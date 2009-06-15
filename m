From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: resubmit kernel scan thread for MSA2012
Date: Mon, 15 Jun 2009 15:41:50 -0700
Message-ID: <20090615154150.fd02f22c.akpm@linux-foundation.org>
References: <20090310151738.GA18243@beardog.cca.cpqcorp.net>
	<1236700241.14822.4.camel@localhost.localdomain>
	<20090310163426.GC18243@beardog.cca.cpqcorp.net>
	<20090310153933.7a7fc224.akpm@linux-foundation.org>
	<20090311161733.GF28208@beardog.cca.cpqcorp.net>
	<20090311151436.c9be9ab4.akpm@linux-foundation.org>
	<20090312162653.GA10839@beardog.cca.cpqcorp.net>
	<20090615203955.GD6471@beardog.cca.cpqcorp.net>
	<20090615142550.7a840730.akpm@linux-foundation.org>
	<20090615221735.GF6471@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbZFOWmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 18:42:18 -0400
In-Reply-To: <20090615221735.GF6471@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com

On Mon, 15 Jun 2009 17:17:35 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> On Mon, Jun 15, 2009 at 02:25:50PM -0700, Andrew Morton wrote:
> > On Mon, 15 Jun 2009 15:39:55 -0500
> > "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> > 
> > > I'm getting reports that the driver hangs in the scan thread during rmmod. I
> > > call kthread_stop in cciss_remove_one. Do I also neesd to call complete()?
> > 
> > Yep.
> > 
> > static int scan_thread(void *data)
> > {
> > 	ctlr_info_t *h = data;
> > 	int rc;
> > 	DECLARE_COMPLETION_ONSTACK(wait);
> > 	h->rescan_wait = &wait;
> > 
> > 	for (;;) {
> > 		rc = wait_for_completion_interruptible(&wait);
> > 		if (kthread_should_stop())
> > 			break;
> > 		if (!rc)
> > 			rebuild_lun_table(h, 0);
> > 	}
> > 	return 0;
> > }
> > 
> > Two things will cause that wait_for_completion_interruptible() to
> > return: a complete() and a signal_pending().  But this is a kernel
> > thread, and kernel threads start out with all signals blocked.
> > 
> > > During my testing everything seemed to working OK.
> > 
> > That's odd.
> 
> Yeah, I guess so. Here's a patch to fix that problem. I add a call to
> complete to cciss_remove_one to stop the thread for rmmod. Please consider
> this for inclusion. Or should I submit separately from this mail?

Well it's a bit crappy - someone need to cook up a suitable title and
write a suitable changelog.  I'd prefer that it be you ;)

<writes a title and changelog.  Sigh>

> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 4d4d5e0..e51a0b2 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3935,6 +3935,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
>  		return;
>  	}
>  
> +	complete(hba[i]->rescan_wait);
>  	kthread_stop(hba[i]->cciss_scan_thread);
>  
>  	remove_proc_entry(hba[i]->devname, proc_cciss);

Has this been confirmed to fix things?

This is needed in 2.6.30.x, yes?
