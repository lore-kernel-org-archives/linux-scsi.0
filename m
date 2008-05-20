From: Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 20 May 2008 17:55:54 +0800
Message-ID: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:24713 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764953AbYETJyr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 05:54:47 -0400
Received: by ug-out-1314.google.com with SMTP id h2so650533ugf.16
        for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 02:54:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Converting class semaphore to mutex cause lockdep warnings due to
class_interface_register/unregister will possible call device_add/del

For the class_interface users here add a class_reclassify macro to
reclassify the lock class of their struct class.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/linux/device.h |    7 +++++++
1 file changed, 7 insertions(+)

--- linux/include/linux/device.h	2008-05-19 12:29:54.000000000 +0800
+++ linux.new/include/linux/device.h	2008-05-19 14:42:25.000000000 +0800
@@ -529,4 +529,11 @@ extern const char *dev_driver_string(str
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
 #define MODULE_ALIAS_CHARDEV_MAJOR(major) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-*")
+
+#define class_reclassify(class)						\
+do {									\
+	static struct lock_class_key	class_key;			\
+	lockdep_set_class_and_name(&(class)->mutex, &class_key,		\
+				 (class)->name);			\
+} while (0)
 #endif /* _DEVICE_H_ */
