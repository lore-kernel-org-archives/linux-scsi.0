From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sym53c8xx: fix resid calculation
Date: Tue, 06 Nov 2007 16:07:04 -0500
Message-ID: <4730D778.9040807@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:1344 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbXKFVHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 16:07:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

This patch fixes the calculation of the data transfer residual for the
case of a command that is supposed to transfer an odd number of bytes on
a wide bus but transfers nothing instead.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-rc1-git15/drivers/scsi/sym53c8xx_2/sym_hipd.c.orig	2007-11-06 15:51:12.000000000 -0500
+++ linux-2.6.24-rc1-git15/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-11-06 15:51:44.000000000 -0500
@@ -3842,7 +3842,7 @@ int sym_compute_residual(struct sym_hcb 
 	if (cp->startp == cp->phys.head.lastp ||
 	    sym_evaluate_dp(np, cp, scr_to_cpu(cp->phys.head.lastp),
 			    &dp_ofs) < 0) {
-		return cp->data_len;
+		return cp->data_len - cp->odd_byte_adjustment;
 	}
 
 	/*


