From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sym53c8xx: increase sg_tablesize for larger data transfers
Date: Thu, 15 Nov 2007 10:06:44 -0500
Message-ID: <473C6084.2040700@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:1556 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXKOPGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 10:06:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

This patch increases the sg_tablesize for sym53c8xx from 96 to 128,
which enables commands to transfer larger amounts of data (e.g. 512 KB
instead of 384 KB, assuming 4 KB non-adjacent pages).

In the current design of sym53c8xx, SYM_CONF_MAX_SG must be set low
enough so that (sym_fw1.a_size <= PAGE_SIZE) && (sym_fw2.a_size <=
PAGE_SIZE).  With SYM_CONF_MAX_SG == 128, sym_fw1.a_size == 3940 and
sym_fw2.a_size == 3576 (plus or minus a few bytes depending on other
configuration options).  The a_size values increase by 16 for every
additional sg vector, so SYM_CONF_MAX_SG cannot be set much higher than
128 without making more intrusive changes.

Tested on a LSI 53c1010-66.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-rc2-git5/drivers/scsi/sym53c8xx_2/sym53c8xx.h.orig	2007-11-15 09:36:03.000000000 -0500
+++ linux-2.6.24-rc2-git5/drivers/scsi/sym53c8xx_2/sym53c8xx.h	2007-11-15 09:36:11.000000000 -0500
@@ -106,7 +106,7 @@
 /*
  *  Max number of SG entries.
  */
-#define SYM_CONF_MAX_SG		(96)
+#define SYM_CONF_MAX_SG		(128)
 
 /*
  *  Driver setup structure.


