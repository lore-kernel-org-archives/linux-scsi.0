From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Jun 1 (scsi)
Date: Wed, 06 Jun 2012 14:43:01 -0700
Message-ID: <4FCFCEE5.1000200@xenotime.net>
References: <20120601132202.ac73b03c845299d384defeaf@canb.auug.org.au>	 <4FCC2BF9.7000802@xenotime.net> <1338962053.23080.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338962053.23080.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dan Williams <dan.j.williams@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 06/05/2012 10:54 PM, James Bottomley wrote:

> On Sun, 2012-06-03 at 20:31 -0700, Randy Dunlap wrote:
>> On 05/31/2012 08:22 PM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120531:
>>
>>
>>
>> already fixed?
>>
>> on i386 and x86_64, loadable module or builtin:
>>
>>
>> ERROR: "scsi_sd_probe_domain" [drivers/scsi/scsi_mod.ko] undefined!
>> or
>> (.text+0x4f6c77): undefined reference to `scsi_sd_probe_domain'
> 
> This looks to be an obvious thinko:  the symbol is conditionally
> defined, but unconditionally used in
> scsi_scan.c:scsi_complete_async_scans().  We can fix just by removing
> the wrong conditional.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 61c82a3..bbbc9c9 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -90,11 +90,9 @@ unsigned int scsi_logging_level;
>  EXPORT_SYMBOL(scsi_logging_level);
>  #endif
>  
> -#if IS_ENABLED(CONFIG_PM) || IS_ENABLED(CONFIG_BLK_DEV_SD)
> -/* sd and scsi_pm need to coordinate flushing async actions */
> +/* sd, scsi core and power management need to coordinate flushing async actions */
>  LIST_HEAD(scsi_sd_probe_domain);
>  EXPORT_SYMBOL(scsi_sd_probe_domain);
>                                 -#endif


Yes, this patch works after I move that "-#endif" to column 1 (or 0).

Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


>  

>  /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
>   * You may not alter any existing entry (although adding new ones is
> 
> 



-- 
~Randy
