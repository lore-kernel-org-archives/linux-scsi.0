From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix transport class corner case after rework
Date: Mon, 15 Aug 2005 16:13:19 -0500
Message-ID: <1124140399.5089.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63695 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964952AbVHOVNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:13:25 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j7FLDKA08661
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 17:13:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

If your transport class sets the ATTRIBUTE_CONTAINER_NO_CLASSDEVS flag,
then its configure method never gets called.  This patch fixes that so
that the configure method is called with a NULL classdev.

Also remove a spurious inverted comma in the transport_class comments.

James

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -237,6 +237,11 @@ attribute_container_device_trigger(struc
 		if (!cont->match(cont, dev))
 			continue;
 
+		if (attribute_container_no_classdevs(cont)) {
+			fn(cont, dev, NULL);
+			continue;
+		}
+
 		spin_lock(&cont->containers_lock);
 		list_for_each_entry_safe(ic, tmp, &cont->containers, node) {
 			if (dev == ic->classdev.dev)
diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -7,7 +7,7 @@
  * This file is licensed under GPLv2
  *
  * The basic idea here is to allow any "device controller" (which
- * would most often be a Host Bus Adapter" to use the services of one
+ * would most often be a Host Bus Adapter to use the services of one
  * or more tranport classes for performing transport specific
  * services.  Transport specific services are things that the generic
  * command layer doesn't want to know about (speed settings, line


