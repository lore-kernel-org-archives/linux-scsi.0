From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH] make sym53c8xx_2 not reject autosense IWR
Date: Wed, 11 Jun 2003 12:59:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000c01c3303a$e0251970$e0019d89@cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:27653 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S262861AbTFKQqG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2003 12:46:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr
Cc: linux-scsi@vger.kernel.org

This patch against recent 2.4.x makes sym53c8xx_2 silently ignore the Ignore
Wide Residue message on autosense commands rather than rejecting it.  This
makes the SCSI communications cleaner for targets that return an odd number
of sense bytes.

Anthony J. Battersby
Cybernetics

--- drivers/scsi/sym53c8xx_2/sym_hipd.c.orig	Wed Jun 11 12:29:11 2003
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c	Wed Jun 11 12:38:54 2003
@@ -4641,7 +4641,10 @@
 		case M_IGN_RESIDUE:
 			if (DEBUG_FLAGS & DEBUG_POINTER)
 				sym_print_msg(cp,"ign wide residue", np->msgin);
-			sym_modify_dp(np, tp, cp, -1);
+			if (cp->host_flags & HF_SENSE)
+				OUTL_DSP (SCRIPTA_BA (np, clrack));
+			else
+				sym_modify_dp(np, tp, cp, -1);
 			return;
 		case M_REJECT:
 			if (INB (HS_PRT) == HS_NEGOTIATE)

