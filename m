From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 8/11] [SYM2] Use scsi_print_msg
Date: Tue, 29 Nov 2005 23:08:42 -0500 (EST)
Message-ID: <20051130040842.7C4F17626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:58325 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1750862AbVK3EIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:45 -0500
Received: from mail3.magma.ca (mail3.magma.ca [206.191.0.221])
	by mx1.magmacom.com (8.13.0/8.13.0) with ESMTP id jAU48hVQ002598
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:44 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail3.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48gRA005470
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:43 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

sym_show_msg was almost a duplicate of scsi_print_msg, except not as
featureful.  So use the common code instead.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

applies-to: eae46886d0779efc27461f36450ee16cbf776e29
b8a84ef674909ad4f46015e2ad9c512e17ecc6d3
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index aa5404d..5cc1420 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -40,6 +40,7 @@
 
 #include <linux/slab.h>
 #include <asm/param.h>		/* for timeouts in units of HZ */
+#include <scsi/scsi_dbg.h>
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -70,32 +71,12 @@ static void sym_printl_hex(u_char *p, in
 	printf (".\n");
 }
 
-/*
- *  Print out the content of a SCSI message.
- */
-static int sym_show_msg (u_char * msg)
-{
-	u_char i;
-	printf ("%x",*msg);
-	if (*msg==M_EXTENDED) {
-		for (i=1;i<8;i++) {
-			if (i-1>msg[1]) break;
-			printf ("-%x",msg[i]);
-		}
-		return (i+1);
-	} else if ((*msg & 0xf0) == 0x20) {
-		printf ("-%x",msg[1]);
-		return (2);
-	}
-	return (1);
-}
-
 static void sym_print_msg(struct sym_ccb *cp, char *label, u_char *msg)
 {
 	sym_print_addr(cp->cmd, "%s: ", label);
 
-	sym_show_msg(msg);
-	printf(".\n");
+	scsi_print_msg(msg);
+	printf("\n");
 }
 
 static void sym_print_nego_msg(struct sym_hcb *np, int target, char *label, u_char *msg)
@@ -103,8 +84,8 @@ static void sym_print_nego_msg(struct sy
 	struct sym_tcb *tp = &np->target[target];
 	dev_info(&tp->starget->dev, "%s: ", label);
 
-	sym_show_msg(msg);
-	printf(".\n");
+	scsi_print_msg(msg);
+	printf("\n");
 }
 
 /*
---
0.99.9.GIT
