From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
Date: Mon, 26 Mar 2007 16:06:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703261604190.32748@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
 <4607CA5A.4040906@s5r6.in-berlin.de> <20070326200257.GA28622@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:48046 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbXCZUQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2007 16:16:39 -0400
In-Reply-To: <20070326200257.GA28622@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Mon, 26 Mar 2007, Christoph Hellwig wrote:

> > >   it would seem to make no sense that the "depends on" clause
> > > for this option includes "m", forcing this (and all other four
> > > entries in that Kconfig file, by the way) to be built as
> > > modules, while the help text for all five entries suggests you
> > > can select "y".
>
> In the old days pcmcia drivers had to be modular because pcmcia
> required a lot of userspace setup.  It's not needed anymore these
> days and the dependencies can go.

i'd suspected something along those lines, which is why i submitted
the patch below to the LKML just a while ago.  if anyone wants to pick
it up and apply it somewhere, feel free.

(i dropped the LKML from the CC list, i don't think they need to see
any more of this.)



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
