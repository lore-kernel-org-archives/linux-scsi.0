From: akpm@linux-foundation.org
Subject: [patch 09/33] Fix scsi/scsi_transport.h compile error
Date: Mon, 05 Feb 2007 16:38:40 -0800
Message-ID: <200702060039.l160diVB004973@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965201AbXBFAj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:39:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, eike-kernel@sf-tec.de

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

scsi_transport.h defines the inline function scsi_transport_device_data() that
dereferences a pointer of "struct scsi_device *".  Since the struct is not
known by the header this might break compilation.

Include scsi/scsi_device.h to not rely on users doing the correct magic
include order.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
