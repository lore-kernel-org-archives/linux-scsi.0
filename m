Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E942C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 02:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F017E611EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 02:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhJSCZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 22:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhJSCZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 22:25:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4E3C06161C;
        Mon, 18 Oct 2021 19:23:22 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so855654pjb.2;
        Mon, 18 Oct 2021 19:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w/5ympYvhaN2axaHCFvNwG3dKfShNuC/zGFJZLprG+k=;
        b=SHGeA8+clXrQJL+NCOSUmjtpoXaBosuoxzhsvEXid71kNNC+GcBcEFpgmj71btzpHQ
         44HJzeubCVBWxHCu9xivnwy1dpiyd5rLVvdibycVkpQu+402a1hhN5QwAKCCnU7eMnkH
         TEtaR3Tg9MkUKnp7MdS3XlYzKdlMccWBezNbJFuH5aTenywfdmZBjWcJp4B6HdqqTpQS
         zMS6fyXvztHcH3hpVgrEbHGI+wyX3nQsuNZEFyWS27n7IYziqmKO34re9er4d0DCbwyc
         4mqCxSeISMXGDb76n9QsRvTyztnhhl3zs+rIkjhiYoiwj1X+08rI6CtSqq5enIu1a906
         6+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w/5ympYvhaN2axaHCFvNwG3dKfShNuC/zGFJZLprG+k=;
        b=xuNedo3Zp17hTtT7JcsuRvWV2aAad3NnYE8N5Ie9Jz/jmfukSL8auduphfAcXE57n5
         0csDyewmSwknKrCK+7KRuwG3UZkDqsA01AkcjOnXXiR7AaioezAJI03+WEt4f+Dhw5Ws
         Or9HN5sDtDtYVaMf3CkSrd30hUB3YrrVs+dosTv8ZxTsTomM0Z2takJUDOFCa/u6ZQdw
         RCDEyO+HZ7sxvBz9FhL3hEo7OJvfNuaiDvbSRSdGBLIVsTP7HqWisremr4tlyLYlGAhE
         KZYSk6UXyOc0Ix4TddL7y9p1ssriajQZQdCgHs7ukI00Zt4B7WJuqVBglP6sgzgjbsJR
         I9ZA==
X-Gm-Message-State: AOAM53181PxLIV2PENNIeS/tXOeNp1NPLchx604cx4hy948UkNzS/Mcd
        oJL3I/PKPOjHomY1tCbH1gxkft/F8UQ=
X-Google-Smtp-Source: ABdhPJxIW7SvUXHBYY3sELLyC7TDVKb4xUjvhQtAaAX5rx8jr6NVpsr9aTlQVNP+o/mNvti+h799lg==
X-Received: by 2002:a17:902:7246:b0:138:a6ed:66cc with SMTP id c6-20020a170902724600b00138a6ed66ccmr31746920pll.22.1634610201926;
        Mon, 18 Oct 2021 19:23:21 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id gm14sm707678pjb.40.2021.10.18.19.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 19:23:21 -0700 (PDT)
From:   Ye Guojin <cgel.zte@gmail.com>
X-Google-Original-From: Ye Guojin <ye.guojin@zte.com.cn>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, zealci@zte.com.cn,
        ye.guojin@zte.com.cn
