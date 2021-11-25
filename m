Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58431C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350808AbhKYPSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:18:17 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47318 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355945AbhKYPQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:16:15 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2A7001FDF4;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Y4QC8NdLscdxdXjELaPL6sQtF3cFb+QoZPqBUKZt58=;
        b=mmxOBxrm+U+tbA7CmsvWbjVYF4F+8z5LkryZCrzoiae60hvp8EzpCOCf4O97mbxpi1KziK
        1ygKcWkbSHMYgTXwlFRoV/LnP1E4yZkGMTcL+Zta9JYrXSoRBpfNLC/YxO2pikZtMqD1tM
        pcW74aLL0UDWbf2lWy9vT8TDdXvZXao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Y4QC8NdLscdxdXjELaPL6sQtF3cFb+QoZPqBUKZt58=;
        b=1CtTMZ4URue2CAtpdd5x8sQB6znkGcaKSf4b16X0SZPQowbCOaCvOfMAZbtfnT31gRrLZZ
        L4COjaE/ODdqj0BA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 228BBA3B97;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C31965191A04; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/15] aacraid: fsa_dev pointer is always valid
Date:   Thu, 25 Nov 2021 16:10:45 +0100
Message-Id: <20211125151048.103910-13-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All call sites to aac_probe_container() already check for a valid
fsa_dev pointer, so we don't need to do that during probing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/aachba.c | 79 ++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 2cc9f79c75ff..580d74b2ee14 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -636,49 +636,44 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 	int (*callback)(struct scsi_cmnd *);
 	struct scsi_cmnd * scsicmd = (struct scsi_cmnd *)context;
 	int i;
+	struct aac_mount * dresp = (struct aac_mount *) fib_data(fibptr);
+	__le32 sup_options2;
 
 
 	if (!aac_valid_context(scsicmd, fibptr))
 		return;
 
-	fsa_dev_ptr = fibptr->dev->fsa_dev;
-	if (fsa_dev_ptr) {
-		struct aac_mount * dresp = (struct aac_mount *) fib_data(fibptr);
-		__le32 sup_options2;
+	fsa_dev_ptr = &fibptr->dev->fsa_dev[fibptr->cid];
+	sup_options2 = fibptr->dev->supplement_adapter_info.supported_options2;
 
-		fsa_dev_ptr += fibptr->cid;
-		sup_options2 =
-			fibptr->dev->supplement_adapter_info.supported_options2;
-
-		if ((le32_to_cpu(dresp->status) == ST_OK) &&
-		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
-		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
-			if (!(sup_options2 & AAC_OPTION_VARIABLE_BLOCK_SIZE)) {
-				dresp->mnt[0].fileinfo.bdevinfo.block_size = 0x200;
-				fsa_dev_ptr->block_size = 0x200;
-			} else {
-				fsa_dev_ptr->block_size =
-					le32_to_cpu(dresp->mnt[0].fileinfo.bdevinfo.block_size);
-			}
-			for (i = 0; i < 16; i++)
-				fsa_dev_ptr->identifier[i] =
-					dresp->mnt[0].fileinfo.bdevinfo
-								.identifier[i];
-			fsa_dev_ptr->valid = 1;
-			/* sense_key holds the current state of the spin-up */
-			if (dresp->mnt[0].state & cpu_to_le32(FSCS_NOT_READY))
-				fsa_dev_ptr->sense_data.sense_key = NOT_READY;
-			else if (fsa_dev_ptr->sense_data.sense_key == NOT_READY)
-				fsa_dev_ptr->sense_data.sense_key = NO_SENSE;
-			fsa_dev_ptr->type = le32_to_cpu(dresp->mnt[0].vol);
-			fsa_dev_ptr->size
-			  = ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
-			    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32);
-			fsa_dev_ptr->ro = ((le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY) != 0);
+	if ((le32_to_cpu(dresp->status) == ST_OK) &&
+	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
+	    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
+		if (!(sup_options2 & AAC_OPTION_VARIABLE_BLOCK_SIZE)) {
+			dresp->mnt[0].fileinfo.bdevinfo.block_size = 0x200;
+			fsa_dev_ptr->block_size = 0x200;
+		} else {
+			fsa_dev_ptr->block_size =
+				le32_to_cpu(dresp->mnt[0].fileinfo.bdevinfo.block_size);
 		}
-		if ((fsa_dev_ptr->valid & 1) == 0)
-			fsa_dev_ptr->valid = 0;
+		for (i = 0; i < 16; i++)
+			fsa_dev_ptr->identifier[i] =
+				dresp->mnt[0].fileinfo.bdevinfo.identifier[i];
+		fsa_dev_ptr->valid = 1;
+		/* sense_key holds the current state of the spin-up */
+		if (dresp->mnt[0].state & cpu_to_le32(FSCS_NOT_READY))
+			fsa_dev_ptr->sense_data.sense_key = NOT_READY;
+		else if (fsa_dev_ptr->sense_data.sense_key == NOT_READY)
+			fsa_dev_ptr->sense_data.sense_key = NO_SENSE;
+		fsa_dev_ptr->type = le32_to_cpu(dresp->mnt[0].vol);
+		fsa_dev_ptr->size
+			= ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
+			(((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32);
+		fsa_dev_ptr->ro = ((le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY) != 0);
 	}
+	if ((fsa_dev_ptr->valid & 1) == 0)
+		fsa_dev_ptr->valid = 0;
+
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
 	callback = (int (*)(struct scsi_cmnd *))(scsicmd->SCp.ptr);
@@ -742,10 +737,12 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 static int _aac_probe_container(struct scsi_cmnd * scsicmd, unsigned int cid,
 				int (*callback)(struct scsi_cmnd *))
 {
+	struct aac_dev * dev =
+		(struct aac_dev *)scsicmd->device->host->hostdata;
 	struct fib * fibptr;
 	int status = -ENOMEM;
 
-	if ((fibptr = aac_fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) {
+	if ((fibptr = aac_fib_alloc(dev))) {
 		struct aac_query_mount *dinfo;
 
 		aac_fib_init(fibptr);
@@ -784,13 +781,9 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, unsigned int cid,
 		}
 	}
 	if (status < 0) {
-		struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
-		if (fsa_dev_ptr) {
-			fsa_dev_ptr += cid;
-			if ((fsa_dev_ptr->valid & 1) == 0) {
-				fsa_dev_ptr->valid = 0;
-				return (*callback)(scsicmd);
-			}
+		if ((dev->fsa_dev[cid].valid & 1) == 0) {
+			dev->fsa_dev[cid].valid = 0;
+			return (*callback)(scsicmd);
 		}
 	}
 	return status;
-- 
2.29.2

