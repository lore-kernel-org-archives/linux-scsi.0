Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070F0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 08:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A4D60F39
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 08:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhKEIRm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 04:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhKEIRl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 04:17:41 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88865C061714;
        Fri,  5 Nov 2021 01:15:02 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id p138so1606357qke.10;
        Fri, 05 Nov 2021 01:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rPfvQBk9AhoT2kc937nnSOy2TXOgDFuQytW4y8jVxFc=;
        b=kiiZwYVYwAz1LQX78zsD+NDbdA/4OsZa8umJ+ZjWQQPFqK2mxzCYyxKmOrPKrO26Bz
         ZyF3AA/WiVXv995qeoIy6t3nBBJ+HFbh9FJcZcNjfjVtjgD/5N3+7cTcVumy38UGCek0
         azZdYX5fxn72sDRF/JDnfTGaGmnu31sjFnX22hm4EeUetrxtmP9vvkwmmcGQnyoZKCdU
         YDHWkt+2WXMybe3d8knU3cNeGmU2ITccolBtHhHvZwxPWKanxY56N1uCb3yXNChKol+X
         9nsrxSgLE1Okrh6bNkWbxMdoiVQ2z6EtGFrxPXO/rIsk7PqdWM9lIzCMxWMKF/evysf+
         CrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rPfvQBk9AhoT2kc937nnSOy2TXOgDFuQytW4y8jVxFc=;
        b=nlG9MN0RD+rcslFfwTkBWfdEmDddaO0kUoxw4BrRzCBADhZsBbPGbmG0yPkHyILfFZ
         bjL2lI58YuVpd0RG1GeLEZtj8lLVIC3tHwuomfrMm/FTrIarr4+Zfby7unIRZfwDn+wH
         IJglOu6+5raPWUrfu+RTVWU/MbZ8eul+xQOmtfREbOSpWYWRNCJX5DL+gKoYRUQxIEaJ
         +7LFNGh1E4xc0nlgkwdmQCROOR9KvIuKpe/MCy124bj3gvNRPUzS+da/w9U2Z5MGElb3
         59aMi0IjWhONPwX5E4Z9DLCrxitPet0F38OPgOlCeHhgzhFjizz//DzLTNNU2CQeGFjj
         Jlww==
X-Gm-Message-State: AOAM532uFnJJks1kYRPeFwO5uP6mlRejs/nx1zKteSU7XWbRZCsuvEv5
        krlbfY0b0V7kLJMGxSuajPs=
X-Google-Smtp-Source: ABdhPJzioDRSIy3hwQsqdvBFcBgX30wR0E4KakSfdJdGREKIjOq76xX+xfMX3AKidBj+gf6+JPHIWw==
X-Received: by 2002:a05:620a:410b:: with SMTP id j11mr24302464qko.498.1636100101808;
        Fri, 05 Nov 2021 01:15:01 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t11sm5016276qkm.92.2021.11.05.01.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 01:15:01 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     kartilak@cisco.com
Cc:     sebaddel@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: snic: Replace snprintf in show functions with   sysfs_emit
Date:   Fri,  5 Nov 2021 08:14:54 +0000
Message-Id: <20211105081454.76950-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING use scnprintf or sprintf

Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---
 drivers/scsi/snic/snic_attrs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_attrs.c
index dc03ce1ec909..cb501be3e9ec 100644
--- a/drivers/scsi/snic/snic_attrs.c
+++ b/drivers/scsi/snic/snic_attrs.c
@@ -27,7 +27,7 @@ snic_show_sym_name(struct device *dev,
 {
 	struct snic *snic = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", snic->name);
+	return sysfs_emit(buf, "%s\n", snic->name);
 }
 
 static ssize_t
@@ -37,7 +37,7 @@ snic_show_state(struct device *dev,
 {
 	struct snic *snic = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			snic_state_str[snic_get_state(snic)]);
 }
 
@@ -46,7 +46,7 @@ snic_show_drv_version(struct device *dev,
 		      struct device_attribute *attr,
 		      char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", SNIC_DRV_VERSION);
+	return sysfs_emit(buf, "%s\n", SNIC_DRV_VERSION);
 }
 
 static ssize_t
@@ -59,7 +59,7 @@ snic_show_link_state(struct device *dev,
 	if (snic->config.xpt_type == SNIC_DAS)
 		snic->link_status = svnic_dev_link_status(snic->vdev);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			(snic->link_status) ? "Link Up" : "Link Down");
 }
 
-- 
2.25.1

