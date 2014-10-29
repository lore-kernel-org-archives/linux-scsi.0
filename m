From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 10/36] ncr5380: Fix SCSI_IRQ_NONE bugs
Date: Wed, 29 Oct 2014 17:07:20 +0100
Message-ID: <545110B8.9010809@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052609.555425104@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423AbaJ2QHh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 12:07:37 -0400
In-Reply-To: <20141027052609.555425104@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Oak scsi doesn't use any IRQ, but it sets irq =3D IRQ_NONE rather tha=
n
> SCSI_IRQ_NONE. Problem is, the core NCR5380 driver expects SCSI_IRQ_N=
ONE
> if it is to issue IDENTIFY commands that prevent target disconnection=
=2E
> And, as Geert points out, IRQ_NONE is part of enum irqreturn.
>
> Other drivers, when they can't get an IRQ or can't use one, will set
> host->irq =3D SCSI_IRQ_NONE (that is, 255). But when they exit they w=
ill
> attempt to free IRQ 255 which was never requested.
>
> Fix these bugs by using NO_IRQ in place of SCSI_IRQ_NONE and IRQ_NONE=
=2E
> That means IRQ 0 is no longer probed by ISA drivers but I don't think
> this matters.
>
> Setting IRQ =3D 255 for these ISA drivers is understood to mean no IR=
Q.
> This remains supported so as to avoid breaking existing ISA setups (w=
hich
> can be difficult to get working) and because existing documentation
> (SANE, TLDP etc) describes this usage for the ISA NCR5380 driver opti=
ons.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
