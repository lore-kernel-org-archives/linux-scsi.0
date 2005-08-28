From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] attribute container final klist fixes
Date: Sun, 28 Aug 2005 09:13:17 -0500
Message-ID: <1125238397.5048.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2955 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751169AbVH1ONU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 10:13:20 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j7SEDJA25066
	for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2005 10:13:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Since the attribute container deletes from a klist while it's walking
it, it is vulnerable to the problem (and fix) here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112485448830217

The attached fixes this (but won't compile without the above).

It also fixes the logical reversal in the traversal loop which meant
that we were never actually traversing the loop to hit this bug in the
first place.

James

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -27,6 +27,21 @@ struct internal_container {
 	struct class_device classdev;
 };
 
+static void internal_container_klist_get(struct klist_node *n)
+{
+	struct internal_container *ic =
+		container_of(n, struct internal_container, node);
+	class_device_get(&ic->classdev);
+}
+
+static void internal_container_klist_put(struct klist_node *n)
+{
+	struct internal_container *ic =
+		container_of(n, struct internal_container, node);
+	class_device_put(&ic->classdev);
+}
+
+
 /**
  * attribute_container_classdev_to_container - given a classdev, return the container
  *
@@ -57,7 +72,8 @@ int
 attribute_container_register(struct attribute_container *cont)
 {
 	INIT_LIST_HEAD(&cont->node);
-	klist_init(&cont->containers);
+	klist_init(&cont->containers,internal_container_klist_get,
+		   internal_container_klist_put);
 		
 	down(&attribute_container_mutex);
 	list_add_tail(&cont->node, &attribute_container_list);
@@ -163,8 +179,8 @@ attribute_container_add_device(struct de
 #define klist_for_each_entry(pos, head, member, iter) \
 	for (klist_iter_init(head, iter); (pos = ({ \
 		struct klist_node *n = klist_next(iter); \
-		n ? ({ klist_iter_exit(iter) ; NULL; }) : \
-			container_of(n, typeof(*pos), member);\
+		n ? container_of(n, typeof(*pos), member) : \
+			({ klist_iter_exit(iter) ; NULL; }); \
 	}) ) != NULL; )
 			
 
@@ -206,7 +222,7 @@ attribute_container_remove_device(struct
 		klist_for_each_entry(ic, &cont->containers, node, &iter) {
 			if (dev != ic->classdev.dev)
 				continue;
-			klist_remove(&ic->node);
+			klist_del(&ic->node);
 			if (fn)
 				fn(cont, dev, &ic->classdev);
 			else {


