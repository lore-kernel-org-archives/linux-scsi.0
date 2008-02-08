From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 05/13] MegaRAID driver management char device moved tomisc
Date: Thu, 7 Feb 2008 19:47:36 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229E75449@NAMAIL2.ad.lsil.com>
References: <1202431248.3171.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57749 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbYBHCsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 21:48:05 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1202431248.3171.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, thomas@horsten.com, "Kolli, Neela" <Neela.Kolli@lsi.com>, Seokmann.Ju@lsil.com, thomas.horsten@gmail.com


James, I acked this patch on 11/28.

We are fine with the change proposed.

Regards,

Sumant



-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Thursday, February 07, 2008 4:41 PM
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org; thomas@horsten.com; Kolli, Neela;
Seokmann.Ju@lsil.com; thomas.horsten@gmail.com; Patro, Sumant
Subject: Re: [patch 05/13] MegaRAID driver management char device moved
tomisc


On Mon, 2008-02-04 at 23:53 -0800, akpm@linux-foundation.org wrote:
> From: Thomas Horsten <thomas@horsten.com>
> 
> The MegaRAID driver's common management module (megaraid_mm.c) creates

> a char device used by the management tool "megarc" from LSI Logic (and

> possibly other management tools).
> 
> In 2.6 with udev, this device doesn't get created because it is not 
> registered in sysfs.
> 
> I first fixed this by registering a class "megaraid_mm", but realized 
> that this should probably be moved to misc devices, instead of taking 
> up a char major.  This is because only 1 device is used, even if there

> are multiple adapters - the minor is never used (the adapter info is 
> in the ioctl block sent to the driver, not detected based on the minor

> number as one might think).  So it is a complete waste to have an
entire major taken by this.
> 
> So it now uses a misc device which I named "megadev0" (the name that 
> megarc expects), and has a dynamic minor (previoulsy a dynamic major
was used).
> 
> I have tested this on my own system with the megarc tool, and it works

> just as fine as before (only now the device gets created correctly by
udev).
> 
> Cc: <thomas.horsten@gmail.com>
> Cc: Neela Syam Kolli <Neela.Kolli@engenio.com>
> Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Neela and Sekomann or Sumant, can I ping on this ... I've no idea what
this will do to the raid management tools, so I really need someone to
sign off on this.

James


