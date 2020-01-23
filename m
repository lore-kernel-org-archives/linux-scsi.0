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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9A4C33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A84621734
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zd4zXd9e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgAWWVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:21:13 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42351 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAWWVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 17:21:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so2078043pgb.9
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 14:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ngc2l8NkuAdUGD5zjUuA+OfrA2FJEejnzIlFf0MlouA=;
        b=Zd4zXd9ekITMK+WnJhhDdjeCMM5kB2BjAz1AlpjUm8ZmLna1uqDzW7MZR/HfCZ8DW/
         lXS6nKaiKBmIOP+o5YSWFNSJitI08XaYC6uHaMooZIVwXrX7OJyRP7zUL6ptosON+eqv
         5+JUkJNmcUv3iubcr0kCKooqadlL2Ene+YYbGjKtpUIpBAiBi32vxF3qZgMQ7cxTSZki
         HgzdoIHKlJKz92qdPO2+q+QiHGm/6a1Ldv5iiWwl8qPqZzIEwNodVEu/8xQXjSsefx76
         40JX+dtrdDijP02jRsZnft3d4dV95daN2TaabuVV0QKf183ReG+qeAhetBCu/dSyxqGg
         hwIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ngc2l8NkuAdUGD5zjUuA+OfrA2FJEejnzIlFf0MlouA=;
        b=IiB1keb7wrGvOcSAzNMdMXihC5O7yUo/pqKPBVs3/dbCY14QGQzymtIbq+wfF3yKUK
         gnRDdStlI+z5EuQbI5/hW3rffT54fCBeE80EzGOmgRoZI6JnUHD11/nlSAq7XWN/tYDJ
         kBY/MzwH6FO3XOy+mlJxYyUJ7J3j/DUieRHlgnReUKFLgK47Ppx7y0UipJjLwOw94a77
         0mMizlpJWUTiJPcbwQ+Kb31+GycnhblRxdLt7tElvOjVyjecq39AUwXTT8dww/WGgm1p
         QyHiVC3m6Jrc+QIY8oLSeelj7ahofpCrpBHaHZkmh18cli440HRxGXPWs1Shi23UqpJN
         iLfQ==
X-Gm-Message-State: APjAAAXoY69/Wr0Mqfqei51Ce4ih0VvrD8QyL7krGosqRqBqBHjIOH4k
        StI5n5fxjOgZABc8v1dgkxAAwigU
X-Google-Smtp-Source: APXvYqzB9EFHdcFWhAo9KZ+00A6wypvcWhCrUSNNYcNVfKDIk3v2Kz6v1bxaN7ngh3IcjOHjriWNgA==
X-Received: by 2002:a65:6794:: with SMTP id e20mr621141pgr.152.1579818072497;
        Thu, 23 Jan 2020 14:21:12 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g8sm3616660pfh.43.2020.01.23.14.21.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 14:21:12 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 3/3] scsi: add shost attribute to set max queue depth on all devices on the shost
Date:   Thu, 23 Jan 2020 14:21:02 -0800
Message-Id: <20200123222102.23383-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200123222102.23383-1-jsmart2021@gmail.com>
References: <20200123222102.23383-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds an shost attribute, max_device_queue_depth, that will
cycle through all devices on the shost and change their current and max
queue depth to the new value.

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/scsi_sysfs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 954f68b002cb..85dab4867eed 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -368,6 +368,23 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store_shost_eh_deadline);
 
+static ssize_t
+store_host_max_device_queue_depth(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	int depth, retval;
+
+	depth = simple_strtoul(buf, NULL, 0);
+
+	retval = shost_change_max_queue_depths(shost, depth);
+
+	return (retval < 0) ? retval : count;
+}
+
+static DEVICE_ATTR(max_device_queue_depth, S_IWUSR, NULL,
+		   store_host_max_device_queue_depth);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
@@ -411,6 +428,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_prot_guard_type.attr,
 	&dev_attr_host_reset.attr,
 	&dev_attr_eh_deadline.attr,
+	&dev_attr_max_device_queue_depth.attr,
 	NULL
 };
 
-- 
2.13.7

