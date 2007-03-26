From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
Date: Mon, 26 Mar 2007 22:31:31 +0200 (CEST)
Message-ID: <tkrat.df2afe7ddab6f326@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
 <4607CA5A.4040906@s5r6.in-berlin.de> <20070326200257.GA28622@infradead.org>
 <Pine.LNX.4.64.0703261604190.32748@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fallback-mx.in-berlin.de ([192.109.42.17]:41266 "EHLO
	fallback-mx.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbXCZVOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2007 17:14:46 -0400
Received: from einhorn.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
	by fallback-mx.in-berlin.de (8.13.6/8.13.6/Debian-1) with ESMTP id l2QKWYv9010464
	for <linux-scsi@vger.kernel.org>; Mon, 26 Mar 2007 22:32:34 +0200
In-Reply-To: <Pine.LNX.4.64.0703261604190.32748@CPE00045a9c397f-CM001225dbafb6>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Robert P. J. Day" <rpjday@mindspring.com>

On 26 Mar, Robert P. J. Day wrote:
> On Mon, 26 Mar 2007, Christoph Hellwig wrote:
>> In the old days pcmcia drivers had to be modular because pcmcia
>> required a lot of userspace setup.  It's not needed anymore these
>> days and the dependencies can go.
> 
> i'd suspected something along those lines, which is why i submitted
> the patch below to the LKML just a while ago.  if anyone wants to pick
> it up and apply it somewhere, feel free.

James,
maybe you want to take it since it's for drivers/scsi/pcmcia/Kconfig.


Date: Sun, 25 Mar 2007 13:59:36 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH] PCMCIA: Allow PCMCIA SCSI drivers to be built into the kernel.

Remove the Kconfig requirement that the PCMCIA SCSI drivers be built
only as modules, and allow them to be built into the kernel.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

i imagine there's a historical reason for these drivers being forced
to be built only as modules.  and i'm not sure whether i should have
CCed the SCSI folks, the PCMCIA folks, or both.  or whatever.

compile-tested on x86 with "make allyesconfig".

diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index eac8e17..7dd787f 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -3,11 +3,11 @@
 #

 menu "PCMCIA SCSI adapter support"
-	depends on SCSI!=n && PCMCIA!=n && MODULES
+	depends on SCSI!=n && PCMCIA!=n

 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
-	depends on m && !64BIT
+	depends on !64BIT
 	select SCSI_SPI_ATTRS
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
@@ -18,7 +18,6 @@ config PCMCIA_AHA152X

 config PCMCIA_FDOMAIN
 	tristate "Future Domain PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -28,7 +27,7 @@ config PCMCIA_FDOMAIN

 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
-	depends on m && !64BIT
+	depends on !64BIT
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
 	  your computer, say Y here and read
@@ -62,7 +61,6 @@ config PCMCIA_NINJA_SCSI

 config PCMCIA_QLOGIC
 	tristate "Qlogic PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -72,7 +70,6 @@ config PCMCIA_QLOGIC

 config PCMCIA_SYM53C500
 	tristate "Symbios 53c500 PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you have a New Media Bus Toaster or other PCMCIA
 	  SCSI adapter based on the Symbios 53c500 controller.


