From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Mon, 1 Sep 2014 08:36:29 -0700
Message-ID: <20140901153629.GA29938@infradead.org>
References: <5403AB47.3040706@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5403AB47.3040706@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Milan Broz <gmazyland@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> --- a/drivers/scsi/scsi_debug.c	2014-08-26 13:24:51.646948507 -0400
> +++ b/drivers/scsi/scsi_debug.c	2014-08-30 18:04:54.589226679 -0400
> @@ -2743,6 +2743,13 @@ static int stop_queued_cmnd(struct scsi_
>  		if (test_bit(k, queued_in_use_bm)) {
>  			sqcp = &queued_arr[k];
>  			if (cmnd == sqcp->a_cmnd) {
> +				devip = (struct sdebug_dev_info *)
> +					cmnd->device->hostdata;
> +				if (devip)
> +					atomic_dec(&devip->num_in_q);
> +				sqcp->a_cmnd = NULL;

Why would the hostdata every be NULL here?  We should never
call ->slave_destroy on a device that has outstanding commands.
