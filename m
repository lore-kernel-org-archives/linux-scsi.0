From: peter fuerst <post@pfrst.de>
Subject: [PATCH][SCSI] sgiwd93.c: interfacing to wd33c93
Date: Mon, 12 Feb 2007 15:27:17 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0702121522570.433@Indigo2.Peter>
Reply-To: post@pfrst.de
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.pearl-online.net ([62.159.194.147]:17817 "EHLO
	mail1.pearl-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbXBLOtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 09:49:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Kumba <kumba@gentoo.org>, Thiemo Seufer <ths@networkno.de>, Tim Yamin <plasmaroo@gentoo.org>



1) sgiwd93 used to switch off asynchronous mode on the wd33c93, discarding
   any "nosync"-requests from the commandline.
   But we need to allow "nosync"-requests for selected devices, for example
   the Pioneer DVD305S.
   (For the curious: this device accepts the SDTR from wd33c93 and success-
   fully sends inquiry data in sync mode, but after the data phase in the
   inquiry command does an unexpected disconnect, seemingly sending no
   "status" or "command complete". Forcing async transfers makes it work
   together flawlessly with the wd33c93. Of course, preferable would be, to
   implement wd33c93's "resume command" stuff, but that probably will not
   come soon.)

2) Maximize benefit from the preceding Fast SCSI patch for wd33c93 by passing
   the higher input-clock frequency explicitely. To be applied after the
   mentioned wd33c93 patch.


with kind regards


Signed-off-by: peter fuerst <post@pfrst.de>

========================================================================
--- dc7bdc97927ea1c519f0d8bd3133739600c841d4/drivers/scsi/sgiwd93.c	Sat Oct  7 00:00:00 2006
+++ new/drivers/scsi/sgiwd93.c	Sun Feb 11 22:10:06 2007
@@ -250,3 +250,3 @@

-	hdata->wh.no_sync = 0;
+	if (0xff == hdata->wh.no_sync) hdata->wh.no_sync = 0;

========================================================================


========================================================================
--- dc7bdc97927ea1c519f0d8bd3133739600c841d4/drivers/scsi/sgiwd93.c	Sat Oct  7 00:00:00 2006
+++ stage2/drivers/scsi/sgiwd93.c	Sun Feb 11 22:10:06 2007
@@ -248,3 +248,3 @@

-	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_16_20);
+	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_MHZ(20));

========================================================================
