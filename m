From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH] scsi: hpsa: select CONFIG_SCSI_SAS_ATTR
Date: Fri, 20 Nov 2015 10:09:50 -0600
Message-ID: <564F45CE.3060402@pmcs.com>
References: <3970646.5sOyETUiWo@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3970646.5sOyETUiWo@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: iss_storagedev@hp.com, storagedev@pmcs.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Don Brace <don.brace@pmcs.com>

And...Thanks!


On 11/19/2015 04:04 PM, Arnd Bergmann wrote:
> The hpsa driver recently started using the sas transport class, but it
> does not ensure that the corresponding code is actually built, which
> may lead to a link error:
>
> drivers/built-in.o: In function `hpsa_free_sas_phy':
> (.text+0x1ce874): undefined reference to `sas_port_delete_phy'
> (.text+0x1ce87c): undefined reference to `sas_phy_free'
> drivers/built-in.o: In function `hpsa_alloc_sas_port':
> (.text+0x1ceb9c): undefined reference to `sas_port_alloc_num'
> (.text+0x1ceba8): undefined reference to `sas_port_add'
> drivers/built-in.o: In function `hpsa_init':
> (.init.text+0x8838): undefined reference to `sas_attach_transport'
> (.init.text+0x8868): undefined reference to `sas_release_transport
>
> This adds 'select SCSI_SAS_ATTR' in the Kconfig entry, just like we do
> for all other drivers using those functions.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
> ---
> This showed up on the ARM randconfig builds today for the first time.
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 04a720686516..64eed87d34a8 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -364,6 +364,7 @@ config SCSI_HPSA
>   	tristate "HP Smart Array SCSI driver"
>   	depends on PCI && SCSI
>   	select CHECK_SIGNATURE
> +	select SCSI_SAS_ATTRS
>   	help
>   	  This driver supports HP Smart Array Controllers (circa 2009).
>   	  It is a SCSI alternative to the cciss driver, which is a block
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
