Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5583C43461
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEB5F610A0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhECPEr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 11:04:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:40892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhECPEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 11:04:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9E070B1BF;
        Mon,  3 May 2021 15:03:44 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/18] aacraid: store target id in host_scribble
Date:   Mon,  3 May 2021 17:03:31 +0200
Message-Id: <20210503150333.130310-17-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210503150333.130310-1-hare@suse.de>
References: <20210503150333.130310-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The probe_container mechanism requires a target id to be present,
even if the device itself isn't present (yet).
As we're now allocating internal commands the target id of the
device is immutable, so store the requested target id in the
host_scribble field.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/aachba.c | 53 +++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index f1f62b5da8b7..ef59303db9b9 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -609,9 +609,11 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 
 static int aac_probe_container_callback2(struct scsi_cmnd * scsicmd)
 {
-	struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
+	struct aac_dev *dev = (struct aac_dev *)(scsicmd->device->host->hostdata);
+	struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
 
-	if ((fsa_dev_ptr[scmd_id(scsicmd)].valid & 1))
+	if (scmd_id(scsicmd) < dev->maximum_num_containers &&
+	    (fsa_dev_ptr[scmd_id(scsicmd)].valid & 1))
 		return aac_scsi_cmd(scsicmd);
 
 	scsicmd->result = DID_NO_CONNECT << 16;
@@ -624,6 +626,7 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 	struct fsa_dev_info *fsa_dev_ptr;
 	int (*callback)(struct scsi_cmnd *);
 	struct scsi_cmnd * scsicmd = (struct scsi_cmnd *)context;
+	int cid = scmd_id(scsicmd);
 	int i;
 
 
@@ -631,12 +634,15 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 		return;
 
 	scsicmd->SCp.Status = 0;
+	if (scsicmd->host_scribble)
+		cid = *(int *)scsicmd->host_scribble;
+
 	fsa_dev_ptr = fibptr->dev->fsa_dev;
-	if (fsa_dev_ptr) {
+	if (fsa_dev_ptr && cid < fibptr->dev->maximum_num_containers) {
 		struct aac_mount * dresp = (struct aac_mount *) fib_data(fibptr);
 		__le32 sup_options2;
 
-		fsa_dev_ptr += scmd_id(scsicmd);
+		fsa_dev_ptr += cid;
 		sup_options2 =
 			fibptr->dev->supplement_adapter_info.supported_options2;
 
@@ -671,7 +677,6 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 		scsicmd->SCp.Status = le32_to_cpu(dresp->count);
 	}
 	aac_fib_complete(fibptr);
-	aac_fib_free(fibptr);
 	callback = (int (*)(struct scsi_cmnd *))(scsicmd->SCp.ptr);
 	scsicmd->SCp.ptr = NULL;
 	(*callback)(scsicmd);
@@ -683,6 +688,7 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	struct scsi_cmnd * scsicmd;
 	struct aac_mount * dresp;
 	struct aac_query_mount *dinfo;
+	int cid;
 	int status;
 
 	dresp = (struct aac_mount *) fib_data(fibptr);
@@ -695,10 +701,15 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 		}
 	}
 	scsicmd = (struct scsi_cmnd *) context;
-
 	if (!aac_valid_context(scsicmd, fibptr))
 		return;
-
+	cid = scmd_id(scsicmd);
+	if (scsicmd->host_scribble)
+		cid = *(int *)scsicmd->host_scribble;
+	if (cid >= fibptr->dev->maximum_num_containers) {
+		_aac_probe_container2(context, fibptr);
+		return;
+	}
 	aac_fib_init(fibptr);
 
 	dinfo = (struct aac_query_mount *)fib_data(fibptr);
@@ -709,7 +720,7 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	else
 		dinfo->command = cpu_to_le32(VM_NameServe64);
 
-	dinfo->count = cpu_to_le32(scmd_id(scsicmd));
+	dinfo->count = cpu_to_le32(cid);
 	dinfo->type = cpu_to_le32(FT_FILESYS);
 	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
@@ -732,10 +743,20 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 
 static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(struct scsi_cmnd *))
 {
+	struct aac_dev * dev;
 	struct fib * fibptr;
 	int status = -ENOMEM;
+	int cid = scmd_id(scsicmd);
 
-	if ((fibptr = aac_fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) {
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+	if (scsicmd->host_scribble) {
+		cid = *(int *)scsicmd->host_scribble;
+		if (cid > dev->maximum_num_containers) {
+			status = -ENODEV;
+			goto out_status;
+		}
+	}
+	if ((fibptr = aac_fib_alloc(dev))) {
 		struct aac_query_mount *dinfo;
 
 		aac_fib_init(fibptr);
@@ -748,7 +769,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 		else
 			dinfo->command = cpu_to_le32(VM_NameServe);
 
-		dinfo->count = cpu_to_le32(scmd_id(scsicmd));
+		dinfo->count = cpu_to_le32(cid);
 		dinfo->type = cpu_to_le32(FT_FILESYS);
 		scsicmd->SCp.ptr = (char *)callback;
 		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
@@ -772,10 +793,11 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 			aac_fib_free(fibptr);
 		}
 	}
+out_status:
 	if (status < 0) {
-		struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
-		if (fsa_dev_ptr) {
-			fsa_dev_ptr += scmd_id(scsicmd);
+		struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
+		if (fsa_dev_ptr && cid < dev->maximum_num_containers) {
+			fsa_dev_ptr += cid;
 			if ((fsa_dev_ptr->valid & 1) == 0) {
 				fsa_dev_ptr->valid = 0;
 				return (*callback)(scsicmd);
@@ -794,7 +816,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
  */
 static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
 {
-	scsicmd->device = NULL;
+	scsicmd->host_scribble = NULL;
 	return 0;
 }
 
@@ -815,6 +837,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 		return -ENOMEM;
 	}
 	scsicmd->scsi_done = aac_probe_container_scsi_done;
+	scsicmd->host_scribble = (unsigned char *)&cid;
 
 	scsicmd->device = scsidev;
 	scsidev->sdev_state = 0;
@@ -822,7 +845,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 	scsidev->host = dev->scsi_host_ptr;
 
 	if (_aac_probe_container(scsicmd, aac_probe_container_callback1) == 0)
-		while (scsicmd->device == scsidev)
+		while (scsicmd->host_scribble == (unsigned char *)&cid)
 			schedule();
 	kfree(scsidev);
 	status = scsicmd->SCp.Status;
-- 
2.29.2

