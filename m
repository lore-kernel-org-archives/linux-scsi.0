Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F26C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 02:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DB4B61181
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 02:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhKJCj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 21:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhKJCjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 21:39:25 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9911DC061764;
        Tue,  9 Nov 2021 18:36:38 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x131so1234154pfc.12;
        Tue, 09 Nov 2021 18:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/RI8za/likW6wn/T62JKpZilA0DKYeC75oCxGkpsJyk=;
        b=j9E8jk4Regjp7QT8Ke5KzZ7nu8DaIRKgAW3S1XNLn8W/bgjcx4rqDK3QBRoc2CRsh/
         otXq0c+djWOKUxrAMBDXqE7w1Sk5gEytTk22FuMqwFCTgkr/DteMiLX5G666ZPlquONH
         ISPsFrmR94PbXkYpQJT297IYTg5oHm/xRWV/GihGyD67K9lxN1nRVYhak3R/MJJWRIwX
         sIgjyP4IEMKr1r5NgS68uWPlzVRwa4V85d3f74Z1neWyGkzRuJzPjQSDErcKHzaiOF/i
         6s6wMhn/t28facyou/ChEEw+s6Bu0LUZOzJUcjkAcZEICnJ5kbuHilg+dPCj9s5WSXz0
         zfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/RI8za/likW6wn/T62JKpZilA0DKYeC75oCxGkpsJyk=;
        b=wiEFKUGxgoJV0bxdW5Sw2Tl1vS6mUfNdbRjigKHwk5bZQcsLKvPoe2xtR1o9+CvLgC
         x6kRA9Crua+6eZokOaz6kSeK9mEwQemA1TbNb7HQMWX0uzVTNdS8HGQVB5VqZEWmkXe1
         kT4IQ1/EQA/JE6wZcHVAsoH509pUIdTeXrM/kJ1YX4t1RkiE1xbv1KMG43JAyzJ4oG3T
         2Uqh8rA63ixVynKWSxgCCbTI4dEF9dDQ8c9DZu8iErRYlC8rwqIAgDGS5oMIxcge6J0O
         wHeDdhRDmJfjB+1jUxtzbj1xqr0kedXJinWPiJt6LXNv4Z4ZJ9c4olNsLGupTDyu2APF
         g7Yg==
X-Gm-Message-State: AOAM533LQkmfGRmBupOwuWBCR4qvSI480LG/L+GLzhdRNzQjBLjQSzuR
        MdnULeDAjUkCcIg7xDKIkdk=
X-Google-Smtp-Source: ABdhPJyT7ug2NPRa8K074vc5mtJH4XcGQEBh9sxjpkbZt6xMLAh8fIuHlf3plIUkwvZuqh3/GMaXUw==
X-Received: by 2002:a65:558f:: with SMTP id j15mr3277836pgs.311.1636511798055;
        Tue, 09 Nov 2021 18:36:38 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id gc22sm3769568pjb.57.2021.11.09.18.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 18:36:37 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     subbu.seetharaman@broadcom.com
Cc:     ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: be2iscsi: Replace snprintf in show functions with  sysfs_emit
Date:   Wed, 10 Nov 2021 02:35:35 +0000
Message-Id: <20211110023535.135713-1-yao.jing2@zte.com.cn>
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
 drivers/scsi/be2iscsi/be_mgmt.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 4e899ec1477d..b0f90b3925fc 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1142,7 +1142,7 @@ ssize_t
 beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute *attr,
 		       char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, BE_NAME "\n");
+	return sysfs_emit(buf, BE_NAME "\n");
 }
 
 /**
@@ -1161,7 +1161,7 @@ beiscsi_fw_ver_disp(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", phba->fw_ver_str);
+	return sysfs_emit(buf, "%s\n", phba->fw_ver_str);
 }
 
 /**
@@ -1248,15 +1248,15 @@ beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
 	case BE_DEVICE_ID1:
 	case OC_DEVICE_ID1:
 	case OC_DEVICE_ID2:
-		return snprintf(buf, PAGE_SIZE,
+		return sysfs_emit(buf,
 				"Obsolete/Unsupported BE2 Adapter Family\n");
 	case BE_DEVICE_ID2:
 	case OC_DEVICE_ID3:
-		return snprintf(buf, PAGE_SIZE, "BE3-R Adapter Family\n");
+		return sysfs_emit(buf, "BE3-R Adapter Family\n");
 	case OC_SKH_ID1:
-		return snprintf(buf, PAGE_SIZE, "Skyhawk-R Adapter Family\n");
+		return sysfs_emit(buf, "Skyhawk-R Adapter Family\n");
 	default:
-		return snprintf(buf, PAGE_SIZE,
+		return sysfs_emit(buf,
 				"Unknown Adapter Family: 0x%x\n", dev_id);
 	}
 }
@@ -1277,7 +1277,7 @@ beiscsi_phys_port_disp(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "Port Identifier : %u\n",
+	return sysfs_emit(buf, "Port Identifier : %u\n",
 			phba->fw_config.phys_port);
 }
 
-- 
2.25.1

