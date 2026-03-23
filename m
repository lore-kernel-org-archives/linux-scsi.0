Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE373BB9F6
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 16:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282522; cv=none; b=GCMjiA1fh0H8XyXzT0kuSxyk2fwzsZ3agTGTwTPFntSvKb0xL074EQL+whUoDLYeKzWA2T8yqg59gLitNUvnkeNtmtNpM8sAIK5/24iej+vL5zWaBBIbV3zrqyl3xOIUuRMLd4vEMGHEpQauplmIinsbcH/DEerFoG9GFgIxEa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282522; c=relaxed/simple;
	bh=DFmxd8hbyc/vuoVJkNWh1WOouE4sQePh6EJjH2B4/5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZfWQndotSn0rx58Ir0mbsQ5Uwft4M2QuB7gNgJRHmDB8UQ8qC6gGNpHbKjI54Pv8o66SP0l9GOGplxVrgaZo/RgQTLpw1I05PovjbpVi8p8k6taBR2GrePaxx5Ca2HhRfQa2AfdXgOKiVJ90ThYbcG56w5umQZPjOsUMK/KX/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZPmSPK0j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPmSPK0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774282520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NYZ/E4Fge0/3/UpAgI4LqmFmyC6lJLMbnjcheApcim4=;
	b=ZPmSPK0j9grLGjuMisNPF59WQP7RsMXLq+lBZnrKdjoJcSLzIcyRe5uJqTLW4ijF/QhdXy
	kbG4m40HIR1nttZjuw1HWhfxhATkUr5cfnNwGk71/rQ/EsqzVXSrL2HoPTh64T6bSZTr4m
	tok3en7vSDCPmRZ83STNF9uUEupAfiE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-1E1OCjhuMgKTEe7uhnblag-1; Mon,
 23 Mar 2026 12:15:14 -0400
X-MC-Unique: 1E1OCjhuMgKTEe7uhnblag-1
X-Mimecast-MFC-AGG-ID: 1E1OCjhuMgKTEe7uhnblag_1774282512
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D68C1955BCE;
	Mon, 23 Mar 2026 16:15:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB8ED30002EE;
	Mon, 23 Mar 2026 16:15:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62NGFAYx1025027
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 12:15:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62NGFAbM1025026;
	Mon, 23 Mar 2026 12:15:10 -0400
Date: Mon, 23 Mar 2026 12:15:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] scsi: scsi_dh_alua: Delete alua_port_group
Message-ID: <acFnDlO6b4SzFq90@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-2-john.g.garry@oracle.com>
 <acCEmFgVgxr8qx39@redhat.com>
 <470edb84-1621-41e4-b172-91f9388a813b@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470edb84-1621-41e4-b172-91f9388a813b@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Mar 23, 2026 at 10:33:12AM +0000, John Garry wrote:
