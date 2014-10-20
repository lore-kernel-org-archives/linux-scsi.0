From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [OPW kernel] [PATCH v2] scsi: ips.c: Use jiffies comparison instead of do_gettimeofday()
Date: Mon, 20 Oct 2014 19:43:18 +0200
Message-ID: <2045799.tHXb4Zp5JS@wuerfel>
References: <1413824761-21426-1-git-send-email-ebru.akagunduz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413824761-21426-1-git-send-email-ebru.akagunduz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: opw-kernel@googlegroups.com
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 20 October 2014 20:06:01 Ebru Akagunduz wrote:
> do_gettimeofday() only can get 32-bit time types
> but the driver should be able to use dates that are
> after January 2038.
> 
> Remove do_gettimeofday() and use
> jiffies comparison to supply 64-bit time types.

The description doesn't seem to match what you are doing:

- the use of 'struct timeval' in this driver is not actually unsafe
- using jiffies does not make it use a 64-bit time type.
- you do not mention that using jiffies makes the driver more
  efficient, which is what James was interested in
- The ips_fix_ffdc_time that needs to be changed for 64-bit time
  does not get changed in this patch. As discussed on IRC, that
  should be a separate patch.

> @@ -6000,7 +6001,7 @@ ips_ffdc_time(ips_ha_t * ha)
>  /*                                                                          */
>  /****************************************************************************/
>  static void
> -ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time_t current_time)
> +ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, unsigned long current_time)
>  {
>  	long days;
>  	long rem;

Using 'unsigned long' for a jiffies value also breaks the function, which
makes calculations based on the assumption that you are dealing with a
time_t. I think the best fix here is to use rtc_ktime_to_tm(ktime_get())
to get a 'struct rtc_time' describing the current time, and then removing
most of the code.

You will have to change Kconfig to 'select RTC_LIB' from the ips driver
in order to do this.

	Arnd
