Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D42CA9EB7
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9C8A2070B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfJUJxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 05:53:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:48840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727885AbfJUJxc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 05:53:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D75E8BABB;
        Mon, 21 Oct 2019 09:53:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/24] sg: use SAM status definitions and avoid using masked_status
Date:   Mon, 21 Oct 2019 11:53:06 +0200
Message-Id: <20191021095322.137969-9-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191021095322.137969-1-hare@suse.de>
References: <20191021095322.137969-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard SAM status definitions and avoid using masked status
values.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sg.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index e88fb3daebcc..60ff388d04b9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -503,7 +503,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	old_hdr->target_status = hp->masked_status;
 	old_hdr->host_status = hp->host_status;
 	old_hdr->driver_status = hp->driver_status;
-	if ((CHECK_CONDITION & hp->masked_status) ||
+	if ((SAM_STAT_CHECK_CONDITION & hp->status) ||
 	    (DRIVER_SENSE & hp->driver_status))
 		memcpy(old_hdr->sense_buffer, srp->sense_b,
 		       sizeof (old_hdr->sense_buffer));
@@ -529,7 +529,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 		break;
 	case DID_ERROR:
 		old_hdr->result = (srp->sense_b[0] == 0 && 
-				  hp->masked_status == GOOD) ? 0 : EIO;
+				  hp->status == SAM_STAT_GOOD) ? 0 : EIO;
 		break;
 	default:
 		old_hdr->result = EIO;
@@ -574,7 +574,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 	}
 	hp->sb_len_wr = 0;
 	if ((hp->mx_sb_len > 0) && hp->sbp) {
-		if ((CHECK_CONDITION & hp->masked_status) ||
+		if ((SAM_STAT_CHECK_CONDITION & hp->status) ||
 		    (DRIVER_SENSE & hp->driver_status)) {
 			int sb_len = SCSI_SENSE_BUFFERSIZE;
 			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
@@ -587,7 +587,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 			hp->sb_len_wr = len;
 		}
 	}
-	if (hp->masked_status || hp->host_status || hp->driver_status)
+	if (hp->status || hp->host_status || hp->driver_status)
 		hp->info |= SG_INFO_CHECK;
 	if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
 		err = -EFAULT;
@@ -873,7 +873,7 @@ sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
 			break;
 		rinfo[val].req_state = srp->done + 1;
 		rinfo[val].problem =
-			srp->header.masked_status &
+			srp->header.status &
 			srp->header.host_status &
 			srp->header.driver_status;
 		if (srp->done)
@@ -1355,8 +1355,8 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		srp->header.host_status = host_byte(result);
 		srp->header.driver_status = driver_byte(result);
 		if ((sdp->sgdebug > 0) &&
-		    ((CHECK_CONDITION == srp->header.masked_status) ||
-		     (COMMAND_TERMINATED == srp->header.masked_status)))
+		    ((SAM_STAT_CHECK_CONDITION == srp->header.status) ||
+		     (SAM_STAT_COMMAND_TERMINATED == srp->header.status)))
 			__scsi_print_sense(sdp->device, __func__, sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
-- 
2.16.4

