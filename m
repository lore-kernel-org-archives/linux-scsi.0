Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5835BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 06:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B47C60F70
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 06:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhKBHB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBHB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 03:01:58 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F243C061714;
        Mon,  1 Nov 2021 23:59:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k4so4724277plx.8;
        Mon, 01 Nov 2021 23:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqXwOUNI4/IijAlpWAo12uhMUJZ0tnXr5EHJzFt7VTI=;
        b=lneso4AyG+tGq8owgQRSmatMK3IUeSPdI90ZQgFfY757rx79Q4gYgWf8mSwll4IBee
         zn/Xfsn/z8MB5jpN35Gq7EOzjX8X49ah8k2IYpxYK7hi5MOLrzfdJ4wE78cM6gMTV/6l
         ZPSUjm8NAcWZNXnpISUyWpNFF5NpiXVg6PVwurlJgxUxtLvN3wiXvSf9LwFthVeEFR0F
         ILs1U2SlKMZN+yyuIyHWyLroKVb40R5ysqMP31UbFsNuIVNQS6c6mXfptGN7zToWzhWF
         T+uoJVObXQLMHPC4mhJdsRED6da/IYlpasL90jwH1OxqFO+fkrl7vTOakAS4eNXiLHOO
         tnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqXwOUNI4/IijAlpWAo12uhMUJZ0tnXr5EHJzFt7VTI=;
        b=jpp25hspoXAAeFfILgK/sZ/B3+MawgpVEymLOG36rhpJBaJ6cGHn2tmyFmcwPUAwSS
         wekCLuGiur7qkwYuiXEl1NOMmwIGsVZeBOPcd31h9Vd+lHilwmy5GqO8e1o1UBkx3qkx
         obEEmJ12OEI6ROYxt6lOhZMZjlsLXVlj9UChQCsNJygWPa7LmuXa9PKbLXEaQ9ioiI6y
         gogkbWo2/vcSXotYjVcIjEoC3Q0KQ7s6b+ilRflcKbbox2t6zgdxqS5mar8O75hV0e29
         nqWYhmbRfRQENwYe4P1oJ6j+k05fmNS5LY7FItmDY5TDtNnoTNaf7COK2knGeDav1/YA
         9RvQ==
X-Gm-Message-State: AOAM533E1bXNIR7uMT2fmPjwFfbOZGYlZIdNWOIPfu/FD+iRzfU3McMh
        wYobpMwtldpau2AeapjFpa0=
X-Google-Smtp-Source: ABdhPJyZwE+1coELcVY3xbl84n48ESpJ+5RLjdIi/ksHkVEOoBlelvQsQw/eCDp7BkzvDbomG0bpQw==
X-Received: by 2002:a17:90a:df96:: with SMTP id p22mr3153842pjv.129.1635836364229;
        Mon, 01 Nov 2021 23:59:24 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id v14sm17611914pff.199.2021.11.01.23.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 23:59:23 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     tyreld@linux.ibm.com
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Jing Yao <yao.jing2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2] drivers: scsi: replace snprintf in show functions with sysfs_emit
Date:   Tue,  2 Nov 2021 06:59:16 +0000
Message-Id: <20211102065916.4164-1-yao.jing2@zte.com.cn>
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
 drivers/scsi/ibmvscsi/ibmvfc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index d0eab5700dc5..69bf55c037a5 100644
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
-- 
2.25.1

