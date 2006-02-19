From: =?iso-8859-1?B?SvxyZ2VuIEUu?= Fischer <fischer@linux-buechse.de>
Subject: Re: [Bugme-new] [Bug 6092] New: drivers/scsi/pcmcia/aha152x_stub.c: aha152x_resume(): variable used before set
Date: Sun, 19 Feb 2006 16:08:04 +0100
Message-ID: <20060219150804.GA16578@linux-buechse.de>
References: <200602180209.k1I29meW030162@fire-2.osdl.org> <20060217211049.4368ff20.akpm@osdl.org> <20060218221039.GA3912@linux-buechse.de> <20060218141423.7d741859.akpm@osdl.org> <20060218233151.GA1985@linux-buechse.de> <1140359237.3103.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:9210 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S932582AbWBSPJR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 10:09:17 -0500
Content-Disposition: inline
In-Reply-To: <1140359237.3103.9.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

Hi James,

On Sun, Feb 19, 2006 at 08:27:17 -0600, James Bottomley wrote:
> >         HOSTDATA(shpnt)->in_intr++;
> >  
> > +       if( HOSTDATA(shpnt)->service==0 )  {
> > +               DO_UNLOCK(flags);
> > +               return;
> > +       }
> 
> Looks a bit wrong.  If that ever triggered, you'd exit your task handler
> with in_intr raised, which would cause a panic the next time
> is_complete() was called.

ouch, but thanks for the understatement. ;)


> The driver still seems to have an awful lot of locking confusion between
> the host lock and its own internal lock (stored in the host structure).
> I think there are several races and other nasties that could be cleaned
> up simply by moving to using the host lock everywhere.

done.

patch:
- drop private lock and use host_lock instead.

Signed-off-by: Juergen E. Fischer <fischer@linux-buechse.de>

--- aha152x.c	2006-02-19 15:54:24.315291253 +0100
+++ linux-2.6/drivers/scsi/aha152x.c	2006-02-19 16:00:45.817015449 +0100
@@ -465,9 +465,6 @@
 	Scsi_Cmnd *done_SC;
 		/* command that was completed */
 
-	spinlock_t lock;
-		/* host lock */
-
 #if defined(AHA152X_DEBUG)
 	const char *locker;
 		/* which function has the lock */
@@ -563,7 +560,7 @@
 #define DONE_SC			(HOSTDATA(shpnt)->done_SC)
 #define ISSUE_SC		(HOSTDATA(shpnt)->issue_SC)
 #define DISCONNECTED_SC		(HOSTDATA(shpnt)->disconnected_SC)
-#define QLOCK			(HOSTDATA(shpnt)->lock)
+#define QLOCK			((shpnt)->host_lock)
 #define QLOCKER			(HOSTDATA(shpnt)->locker)
 #define QLOCKERL		(HOSTDATA(shpnt)->lockerl)
 
@@ -802,7 +799,6 @@
 		HOSTIOPORT1 = setup->io_port-0x10;
 	}
 
-	spin_lock_init(&QLOCK);
 	RECONNECT   = setup->reconnect;
 	SYNCHRONOUS = setup->synchronous;
 	PARITY      = setup->parity;
@@ -2539,6 +2535,13 @@
 
 	DO_LOCK(flags);
 
+	if( HOSTDATA(shpnt)->service==0 )  {
+		DO_UNLOCK(flags);
+		return;
+	}
+
+	HOSTDATA(shpnt)->service = 0;
+
 	if(HOSTDATA(shpnt)->in_intr) {
 		DO_UNLOCK(flags);
 		/* aha152x_error never returns.. */
@@ -2546,13 +2549,6 @@
 	}
 	HOSTDATA(shpnt)->in_intr++;
 
-	if (HOSTDATA(shpnt)->service == 0) {
-		DO_UNLOCK(flags);
-		return;
-	}
-
-	HOSTDATA(shpnt)->service = 0;
-
 
 	/*
 	 * loop while there are interrupt conditions pending

