From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the error
 handler
Date: Tue, 27 May 2014 10:36:30 +0200
Message-ID: <53844E8E.7010404@acm.org>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>	 <53835C55.6070400@redhat.com> <5384476F.6010705@acm.org> <1401178172.14454.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:57445 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaE0Igc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 04:36:32 -0400
In-Reply-To: <1401178172.14454.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On 05/27/14 10:09, James Bottomley wrote:
> On Tue, 2014-05-27 at 10:06 +0200, Bart Van Assche wrote:
>> As you probably know scsi_put_command() can get called from softirq
>> context. A BUG_ON() in that context might make it unnecessary hard for a
>> user to collect call traces.
> 
> Why?  The messages dumped are the same, the trace just starts from the
> IRQ context ... I don't see what the problem is.
> 
> The question isn't ease of gathering the data, it's correctness.  The
> point is that if the assert fails we have a free of an in-use command
> leading to a nasty use after free ... the machine state is hosed at that
> point.

Please keep in mind that even if the SCSI mid-layer functions correctly
it is still possible that another driver in the system could cause these
tests to fail if it triggers e.g. a use-after-free.

If BUG_ON() is invoked the dumped message will be displayed on the
screen but will not be saved in the system log. This is inconvenient
because it means that if someone wants to capture the dumped message a
camera is necessary and one has to step to the physical console to
capture this message. Using WARN_ON() or WARN_ON_ONCE() makes it a lot
easier for users to capture any message that is displayed.

Bart.

