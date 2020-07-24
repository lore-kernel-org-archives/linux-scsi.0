Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37771C433E3
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19867206F6
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bo17s4PW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGXRRP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726488AbgGXRRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 13:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXsCksyTLCkwB57az0VC2sK31RKrpKwrezDs3J5Qc1I=;
        b=Bo17s4PWW+rFGMCWoeJNn1Kq/x2iWjecJ0O77PYUw55iUFjFmfqVh2vjdhv0N9BIYr354R
        HrwX8R2PD+hxA8cyaPBbr8TD3FDbTv3bmsumDJazArGSRz2ovsJQ1mXMsh+Hi9YJP8vt5s
        7ufX3n3a2nGmT6IwuCg/jHnVw/CWoVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-ptN7wANIMu-kj1MbRo5WrA-1; Fri, 24 Jul 2020 13:17:12 -0400
X-MC-Unique: ptN7wANIMu-kj1MbRo5WrA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2525080183C;
        Fri, 24 Jul 2020 17:17:11 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD71E74F64;
        Fri, 24 Jul 2020 17:17:09 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 01/11] struct device: Add function callback durable_name
Date:   Fri, 24 Jul 2020 12:16:56 -0500
Message-Id: <20200724171706.1550403-2-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function callback and function to be used to write a persistent
durable name to the supplied character buffer.  This will be used to add
structured key-value data to log messages for hardware related errors
which allows end users to correlate message and specific hardware.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/base/core.c    | 24 ++++++++++++++++++++++++
 include/linux/device.h |  4 ++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0cad34f1eede..511b7d2fc916 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2304,6 +2304,30 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
 
+/**
+ * dev_durable_name - Write "DURABLE_NAME"=<durable name> in buffer
+ * @dev: device
+ * @buffer: character buffer to write results
+ * @len: length of buffer
+ * @return: Number of bytes written to buffer
+ */
+int dev_durable_name(const struct device *dev, char *buffer, size_t len)
+{
+	int tmp, dlen;
+
+	if (dev && dev->durable_name) {
+		tmp = snprintf(buffer, len, "DURABLE_NAME=");
+		if (tmp < len) {
+			dlen = dev->durable_name(dev, buffer + tmp,
+							len - tmp);
+			if (dlen > 0 && ((dlen + tmp) < len))
+				return dlen + tmp;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dev_durable_name);
+
 /**
  * device_to_dev_kobj - select a /sys/dev/ directory for the device
  * @dev: device
diff --git a/include/linux/device.h b/include/linux/device.h
index ac8e37cd716a..281755404c21 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -613,6 +613,8 @@ struct device {
 	struct iommu_group	*iommu_group;
 	struct dev_iommu	*iommu;
 
+	int (*durable_name)(const struct device *dev, char *buff, size_t len);
+
 	bool			offline_disabled:1;
 	bool			offline:1;
 	bool			of_node_reused:1;
@@ -654,6 +656,8 @@ static inline const char *dev_name(const struct device *dev)
 extern __printf(2, 3)
 int dev_set_name(struct device *dev, const char *name, ...);
 
+int dev_durable_name(const struct device *d, char *buffer, size_t len);
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
-- 
2.26.2

