Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAF5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355972AbhKYPQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:18 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35606 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353315AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2040A21B36;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6UI9GunQsBtnUmKnGQMS+6Dg+8spqijiZfuVVc7sY/w=;
        b=12rHIiCha+oplSCdK5CI2Zs0bZpVkkForrXqkF5i4c0jC1SMaHfvGm9huDAgPxbpA0O3gK
        E/FHNnwOfmxynXTuu/nC+VvGqHSh6FLOUiTPzNw1KA/t5fjC81ISFPMultBIHRqjGpbzf8
        GgVCDiLjMRQ3izNXxtM1tHhY5tXYkOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6UI9GunQsBtnUmKnGQMS+6Dg+8spqijiZfuVVc7sY/w=;
        b=YMw6rS6G7wbWSk8+FPHB9xH9jnbncuQB/RBzcurSGV9GFEDOUFT747zzNC50Zjt7JklVpZ
        CuNmnQqehCkdUMCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1800FA3B93;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BFC485191A02; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/15] aacraid: move container ID into struct fib
Date:   Thu, 25 Nov 2021 16:10:44 +0100
Message-Id: <20211125151048.103910-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new field 'cid' to struct fib to hold the container ID this
I/O is destined for.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/aachba.c  | 19 +++++++++++--------
 drivers/scsi/aacraid/aacraid.h |  6 +++++-
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 289c4968a92e..2cc9f79c75ff 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -646,7 +646,7 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 		struct aac_mount * dresp = (struct aac_mount *) fib_data(fibptr);
 		__le32 sup_options2;
 
-		fsa_dev_ptr += scmd_id(scsicmd);
+		fsa_dev_ptr += fibptr->cid;
 		sup_options2 =
 			fibptr->dev->supplement_adapter_info.supported_options2;
 
@@ -718,7 +718,7 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	else
 		dinfo->command = cpu_to_le32(VM_NameServe64);
 
-	dinfo->count = cpu_to_le32(scmd_id(scsicmd));
+	dinfo->count = cpu_to_le32(fibptr->cid);
 	dinfo->type = cpu_to_le32(FT_FILESYS);
 	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
@@ -739,7 +739,8 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	}
 }
 
-static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(struct scsi_cmnd *))
+static int _aac_probe_container(struct scsi_cmnd * scsicmd, unsigned int cid,
+				int (*callback)(struct scsi_cmnd *))
 {
 	struct fib * fibptr;
 	int status = -ENOMEM;
@@ -748,6 +749,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 		struct aac_query_mount *dinfo;
 
 		aac_fib_init(fibptr);
+		fibptr->cid = cid;
 
 		dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
@@ -757,7 +759,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 		else
 			dinfo->command = cpu_to_le32(VM_NameServe);
 
-		dinfo->count = cpu_to_le32(scmd_id(scsicmd));
+		dinfo->count = cpu_to_le32(fibptr->cid);
 		dinfo->type = cpu_to_le32(FT_FILESYS);
 		scsicmd->SCp.ptr = (char *)callback;
 		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
@@ -784,7 +786,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 	if (status < 0) {
 		struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
 		if (fsa_dev_ptr) {
-			fsa_dev_ptr += scmd_id(scsicmd);
+			fsa_dev_ptr += cid;
 			if ((fsa_dev_ptr->valid & 1) == 0) {
 				fsa_dev_ptr->valid = 0;
 				return (*callback)(scsicmd);
@@ -812,7 +814,7 @@ static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
 	aac_probe_container_callback1(scsi_cmnd);
 }
 
-int aac_probe_container(struct aac_dev *dev, int cid)
+int aac_probe_container(struct aac_dev *dev, unsigned int cid)
 {
 	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd), GFP_KERNEL);
 	struct scsi_device *scsidev = kzalloc(sizeof(*scsidev), GFP_KERNEL);
@@ -829,7 +831,8 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 	scsidev->id = cid;
 	scsidev->host = dev->scsi_host_ptr;
 
-	status = _aac_probe_container(scsicmd, aac_probe_container_callback1);
+	status = _aac_probe_container(scsicmd, cid,
+				      aac_probe_container_callback1);
 	if (status == 0)
 		while (scsicmd->device == scsidev)
 			schedule();
@@ -2811,7 +2814,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				case TEST_UNIT_READY:
 					if (dev->in_reset)
 						return SCSI_MLQUEUE_DEVICE_BUSY;
-					return _aac_probe_container(scsicmd,
+					return _aac_probe_container(scsicmd, cid,
 							aac_probe_container_callback2);
 				default:
 					break;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3733df77bc65..90705c4f8ec8 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1298,6 +1298,10 @@ struct fib {
 	 *	The Adapter that this I/O is destined for.
 	 */
 	struct aac_dev		*dev;
+	/*
+	 *	The Container that this I/O is destined for.
+	 */
+	u32			cid;
 	/*
 	 *	This is the event the sendfib routine will wait on if the
 	 *	caller did not pass one and this is synch io.
@@ -2734,7 +2738,7 @@ int aac_fib_adapter_complete(struct fib * fibptr, unsigned short size);
 struct aac_driver_ident* aac_get_driver_ident(int devtype);
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
-int aac_probe_container(struct aac_dev *dev, int cid);
+int aac_probe_container(struct aac_dev *dev, unsigned int cid);
 int _aac_rx_init(struct aac_dev *dev);
 int aac_rx_select_comm(struct aac_dev *dev, int comm);
 int aac_rx_deliver_producer(struct fib * fib);
-- 
2.29.2

