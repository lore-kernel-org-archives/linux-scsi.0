Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F420EC33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D45ED2072A
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgAFS6c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:58:32 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35916 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFS6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 13:58:31 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 09F3029196A;
        Mon,  6 Jan 2020 18:58:28 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     gregkh@linuxfoundation.org
Cc:     rafael@kernel.org, lduncan@suse.com, cleech@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 1/3] drivers: base: Support atomic version of attribute_container_device_trigger
Date:   Mon,  6 Jan 2020 13:58:15 -0500
Message-Id: <20200106185817.640331-2-krisman@collabora.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106185817.640331-1-krisman@collabora.com>
References: <20200106185817.640331-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

attribute_container_device_trigger invokes callbacks that may fail for
one or more classdev's, for instance, the transport_add_class_device
callback, called during transport creation, does memory allocation.
This information, though, is not propagated to upper layers, and any
driver using the attribute_container_device_trigger API will not know
whether any, some, or all callbacks succeeded.

This patch implements a safe version of this dispatcher, to either
succeed all the callbacks or revert to the original state.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/base/attribute_container.c  | 103 ++++++++++++++++++++++++++++
 include/linux/attribute_container.h |   7 ++
 2 files changed, 110 insertions(+)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 20736aaa0e69..f7bd0f4db13d 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -236,6 +236,109 @@ attribute_container_remove_device(struct device *dev,
 	mutex_unlock(&attribute_container_mutex);
 }
 
+static int
+do_attribute_container_device_trigger_safe(struct device *dev,
+					   struct attribute_container *cont,
+					   int (*fn)(struct attribute_container *,
+						     struct device *, struct device *),
+					   int (*undo)(struct attribute_container *,
+						       struct device *, struct device *))
+{
+	int ret;
+	struct internal_container *ic, *failed;
+	struct klist_iter iter;
+
+	if (attribute_container_no_classdevs(cont))
+		return fn(cont, dev, NULL);
+
+	klist_for_each_entry(ic, &cont->containers, node, &iter) {
+		if (dev == ic->classdev.parent) {
+			ret = fn(cont, dev, &ic->classdev);
+			if (ret) {
+				failed = ic;
+				klist_iter_exit(&iter);
+				goto fail;
+			}
+		}
+	}
+	return 0;
+
+fail:
+	if (!undo)
+		return ret;
+
+	/* Attempt to undo the work partially done. */
+	klist_for_each_entry(ic, &cont->containers, node, &iter) {
+		if (ic == failed) {
+			klist_iter_exit(&iter);
+			break;
+		}
+		if (dev == ic->classdev.parent)
+			undo(cont, dev, &ic->classdev);
+	}
+	return ret;
+}
+
+/**
+ * attribute_container_device_trigger_safe - execute a trigger for each
+ * matching classdev or fail all of them.
+ *
+ * @dev:  The generic device to run the trigger for
+ * @fn	  the function to execute for each classdev.
+ * @undo  A function to undo the work previously done in case of error
+ *
+ * This function is a safe version of
+ * attribute_container_device_trigger. It stops on the first error and
+ * undo the partial work that has been done, on previous classdev.  It
+ * is guaranteed that either they all succeeded, or none of them
+ * succeeded.
+ */
+int
+attribute_container_device_trigger_safe(struct device *dev,
+					int (*fn)(struct attribute_container *,
+						  struct device *,
+						  struct device *),
+					int (*undo)(struct attribute_container *,
+						    struct device *,
+						    struct device *))
+{
+	struct attribute_container *cont, *failed = NULL;
+	int ret = 0;
+
+	mutex_lock(&attribute_container_mutex);
+
+	list_for_each_entry(cont, &attribute_container_list, node) {
+
+		if (!cont->match(cont, dev))
+			continue;
+
+		ret = do_attribute_container_device_trigger_safe(dev, cont,
+								 fn, undo);
+		if (ret) {
+			failed = cont;
+			break;
+		}
+	}
+
+	if (ret && !WARN_ON(!undo)) {
+		list_for_each_entry(cont, &attribute_container_list, node) {
+
+			if (failed == cont)
+				break;
+
+			if (!cont->match(cont, dev))
+				continue;
+
+			do_attribute_container_device_trigger_safe(dev, cont,
+								   undo, NULL);
+		}
+	}
+
+	mutex_unlock(&attribute_container_mutex);
+	return ret;
+
+}
+
 /**
  * attribute_container_device_trigger - execute a trigger for each matching classdev
  *
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index d12bb2153cd6..e4004d1e6725 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -54,6 +54,13 @@ void attribute_container_device_trigger(struct device *dev,
 					int (*fn)(struct attribute_container *,
 						  struct device *,
 						  struct device *));
+int attribute_container_device_trigger_safe(struct device *dev,
+					    int (*fn)(struct attribute_container *,
+						      struct device *,
+						      struct device *),
+					    int (*undo)(struct attribute_container *,
+							struct device *,
+							struct device *));
 void attribute_container_trigger(struct device *dev, 
 				 int (*fn)(struct attribute_container *,
 					   struct device *));
-- 
2.24.1

