From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 06/11] target_core_alua: Validate ALUA state transition
Date: Wed, 16 Oct 2013 14:40:36 -0700
Message-ID: <1381959636.19256.651.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1381908048-82014-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381908048-82014-7-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> As we now can modify the list of supported states we need to
> validate the requested ALUA state when doing a state transition.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

Looks good.

--nab

>  drivers/target/target_core_alua.c | 85 ++++++++++++++++++++++++++-------------
>  1 file changed, 56 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index a16115e..a420778 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -41,7 +41,8 @@
>  #include "target_core_alua.h"
>  #include "target_core_ua.h"
>  
> -static sense_reason_t core_alua_check_transition(int state, int *primary);
> +static sense_reason_t core_alua_check_transition(int state, int valid,
> +						 int *primary);
>  static int core_alua_set_tg_pt_secondary_state(
>  		struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
>  		struct se_port *port, int explicit, int offline);
> @@ -210,7 +211,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
>  	unsigned char *ptr;
>  	sense_reason_t rc = TCM_NO_SENSE;
>  	u32 len = 4; /* Skip over RESERVED area in header */
> -	int alua_access_state, primary = 0;
> +	int alua_access_state, primary = 0, valid_states;
>  	u16 tg_pt_id, rtpi;
>  
>  	if (!l_port)
> @@ -252,6 +253,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
>  		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
>  		goto out;
>  	}
> +	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
>  
>  	ptr = &buf[4]; /* Skip over RESERVED area in header */
>  
> @@ -263,7 +265,8 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
>  		 * the state is a primary or secondary target port asymmetric
>  		 * access state.
>  		 */
> -		rc = core_alua_check_transition(alua_access_state, &primary);
> +		rc = core_alua_check_transition(alua_access_state,
> +						valid_states, &primary);
>  		if (rc) {
>  			/*
>  			 * If the SET TARGET PORT GROUPS attempts to establish
> @@ -614,21 +617,57 @@ out:
>  	return 0;
>  }
>  
> +static char *core_alua_dump_state(int state)
> +{
> +	switch (state) {
> +	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
> +		return "Active/Optimized";
> +	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
> +		return "Active/NonOptimized";
> +	case ALUA_ACCESS_STATE_STANDBY:
> +		return "Standby";
> +	case ALUA_ACCESS_STATE_UNAVAILABLE:
> +		return "Unavailable";
> +	case ALUA_ACCESS_STATE_OFFLINE:
> +		return "Offline";
> +	case ALUA_ACCESS_STATE_TRANSITION:
> +		return "Transitioning";
> +	default:
> +		return "Unknown";
> +	}
> +
> +	return NULL;
> +}
> +
>  /*
>   * Check implicit and explicit ALUA state change request.
>   */
>  static sense_reason_t
> -core_alua_check_transition(int state, int *primary)
> +core_alua_check_transition(int state, int valid, int *primary)
>  {
> +	/*
> +	 * OPTIMIZED, NON-OPTIMIZED, STANDBY and UNAVAILABLE are
> +	 * defined as primary target port asymmetric access states.
> +	 */
>  	switch (state) {
>  	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
> +		if (!(valid & ALUA_AO_SUP))
> +			goto not_supported;
> +		*primary = 1;
> +		break;
>  	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
> +		if (!(valid & ALUA_AN_SUP))
> +			goto not_supported;
> +		*primary = 1;
> +		break;
>  	case ALUA_ACCESS_STATE_STANDBY:
> +		if (!(valid & ALUA_S_SUP))
> +			goto not_supported;
> +		*primary = 1;
> +		break;
>  	case ALUA_ACCESS_STATE_UNAVAILABLE:
> -		/*
> -		 * OPTIMIZED, NON-OPTIMIZED, STANDBY and UNAVAILABLE are
> -		 * defined as primary target port asymmetric access states.
> -		 */
> +		if (!(valid & ALUA_U_SUP))
> +			goto not_supported;
>  		*primary = 1;
>  		break;
>  	case ALUA_ACCESS_STATE_OFFLINE:
> @@ -636,6 +675,8 @@ core_alua_check_transition(int state, int *primary)
>  		 * OFFLINE state is defined as a secondary target port
>  		 * asymmetric access state.
>  		 */
> +		if (!(valid & ALUA_O_SUP))
> +			goto not_supported;
>  		*primary = 0;
>  		break;
>  	default:
> @@ -644,26 +685,11 @@ core_alua_check_transition(int state, int *primary)
>  	}
>  
>  	return 0;
> -}
>  
> -static char *core_alua_dump_state(int state)
> -{
> -	switch (state) {
> -	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
> -		return "Active/Optimized";
> -	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
> -		return "Active/NonOptimized";
> -	case ALUA_ACCESS_STATE_STANDBY:
> -		return "Standby";
> -	case ALUA_ACCESS_STATE_UNAVAILABLE:
> -		return "Unavailable";
> -	case ALUA_ACCESS_STATE_OFFLINE:
> -		return "Offline";
> -	default:
> -		return "Unknown";
> -	}
> -
> -	return NULL;
> +not_supported:
> +	pr_err("ALUA access state %s not supported",
> +	       core_alua_dump_state(state));
> +	return TCM_INVALID_PARAMETER_LIST;
>  }
>  
>  char *core_alua_dump_status(int status)
> @@ -884,9 +910,10 @@ int core_alua_do_port_transition(
>  	struct t10_alua_lu_gp_member *lu_gp_mem, *local_lu_gp_mem;
>  	struct t10_alua_tg_pt_gp *tg_pt_gp;
>  	unsigned char *md_buf;
> -	int primary;
> +	int primary, valid_states;
>  
> -	if (core_alua_check_transition(new_state, &primary) != 0)
> +	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
> +	if (core_alua_check_transition(new_state, valid_states, &primary) != 0)
>  		return -EINVAL;
>  
>  	md_buf = kzalloc(l_tg_pt_gp->tg_pt_gp_md_buf_len, GFP_KERNEL);
