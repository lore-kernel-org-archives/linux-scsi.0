Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D74C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Aug 2021 03:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 676A760FE6
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Aug 2021 03:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhHUD4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 23:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhHUD4j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 23:56:39 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C37C061575;
        Fri, 20 Aug 2021 20:56:00 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id m21so12969741qkm.13;
        Fri, 20 Aug 2021 20:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LKoKG/sND2csb1UdQ5fsSYSSpFb28MbuaJ6BEIHj7yQ=;
        b=njEFK8tzexXCnZXbDhdfPBKiQAAfAhPLhvAy6Uv+JZEtPhTVwF+4Z24/URYYlRhnpI
         +h2WcIKpHU79KQZnk97vNdi04KLdclyvyD88/LdKyg+YB3kg5GNHojwoY3tLS1vpQfMY
         ijZJd4ZrDLP2bvZHZawilRQq4kpPLs/oENiU6+FslJKNRtHpqfKRU9ertXBxRAwF3CRg
         tQSwfjg3jj2YR9ZYLggK8Bpu+45gXpNXj5wVVltjUfceXTsoOOYSNke6dU1QiPMHuI5R
         I90da4kZu8hL8Uvrol8IxT7BB5+M9vHLm5q85xyqTsRjSnEzVk4tYA9JDwdZNmm9va+0
         Cylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LKoKG/sND2csb1UdQ5fsSYSSpFb28MbuaJ6BEIHj7yQ=;
        b=CvGig2QaNjr20IFcbvBqyQeSfpDMuRkPOEge87fJoVE+JnoUM3bUwlHnsQwm2lfTvv
         13OdyaklhhtrWBD/fpmtdIDLdAicYAZttCvTr6z9q0jpSIkfpXNYP/iV7h67rpnPTF4j
         ogS5ITwIXoYtdU5dUBY72aY5luvlcNy00Fb3AqTRdg59XqDcwXD/arJs4/zb/Ps1PedM
         J+FGL8h5HHTqhmVX3FT0dllqw7T2vpmezTxa+RKeh49o5qaG4FtiHWM/lVSe1HfTqolz
         QXSNQoge4JQiSEzQHJHlNG6nuCmVBJpuiRvF1fE6o2SxTuyRBIB7BqiUfR/ry9w2yLum
         4Vkg==
X-Gm-Message-State: AOAM533a4/38QPOPFiVl5ydsR11+OV/sHEcQbHoUI50FdasRCG8G3IUp
        uD1JZ9SsUrE5bKopgctA1p4=
X-Google-Smtp-Source: ABdhPJwHz+yvtnz9viuBaUmmHb/HJaXFLlUyIms0uGAtUgJTk/yhQyC/fzRn8z+TJHSOmvdTGGVJ0Q==
X-Received: by 2002:a05:620a:145c:: with SMTP id i28mr11495077qkl.118.1629518159770;
        Fri, 20 Aug 2021 20:55:59 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z21sm845699qts.27.2021.08.20.20.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 20:55:59 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     Karan Tilak Kumar <kartilak@cisco.com>
Cc:     Sesidhar Baddela <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] scsi:snic_attrs:Convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Fri, 20 Aug 2021 20:55:52 -0700
Message-Id: <20210821035553.28419-1-jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

Fix the following coccicheck warning:
./drivers/scsi/snic/snic_attrs.c:49: 8-16: WARNING:  use scnprintf or sprintf
./drivers/scsi/snic/snic_attrs.c:62: 8-16: WARNING:  use scnprintf or sprintf
./drivers/scsi/snic/snic_attrs.c:40: 8-16: WARNING:  use scnprintf or sprintf
./drivers/scsi/snic/snic_attrs.c:30: 8-16: WARNING:  use scnprintf or sprintf

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 drivers/scsi/snic/snic_attrs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_attrs.c
index 32d5d55..0d41a00 100644
--- a/drivers/scsi/snic/snic_attrs.c
+++ b/drivers/scsi/snic/snic_attrs.c
@@ -27,7 +27,7 @@
 {
 	struct snic *snic = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", snic->name);
+	return sysfs_emit(buf, "%s\n", snic->name);
 }
 
 static ssize_t
@@ -37,7 +37,7 @@
 {
 	struct snic *snic = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			snic_state_str[snic_get_state(snic)]);
 }
 
@@ -46,7 +46,7 @@
 		      struct device_attribute *attr,
 		      char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", SNIC_DRV_VERSION);
+	return sysfs_emit(buf, "%s\n", SNIC_DRV_VERSION);
 }
 
 static ssize_t
@@ -59,7 +59,7 @@
 	if (snic->config.xpt_type == SNIC_DAS)
 		snic->link_status = svnic_dev_link_status(snic->vdev);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			(snic->link_status) ? "Link Up" : "Link Down");
 }
 
-- 
1.8.3.1


