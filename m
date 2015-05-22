From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 2/9] target/pr: Use atomic bitop for
	se_dev_entry->pr_reg reservation check
Date: Fri, 22 May 2015 13:52:03 +0200
Message-ID: <20150522115203.GA29155@lst.de>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com> <1432275071-28882-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432275071-28882-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>  
> -/*
> - * this function can be called with struct se_device->dev_reservation_lock
> - * when register_move = 1
> - */
>  static void __core_scsi3_add_registration(
>  	struct se_device *dev,
>  	struct se_node_acl *nacl,
> @@ -1023,6 +1021,7 @@ static void __core_scsi3_add_registration(
>  	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
>  	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
>  	struct t10_reservation *pr_tmpl = &dev->t10_pr;
> +	struct se_dev_entry *deve;
>  
>  	/*
>  	 * Increment PRgeneration counter for struct se_device upon a successful
> @@ -1039,10 +1038,16 @@ static void __core_scsi3_add_registration(
>  
>  	spin_lock(&pr_tmpl->registration_lock);
>  	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
> -	pr_reg->pr_reg_deve->def_pr_registered = 1;
>  
>  	__core_scsi3_dump_registration(tfo, dev, nacl, pr_reg, register_type);
>  	spin_unlock(&pr_tmpl->registration_lock);
> +
> +	mutex_lock(&nacl->lun_entry_mutex);
> +	deve = target_nacl_find_deve(nacl, pr_reg->pr_res_mapped_lun);
> +	if (deve)
> +		set_bit(1, &deve->pr_reg);
> +	mutex_unlock(&nacl->lun_entry_mutex);

Why can't we rely on pr_reg->pr_reg_deve here?  The way the it's
set up is a bit convoluted, but unless I miss something it needs to
have a reference if it's set (and it it doesn't that needs to be fixed
ASAP).

Also even if we would need a target_nacl_find_deve call here it could
be done under rcu_read_lock as lun_entry_hlist isn't modified.

> +		mutex_lock(&nacl->lun_entry_mutex);
> +		deve = target_nacl_find_deve(nacl_tmp, pr_reg_tmp->pr_res_mapped_lun);
> +		if (deve)
> +			set_bit(1, &deve->pr_reg);
> +		mutex_unlock(&nacl->lun_entry_mutex);
> +

Same here.

> @@ -1258,6 +1269,8 @@ static void __core_scsi3_free_registration(
>  	 */
>  	if (dec_holders)
>  		core_scsi3_put_pr_reg(pr_reg);
> +
> +	spin_unlock(&pr_tmpl->registration_lock);
>  	/*
>  	 * Wait until all reference from any other I_T nexuses for this
>  	 * *pr_reg have been released.  Because list_del() is called above,
> @@ -1265,13 +1278,18 @@ static void __core_scsi3_free_registration(
>  	 * count back to zero, and we release *pr_reg.
>  	 */
>  	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
> -		spin_unlock(&pr_tmpl->registration_lock);
>  		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
>  				tfo->get_fabric_name());
>  		cpu_relax();
> -		spin_lock(&pr_tmpl->registration_lock);
>  	}
>  
> +	mutex_lock(&nacl->lun_entry_mutex);
> +	deve = target_nacl_find_deve(nacl, pr_reg->pr_res_mapped_lun);
> +	if (deve)
> +		clear_bit(1, &deve->pr_reg);
> +	mutex_unlock(&nacl->lun_entry_mutex);

And here.
