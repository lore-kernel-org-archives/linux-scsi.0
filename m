From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] qlogicpti: Add missing parentheses
Date: Fri, 20 Feb 2009 00:51:28 -0800 (PST)
Message-ID: <20090220.005128.240701957.davem@davemloft.net>
References: <499C038B.7050607@gmail.com>
	<20090218.143916.50840604.davem@davemloft.net>
	<20090219130142.4442c1a5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59438
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753203AbZBTIvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 03:51:47 -0500
In-Reply-To: <20090219130142.4442c1a5.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: roel.kluin@gmail.com, linux-scsi@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 19 Feb 2009 13:01:42 -0800

> On Wed, 18 Feb 2009 14:39:16 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Roel Kluin <roel.kluin@gmail.com>
> > Date: Wed, 18 Feb 2009 13:48:11 +0100
> > 
> > > Add missing parentheses
> > > 
> > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > 
> > So what bug does this cause?
> > 
> > >  #define QLOGICPTI_REQ_QUEUE_LEN	255	/* must be power of two - 1 */
> > > -#define QLOGICPTI_MAX_SG(ql)	(4 + ((ql) > 0) ? 7*((ql) - 1) : 0)
> > > +#define QLOGICPTI_MAX_SG(ql)	(4 + (((ql) > 0) ? 7*((ql) - 1) : 0))
> > 
> > The "ql > 0" bids to the "?" operator, so this expression
> > does the right thing as-is as far as I can tell.
> > 
> > Do you think that "4 + ((ql > 0)" binds to "?", I don't think
> > it does.
> 
> The code is crap, and buggy if passed an expression with side-effects. 

Thank got it never is called that way :-)

> Now, 4 plus a boolean can only ever evaluate to 4 or 5, so this
> function can never return zero.  So yeah, I assume that this was meant:
> 
> static inline int qlogicpti_max_sg(int ql)
> {
> 	if (ql > 0)
> 		return 7 * (ql - 1) + 4;
> 	else
> 		return 4;
> }
> 

I think this doesn't even match the intention, and I wrote
the code so...

We want to return 0 if the queue has no free entries.
But if it does have free slots, we want "4 + xxx"

These problems probably explain the mysterious workaround
in update_can_queue().
