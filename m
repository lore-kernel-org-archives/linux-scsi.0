From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 02/11] IB/srp: simplify state tracking
Date: Mon, 26 Nov 2012 22:56:41 -0500
Message-ID: <1353988601.28917.18.camel@obelisk.thedillows.org>
References: <cover.1353903448.git.dillowda@ornl.gov>
	 <6f9ad200f981a2fe49319e7437c842f03063a4f1.1353903448.git.dillowda@ornl.gov>
	 <50B33A91.3060103@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50B33A91.3060103-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-11-26 at 10:46 +0100, Bart Van Assche wrote:
> On 11/26/12 05:44, David Dillow wrote:
> > The state of the target has several conditions that overlap, making it
> > easier to model as a bit-field of exceptional conditions rather than an
> > enum of all possible states.
> >
> > Bart Van Assche did the hard work of identifying the states that can be
> > removed, and did a first patch that consolidated the state space.
> [ ... ]
> 
> Hi Dave,
> 
> Could you please explain why you would prefer to use test_bit () / 
> test_and_set_bit() and clear_bit() for managing the SRP target state ? 
> As far as I can see the target state is not changed in any code path 
> where it matters how fast the state is changed. Maybe I'm missing 
> something ?

I don't think you are missing anything; if anything, I probably am. I
still believe that there is a possibility of overlapping states, and
some of the changes you had introduced had us checking multiple state
variables to see if we could perform an action. Moving to bit flags
cleaned that up, at least in my head.

Your more recent series does not need to check multiple variables given
the target block, and while resource lifetimes confuse the various
states, I may be inclined to go back to your set. It's had more testing,
for sure.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
