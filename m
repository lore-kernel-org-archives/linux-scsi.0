From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] Fix lpfc oops when parsing dodgy VPD
Date: Wed, 21 Mar 2007 08:41:47 -0500
Message-ID: <20070321134147.GA7119@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:47979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbXCUOqh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2007 10:46:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org


We have seen two cases where VPD on an emulex card has been incorrect
and we end up walking off the end of memory. It looks like someone made
an update (increased the length of a string) without increasing the
Length field. Then we do:

	Length -= (3+i);

And since Length is unsigned it becomes very large and we loop forever
in the encapsulating:

	while (Length > 0) {

If we make Length signed then we fall out of the loop and proceed on.

Its important to note we have only seen this in the lab and it may be
the only two cases of this in existence, but since the rest of the code
has been written to be resilient against bad VPD we may as well fix this
too.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: kernel/drivers/scsi/lpfc/lpfc_init.c
===================================================================
--- kernel.orig/drivers/scsi/lpfc/lpfc_init.c	2007-02-07 17:02:43.000000000 -0600
+++ kernel/drivers/scsi/lpfc/lpfc_init.c	2007-02-07 17:23:31.000000000 -0600
@@ -662,7 +662,7 @@
 lpfc_parse_vpd(struct lpfc_hba * phba, uint8_t * vpd, int len)
 {
 	uint8_t lenlo, lenhi;
-	uint32_t Length;
+	int Length;
 	int i, j;
 	int finished = 0;
 	int index = 0;
