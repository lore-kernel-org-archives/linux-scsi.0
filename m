Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F530C33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1587208C4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgAFS6g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:58:36 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35924 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFS6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 13:58:34 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 6AD4429166F;
        Mon,  6 Jan 2020 18:58:32 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     gregkh@linuxfoundation.org
Cc:     rafael@kernel.org, lduncan@suse.com, cleech@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 2/3] drivers: base: Propagate errors through the transport component
Date:   Mon,  6 Jan 2020 13:58:16 -0500
Message-Id: <20200106185817.640331-3-krisman@collabora.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106185817.640331-1-krisman@collabora.com>
References: <20200106185817.640331-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The transport registration may fail.  Make sure the errors are
propagated to the callers.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/base/transport_class.c  | 11 ++++++++---
 include/linux/transport_class.h |  6 +++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index 5ed86ded6e6b..ccc86206e508 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -30,6 +30,10 @@
 #include <linux/attribute_container.h>
 #include <linux/transport_class.h>
 
+static int transport_remove_classdev(struct attribute_container *cont,
+				     struct device *dev,
+				     struct device *classdev);
+
 /**
  * transport_class_register - register an initial transport class
  *
@@ -172,10 +176,11 @@ static int transport_add_class_device(struct attribute_container *cont,
  * routine is simply a trigger point used to add the device to the
  * system and register attributes for it.
  */
-
-void transport_add_device(struct device *dev)
+int transport_add_device(struct device *dev)
 {
-	attribute_container_device_trigger(dev, transport_add_class_device);
+	return attribute_container_device_trigger_safe(dev,
+					transport_add_class_device,
+					transport_remove_classdev);
 }
 EXPORT_SYMBOL_GPL(transport_add_device);
 
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index a9c59761927b..63076fb835e3 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -62,16 +62,16 @@ struct transport_container {
 	container_of(x, struct transport_container, ac)
 
 void transport_remove_device(struct device *);
-void transport_add_device(struct device *);
+int transport_add_device(struct device *);
 void transport_setup_device(struct device *);
 void transport_configure_device(struct device *);
 void transport_destroy_device(struct device *);
 
-static inline void
+static inline int
 transport_register_device(struct device *dev)
 {
 	transport_setup_device(dev);
-	transport_add_device(dev);
+	return transport_add_device(dev);
 }
 
 static inline void
-- 
2.24.1

