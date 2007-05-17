From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: Let users disable SCSI_WAIT_SCAN to be built
Date: Thu, 17 May 2007 10:00:07 -0400
Message-ID: <1179410407.3785.16.camel@mulgrave.il.steeleye.com>
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
	 <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
	 <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
	 <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
	 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <17841.simon.1179228389@5ec7c279.invalid>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <tkrat.99c0f1a1898aa67f@s5r6.in-berlin.de>
	 <464B1886.1060502@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37532 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754331AbXEQOAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 10:00:17 -0400
In-Reply-To: <464B1886.1060502@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Simon Arlott <simon@fire.lp0.eu>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-packagers@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Wed, 2007-05-16 at 16:43 +0200, Stefan Richter wrote:
> I wrote:
> > --- linux-2.6.22-rc1.orig/drivers/scsi/Kconfig
> > +++ linux-2.6.22-rc1/drivers/scsi/Kconfig
> > @@ -241,11 +241,19 @@ config SCSI_SCAN_ASYNC
> >  	  You can override this choice by specifying "scsi_mod.scan=sync"
> >  	  or async on the kernel's command line.
> >  
> > -config SCSI_WAIT_SCAN
> > +config SCSI_WAIT_SCAN_NO_Y
> >  	tristate
> >  	default m
> > -	depends on SCSI
> > -	depends on MODULES
> 
> SCSI_WAIT_SCAN_NO_Y is unnecessary, as Randy Dunlap pointed out in "Re:
> How to force Kconfig tristate into range n..m?".
> http://lkml.org/lkml/2007/5/15/320
> 
> > +
> > +config SCSI_WAIT_SCAN
> > +	tristate "Pseudo driver which waits for SCSI scanning to finish"
> > +	depends on MODULES && SCSI && SCSI_WAIT_SCAN_NO_Y
> 
> 	depends on SCSI && m
> 
> > +	help
> > +	  When loaded, this module will do nothing else than wait for
> > +	  SCSI low-level drivers to finish asynchronous scanning.
> > +	  The module will be called scsi_wait_scan.
> 
> There should be explained that it is the command "modprobe
> scsi_wait_scan" which is doing the waiting, and that this is useful or
> required in initrds.
> 
> > +	  Most people can say n here.
> 
> This sentence should probably be omitted, as it may be wrong in the
> future and unsafe already now.
> 
> I will resend an updated patch.

Please don't bother ... I really want a more considered way of fixing
this.  If everyone decides the best way is exposing this to the user,
then this is the way to do it ... however, I still don't consider this
argument made out yet.

James

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d28c14e..a6b95cd 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -242,10 +242,14 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
-	default m
+	tristate "Build Scan Wait Module"
+	depends on m
 	depends on SCSI
 	depends on MODULES
+	help
+	  The wait scan module builds a module which is used by
+	  initramdisk boots to wait for scans to complete after
+	  all SCSI modules have been loaded.  If unsure, say M here
 
 menu "SCSI Transports"
 	depends on SCSI


