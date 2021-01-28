Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE783C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 03:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8356A64DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 03:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhA1D13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 22:27:29 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:10613 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhA1D13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 22:27:29 -0500
IronPort-SDR: m5c5356bsjqz7qwNEQmVHgwIAo/5ayBk9kDgf2NHe8IJOgDCykV0jSPelwqwfDGBcKwiw54dfy
 smyf+oFKgOk8lC3gz2D//5AvVtNeuTxSbA3Yx0X2CtVYTVR3HanreNFfzBEIDmp+NdWP2oQ50j
 kiTWanCPMLkESwVCeROow4jEz+qStXBon6PUi5wmOkEB41qRDKokQvpK8gYU4LaREON7g7LJ9k
 l/SO1AezUiDQMgImqSoM9ARnesJZdERYpnIKJsk3MUHOBvL+VRHVj+TFLgXmAn9h8MuRl6EkKA
 f24=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="47715510"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 27 Jan 2021 19:26:48 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 27 Jan 2021 19:26:42 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 92687)
        id A0597219A2; Wed, 27 Jan 2021 19:26:42 -0800 (PST)
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
Subject: [RFC PATCH v2 1/2] block: bsg: resume platform device before accessing
Date:   Wed, 27 Jan 2021 19:26:37 -0800
Message-Id: <b1db5394aa3f6cf44cd9adb9c8d569caa0c9e4f5.1611803264.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611719814.git.asutoshd@codeaurora.org>
References: <cover.1611719814.git.asutoshd@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It may happen that the underlying device's runtime-pm is
not controlled by block-pm. So it's possible that when
commands are sent to the device, it's suspended and may not
be resumed by blk-pm. Hence explicitly resume the parent
which is the platform device.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
---
 block/bsg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/bsg.c b/block/bsg.c
index d7bae94..e9fc896 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -306,12 +307,15 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 static int bsg_open(struct inode *inode, struct file *file)
 {
 	struct bsg_device *bd;
+	struct bsg_class_device *bcd;
 
 	bd = bsg_get_device(inode, file);
 
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
+	bcd = &bd->queue->bsg_dev;
+	pm_runtime_get_sync(bcd->class_dev->parent);
 	file->private_data = bd;
 	return 0;
 }
@@ -319,8 +323,12 @@ static int bsg_open(struct inode *inode, struct file *file)
 static int bsg_release(struct inode *inode, struct file *file)
 {
 	struct bsg_device *bd = file->private_data;
+	struct bsg_class_device *bcd;
 
 	file->private_data = NULL;
+
+	bcd = &bd->queue->bsg_dev;
+	pm_runtime_put_sync(bcd->class_dev->parent);
 	return bsg_put_device(bd);
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

