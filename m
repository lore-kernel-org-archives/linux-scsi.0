From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/20] scsi_dh_alua: Use workqueue for RTPG
Date: Thu, 31 Dec 2015 14:01:43 +0100
Message-ID: <56852737.4000803@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
 <1449560260-53407-12-git-send-email-hare@suse.de>
 <20151230131923.GA15270@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbbLaNBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Dec 2015 08:01:46 -0500
In-Reply-To: <20151230131923.GA15270@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 12/30/2015 02:19 PM, Christoph Hellwig wrote:
> This looks good in general, but a couple nitpicks below:
>
>> +static uint optimize_stpg;
>> +module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
>> +MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path,=
 rather than sending a STPG, when implicit TPGS is supported (0=3DNo,1=3D=
Yes). Default is 0.");
>
> why is this moved around in this patch?  It doesn't seem related to t=
he
> rest of it, and isn't documented in the changelog either.
>
Yeah, can move it to a separate patch.

>>   {
>> -	struct alua_port_group *pg =3D NULL;
>> +	struct alua_port_group *pg;
>
> looks like this should be folded into the patch that introduces the
> unessecary NULL assignment.
>
Ok.

>>   	list_for_each_entry(pg, &port_group_list, node) {
>>   		if (pg->group_id !=3D group_id)
>> @@ -214,18 +240,26 @@ struct alua_port_group *alua_get_pg(struct scs=
i_device *sdev,
>>   	pg->group_id =3D group_id;
>>   	pg->tpgs =3D tpgs;
>>   	pg->state =3D TPGS_STATE_OPTIMIZED;
>> +	if (optimize_stpg)
>> +		pg->flags |=3D ALUA_OPTIMIZE_STPG;
>
>
> why is this moved earlier here?  Doing it from the beginning seems
> useful to me, but I'd expect it in a separate patch with a proper
> description.
>
Ok.

>>   	kref_init(&pg->kref);
>> +	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
>> +	INIT_LIST_HEAD(&pg->rtpg_list);
>> +	INIT_LIST_HEAD(&pg->node);
>> +	spin_lock_init(&pg->lock);
>>
>>   	/* Re-check list again to catch concurrent updates */
>>   	spin_lock(&port_group_lock);
>>   	tmp_pg =3D alua_lookup_pg(id_str, id_size, group_id);
>>   	if (tmp_pg) {
>>   		spin_unlock(&port_group_lock);
>> -		kfree(pg);
>> -		return tmp_pg;
>> +		kref_put(&pg->kref, release_port_group);
>> +		pg =3D tmp_pg;
>> +		tmp_pg =3D NULL;
>
> The only thing release_port_group does in addition to the kfree
> is a list_del on pg->entry.  But given that we never added
> the pg to a list it doesn't need to be deleted, and it can't
> have another reference.  Why this change?
>
Mainly for symmetry; with this patch we're always calling kref_put() to=
=20
delete the port_group structure.

> While we're at it, there are 6 calls to
> 'kref_put(&pg->kref, release_port_group)' in addition to this one,
> so it might make sense to add a helper for it to the patch introducin=
g
> struct alua_port_group.
>
Ok.

>>    * Extract the relative target port and the target port group
>>    * descriptor from the list of identificators.
>>    *
>> - * Returns 0 or SCSI_DH_ error code on failure.
>> + * Returns the target port group id or -1 on failure
>
> That's not how I interpret the code below, it seems to always return
> SCSI_DH_* values.
>
>> +	struct alua_port_group *pg =3D NULL, *old_pg =3D NULL;
>> +	bool pg_found =3D false;
>
>> +	pg =3D alua_get_pg(sdev, group_id, tpgs, id_str, id_size);
>> +	if (!pg)
>>   		return SCSI_DH_NOMEM;
>> +	/* Check for existing port_group references */
>> +	spin_lock(&h->pg_lock);
>> +	if (h->pg) {
>> +		old_pg =3D pg;
>> +		/* port_group has changed. Update to new port group */
>> +		if (h->pg !=3D pg) {
>> +			old_pg =3D h->pg;
>> +			rcu_assign_pointer(h->pg, pg);
>> +			h->pg->expiry =3D 0;
>
> why do we set expiry to 0 here, but not if we didn't have a pg
> yet?  This could use a comment not just here but in all the places
> that set it to zero.
>
>> +			pg_found =3D true;
>
> pg_found should be pg_updated, right?
>
>> +	if (pg_found)
>> +		synchronize_rcu();
>> +	if (old_pg) {
>> +		if (old_pg->rtpg_sdev)
>> +			flush_delayed_work(&old_pg->rtpg_work);
>> +		kref_put(&old_pg->kref, release_port_group);
>> +	}
>
> This code looks odd.  I can't see why we need a synchronize_rcu here.
> The only thing we should need is a kfree_rcu for the final free in
> release_port_group.  I also don't quite understand the flush_delayed_=
work.
> As far as I can tell we only need it if rtpg_sdev is the sdev passed
> in, so it we probably should check for that.
>
rtpg_sdev is set whenever the port_group structure needs or is schedule=
d=20
for alua_rtpg_work(), ie whenever some action needs to be taken.
As the sdev might be a different sdev than that one we've been called=20
from (a port_group might have several sdevs pointing to it), the=20
existence of an sdev signals that we need to flush the workqueue item.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