> On 23/03/2026 00:08, Benjamin Marzinski wrote:
> > >       k += off, desc += off) {
> > > -		u16 group_id = get_unaligned_be16(&desc[2]);
> > > -
> > > -		spin_lock_irqsave(&port_group_lock, flags);
> > > -		tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
> > > -					  group_id);
> > > -		spin_unlock_irqrestore(&port_group_lock, flags);
> > > -		if (tmp_pg) {
> > > -			if (spin_trylock_irqsave(&tmp_pg->lock, flags)) {
> > > -				if ((tmp_pg == pg) ||
> > > -				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
> > > -					struct alua_dh_data *h;
> > > -
> > > -					tmp_pg->state = desc[0] & 0x0f;
> > > -					tmp_pg->pref = desc[0] >> 7;
> > > -					rcu_read_lock();
> > > -					list_for_each_entry_rcu(h,
> > > -						&tmp_pg->dh_list, node) {
> > > -						if (!h->sdev)
> > > -							continue;
> > > -						h->sdev->access_state = desc[0];
> > > -					}
> > > -					rcu_read_unlock();
> > > -				}
> > > -				if (tmp_pg == pg)
> > > -					tmp_pg->valid_states = desc[1];
> > > -				spin_unlock_irqrestore(&tmp_pg->lock, flags);
> > > -			}
> > > -			kref_put(&tmp_pg->kref, release_port_group);
> > > +		u16 group_id_desc = get_unaligned_be16(&desc[2]);
> > > +
> > > +		spin_lock_irqsave(&h->lock, flags);
> > > +		if (group_id_desc == group_id) {
> > > +			h->group_id = group_id;
> > > +			WRITE_ONCE(h->state, desc[0] & 0x0f);
> > > +			h->pref = desc[0] >> 7;
> > > +			WRITE_ONCE(sdev->access_state, desc[0]);
> > > +			h->valid_states = desc[1];
> > instead of alua_rtpg() updating the access_state all of the devices in
> > all the port groups, and the state and pref of all the port groups. It
> > now just sets these for one device. It seems like it's wasting a lot of
> > information that it used to use. For instance, now when a scsi command
> > returns a unit attention that the ALUA state has changed, it won't get
> > updated on all the devices, just the one that got the unit attention.
> 
> The fabric should then trigger this PG info update be re-scanned
> per-path/sdev (and not just a single sdev in the PG). From testing with a
> linux target, this is what happens - a UA is triggered per path when I
> changed the PG access state.
> 
> > 
> > >   		}
> > > +		spin_unlock_irqrestore(&h->lock, flags);
> > >   		off = 8 + (desc[7] * 4);
> > >   	}
> > >    skip_rtpg:
> > > -	spin_lock_irqsave(&pg->lock, flags);
> > > +	spin_lock_irqsave(&h->lock, flags);
> > >   	if (transitioning_sense)
> > > -		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> > > +		h->state = SCSI_ACCESS_STATE_TRANSITIONING;
> 
> ...
> 
> > > -
> > >   static void alua_rtpg_work(struct work_struct *work)
> > >   {
> > > -	struct alua_port_group *pg =
> > > -		container_of(work, struct alua_port_group, rtpg_work.work);
> > > -	struct scsi_device *sdev, *prev_sdev = NULL;
> > > +	struct alua_dh_data *h =
> > > +		container_of(work, struct alua_dh_data, rtpg_work.work);
> > > +	struct scsi_device *sdev = h->sdev;
> > >   	LIST_HEAD(qdata_list);
> > >   	int err = SCSI_DH_OK;
> > >   	struct alua_queue_data *qdata, *tmp;
> > > -	struct alua_dh_data *h;
> > >   	unsigned long flags;
> > > -	spin_lock_irqsave(&pg->lock, flags);
> > > -	sdev = pg->rtpg_sdev;
> > > -	if (!sdev) {
> > > -		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG);
> > > -		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
> > > -		spin_unlock_irqrestore(&pg->lock, flags);
> > > -		kref_put(&pg->kref, release_port_group);
> > > -		return;
> > > -	}
> > > -	pg->flags |= ALUA_PG_RUNNING;
> > > -	if (pg->flags & ALUA_PG_RUN_RTPG) {
> > > -		int state = pg->state;
> > > +	spin_lock_irqsave(&h->lock, flags);
> > > +	h->flags |= ALUA_PG_RUNNING;
> > > +	if (h->flags & ALUA_PG_RUN_RTPG) {
> > > +		int state = h->state;
> > > -		pg->flags &= ~ALUA_PG_RUN_RTPG;
> > > -		spin_unlock_irqrestore(&pg->lock, flags);
> > > +		h->flags &= ~ALUA_PG_RUN_RTPG;
> > > +		spin_unlock_irqrestore(&h->lock, flags);
> > >   		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
> > >   			if (alua_tur(sdev) == SCSI_DH_RETRY) {
> > > -				spin_lock_irqsave(&pg->lock, flags);
> > > -				pg->flags &= ~ALUA_PG_RUNNING;
> > > -				pg->flags |= ALUA_PG_RUN_RTPG;
> > > -				if (!pg->interval)
> > > -					pg->interval = ALUA_RTPG_RETRY_DELAY;
> > > -				spin_unlock_irqrestore(&pg->lock, flags);
> > > -				queue_delayed_work(kaluad_wq, &pg->rtpg_work,
> > > -						   pg->interval * HZ);
> > > +				spin_lock_irqsave(&h->lock, flags);
> > > +				h->flags &= ~ALUA_PG_RUNNING;
> > > +				h->flags |= ALUA_PG_RUN_RTPG;
> > > +				if (!h->interval)
> > > +					h->interval = ALUA_RTPG_RETRY_DELAY;
> > > +				spin_unlock_irqrestore(&h->lock, flags);
> > > +				queue_delayed_work(kaluad_wq, &h->rtpg_work,
> > > +						   h->interval * HZ);
> > >   				return;
> > >   			}
> > >   			/* Send RTPG on failure or if TUR indicates SUCCESS */
> > >   		}
> > > -		err = alua_rtpg(sdev, pg);
> > > -		spin_lock_irqsave(&pg->lock, flags);
> > > +		err = alua_rtpg(sdev);
> > > +		spin_lock_irqsave(&h->lock, flags);
> > > -		/* If RTPG failed on the current device, try using another */
> > > -		if (err == SCSI_DH_RES_TEMP_UNAVAIL &&
> > > -		    (prev_sdev = alua_rtpg_select_sdev(pg)))
> > > -			err = SCSI_DH_IMM_RETRY;
> > Previously, if the rtpg failed on a device, another device would be
> > tried, and the unusable device's alua state would get updated, along
> > with all the other device's states.
> 
> Where specifically are you referring to here please?

The removed code above here calls alua_rtpg_select_sdev() to select a
new device to retry the rtpg on, and returns with SCSI_DH_IMM_RETRY, to
retrigger the rtpg on that device. If the rtpg completed on any device,
it would update the state on all the devices. But if we are depending
each device issuing its own rtp to update its state, what happens to
the devices that can't complete the rtpg? I assume the correct answer is
to give them some failed state.
 
-Ben

> > Now I don't see how a failed device
> > gets its state updated.
> 
> AFAICS, I am only not omitted how we iterate through the devices per-PG, as
> now we just do this work for all paths/scsi devices.
> 
> Thanks,
> John

