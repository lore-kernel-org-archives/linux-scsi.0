Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B835C3F2D8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA84524699
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCBDdd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:33:33 -0500
Received: from smtp.infotech.no ([82.134.31.41]:60660 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbgCBDdd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 1 Mar 2020 22:33:33 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 43EA320426C;
        Mon,  2 Mar 2020 04:33:32 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M2bBuefXEYTm; Mon,  2 Mar 2020 04:33:30 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 630BF204248;
        Mon,  2 Mar 2020 04:33:25 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH v8 29/38] sg: add 8 byte SCSI LUN to sg_scsi_id
Date:   Sun,  1 Mar 2020 22:32:40 -0500
Message-Id: <20200302033249.4515-30-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302033249.4515-1-dgilbert@interlog.com>
References: <20200302033249.4515-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The existing ioctl(SG_GET_SCSI_ID) fills a object of type
struct sg_scsi_id whose last field is int unused[2]. Add
an anonymous union with u8 scsi_lun[8] sharing those last
8 bytes. This patch will place the current device's full
LUN in the scsi_lun array using T10's preferred LUN
format (i.e. an array of 8 bytes) when
ioctl(SG_GET_SCSI_ID) is called.

Note that structure already contains a 'lun' field but that
is a 32 bit integer. Users of this upgrade should choose
the scsi_lun array field henceforth but existing code
can remain as it is and will get the same 'lun' value with
the version 3 or version 4 driver.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 8 +++++---
 include/uapi/scsi/sg.h | 5 ++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 017897a1a2a4..a2ddb9b9e63b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1225,7 +1225,7 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 	h4p->din_resid = srp->in_resid;
 	h4p->dout_resid = srp->s_hdr4.out_resid;
 	h4p->usr_ptr = srp->s_hdr4.usr_ptr;
-	h4p->response = (u64)srp->s_hdr4.sbp;
+	h4p->response = (uintptr_t)srp->s_hdr4.sbp;
 	h4p->request_extra = srp->pack_id;
 	if (p) {
 		if (copy_to_user(p, h4p, SZ_SG_IO_V4))
@@ -1837,6 +1837,7 @@ static int
 sg_ctl_scsi_id(struct scsi_device *sdev, struct sg_fd *sfp, void __user *p)
 {
 	struct sg_scsi_id ss_id;
+	struct scsi_lun lun8b;
 
 	SG_LOG(3, sfp, "%s:    SG_GET_SCSI_ID\n", __func__);
 	ss_id.host_no = sdev->host->host_no;
@@ -1846,8 +1847,9 @@ sg_ctl_scsi_id(struct scsi_device *sdev, struct sg_fd *sfp, void __user *p)
 	ss_id.scsi_type = sdev->type;
 	ss_id.h_cmd_per_lun = sdev->host->cmd_per_lun;
 	ss_id.d_queue_depth = sdev->queue_depth;
-	ss_id.unused[0] = 0;
-	ss_id.unused[1] = 0;
+	int_to_scsilun(sdev->lun, &lun8b);
+	/* ss_id.scsi_lun is in an anonymous union with 'int unused[2]' */
+	memcpy(ss_id.scsi_lun, lun8b.scsi_lun, 8);
 	if (copy_to_user(p, &ss_id, sizeof(struct sg_scsi_id)))
 		return -EFAULT;
 	return 0;
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 51b86d20a7a5..182001023360 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -136,7 +136,10 @@ typedef struct sg_scsi_id {
 	int scsi_type;	/* TYPE_... defined in scsi/scsi.h */
 	short h_cmd_per_lun;/* host (adapter) maximum commands per lun */
 	short d_queue_depth;/* device (or adapter) maximum queue length */
-	int unused[2];
+	union {
+		int unused[2];  /* as per version 3 driver */
+		__u8 scsi_lun[8];  /* full 8 byte SCSI LUN [in v4 driver] */
+	};
 } sg_scsi_id_t;
 
 /* For backward compatibility v4 driver yields at most SG_MAX_QUEUE of these */
-- 
2.25.1

