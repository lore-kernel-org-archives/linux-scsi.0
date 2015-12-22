From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 61/77] ncr5380: Fix EH during arbitration and selection
Date: Tue, 22 Dec 2015 09:00:35 +0100
Message-ID: <56790323.2090406@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011754.605516715@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011754.605516715@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> During arbitration and selection, the relevant command is invisible t=
o
> exception handlers and can be found only in a pointer on the stack of=
 a
> different thread.
>
> When eh_abort_handler can't find a given command, it can't decide whe=
ther
> that command was completed already or is still in arbitration or sele=
ction
> phase. But it must return either SUCCESS (e.g. command completed earl=
ier)
> or FAILED (could not abort the nexus, try bus reset).
>
> The solution is to make sure all commands belonging to the LLD are al=
ways
> visible to exception handlers. Add another scsi_cmnd pointer to the
> hostdata struct to track the command in arbitration or selection phas=
e.
>
> Replace 'retain_dma_irq' with the new 'selecting' pointer, to bring
> atari_NCR5380.c into line with NCR5380.c.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   76 +++++++++++++++++++++++++++++--=
--------
>   drivers/scsi/NCR5380.h       |    4 +-
>   drivers/scsi/atari_NCR5380.c |   82 +++++++++++++++++++++++++++++++=
------------
>   3 files changed, 119 insertions(+), 43 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
