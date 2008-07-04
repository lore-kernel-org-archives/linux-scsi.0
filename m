From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] move memory_read_from_buffer() from fs.h to string.h
Date: Sat, 5 Jul 2008 01:39:43 +0900
Message-ID: <20080704163942.GA15214@localhost.localdomain>
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org> <1215182555.5413.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:22028 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbYGDQjz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 12:39:55 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1619318rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jul 2008 09:39:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1215182555.5413.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, linux-driver@qlogic.com, seokmann.ju@qlogic.com, linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 09:42:35AM -0500, James Bottomley wrote:
> For such a micro optimisation, this is a pretty big price to pay.
> 
> Inclusion of linux/fs.h in a low level driver was always a danger signal
> usually it meant the driver was trying to access files or something at
> the very least it was a warning of a potential layering violation.  Now
> you're trying to make it standard practice ... I really don't like that.
> Surely a function that does memory to memory copies belongs either in
> string.h with the rest of our memory copies ... or in another header
> that would be a usual include for the potential users.

OK, I'll move it to linux/string.h

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] move memory_read_from_buffer() from fs.h to string.h

James Bottomley warns that inclusion of linux/fs.h in a low level driver
was always a danger signal. This patch moves memory_read_from_buffer()
from fs.h to string.h and fixes includes in existing memory_read_from_buffer()
users.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/system.c       |    1 +
 drivers/zorro/zorro-sysfs.c |    1 -
 include/linux/fs.h          |    2 --
 include/linux/string.h      |    3 +++
 4 files changed, 4 insertions(+), 3 deletions(-)

Index: 2.6-mm/include/linux/fs.h
===================================================================
--- 2.6-mm.orig/include/linux/fs.h
+++ 2.6-mm/include/linux/fs.h
@@ -2026,8 +2026,6 @@ extern void simple_release_fs(struct vfs
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
-			const void *from, size_t available);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
Index: 2.6-mm/include/linux/string.h
===================================================================
--- 2.6-mm.orig/include/linux/string.h
+++ 2.6-mm/include/linux/string.h
@@ -111,5 +111,8 @@ extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
 
+extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+			const void *from, size_t available);
+
 #endif
 #endif /* _LINUX_STRING_H_ */
Index: 2.6-mm/drivers/acpi/system.c
===================================================================
--- 2.6-mm.orig/drivers/acpi/system.c
+++ 2.6-mm/drivers/acpi/system.c
@@ -26,6 +26,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/string.h>
 #include <asm/uaccess.h>
 
 #include <acpi/acpi_drivers.h>
Index: 2.6-mm/drivers/zorro/zorro-sysfs.c
===================================================================
--- 2.6-mm.orig/drivers/zorro/zorro-sysfs.c
+++ 2.6-mm/drivers/zorro/zorro-sysfs.c
@@ -15,7 +15,6 @@
 #include <linux/zorro.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/fs.h>
 
 #include "zorro.h"
 
