From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 2/2] target: Avoid dropping AllRegistrants reservation
 during unregister
Date: Wed, 17 Dec 2014 23:02:04 -0800
Message-ID: <54927BEC.4080301@suse.com>
References: <1418688544-18825-1-git-send-email-nab@daterainc.com> <1418688544-18825-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1418688544-18825-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 12/15/2014 04:09 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes an issue with AllRegistrants reservations where
> an unregister operation by the I_T nexus reservation holder would
> incorrectly drop the reservation, instead of waiting until the
> last active I_T nexus is unregistered as per SPC-4.
> 
> This includes updating __core_scsi3_complete_pro_release() to reset
> dev->dev_pr_res_holder with another pr_reg for this special case,
> as well as a new 'unreg' parameter to determine when the release
> is occuring from an implicit unregister, vs. explicit RELEASE.
> 
> It also adds special handling in core_scsi3_free_pr_reg_from_nacl()
> to release the left-over pr_res_holder, now that pr_reg is deleted
> from pr_reg_list within __core_scsi3_complete_pro_release().
> 
> Reported-by: Ilias Tsitsimpis <i.tsitsimpis@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_pr.c | 87 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 65 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index c4a8da5..703890c 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -76,7 +76,7 @@ enum preempt_type {
>  };
>  
>  static void __core_scsi3_complete_pro_release(struct se_device *, struct se_node_acl *,
> -			struct t10_pr_registration *, int);
> +					      struct t10_pr_registration *, int, int);
>  
>  static sense_reason_t
>  target_scsi2_reservation_check(struct se_cmd *cmd)
> @@ -1177,7 +1177,7 @@ static int core_scsi3_check_implicit_release(
>  		 *    service action with the SERVICE ACTION RESERVATION KEY
>  		 *    field set to zero (see 5.7.11.3).
>  		 */
> -		__core_scsi3_complete_pro_release(dev, nacl, pr_reg, 0);
> +		__core_scsi3_complete_pro_release(dev, nacl, pr_reg, 0, 1);
>  		ret = 1;
>  		/*
>  		 * For 'All Registrants' reservation types, all existing
> @@ -1219,7 +1219,8 @@ static void __core_scsi3_free_registration(
>  
>  	pr_reg->pr_reg_deve->def_pr_registered = 0;
>  	pr_reg->pr_reg_deve->pr_res_key = 0;
> -	list_del(&pr_reg->pr_reg_list);
> +	if (!list_empty(&pr_reg->pr_reg_list))
> +		list_del(&pr_reg->pr_reg_list);
>  	/*
>  	 * Caller accessing *pr_reg using core_scsi3_locate_pr_reg(),
>  	 * so call core_scsi3_put_pr_reg() to decrement our reference.
> @@ -1271,6 +1272,7 @@ void core_scsi3_free_pr_reg_from_nacl(
>  {
>  	struct t10_reservation *pr_tmpl = &dev->t10_pr;
>  	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_res_holder;
> +	bool free_reg = false;
>  	/*
>  	 * If the passed se_node_acl matches the reservation holder,
>  	 * release the reservation.
> @@ -1278,13 +1280,18 @@ void core_scsi3_free_pr_reg_from_nacl(
>  	spin_lock(&dev->dev_reservation_lock);
>  	pr_res_holder = dev->dev_pr_res_holder;
>  	if ((pr_res_holder != NULL) &&
> -	    (pr_res_holder->pr_reg_nacl == nacl))
> -		__core_scsi3_complete_pro_release(dev, nacl, pr_res_holder, 0);
> +	    (pr_res_holder->pr_reg_nacl == nacl)) {
> +		__core_scsi3_complete_pro_release(dev, nacl, pr_res_holder, 0, 1);
> +		free_reg = true;
> +	}
>  	spin_unlock(&dev->dev_reservation_lock);
>  	/*
>  	 * Release any registration associated with the struct se_node_acl.
>  	 */
>  	spin_lock(&pr_tmpl->registration_lock);
> +	if (pr_res_holder && free_reg)
> +		__core_scsi3_free_registration(dev, pr_res_holder, NULL, 0);
> +
>  	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
>  			&pr_tmpl->registration_list, pr_reg_list) {
>  
> @@ -1307,7 +1314,7 @@ void core_scsi3_free_all_registrations(
>  	if (pr_res_holder != NULL) {
>  		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
>  		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
> -				pr_res_holder, 0);
> +						  pr_res_holder, 0, 0);
>  	}
>  	spin_unlock(&dev->dev_reservation_lock);
>  
> @@ -2103,13 +2110,13 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
>  		/*
>  		 * sa_res_key=0 Unregister Reservation Key for registered I_T Nexus.
>  		 */
> -		pr_holder = core_scsi3_check_implicit_release(
> -				cmd->se_dev, pr_reg);
> +		type = pr_reg->pr_res_type;
> +		pr_holder = core_scsi3_check_implicit_release(cmd->se_dev,
> +							      pr_reg);
>  		if (pr_holder < 0) {
>  			ret = TCM_RESERVATION_CONFLICT;
>  			goto out;
>  		}
> -		type = pr_reg->pr_res_type;
>  
>  		spin_lock(&pr_tmpl->registration_lock);
>  		/*
> @@ -2383,23 +2390,59 @@ static void __core_scsi3_complete_pro_release(
>  	struct se_device *dev,
>  	struct se_node_acl *se_nacl,
>  	struct t10_pr_registration *pr_reg,
> -	int explicit)
> +	int explicit,
> +	int unreg)
>  {
>  	struct target_core_fabric_ops *tfo = se_nacl->se_tpg->se_tpg_tfo;
>  	char i_buf[PR_REG_ISID_ID_LEN];
> +	int pr_res_type = 0, pr_res_scope = 0;
>  
>  	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
>  	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
>  	/*
>  	 * Go ahead and release the current PR reservation holder.
> +	 * If an All Registrants reservation is currently active and
> +	 * a unregister operation is requested, replace the current
> +	 * dev_pr_res_holder with another active registration.
>  	 */
> -	dev->dev_pr_res_holder = NULL;
> +	if (dev->dev_pr_res_holder) {
> +		pr_res_type = dev->dev_pr_res_holder->pr_res_type;
> +		pr_res_scope = dev->dev_pr_res_holder->pr_res_scope;
> +		dev->dev_pr_res_holder->pr_res_type = 0;
> +		dev->dev_pr_res_holder->pr_res_scope = 0;
> +		dev->dev_pr_res_holder->pr_res_holder = 0;
> +		dev->dev_pr_res_holder = NULL;
> +	}
> +	if (!unreg)
> +		goto out;
>  
> -	pr_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
> -		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
> -		tfo->get_fabric_name(), (explicit) ? "explicit" : "implicit",
> -		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
> -		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
> +	spin_lock(&dev->t10_pr.registration_lock);
> +	list_del_init(&pr_reg->pr_reg_list);
> +	/*
> +	 * If the I_T nexus is a reservation holder, the persistent reservation
> +	 * is of an all registrants type, and the I_T nexus is the last remaining
> +	 * registered I_T nexus, then the device server shall also release the
> +	 * persistent reservation.
> +	 */
> +	if (!list_empty(&dev->t10_pr.registration_list) &&
> +	    ((pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
> +	     (pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG))) {
> +		dev->dev_pr_res_holder =
> +			list_entry(dev->t10_pr.registration_list.next,
> +				   struct t10_pr_registration, pr_reg_list);
> +		dev->dev_pr_res_holder->pr_res_type = pr_res_type;
> +		dev->dev_pr_res_holder->pr_res_scope = pr_res_scope;
> +		dev->dev_pr_res_holder->pr_res_holder = 1;
> +	}
> +	spin_unlock(&dev->t10_pr.registration_lock);
> +out:
> +	if (!dev->dev_pr_res_holder) {
> +		pr_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
> +			" reservation holder TYPE: %s ALL_TG_PT: %d\n",
> +			tfo->get_fabric_name(), (explicit) ? "explicit" :
> +			"implicit", core_scsi3_pr_dump_type(pr_res_type),
> +			(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
> +	}
>  	pr_debug("SPC-3 PR [%s] RELEASE Node: %s%s\n",
>  		tfo->get_fabric_name(), se_nacl->initiatorname,
>  		i_buf);
> @@ -2530,7 +2573,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
>  	 *    server shall not establish a unit attention condition.
>  	 */
>  	__core_scsi3_complete_pro_release(dev, se_sess->se_node_acl,
> -			pr_reg, 1);
> +					  pr_reg, 1, 0);
>  
>  	spin_unlock(&dev->dev_reservation_lock);
>  
> @@ -2618,7 +2661,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
>  	if (pr_res_holder) {
>  		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
>  		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
> -			pr_res_holder, 0);
> +						  pr_res_holder, 0, 0);
>  	}
>  	spin_unlock(&dev->dev_reservation_lock);
>  	/*
> @@ -2677,7 +2720,7 @@ static void __core_scsi3_complete_pro_preempt(
>  	 */
>  	if (dev->dev_pr_res_holder)
>  		__core_scsi3_complete_pro_release(dev, nacl,
> -				dev->dev_pr_res_holder, 0);
> +						  dev->dev_pr_res_holder, 0, 0);
>  
>  	dev->dev_pr_res_holder = pr_reg;
>  	pr_reg->pr_res_holder = 1;
> @@ -2922,8 +2965,8 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
>  	 */
>  	if (pr_reg_n != pr_res_holder)
>  		__core_scsi3_complete_pro_release(dev,
> -				pr_res_holder->pr_reg_nacl,
> -				dev->dev_pr_res_holder, 0);
> +						  pr_res_holder->pr_reg_nacl,
> +						  dev->dev_pr_res_holder, 0, 0);
>  	/*
>  	 * b) Remove the registrations for all I_T nexuses identified
>  	 *    by the SERVICE ACTION RESERVATION KEY field, except the
> @@ -3386,7 +3429,7 @@ after_iport_check:
>  	 *    holder (i.e., the I_T nexus on which the
>  	 */
>  	__core_scsi3_complete_pro_release(dev, pr_res_nacl,
> -			dev->dev_pr_res_holder, 0);
> +					  dev->dev_pr_res_holder, 0, 0);
>  	/*
>  	 * g) Move the persistent reservation to the specified I_T nexus using
>  	 *    the same scope and type as the persistent reservation released in
> 


Tested-by: Lee Duncan <lduncan@suse.com>
