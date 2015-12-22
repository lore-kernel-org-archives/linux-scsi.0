From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 66/77] ncr5380: Fix soft lockups
Date: Tue, 22 Dec 2015 09:03:54 +0100
Message-ID: <567903EA.7030803@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011755.965510468@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011755.965510468@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Because of the rudimentary design of the chip, it is necessary to pol=
l the
> SCSI bus signals during PIO and this tends to hog the CPU. The driver=
 will
> accept new commands while others execute, and this causes a soft lock=
up
> because the workqueue item will not terminate until the issue queue i=
s
> emptied.
>
> When exercising dmx3191d using sequential IO from dd, the driver is s=
ent
> 512 KiB WRITE commands and 128 KiB READs. For a PIO transfer, the rat=
e is
> is only about 300 KiB/s, so these are long-running commands. And alth=
ough
> PDMA may run at several MiB/s, interrupts are disabled for the durati=
on
> of the transfer.
>
> Fix the unresponsiveness and soft lockup issues by calling cond_resch=
ed()
> after each command is completed and by limiting max_sectors for drive=
rs
> that don't implement real DMA.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>
> Changed since v2:
> - Moved max_sectors initialization to wrapper drivers. It isn't reall=
y
>    relevant to the core driver and compile-time configuration using m=
acros
>    like REAL_DMA should be avoided.
>
> ---
>   drivers/scsi/NCR5380.c       |    6 ++++--
>   drivers/scsi/arm/cumana_1.c  |    1 +
>   drivers/scsi/arm/oak.c       |    1 +
>   drivers/scsi/atari_NCR5380.c |    6 ++++--
>   drivers/scsi/dmx3191d.c      |    1 +
>   drivers/scsi/dtc.c           |    1 +
>   drivers/scsi/g_NCR5380.c     |    1 +
>   drivers/scsi/mac_scsi.c      |    1 +
>   drivers/scsi/pas16.c         |    1 +
>   drivers/scsi/t128.c          |    1 +
>   10 files changed, 16 insertions(+), 4 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
