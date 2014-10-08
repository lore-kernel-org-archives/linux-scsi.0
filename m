From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Wed, 08 Oct 2014 13:44:55 -0700
Message-ID: <1412801095.32718.13.camel@jarvis>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-10-08 at 23:14 +0300, Ebru Akagunduz wrote:
> This patch changes 32-bit time types to 64-bit in
> ips.c
> 
> time_t can only represent signed 32-bit dates but
> the driver should represent dates that are after
> January 2038.
> 
> Use time64_t type instead of time_t.
> 
> Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
> ---
>  drivers/scsi/ips.c | 6 ++++--
>  drivers/scsi/ips.h | 2 +-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 52a216f..8a2cf68 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -195,6 +195,8 @@
>  
>  #include <linux/smp.h>
>  
> +#include <linux/time64.h>
> +
>  #ifdef MODULE
>  static char *ips = NULL;
>  module_param(ips, charp, 0);
> @@ -297,7 +299,7 @@ static void ips_freescb(ips_ha_t *, ips_scb_t *);
>  static void ips_setup_funclist(ips_ha_t *);
>  static void ips_statinit(ips_ha_t *);
>  static void ips_statinit_memio(ips_ha_t *);
> -static void ips_fix_ffdc_time(ips_ha_t *, ips_scb_t *, time_t);
> +static void ips_fix_ffdc_time(ips_ha_t *, ips_scb_t *, time64_t);
>  static void ips_ffdc_reset(ips_ha_t *, int);
>  static void ips_ffdc_time(ips_ha_t *);
>  static uint32_t ips_statupd_copperhead(ips_ha_t *);
> @@ -6000,7 +6002,7 @@ ips_ffdc_time(ips_ha_t * ha)
>  /*                                                                          */
>  /****************************************************************************/
>  static void
> -ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time_t current_time)
> +ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time64_t current_time)
>  {
>  	long days;
>  	long rem;
> diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> index 45b9566..ff2a0b3 100644
> --- a/drivers/scsi/ips.h
> +++ b/drivers/scsi/ips.h
> @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
>     uint8_t            active;
>     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
>     uint16_t           reset_count;        /* number of resets           */
> -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> +   time64_t             last_ffdc;          /* last time we sent ffdc info*/
>     uint8_t            slot_num;           /* PCI Slot Number            */
>     int                ioctl_len;          /* size of ioctl buffer       */
>     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/

This is completely pointless, isn't it?  All the ips driver cares about
is that we send a FFDC time update every eight hours or so, so we can
happily truncate the number of seconds to 32 bits for that calculation
just keep the variable at 32 bits and do a time_after thing for the
comparison.

However, what the code *should* be doing is using jiffies and
time_before/after since the interval is so tiny rather than a
do_gettimeofday() call in the fast path.

James
