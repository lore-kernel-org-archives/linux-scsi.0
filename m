From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/11] target_core_alua: Use workqueue for ALUA
 transitioning
Date: Wed, 16 Oct 2013 15:06:17 -0700
Message-ID: <1381961177.19256.656.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1381908048-82014-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41291 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3JPV5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 17:57:36 -0400
In-Reply-To: <1381908048-82014-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> Use a workqueue for processing ALUA state transitions; this allows
> us to process implicit delay properly.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c | 174 +++++++++++++++++++++++++++-----------
>  include/target/target_core_base.h |   4 +
>  2 files changed, 128 insertions(+), 50 deletions(-)
> 

<SNIP>

> +static int core_alua_do_transition_tg_pt(
> +	struct t10_alua_tg_pt_gp *tg_pt_gp,
> +	int new_state,
> +	int explicit)
> +{
> +	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +
> +	/* Nothing to be done here */
> +	if (atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state) == new_state)
> +		return 0;
> +
> +	if (new_state == ALUA_ACCESS_STATE_TRANSITION)
> +		return -EAGAIN;
> +
> +	/*
> +	 * Flush any pending transitions
> +	 */
> +	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs &&
> +	    atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state) ==
> +	    ALUA_ACCESS_STATE_TRANSITION) {
> +		/* Just in case */
> +		tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
> +		tg_pt_gp->tg_pt_gp_transition_complete = &wait;
> +		flush_delayed_work(&tg_pt_gp->tg_pt_gp_transition_work);
> +		wait_for_completion(&wait);
> +		tg_pt_gp->tg_pt_gp_transition_complete = NULL;
> +		return 0;
> +	}
> +
> +	/*
> +	 * Save the old primary ALUA access state, and set the current state
> +	 * to ALUA_ACCESS_STATE_TRANSITION.
> +	 */
> +	tg_pt_gp->tg_pt_gp_alua_previous_state =
> +		atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
> +	tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
> +
> +	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
> +			ALUA_ACCESS_STATE_TRANSITION);
> +	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
> +				ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
> +				ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
> +
> +	/*
> +	 * Check for the optional ALUA primary state transition delay
> +	 */
> +	if (tg_pt_gp->tg_pt_gp_trans_delay_msecs != 0)
> +		msleep_interruptible(tg_pt_gp->tg_pt_gp_trans_delay_msecs);
> +
> +	/*
> +	 * Take a reference for workqueue item
> +	 */
> +	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> +	atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
> +	smp_mb__after_atomic_inc();
> +	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
> +
> +	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs) {
> +		unsigned long transition_tmo;
> +
> +		transition_tmo = tg_pt_gp->tg_pt_gp_implicit_trans_secs * HZ;
> +		queue_delayed_work(tg_pt_gp->tg_pt_gp_dev->tmr_wq,
> +				   &tg_pt_gp->tg_pt_gp_transition_work,
> +				   transition_tmo);
> +	} else {
> +		tg_pt_gp->tg_pt_gp_transition_complete = &wait;
> +		queue_delayed_work(tg_pt_gp->tg_pt_gp_dev->tmr_wq,
> +				   &tg_pt_gp->tg_pt_gp_transition_work, 0);
> +		wait_for_completion(&wait);
> +		tg_pt_gp->tg_pt_gp_transition_complete = NULL;
> +	}

Mmm, the trans_delay_msecs delay seems a bit out of place now..

How about dropping it's usage with msleep_interruptible() above, and
instead combining it with the delay passed into queue_delayed_work()..?

--nab


