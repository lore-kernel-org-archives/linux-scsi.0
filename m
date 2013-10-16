From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/11] target_core_alua: Allocate ALUA metadata on demand
Date: Wed, 16 Oct 2013 14:42:26 -0700
Message-ID: <1381959746.19256.652.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1381908048-82014-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381908048-82014-8-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> We should only allocate ALUA metadata if we're actually going
> to write them.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c | 70 +++++++++++++++++----------------------
>  drivers/target/target_core_alua.h |  3 ++
>  include/target/target_core_base.h |  3 --
>  3 files changed, 34 insertions(+), 42 deletions(-)
> 

Looks reasonable to me..

--nab

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index a420778..b1d08bf 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -762,16 +762,22 @@ static int core_alua_write_tpg_metadata(
>   */
>  static int core_alua_update_tpg_primary_metadata(
>  	struct t10_alua_tg_pt_gp *tg_pt_gp,
> -	int primary_state,
> -	unsigned char *md_buf)
> +	int primary_state)
>  {
> +	unsigned char *md_buf;
>  	struct t10_wwn *wwn = &tg_pt_gp->tg_pt_gp_dev->t10_wwn;
>  	char path[ALUA_METADATA_PATH_LEN];
> -	int len;
> +	int len, rc;
> +
> +	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
> +	if (!md_buf) {
> +		pr_err("Unable to allocate buf for ALUA metadata\n");
> +		return -ENOMEM;
> +	}
>  
>  	memset(path, 0, ALUA_METADATA_PATH_LEN);
>  
> -	len = snprintf(md_buf, tg_pt_gp->tg_pt_gp_md_buf_len,
> +	len = snprintf(md_buf, ALUA_MD_BUF_LEN,
>  			"tg_pt_gp_id=%hu\n"
>  			"alua_access_state=0x%02x\n"
>  			"alua_access_status=0x%02x\n",
> @@ -782,14 +788,15 @@ static int core_alua_update_tpg_primary_metadata(
>  		"/var/target/alua/tpgs_%s/%s", &wwn->unit_serial[0],
>  		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
>  
> -	return core_alua_write_tpg_metadata(path, md_buf, len);
> +	rc = core_alua_write_tpg_metadata(path, md_buf, len);
> +	kfree(md_buf);
> +	return rc;
>  }
>  
>  static int core_alua_do_transition_tg_pt(
>  	struct t10_alua_tg_pt_gp *tg_pt_gp,
>  	struct se_port *l_port,
>  	struct se_node_acl *nacl,
> -	unsigned char *md_buf,
>  	int new_state,
>  	int explicit)
>  {
> @@ -877,8 +884,7 @@ static int core_alua_do_transition_tg_pt(
>  	 */
>  	if (tg_pt_gp->tg_pt_gp_write_metadata) {
>  		mutex_lock(&tg_pt_gp->tg_pt_gp_md_mutex);
> -		core_alua_update_tpg_primary_metadata(tg_pt_gp,
> -					new_state, md_buf);
> +		core_alua_update_tpg_primary_metadata(tg_pt_gp, new_state);
>  		mutex_unlock(&tg_pt_gp->tg_pt_gp_md_mutex);
>  	}
>  	/*
> @@ -909,19 +915,12 @@ int core_alua_do_port_transition(
>  	struct t10_alua_lu_gp *lu_gp;
>  	struct t10_alua_lu_gp_member *lu_gp_mem, *local_lu_gp_mem;
>  	struct t10_alua_tg_pt_gp *tg_pt_gp;
> -	unsigned char *md_buf;
>  	int primary, valid_states;
>  
>  	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
>  	if (core_alua_check_transition(new_state, valid_states, &primary) != 0)
>  		return -EINVAL;
>  
> -	md_buf = kzalloc(l_tg_pt_gp->tg_pt_gp_md_buf_len, GFP_KERNEL);
> -	if (!md_buf) {
> -		pr_err("Unable to allocate buf for ALUA metadata\n");
> -		return -ENOMEM;
> -	}
> -
>  	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
>  	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
>  	lu_gp = local_lu_gp_mem->lu_gp;
> @@ -939,10 +938,9 @@ int core_alua_do_port_transition(
>  		 * success.
>  		 */
>  		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
> -					md_buf, new_state, explicit);
> +					new_state, explicit);
>  		atomic_dec(&lu_gp->lu_gp_ref_cnt);
>  		smp_mb__after_atomic_dec();
> -		kfree(md_buf);
>  		return 0;
>  	}
>  	/*
> @@ -992,7 +990,7 @@ int core_alua_do_port_transition(
>  			 * success.
>  			 */
>  			core_alua_do_transition_tg_pt(tg_pt_gp, port,
> -					nacl, md_buf, new_state, explicit);
> +					nacl, new_state, explicit);
>  
>  			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
> @@ -1014,7 +1012,6 @@ int core_alua_do_port_transition(
>  
>  	atomic_dec(&lu_gp->lu_gp_ref_cnt);
>  	smp_mb__after_atomic_dec();
> -	kfree(md_buf);
>  	return 0;
>  }
>  
> @@ -1023,13 +1020,18 @@ int core_alua_do_port_transition(
>   */
>  static int core_alua_update_tpg_secondary_metadata(
>  	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
> -	struct se_port *port,
> -	unsigned char *md_buf,
> -	u32 md_buf_len)
> +	struct se_port *port)
>  {
> +	unsigned char *md_buf;
>  	struct se_portal_group *se_tpg = port->sep_tpg;
>  	char path[ALUA_METADATA_PATH_LEN], wwn[ALUA_SECONDARY_METADATA_WWN_LEN];
> -	int len;
> +	int len, rc;
> +
> +	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
> +	if (!md_buf) {
> +		pr_err("Unable to allocate buf for ALUA metadata\n");
> +		return -ENOMEM;
> +	}
>  
>  	memset(path, 0, ALUA_METADATA_PATH_LEN);
>  	memset(wwn, 0, ALUA_SECONDARY_METADATA_WWN_LEN);
> @@ -1041,7 +1043,7 @@ static int core_alua_update_tpg_secondary_metadata(
>  		snprintf(wwn+len, ALUA_SECONDARY_METADATA_WWN_LEN-len, "+%hu",
>  				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
>  
> -	len = snprintf(md_buf, md_buf_len, "alua_tg_pt_offline=%d\n"
> +	len = snprintf(md_buf, ALUA_MD_BUF_LEN, "alua_tg_pt_offline=%d\n"
>  			"alua_tg_pt_status=0x%02x\n",
>  			atomic_read(&port->sep_tg_pt_secondary_offline),
>  			port->sep_tg_pt_secondary_stat);
> @@ -1050,7 +1052,10 @@ static int core_alua_update_tpg_secondary_metadata(
>  			se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
>  			port->sep_lun->unpacked_lun);
>  
> -	return core_alua_write_tpg_metadata(path, md_buf, len);
> +	rc = core_alua_write_tpg_metadata(path, md_buf, len);
> +	kfree(md_buf);
> +
> +	return rc;
>  }
>  
>  static int core_alua_set_tg_pt_secondary_state(
> @@ -1060,8 +1065,6 @@ static int core_alua_set_tg_pt_secondary_state(
>  	int offline)
>  {
>  	struct t10_alua_tg_pt_gp *tg_pt_gp;
> -	unsigned char *md_buf;
> -	u32 md_buf_len;
>  	int trans_delay_msecs;
>  
>  	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
> @@ -1082,7 +1085,6 @@ static int core_alua_set_tg_pt_secondary_state(
>  	else
>  		atomic_set(&port->sep_tg_pt_secondary_offline, 0);
>  
> -	md_buf_len = tg_pt_gp->tg_pt_gp_md_buf_len;
>  	port->sep_tg_pt_secondary_stat = (explicit) ?
>  			ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
>  			ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
> @@ -1104,18 +1106,9 @@ static int core_alua_set_tg_pt_secondary_state(
>  	 * secondary state and status
>  	 */
>  	if (port->sep_tg_pt_secondary_write_md) {
> -		md_buf = kzalloc(md_buf_len, GFP_KERNEL);
> -		if (!md_buf) {
> -			pr_err("Unable to allocate md_buf for"
> -				" secondary ALUA access metadata\n");
> -			return -ENOMEM;
> -		}
>  		mutex_lock(&port->sep_tg_pt_md_mutex);
> -		core_alua_update_tpg_secondary_metadata(tg_pt_gp_mem, port,
> -				md_buf, md_buf_len);
> +		core_alua_update_tpg_secondary_metadata(tg_pt_gp_mem, port);
>  		mutex_unlock(&port->sep_tg_pt_md_mutex);
> -
> -		kfree(md_buf);
>  	}
>  
>  	return 0;
> @@ -1374,7 +1367,6 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
>  	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
>  	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
>  	tg_pt_gp->tg_pt_gp_dev = dev;
> -	tg_pt_gp->tg_pt_gp_md_buf_len = ALUA_MD_BUF_LEN;
>  	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
>  		ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED);
>  	/*
> diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
> index 88e2e83..1a152cd 100644
> --- a/drivers/target/target_core_alua.h
> +++ b/drivers/target/target_core_alua.h
> @@ -78,6 +78,9 @@
>   */
>  #define ALUA_SECONDARY_METADATA_WWN_LEN			256
>  
> +/* Used by core_alua_update_tpg_(primary,secondary)_metadata */
> +#define ALUA_MD_BUF_LEN					1024
> +
>  extern struct kmem_cache *t10_alua_lu_gp_cache;
>  extern struct kmem_cache *t10_alua_lu_gp_mem_cache;
>  extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 21f4bd5..933c59d 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -290,9 +290,6 @@ struct t10_alua_tg_pt_gp {
>  	int	tg_pt_gp_implicit_trans_secs;
>  	int	tg_pt_gp_pref;
>  	int	tg_pt_gp_write_metadata;
> -	/* Used by struct t10_alua_tg_pt_gp->tg_pt_gp_md_buf_len */
> -#define ALUA_MD_BUF_LEN				1024
> -	u32	tg_pt_gp_md_buf_len;
>  	u32	tg_pt_gp_members;
>  	atomic_t tg_pt_gp_alua_access_state;
>  	atomic_t tg_pt_gp_ref_cnt;
