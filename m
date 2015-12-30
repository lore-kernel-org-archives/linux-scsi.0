From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/20] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 30 Dec 2015 14:19:24 +0100
Message-ID: <20151230131923.GA15270@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49461 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbbL3NT1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 08:19:27 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

This looks good in general, but a couple nitpicks below:

> +static uint optimize_stpg;
> +module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than sending a STPG, when implicit TPGS is supported (0=No,1=Yes). Default is 0.");

why is this moved around in this patch?  It doesn't seem related to the
rest of it, and isn't documented in the changelog either.

>  {
> -	struct alua_port_group *pg = NULL;
> +	struct alua_port_group *pg;

looks like this should be folded into the patch that introduces the
unessecary NULL assignment.

>  	list_for_each_entry(pg, &port_group_list, node) {
>  		if (pg->group_id != group_id)
> @@ -214,18 +240,26 @@ struct alua_port_group *alua_get_pg(struct scsi_device *sdev,
>  	pg->group_id = group_id;
>  	pg->tpgs = tpgs;
>  	pg->state = TPGS_STATE_OPTIMIZED;
> +	if (optimize_stpg)
> +		pg->flags |= ALUA_OPTIMIZE_STPG;


why is this moved earlier here?  Doing it from the beginning seems
useful to me, but I'd expect it in a separate patch with a proper
description.

>  	kref_init(&pg->kref);
> +	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
> +	INIT_LIST_HEAD(&pg->rtpg_list);
> +	INIT_LIST_HEAD(&pg->node);
> +	spin_lock_init(&pg->lock);
>  
>  	/* Re-check list again to catch concurrent updates */
>  	spin_lock(&port_group_lock);
>  	tmp_pg = alua_lookup_pg(id_str, id_size, group_id);
>  	if (tmp_pg) {
>  		spin_unlock(&port_group_lock);
> -		kfree(pg);
> -		return tmp_pg;
> +		kref_put(&pg->kref, release_port_group);
> +		pg = tmp_pg;
> +		tmp_pg = NULL;

The only thing release_port_group does in addition to the kfree
is a list_del on pg->entry.  But given that we never added
the pg to a list it doesn't need to be deleted, and it can't
have another reference.  Why this change?

While we're at it, there are 6 calls to
'kref_put(&pg->kref, release_port_group)' in addition to this one,
so it might make sense to add a helper for it to the patch introducing
struct alua_port_group.

>   * Extract the relative target port and the target port group
>   * descriptor from the list of identificators.
>   *
> - * Returns 0 or SCSI_DH_ error code on failure.
> + * Returns the target port group id or -1 on failure

That's not how I interpret the code below, it seems to always return
SCSI_DH_* values.

> +	struct alua_port_group *pg = NULL, *old_pg = NULL;
> +	bool pg_found = false;

> +	pg = alua_get_pg(sdev, group_id, tpgs, id_str, id_size);
> +	if (!pg)
>  		return SCSI_DH_NOMEM;
> +	/* Check for existing port_group references */
> +	spin_lock(&h->pg_lock);
> +	if (h->pg) {
> +		old_pg = pg;
> +		/* port_group has changed. Update to new port group */
> +		if (h->pg != pg) {
> +			old_pg = h->pg;
> +			rcu_assign_pointer(h->pg, pg);
> +			h->pg->expiry = 0;

why do we set expiry to 0 here, but not if we didn't have a pg
yet?  This could use a comment not just here but in all the places
that set it to zero.

> +			pg_found = true;

pg_found should be pg_updated, right?

> +	if (pg_found)
> +		synchronize_rcu();
> +	if (old_pg) {
> +		if (old_pg->rtpg_sdev)
> +			flush_delayed_work(&old_pg->rtpg_work);
> +		kref_put(&old_pg->kref, release_port_group);
> +	}

This code looks odd.  I can't see why we need a synchronize_rcu here.
The only thing we should need is a kfree_rcu for the final free in
release_port_group.  I also don't quite understand the flush_delayed_work.
As far as I can tell we only need it if rtpg_sdev is the sdev passed
in, so it we probably should check for that.
