From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] [RESEND] scsi: ips: fix firmware timestamps for 32-bit
Date: Thu, 18 Jan 2018 20:35:03 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1801182000330.3@nippy.intranet>
References: <20180117145749.2712957-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117145749.2712957-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Yang Hongyang <yanghy@cn.fujitsu.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 17 Jan 2018, Arnd Bergmann wrote:

> do_gettimeofday() is deprecated since it will stop working in 2038 on
> 32-bit platforms. The firmware interface here actually supports times
> until year 25500, so we should use longer timestamps.
> 

I think that reasoning is flawed. If the firmware supports large year 
values, then fine. The firmware interface is another story.

If you are simply trying to get rid of the old API, I think you should 
just say that.

> Using ktime_get_real_seconds() to get a 64-bit seconds value
> and time64_to_tm() to convert it into the right format also has
> the advantage of greatly simplifying the time management code.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Submitted originally in November 2017. The aacraid@adaptec.com
> apparently bounced. Trying again now with a few people on Cc
> that previously reviewed patches to this driver.
> ---
>  drivers/scsi/ips.c | 78 +++++++++++-------------------------------------------
>  drivers/scsi/ips.h |  2 +-
>  2 files changed, 17 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 67621308eb9c..887843a465e1 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -293,7 +293,7 @@ static void ips_freescb(ips_ha_t *, ips_scb_t *);
>  static void ips_setup_funclist(ips_ha_t *);
>  static void ips_statinit(ips_ha_t *);
>  static void ips_statinit_memio(ips_ha_t *);
> -static void ips_fix_ffdc_time(ips_ha_t *, ips_scb_t *, time_t);
> +static void ips_fix_ffdc_time(ips_ha_t *, ips_scb_t *, time64_t);
>  static void ips_ffdc_reset(ips_ha_t *, int);
>  static void ips_ffdc_time(ips_ha_t *);
>  static uint32_t ips_statupd_copperhead(ips_ha_t *);
> @@ -989,10 +989,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
>  
>  	/* FFDC */
>  	if (le32_to_cpu(ha->subsys->param[3]) & 0x300000) {
> -		struct timeval tv;
> -
> -		do_gettimeofday(&tv);
> -		ha->last_ffdc = tv.tv_sec;
> +		ha->last_ffdc = ktime_get_real_seconds();
>  		ha->reset_count++;
>  		ips_ffdc_reset(ha, IPS_INTR_IORL);
>  	}
> @@ -2396,7 +2393,6 @@ static int
>  ips_hainit(ips_ha_t * ha)
>  {
>  	int i;
> -	struct timeval tv;
>  
>  	METHOD_TRACE("ips_hainit", 1);
>  
> @@ -2411,8 +2407,7 @@ ips_hainit(ips_ha_t * ha)
>  
>  	/* Send FFDC */
>  	ha->reset_count = 1;
> -	do_gettimeofday(&tv);
> -	ha->last_ffdc = tv.tv_sec;
> +	ha->last_ffdc = ktime_get_real_seconds();
>  	ips_ffdc_reset(ha, IPS_INTR_IORL);
>  
>  	if (!ips_read_config(ha, IPS_INTR_IORL)) {
> @@ -2552,12 +2547,9 @@ ips_next(ips_ha_t * ha, int intr)
>  
>  	if ((ha->subsys->param[3] & 0x300000)
>  	    && (ha->scb_activelist.count == 0)) {
> -		struct timeval tv;
> -
> -		do_gettimeofday(&tv);
> -
> -		if (tv.tv_sec - ha->last_ffdc > IPS_SECS_8HOURS) {
> -			ha->last_ffdc = tv.tv_sec;
> +		time64_t now = ktime_get_real_seconds();
> +		if (now - ha->last_ffdc > IPS_SECS_8HOURS) {
> +			ha->last_ffdc = now;
>  			ips_ffdc_time(ha);
>  		}
>  	}
> @@ -5992,59 +5984,21 @@ ips_ffdc_time(ips_ha_t * ha)
>  /*                                                                          */
>  /****************************************************************************/
>  static void
> -ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time_t current_time)
> +ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time64_t current_time)

Does this conversion assume that current_time is always positive? I don't 
have a problem with that (the existing code seems to fail otherwise) but 
maybe it should be mentioned in the commit log.

>  {
> -	long days;
> -	long rem;
> -	int i;
> -	int year;
> -	int yleap;
> -	int year_lengths[2] = { IPS_DAYS_NORMAL_YEAR, IPS_DAYS_LEAP_YEAR };
> -	int month_lengths[12][2] = { {31, 31},
> -	{28, 29},
> -	{31, 31},
> -	{30, 30},
> -	{31, 31},
> -	{30, 30},
> -	{31, 31},
> -	{31, 31},
> -	{30, 30},
> -	{31, 31},
> -	{30, 30},
> -	{31, 31}
> -	};
> +	struct tm tm;
>  
>  	METHOD_TRACE("ips_fix_ffdc_time", 1);
>  
> -	days = current_time / IPS_SECS_DAY;
> -	rem = current_time % IPS_SECS_DAY;
> -
> -	scb->cmd.ffdc.hour = (rem / IPS_SECS_HOUR);
> -	rem = rem % IPS_SECS_HOUR;
> -	scb->cmd.ffdc.minute = (rem / IPS_SECS_MIN);
> -	scb->cmd.ffdc.second = (rem % IPS_SECS_MIN);
> -
> -	year = IPS_EPOCH_YEAR;
> -	while (days < 0 || days >= year_lengths[yleap = IPS_IS_LEAP_YEAR(year)]) {
> -		int newy;
> -
> -		newy = year + (days / IPS_DAYS_NORMAL_YEAR);
> -		if (days < 0)
> -			--newy;
> -		days -= (newy - year) * IPS_DAYS_NORMAL_YEAR +
> -		    IPS_NUM_LEAP_YEARS_THROUGH(newy - 1) -
> -		    IPS_NUM_LEAP_YEARS_THROUGH(year - 1);

These IPS_ time macros are all unused after this patch except 
IPS_SECS_8HOURS so the definitions should probably be removed.

> -		year = newy;
> -	}
> -
> -	scb->cmd.ffdc.yearH = year / 100;
> -	scb->cmd.ffdc.yearL = year % 100;
> -
> -	for (i = 0; days >= month_lengths[i][yleap]; ++i)
> -		days -= month_lengths[i][yleap];
> +	time64_to_tm(current_time, 0, &tm);
>  
> -	scb->cmd.ffdc.month = i + 1;
> -	scb->cmd.ffdc.day = days + 1;
> +	scb->cmd.ffdc.hour   = tm.tm_hour;
> +	scb->cmd.ffdc.minute = tm.tm_min;
> +	scb->cmd.ffdc.second = tm.tm_sec;
> +	scb->cmd.ffdc.yearH  = tm.tm_year / 100 + 1900;

That looks wrong to me. If tm_year is in units of years not centuries, 
shouldn't that be,

	scb->cmd.ffdc.yearH  = tm.tm_year / 100 + 19;

-- 

> +	scb->cmd.ffdc.yearL  = tm.tm_year % 100;
> +	scb->cmd.ffdc.month  = tm.tm_mon + 1;
> +	scb->cmd.ffdc.day    = tm.tm_mday;
>  }
>  
>  /****************************************************************************
> diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> index 366be3b2f9b4..b43a1ae75660 100644
> --- a/drivers/scsi/ips.h
> +++ b/drivers/scsi/ips.h
> @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
>     uint8_t            active;
>     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
>     uint16_t           reset_count;        /* number of resets           */
> -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> +   time64_t           last_ffdc;          /* last time we sent ffdc info*/
>     uint8_t            slot_num;           /* PCI Slot Number            */
>     int                ioctl_len;          /* size of ioctl buffer       */
>     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
> 
