From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in
 target_get_sess_cmd()
Date: Tue, 17 Jul 2012 16:24:21 -0700
Message-ID: <1342567461.18004.517.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-6-git-send-email-roland@kernel.org>
	 <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
	 <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com>
	 <1342490218.18004.382.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDUVaF_GGwN_0nYD2X87Sa0hwiihuua9HJgK=CJ7HiFv_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDUVaF_GGwN_0nYD2X87Sa0hwiihuua9HJgK=CJ7HiFv_w@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-07-17 at 09:34 -0700, Roland Dreier wrote:
> On Mon, Jul 16, 2012 at 6:56 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >> Do you have a plan for how to handle this?  Do we really want to plumb
> >> through another callback to tell the fabric driver to free the command
> >> in this case?
> 
> > I need to think more about this ahead of changing it back again for-3.6
> > now that other fabrics have the assumption of target_submit_cmd() would
> > not fail.
> 
> > There is a clear case with qla2xxx for just changing it back (we might
> > end up doing that just yet) but I wanted to get the other important bits
> > into for-next into place first..
> 
> Sleeping on things, I now feel pretty strongly that having target_submit_cmd
> return an error value for "immediate" errors where the command does not
> make it into the target core is the right approach.
> 
> Freeing commands is already one of the most confusing and complex parts
> of the target code, with "check_stop_free," "cmd_wait_comp" and
> "SCF_ACK_KREF."  Adding another code flow back to the fabric driver
> with yet another set of semantics around freeing a command seems like
> it's making things even harder to maintain.
> 

I wasn't talking about adding another release path.  I was thinking more
about a TFO call to optionally abort HW/SW exchange if we can't accept
the command in question.

Not to mention, this could end up being useful for other purposes beyond
the initial target_submit_cmd() failure case due to active I/O shutdown.
(aborts + active I/O shutdown with active SRP WRITEs with ib_srpt come
to mind needing something like this..)

> On the other hand, every caller of target_submit_cmd() in the tree already
> has an error path where it handles problems it detects right before calling
> target_submit_cmd(), and so it's trivial to share that for problems detected
> inside target_submit_cmd().  If you look at patch 4/7, pretty much the
> only changes are like going from
> 
>     target_submit_cmd(...);
> 
> to
> 
>     if (target_submit_cmd(...))
>         goto err;
> 
> and in fact the ->handle_cmd() wrapper that qla_target uses to call
> target_submit_cmd via tcm_qla2xxx already has a return value that
> qla_target handled properly!
> 

Sure, there is no doubting tcm_qla2xxx's usage of this return value back
into qla_target.c code.. 

> I guess another approach would be to split target_submit_cmd() into
> the target_get_sess_cmd() part and the rest of it, and have fabric
> drivers handle errors queueing commands but not have to worry about
> the submit cmd part failing.  But I'm not sure that's any better.
> 
> Andy, any feelings about this one way or another?  Christoph?
> 

Ok, so for-3.6 it makes the most sense to just convert this back to
propagate up the return code, but only for target_get_sess_cmd() failure
case..

That said, I'll go ahead and respin patch #4 on top of for-next, and
post the updated patch shortly with the same CC's and ask for ACKs from
the necessary folks.

--nab
