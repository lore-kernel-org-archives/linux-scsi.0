From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ips.c: Use jiffies comparison instead of
 do_gettimeofday()
Date: Mon, 20 Oct 2014 18:39:48 +0100
Message-ID: <1413826788.13078.5.camel@jarvis>
References: <1413824761-21426-1-git-send-email-ebru.akagunduz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413824761-21426-1-git-send-email-ebru.akagunduz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-10-20 at 20:06 +0300, Ebru Akagunduz wrote:
> do_gettimeofday() only can get 32-bit time types
> but the driver should be able to use dates that are
> after January 2038.
> 
> Remove do_gettimeofday() and use
> jiffies comparison to supply 64-bit time types.
> 
> Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
> ---
>  drivers/scsi/ips.c | 25 +++++++++++++------------
>  drivers/scsi/ips.h |  2 +-
>  2 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index e5afc38..6d27024 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -162,6 +162,7 @@
>   */
>  
>  #include <asm/io.h>
> +#include <linux/jiffies.h>
>  #include <asm/byteorder.h>
>  #include <asm/page.h>
>  #include <linux/stddef.h>
> @@ -297,7 +298,7 @@ static void ips_freescb(ips_ha_t *, ips_scb_t *);
>  static void ips_setup_funclist(ips_ha_t *);
>  static void ips_statinit(ips_ha_t *);
>  static void ips_statinit_memio(ips_ha_t *);
> -static void ips_fix_ffdc_time(ips_ha_t *, ips_scb_t *, time_t);
> +static void ips_fix_ffdc_time(ips_ha_t *, ips_scb_t *, unsigned long);
>  static void ips_ffdc_reset(ips_ha_t *, int);
>  static void ips_ffdc_time(ips_ha_t *);
>  static uint32_t ips_statupd_copperhead(ips_ha_t *);
> @@ -993,10 +994,10 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
>  
>  	/* FFDC */
>  	if (le32_to_cpu(ha->subsys->param[3]) & 0x300000) {
> -		struct timeval tv;
> +		unsigned long now;
>  
> -		do_gettimeofday(&tv);
> -		ha->last_ffdc = tv.tv_sec;
> +		now = jiffies;
> +		ha->last_ffdc = jiffies;
>  		ha->reset_count++;
>  		ips_ffdc_reset(ha, IPS_INTR_IORL);
>  	}
> @@ -2404,7 +2405,7 @@ static int
>  ips_hainit(ips_ha_t * ha)
>  {
>  	int i;
> -	struct timeval tv;
> +	unsigned long now;
>  
>  	METHOD_TRACE("ips_hainit", 1);
>  
> @@ -2419,8 +2420,8 @@ ips_hainit(ips_ha_t * ha)
>  
>  	/* Send FFDC */
>  	ha->reset_count = 1;
> -	do_gettimeofday(&tv);
> -	ha->last_ffdc = tv.tv_sec;
> +	now = jiffies;
> +	ha->last_ffdc = jiffies;
>  	ips_ffdc_reset(ha, IPS_INTR_IORL);
>  
>  	if (!ips_read_config(ha, IPS_INTR_IORL)) {
> @@ -2560,12 +2561,12 @@ ips_next(ips_ha_t * ha, int intr)
>  
>  	if ((ha->subsys->param[3] & 0x300000)
>  	    && (ha->scb_activelist.count == 0)) {
> -		struct timeval tv;
> +		unsigned long now;
>  
> -		do_gettimeofday(&tv);
> +		now = jiffies;
>  
> -		if (tv.tv_sec - ha->last_ffdc > IPS_SECS_8HOURS) {
> -			ha->last_ffdc = tv.tv_sec;
> +		if (time_after(now, ha->last_ffdc + IPS_SECS_8HOURS * HZ)) {
> +			ha->last_ffdc = now;
>  			ips_ffdc_time(ha);
>  		}
>  	}
> @@ -6000,7 +6001,7 @@ ips_ffdc_time(ips_ha_t * ha)
>  /*                                                                          */
>  /****************************************************************************/
>  static void
> -ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time_t current_time)
> +ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, unsigned long current_time)
>  {
>  	long days;
>  	long rem;
> diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> index 45b9566..250beea 100644
> --- a/drivers/scsi/ips.h
> +++ b/drivers/scsi/ips.h
> @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
>     uint8_t            active;
>     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
>     uint16_t           reset_count;        /* number of resets           */
> -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> +   unsigned long      last_ffdc;          /* last time we sent ffdc info*/
>     uint8_t            slot_num;           /* PCI Slot Number            */
>     int                ioctl_len;          /* size of ioctl buffer       */
>     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/

Great, looks exactly correct as far as it goes, but without the second
part (converting  ips_fix_ffdc_time() to use 64 bit time) it won't
actually work.  The problem is jiffies is a relative time measurement
and the RAID engine needs its real time clock setting periodically, so
there's no need to pass current_time (which is no longer current_time)
into ips_fix_ffdc_time(); just have that routine get the 64 bit time and
convert it to the format the card wants.

James
