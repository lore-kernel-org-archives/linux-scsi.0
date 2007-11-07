From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sym53c8xx: fix setflag user command to control disconnects
Date: Wed, 07 Nov 2007 15:37:47 -0500
Message-ID: <4732221B.1000104@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:2266 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbXKGUho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 15:37:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

This patch fixes the sym53c8xx "setflag" user command to control
disconnect privilege, which has been broken for a long time.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

NOTE regarding the following change:

 	can_disconnect = (cp->tag != NO_TAG) ||
-		(lp && (lp->curr_flags & SYM_DISC_ENABLED));
+		(lp && (tp->usrflags & SYM_DISC_ENABLED));

In 2.4 kernels, lp == NULL when scanning for devices, and allowing
disconnect when lp == NULL would confuse the code that handles
reselection.  So with 2.4 kernels, the check for lp != NULL had to be
left in even if lp wasn't being dereferenced.  In 2.6 kernels,
lp != NULL when scanning for devices.  In fact, I didn't encounter any
cases where lp == NULL during my testing with 2.6 kernels, so the check
for lp != NULL may be superfluous now.  However, the same check is
performed in other places in the same function, so I left it in to be
safe.

diff -urpN linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-11-07 15:05:22.000000000 -0500
+++ linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-11-07 15:06:41.000000000 -0500
@@ -785,11 +785,6 @@ static int sym53c8xx_slave_configure(str
 	int reqtags, depth_to_use;
 
 	/*
-	 *  Get user flags.
-	 */
-	lp->curr_flags = lp->user_flags;
-
-	/*
 	 *  Select queue depth from driver setup.
 	 *  Donnot use more than configured by user.
 	 *  Use at least 2.
@@ -937,7 +932,9 @@ static void sym_exec_user_command (struc
 				OUTB(np, nc_istat, SIGP|SEM);
 				break;
 			case UC_SETFLAG:
-				tp->usrflags = uc->data;
+				tp->usrflags =
+					(tp->usrflags & ~SYM_DISC_ENABLED) |
+					uc->data;
 				break;
 			}
 		}
@@ -1098,6 +1095,7 @@ printk("sym_user_command: data=%ld\n", u
 		break;
 #endif /* SYM_LINUX_DEBUG_CONTROL_SUPPORT */
 	case UC_SETFLAG:
+		uc->data = SYM_DISC_ENABLED;
 		while (len > 0) {
 			SKIP_SPACES(ptr, len);
 			if	((arg_len = is_keyword(ptr, len, "no_disc")))
diff -urpN linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.c linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-11-07 15:05:22.000000000 -0500
+++ linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-11-07 15:06:41.000000000 -0500
@@ -4984,11 +4984,6 @@ struct sym_lcb *sym_alloc_lcb (struct sy
 	 */
 	lp->head.resel_sa = cpu_to_scr(SCRIPTB_BA(np, resel_bad_lun));
 
-	/*
-	 *  Set user capabilities.
-	 */
-	lp->user_flags = tp->usrflags & (SYM_DISC_ENABLED | SYM_TAGS_ENABLED);
-
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	/*
 	 *  Initialize device queueing.
@@ -5077,7 +5072,7 @@ int sym_queue_scsiio(struct sym_hcb *np,
 	lp = sym_lp(tp, sdev->lun);
 
 	can_disconnect = (cp->tag != NO_TAG) ||
-		(lp && (lp->curr_flags & SYM_DISC_ENABLED));
+		(lp && (tp->usrflags & SYM_DISC_ENABLED));
 
 	msgptr = cp->scsi_smsg;
 	msglen = 0;
diff -urpN linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.h linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.h	2007-11-07 15:05:22.000000000 -0500
+++ linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.h	2007-11-07 15:06:41.000000000 -0500
@@ -536,12 +536,6 @@ struct sym_lcb {
 	 *  Set when we want to clear all tasks.
 	 */
 	u_char to_clear;
-
-	/*
-	 *  Capabilities.
-	 */
-	u_char	user_flags;
-	u_char	curr_flags;
 };
 
 /*


