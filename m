From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: fix SATA dependency
Date: Tue, 28 Mar 2017 17:48:23 +0100
Message-ID: <071c038f-d3f2-4850-c06e-db1d0d54efc9@huawei.com>
References: <20170328142212.1816773-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:4902 "EHLO
        dggrg03-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751969AbdC1QtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Mar 2017 12:49:06 -0400
In-Reply-To: <20170328142212.1816773-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 28/03/2017 15:22, Arnd Bergmann wrote:
> Removing the 'select SCSI_SAS_LIBSAS' statement in Kconfig resulted
> in a link failure in configurations that have hisi_sas built-in
> but libsas as a loadable module:
>
> drivers/scsi/built-in.o: In function `hisi_sas_scan_finished':
> hisi_sas_main.c:(.text+0x37ce9): undefined reference to `sas_drain_work'
> drivers/scsi/built-in.o: In function `hisi_sas_slave_configure':
> hisi_sas_main.c:(.text+0x37d17): undefined reference to `sas_slave_configure'
> hisi_sas_main.c:(.text+0x37d40): undefined reference to `sas_change_queue_depth'
> drivers/scsi/built-in.o: In function `hisi_sas_remove':
>
> All other libsas users have the 'select' statement, so we should do the
> same here for consistency. For all I can tell, the patch that added
> the sata softreset does not actually introduce a dependency on SCSI_SAS_ATA
> but instead adds calls into libata itself, so we can express that with
> a more specific dependency.
>
> We cannot have 'select SCSI_SAS_LIBSAS; depends on SCSI_SAS_ATA' as that
> would cause a dependency loop.
>

Hi Arnd,

Thanks for the fix. So we missed that SCSI_SAS_ATA is a bool and not a 
tristate, like SCSI_SAS_LIBSAS. Just adding the dependency on ATA is better.


> Fixes: 7c594f0407de ("scsi: hisi_sas: add softreset function for SATA disk")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: John Garry <john.garry@huawei.com>

> ---
>  drivers/scsi/hisi_sas/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
> index ded2c201071d..374a329b91fc 100644
> --- a/drivers/scsi/hisi_sas/Kconfig
> +++ b/drivers/scsi/hisi_sas/Kconfig
> @@ -2,7 +2,8 @@ config SCSI_HISI_SAS
>  	tristate "HiSilicon SAS"
>  	depends on HAS_DMA && HAS_IOMEM
>  	depends on ARM64 || COMPILE_TEST
> -	depends on SCSI_SAS_ATA
> +	select SCSI_SAS_LIBSAS
>  	select BLK_DEV_INTEGRITY
> +	depends on ATA
>  	help
>  		This driver supports HiSilicon's SAS HBA
>
