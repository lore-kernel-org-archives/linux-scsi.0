Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B7AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80E072082F
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DcUaJKNQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387466AbgFWTR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:17:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733309AbgFWTR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 15:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592939875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MVXzDZJGgBD4xUv6v9WDwHRdtXXOvQAzISrUuLR4fHM=;
        b=DcUaJKNQ+C06tR0om72J57qC9nPRjNDaGd+Bkn2v+Ms5PQqYr9jpZIcUpsF9dRoxst3nL8
        p2BP0jrglanrChBF26lPmML1fIuhLBOSQSeFuv4h1LGYM/hkgiiqJ6otoK5GDL3lDXAK26
        L6Dsl3oSKoOwuO85FGn0hbjwRDzyTsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-l_94cfbbOquXuITPxu4PpA-1; Tue, 23 Jun 2020 15:17:54 -0400
X-MC-Unique: l_94cfbbOquXuITPxu4PpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D000801503;
        Tue, 23 Jun 2020 19:17:53 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C59E7168D;
        Tue, 23 Jun 2020 19:17:52 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v3 1/8] struct device: Add function callback durable_name
Date:   Tue, 23 Jun 2020 14:17:42 -0500
Message-Id: <20200623191749.115200-2-tasleson@redhat.com>
In-Reply-To: <20200623191749.115200-1-tasleson@redhat.com>
References: <20200623191749.115200-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
2.25.4

