From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/8] target_core_alua: store old and pending ALUA state
Date: Tue, 17 Dec 2013 11:32:28 -0800
Message-ID: <1387308748.20247.295.camel@haakon3.risingtidesystems.com>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
	 <1387268330-121064-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35607 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3LQTbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 14:31:33 -0500
In-Reply-To: <1387268330-121064-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
> During state transition we should be storing both the original
> and the pending state.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c | 15 ++++++++++-----
>  include/target/target_core_base.h |  2 ++
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 

Applied to for-next.

--nab

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 738244b..4805e97 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -812,12 +812,15 @@ static int core_alua_do_transition_tg_pt(
>  	struct se_lun_acl *lacl;
>  	struct se_port *port;
>  	struct t10_alua_tg_pt_gp_member *mem;
> -	int old_state = 0;
> +
>  	/*
>  	 * Save the old primary ALUA access state, and set the current state
>  	 * to ALUA_ACCESS_STATE_TRANSITION.
>  	 */
> -	old_state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
> +	tg_pt_gp->tg_pt_gp_alua_previous_state =
> +		atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
> +	tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
> +
>  	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
>  			ALUA_ACCESS_STATE_TRANSITION);
>  	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
> @@ -898,13 +901,15 @@ static int core_alua_do_transition_tg_pt(
>  	/*
>  	 * Set the current primary ALUA access state to the requested new state
>  	 */
> -	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state, new_state);
> +	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
> +		   tg_pt_gp->tg_pt_gp_alua_pending_state);
>  
>  	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
>  		" from primary access state %s to %s\n", (explicit) ? "explicit" :
>  		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
> -		tg_pt_gp->tg_pt_gp_id, core_alua_dump_state(old_state),
> -		core_alua_dump_state(new_state));
> +		tg_pt_gp->tg_pt_gp_id,
> +		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_previous_state),
> +		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_pending_state));
>  
>  	return 0;
>  }
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 6e95281..6758e81 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -284,6 +284,8 @@ struct t10_alua_tg_pt_gp {
>  	u16	tg_pt_gp_id;
>  	int	tg_pt_gp_valid_id;
>  	int	tg_pt_gp_alua_supported_states;
> +	int	tg_pt_gp_alua_pending_state;
> +	int	tg_pt_gp_alua_previous_state;
>  	int	tg_pt_gp_alua_access_status;
>  	int	tg_pt_gp_alua_access_type;
>  	int	tg_pt_gp_nonop_delay_msecs;


