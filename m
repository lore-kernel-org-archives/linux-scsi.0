From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the
 error handler
Date: Tue, 27 May 2014 08:56:22 +0000
Message-ID: <1401180980.14454.31.camel@dabdike>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
		 <53835C55.6070400@redhat.com> <5384476F.6010705@acm.org>
	 <1401178172.14454.12.camel@dabdike> <53844E8E.7010404@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:55850 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaE0I42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 04:56:28 -0400
In-Reply-To: <53844E8E.7010404@acm.org>
Content-Language: en-US
Content-ID: <3A910EEBF7DBE242AB3CAF795920FC08@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Tue, 2014-05-27 at 10:36 +0200, Bart Van Assche wrote:
> On 05/27/14 10:09, James Bottomley wrote:
> > On Tue, 2014-05-27 at 10:06 +0200, Bart Van Assche wrote:
> >> As you probably know scsi_put_command() can get called from softirq
> >> context. A BUG_ON() in that context might make it unnecessary hard for a
> >> user to collect call traces.
> > 
> > Why?  The messages dumped are the same, the trace just starts from the
> > IRQ context ... I don't see what the problem is.
> > 
> > The question isn't ease of gathering the data, it's correctness.  The
> > point is that if the assert fails we have a free of an in-use command
> > leading to a nasty use after free ... the machine state is hosed at that
> > point.
> 
> Please keep in mind that even if the SCSI mid-layer functions correctly
> it is still possible that another driver in the system could cause these
> tests to fail if it triggers e.g. a use-after-free.
> 
> If BUG_ON() is invoked the dumped message will be displayed on the
> screen but will not be saved in the system log. This is inconvenient
> because it means that if someone wants to capture the dumped message a
> camera is necessary and one has to step to the physical console to
> capture this message. Using WARN_ON() or WARN_ON_ONCE() makes it a lot
> easier for users to capture any message that is displayed.

This isn't debatable: we code for the safety of the user not for some
academic need to capture data; if you don't understand that, you might
like to re-review systems design.  If this assertion fails, the system
state is corrupt and if we let it continue, that corruption will
propagate.  The *only* safe course that protects the user is to stop it
as fast as possible, hopefully before the corruption penetrates to the
permanent storage.

The whole reason BUG_ON doesn't leave a log trace is to try to prevent
corruption propagating to the data storage devices.  What you propose
would be inviting that corruption in the name of getting a log entry.

If I prioritise getting log information over protecting user data, no
user would, quite rightly, ever trust Linux to store their vital
information.

James

