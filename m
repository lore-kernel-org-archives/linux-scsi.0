From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH 07/24] libsas: fix leak of dev->sata_dev.identify_[packet_]device
Date: Mon, 19 Dec 2011 10:38:28 +0800
Message-ID: <334C9030B49B4E9F9A0E62261B585988@usish.com.cn>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6> <20111217023344.15036.5618.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217023344.15036.5618.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks for fix.
Reviewed-by: Jack Wang <jack_wang@usish.com>
> 
> These are never freed in the nominal path.  A domain_device has a
> different lifetime than a sas_rphy we need a dev->rphy independent way
> of identifying sata devices.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_discover.c |    6 ++++++
>  include/scsi/sas_ata.h             |    3 ++-
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c
> b/drivers/scsi/libsas/sas_discover.c
> index 4e64930..dc52b1f 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -30,6 +30,7 @@
> 
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_transport_sas.h>
> +#include <scsi/sas_ata.h>
>  #include "../scsi_sas_internal.h"
> 
>  /* ---------- Basic task processing for discovery purposes ---------- */
> @@ -231,6 +232,11 @@ void sas_free_device(struct kref *kref)
>  	if (dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV)
>  		kfree(dev->ex_dev.ex_phy);
> 
> +	if (dev_is_sata(dev)) {
> +		kfree(dev->sata_dev.identify_device);
> +		kfree(dev->sata_dev.identify_packet_device);
> +	}
> +
>  	kfree(dev);
>  }
> 
> diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
> index 9c159f7..7d5013f 100644
> --- a/include/scsi/sas_ata.h
> +++ b/include/scsi/sas_ata.h
> @@ -32,7 +32,8 @@
> 
>  static inline int dev_is_sata(struct domain_device *dev)
>  {
> -	return (dev->rphy->identify.target_port_protocols &
> SAS_PROTOCOL_SATA);
> +	return dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM ||
> +	       dev->dev_type == SATA_PM_PORT;
>  }
> 
>  int sas_ata_init_host_and_port(struct domain_device *found_dev,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

