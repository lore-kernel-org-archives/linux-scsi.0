From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 49/77] ncr5380: Remove redundant ICR_ARBITRATION_LOST
 test and eliminate FLAG_DTC3181E
Date: Tue, 22 Dec 2015 08:45:14 +0100
Message-ID: <5678FF8A.8030105@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011751.308030701@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011751.308030701@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Remove FLAG_DTC3181E. It was used to suppress a final Arbitration Los=
t
> (SEL asserted) test that isn't actually needed. The test was suppress=
ed
> because it causes problems for DTC436 and DTC536 chips. It takes plac=
e
> after the host wins arbitration, so SEL has been asserted. These chip=
s
> can't seem to tell whether it was the host or another bus device that
> did so.
>
> This questionable final test appears in a flow chart in an early NCR5=
380
> datasheet. It was removed from later documents like the DP5380 datash=
eet.
>
> By the time this final test takes place, the driver has already teste=
d
> the Arbitration Lost bit several times. The first test happens 3 us a=
fter
> BUS FREE (or longer due to register access delays). The protocol requ=
ires
> that a device stop signalling within 1.8 us after BUS FREE unless it =
won
> arbitration, in which case it must assert SEL, which is detected 1.2 =
us
> later by the first Arbitration Lost test.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   14 +-------------
>   drivers/scsi/NCR5380.h       |    1 -
>   drivers/scsi/atari_NCR5380.c |    9 ---------
>   drivers/scsi/dmx3191d.c      |    2 +-
>   drivers/scsi/g_NCR5380.c     |    2 +-
>   5 files changed, 3 insertions(+), 25 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
