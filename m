Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD30FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349951AbhKYPSQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:18:16 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47314 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355934AbhKYPQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:16:15 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1EC0E1FDF1;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1iiLtv7xN/hVkIOxGQ3FKUObDTQbP+0SPmvUzVX3Cw=;
        b=m/n6gI11e2lvuguvgpfYf3ua6LI7/0vZMW8ChGspq1VMQ138wKdKmRv0EhuT/w0HJA9d1P
        QPJFqgSAfBozZksipwoLx8ZLe15C9ryVu9FhCKJCKA2dpYMyPYjhJdFOVueflWq68EOmg5
        vbFnGkN5qlZPIpvnKi+/lWFn4gdkD1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1iiLtv7xN/hVkIOxGQ3FKUObDTQbP+0SPmvUzVX3Cw=;
        b=zmvmWgvJmu/QTW+bPqZ95x4WZ/5tcoKQJH8AJz/mxlcMhzOwhym3GHffZwIFR8lE8ix+x8
        Wx6Kere13TACL1AA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 10D8AA3B8D;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B558951919FC; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/15] aacraid: return valid status from aac_scsi_cmd()
Date:   Thu, 25 Nov 2021 16:10:41 +0100
Message-Id: <20211125151048.103910-9-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

aac_scsi_cmd() is called directly from .queuecommand(), and should
to return valid SCSI_MLQUEUE_XXX status codes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/aachba.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 59f6b7b2a70a..5b309a8beab8 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2775,8 +2775,11 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
 
-	if (fsa_dev_ptr == NULL)
-		return -1;
+	if (fsa_dev_ptr == NULL) {
+		scsicmd->result = DID_NO_CONNECT << 16;
+		goto scsi_done_ret;
+	}
+
 	/*
 	 *	If the bus, id or lun is out of range, return fail
 	 *	Test does not apply to ID 16, the pseudo id for the controller
@@ -2809,7 +2812,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				case READ_CAPACITY:
 				case TEST_UNIT_READY:
 					if (dev->in_reset)
-						return -1;
+						return SCSI_MLQUEUE_DEVICE_BUSY;
 					return _aac_probe_container(scsicmd,
 							aac_probe_container_callback2);
 				default:
@@ -2823,12 +2826,12 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				dev->hba_map[bus][cid].devtype
 					== AAC_DEVTYPE_NATIVE_RAW) {
 				if (dev->in_reset)
-					return -1;
+					return SCSI_MLQUEUE_DEVICE_BUSY;
 				return aac_send_hba_fib(scsicmd);
 			} else if (dev->nondasd_support || expose_physicals ||
 				dev->jbod) {
 				if (dev->in_reset)
-					return -1;
+					return SCSI_MLQUEUE_DEVICE_BUSY;
 				return aac_send_srb_fib(scsicmd);
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16;
@@ -2859,7 +2862,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	case READ_12:
 	case READ_16:
 		if (dev->in_reset)
-			return -1;
+			return SCSI_MLQUEUE_DEVICE_BUSY;
 		return aac_read(scsicmd);
 
 	case WRITE_6:
@@ -2867,7 +2870,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	case WRITE_12:
 	case WRITE_16:
 		if (dev->in_reset)
-			return -1;
+			return SCSI_MLQUEUE_DEVICE_BUSY;
 		return aac_write(scsicmd);
 
 	case SYNCHRONIZE_CACHE:
@@ -2954,7 +2957,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			break;
 		}
 		if (dev->in_reset)
-			return -1;
+			return SCSI_MLQUEUE_DEVICE_BUSY;
 		setinqstr(dev, (void *) (inq_data.inqd_vid), fsa_dev_ptr[cid].type);
 		inq_data.inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
 		scsi_sg_copy_from_buffer(scsicmd, &inq_data, sizeof(inq_data));
-- 
2.29.2

