Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BF1C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 08:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC0B660FE3
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 08:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhKEIYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 04:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhKEIYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 04:24:40 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA2C061714;
        Fri,  5 Nov 2021 01:22:01 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id v4so6502942qtw.8;
        Fri, 05 Nov 2021 01:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UeE83lis6ZLgwEGLKe5llQHwu8pvxfQ5EgZx+3HxWOc=;
        b=I5pfBRn4t05dAYlswwEnjMwtRewjp5jQxoUzQQrEd/BsFhogwTKRq9ySrSQXfybUtN
         2oEMr9rD2zo6hM0FN0OH5i2wy4mgBCrgwv/anqmou0N44IFrtCIPkm3fTydppVP2ff4f
         OY8RE2y6431802VlE8FQyptp7sLtGtN+QiRKVLYm9zp9/qzkJJqcNvfOn3EdViIdATn3
         /XQq3C9PQFPCt1aLflBD8/IGAzxGde7uTEoTG+CQ2lFdiHCB92sM3a05M6i1jmebd8BL
         ZDcn5gr+sSA7G2Smkymr8lyR+XN9cjpeqYrUgrlZ+A+FDpcsQ/rptE9PQxBSPFxvPF2t
         qo1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UeE83lis6ZLgwEGLKe5llQHwu8pvxfQ5EgZx+3HxWOc=;
        b=Xw2H4L5Cf8wKPJy4YlNuyjU6bGiQvucP56C7n2vc3SHqcOw72MKxarJCaZu0KlAEUF
         bsN7Nzc9Iz1aIkKbbCJ5JdRbMg1+TWM9KmeiSbgcuUi/SLNnqY3p+HV5eNkuhdlX4eq6
         KwSw5fNnxeezwKG3On83QJCYo0m8Y4ewy+HmJxrGUvkIWfonsexobnrqizeglge3PPAe
         KMJslpbUo62iRtQ9hm6QocQBZ15Owmmt08slmtVavTpQzVPwE6eU0EMc7cM+jwYSygbs
         732SM4g2WE8KXA/w9A19e5YL5VZhcjnlqbgzYmzsrOW6qCUdBLzJS9+nYXLjkVWQxA6Z
         gPOA==
X-Gm-Message-State: AOAM533xc3KOWwACAQNHQzL1vaFxSeeoq3PbbrgW+7zqHB8vO++hc00l
        icAB/ltKAekSjoP9wGOgSHw=
X-Google-Smtp-Source: ABdhPJwhHwZonV6IBNpMZxxp+iBQ/6YumnCbcvgX/ZqnyKoUCoaRJOBkq84s4LbMrLV7vnG8IHCV7Q==
X-Received: by 2002:a05:622a:1043:: with SMTP id f3mr6629450qte.284.1636100520726;
        Fri, 05 Nov 2021 01:22:00 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e10sm5455946qtx.66.2021.11.05.01.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 01:22:00 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jing Yao <yao.jing2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: scsi_transport_fc: Replace snprintf in show  functions with  sysfs_emit
