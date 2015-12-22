From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 39/77] ncr5380: Standardize interrupt handling
Date: Tue, 22 Dec 2015 08:36:29 +0100
Message-ID: <5678FD7D.1030401@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011748.635798149@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbbLVHgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 02:36:31 -0500
In-Reply-To: <20151222011748.635798149@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Because interrupt handling is crucial to the core driver(s), all wrap=
per
> drivers need to agree on this code. This patch removes discrepancies.
>
> NCR5380_intr() in NCR5380.c has the following pointless loop that dif=
fers
> from the code in atari_NCR5380.c.
>
> 	done =3D 1;
> 	do {
> 		/* ... */
> 	} while (!done);
>
> The 'done' flag gets cleared when a reconnected command is to be proc=
essed
> from the work queue. But in NCR5380.c, the flag is also used to cause=
 the
> interrupt conditions to be re-examined. Perhaps this was because
> NCR5380_reselect() was expected to cause another interrupt, or perhap=
s
> the remaining present interrupt conditions need to be handled after t=
he
> NCR5380_reselect() call?
>
> Actually, both possibilities are bogus, as is the loop itself. It see=
ms
> have been overlooked in the hit-and-miss removal of scsi host instanc=
e
> list iteration many years ago; see history/history.git commit 491447e=
1fcff
> ("[PATCH] next NCR5380 updates") and commit 69e1a9482e57 ("[PATCH] fi=
x up
> NCR5380 private data"). See also my earlier patch, "Always retry
> arbitration and selection".
>
> The datasheet says, "IRQ can be reset simply by reading the Reset
> Parity/Interrupt Register". So don't treat the chip IRQ like a
> level-triggered interrupt. Of the conditions that set the IRQ flag,
> some are level-triggered and some are edge-triggered, which means IRQ
> itself must be edge-triggered.
>
> Some interrupt conditions are latched and some are not. Before cleari=
ng
> the chip IRQ flag, clear all state that may cause it to be raised. Th=
at
> means clearing the DMA Mode and Busy Monitor bits in the Mode Registe=
r
> and clearing the host ID in the Select Enable register.
>
> Also clean up some printk's and some comments. Keep atari_NCR5380.c a=
nd
> NCR5380.c in agreement.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |  187 +++++++++++++++++++++++--------=
------------
>   drivers/scsi/atari_NCR5380.c |  156 +++++++++++++++++--------------=
----
>   drivers/scsi/dtc.c           |    8 -
>   drivers/scsi/g_NCR5380.c     |    2
>   4 files changed, 180 insertions(+), 173 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
