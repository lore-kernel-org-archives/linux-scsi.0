From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Wed, 16 May 2012 11:59:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205161156480.1852-100000@iolanthe.rowland.org>
References: <1337182820.4047.18.camel@hp6530s>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54037 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756094Ab2EPP7f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 11:59:35 -0400
In-Reply-To: <1337182820.4047.18.camel@hp6530s>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 16 May 2012, Lin Ming wrote:

> > Lin, you should have more slack timer handling. Look at the blk-timeout
> > handling of request timeouts for inspiration, and/or the thread that
> > Jeff also references. Doing a timer add/del for each request put is a no
> > go.
> 
> You mentioned how to detect queue idle in the referenced thread:
> 	
> ===
> So we could probably add an idle timer that is set to some suitable
> timeout for this and would be added when the queue first goes empty. If
> new requests come in, just let it simmer and defer checking the state to
> when it actually fires.

That is basically how the runtime PM timer works, if you use it as I 
described earlier.

> ===
> 
> What do you mean of "the queue first goes empty"?

When the queue is first created, the timer is started.

Whenever the timer expires, the code checks to see if any requests have 
been processed since the previous expiration.  If they have, the timer 
is restarted.  If they haven't, you suspend the device.

Alan Stern

