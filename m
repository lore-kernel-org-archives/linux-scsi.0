From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: myrs: only build on little-endian platforms
Date: Mon, 5 Nov 2018 08:54:06 +0100
Message-ID: <69fd8fbd-987a-c48e-6732-387239c3ab0e@suse.de>
References: <20181102154740.2011289-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102154740.2011289-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/2/18 4:47 PM, Arnd Bergmann wrote:
> Reading throught the new driver, I noticed that this cannot work on
> big-endian CPUs, and the old DAC960 had exactly the same behavior.
> 
> To document this for the future, add a Kconfig dependency that prevents it
> from being included in big-endian kernels.  Since the hardware is really
> old and we never had a working driver on it for big-endian platforms,
> it's unlikely to make a difference to users.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index f07444d30b21..640cd1b31a18 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -578,6 +578,7 @@ config SCSI_MYRB
>   config SCSI_MYRS
>   	tristate "Mylex DAC960/DAC1100 PCI RAID Controller (SCSI Interface)"
>   	depends on PCI
> +	depends on !CPU_BIG_ENDIAN || COMPILE_TEST
>   	select RAID_ATTRS
>   	help
>   	  This driver adds support for the Mylex DAC960, AcceleRAID, and
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
