From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 1/1] Cleanup namespace collision with ktimers in drivers/scsi/*53c8xx.*
Date: Tue, 25 Oct 2005 22:16:02 -0600
Message-ID: <20051026041602.GA11040@parisc-linux.org>
References: <200510251755.j9PHtd8n021013@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35778 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932530AbVJZEQF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Oct 2005 00:16:05 -0400
Content-Disposition: inline
In-Reply-To: <200510251755.j9PHtd8n021013@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: willy@debian.org, linux-scsi@vger.kernel.org, tglx@linutronix.de, James.Bottomley@steeleye.com, mingo@elte.hu

On Tue, Oct 25, 2005 at 10:55:12AM -0700, akpm@osdl.org wrote:
> Rename the time related macros in *53c8xx.* to cleanup the namespace
> collision introduced by the ktimers patch.

wowYuckMixedCase?WhatIsThisJava?

How about we just delete that crap instead?  It boots ... but I've been
up for 20 hours at this point, so I'm not prepared to guarantee I got
all the conversions right.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: drivers/scsi/ncr53c8xx.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/ncr53c8xx.c,v
retrieving revision 1.35
diff -u -p -r1.35 ncr53c8xx.c
--- drivers/scsi/ncr53c8xx.c	10 Aug 2005 16:34:07 -0000	1.35
+++ drivers/scsi/ncr53c8xx.c	26 Oct 2005 04:10:24 -0000
@@ -3481,8 +3481,8 @@ static int ncr_queue_command (struct ncb
 	**----------------------------------------------------
 	*/
 	if (np->settle_time && cmd->timeout_per_command >= HZ) {
-		u_long tlimit = ktime_get(cmd->timeout_per_command - HZ);
-		if (ktime_dif(np->settle_time, tlimit) > 0)
+		u_long tlimit = jiffies + cmd->timeout_per_command - HZ;
+		if (time_after(np->settle_time, tlimit))
 			np->settle_time = tlimit;
 	}
 
@@ -3516,7 +3516,7 @@ static int ncr_queue_command (struct ncb
 		**	Force ordered tag if necessary to avoid timeouts 
 		**	and to preserve interactivity.
 		*/
-		if (lp && ktime_exp(lp->tags_stime)) {
+		if (lp && time_after(jiffies, lp->tags_stime)) {
 			if (lp->tags_smap) {
 				order = M_ORDERED_TAG;
 				if ((DEBUG_FLAGS & DEBUG_TAGS)||bootverbose>2){ 
@@ -3524,7 +3524,7 @@ static int ncr_queue_command (struct ncb
 						"ordered tag forced.\n");
 				}
 			}
-			lp->tags_stime = ktime_get(3*HZ);
+			lp->tags_stime = jiffies + 3*HZ;
 			lp->tags_smap = lp->tags_umap;
 		}
 
@@ -3792,7 +3792,7 @@ static int ncr_reset_scsi_bus(struct ncb
 	u32 term;
 	int retv = 0;
 
-	np->settle_time	= ktime_get(settle_delay * HZ);
+	np->settle_time	= jiffies + settle_delay * HZ;
 
 	if (bootverbose > 1)
 		printk("%s: resetting, "
@@ -5044,7 +5044,7 @@ static void ncr_setup_tags (struct ncb *
 
 static void ncr_timeout (struct ncb *np)
 {
-	u_long	thistime = ktime_get(0);
+	u_long	thistime = jiffies;
 
 	/*
 	**	If release process in progress, let's go
@@ -5057,7 +5057,7 @@ static void ncr_timeout (struct ncb *np)
 		return;
 	}
 
-	np->timer.expires = ktime_get(SCSI_NCR_TIMER_INTERVAL);
+	np->timer.expires = jiffies + SCSI_NCR_TIMER_INTERVAL;
 	add_timer(&np->timer);
 
 	/*
@@ -5336,8 +5336,8 @@ void ncr_exception (struct ncb *np)
 	**=========================================================
 	*/
 
-	if (ktime_exp(np->regtime)) {
-		np->regtime = ktime_get(10*HZ);
+	if (time_after(jiffies, np->regtime)) {
+		np->regtime = jiffies + 10*HZ;
 		for (i = 0; i<sizeof(np->regdump); i++)
 			((char*)&np->regdump)[i] = INB_OFF(i);
 		np->regdump.nc_dstat = dstat;
@@ -5453,7 +5453,7 @@ static int ncr_int_sbmc (struct ncb *np)
 		**	Suspend command processing for 1 second and 
 		**	reinitialize all except the chip.
 		*/
-		np->settle_time	= ktime_get(1*HZ);
+		np->settle_time	= jiffies + HZ;
 		ncr_init (np, 0, bootverbose ? "scsi mode change" : NULL, HS_RESET);
 		return 1;
 	}
@@ -6923,7 +6923,7 @@ static struct lcb *ncr_setup_lcb (struct
 		for (i = 0 ; i < MAX_TAGS ; i++)
 			lp->cb_tags[i] = i;
 		lp->maxnxs = MAX_TAGS;
-		lp->tags_stime = ktime_get(3*HZ);
+		lp->tags_stime = jiffies + 3*HZ;
 		ncr_setup_tags (np, sdev);
 	}
 
Index: drivers/scsi/sym53c8xx_defs.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_defs.h,v
retrieving revision 1.13
diff -u -p -r1.13 sym53c8xx_defs.h
--- drivers/scsi/sym53c8xx_defs.h	21 Feb 2005 15:26:11 -0000	1.13
+++ drivers/scsi/sym53c8xx_defs.h	26 Oct 2005 04:10:22 -0000
@@ -281,19 +281,6 @@
 #endif
 
 /*
-**	These simple macros limit expression involving 
-**	kernel time values (jiffies) to some that have 
-**	chance not to be too much incorrect. :-)
-*/
-#define ktime_get(o)		(jiffies + (u_long) o)
-#define ktime_exp(b)		((long)(jiffies) - (long)(b) >= 0)
-#define ktime_dif(a, b)		((long)(a) - (long)(b))
-/* These ones are not used in this driver */
-#define ktime_add(a, o)		((a) + (u_long)(o))
-#define ktime_sub(a, o)		((a) - (u_long)(o))
-
-
-/*
  *  IO functions definition for big/little endian CPU support.
  *  For now, the NCR is only supported in little endian addressing mode, 
  */
