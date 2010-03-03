From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH -next] scsi: RAID_ATTRS depends on SCSI
Date: Wed, 03 Mar 2010 08:56:36 -0800
Message-ID: <4B8E94C4.8070106@xenotime.net>
References: <20100219174711.5e7cc7be.sfr@canb.auug.org.au>	 <4B7EC8AE.60200@oracle.com>  <20100221194636.ef885e5a.rdunlap@xenotime.net> <1267594617.4383.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1267594617.4383.24.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-next@vger.kernel.org, akpm <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/02/10 21:36, James Bottomley wrote:
> On Sun, 2010-02-21 at 19:46 -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> raid_class uses scsi interfaces, so it should depend on SCSI.
>> Otherwise build errors occur when RAID_ATTRS=y and SCSI=m:
>>
>> ERROR: "raid_class_release" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
>> ERROR: "raid_class_attach" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  drivers/scsi/Kconfig |   14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> --- linux-next-20100219.orig/drivers/scsi/Kconfig
>> +++ linux-next-20100219/drivers/scsi/Kconfig
>> @@ -1,12 +1,5 @@
>>  menu "SCSI device support"
>>  
>> -config RAID_ATTRS
>> -	tristate "RAID Transport Class"
>> -	default n
>> -	depends on BLOCK
>> -	---help---
>> -	  Provides RAID
>> -
>>  config SCSI
>>  	tristate "SCSI device support"
>>  	depends on BLOCK
>> @@ -34,6 +27,13 @@ config SCSI_DMA
>>  	bool
>>  	default n
>>  
>> +config RAID_ATTRS
>> +	tristate "RAID Transport Class"
>> +	default n
>> +	depends on BLOCK && SCSI
>> +	---help---
>> +	  Provides RAID
>> +
> 
> This will fix the error, but it's not quite the right thing to do.  the
> RAID class should be independent of SCSI, but it wants to do a SCSI
> check if SCSI is compiled in the matching routines.  This gives us a
> nasty dependency, the condition being that the raid class must be m if
> SCSI is m.
> 
> I think this patch does the right thing.  Can someone test it on the
> config checker?  Or I can just put it in linux-next and have Stephen's
> builds do it.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks for the patch.

> Thanks,
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9191d1e..75f2336 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1,9 +1,15 @@
>  menu "SCSI device support"
>  
> +config SCSI_MOD
> +       tristate
> +       default y if SCSI=n || SCSI=y
> +       default m if SCSI=m
> +
>  config RAID_ATTRS
>  	tristate "RAID Transport Class"
>  	default n
>  	depends on BLOCK
> +	depends on SCSI_MOD
>  	---help---
>  	  Provides RAID
>  
> diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
> index bd88349..2c146b4 100644
> --- a/drivers/scsi/raid_class.c
> +++ b/drivers/scsi/raid_class.c
> @@ -63,6 +63,7 @@ static int raid_match(struct attribute_container *cont, struct device *dev)
>  	 * emulated RAID devices, so start with SCSI */
>  	struct raid_internal *i = ac_to_raid_internal(cont);
>  
> +#if defined(CONFIG_SCSI) || defined(CONFIG_SCSI_MODULE)
>  	if (scsi_is_sdev_device(dev)) {
>  		struct scsi_device *sdev = to_scsi_device(dev);
>  
> @@ -71,6 +72,7 @@ static int raid_match(struct attribute_container *cont, struct device *dev)
>  
>  		return i->f->is_raid(dev);
>  	}
> +#endif
>  	/* FIXME: look at other subsystems too */
>  	return 0;
>  }
> 
> 


-- 
~Randy
