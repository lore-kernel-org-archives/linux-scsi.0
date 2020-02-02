Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6F3C3524B
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0382220838
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BvDdVHUM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgBBKrZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 05:47:25 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8763 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgBBKrX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 05:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580640443; x=1612176443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=L4nAHFKokWMKbsmdb2ayPfvOB5mMFhDgRN9aEfo+7Pk=;
  b=BvDdVHUMrTolEoYuxCjFwtBuAIt/kqNjt0mcIQ1NTet3epRQ0xli1lcV
   0LWxqshpn91ycBuWu2/ayl+/zJCFRjT3MFP7p+NSs+n5FcqkIPaVUOO+C
   hK3xDpTJyKhp/5lnkTwruzjvrD7PKaNpnkWTlDK1p2Fgq94wtH1YZMqxs
   TwFroUwTceI5q3/FT510Q6IttaqmImICGFBOwcOFNGfKBmP7B2UYNRwD4
   ykHJKuULz1+B26WzQC4ywkbt2tjj6Mjcj/+V83OTntYbx4BPBcIH9PNOr
   gIwZdq+3y+jedvOLhC4YSysrTx+dr/MguSpvr5/rskhsytZeXVMVpkFKQ
   w==;
IronPort-SDR: qDSOw3JcaXxn21mJEceTM+MjOfYbvY7bLZUXvuBN/SH5qW7XZzS0OBxZVNh28N2iFZpWjc5sgb
 C6l3ngAxwyDUltg8z0KqdhlsNsNkBp8ZYVP9q9zOqNMg+lKcHHS7HcOO1oFlyA/yyY+uuzjtqt
 uV0OitUImLIk4UiXrX4JFHUcmT4m8+H+qxJjZR9UBnAtg3AGEC5A5bL/NYBJwzhrJU/dej+Ff5
 hUy3dUkJ0vv9mTmzt+3w1hz3L0IfIS+lokGl0yK1G0Zr/9AzrYV7ufExOMfdaOeDf5Ctwf3S2i
 58o=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="128925975"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 18:47:23 +0800
IronPort-SDR: TlAOPE+RWUw3Uh8SbQhreOBfF8GKvc3K8Di7cMB6tZVeLQClNPzVhV2KNoHup71vOfB5C56H0y
 +npCWMKHXi37THqu+gIzHWlOzSAz725WB5jduv2oZP4V673yPk4evRtas3RrhtJ4hxbfsMeEZj
 FpqkjUUAkn+PVvCNu5lxENmSJn794ZyInycam0ft7pZS6yboUuEvdFnN6foudmDF5o94JvmwKw
 nWxqffyb1fumgJWUk9hmY8peBczfraTbIOkBpTGDRkHPKOpVJwfSKs23KDYpPwA32XHXLOAiZm
 6RGPVDsfmCrxljYAbdwfs1uY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2020 02:40:29 -0800
IronPort-SDR: Hc51kDLCNGUTtubZS79q+bfxzteXY0gCd4WUdkyFsyegZbNfIKWWcoYpb7ehaZCxM4jeAonfet
 3Ra6faP15GbG6QYH5dHb8g575pUGmZ/bDY9vPU9rLVXCwsbF+vTqynjxVVPbshNt/x3SzA1Lvo
 qmJ53tdFOjPW4FZKbkZHBudMbGIIMCO7izXStMLkC4IzHDP1Nd+Xy6wyYAhBAOIo38uqrAuAnF
 QDU69SlSaAbmwcOVlviW8XELM1H+oOc2KJJ8JsubdV081KvzsBUIuP4xyETzEvHOCtQCMpfJzI
 P+s=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2020 02:47:20 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Avi Shchislowski <avi.shchislowski@swdc.com>,
        Uri Yanai <uri.yanai@wdc.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>
Subject: [PATCH 5/5] scsi: ufs: temperature atrributes add to ufs_sysfs
Date:   Sun,  2 Feb 2020 12:46:59 +0200
Message-Id: <1580640419-6703-6-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Avi Shchislowski <avi.shchislowski@swdc.com>

Signed-off-by: Uri Yanai <uri.yanai@wdc.com>
Signed-off-by: Avi Shchislowski <avi.shchislowski@wdc.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index dbdf8b0..180f4db 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -667,6 +667,9 @@ static DEVICE_ATTR_RO(_name)
 UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
 UFS_ATTRIBUTE(psa_state, _PSA_STATE);
 UFS_ATTRIBUTE(psa_data_size, _PSA_DATA_SIZE);
+UFS_ATTRIBUTE(rough_temp, _ROUGH_TEMP);
+UFS_ATTRIBUTE(too_high_temp, _TOO_HIGH_TEMP);
+UFS_ATTRIBUTE(too_low_temp, _TOO_LOW_TEMP);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
@@ -685,6 +688,9 @@ static DEVICE_ATTR_RO(_name)
 	&dev_attr_ffu_status.attr,
 	&dev_attr_psa_state.attr,
 	&dev_attr_psa_data_size.attr,
+	&dev_attr_rough_temp.attr,
+	&dev_attr_too_high_temp.attr,
+	&dev_attr_too_low_temp.attr,
 	NULL,
 };
 
-- 
1.9.1

