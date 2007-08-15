From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] make attribute_container_unregister() unconditionally
	wait for list empty
Date: Wed, 15 Aug 2007 10:54:42 -0500
Message-ID: <1187193282.3327.21.camel@localhost.localdomain>
References: <1187192400.3142.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44159 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762613AbXHOPyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 11:54:44 -0400
In-Reply-To: <1187192400.3142.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 11:40 -0400, James Smart wrote:
> James,
> 
> >> > > Isn't a better way to handle it simply to give
> >> > > transport_container_unregister() the semantics everyone is expecting
> >> > > (i.e. to wait for everything to be tidied up and gone)?  That way none
> >> > > of the transport classes needs updating, and we don't have to handle the
> >> > > rather nasty release and unload races.
> > 
> > I was thinking of a wait_event driven system checking for 
> > list_empty(cont->containers.k_list)
> 
> I hope this is more in line with what you were thinking.....

Almost .. the event is so rare, it's easier to do it globally (and not
waste the storage in the containers).  Plus, the signal is an empty
list, which we can move into a separate function.  Finally, I kept the
old API just in case, but made a new unregister_and_wait one which the
transport classes use (and changed the return to be void ... which tells
me absolutely no-one was cheking it).

This is the patch I've been testing.

James

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 7370d7c..5cbfb4c 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
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
@@ -86,29 +93,58 @@ attribute_container_register(struct attribute_container *cont)
 }
 EXPORT_SYMBOL_GPL(attribute_container_register);
 
+static int
+attribute_container_in_use(struct attribute_container *cont)
+{
+	int retval;
+
+	spin_lock(&cont->containers.k_lock);
+	retval = !!list_empty(&cont->containers.k_list);
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
+	while (attribute_container_unregister(cont) != -EBUSY)
+		WARN_ON(wait_event_timeout(busy_containers_waitq,
+					   !attribute_container_in_use(cont),
+					   BUSY_CONTAINERS_TIMEOUT) == 0);
+}
+EXPORT_SYMBOL_GPL(attribute_container_unregister_and_wait);
+
 /* private function used as class release */
 static void attribute_container_release(struct class_device *classdev)
 {
@@ -227,6 +263,8 @@ attribute_container_remove_device(struct device *dev,
 			if (dev != ic->classdev.dev)
 				continue;
 			klist_del(&ic->node);
+			if (!attribute_container_in_use(cont))
+				wake_up(&busy_containers_waitq);
 			if (fn)
 				fn(cont, dev, &ic->classdev);
 			else {
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index 8ff2749..1025557 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -37,6 +37,7 @@ attribute_container_set_no_classdevs(struct attribute_container *atc)
 
 int attribute_container_register(struct attribute_container *cont);
 int attribute_container_unregister(struct attribute_container *cont);
+void attribute_container_unregister_and_wait(struct attribute_container *cont);
 void attribute_container_create_device(struct device *dev,
 				       int (*fn)(struct attribute_container *,
 						 struct device *,
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 1d6cc22..63d4bd6 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -86,9 +86,9 @@ static inline int transport_container_register(struct transport_container *tc)
 	return attribute_container_register(&tc->ac);
 }
 
-static inline int transport_container_unregister(struct transport_container *tc)
+static inline void transport_container_unregister(struct transport_container *tc)
 {
-	return attribute_container_unregister(&tc->ac);
+	attribute_container_unregister_and_wait(&tc->ac);
 }
 
 int transport_class_register(struct transport_class *);


