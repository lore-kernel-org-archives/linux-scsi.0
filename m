From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] sym53c8xx_2 Ultra 160 requires LVD
Date: Mon, 1 Nov 2004 16:26:05 -0500
Message-ID: <04Nov1.162543est.333214@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:51984 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S320881AbUKAVfD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2004 16:35:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Marcelo Tosatti' <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org

This patch prevents sym53c8xx_2 from attempting to negotiate Ultra 160 on a
SE or HVD bus, which is invalid and confuses some devices.  Please apply.

--- linux-2.4.26-vanilla/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Nov 28 18:53:14 2002
+++ linux-2.4.26-asp/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon May 10 10:15:27 2004
@@ -1469,7 +1497,8 @@
 					tp->tinfo.goal.offset  = 0;
 					break;
 				}
-				if (uc->data <= 9 && np->minsync_dt) {
+				if (uc->data <= 9 && np->minsync_dt &&
+				    np->scsi_mode == SMODE_LVD) {
 					if (uc->data < np->minsync_dt)
 						uc->data = np->minsync_dt;
 					tp->tinfo.goal.options = PPR_OPT_DT;

Anthony J. Battersby
Cybernetics

