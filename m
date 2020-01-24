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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34314C2D0CE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091C72075D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjsAYQac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgAXXBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:01:25 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45050 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbgAXXBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 18:01:24 -0500
Received: by mail-pf1-f196.google.com with SMTP id 62so1800397pfu.11
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 15:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dakujYJY/7ExPlGLb/f9tkbvzTxLC/3th35VdsB95QU=;
        b=IjsAYQac6uDrWSbwssBflE/zJLw7AXimvZ3924jsuViTKmq8ZK3sbvxLZLnA1/TbnL
         MAcEKlBwq7B+j85Mpho0oHJ1eWA7pe1Zfa2zqWFpspN3oup1clu88SytxRmmLS8zc64y
         mlheefLTxHSTexOqxtP0Cr9SPJH+Fr4zxbww+2KKYxz+IkXhBun7Q+fzseaj5pKUAZ5q
         UFYFv3DklGwNkljvpMSe0RQ7oPsycc8m3r4JpSDMnQURVTm1pc8C798ySV7c5u4X/uYv
         ACq2GpcFOhbvEn4ddzvCUfx1shg2jsvK/uyzmltV/aN3ux+KK2Ad9UcTVz3eP9AqfcMx
         Mcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dakujYJY/7ExPlGLb/f9tkbvzTxLC/3th35VdsB95QU=;
        b=VqzhA4G2FkSBaGF+u+sEJj310AjX5uIxJ638aVRJxMEVAe3rHqNhPHSLAqKac3HMD3
         ysOEEQdanphCEwlY8kBeSB+QyPOvaQbHgaHCkh6HaYhmyL21uesFumgTMZl0WIhDbP5m
         u55XzoRfk+zwf77qvyisUowDjnSUwS0L8H3piFBWvVCtetr7/PHGq0yxC6oiva2ClgKd
         Krh2kV2IXDoxeQ/J+ZvZH85lYuu1LCUlZ3GFFr35Q/tKFSlTRhfBmpgeWEn3yrP74Ory
         Rih6Sx79n8dUTMaRWczEelVVdqBlwWywGZejnLh00T24/XuMZS/OH3QwQ3VfjjGGwyYl
         k5/g==
X-Gm-Message-State: APjAAAVLai9G0nsGeXXtbBScVsBzTu36r7DYny7k4YMru3jOC3BFor8f
        poRiHLx1PvHnaWpCznBbhfTrm+pt
X-Google-Smtp-Source: APXvYqy98R1TM39/SADRZ70Rgg9bDkO5jBkcyCONmO5wTK01LCkls/PZRE3ZiZtVR3u+1jN0JwMTFA==
X-Received: by 2002:a63:ed56:: with SMTP id m22mr6511403pgk.261.1579906884081;
        Fri, 24 Jan 2020 15:01:24 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d4sm7406784pjz.12.2020.01.24.15.01.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 15:01:23 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     bvanassche@acm.org, James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 2/3] scsi: add shost helper to set max queue depth on all of its devices
Date:   Fri, 24 Jan 2020 15:01:14 -0800
Message-Id: <20200124230115.14562-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200124230115.14562-1-jsmart2021@gmail.com>
References: <20200124230115.14562-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create a helper routine to loop through all devices on an shost and
change their current and maximum queue depth. The helper is created
such that is lldd callable.

Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
 fix spaces
 change ENOTSUPP to ENXIO
---
 drivers/scsi/scsi.c        | 32 ++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 2 files changed, 33 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 195c0b11260a..86db018bacb2 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -272,6 +272,38 @@ scsi_change_max_queue_depth(struct scsi_device *sdev, int depth)
 }
 
 /**
+ * shost_change_max_queue_depths - helper to walk all devices on a
+ *         shost and change their max queue depth.
+ * @shost: shost whose devices we want to iterate over.
+ * @depth: number of commands allowed to be queued to the driver
+ *
+ * Validates the shost allows a change of queue depth, the value is valid,
+ * then traverses over all devices and sets their maximum queue depth.
+ */
+int shost_change_max_queue_depths(struct Scsi_Host *shost, int depth)
+{
+	struct scsi_device *sdev;
+	int retval;
+
+	if (!shost->hostt->change_queue_depth)
+		return -ENXIO;
+
+	if (depth < 1 || depth > shost->can_queue)
+		return -EINVAL;
+
+	shost_for_each_device(sdev, shost) {
+		retval = scsi_change_max_queue_depth(sdev, depth);
+		if (retval != 0)
+			sdev_printk(KERN_INFO, sdev,
+				"failed to set queue depth to %d (err %d)",
+				depth, retval);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(shost_change_max_queue_depths);
+
+/**
  * scsi_track_queue_full - track QUEUE_FULL events to adjust queue depth
  * @sdev: SCSI Device in question
  * @depth: Current number of outstanding SCSI commands on this device,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3e5b42..38c4b97fc1b8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -392,6 +392,7 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
 
 extern int scsi_change_queue_depth(struct scsi_device *, int);
 extern int scsi_track_queue_full(struct scsi_device *, int);
+extern int shost_change_max_queue_depths(struct Scsi_Host *shost, int depth);
 
 extern int scsi_set_medium_removal(struct scsi_device *, char);
 
-- 
2.13.7

