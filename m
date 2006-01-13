From: Volker Kuhlmann <list0570@paradise.net.nz>
Subject: [PATCH] sym53c8xx phase change log suppression
Date: Sat, 14 Jan 2006 09:02:00 +1300
Message-ID: <20060113200200.GB12885@paradise.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 203-79-122-66.cable.paradise.net.nz ([203.79.122.66]:23900 "EHLO
	kereru.site") by vger.kernel.org with ESMTP id S1422926AbWAMUCE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 15:02:04 -0500
Received: from kereru.site (localhost [127.0.0.1])
	by kereru.site (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id k0DK20ZZ020223
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jan 2006 09:02:02 +1300
Received: (from volker@localhost)
	by kereru.site (8.13.4/8.13.4/Submit) id k0DK20aL020222
	for linux-scsi@vger.kernel.org; Sat, 14 Jan 2006 09:02:00 +1300
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I get a huge number of these phase change entries in syslog, just about
with ever SCSI transfer. That's with a scanner anyway, on AMD64. As they
seem to be harmless, this patch allows to prevent syslog being filled
by using verb=0. Perhaps verb=1 should also suppress it?

Thanks,

Volker


--- linux-2.6.13-15.7/drivers/scsi/sym53c8xx_2/sym_hipd.c.orig	2005-08-29 11:41:01.000000000 +1200
+++ linux-2.6.13-15.7/drivers/scsi/sym53c8xx_2/sym_hipd.c	2006-01-12 22:46:15.000000000 +1300
@@ -2556,6 +2556,11 @@ static void sym_int_ma (struct sym_hcb *
 	 *  if old phase not dataphase, leave here.
 	 */
 	if (cmd & 2) {
+		/* Huge number of these phase changes logged in normal use
+		   (at least with a scanner).
+		   Allow to suppress with verb=0.
+		   Volker Kuhlmann, VolkerKuhlmann@gmx.de 12 Jan 2006 */
+		if (sym_verbose >= 1)
 		sym_print_addr(cp->cmd,
 			"phase change %x-%x %d@%08x resid=%d.\n",
 			cmd&7, INB(np, nc_sbcl)&7, (unsigned)olen,

-- 
Volker Kuhlmann			is possibly list0570 with the domain in header
http://volker.dnsalias.net/		Please do not CC list postings to me.
