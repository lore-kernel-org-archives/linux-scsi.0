Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF44C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12C9520675
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFskSfAW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgEMVg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 17:36:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37451 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729345AbgEMVg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 17:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589405786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/s6vI/nmCH6b0CmF34V4hXpVkjbqBprb5r6kKm9AhU=;
        b=fFskSfAWNhh74wjvGJ0GKi92QB4sPtjKYK0odc5uC0d7nu/zhJGEM/RoPF0pkJCZaQtgcr
        E4R7OeIo1xR3YDD1KQGH8P9ieJ0tTkBTb4d9YMuVciFLSi5mHz/1c0Io8A3fCyOZ5W2j37
        mif9/pS53mWsE9qUg7ChKyg1b7IlddI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-rW6S6VcKOSuZkPVYP1uK2g-1; Wed, 13 May 2020 17:36:25 -0400
X-MC-Unique: rW6S6VcKOSuZkPVYP1uK2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 733D080572B;
        Wed, 13 May 2020 21:36:24 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBFE15D9E5;
        Wed, 13 May 2020 21:36:23 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v2 1/7] struct device: Add function callback durable_name
Date:   Wed, 13 May 2020 16:36:15 -0500
Message-Id: <20200513213621.470411-2-tasleson@redhat.com>
In-Reply-To: <20200513213621.470411-1-tasleson@redhat.com>
References: <20200513213621.470411-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index dbb0f9130f42..86ea3acb1e1f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2281,6 +2281,30 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
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
index fa04dfd22bbc..a9e5abbd2269 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -616,6 +616,8 @@ struct device {
 	struct iommu_fwspec	*iommu_fwspec;
 	struct iommu_param	*iommu_param;
 
+	int (*durable_name)(const struct device *dev, char *buff, size_t len);
+
 	bool			offline_disabled:1;
 	bool			offline:1;
 	bool			of_node_reused:1;
@@ -657,6 +659,8 @@ static inline const char *dev_name(const struct device *dev)
 extern __printf(2, 3)
 int dev_set_name(struct device *dev, const char *name, ...);
 
+int dev_durable_name(const struct device *d, char *buffer, size_t len);
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
-- 
2.25.4

