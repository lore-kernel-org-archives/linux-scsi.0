From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 05/13] MegaRAID driver management char device moved to
	misc
Date: Thu, 07 Feb 2008 18:40:47 -0600
Message-ID: <1202431248.3171.44.camel@localhost.localdomain>
References: <200802050752.m157qxIX010700@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33610 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935416AbYBHAky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 19:40:54 -0500
In-Reply-To: <200802050752.m157qxIX010700@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, thomas@horsten.com, Neela.Kolli@engenio.com, Seokmann.Ju@lsil.com, thomas.horsten@gmail.com, "Patro, Sumant" <Sumant.Patro@lsi.com>


On Mon, 2008-02-04 at 23:53 -0800, akpm@linux-foundation.org wrote:
> From: Thomas Horsten <thomas@horsten.com>
> 
> The MegaRAID driver's common management module (megaraid_mm.c) creates a
> char device used by the management tool "megarc" from LSI Logic (and
> possibly other management tools).
> 
> In 2.6 with udev, this device doesn't get created because it is not
> registered in sysfs.
> 
> I first fixed this by registering a class "megaraid_mm", but realized that
> this should probably be moved to misc devices, instead of taking up a char
> major.  This is because only 1 device is used, even if there are multiple
> adapters - the minor is never used (the adapter info is in the ioctl block
> sent to the driver, not detected based on the minor number as one might
> think).  So it is a complete waste to have an entire major taken by this.
> 
> So it now uses a misc device which I named "megadev0" (the name that megarc
> expects), and has a dynamic minor (previoulsy a dynamic major was used).
> 
> I have tested this on my own system with the megarc tool, and it works just
> as fine as before (only now the device gets created correctly by udev).
> 
> Cc: <thomas.horsten@gmail.com>
> Cc: Neela Syam Kolli <Neela.Kolli@engenio.com>
> Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Neela and Sekomann or Sumant, can I ping on this ... I've no idea what
this will do to the raid management tools, so I really need someone to
sign off on this.

James


