From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Sym53c8xx_2
Date: Sun, 15 Aug 2004 10:21:35 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
References: <1092366037.28144.202254467@webmail.messagingengine.com>  
 <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
 <1092432298.18813.202307545@webmail.messagingengine.com>
 <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep22-0.kolumbus.fi ([193.229.0.60]:36993 "EHLO
	fep22-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S266519AbUHOHVj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Aug 2004 03:21:39 -0400
In-Reply-To: <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kai OM <epimetreus@fastmail.fm>, linux-scsi@vger.kernel.org

On Sun, 15 Aug 2004, Guennadi Liakhovetski wrote:

> Hi
> 
> On Fri, 13 Aug 2004, Kai OM wrote:
> 
> > There was one entry in the 2.6.6 changelog, though, that said something
> > about modifying the driver in question; adding generic domain validation
> > and such -- and it's during domain validation that the driver stops.
> 
> I looked through the diffs between 2.6.5 and 2.6.7 versions of sym53c8xx_2 
> - there are not so many of them, so, we'll have to able to find the guilty 
> one. In fact, I think, there are only 2 lines of code that can be 
> essential. But before you test them, one question: in your original posts 
> you quoted dmesg with 2.6.7 and 2.6.7 with replaced sym53c8xx_2 directory. 
> However, the output of the working version with the older driver is 
> missing 2 lines:
> 
> sym0:0:0: Tagged command queue enabled, command queue depth 16
> scsi(0:0:0:0): Beginning Domain Validation
> 
> which are present in the non-working version. Why are they missing from 
> the working version - did you use a different configuration or different 
> command-line parameters?
> 
You missed one essential change in 2.6.6:

@@ -908,6 +916,7 @@
 config SCSI_SYM53C8XX_2
        tristate "SYM53C8XX Version 2 SCSI support"
        depends on PCI && SCSI
+       select SCSI_SPI_ATTRS

(Many changes in sym_glue.c accompany this. You can't just remove this 
config change to try without spi.)

Because of this, the system is trying to do domain validation with the 
SCSI devices. For some reason it fails. The problem may be in the drive 
firmware, mid-level spi code, the sym53c8xxx driver, or an interaction 
with some/all of those.

Domain Validation does not fail in all configurations. I am using 
sym53c8xx_2 in two machines to drive the system disk and some other 
devices. I have had no SCSI problems with these systems.

-- 
Kai
