From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] qlogicpti: Add missing parentheses
Date: Thu, 19 Feb 2009 13:01:42 -0800
Message-ID: <20090219130142.4442c1a5.akpm@linux-foundation.org>
References: <499C038B.7050607@gmail.com>
	<20090218.143916.50840604.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782AbZBSVCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 16:02:16 -0500
In-Reply-To: <20090218.143916.50840604.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: roel.kluin@gmail.com, linux-scsi@vger.kernel.org

On Wed, 18 Feb 2009 14:39:16 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Roel Kluin <roel.kluin@gmail.com>
> Date: Wed, 18 Feb 2009 13:48:11 +0100
> 
> > Add missing parentheses
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> So what bug does this cause?
> 
> >  #define QLOGICPTI_REQ_QUEUE_LEN	255	/* must be power of two - 1 */
> > -#define QLOGICPTI_MAX_SG(ql)	(4 + ((ql) > 0) ? 7*((ql) - 1) : 0)
> > +#define QLOGICPTI_MAX_SG(ql)	(4 + (((ql) > 0) ? 7*((ql) - 1) : 0))
> 
> The "ql > 0" bids to the "?" operator, so this expression
> does the right thing as-is as far as I can tell.
> 
> Do you think that "4 + ((ql > 0)" binds to "?", I don't think
> it does.

The code is crap, and buggy if passed an expression with side-effects. 
Let's turn it into the way it _should_ have been written.

yes, "+" has higher precedence than ?:, so the current code is:

static inline int qlogicpti_max_sg(int ql)
{
	if (4 + (ql > 0))
		return 7 * (ql - 1);
	else
		return 0;
}

Now, 4 plus a boolean can only ever evaluate to 4 or 5, so this
function can never return zero.  So yeah, I assume that this was meant:

static inline int qlogicpti_max_sg(int ql)
{
	if (ql > 0)
		return 7 * (ql - 1) + 4;
	else
		return 4;
}

