From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] block_abort_queue (blk_abort_request) racing with
 scsi_request_fn
Date: Wed, 17 Nov 2010 09:49:25 -0800
Message-ID: <20101117174925.GA2176@linux.vnet.ibm.com>
References: <20100512052336.GB15240@linux.vnet.ibm.com>
 <4CDA4524.4010204@cs.wisc.edu>
 <4CDA49F8.9050406@cs.wisc.edu>
 <20101110163047.GA26201@linux.vnet.ibm.com>
 <4CDB0BAA.8060801@cs.wisc.edu>
 <20101112175440.GA3978@linux.vnet.ibm.com>
 <20101116213904.GA470@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:38631 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0KQRtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 12:49:33 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id oAHHaHbC006366
	for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2010 10:36:17 -0700
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oAHHnToN159184
	for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2010 10:49:29 -0700
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oAHHrXI7002671
	for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2010 10:53:34 -0700
Content-Disposition: inline
In-Reply-To: <20101116213904.GA470@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> wrote:
> Hi Mike,
> 
> On Fri, Nov 12 2010 at 12:54pm -0500,
> Mike Anderson <andmike@linux.vnet.ibm.com> wrote:
> 
> > By not directly timing out the I/O but accelerating the timeout by a
> > factor. The value could be calculated as a percentage of the queue timeout
> > value for a default with the option of exposing a sysfs attribute
> > similar to fast_io_fail_tmo. The attribute could also provide a off
> > method which we do not have today and is my bad that we do not have one
> > (I posted the features patch to multipath but did not followup which
> > would have provided a off).
> 
> You're referring to these patches:
> https://patchwork.kernel.org/patch/96674/
> https://patchwork.kernel.org/patch/96673/
> 

Yes these are the patches that I was referring to.

> Do you have an interest in pursuing these further? 

Yes.

> In the near-term
> should we default to off (so introduce MP_FEATURE_ABORT_Q) -- given the
> current race which exposes corruption?
> 

Given the current race exposure default to off might be the best choice.

> Or are you now interested in accelerating the timeout?  I'd need to
> review this thread in more detail to give you an opinion.  But I do know
> that simply disabling dm-mpath's call to blk_abort_queue() enables some
> extensive path failure load testing to _not_ cause the list corruption
> that leads to a crash.

I think the on/off control plus a fix to address the issue when it is on
would be good. Since I do not believe we want the impact the normal IO
path by more lock bouncing adding modification of the blk_abort_queue
function appeared like one of the least distributive options. There might
be others.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
