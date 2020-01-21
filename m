Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A53C2D0CE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 23:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC16320665
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 23:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oTnYwx/k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgAUXxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:53:14 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32768 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUXxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2020 18:53:11 -0500
Received: by mail-pf1-f196.google.com with SMTP id z16so2345719pfk.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2020 15:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5p0z5zmz0EYN4OPNUv7wljclAGx1P4SFjCAsxMT/WRM=;
        b=oTnYwx/kbiRF5XNnD5Cfgd1SmxNBz0qckKIj78YO3Gy+1UD+Aax+cqTBWJiQfo/ebs
         P/rf6BmKcJPVZagvJd2RxAwlYXH9MDzIzMmS2JxgG3oAwiVeswGWVO4SjON53oxxoE/P
         HJdDaGhbnEw4Kf4TzZvmvWPQmIFTbLOdChAU7uO5SYlXBaORX7WyM03hc73DTdn/plti
         a43RNkcfPQMFRFC0qKXCIyhGqslbE/6ueDQS12FbYnBHsrIVTLJQs3jNj9fYgRUNsZmv
         UmI74PJTRmbcOyZP5KJNjlcxHwwqkE3Og4s5lvWztri97Whea6VkvtJn0OQbeN/tE2JU
         QsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5p0z5zmz0EYN4OPNUv7wljclAGx1P4SFjCAsxMT/WRM=;
        b=JOR76Z+CKantq4ozXRRsGqZgccJ4lcUbk450S4YYc1sGSKB5u7057OD5Hjv7RIxk8C
         s9JqbseboLaGN8Lkzq1BURwkYEKv7MT/XavTsVN4/fvB43lzKCaODu0v87CT7xxLiBSy
         CUTqk2acBr8dtwXsNIq3A9CEhaZAclYxHBAxCN1paZHxSHj4MRK+2FSrZy00WehPZKoM
         zWyE40+KeK3+AMKcBVU3AbgBrnXYhWSWbu9TXbP1HmRs7fWtxsJOwG4x1ZVncfe/pXUq
         XA9jGgtBtlZ9pzbgZL8bGsSTXp+EUD4d+4s9mKLdwO/AmX/nnRQl8EGIZdIuQ7R/y9d7
         hZkw==
X-Gm-Message-State: APjAAAWsf/zWE71wf75tFLrhdWWU3eqHWNuHeIpU1uMnrGb7Dej2vcIH
        umDzkoD9uJUIOlBU8RtJ1ZrHe+26
X-Google-Smtp-Source: APXvYqxn8d9SRGwHNJsyU1gLpSWsGoS6KJ+pDAtNC5XIfmCpwvDueoZMisIPskNqluC+HMavfLkbMg==
X-Received: by 2002:a62:7711:: with SMTP id s17mr7740pfc.157.1579650789940;
        Tue, 21 Jan 2020 15:53:09 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u18sm44056143pgn.9.2020.01.21.15.53.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 15:53:09 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH] scsi: add attribute to set lun queue depth on all luns on shost
Date:   Tue, 21 Jan 2020 15:53:02 -0800
Message-Id: <20200121235302.9955-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There has been a desire to set the lun queue depth on all luns on
an shost. Today that is done by an external script looping through
discovered sdevs and set an sdev attribute.

This patch addes a shost attribute that will cycle through all
sdevs and set the lun queue depth.

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/scsi_sysfs.c | 49 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 677b5c5403d2..debb79be66c0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -368,6 +368,50 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store_shost_eh_deadline);
 
+static int
+sdev_set_queue_depth(struct scsi_device *sdev, int depth)
+{
+	struct scsi_host_template *sht = sdev->host->hostt;
+	int retval;
+
+	retval = sht->change_queue_depth(sdev, depth);
+	if (retval < 0)
+		return retval;
+
+	sdev->max_queue_depth = sdev->queue_depth;
+
+	return 0;
+}
+
+static ssize_t
+store_host_lun_queue_depth(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct scsi_host_template *sht = shost->hostt;
+	struct scsi_device *sdev;
+	int depth, retval;
+
+	if (!sht->change_queue_depth)
+		return -EINVAL;
+
+	depth = simple_strtoul(buf, NULL, 0);
+	if (depth < 1 || depth > shost->can_queue)
+		return -EINVAL;
+
+	shost_for_each_device(sdev, shost) {
+		retval = sdev_set_queue_depth(sdev, depth);
+		if (retval != 0)
+			sdev_printk(KERN_INFO, sdev,
+				"failed to set queue depth to %d (err %d)",
+				depth, retval);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(lun_queue_depth, S_IWUSR, NULL, store_host_lun_queue_depth);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
@@ -411,6 +455,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_prot_guard_type.attr,
 	&dev_attr_host_reset.attr,
 	&dev_attr_eh_deadline.attr,
+	&dev_attr_lun_queue_depth.attr,
 	NULL
 };
 
@@ -992,12 +1037,10 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 	if (depth < 1 || depth > sdev->host->can_queue)
 		return -EINVAL;
 
-	retval = sht->change_queue_depth(sdev, depth);
+	retval = sdev_set_queue_depth(sdev, depth);
 	if (retval < 0)
 		return retval;
 
-	sdev->max_queue_depth = sdev->queue_depth;
-
 	return count;
 }
 sdev_show_function(queue_depth, "%d\n");
-- 
2.13.7

