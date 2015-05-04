From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/9] scsi_dh: integrate into the core SCSI code
Date: Mon, 04 May 2015 09:50:38 +0200
Message-ID: <554724CE.1090002@suse.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de> <1430415151-30948-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbEDHul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 03:50:41 -0400
In-Reply-To: <1430415151-30948-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 04/30/2015 07:32 PM, Christoph Hellwig wrote:
> Stop building scsi_dh as a separate module and integrate it fully int=
o the
> core SCSI code with explicit callouts at bus scan time.  For now the
> callouts are placed at the same point as the old bus notifiers were c=
alled,
> but in the future we will be able to look at ALUA INQUIRY data earlie=
r on.
>=20
> Note that this also means that the device handler modules need to be =
loaded
> by the time we scan the bus.  The next patches will add support for
> autoloading device handlers at bus scan time to make sure they are al=
ways
> loaded if they are enabled in the kernel config.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/Makefile                 |   1 +
>  drivers/scsi/device_handler/Kconfig   |   2 +-
>  drivers/scsi/device_handler/Makefile  |   1 -
>  drivers/scsi/device_handler/scsi_dh.c | 185 +++---------------------=
----------
>  drivers/scsi/scsi_priv.h              |   9 ++
>  drivers/scsi/scsi_sysfs.c             |  10 ++
>  include/scsi/scsi_dh.h                |   2 +-
>  7 files changed, 35 insertions(+), 175 deletions(-)
>=20
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index dee160a..df2f656 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -169,6 +169,7 @@ scsi_mod-$(CONFIG_SYSCTL)	+=3D scsi_sysctl.o
>  scsi_mod-$(CONFIG_SCSI_PROC_FS)	+=3D scsi_proc.o
>  scsi_mod-y			+=3D scsi_trace.o scsi_logging.o
>  scsi_mod-$(CONFIG_PM)		+=3D scsi_pm.o
> +scsi_mod-$(CONFIG_SCSI_DH)	+=3D device_handler/scsi_dh.o
> =20
>  hv_storvsc-y			:=3D storvsc_drv.o
> =20
> diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/devic=
e_handler/Kconfig
> index 69abd0a..e5647d5 100644
> --- a/drivers/scsi/device_handler/Kconfig
> +++ b/drivers/scsi/device_handler/Kconfig
> @@ -3,7 +3,7 @@
>  #
> =20
>  menuconfig SCSI_DH
> -	tristate "SCSI Device Handlers"
> +	bool "SCSI Device Handlers"
>  	depends on SCSI
>  	default n
>  	help
> diff --git a/drivers/scsi/device_handler/Makefile b/drivers/scsi/devi=
ce_handler/Makefile
> index e1d2ea0..09866c5 100644
> --- a/drivers/scsi/device_handler/Makefile
> +++ b/drivers/scsi/device_handler/Makefile
> @@ -1,7 +1,6 @@
>  #
>  # SCSI Device Handler
>  #
> -obj-$(CONFIG_SCSI_DH)		+=3D scsi_dh.o
>  obj-$(CONFIG_SCSI_DH_RDAC)	+=3D scsi_dh_rdac.o
>  obj-$(CONFIG_SCSI_DH_HP_SW)	+=3D scsi_dh_hp_sw.o
>  obj-$(CONFIG_SCSI_DH_EMC)	+=3D scsi_dh_emc.o
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/dev=
ice_handler/scsi_dh.c
> index e6ed565..cb336a4 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -24,7 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <scsi/scsi_dh.h>
> -#include "../scsi_priv.h"
> +#include "scsi_priv.h"
> =20
This doesn't compile; 'scsi_dh' is still at it's old location.

Please remove this hunk.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
