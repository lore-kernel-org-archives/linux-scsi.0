From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [PATCH] Revert "scsi: default to scsi-mq"
Date: Mon, 14 Aug 2017 10:50:47 -0500
Message-ID: <d89724d1-b358-7aa4-ba1d-65a7972a4518@oracle.com>
References: <20170813174422.16197-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170813174422.16197-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/13/2017 12:44 PM, Christoph Hellwig wrote:
> Defaulting to scsi-mq in 4.13-rc has shown various regressions
> on setups that we didn't previously consider.  Fixes for them are
> in progress, but too invasive to make it in this cycle.  So for
> now revert the commit that defaults to blk-mq for SCSI.  For 4.14
> we'll plan to try again with these fixes.

I'm not sure if this is one of your known regressions, but I've had a
problem on my Lenovo T410 with the 4.13-rc kernels. When unplugging the
power cord, the hard disk gets suspended.

[ 1499.629415] thinkpad_acpi: EC reports that Thermal Table has changed
[ 1499.832116] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1499.885831] e1000e: eth0 NIC Link is Down
[ 1499.897531] sd 0:0:0:0: [sda] Stopping disk
[ 1499.923736] EXT4-fs (sda5): re-mounted. Opts: data=ordered,commit=600
[ 1504.240444] thinkpad_acpi: EC reports that Thermal Table has changed
[ 1515.502561] sd 0:0:0:0: timing out command, waited 15s

Adding "scsi_mod.use_blk_mq=0" to the command line fixes it.

Thanks,
Shaggy

> 
> This reverts commit 5c279bd9e40624f4ab6e688671026d6005b066fa.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/Kconfig | 11 +++++++++++
>  drivers/scsi/scsi.c  |  4 ++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index f4538d7a3016..d145e0d90227 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -47,6 +47,17 @@ config SCSI_NETLINK
>  	default	n
>  	depends on NET
>  
> +config SCSI_MQ_DEFAULT
> +	bool "SCSI: use blk-mq I/O path by default"
> +	depends on SCSI
> +	---help---
> +	  This option enables the new blk-mq based I/O path for SCSI
> +	  devices by default.  With the option the scsi_mod.use_blk_mq
> +	  module/boot option defaults to Y, without it to N, but it can
> +	  still be overridden either way.
> +
> +	  If unsure say N.
> +
>  config SCSI_PROC_FS
>  	bool "legacy /proc/scsi/ support"
>  	depends on SCSI && PROC_FS
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3d38c6d463b8..1bf274e3b2b6 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -800,7 +800,11 @@ MODULE_LICENSE("GPL");
>  module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
>  
> +#ifdef CONFIG_SCSI_MQ_DEFAULT
>  bool scsi_use_blk_mq = true;
> +#else
> +bool scsi_use_blk_mq = false;
> +#endif
>  module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
>  
>  static int __init init_scsi(void)
> 
