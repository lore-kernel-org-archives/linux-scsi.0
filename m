From: akpm@osdl.org
Subject: [patch 09/30] Fix scsi/scsi_transport.h compile error
Date: Mon, 04 Dec 2006 15:18:29 -0800
Message-ID: <200612042319.kB4NJc6H008751@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56730 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967770AbWLDXTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:19:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, eike-kernel@sf-tec.de

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

scsi_transport.h defines the inline function scsi_transport_device_data() that
dereferences a pointer of "struct scsi_device *".  Since the struct is not
known by the header this might break compilation.

Include scsi/scsi_device.h to not rely on users doing the correct magic
include order.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/scsi/scsi_transport.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/scsi/scsi_transport.h~fix-scsi-scsi_transporth-compile-error include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h~fix-scsi-scsi_transporth-compile-error
+++ a/include/scsi/scsi_transport.h
@@ -22,6 +22,7 @@
 
 #include <linux/transport_class.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 
 struct scsi_transport_template {
 	/* the attribute containers */
_
