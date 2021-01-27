Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93505C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 472102071C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238455AbhA0EXo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:23:44 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:46886 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbhA0EJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:09:18 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2021 23:09:10 EST
IronPort-SDR: zMp0UeaATN8dAmwGUwJ/f7vfSKVLz9SPYEYrELP5OMt/VgAxzU5cksfjlratlBdfK0pJQ3z2rC
 x2a3ye/2oVbx5tzxjyyJZkznOGOcthLpltY27o/jPNQ6FF+zI8jL/bahGwA8PyJKtqfyXJ3Xj9
 9R2xKP3PwznzerwKspmpMZ2O+N5CHBLIIdOny9+2atBXocI4fumPPj1NddbDvfw6vMw8uwIapO
 z0ZiW9vpyisAPT+sN2TJG3kuIFowA56cKA50d3K4EESWGnsgLVTMoErSwp5WQShPhJJs5oMAK6
 C+o=
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="47711299"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 26 Jan 2021 20:00:27 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 26 Jan 2021 20:00:26 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 92687)
        id 6068421903; Tue, 26 Jan 2021 20:00:26 -0800 (PST)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     cang@codeaurora.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, stern@rowland.harvard.edu,
        "Bao D . Nguyen" <nguyenb@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org (open list:BLOCK LAYER),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v1 1/2] block: bsg: resume scsi device before accessing
Date:   Tue, 26 Jan 2021 20:00:22 -0800
Message-Id: <c04a11a590628c2497cef113b0dfea781de90416.1611719814.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611719814.git.asutoshd@codeaurora.org>
References: <cover.1611719814.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1611719814.git.asutoshd@codeaurora.org>
References: <cover.1611719814.git.asutoshd@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Resumes the scsi device before accessing it.

Change-Id: I2929af60f2a92c89704a582fcdb285d35b429fde
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
---
 block/bsg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/bsg.c b/block/bsg.c
index d7bae94..f4c197f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -306,12 +306,16 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 static int bsg_open(struct inode *inode, struct file *file)
 {
 	struct bsg_device *bd;
+	struct scsi_device *sd;
 
 	bd = bsg_get_device(inode, file);
 
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
+	sd = (struct scsi_device *) bd->queue->queuedata;
+	if (scsi_autopm_get_device(sd))
+		return -EIO;
 	file->private_data = bd;
 	return 0;
 }
@@ -319,8 +323,12 @@ static int bsg_open(struct inode *inode, struct file *file)
 static int bsg_release(struct inode *inode, struct file *file)
 {
 	struct bsg_device *bd = file->private_data;
+	struct scsi_device *sd;
 
 	file->private_data = NULL;
+	sd = (struct scsi_device *) bd->queue->queuedata;
+	scsi_autopm_put_device(sd);
+
 	return bsg_put_device(bd);
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

