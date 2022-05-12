Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EB4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 01:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349869AbiELBS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 May 2022 21:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349857AbiELBS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2022 21:18:58 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CE07DA8D;
        Wed, 11 May 2022 18:18:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n10so3758615pjh.5;
        Wed, 11 May 2022 18:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AnVgcIyIBqniHu4rYLTlqz37Qz+0nzpmLAnn5WFxfPs=;
        b=Q9U8UNeaLvA04a+8y+a2xJd59Cn9LqfLtp9pFxCYaGjjroX8aohicGf25t1hkXfTxe
         KkfsAuFAV5nZ1VD4xgHw3W6y2zoFHZCLvHNrt5+c/1QTXx1sPWbawP5BgsSs0yfgVLZm
         RKpaQtf6npbYQdZMq4bV+jSngyQ4NBfY2olNrFZ1ETKBH8qk2ykIcdGdPIWktQOVFcKd
         lyNto3FIRmE08eIuSHtNqAGaDNQd67EXEIFIDLBYXZ6PfHTDVfZapnlbluGBDuf+STDG
         jVAuw0hSD7L63QBFSW03EwhSr+r5qCZFcMe6Uw9VQScuU6515YWsvKAoc+PVKVPjiRvP
         FTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AnVgcIyIBqniHu4rYLTlqz37Qz+0nzpmLAnn5WFxfPs=;
        b=Wihowfk4D0MW+7+g1MvUg8G9MCsblpdDE9BleNEgYjNrCDg2dkq/NENJ+g0h6wd/4f
         c+XMv9PTYwLP4oiVYQEL7qPXQY4yHD5kEFmQbckQOaeMJymZS2EvcFyNrmqTepNEwqvv
         TZo2StXG0KCeXo7gzyCeTp3+XpN33LnD9gY3E500/Oc4i3yleJASV6IFc7uWJ430T5MM
         KcgV+oaj8TB4iSN3ye3MgSiezTbSGzlf60WD91orpUVm3LcmhM9CITZoT17J03CMA4Rw
         S/e7YqQVQmfm/0nIbBfqTnDkKXWNTFkE9vi8alXyIJKZMkZgQ3qDl/krEG8ACSSiK5Ew
         RsZw==
X-Gm-Message-State: AOAM532wETQIHZqV6o+EOE7SbWquK6RCWuFkaStcL9FtJo81lyj1goio
        4sx4gC9qmElpGJzQ39IIgCQ=
X-Google-Smtp-Source: ABdhPJz/rmyQf3Qoamjem3D5LRE9zsf7vddS53Lp1Scd8NQQ8dwNOtOJXSlw1nFabBJOjpJcXTWJCw==
X-Received: by 2002:a17:902:7891:b0:15e:cae9:7620 with SMTP id q17-20020a170902789100b0015ecae97620mr28091638pll.136.1652318337357;
        Wed, 11 May 2022 18:18:57 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 18-20020a621712000000b0050dc762817asm2398325pfx.84.2022.05.11.18.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 18:18:57 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] [SCSI] arcmsr: Use kobj_to_dev()
Date:   Thu, 12 May 2022 01:18:53 +0000
Message-Id: <20220512011853.1621819-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Use kobj_to_dev() instead of open-coding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/scsi/arcmsr/arcmsr_attr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index baeb5e795690..041e15929cd3 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -64,7 +64,7 @@ static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
 					     char *buf, loff_t off,
 					     size_t count)
 {
-	struct device *dev = container_of(kobj,struct device,kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	uint8_t *ptmpQbuffer;
@@ -111,7 +111,7 @@ static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
 					      char *buf, loff_t off,
 					      size_t count)
 {
-	struct device *dev = container_of(kobj,struct device,kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	int32_t user_len, cnt2end;
@@ -159,7 +159,7 @@ static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
 					      char *buf, loff_t off,
 					      size_t count)
 {
-	struct device *dev = container_of(kobj,struct device,kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	uint8_t *pQbuffer;
--
2.25.1


