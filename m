From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] make attribute_container_unregister() unconditionally
	wait for list empty
Date: Thu, 16 Aug 2007 09:49:47 -0500
Message-ID: <1187275787.3367.25.camel@localhost.localdomain>
References: <1187192400.3142.6.camel@localhost.localdomain>
	 <1187193282.3327.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51951 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760785AbXHPOtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2007 10:49:53 -0400
In-Reply-To: <1187193282.3327.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 10:54 -0500, James Bottomley wrote:
> This is the patch I've been testing.

Actually, that patch was wrong ... it has two subtle bugs that conspire
to make it seem correct.  Can you try this one instead?  I don't have
any fibre equipment, and the other transport classes aren't in use when
they're released.

Thanks,

James

Index: BUILD-2.6/drivers/base/attribute_container.c
===================================================================
--- BUILD-2.6.orig/drivers/base/attribute_container.c	2007-08-15 12:09:32.000000000 -0500
+++ BUILD-2.6/drivers/base/attribute_container.c	2007-08-15 18:01:44.000000000 -0500
@@ -19,9 +19,16 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 
 #include "base.h"
 
+static DECLARE_WAIT_QUEUE_HEAD(busy_containers_waitq);
+
+/* wait up to 30s for containers being unregistered to become free */
+#define BUSY_CONTAINERS_TIMEOUT (30*HZ)
+
 /* This is a private structure used to tie the classdev and the
  * container .. it should never be visible outside this file */
 struct internal_container {
@@ -86,29 +93,58 @@ attribute_container_register(struct attr
 }
 EXPORT_SYMBOL_GPL(attribute_container_register);
 
+static int
+attribute_container_in_use(struct attribute_container *cont)
+{
+	int retval;
+
+	spin_lock(&cont->containers.k_lock);
+	retval = !list_empty(&cont->containers.k_list);
+	spin_unlock(&cont->containers.k_lock);
+
+	return retval;
+}
 /**
  * attribute_container_unregister - remove a container registration
  *
  * @cont: previously registered container to remove
+ *
+ * May return -EBUSY if the container still contains live attributes
+ * that cannot be released.
  */
 int
 attribute_container_unregister(struct attribute_container *cont)
 {
 	int retval = -EBUSY;
 	mutex_lock(&attribute_container_mutex);
-	spin_lock(&cont->containers.k_lock);
-	if (!list_empty(&cont->containers.k_list))
+	if (attribute_container_in_use(cont))
 		goto out;
 	retval = 0;
 	list_del(&cont->node);
  out:
-	spin_unlock(&cont->containers.k_lock);
 	mutex_unlock(&attribute_container_mutex);
 	return retval;
 		
 }
 EXPORT_SYMBOL_GPL(attribute_container_unregister);
 
+/**
+ * attribute_container_unregister_and_wait - remove a container registration
+ *
+ * @cont: previously registered container to remove
+ *
+ * Waits for everything to be released before returning.
+ */
+void
+attribute_container_unregister_and_wait(struct attribute_container *cont)
+{
+	while (attribute_container_unregister(cont) == -EBUSY)
+		WARN_ON(wait_event_timeout(busy_containers_waitq,
+					   !attribute_container_in_use(cont),
+					   BUSY_CONTAINERS_TIMEOUT) == 0);
+}
+EXPORT_SYMBOL_GPL(attribute_container_unregister_and_wait);
+
 /* private function used as class release */
 static void attribute_container_release(struct class_device *classdev)
 {
@@ -227,6 +263,8 @@ attribute_container_remove_device(struct
 			if (dev != ic->classdev.dev)
 				continue;
 			klist_del(&ic->node);
+			if (!attribute_container_in_use(cont))
+				wake_up(&busy_containers_waitq);
 			if (fn)
 				fn(cont, dev, &ic->classdev);
 			else {
Index: BUILD-2.6/include/linux/attribute_container.h
===================================================================
--- BUILD-2.6.orig/include/linux/attribute_container.h	2007-08-15 12:09:32.000000000 -0500
+++ BUILD-2.6/include/linux/attribute_container.h	2007-08-15 15:59:14.000000000 -0500
@@ -37,6 +37,7 @@ attribute_container_set_no_classdevs(str
 
 int attribute_container_register(struct attribute_container *cont);
 int attribute_container_unregister(struct attribute_container *cont);
+void attribute_container_unregister_and_wait(struct attribute_container *cont);
 void attribute_container_create_device(struct device *dev,
 				       int (*fn)(struct attribute_container *,
 						 struct device *,
Index: BUILD-2.6/include/linux/transport_class.h
===================================================================
--- BUILD-2.6.orig/include/linux/transport_class.h	2007-08-15 12:09:32.000000000 -0500
+++ BUILD-2.6/include/linux/transport_class.h	2007-08-15 15:59:14.000000000 -0500
@@ -86,9 +86,9 @@ static inline int transport_container_re
 	return attribute_container_register(&tc->ac);
 }
 
-static inline int transport_container_unregister(struct transport_container *tc)
+static inline void transport_container_unregister(struct transport_container *tc)
 {
-	return attribute_container_unregister(&tc->ac);
+	attribute_container_unregister_and_wait(&tc->ac);
 }
 
 int transport_class_register(struct transport_class *);


