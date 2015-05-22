From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v2 1/9] target: Convert se_node_acl->device_list[] to RCU
 hlist
Date: Fri, 22 May 2015 01:24:11 -0700
Message-ID: <20150522082411.GB5384@infradead.org>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
 <1432275071-28882-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432275071-28882-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> -	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
> -	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
> -	if (se_cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> -		struct se_dev_entry *deve = se_cmd->se_deve;
> -
> +	rcu_read_lock();
> +	deve = target_nacl_find_deve(nacl, unpacked_lun);
> +	if (deve) {
>  		deve->total_cmds++;

This update will now be racy, ditto for the read/write_bytes update
later.

> +bool target_lun_is_rdonly(struct se_cmd *cmd)
> +{
> +	struct se_session *se_sess = cmd->se_sess;
> +	struct se_dev_entry *deve;
> +	bool ret;
> +
> +	if (cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY)
> +		return true;
> +
> +	rcu_read_lock();
> +	deve = target_nacl_find_deve(se_sess->se_node_acl, cmd->orig_fe_lun);
> +	ret = (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(target_lun_is_rdonly);

This should be a separate prep patch like, like it was in my original
version.  I also still think you want this whole patch:

http://git.infradead.org/users/hch/scsi.git/commitdiff/e9a71bda1a120e0488c5c4e4b2f17f14333e2dc6

as storing a pointer to the dev entry without a refcount is bound to
cause trouble.  I don't have a tree with all the patches applied
available, but I doubt it fully gets that right.

> +void target_pr_kref_release(struct kref *kref)
> +{
> +	struct se_dev_entry *deve = container_of(kref, struct se_dev_entry,
> +						 pr_kref);
> +	complete(&deve->pr_comp);
>  }
>  
>  /*      core_enable_device_list_for_node():

> +		kref_put(&orig->pr_kref, target_pr_kref_release);
> +		wait_for_completion(&orig->pr_comp);
>  

> +	kref_put(&orig->pr_kref, target_pr_kref_release);
>  	/*
> -	 * Disable struct se_dev_entry LUN ACL mapping
> +	 * Before fireing off RCU callback, wait for any in process SPEC_I_PT=1
> +	 * or REGISTER_AND_MOVE PR operation to complete.
>  	 */
> +	wait_for_completion(&orig->pr_comp);
> +	kfree_rcu(orig, rcu_head);

The release callback should just call kfree_rcu, no need to wait for the
release in the caller.

Also can you drop the _pr from the name?  It's a generic refcount now
even if the PR code is the only consumer so far.

> +void	target_pr_kref_release(struct kref *);

Instead of exporting the release function it would be much more obvious
to have a 

void target_deve_put(struct se_dev_entry *deve)
{
	kref_put(&deve->pr_kref, target_deve_release);
}

helper.  Probably paired with one for the get side.

>  static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
>  {
> -	struct se_lun_acl *lun_acl = se_deve->se_lun_acl;
> +	struct se_lun_acl *lun_acl;
>  	struct se_node_acl *nacl;
>  	struct se_portal_group *tpg;
> +
> +	if (!se_deve) {
> +		pr_err("core_scsi3_lunacl_undepend_item passed NULL se_deve\n");
> +		dump_stack();
> +		return;
> +	}

How could this happen and how is it related to this patch?

> -	if (!deve->se_lun || !deve->se_lun_acl) {
> -		spin_unlock_irq(&nacl->device_list_lock);
> +	rcu_read_lock();
> +	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
> +	if (!deve) {
> +		rcu_read_unlock();
>  		return -ENODEV;

So previously a lot of these files returned -ENODEV when not having
an explicit node ACL, and now they don't.  If that was intentional
it should be documented in the changelog, or preferably moved into
a preparation patch of its own.

> +	struct se_node_acl	*se_node_acl;

Where is this field coming from?  It's not documented in the changelog
and doesn't seem to be actually used either.
