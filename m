From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/71] atari_NCR5380: Remove RESET_BOOT, CONFIG_ATARI_SCSI_TOSHIBA_DELAY
 and CONFIG_ATARI_SCSI_RESET_BOOT
Date: Thu, 19 Nov 2015 14:41:30 +0100
Message-ID: <564DD18A.40909@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083457.891774987@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083457.891774987@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> The atari_NCR5380.c core driver now takes care of bus reset upon driv=
er
> initialization if required (same as NCR5380.c). Move the Toshiba CD-R=
OM
> support into the core driver, enabled with a host flag, so that all
> NCR5380 drivers can make use of it.
>=20
> Drop the RESET_BOOT macros and the ATARI_SCSI_RESET_BOOT and=20
> ATARI_SCSI_TOSHIBA_DELAY Kconfig symbols, which are now redundant.
>=20
> Remove the atari_scsi_reset_boot(), mac_scsi_reset_boot() and
> sun3_scsi_reset_boot() routines. None of this duplicated code is need=
ed
> now that all drivers can use NCR5380_maybe_reset_bus().
>=20
> This brings atari_scsi, mac_scsi and sun3_scsi into line with all of =
the
> other NCR5380 drivers.
>=20
> The bus reset may raise an interrupt. That would be new behaviour for
> atari_scsi only when CONFIG_ATARI_SCSI_RESET_BOOT=3Dn. The ST DMA int=
errupt
> is not assigned to atari_scsi at this stage, so
> CONFIG_ATARI_SCSI_RESET_BOOT=3Dy may well be problematic already.
> Regardless, do_reset() now raises and clears the interrupt within
> local_irq_save/restore which should avoid problems.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/Kconfig         |   17 -----------
>  drivers/scsi/NCR5380.c       |   17 +++++++++--
>  drivers/scsi/NCR5380.h       |    1=20
>  drivers/scsi/atari_NCR5380.c |   22 +++++++++-----
>  drivers/scsi/atari_scsi.c    |   60 +++++---------------------------=
-------
>  drivers/scsi/mac_scsi.c      |   65 ++++++--------------------------=
-----------
>  drivers/scsi/sun3_scsi.c     |   47 -------------------------------
>  7 files changed, 51 insertions(+), 178 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
