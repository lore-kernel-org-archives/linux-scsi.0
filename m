Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A3AC33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DCF321734
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWfeuxsi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAWWVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:21:12 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40481 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAWWVL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 17:21:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id k25so2087999pgt.7
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 14:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0k821ioYLcih8vf/gJjSO7Ax9tQbTTCQOZMsHt0dh0c=;
        b=FWfeuxsiNPtHOY0B0ji/JlI1wYZKjigKigdSgGqLrMGWUfdAaOx9r+MzpQ+hmKN7zb
         l0EqC3Dv1u7iuFUfxRNsNLtUJu5WYQ77O7Wj+aqPFvnxIzq7dMnXoqtqsbKIXdDs7CMI
         RCjqWsBNRsiNKygTy3uM4a+7VusLMpRVjzDDq8jNzgUOJuQNBVaHJHq3SF2PoxH1/2ue
         KTt6n8dXalt3sD8JywPVXcYnQOJstDNLiDkZC0snvHVY+rwy+LLjkn6gI0vxHiLpHELm
         BPQ+hHy4cICC9HDRuL4OeE0s6g7BWPjaKTsrjxUlaCbdlA9Me9JQgYmRm66tygo/n8Fb
         Worg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0k821ioYLcih8vf/gJjSO7Ax9tQbTTCQOZMsHt0dh0c=;
        b=TczlEgI6thaZzmPldpVoxIW+VRUGtSxyLQ9vj0k4uhNO0i9OHG6miSkgpn7O2eN9XN
         5/K8tdJ8UcLygM/32LA3URP9TMusww9to/t/ZExFFsbciR4JgPP3cw/IKdal6Qo1d4fe
         yJj9IsVVFolRD1JMKO2JAhs6EW23aQ0M0VGul9HU9FdhFMX2mvU3UZcuN8c2LksuUm78
         /tfYST2OwBR6ElQnnxO+ojXG3WlBHLA/nNRPsITpeRP1OPgoqBmS9pX39SWhbyEdFHPu
         qIgXcFm0qhXyL27sRPr7/mozRio3QC8O/JIdl/kv5aAQZyIpzg90e22WquH/iY9LD2D0
         vwig==
X-Gm-Message-State: APjAAAX5PoU+y9Ap+YFE+q7IKsGEHVKOvRSeEvNZCP6Lr78Trr+gfoCp
        oVt0HhpyaEFZUxznOyRd1SCE0hm3
X-Google-Smtp-Source: APXvYqyvvCz1Qt08iWFMUxVLRszvHBlwPKjOXccYlnDGEHWiRmmlQrj7BkyirJajvfux3fNAhtss6Q==
X-Received: by 2002:a63:d66:: with SMTP id 38mr559643pgn.233.1579818070785;
        Thu, 23 Jan 2020 14:21:10 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g8sm3616660pfh.43.2020.01.23.14.21.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 14:21:10 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 1/3] scsi: refactor sdev lun queue depth setting via sysfs
Date:   Thu, 23 Jan 2020 14:21:00 -0800
Message-Id: <20200123222102.23383-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200123222102.23383-1-jsmart2021@gmail.com>
References: <20200123222102.23383-1-jsmart2021@gmail.com>
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
 drivers/scsi/scsi.c       | 22 ++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  |  1 +
 drivers/scsi/scsi_sysfs.c |  9 +++------
 3 files changed, 26 insertions(+), 6 deletions(-)

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
index 677b5c5403d2..954f68b002cb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -982,22 +982,19 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 {
 	int depth, retval;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_host_template *sht = sdev->host->hostt;
 
-	if (!sht->change_queue_depth)
-		return -EINVAL;
+	if (!sdev->host->hostt->change_queue_depth)
+		return -ENOTSUPP;
 
 	depth = simple_strtoul(buf, NULL, 0);
 
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

