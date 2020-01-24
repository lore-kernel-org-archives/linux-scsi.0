Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF26DC32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3B3220678
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kAVmWRAY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgAXXBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:01:24 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38776 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729346AbgAXXBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 18:01:24 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so1814957pfc.5
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 15:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ABmn4WSAZLL/09a8t+v+LX5fJ3yi/gmr9dfUNA4ge+c=;
        b=kAVmWRAYIQReDJbH1UDTQnDMMfxOgOfMYc+trEX4x0T5V67TNOvElFtXCkChxZ7E7E
         TkjG5B/Dxeg/GCOPFp3RDnXjQhExsobYa/0t6k2SXoLpkRFMf8kSAxPVbbLWV/Ii8t1J
         SZTW6UHhZUBsyn78MYrWKYjlde7JMLQjz1SriHbq58tkd0OVmutqpckPHHUUI4opQbXf
         nCNraQWuuFc9PqHk2gVJlq5Kt6WGVFOcHKl3AaKj/y//uvvPE59HKzucvEcWETXwxQd6
         U9a6qaNxxv+TjwuTSAL3qsaSQMeJtcHnwAnc8Lx0zCax78ld0Xbm0ZQ7S1Ka7/I0svyJ
         QP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ABmn4WSAZLL/09a8t+v+LX5fJ3yi/gmr9dfUNA4ge+c=;
        b=FCkWW6amo3XxA8xvfIg0QMAzQx4+eZ5x8w4IYwFcQRMaTdE9LTi6HlEIZe65Z/tgQY
         QFy/JYPGyX4d/vf3fNWRBtl8hqugtlOH5Nh8kA+BMusxm1b2ZWLVn9x1egCDDmY24mH0
         uCegTDDa7RWXxb4nbUWxLHqorus24wGJ4l7oqIBHlOJvniKVIBbdDEI5CEBrS3cL85iv
         he3IN6J563FDzrxcEYKEo31w0yR3BHvkHUosEjkuIv6k/f7/Wgvpl2rGjrnwprYSLW8D
         B+B0OWCDQWth1QMnao1L3eIQGAtx/H/VSL8nNLCAUimlJmZvwBGvf5pJB8WcP1RGqw90
         aHIg==
X-Gm-Message-State: APjAAAXpzT3rPka+wKw8OzBf7Bxpbl/hL69CXypPgtnuX5+E/CjcE8x5
        mx8ZFaC+imleU4XBKe1GZPfaMLFZ
X-Google-Smtp-Source: APXvYqwpbWaOyhutNRdP4hdBTh5KwTh8UlEUpBa8/qNd5vKRkA7z6NBkbVLOYDbSDcbGAtM8vyN10g==
X-Received: by 2002:a63:6e0e:: with SMTP id j14mr6456115pgc.361.1579906883131;
        Fri, 24 Jan 2020 15:01:23 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d4sm7406784pjz.12.2020.01.24.15.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 15:01:22 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     bvanassche@acm.org, James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 1/3] scsi: refactor sdev lun queue depth setting via sysfs
Date:   Fri, 24 Jan 2020 15:01:13 -0800
Message-Id: <20200124230115.14562-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200124230115.14562-1-jsmart2021@gmail.com>
References: <20200124230115.14562-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for allowing other attributes and routines to change
the current and max lun queue depth on an sdev, refactor the sysfs
sdev attribute change routine. The refactoring creates a new scsi-internal
routine, scsi_change_max_queue_depth(), which changes a devices current
and max queue value.

The new routine is placed next to the routine, scsi_change_queue_depth(),
which is used by most lldds to implement a queue depth change.

Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  revert -ENOTSUPP status on shost template check back to -EINVAL
---
 drivers/scsi/scsi.c       | 22 ++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  |  1 +
 drivers/scsi/scsi_sysfs.c |  7 ++-----
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 930e4803d888..195c0b11260a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -249,6 +249,28 @@ int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 }
 EXPORT_SYMBOL(scsi_change_queue_depth);
 
+/*
+ * scsi_change_max_queue_depth - change the max queue depth for a device.
+ * @sdev: SCSI Device in question
+ * @depth: number of commands allowed to be queued to the driver
+ *
+ * Calls the device's transport to validate and change the queue depth,
+ * then stores the new maximum on the device.
+ */
+int
+scsi_change_max_queue_depth(struct scsi_device *sdev, int depth)
+{
+	int retval;
+
+	retval = sdev->host->hostt->change_queue_depth(sdev, depth);
+	if (retval < 0)
+		return retval;
+
+	sdev->max_queue_depth = sdev->queue_depth;
+
+	return 0;
+}
+
 /**
  * scsi_track_queue_full - track QUEUE_FULL events to adjust queue depth
  * @sdev: SCSI Device in question
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3bff9f7aa684..5c288cf3ae64 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -41,6 +41,7 @@ static inline void scsi_log_send(struct scsi_cmnd *cmd)
 static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 	{ };
 #endif
+int scsi_change_max_queue_depth(struct scsi_device *sdev, int depth);
 
 /* scsi_devinfo.c */
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 677b5c5403d2..d4e9ad9a6f18 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -982,9 +982,8 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 {
 	int depth, retval;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_host_template *sht = sdev->host->hostt;
 
-	if (!sht->change_queue_depth)
+	if (!sdev->host->hostt->change_queue_depth)
 		return -EINVAL;
 
 	depth = simple_strtoul(buf, NULL, 0);
@@ -992,12 +991,10 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 	if (depth < 1 || depth > sdev->host->can_queue)
 		return -EINVAL;
 
-	retval = sht->change_queue_depth(sdev, depth);
+	retval = scsi_change_max_queue_depth(sdev, depth);
 	if (retval < 0)
 		return retval;
 
-	sdev->max_queue_depth = sdev->queue_depth;
-
 	return count;
 }
 sdev_show_function(queue_depth, "%d\n");
-- 
2.13.7

