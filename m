From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Bug 7994] New: sleeping function called from invalid context
 at mm/slab.c:3034
Date: Tue, 13 Feb 2007 06:56:35 -0800
Message-ID: <45D1D1A3.50500@torque.net>
References: <200702130307.l1D378vc003798@fire-2.osdl.org>	 <20070212200620.7320b3be.akpm@linux-foundation.org> <1171376251.3382.0.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050103080506070408060302"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40752 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXBMO4m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2007 09:56:42 -0500
In-Reply-To: <1171376251.3382.0.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, adrakoa@es.gnu.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

This is a multi-part message in MIME format.
--------------050103080506070408060302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Mon, 2007-02-12 at 20:06 -0800, Andrew Morton wrote:
>> This is fixed in mainline and I expect that the fix is also lined up
>> for
>> 2.6.20.1. (?)
> 
> It's definitely in mainline.  I've cc'd Doug Gilbert, the scsi_debug
> maintainer to assess what should be done for 2.6.20.1

James,
I thought this had been addressed but I can't find a
trail on my laptop. A minimal patch is attached.


ChangeLog:
   - Use GFP_ATOMIC for allocations that can be called
     from the queuecommand() entry point

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert




--------------050103080506070408060302
Content-Type: text/x-patch;
 name="sdebug2620atom.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug2620atom.diff"

--- linux/drivers/scsi/scsi_debug.c	2006-11-30 07:00:01.000000000 -0800
+++ linux/drivers/scsi/scsi_debug.c2620atom	2007-02-13 06:43:28.000000000 -0800
@@ -954,7 +954,7 @@
 	int alloc_len, n, ret;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
-	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_KERNEL);
+	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (devip->wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
@@ -1217,7 +1217,7 @@
 	alen = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
 		+ cmd[9]);
 
-	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_KERNEL);
+	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
 	/*
 	 * EVPD page 0x88 states we have two ports, one
 	 * real and a fake port with no device connected.
@@ -2044,7 +2044,7 @@
 		}
 	}
 	if (NULL == open_devip) { /* try and make a new one */
-		open_devip = kzalloc(sizeof(*open_devip),GFP_KERNEL);
+		open_devip = kzalloc(sizeof(*open_devip),GFP_ATOMIC);
 		if (NULL == open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
 				__FUNCTION__, __LINE__);

--------------050103080506070408060302--