Subject: [PATCH] scsi: fixup coccinelle warnings
Date:   Tue, 19 Oct 2021 02:22:52 +0000
Message-Id: <20211019022252.971916-1-ye.guojin@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING  use scnprintf or sprintf

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
---
 drivers/scsi/scsi_sysfs.c | 50 +++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a35841b34bfd..69885999ec5f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -163,7 +163,7 @@ show_##name (struct device *dev, struct device_attribute *attr, 	\
 	     char *buf)							\
 {									\
 	struct Scsi_Host *shost = class_to_shost(dev);			\
-	return snprintf (buf, 20, format_string, shost->field);		\
+	return sysfs_emit(buf, format_string, shost->field);		\
 }
 
 /*
@@ -228,7 +228,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 	if (!name)
 		return -EINVAL;
 
-	return snprintf(buf, 20, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
@@ -274,7 +274,7 @@ show_shost_active_mode(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	if (shost->active_mode == MODE_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
+		return sysfs_emit(buf, "unknown\n");
 	else
 		return show_shost_mode(shost->active_mode, buf);
 }
@@ -324,8 +324,8 @@ show_shost_eh_deadline(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	if (shost->eh_deadline == -1)
-		return snprintf(buf, strlen("off") + 2, "off\n");
-	return sprintf(buf, "%u\n", shost->eh_deadline / HZ);
+		return sysfs_emit(buf, "off\n");
+	return sysfs_emit(buf, "%u\n", shost->eh_deadline / HZ);
 }
 
 static ssize_t
@@ -382,14 +382,14 @@ static ssize_t
 show_host_busy(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
-	return snprintf(buf, 20, "%d\n", scsi_host_busy(shost));
+	return sysfs_emit(buf, "%d\n", scsi_host_busy(shost));
 }
 static DEVICE_ATTR(host_busy, S_IRUGO, show_host_busy, NULL);
 
 static ssize_t
 show_use_blk_mq(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "1\n");
+	return sysfs_emit(buf, "1\n");
 }
 static DEVICE_ATTR(use_blk_mq, S_IRUGO, show_use_blk_mq, NULL);
 
@@ -399,7 +399,7 @@ show_nr_hw_queues(struct device *dev, struct device_attribute *attr, char *buf)
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct blk_mq_tag_set *tag_set = &shost->tag_set;
 
-	return snprintf(buf, 20, "%d\n", tag_set->nr_hw_queues);
+	return sysfs_emit(buf, "%d\n", tag_set->nr_hw_queues);
 }
 static DEVICE_ATTR(nr_hw_queues, S_IRUGO, show_nr_hw_queues, NULL);
 
@@ -593,7 +593,7 @@ sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	return snprintf (buf, 20, format_string, sdev->field);		\
+	return sysfs_emit(buf, format_string, sdev->field);		\
 }									\
 
 /*
@@ -680,7 +680,7 @@ sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", scsi_device_busy(sdev));
+	return sysfs_emit(buf, "%d\n", scsi_device_busy(sdev));
 }
 static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
 
@@ -689,7 +689,7 @@ sdev_show_device_blocked(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_blocked));
+	return sysfs_emit(buf, "%d\n", atomic_read(&sdev->device_blocked));
 }
 static DEVICE_ATTR(device_blocked, S_IRUGO, sdev_show_device_blocked, NULL);
 
@@ -701,7 +701,7 @@ sdev_show_timeout (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", sdev->request_queue->rq_timeout / HZ);
+	return sysfs_emit(buf, "%d\n", sdev->request_queue->rq_timeout / HZ);
 }
 
 static ssize_t
@@ -722,7 +722,7 @@ sdev_show_eh_timeout(struct device *dev, struct device_attribute *attr, char *bu
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%u\n", sdev->eh_timeout / HZ);
+	return sysfs_emit(buf, "%u\n", sdev->eh_timeout / HZ);
 }
 
 static ssize_t
@@ -842,7 +842,7 @@ show_state_field(struct device *dev, struct device_attribute *attr, char *buf)
 	if (!name)
 		return -EINVAL;
 
-	return snprintf(buf, 20, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
 static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field, store_state_field);
@@ -857,7 +857,7 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 	if (sdev->simple_tags)
 		name = "simple";
 
-	return snprintf(buf, 20, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
 static ssize_t
@@ -934,7 +934,7 @@ static ssize_t
 show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
+	return sysfs_emit(buf, "%d\n", (int)sizeof(atomic_t) * 8);
 }
 
 static DEVICE_ATTR(iocounterbits, S_IRUGO, show_iostat_counterbits, NULL);
@@ -946,7 +946,7 @@ show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	unsigned long long count = atomic_read(&sdev->field);		\
-	return snprintf(buf, 20, "0x%llx\n", count);			\
+	return sysfs_emit(buf, "0x%llx\n", count);			\
 }									\
 static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
 
@@ -959,7 +959,7 @@ sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf (buf, 20, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
+	return sysfs_emit(buf, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
 }
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
@@ -970,7 +970,7 @@ sdev_show_evt_##name(struct device *dev, struct device_attribute *attr,	\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	int val = test_bit(SDEV_EVT_##Cap_name, sdev->supported_events);\
-	return snprintf(buf, 20, "%d\n", val);				\
+	return sysfs_emit(buf, "%d\n", val);				\
 }
 
 #define DECLARE_EVT_STORE(name, Cap_name)				\
@@ -1092,9 +1092,9 @@ sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
 	struct scsi_device *sdev = to_scsi_device(dev);
 
 	if (!sdev->handler)
-		return snprintf(buf, 20, "detached\n");
+		return sysfs_emit(buf, "detached\n");
 
-	return snprintf(buf, 20, "%s\n", sdev->handler->name);
+	return sysfs_emit(buf, "%s\n", sdev->handler->name);
 }
 
 static ssize_t
@@ -1152,7 +1152,7 @@ sdev_show_access_state(struct device *dev,
 	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
 	access_state_name = scsi_access_state_name(access_state);
 
-	return sprintf(buf, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 		       access_state_name ? access_state_name : "unknown");
 }
 static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
@@ -1168,9 +1168,9 @@ sdev_show_preferred_path(struct device *dev,
 		return -EINVAL;
 
 	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
-		return sprintf(buf, "1\n");
+		return sysfs_emit(buf, "1\n");
 	else
-		return sprintf(buf, "0\n");
+		return sysfs_emit(buf, "0\n");
 }
 static DEVICE_ATTR(preferred_path, S_IRUGO, sdev_show_preferred_path, NULL);
 #endif
@@ -1182,7 +1182,7 @@ sdev_show_queue_ramp_up_period(struct device *dev,
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%u\n",
+	return sysfs_emit(buf, "%u\n",
 			jiffies_to_msecs(sdev->queue_ramp_up_period));
 }
 
-- 
2.25.1


