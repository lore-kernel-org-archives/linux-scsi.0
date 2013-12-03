From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] qla2xxx: Question about out-of-order SCSI command
 processing
Date: Tue, 03 Dec 2013 10:34:09 -0800
Message-ID: <1386095649.2166.104.camel@dabdike.int.hansenpartnership.com>
References: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
	 <1386027526.2014.2.camel@dabdike.int.hansenpartnership.com>
	 <529DCDE5.6010304@acm.org>
	 <1386077157.2166.16.camel@dabdike.int.hansenpartnership.com>
	 <CAB-428mPDKLKB_20jsUudU1OZ2rphYrjWx00ikAe1gK3_AnuPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52291 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab3LCSeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2013 13:34:11 -0500
In-Reply-To: <CAB-428mPDKLKB_20jsUudU1OZ2rphYrjWx00ikAe1gK3_AnuPQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Jerry Fredin <jerry.fredin@netapp.com>

On Tue, 2013-12-03 at 11:46 -0600, Alireza Haghdoost wrote:
> On Tue, Dec 3, 2013 at 7:25 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Well, no, we could have used Ordered instead of Simple tags ... that
> > would preserve submission order according to spec.  This wouldn't really
> > work for SATA because NCQ only has simple tags.
> 
> Thanks a lot James for your comments. Is it possible to configure TCQ
> mode to the Ordered tag instead of Simple tags? I understand that NCQ
> does not support Ordered tags but I think it would be nice to keep
> this functionality as an option for other SCSI targets like qla2xxx.
> I can see the discussion about TAG ordering in the mailing list.
> However, I am not sure if it is functional right now or not.

It's set in the scsi_populate_tag() inline function (scsi_tcq.h).
That's currently hard coded to simple tags.

> > The point is that our
> > granular unit of ordering is between two barriers, which is way above
> > the request/tag level so we didn't bother to enforce tag ordering.
> 
> Does a barrier force flush all in_flight SCSI commands ?

A flush barrier does, yes ... that's the predominant implementation.

>  Based on my
> understanding if we put a barrier between multiple requests, it wont
> return until TCQ process all in_flight scsi commands. Which means we
> can not keep a fixed load on TCQ and it would certainly reduce the
> throughput of our application.

Yes, that's what we see in filesystems with barriers enabled.  It's the
price we pay for integrity.

> > However, handling
> > strict ordering in the face of requeuing events like QUEUE FULL or BUSY
> > is hard so we didn't bother.
> 
> We have a peace of code to monitor in_flight requests and avoid
> QUEUE_FULL events. However, would you please let us know a case that
> cause a BUSY events ? Does it means the scsi target is busy processing
> other requests with-in the same host machine ?

BUSY is a catch all status.  It's different from QUEUE FULL because
queue tracking algorithms use QUEUE FULL to determine the optimal number
of in-flight commands (we can do that in the mid-layer today with the
queue full tracking code).  BUSY means the command needs retrying
because of some other condition on the initiator that isn't connected
with the task queues, so it isn't counted against the queue full status
tracking for reducing command flows.  It's most often returned by
multi-initiator devices in the presence of management (or even
statistics type) conditions, or because of scheduling or caching issues.

James


