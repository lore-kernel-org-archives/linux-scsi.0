From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: transport_class: BUG if we can't release the attribute container
Date: Sat, 22 Mar 2008 11:39:17 -0500
Message-ID: <1206203957.4393.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41528 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255AbYCVQjW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2008 12:39:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Every current transport class calls transport_container_release but
ignores the return value.  This is catastrophic if it returns an error
because the containers are part of a global list and the next action of
almost every transport class is to free the memory used by the
container.

Fix this by making transport_container_release a void, but making it BUG
if attribute_container_release returns an error ... this catches the
root cause of a system panic much earlier.  If we don't do this, we get
an eventual BUG when the attribute container list notices the corruption
caused by the freed memory it's still referencing.

Also made attribute_container_release __must_check as a reminder.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index 40bca48..06861ae 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -108,7 +108,7 @@ EXPORT_SYMBOL_GPL(anon_transport_class_register);
  */
 void anon_transport_class_unregister(struct anon_transport_class *atc)
 {
-	attribute_container_unregister(&atc->container);
+	BUG_ON(attribute_container_unregister(&atc->container));
 }
 EXPORT_SYMBOL_GPL(anon_transport_class_unregister);
 
diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 86e1318..52182a7 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -289,7 +289,7 @@ raid_class_release(struct raid_template *r)
 {
 	struct raid_internal *i = to_raid_internal(r);
 
-	attribute_container_unregister(&i->r.raid_attrs.ac);
+	BUG_ON(attribute_container_unregister(&i->r.raid_attrs.ac));
 
 	kfree(i);
 }
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index f558233..574b201 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -37,7 +37,7 @@ attribute_container_set_no_classdevs(struct attribute_container *atc)
 }
 
 int attribute_container_register(struct attribute_container *cont);
-int attribute_container_unregister(struct attribute_container *cont);
+int __must_check attribute_container_unregister(struct attribute_container *cont);
 void attribute_container_create_device(struct device *dev,
 				       int (*fn)(struct attribute_container *,
 						 struct device *,
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 1d6cc22..e74c6dc 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -86,9 +86,9 @@ static inline int transport_container_register(struct transport_container *tc)
 	return attribute_container_register(&tc->ac);
 }
 
-static inline int transport_container_unregister(struct transport_container *tc)
+static inline void transport_container_unregister(struct transport_container *tc)
 {
-	return attribute_container_unregister(&tc->ac);
+	BUG_ON(attribute_container_unregister(&tc->ac));
 }
 
 int transport_class_register(struct transport_class *);


