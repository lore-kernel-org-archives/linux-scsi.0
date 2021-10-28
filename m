Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC95C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 02:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82DF760C4A
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 02:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJ1C1g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 22:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhJ1C1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 22:27:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F923C061570;
        Wed, 27 Oct 2021 19:25:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so3506490pjb.3;
        Wed, 27 Oct 2021 19:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5GRC3oKU5t8MNbDIRrWo3mHgF77PLmBHPiD3xo6WI7U=;
        b=EqwXy5n9i8RiU1Vqj5mkd6XKFXv/7pY4aSKYpOAzquPYCEy3yMTtku9UkfYIVBtyYK
         9+AzS1vhmGcTxOt56eLm3ysI8mBYn7XgwsbTeaLuOBI4UctuckQbRHz/8WaZ85CP231X
         fwUbh5i8MWFMzXBeOl6BavkZuzxO4vOsyDhKidTYhxRly+qPrnNtxChJDle40rRcyclD
         cJzNhCFliUnPwUx7OisY/NxQehcMQvtP+oJh+QjpnYJbBOMdM1D496JuP72FSAoLC4xj
         V/XUcLyUFQaCHL+VYPW57va/GfcqBQtrVyJiNkEUfLmwj2o85jIzaoT1/IMKWwxECb6U
         INcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5GRC3oKU5t8MNbDIRrWo3mHgF77PLmBHPiD3xo6WI7U=;
        b=aJ5U3dzS+uW419vZlQGVzQdhSaUcNPgGR3+S//3VbxCeKGF/kyQt+RnPVBOxbqfYFr
         BjoxAP9hwQHnIw9jvNW2X6Ik0Q6mlKN+7vCllGde90OPAe8jyoi6SUIVfPB/35GYXTNU
         jIiBh9+ClEkEv9H4Uf79+QswQohmi033/M/ugNJzY6pDsW7xBoTji4xo7uQ0hfYKk/e7
         porQTBWzWjxI3ygonUgr1+ugrar8rnoF19AVrMWsylO0uak2VhsPz02CYP4wG5+M4JAg
         Q4fM32dzBOdGtC1VrD1A6Tjd38mMe7QNz+nhHvXDjv79Sl4mPjel1tPkJHZou6/0a2Ik
         FqlQ==
X-Gm-Message-State: AOAM533yZOY9EVaY3GZqtMN+ap4ldOlbhfQPlOeq/b+WtchNIvYEnxAT
        SQI8jVTH9hoSu4/glwdogn0=
X-Google-Smtp-Source: ABdhPJyaUMQa33s9XhiwDfXb5v0/Ivv7x0V/Uwo58Yx3uqZUxdP2E0LU5ZcBtVYvQUYiZ7PK9AgPdQ==
X-Received: by 2002:a17:902:9348:b0:141:5862:28b4 with SMTP id g8-20020a170902934800b00141586228b4mr1352384plp.17.1635387908677;
        Wed, 27 Oct 2021 19:25:08 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c8sm1224790pfv.150.2021.10.27.19.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 19:25:08 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     tyreld@linux.ibm.com
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: ibmvfc: replace scnprintf in show functions with sysfs_emit
Date:   Thu, 28 Oct 2021 02:24:59 +0000
Message-Id: <20211028022459.9076-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the coccicheck warning:
WARNING: use scnprintf or sprintf

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a4b0a12f8a97..7f39a965677b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3402,8 +3402,7 @@ static ssize_t ibmvfc_show_host_partition_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			vhost->login_buf->resp.partition_name);
+	return sysfs_emit(buf, "%s\n", vhost->login_buf->resp.partition_name);
 }
 
 static ssize_t ibmvfc_show_host_device_name(struct device *dev,
@@ -3412,8 +3411,7 @@ static ssize_t ibmvfc_show_host_device_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			vhost->login_buf->resp.device_name);
+	return sysfs_emit(buf, "%s\n", vhost->login_buf->resp.device_name);
 }
 
 static ssize_t ibmvfc_show_host_loc_code(struct device *dev,
@@ -3422,8 +3420,7 @@ static ssize_t ibmvfc_show_host_loc_code(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			vhost->login_buf->resp.port_loc_code);
+	return sysfs_emit(buf, "%s\n", vhost->login_buf->resp.port_loc_code);
 }
 
 static ssize_t ibmvfc_show_host_drc_name(struct device *dev,
@@ -3432,8 +3429,7 @@ static ssize_t ibmvfc_show_host_drc_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			vhost->login_buf->resp.drc_name);
+	return sysfs_emit(buf, "%s\n", vhost->login_buf->resp.drc_name);
 }
 
 static ssize_t ibmvfc_show_host_npiv_version(struct device *dev,
@@ -3441,7 +3437,7 @@ static ssize_t ibmvfc_show_host_npiv_version(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	return snprintf(buf, PAGE_SIZE, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));
+	return sysfs_emit(buf, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));
 }
 
 static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
@@ -3449,7 +3445,7 @@ static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	return snprintf(buf, PAGE_SIZE, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
+	return sysfs_emit(buf, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
 }
 
 /**
-- 
2.25.1

