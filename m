From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: resubmit kernel scan thread for MSA2012
Date: Tue, 16 Jun 2009 12:17:03 -0700
Message-ID: <20090616121703.22c81a7c.akpm@linux-foundation.org>
References: <1236700241.14822.4.camel@localhost.localdomain>
	<20090310163426.GC18243@beardog.cca.cpqcorp.net>
	<20090310153933.7a7fc224.akpm@linux-foundation.org>
	<20090311161733.GF28208@beardog.cca.cpqcorp.net>
	<20090311151436.c9be9ab4.akpm@linux-foundation.org>
	<20090312162653.GA10839@beardog.cca.cpqcorp.net>
	<20090615203955.GD6471@beardog.cca.cpqcorp.net>
	<20090615142550.7a840730.akpm@linux-foundation.org>
	<20090615221735.GF6471@beardog.cca.cpqcorp.net>
	<20090615154150.fd02f22c.akpm@linux-foundation.org>
	<20090616190743.GC26722@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZFPTRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 15:17:33 -0400
In-Reply-To: <20090616190743.GC26722@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com

On Tue, 16 Jun 2009 14:07:43 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> > > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > > index 4d4d5e0..e51a0b2 100644
> > > --- a/drivers/block/cciss.c
> > > +++ b/drivers/block/cciss.c
> > > @@ -3935,6 +3935,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
> > >  		return;
> > >  	}
> > >  
> > > +	complete(hba[i]->rescan_wait);
> > >  	kthread_stop(hba[i]->cciss_scan_thread);
> > >  
> > >  	remove_proc_entry(hba[i]->devname, proc_cciss);
> > 
> > Has this been confirmed to fix things?
> 
> Apparently, not. I'm still having issues. I'm sure this worked before my
> patch was finally accepted. That's why I made the thread interruptible. Now
> I see an article on LWN saying that kthread_stop doesn't use signals. It
> says call kthread_should_stop periodically, which I do. How else to stop a
> thread???

Presumably your thread is blocked elsewhere, so it is failing to poll
kthread_should_stop().

When the thread is stuck, do an `echo t > /proc/sysrq-trigger' and find
the thread's stack trace and work out where it's blocked.
