From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [4/5] ncr53c8xx update
Date: Sat, 19 Mar 2005 18:32:07 -0600
Message-ID: <1111278727.5525.33.camel@mulgrave>
References: <20050319035637.16128496108@palinux.hppa>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:52653 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261761AbVCTAcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 19:32:11 -0500
In-Reply-To: <20050319035637.16128496108@palinux.hppa>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@parisc-linux.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-03-18 at 20:56 -0700, Matthew Wilcox wrote:
> ncr53c8xx update

There's actually a slight problem with this one: on my Q720 it produces
messages like this:

ncr53c720-1: ID 7, Fast-10, Parity Checking
scsi1 : ncr53c8xx-3.4.3g
 target1:0:1: target did not report SYNC.
  Vendor: TOSHIBA   Model: CD-ROM XM-5401TA  Rev: 3605
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target1:0:1: Beginning Domain Validation
 target1:0:1: asynchronous.
 target1:0:1: Domain Validation skipping write tests
 target1:0:1: FAST-5 SCSI 4.2 MB/s ST (236 ns, offset 8)
 target1:0:1: Ending Domain Validation

Although everything is fine.  The initial "target did not report SYNC"
is because the driver is trying to negotiate over the initial inquiry
(so, naturally we don't know if it supports sync yet).  The solution is
to rip out the last remnants of the spontaneous attempts at negotiation
to force it to wait for the DV negotiation in slave_configure.

James

===== drivers/scsi/ncr53c8xx.c 1.53 vs edited =====
--- 1.53/drivers/scsi/ncr53c8xx.c	2005-03-18 21:36:11 -06:00
+++ edited/drivers/scsi/ncr53c8xx.c	2005-03-19 17:57:28 -06:00
@@ -3278,6 +3278,7 @@
 		tp->usrsync = driver_setup.default_sync;
 		tp->usrwide = driver_setup.max_wide;
 		tp->usrtags = MAX_TAGS;
+		tp->period = 0xffff;
 		if (!driver_setup.disconnection)
 			np->target[i].usrflag = UF_NODISC;
 	}
@@ -4650,7 +4651,6 @@
 		if (tp->usrwide > np->maxwide)
 			tp->usrwide = np->maxwide;
 
-		ncr_negotiate (np, tp);
 	}
 
 	/*
@@ -6900,15 +6900,10 @@
 	unsigned char tn = sdev->id, ln = sdev->lun;
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
-	struct scsi_target *starget = sdev->sdev_target;
 
 	/* If no lcb, try to allocate it.  */
 	if (!lp && !(lp = ncr_alloc_lcb(np, tn, ln)))
 		goto fail;
-
-	/* Prepare negotiation */
-	if (spi_support_wide(starget) || spi_support_sync(starget))
-		ncr_negotiate(np, tp);
 
 	/*
 	**	If unit supports tagged commands, allocate the 


