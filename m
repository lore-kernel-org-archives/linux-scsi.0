From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Thu, 12 Apr 2012 10:48:20 +0000
Message-ID: <4F86B2F4.3020101@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>    <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>   <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>  <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org> <1333732525.2953.16.camel@dabdike> <4F81CCF9.8010408@acm.org> <4F85CACA.8060803@cs.wisc.edu> <4F85DFEB.5080000@acm.org> <4F860572.6090404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:56008 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab2DLKsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 06:48:25 -0400
In-Reply-To: <4F860572.6090404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/11/12 22:28, Mike Christie wrote:

> On 04/11/2012 02:47 PM, Bart Van Assche wrote:
>> disadvantage is that this approach will only work fine if the LLD stops
>> I/O completion notifications before invoking scsi_remove_host(). Several
> 
> I don't think you would want to do that, because you have IO from the
> sd_shutdown path that you do want to execute. After the remove/shutdown
> callouts have been run then you do not want new IO to be sent to the LLD.
> 
> So scsi_remove_host sets the host state to cancel initially. It then
> calls scsi_forget_host which will loop over devices and remove them.
> That could cause IO to be sent by functions like sd_shutdown.


So that means that with an operational transport layer it's wrong for a
SCSI LLD to stop processing SCSI commands before scsi_remove_host()
finished ? It looks like several SCSI LLD authors are not aware of this.
I have found several examples of high-profile SCSI LLD drivers in the
kernel tree that cause newly submitted SCSI commands to fail during
kernel module removal even before scsi_remove_host() gets invoked.

> After the ULD code is run __scsi_remove_device will set the state to
> SDEV_DEL and scsi_remove_host will then set the state to SHOST_DEL. So
> that would prevent new IO from getting queued.
> 
> But then is there a race that you were hitting?


scsi_remove_host() can get invoked after the SCSI core has submitted a
request to the LLD via queuecommand() but before the LLD has received
the I/O completion notification that will be generated once that request
finishes. I see three alternatives to handle this:
- The LLD stops I/O completion notifications before invoking
  scsi_remove_host() (which is not correct because it prevents
  sd_shutdown() to send SCSI commands to the device).
- The SCSI core keeps the LLD around long enough until it is sure that
  no new I/O notifications will arrive.
- The SCSI LLD stops I/O completion notifications after having invoked
  scsi_remove_host() and kills all pending SCSI commands before
  continuing with LLD-specific host removal tasks. As far as I can see
  the SCSI core doesn't provide a function yet that would allow an
  LLD to kill all pending requests. Maybe blk_abort_queue() could be
  helpful here.

Bart.
