From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] add missing class_device_del to transport classes
Date: Wed, 26 Jan 2005 15:59:26 -0800
Message-ID: <41F82EDE.3040905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080808020809000600070700"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45740 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262223AbVAZX7g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2005 18:59:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080808020809000600070700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James,

It appears there is a missing class_device_del.
The comments for transport_remove_device indicate
that transport_remove_classdev should call it
(which the attached patch does), but the comment in
attribute_container_remove_device:

  If you want a
  * two phase release: remove from visibility and then delete the
  * device, then you should use this routine with a fn that calls
  * class_device_del() and then use
  * attribute_container_device_trigger() to do the final put on the
  * classdev.

Indicate that maybe transport_destroy_classdev and
transport_remove_device are incorrect. However,
attribute_container_remove_device will do a
list_del(&ic->node); so that later calls to
attribute_container_device_trigger would not be able
to do the final put on that classdev. I assumed the
comments in attribute_container_remove_device
are incorrect, so the attached patch made against
scsi-rc-fixes-2.6 adds a call to class_device_del
to transport_remove_classdev.

I did not fix the comments in attribute_container_remove_device
becuase I was not 100% certain what is the correct behavior or
usage.

Mike


--------------080808020809000600070700
Content-Type: text/x-patch;
 name="add-classdev-del.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-classdev-del.patch"

--- scsi-rc-fixes-2.6.orig/drivers/base/transport_class.c	2005-01-25 13:30:27.000000000 -0800
+++ scsi-rc-fixes-2.6.newtest/drivers/base/transport_class.c	2005-01-26 15:22:52.000000000 -0800
@@ -216,10 +216,16 @@ static int transport_remove_classdev(str
 				     struct class_device *classdev)
 {
 	struct transport_class *tclass = class_to_transport_class(cont->class);
+	struct class_device_attribute **attrs = cont->attrs;
+	int i;
 
 	if (tclass->remove)
 		tclass->remove(dev);
 
+	for (i = 0; attrs[i]; i++)
+		class_device_remove_file(classdev, attrs[i]);
+	class_device_del(classdev);
+
 	return 0;
 }
 

--------------080808020809000600070700--
