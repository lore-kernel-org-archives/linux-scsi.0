From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [RFC v2 2/2] scsi: add rate limit to scsi sense code uevent
Date: Mon, 05 Jun 2017 18:22:15 -0400
Message-ID: <1496701335.4753.220.camel@localhost.localdomain>
References: <20170518181456.1955523-1-songliubraving@fb.com>
         <20170518181456.1955523-3-songliubraving@fb.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751189AbdFEWWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Jun 2017 18:22:17 -0400
In-Reply-To: <20170518181456.1955523-3-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk, bblock@linux.vnet.ibm.com

On Thu, 2017-05-18 at 11:14 -0700, Song Liu wrote:
> This patch adds rate limits to SCSI sense code uevets. Currently,
> the rate limit is hard-coded to 16 events per second.
> 
> The code tracks nano second time of latest 16 events in a circular
> buffer. When a new event arrives, the time is compared against the
> latest time in the buffer. If the difference is smaller than one
> second, the new event is dropped.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/scsi/scsi_error.c  | 15 +++++++++++++++
>  drivers/scsi/scsi_scan.c   |  4 ++++
>  include/scsi/scsi_device.h | 12 +++++++++++-
>  3 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a49c63a..91e6b0a 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -436,11 +436,26 @@ static void scsi_send_sense_uevent(struct scsi_device *sdev,
>  #ifdef CONFIG_SCSI_SENSE_UEVENT
>  	struct scsi_event *evt;
>  	unsigned char sb_len;
> +	unsigned long flags;
> +	u64 time_ns;
>  
>  	if (!test_bit(sshdr->sense_key & 0xf,
>  		      &sdev->sense_event_filter))
>  		return;
>  	evt = sdev_evt_alloc(SDEV_EVT_SCSI_SENSE, GFP_ATOMIC);
> +
> +	time_ns = ktime_to_ns(ktime_get());
> +	spin_lock_irqsave(&sdev->latest_event_lock, flags);
> +	if (time_ns - sdev->latest_event_times[sdev->latest_event_idx] <
> +	    NSEC_PER_SEC) {
> +		spin_unlock_irqrestore(&sdev->latest_event_lock, flags);
> +		return;

You have an allocated evt here, so if you return here you will leak
kernel memory.

This code appears to be rate limiting per-sdev.  You have to remember
that on a large system, there could be thousands of these devices.
You could easily end up generating 10s or 100s of thousands of events
per second, in a very short amount of time under certain failure
conditions.

The udev event mechanism can realistically only process a few
hundred events per second before it starts getting behind, due to
the rule processing engine (the rules in userspace).

You also have to consider that if you clog up udev with a lot of
your events, you affect event processing for other events.

-Ewan

> +	}
> +	sdev->latest_event_times[sdev->latest_event_idx] = time_ns;
> +	sdev->latest_event_idx = (sdev->latest_event_idx + 1) %
> +		MAX_SENSE_EVENT_PER_SECOND;
> +	spin_unlock_irqrestore(&sdev->latest_event_lock, flags);
> +
>  	if (!evt)
>  		return;
>  
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6f7128f..67b3f71 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -301,6 +301,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  		}
>  	}
>  
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +	spin_lock_init(&sdev->latest_event_lock);
> +#endif
> +
>  	return sdev;
>  
>  out_device_destroy:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 5b6f06d..9217dae 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -214,12 +214,22 @@ struct scsi_device {
>  	atomic_t ioerr_cnt;
>  
>  #ifdef CONFIG_SCSI_SENSE_UEVENT
> +#define MAX_SENSE_EVENT_PER_SECOND	16
>  	/*
>  	 * filter of sense code uevent
>  	 * setting bit X (0x00 - 0x0e) of sense_event_filter enables
>  	 * uevent for sense key X
>  	 */
> -	unsigned long		sense_event_filter;
> +	unsigned long	sense_event_filter;
> +	/*
> +	 * To rate limit uevents to MAX_SENSE_EVENT_PER_SECOND, we track
> +	 * nano second time of MAX_SENSE_EVENT_PER_SECOND most recent
> +	 * events. If there are already MAX_SENSE_EVENT_PER_SECOND in the
> +	 * past seconds, new event is dropped.
> +	 */
> +	u64		latest_event_times[MAX_SENSE_EVENT_PER_SECOND];
> +	int		latest_event_idx;
> +	spinlock_t	latest_event_lock;
>  #endif
>  
>  	struct device		sdev_gendev,
