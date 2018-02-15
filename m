From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] lpfc: add missing Kconfig NVME dependencies
Date: Thu, 15 Feb 2018 14:00:30 -0500
Message-ID: <1518721230.2427.82.camel@localhost.localdomain>
References: <58adba5f.BoP49Cv2S5zD9ZuD%jsmart2021@gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <58adba5f.BoP49Cv2S5zD9ZuD%jsmart2021@gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: hare@suse.com, martin.petersen@oracle.com, dick.kennedy@broadcom.com, linux-next@vger.kernel.org, sfr@canb.auug.org.au, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-02-22 at 08:20 -0800, James Smart wrote:
> add missing Kconfig NVME dependencies
> 
> Can't believe I missed posting this
> 
> -- james
> 
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index d4023bf..2558434 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1240,6 +1240,7 @@ config SCSI_LPFC
>  	tristate "Emulex LightPulse Fibre Channel Support"
>  	depends on PCI && SCSI
>  	depends on SCSI_FC_ATTRS
> +	depends on NVME_FC && NVME_TARGET_FC
>  	select CRC_T10DIF
>  	help
>            This lpfc driver supports the Emulex LightPulse

I thought this was why you had

#if (IS_ENABLED(CONFIG_NVME_FC))
#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))

at various places in the lpfc driver.  Do you actually depend
on having NVME_FC and NVME_TARGET_FC, or do you selectively
include code if they are config'ed in?

Or do you want to force-enable it at this point?

-Ewan
