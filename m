Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B70FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 11:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C79761186
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 11:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhKDL4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhKDL4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 07:56:37 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84D5C061714;
        Thu,  4 Nov 2021 04:53:59 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id v4so3786919qtw.8;
        Thu, 04 Nov 2021 04:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koH6vD7SVMVKyJH/PJVBm1PhjwmEcK7v9ZicEy7lRJE=;
        b=YtSkQW2/I77tbpJo4uN2ee+ONJYmLMsvnxshoPFe1mj2VbXd2YBMaYW4XI+2hmSzEU
         LpaZYTD8gRTIha/f76p9pBNXwBQns5TNXDZxE+3+gDDX6CaTnvpJlRMRI/NFFbVyArUW
         O6KwCq66rAnlpZYaLqcqycGMRS0Zy8QhkHGFOniMwYIexHAJRwLEmJF2KRgZI6T50Acu
         Bgi1e9h6B5O89yADCL7Fc75RqlrR14aHQO6C5JbQYP9Fsqilmpfu4CFSVNw9YIOTTN0N
         Yzwnbd/LnfJefyJZ5/QJ0ljkghvctSbPltICGQ8uuFeHsLSn5hxUkRXXuOXuDs/G58np
         BXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koH6vD7SVMVKyJH/PJVBm1PhjwmEcK7v9ZicEy7lRJE=;
        b=ihLmns3Grp8kM28z2uq55szTXC3j5Ta5wccNRGXHOOgczC4Or/7dXw26yTamKo4rnz
         bS0Xk7Oo4hJWl6nvdeprFYEMHtkxG56IDWj2IgfSFTmhBFVfU/R+CFUsiBZL0STMP2V7
         7IVTUwIs3vNLrAFboz9xRqWmVdhc5RqhpmWAGvuJ7ZAR4ACrE5URD3vJ23/T1GrbnGdn
         +fN6BkTT8FKkDtQdxF9UUsy5jwJZjYNwg9Evw7+59SRs8T4FFDttk4pR7Vw+AcQoSWGv
         pMibciqCYBnQXZzMNXr3NRKif+YupxL7xYreLPUEjBeBJ7mB69QFJpckAgnUJ4iBiq3q
         rJBw==
X-Gm-Message-State: AOAM531+XTItMkw8wRri66zczLg5nhVaOWfOGFHY1CdR+8dxft5ELmqW
        FJ4/Orgk8hgGNcNETFXFLcI=
X-Google-Smtp-Source: ABdhPJx1NEHVvXxK5z5l9KHyTun2FQnkWIAKijzYgaZxce7qhxR1ugu8xlAj6P+I1f9eR8XJWJfEBA==
X-Received: by 2002:ac8:4e03:: with SMTP id c3mr14763885qtw.148.1636026839036;
        Thu, 04 Nov 2021 04:53:59 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m1sm3548561qkp.124.2021.11.04.04.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:53:58 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     tyreld@linux.ibm.com
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Jing Yao <yao.jing2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: ibmvfc: replace snprintf in show functions with  sysfs_emit
Date:   Thu,  4 Nov 2021 11:53:49 +0000
Message-Id: <20211104115349.32073-1-yao.jing2@zte.com.cn>
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

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index d0eab5700dc5..d5a197d17e0a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3403,7 +3403,7 @@ static ssize_t ibmvfc_show_host_partition_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			vhost->login_buf->resp.partition_name);
 }
 
@@ -3413,7 +3413,7 @@ static ssize_t ibmvfc_show_host_device_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			vhost->login_buf->resp.device_name);
 }
 
@@ -3423,7 +3423,7 @@ static ssize_t ibmvfc_show_host_loc_code(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			vhost->login_buf->resp.port_loc_code);
 }
 
@@ -3433,7 +3433,7 @@ static ssize_t ibmvfc_show_host_drc_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 			vhost->login_buf->resp.drc_name);
 }
 
@@ -3442,7 +3442,7 @@ static ssize_t ibmvfc_show_host_npiv_version(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	return snprintf(buf, PAGE_SIZE, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));
+	return sysfs_emit(buf, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));
 }
 
 static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
@@ -3450,7 +3450,7 @@ static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	return snprintf(buf, PAGE_SIZE, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
+	return sysfs_emit(buf, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
 }
 
 /**
@@ -3471,7 +3471,7 @@ static ssize_t ibmvfc_show_log_level(struct device *dev,
 	int len;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	len = snprintf(buf, PAGE_SIZE, "%d\n", vhost->log_level);
+	len = sysfs_emit(buf, "%d\n", vhost->log_level);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return len;
 }
@@ -3509,7 +3509,7 @@ static ssize_t ibmvfc_show_scsi_channels(struct device *dev,
 	int len;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	len = snprintf(buf, PAGE_SIZE, "%d\n", vhost->client_scsi_channels);
+	len = sysfs_emit(buf, "%d\n", vhost->client_scsi_channels);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return len;
 }
-- 
2.25.1

