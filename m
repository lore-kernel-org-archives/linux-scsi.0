From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Wed, 19 Jun 2002 14:15:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020619141522.A11733@eng2.beaverton.ibm.com>
References: <20020618204753.A8597@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e1.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g5JLFVg5197674
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 17:15:32 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by northrelay03.pok.ibm.com (8.11.1m3/NCO/VER6.1) with ESMTP id g5JLFTZ43632
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 17:15:29 -0400
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g5JLFPe17660
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 14:15:25 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g5JLFN711772
	for linux-scsi@vger.kernel.org; Wed, 19 Jun 2002 14:15:23 -0700 (PDT)
In-Reply-To: <20020618204753.A8597@redhat.com>; from dledford@redhat.com on Tue, Jun 18, 2002 at 08:47:53PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Jun 18, 2002 at 08:47:53PM -0400, Doug Ledford wrote:

Doug -

> As mentioned, this adds a new scsi_adjust_queue_depth routine that lets 
> the low level driver update the queue depth on a device at any point in 
> time.  So, when Justin Gibbs' driver allocates a queue depth of 253 
> commands on drive X, then finds out that drive X has a hard limit of 64, 
> then we aren't continuing to waste 189 commands worth of allocated kernel 
> memory that can never be effectively used.  Future plans here include 
> linking this into the bio queueing so that adjusting the mid layer queue 
> depth does the "right thing" in regards to the bio layer (for all I know 
> it does already, I haven't gotten into the bio->scsi interface yet).

> Once this stuff is in place, then my next goal is to get the queueing code 
> in the mid layer up to useable standards (the goal is to be able to rip 
> the buts of the QUEUE_FULL and BUSY handling out of my driver and still 
> have the system do the "right thing" instead of my driver having it's own 
> complete internal queue mechanism including timers and such like it does 
> now).

The Scsi_Cmnd initialization should have its own function (maybe
including allocation), called from scsi_adjust_queue_depth and your
new code.

So do you think the current select_queue_depths should (eventually)
be removed?

Not a comment on your patch, but why isn't the queue depth setting
handled completely in the mid-layer?

The cmd_per_lun and can_queue fields are in Scsi_Host, and the mid-layer
already checks for tagged queueing. I don't see what adavantage there
is to having the low level adapters each set the queue depth in their
own way. Plus, a lot of common (and not so common) code would go away.

And then scsi_adjust_queue_depth() could be called when not in interrupt
context.

-- Patrick Mansfield
