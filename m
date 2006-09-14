From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas: move ATA bits into a separate module
Date: Thu, 14 Sep 2006 11:14:27 -0400
Message-ID: <450971D3.2040405@garzik.org>
References: <4508A0A2.2080605@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:3268 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750749AbWINPOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Sep 2006 11:14:33 -0400
In-Reply-To: <4508A0A2.2080605@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

Darrick J. Wong wrote:
> Hi all,
> 
> Per James Bottomley's request, I've moved all the libsas SATA support
> code into a separate module, named sas_ata.  To satisfy his further
> requirement that libsas not require libata (and vice versa), ata_sas
> maintains fixed function pointer tables to various required functions
> within libsas and libata.  Unfortunately, this means that libsas and
> libata both require sas_ata, but sas_ata is smaller than libata.
> Unloads of libata/libsas at inopportune moments are prevented by
> increasing the refcounts on both modules whenever libsas detects a SATA
> device (and decreasing it when the device goes away, of course).  If the
> module is removed from the .config, then all of hooks into libsas/libata
> should go away.
> 
> This is a rough-cut at separating out the ATA code; please let me know
> what I can improve.  At the moment, I can load and talk to SATA disks
> with the module enabled, as well as watch nothing happen if the module
> is not config'd in.
> 
> The patch is a bit large, so here's where it lives:
> http://sweaglesw.net/~djwong/docs/sas-ata_2.patch

I disagree completely with this approach.

You don't need a table of hooks for the case where libata is disabled in 
.config.  Thus, it's only useful for the case where libsas is loaded as 
a module, but libata is not.

And the cost of having libata loaded via the normal symbol resolution / 
module load mechanisms is low, so adding a table of hooks completely 
wrapping libata functions is just silly.

The libsas code should directly call libata functions.  If ATA support 
in libsas is disabled in .config, then those functions will never be 
called, thus never loaded the libata module.

	Jeff




