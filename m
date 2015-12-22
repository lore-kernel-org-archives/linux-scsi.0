From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 35/77] ncr5380: Dont wait for BUS FREE after disconnect
Date: Tue, 22 Dec 2015 08:31:11 +0100
Message-ID: <5678FC3F.5040507@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011747.535983710@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011747.535983710@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> When there is a queued command and no connected command, NCR5380_sele=
ct()
> is called and arbitration begins. The chip waits for BUS FREE once th=
e
> MR_ARBITRATE bit in the mode register is enabled. That means there is
> no need to wait for BUS FREE after disconnecting.
>
> There is presently no polling for BUS FREE after sending an ABORT or
> other message that might lead to disconnection. It only happens after
> COMMAND COMPLETE or DISCONNECT messages, which seems inconsistent.
> Remove the polling for !BSY in the COMMAND COMPLETE and DISCONNECT
> cases.
>
> BTW, the comments say "avoid nasty timeouts" and perhaps BUS FREE pol=
ling
> was somehow helpful back in Linux v0.99.14u, when it was introduced.
> The relevant timeout is presently 1 second (for bus arbitration).
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |    7 -------
>   drivers/scsi/atari_NCR5380.c |   11 -----------
>   2 files changed, 18 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
