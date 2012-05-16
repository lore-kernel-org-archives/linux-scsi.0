From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Thu, 17 May 2012 00:12:10 +0800
Message-ID: <1337184730.4047.21.camel@hp6530s>
References: <Pine.LNX.4.44L0.1205161156480.1852-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2EPQMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 12:12:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.1205161156480.1852-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2012-05-16 at 11:59 -0400, Alan Stern wrote:
> On Wed, 16 May 2012, Lin Ming wrote:
> 
> > > Lin, you should have more slack timer handling. Look at the blk-timeout
> > > handling of request timeouts for inspiration, and/or the thread that
> > > Jeff also references. Doing a timer add/del for each request put is a no
> > > go.
> > 
> > You mentioned how to detect queue idle in the referenced thread:
> > 	
> > ===
> > So we could probably add an idle timer that is set to some suitable
> > timeout for this and would be added when the queue first goes empty. If
> > new requests come in, just let it simmer and defer checking the state to
> > when it actually fires.
> 
> That is basically how the runtime PM timer works, if you use it as I 
> described earlier.
> 
> > ===
> > 
> > What do you mean of "the queue first goes empty"?
> 
> When the queue is first created, the timer is started.
> 
> Whenever the timer expires, the code checks to see if any requests have 
> been processed since the previous expiration.  If they have, the timer 
> is restarted.  If they haven't, you suspend the device.

And the timer is restarted when we resume the device, right?

> 
> Alan Stern
> 


