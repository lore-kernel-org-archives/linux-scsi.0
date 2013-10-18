From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/11] target_core_alua: Use workqueue for ALUA
 transitioning
Date: Fri, 18 Oct 2013 12:04:10 -0700
Message-ID: <1382123050.19256.686.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1381908048-82014-10-git-send-email-hare@suse.de>
	 <1381961177.19256.656.camel@haakon3.risingtidesystems.com>
	 <525F892A.9060309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <525F892A.9060309@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-10-17 at 08:52 +0200, Hannes Reinecke wrote:
> On 10/17/2013 12:06 AM, Nicholas A. Bellinger wrote:
> > On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> >> Use a workqueue for processing ALUA state transitions; this allows
> >> us to process implicit delay properly.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  drivers/target/target_core_alua.c | 174 +++++++++++++++++++++++++++-----------
> >>  include/target/target_core_base.h |   4 +
> >>  2 files changed, 128 insertions(+), 50 deletions(-)
> >>
> > 
> > <SNIP>
> > 
> >> +static int core_alua_do_transition_tg_pt(
> >> +	struct t10_alua_tg_pt_gp *tg_pt_gp,
> >> +	int new_state,
> >> +	int explicit)
> >> +{
> >> +	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
> >> +	DECLARE_COMPLETION_ONSTACK(wait);
> >> +
> >> +	/* Nothing to be done here */
> >> +	if (atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state) == new_state)
> >> +		return 0;
> >> +
> >> +	if (new_state == ALUA_ACCESS_STATE_TRANSITION)
> >> +		return -EAGAIN;
> >> +
> >> +	/*
> >> +	 * Flush any pending transitions
> >> +	 */
> >> +	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs &&
> >> +	    atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state) ==
> >> +	    ALUA_ACCESS_STATE_TRANSITION) {
> >> +		/* Just in case */
> >> +		tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
> >> +		tg_pt_gp->tg_pt_gp_transition_complete = &wait;
> >> +		flush_delayed_work(&tg_pt_gp->tg_pt_gp_transition_work);
> >> +		wait_for_completion(&wait);
> >> +		tg_pt_gp->tg_pt_gp_transition_complete = NULL;
> >> +		return 0;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Save the old primary ALUA access state, and set the current state
> >> +	 * to ALUA_ACCESS_STATE_TRANSITION.
> >> +	 */
> >> +	tg_pt_gp->tg_pt_gp_alua_previous_state =
> >> +		atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
> >> +	tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
> >> +
> >> +	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
> >> +			ALUA_ACCESS_STATE_TRANSITION);
> >> +	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
> >> +				ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
> >> +				ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
> >> +
> >> +	/*
> >> +	 * Check for the optional ALUA primary state transition delay
> >> +	 */
> >> +	if (tg_pt_gp->tg_pt_gp_trans_delay_msecs != 0)
> >> +		msleep_interruptible(tg_pt_gp->tg_pt_gp_trans_delay_msecs);
> >> +
> >> +	/*
> >> +	 * Take a reference for workqueue item
> >> +	 */
> >> +	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> >> +	atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
> >> +	smp_mb__after_atomic_inc();
> >> +	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
> >> +
> >> +	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs) {
> >> +		unsigned long transition_tmo;
> >> +
> >> +		transition_tmo = tg_pt_gp->tg_pt_gp_implicit_trans_secs * HZ;
> >> +		queue_delayed_work(tg_pt_gp->tg_pt_gp_dev->tmr_wq,
> >> +				   &tg_pt_gp->tg_pt_gp_transition_work,
> >> +				   transition_tmo);
> >> +	} else {
> >> +		tg_pt_gp->tg_pt_gp_transition_complete = &wait;
> >> +		queue_delayed_work(tg_pt_gp->tg_pt_gp_dev->tmr_wq,
> >> +				   &tg_pt_gp->tg_pt_gp_transition_work, 0);
> >> +		wait_for_completion(&wait);
> >> +		tg_pt_gp->tg_pt_gp_transition_complete = NULL;
> >> +	}
> > 
> > Mmm, the trans_delay_msecs delay seems a bit out of place now..
> > 
> > How about dropping it's usage with msleep_interruptible() above, and
> > instead combining it with the delay passed into queue_delayed_work()..?
> > 
> Yeah, we could.
> Actually I was thinking of opening up the implicit transition time
> to be a general transitioning time, to be used for both implicit and
> explicit.

Sounds reasonable to me..

> Reasoning here is that one could kick off a userland tool once
> 'transitioning' mode has been requested.
> That tool would then go ahead and do whatever is required to switch
> paths around etc, and could write the final ALUA state into configfs.
> That would then terminate the workqueue and the system would
> continue with the new state.
> If the userland tool fails to execute in time the system would
> revert to the requested state as it does now.

Also sounds reasonable.  This timeout, along with the explicit +
implicit timeout probably needs to be limited to a value less than the
SCSI abort timeout on the host side..

> 
> The only problem with that approach is that it's currently
> impossible to have an atomic implicit transition for several tpgs.
> 
> You can to an atomic _explicit_ transition, as SET TARGET PORT
> GROUPS _can_ carry information about all target port groups.
> (Mind you, scsi_dh_alua doesn't use it that way, it only sends
> information for the active/optimized target port group).
> But you cannot achieve a similar operation via configfs; there you
> can only set one tpg at a time, and each of this will potentially
> trigger a move to transitioning.
> 
> While this is not a violation of the spec, it is certainly
> confusing. I'd rather have a way to set the new state for _all_ tpgs
> at once and only then kick off the transitioning mechanism.
> 
> Any ideas how this could be achieved?
> 

Two ideas..

The first would be to add a new attribute at 

   /sys/kernel/config/target/core/$HBA/$DEV/alua/do_transition

that triggers the implicit transitions for each 
../$HBA/$DEV/alua/$TG_PT_GP that has had a queue_transition (or
something to that effect) bit set..

The second is similar, but would involve putting the do_transition
attribute into ../$HBA/$DEV/attrib/ instead of the ../alua directory, in
order to avoid some minor breakage with lio-utils that incorrectly
assumes everything in ../alua/ is a configfs directory.

--nab
