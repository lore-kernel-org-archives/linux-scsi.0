From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Wed, 11 Apr 2012 17:28:02 -0500
Message-ID: <4F860572.6090404@cs.wisc.edu>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>    <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>   <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>  <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org> <1333732525.2953.16.camel@dabdike> <4F81CCF9.8010408@acm.org> <4F85CACA.8060803@cs.wisc.edu> <4F85DFEB.5080000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45683 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933509Ab2DKW2O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 18:28:14 -0400
In-Reply-To: <4F85DFEB.5080000@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/11/2012 02:47 PM, Bart Van Assche wrote:
> On 04/11/12 18:17, Mike Christie wrote:
> 
>> I would like scsi core to handle this, but I think right now drivers are
>> doing work arounds like your patch.
> 
> 
> I've been wondering whether the following approach would make sense
> (haven't tested this yet):
> - Let scsi_remove_host() stop the SCSI error handler thread instead of
>   keeping the error handler thread around until scsi_host_dev_release()
>   gets invoked.
> - After blk_cleanup_queue() finished, kill all outstanding SCSI
>   requests from inside scsi_remove_device() (those requests that have
>   already been passed to the LLD via queuecommand) instead of waiting
>   until the SCSI error handler detects a timeout.
> 
> An advantage of that approach would be that independent of the context
> from which an I/O request is submitted (scanning / user space / ...)
> that no new requests would be passed to the SCSI LLD after
> scsi_remove_host() has finished. So this approach could be an
> alternative for Tomas' patch at the start of this thread. However, a

I do not think it solve's Tomas's issue, because if a async scan is
running it could have already completed the scan related IO and is just
about to call the slave_configure callout when the user does a rmmod.
The scsi_remove_host from the rmmod will not see any IOs in flight and
go right along removing the host and rmmod will complete and remove the
module. The scsi_scan.c code could then try to access the
slave_configure callout which is now invalid.


> disadvantage is that this approach will only work fine if the LLD stops
> I/O completion notifications before invoking scsi_remove_host(). Several

I don't think you would want to do that, because you have IO from the
sd_shutdown path that you do want to execute. After the remove/shutdown
callouts have been run then you do not want new IO to be sent to the LLD.

So scsi_remove_host sets the host state to cancel initially. It then
calls scsi_forget_host which will loop over devices and remove them.
That could cause IO to be sent by functions like sd_shutdown.

After the ULD code is run __scsi_remove_device will set the state to
SDEV_DEL and scsi_remvoe_host will then set the state to SHOST_DEL. So
that would prevent new IO from getting queued.

But then is there a race that you were hitting? Were you hitting
something like IO was in the reuqest_queue, the sd_shutdown IO got
queued before those IOs, but then the sd shutdown IO completed and the
other queued IO got sent to the LLD before the sdev state could get set
to SDEV_DEL. So then IO could get sent to the LLD queuecommand when we
did not want it to.
