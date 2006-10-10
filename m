From: akpm@osdl.org
Subject: [patch 13/36] Fix scsi/scsi_transport.h compile error
Date: Tue, 10 Oct 2006 14:41:30 -0700
Message-ID: <200610102141.k9ALfUhx025387@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40350 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965112AbWJJVmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:42:14 -0400
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
 1 files changed, 1 insertion(+)

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
