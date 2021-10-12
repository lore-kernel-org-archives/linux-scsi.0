Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE817C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D84C460F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhJLXix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:53 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:41601 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbhJLXiu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:50 -0400
Received: by mail-pl1-f175.google.com with SMTP id x8so565562plv.8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzGDEg+jAZR7uGnvCWr1TcRbXzy6bDQwywzwfMVHUFM=;
        b=ut0P43ZsoSzMuv7c4kVepMv2m8jHdL6YPeyxB+rBvMwUwVYjQeOBV23yJvVhHvrK2u
         6E3hoArGmbIVfUkfKzJ1cj2I0vrb7/XevcLDCeyS45nzT2jGhpAWeAzWmeiG4RU82mBn
         y5DAnEm5CGuydLvQIHP8UXZITFVpN8IiyAVob+XOrnnBxW+GaKmovP/OzYl8zb0T5dCy
         4DhPseRvXkyKFafKiC1XeI150HJAwL84HXHvX8AAkAKmhXuPFHmkdaLN4H+Qmk9hKN4E
         HflOYhKZW7S0Lw65/Vaa0i7lB1wDDWU1pz8SuEDzO8k7EA6i8GiYmSShSnM4H8xuqW97
         Lx1A==
X-Gm-Message-State: AOAM532GhgjKenhdePq1x0AgrsafC8qquFvdzYTDeF/NiMaIUyV+ib5b
        kGzzItaM7Euv0gpTk8Ryu7UvjOoy7gxpPA==
X-Google-Smtp-Source: ABdhPJwkBa8BN2Ajbg7rZ9skvs8hLomFaKD4FGmGjPYYuJ3LzZNUl3ScJnayV4eESa5xma6z94f3dQ==
X-Received: by 2002:a17:90a:ec17:: with SMTP id l23mr9431039pjy.184.1634081808370;
        Tue, 12 Oct 2021 16:36:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 21/46] scsi: hpsa: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:33 -0700
Message-Id: <20211012233558.4066756-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hpsa.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3faa87fa296a..8b0dc4be486e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -936,30 +936,34 @@ static DEVICE_ATTR(ctlr_num, S_IRUGO,
 static DEVICE_ATTR(legacy_board, S_IRUGO,
 	host_show_legacy_board, NULL);
 
-static struct device_attribute *hpsa_sdev_attrs[] = {
-	&dev_attr_raid_level,
-	&dev_attr_lunid,
-	&dev_attr_unique_id,
-	&dev_attr_hp_ssd_smart_path_enabled,
-	&dev_attr_path_info,
-	&dev_attr_sas_address,
+static struct attribute *hpsa_sdev_attrs[] = {
+	&dev_attr_raid_level.attr,
+	&dev_attr_lunid.attr,
+	&dev_attr_unique_id.attr,
+	&dev_attr_hp_ssd_smart_path_enabled.attr,
+	&dev_attr_path_info.attr,
+	&dev_attr_sas_address.attr,
 	NULL,
 };
 
-static struct device_attribute *hpsa_shost_attrs[] = {
-	&dev_attr_rescan,
-	&dev_attr_firmware_revision,
-	&dev_attr_commands_outstanding,
-	&dev_attr_transport_mode,
-	&dev_attr_resettable,
-	&dev_attr_hp_ssd_smart_path_status,
-	&dev_attr_raid_offload_debug,
-	&dev_attr_lockup_detected,
-	&dev_attr_ctlr_num,
-	&dev_attr_legacy_board,
+ATTRIBUTE_GROUPS(hpsa_sdev);
+
+static struct attribute *hpsa_shost_attrs[] = {
+	&dev_attr_rescan.attr,
+	&dev_attr_firmware_revision.attr,
+	&dev_attr_commands_outstanding.attr,
+	&dev_attr_transport_mode.attr,
+	&dev_attr_resettable.attr,
+	&dev_attr_hp_ssd_smart_path_status.attr,
+	&dev_attr_raid_offload_debug.attr,
+	&dev_attr_lockup_detected.attr,
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_legacy_board.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(hpsa_shost);
+
 #define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_DRIVER +\
 				 HPSA_MAX_CONCURRENT_PASSTHRUS)
 
@@ -980,8 +984,8 @@ static struct scsi_host_template hpsa_driver_template = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= hpsa_compat_ioctl,
 #endif
-	.sdev_attrs = hpsa_sdev_attrs,
-	.shost_attrs = hpsa_shost_attrs,
+	.sdev_groups = hpsa_sdev_groups,
+	.shost_groups = hpsa_shost_groups,
 	.max_sectors = 2048,
 	.no_write_same = 1,
 };
