From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] resubmit cciss: kernel thread to detect changes on
	MSA2012
Date: Sat, 07 Mar 2009 14:36:38 -0600
Message-ID: <1236458199.3670.29.camel@localhost.localdomain>
References: <20090306181603.GA30801@roadking.ldev.net>
	 <1236363867.12019.2.camel@localhost.localdomain>
	 <20090306232918.GA586@beardog.cca.cpqcorp.net>
	 <20090306155623.2e817207.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33130 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbZCGUgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2009 15:36:48 -0500
In-Reply-To: <20090306155623.2e817207.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, coldwell@redhat.com

On Fri, 2009-03-06 at 15:56 -0800, Andrew Morton wrote:
> On Fri, 6 Mar 2009 17:29:18 -0600
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > On Fri, Mar 06, 2009 at 12:24:27PM -0600, James Bottomley wrote:
> > > On Fri, 2009-03-06 at 12:16 -0600, Mike Miller wrote:
> > > > Patch 1 of 2
> > > > 
> > > > This is a resubmission of yesterdays patch to detect changes on the MSA2012.
> > > > I hope I've addressed all concerns. This patch rearranges some of the code
> > > > so we also have coverage in the sg and the ioctl paths as well as the main
> > > > data path.
> > > > 
> > > > The MSA2012 cannot inform the driver of configuration changes since all
> > > > management is out of band. This is a departure from any storage we have
> > > > supported in the past. We need some way to detect changes on the topology so
> > > > we implement this kernel thread. In some instances there's nothing we can do
> > > > from the driver (like LUN failure) so just print out a message. In the case
> > > > where logical volumes are added or deleted we call rebuild_lun_table to
> > > > refreash the driver's view of the world.
> > > > 
> > > > Please consider this for inclusion.
> > > 
> > > I still don't quite see how the thread stops on module removal ... there
> > > needs to be an explicit kthread_stop() somewhere in the clean up path.
> > > 
> > > James
> > > 
> > > 
> > This time I make a call to kthread_stop in cciss_remove_one. The driver can
> > be unloaded and the thread gets cleaned up.
> 
> Please include a complete (and suitably updated) copy of the changelog
> with each iteration of a patch.
> 
> 
> > KNOWN BUG: it seems the timeout must expire before kthread_stop actually
> > stops the thread. This causes the driver to hang and wait during rmmod. I've
> > played around with several things but haven't found the correct way to
> > address the problem. Looking at other drivers hasn't been much help. Any
> > advice is greatly appreciated.
> 
> Well, wait_for_completion_timeout() is only going to return when the
> timeout timed out, or someone ran complete().
> 
> > +static int scan_thread(ctlr_info_t *h)
> > +{
> > +	int rc;
> > +	DECLARE_COMPLETION_ONSTACK(wait);
> > +	h->rescan_wait = &wait;
> > +
> > +	while (!kthread_should_stop()) {
> > +		rc = wait_for_completion_timeout(&wait, 300 * HZ);
> > +		if (!rc)
> > +			continue;
> > +		else
> > +			rebuild_lun_table(h, 0);
> > +	}
> > +	return 0;
> > +}
> 
> So..  we shouldn't need the timeout here at all - just use
> wait_for_completion().
> 
> static int scan_thread(ctlr_info_t *h)
> {
> 	DECLARE_COMPLETION_ONSTACK(wait);
> 
> 	h->rescan_wait = &wait;
> 	for ( ; ; ) {
> 		wait_for_completion(&wait);
> 		if (kthread_should_stop())
> 			break;
> 		rebuild_lun_table(h, 0);
> 	}
> 	return 0;
> }
> 
> And on the teardown path, do
> 
> 	complete(...);
> 	kthread_stop(...);

This is racy ... although I think the race would only show in a pre-empt
kernel:  complete causes the thread to run immediately pre-empting us.
Now it runs around the loop, through kthread_should_stop() and back to
wait_for_completion() before we get a chance to run kthread_stop().

The only way to avoid this seems to be to use wait queues and wake up
(kthread_stop does an automatic wake_up of the process, which is ignored
by completions).

James