Date:   Fri,  5 Nov 2021 08:21:53 +0000
Message-Id: <20211105082153.77120-1-yao.jing2@zte.com.cn>
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
 drivers/scsi/scsi_transport_fc.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 60e406bcf42a..42a1fe6f4bd6 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1122,7 +1122,7 @@ show_fc_rport_supported_classes (struct device *dev,
 {
 	struct fc_rport *rport = transport_class_to_rport(dev);
 	if (rport->supported_classes == FC_COS_UNSPECIFIED)
-		return snprintf(buf, 20, "unspecified\n");
+		return sysfs_emit(buf, "unspecified\n");
 	return get_fc_cos_names(rport->supported_classes, buf);
 }
 static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
@@ -1217,21 +1217,21 @@ show_fc_rport_roles (struct device *dev, struct device_attribute *attr,
 					FC_WELLKNOWN_PORTID_MASK) {
 		switch (rport->port_id & FC_WELLKNOWN_ROLE_MASK) {
 		case FC_FPORT_PORTID:
-			return snprintf(buf, 30, "Fabric Port\n");
+			return sysfs_emit(buf, "Fabric Port\n");
 		case FC_FABCTLR_PORTID:
-			return snprintf(buf, 30, "Fabric Controller\n");
+			return sysfs_emit(buf, "Fabric Controller\n");
 		case FC_DIRSRVR_PORTID:
-			return snprintf(buf, 30, "Directory Server\n");
+			return sysfs_emit(buf, "Directory Server\n");
 		case FC_TIMESRVR_PORTID:
-			return snprintf(buf, 30, "Time Server\n");
+			return sysfs_emit(buf, "Time Server\n");
 		case FC_MGMTSRVR_PORTID:
-			return snprintf(buf, 30, "Management Server\n");
+			return sysfs_emit(buf, "Management Server\n");
 		default:
-			return snprintf(buf, 30, "Unknown Fabric Entity\n");
+			return sysfs_emit(buf, "Unknown Fabric Entity\n");
 		}
 	} else {
 		if (rport->roles == FC_PORT_ROLE_UNKNOWN)
-			return snprintf(buf, 20, "unknown\n");
+			return sysfs_emit(buf, "unknown\n");
 		return get_fc_port_roles_names(rport->roles, buf);
 	}
 }
@@ -1285,7 +1285,7 @@ show_fc_rport_port_state(struct device *dev,
 	if (!name)
 		return -EINVAL;
 
-	return snprintf(buf, 20, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
 static FC_DEVICE_ATTR(rport, port_state, 0444 | 0200,
@@ -1303,8 +1303,8 @@ show_fc_rport_fast_io_fail_tmo (struct device *dev,
 	struct fc_rport *rport = transport_class_to_rport(dev);
 
 	if (rport->fast_io_fail_tmo == -1)
-		return snprintf(buf, 5, "off\n");
-	return snprintf(buf, 20, "%d\n", rport->fast_io_fail_tmo);
+		return sysfs_emit(buf, "off\n");
+	return sysfs_emit(buf, "%d\n", rport->fast_io_fail_tmo);
 }
 
 static ssize_t
@@ -1664,7 +1664,7 @@ show_fc_vport_roles (struct device *dev, struct device_attribute *attr,
 	struct fc_vport *vport = transport_class_to_vport(dev);
 
 	if (vport->roles == FC_PORT_ROLE_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
+		return sysfs_emit(buf, "unknown\n");
 	return get_fc_port_roles_names(vport->roles, buf);
 }
 static FC_DEVICE_ATTR(vport, roles, S_IRUGO, show_fc_vport_roles, NULL);
@@ -1890,7 +1890,7 @@ show_fc_host_supported_classes (struct device *dev,
 	struct Scsi_Host *shost = transport_class_to_shost(dev);
 
 	if (fc_host_supported_classes(shost) == FC_COS_UNSPECIFIED)
-		return snprintf(buf, 20, "unspecified\n");
+		return sysfs_emit(buf, "unspecified\n");
 
 	return get_fc_cos_names(fc_host_supported_classes(shost), buf);
 }
@@ -1914,7 +1914,7 @@ show_fc_host_supported_speeds (struct device *dev,
 	struct Scsi_Host *shost = transport_class_to_shost(dev);
 
 	if (fc_host_supported_speeds(shost) == FC_PORTSPEED_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
+		return sysfs_emit(buf, "unknown\n");
 
 	return get_fc_port_speed_names(fc_host_supported_speeds(shost), buf);
 }
@@ -1966,7 +1966,7 @@ show_fc_host_speed (struct device *dev,
 		i->f->get_host_speed(shost);
 
 	if (fc_host_speed(shost) == FC_PORTSPEED_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
+		return sysfs_emit(buf, "unknown\n");
 
 	return get_fc_port_speed_names(fc_host_speed(shost), buf);
 }
-- 
2.25.1

