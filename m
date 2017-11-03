From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: select CONFIG_RAS
Date: Fri, 3 Nov 2017 10:14:16 +0000
Message-ID: <bdb263f7-7e1f-47ab-881b-2feeeeccfbf5@huawei.com>
References: <20171102165059.213216-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171102165059.213216-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linuxarm <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>
List-Id: linux-scsi@vger.kernel.org

+ Shiju, who authored the original patch

Hi Arnd,

Thanks for this.

On 02/11/2017 16:50, Arnd Bergmann wrote:
> The driver now uses the RAS infrastructure, and fails to link if that
> is disabled:
>
> drivers/scsi/hisi_sas/hisi_sas_v2_hw.o: In function `fatal_ecc_int_v2_hw':
> hisi_sas_v2_hw.c:(.text+0xb08): undefined reference to `__tracepoint_non_standard_event'
> drivers/scsi/hisi_sas/hisi_sas_v2_hw.o: In function `fatal_axi_int_v2_hw':
> hisi_sas_v2_hw.c:(.text+0x1b34): undefined reference to `__tracepoint_non_standard_event'
>
> This adds an explicit Kconfig 'select RAS' statement. I don't know if
> the driver uses the interface correctly, as no other driver seems to do
> it like this, but the change fixes the link error.
>
> Fixes: dfeb5021f001 ("scsi: hisi_sas: report ECC and AXI errors in v2 hw to userspace")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/hisi_sas/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
> index d42f29a5eb65..6ad8a6251d21 100644
> --- a/drivers/scsi/hisi_sas/Kconfig
> +++ b/drivers/scsi/hisi_sas/Kconfig
> @@ -4,6 +4,7 @@ config SCSI_HISI_SAS
>  	depends on ARM64 || COMPILE_TEST
>  	select SCSI_SAS_LIBSAS
>  	select BLK_DEV_INTEGRITY
> +	select RAS

My impression is that we don't want this. Correction: shouldn't want this.

Do you have the .config for the broken build? I couldn't recreate this 
by turning off CONFIG_RAS.

John

>  	depends on ATA
>  	help
>  		This driver supports HiSilicon's SAS HBA, including support based
>
