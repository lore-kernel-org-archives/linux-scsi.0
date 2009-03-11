From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: resubmit kernel scan thread for MSA2012
Date: Wed, 11 Mar 2009 15:14:36 -0700
Message-ID: <20090311151436.c9be9ab4.akpm@linux-foundation.org>
References: <20090310151738.GA18243@beardog.cca.cpqcorp.net>
	<1236700241.14822.4.camel@localhost.localdomain>
	<20090310163426.GC18243@beardog.cca.cpqcorp.net>
	<20090310153933.7a7fc224.akpm@linux-foundation.org>
	<20090311161733.GF28208@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbZCKWRn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Mar 2009 18:17:43 -0400
In-Reply-To: <20090311161733.GF28208@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com

On Wed, 11 Mar 2009 11:17:33 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
>

We haven't finished with you yet ;)

> Changed the logic in the while loop. The thread works, whenever I change my
> config the next IO to the storage returns the unit attention
> LUN_DATA_CHANGED. The thread fires off and either adds or removes the
> logical volume.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>

That's not a suitable changelog for the patch.  Please maintain
changelogs alongside the patch, update them (if needed) with each
iteration and resend the full changelog each time.

> +static int scan_thread(ctlr_info_t *h)
> +{
> +	int rc;
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	h->rescan_wait = &wait;
> +
> +	while (!kthread_should_stop()) {
> +		rc = wait_for_completion_interruptible(&wait);
> +		if (!rc)
> +			rebuild_lun_table(h, 0);
> +	}
> +	return 0;
> +}

This will run rebuild_lun_table() in the case where the thread is being
asked to terminate.  Seems a bit peculiar, although hopefully harmless.

> +	snprintf(cciss_scan, 14, "cciss_scan%02d", i);
> +	hba[i]->cciss_scan_thread = kthread_run((void *)scan_thread, hba[i],
> +				cciss_scan);

kthread_run() takes printf-style arguments, so this can be

	hba[i]->cciss_scan_thread = kthread_run(scan_thread, hba[i],
					 "cciss_scan%02d", i);

and cciss_scan[] is removed.


And that void* cast of scan_thread is a bit grubby.  It would be
better to be more honest to the type system and do

static int scan_thread(void *data)
{
	ctlr_info_t *h = data;
	...
}


