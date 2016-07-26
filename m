From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 26 Jul 2016 15:51:52 -0700
Message-ID: <577bc6d5-9c78-b6d3-10f7-10626c0da516@sandisk.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com> <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com> <20160725212325.GA23961@redhat.com>
 <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
 <20160726011607.GA77078@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0055.outbound.protection.outlook.com ([104.47.34.55]:10608
	"EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754393AbcGZWwE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2016 18:52:04 -0400
In-Reply-To: <20160726011607.GA77078@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/25/2016 06:15 PM, Mike Snitzer wrote:
> Please try this patch to see if it fixes your issue, thanks.
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 52baf8a..287caa7 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -433,10 +433,17 @@ failed:
>   */
>  static int must_push_back(struct multipath *m)
>  {
> -	return (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
> -		((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
> -		  test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> -		 dm_noflush_suspending(m->ti)));
> +	bool r;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&m->lock, flags);
> +	r = (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
> +	     ((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
> +	       test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> +	      dm_noflush_suspending(m->ti)));
> +	spin_unlock_irqrestore(&m->lock, flags);
> +
> +	return r;
>  }
>  
>  /*
 
Hello Mike,

Thank you for having made this patch available. Unfortunately even
with this patch applied I still see fio reporting I/O errors and the
following text still appears in the system log immediately before the
I/O errors are reported (due to debug statements I added in the device
mapper; mpath 254:0 and mpathbe refer to the same dm device):

Jul 26 15:40:37 ion-dev-ib-ini kernel: mpath 254:0: queue_if_no_path 0 -> 1
Jul 26 15:40:37 ion-dev-ib-ini kernel: executing DM ioctl DEV_SUSPEND on mpathbe
Jul 26 15:40:37 ion-dev-ib-ini kernel: mpath 254:0: queue_if_no_path 1 -> 0

BTW, I have not yet been able to determine which user space code
triggers the DEV_SUSPEND ioctl. A condlog() call I had added just
above dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0) call in
multipathd did not produce any output.

Bart.
