From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/17] lpfc 8.3.40: Clarified the behavior of the
 lpfc_max_luns module parameter
Date: Fri, 31 May 2013 17:04:59 -0400
Message-ID: <1370034299.17258.33.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5801 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3EaVLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:11:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Clarified the behavior of the lpfc_max_luns module parameter


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-05-31 10:58:23.785057766 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -4070,11 +4070,28 @@ LPFC_VPORT_ATTR(discovery_threads, 32, 1
 		 "during discovery");
 
 /*
-# lpfc_max_luns: maximum allowed LUN.
+# lpfc_max_luns: maximum allowed LUN ID. This is the highest LUN ID that
+#    will be scanned by the SCSI midlayer when sequential scanning is
+#    used; and is also the highest LUN ID allowed when the SCSI midlayer
+#    parses REPORT_LUN responses. The lpfc driver has no LUN count or
+#    LUN ID limit, but the SCSI midlayer requires this field for the uses
+#    above. The lpfc driver limits the default value to 255 for two reasons.
+#    As it bounds the sequential scan loop, scanning for thousands of luns
+#    on a target can take minutes of wall clock time.  Additionally,
+#    there are FC targets, such as JBODs, that only recognize 8-bits of
+#    LUN ID. When they receive a value greater than 8 bits, they chop off
+#    the high order bits. In other words, they see LUN IDs 0, 256, 512,
+#    and so on all as LUN ID 0. This causes the linux kernel, which sees
+#    valid responses at each of the LUN IDs, to believe there are multiple
+#    devices present, when in fact, there is only 1.
+#    A customer that is aware of their target behaviors, and the results as
+#    indicated above, is welcome to increase the lpfc_max_luns value.
+#    As mentioned, this value is not used by the lpfc driver, only the
+#    SCSI midlayer.
 # Value range is [0,65535]. Default value is 255.
 # NOTE: The SCSI layer might probe all allowed LUN on some old targets.
 */
-LPFC_VPORT_ATTR_R(max_luns, 255, 0, 65535, "Maximum allowed LUN");
+LPFC_VPORT_ATTR_R(max_luns, 255, 0, 65535, "Maximum allowed LUN ID");
 
 /*
 # lpfc_poll_tmo: .Milliseconds driver will wait between polling FCP ring.



