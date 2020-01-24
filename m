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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF06C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80CAA20678
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0Ety7Tu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgAXXB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:01:26 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54244 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgAXXBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 18:01:25 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so451092pjc.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 15:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7HlQSn3OI5vadelPh1ROqxp9w9f77dU+sOeebZqF/Ec=;
        b=W0Ety7TuQ2V0biIbV1BzS3HiCTj+zOGX1O6TX++ZfgRjBwEiEFNlCPb9IAL3TFGmAy
         6sR34/sbv7Y+BXbyO5Mz68JgRMZD0VPJbPqsbqLOVstUtd2BPGp/kP9nSMhmU1y4zK06
         xddu457CzXo72c87DrbIUyliCik1Z3e8hgmxGOdS8xnbPFGqiERf6+uCDMmPRzhcoa+S
         SoNLCLljulUBssjlsdMaxWkXSOU1l8ii95XOueVOXo55upwU5ZTV3PpK2lNidjtMQuFZ
         6w990UZmhyPELQQCUGmVfAAZnufl7/YJ0BUczJVLuhhdapXnhLidjNbCI6Az2xtqB+6B
         qKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7HlQSn3OI5vadelPh1ROqxp9w9f77dU+sOeebZqF/Ec=;
        b=IbaoPRso/a7lE+J46kWcJIMkgtRzsiDM7NkBJYn2FxYTw91dNL/ysRsvh700MtBZoD
         BWdC8BvlR3X5YoJonNhKh9R5Dh5BygeWokiBspBN3dDd15iVBhkAE7ADt1pIDx7PNt5K
         7c+E+WzmtYU2NkXEi3OBodV1MFZezJZ0ZO2P5f56F4d/63a2qHFgeC4tiQFBl1rNQ6zu
         vXlNPamYAFyDYy4yn0X4ci/+fM2FDPn8clSCGSOGUpDhVF0aIiN/ogRccK+Ndq19M6ZD
         hDHq8iubKoh4YerNvwegFWlFnhnv9Vt9UdBZI2Hol6kAuKLdWteDKB708mQof2HRFSMz
         GRzg==
X-Gm-Message-State: APjAAAVcOei0Yhxg6h3AJGPdxdeN66xAR557q5uAn3dabDFSIA7xLe+3
        HQhhT9ElU2NtTz4dDZfaTQZDQg3q
X-Google-Smtp-Source: APXvYqzP2onbGsPdRva9bGkeNH24Vl/4sAIoyHV3SVOtsE2DkVM8UdipXNd5pxtomaXjs3dvn8HGSw==
X-Received: by 2002:a17:902:b604:: with SMTP id b4mr5846162pls.340.1579906884894;
        Fri, 24 Jan 2020 15:01:24 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d4sm7406784pjz.12.2020.01.24.15.01.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 15:01:24 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     bvanassche@acm.org, James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 3/3] scsi: add shost attribute to set max queue depth on all devices on the shost
Date:   Fri, 24 Jan 2020 15:01:15 -0800
Message-Id: <20200124230115.14562-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200124230115.14562-1-jsmart2021@gmail.com>
References: <20200124230115.14562-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds an shost attribute, max_device_queue_depth, that will
cycle through all devices on the shost and change their current and max
queue depth to the new value.

Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
 use kstrtouint
 specify permissions in octl, not by mnemonic
 remove unnecessary parens
---
 drivers/scsi/scsi_sysfs.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d4e9ad9a6f18..98dbbfb6397b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -368,6 +368,26 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store_shost_eh_deadline);
 
+static ssize_t
+store_host_max_device_queue_depth(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	unsigned int depth;
+	int retval;
+
+	retval = kstrtouint(buf, 10, &depth);
+	if (retval)
+		return -EINVAL;
+
+	retval = shost_change_max_queue_depths(shost, depth);
+
+	return retval < 0 ? retval : count;
+}
+
+static DEVICE_ATTR(max_device_queue_depth, 0200, NULL,
+		   store_host_max_device_queue_depth);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
@@ -411,6 +431,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_prot_guard_type.attr,
 	&dev_attr_host_reset.attr,
 	&dev_attr_eh_deadline.attr,
+	&dev_attr_max_device_queue_depth.attr,
 	NULL
 };
 
-- 
2.13.7

