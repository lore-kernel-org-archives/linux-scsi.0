From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] sym53c8xx_2 error handler fix
Date: Mon, 1 Nov 2004 16:25:58 -0500
Message-ID: <04Nov1.162535est.332407@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:25101 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S319846AbUKAVZl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2004 16:25:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Marcelo Tosatti' <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org

The sym53c8xx_2 driver in lk 2.4.x is unmaintained.  This is a backported
fix from lk 2.6.x for a problem with the error handler never successfully
completing an abort, bus reset, device reset, or host reset.  This patch has
been well tested at my company.  Please apply.

--- linux-2.4.26-vanilla/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Nov 28 18:53:14 2002
+++ linux-2.4.26-asp/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri May 21 11:43:51 2004
@@ -1149,7 +1149,6 @@
 	switch(to_do) {
 	default:
 	case SYM_EH_DO_IGNORE:
-		goto finish;
 		break;
 	case SYM_EH_DO_WAIT:
 #if LINUX_VERSION_CODE > LinuxVersionCode(2,3,0)
@@ -1193,7 +1192,6 @@
 		to_do = SYM_EH_DO_IGNORE;
 	}
 
-finish:
 	ep->to_do = to_do;
 	/* Complete the command with locks held as required by the driver */
 	if (to_do == SYM_EH_DO_COMPLETE)


Anthony J. Battersby
Cybernetics

