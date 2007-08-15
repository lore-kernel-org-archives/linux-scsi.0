From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] make attribute_container_unregister() unconditionally wait
	for list empty
Date: Wed, 15 Aug 2007 11:40:00 -0400
Message-ID: <1187192400.3142.6.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51522 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbXHOPkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 11:40:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomely@steeleye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James,

>> > > Isn't a better way to handle it simply to give
>> > > transport_container_unregister() the semantics everyone is expecting
>> > > (i.e. to wait for everything to be tidied up and gone)?  That way none
>> > > of the transport classes needs updating, and we don't have to handle the
>> > > rather nasty release and unload races.
> 
> I was thinking of a wait_event driven system checking for 
> list_empty(cont->containers.k_list)

I hope this is more in line with what you were thinking.....

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c	2007-08-16 02:59:50.000000000 -0400
+++ b/drivers/base/attribute_container.c	2007-08-17 05:02:03.000000000 -0400
@@ -19,6 +19,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #include "base.h"
 
@@ -75,6 +76,8 @@ int
 attribute_container_register(struct attribute_container *cont)
 {
 	INIT_LIST_HEAD(&cont->node);
+	init_waitqueue_head(&cont->cont_wait);
+	cont->flags &= ~ATTRIBUTE_CONTAINER_EVENT_PENDING;
 	klist_init(&cont->containers,internal_container_klist_get,
 		   internal_container_klist_put);
 		
@@ -89,23 +92,26 @@ EXPORT_SYMBOL_GPL(attribute_container_re
 /**
  * attribute_container_unregister - remove a container registration
  *
+ * Semantics have now changed - we never return until the list goes empty
+ * 
  * @cont: previously registered container to remove
  */
 int
 attribute_container_unregister(struct attribute_container *cont)
 {
-	int retval = -EBUSY;
 	mutex_lock(&attribute_container_mutex);
 	spin_lock(&cont->containers.k_lock);
-	if (!list_empty(&cont->containers.k_list))
-		goto out;
-	retval = 0;
-	list_del(&cont->node);
- out:
+	if (!list_empty(&cont->containers.k_list)) 
+		cont->flags |= ATTRIBUTE_CONTAINER_EVENT_PENDING;
 	spin_unlock(&cont->containers.k_lock);
 	mutex_unlock(&attribute_container_mutex);
-	return retval;
-		
+	wait_event(cont->cont_wait,
+			 !(cont->flags & ATTRIBUTE_CONTAINER_EVENT_PENDING));
+	mutex_lock(&attribute_container_mutex);
+	list_del(&cont->node);
+	mutex_unlock(&attribute_container_mutex);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(attribute_container_unregister);
 
@@ -234,6 +240,15 @@ attribute_container_remove_device(struct
 				class_device_unregister(&ic->classdev);
 			}
 		}
+
+		if (cont->flags & ATTRIBUTE_CONTAINER_EVENT_PENDING) {
+			spin_lock(&cont->containers.k_lock);
+			if (list_empty(&cont->containers.k_list)) 
+				cont->flags &= 
+					~ATTRIBUTE_CONTAINER_EVENT_PENDING;
+			spin_unlock(&cont->containers.k_lock);
+			wake_up(&cont->cont_wait);
+		}
 	}
 	mutex_unlock(&attribute_container_mutex);
 }
diff -upNr a/include/linux/attribute_container.h b/include/linux/attribute_container.h
--- a/include/linux/attribute_container.h	2007-08-16 03:00:10.000000000 -0400
+++ b/include/linux/attribute_container.h	2007-08-17 03:46:01.000000000 -0400
@@ -20,7 +20,9 @@ struct attribute_container {
 	struct class_device_attribute **attrs;
 	int (*match)(struct attribute_container *, struct device *);
 #define	ATTRIBUTE_CONTAINER_NO_CLASSDEVS	0x01
+#define	ATTRIBUTE_CONTAINER_EVENT_PENDING	0x02
 	unsigned long		flags;
+	wait_queue_head_t       cont_wait;
 };
 
 static inline int



