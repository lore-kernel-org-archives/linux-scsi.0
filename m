From: =?iso-8859-1?B?SvxyZ2VuIEUu?= Fischer <fischer@linux-buechse.de>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Thu, 2 Aug 2007 22:22:16 +0200
Message-ID: <20070802202216.GA26321@linux-buechse.de>
References: <46ACE62F.4070108@panasas.com> <46ACEA0A.5040101@panasas.com> <20070730171331.5237bb94.rdunlap@xenotime.net> <46AEEBF7.3060808@panasas.com> <20070731114021.488735ec.rdunlap@xenotime.net> <1185976274.3468.70.camel@localhost.localdomain> <20070801093422.f986597d.rdunlap@xenotime.net> <46B1BF77.6060804@panasas.com> <20070802120926.63a76fce.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.179]:59414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364AbXHBUSE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 16:18:04 -0400
Content-Disposition: inline
In-Reply-To: <20070802120926.63a76fce.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "David A. Hinds" <dahinds@users.sourceforge.net>

Hi Randy,

On Thu, Aug 02, 2007 at 12:09:26 -0700, Randy Dunlap wrote:
> > 6. One more second passes and 2nd abort comes in.
> > 7. Than a reset comes in. Here too Should driver check for hardware
> >    presence.
> > 
> > since ds.c is doing: p_dev->_removed=1;
> > before the shutdown. Maybe a solution is to have aha152x_stub.c,
> > which is the only one that knows of PCMCIA, Override queuecommand
> > and just check for p_dev->_removed==1. Something like:

> This makes sense, but it didn't work:

Looks like that's just because aha152x_bus_reset_host locks up when
debugging output is on.


--- a/aha152x.c	2007-08-02 21:27:12.756833348 +0200
+++ b/aha152x.c	2007-08-02 21:28:12.320227674 +0200
@@ -1102,7 +1102,7 @@
 
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
-		printk(DEBUG_LEAD "abort(%p)", CMDINFO(SCpnt), SCpnt);
+		printk(DEBUG_LEAD "abort(%p)\n", CMDINFO(SCpnt), SCpnt);
 		show_queues(shpnt);
 	}
 #endif
@@ -1267,15 +1267,15 @@
 {
 	unsigned long flags;
 
-	DO_LOCK(flags);
-
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
-		printk(KERN_DEBUG "scsi%d: bus reset", shpnt->host_no);
+		printk(KERN_DEBUG "scsi%d: bus reset\n", shpnt->host_no);
 		show_queues(shpnt);
 	}
 #endif
 
+	DO_LOCK(flags);
+
 	free_hard_reset_SCs(shpnt, &ISSUE_SC);
 	free_hard_reset_SCs(shpnt, &DISCONNECTED_SC);
 
