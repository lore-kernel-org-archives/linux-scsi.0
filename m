Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2457831B10B
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773155991; cv=none; b=TBks50lkCJh2Swxg13JdSxM3ufL9QOa/SsyUbAQLQPjsB+znNZk70SwAx020srbkRxh37EThelpDw2EFfHUSDfvNgKTm/qsfq5vn3cYMwIMDksodIYDfvbhfC2RuBEcR4fKQEZpc9dQy8r0fZ2y7U9pW4llL65AJEwDIqaixsEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773155991; c=relaxed/simple;
	bh=wWkYcqscYrSPZY5rn1cyuzamzMbCZfG36Dc/QvxGcfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEjeYPlsAK4SgIxRu2gDZTsEvbQrT+lTd40LTRGS6YJdj5Odlsrd6biO1Nb9c46nmhlcbKcM/ZY+SdQOiL/Pb81G3x/A640kbqDba5mYgoyMWF/agAOVEXuGQHJD8kVZ3gwPhilGM85XDJnIa3DpNnkHcjQ6f6m2EaauijcOjhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADOI3BPD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADOI3BPD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773155989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VHucvSpsJZ1hD1W0lD+QRrW+SKG/AnUELnrm6Bsd77M=;
	b=ADOI3BPDq/iv85sAjV/LKBQVM0koUeasNdpyarOxkZyoav+eVGyQYxyTbXu/vJEvhsrrYC
	uj8G7qAqd/F6akfRVV4Gtzz4DHKRcjOSL3vdV56pOuSNsIH7RdapAJ4P3S+wyC2XEQ+c4F
	ChP1vpQwgjLKOTuOuqFSIIy1aBmBOpI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-qM-ye5rAOsaELTeyzYFToQ-1; Tue,
 10 Mar 2026 11:19:44 -0400
X-MC-Unique: qM-ye5rAOsaELTeyzYFToQ-1
X-Mimecast-MFC-AGG-ID: qM-ye5rAOsaELTeyzYFToQ_1773155981
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0EF218005BA;
	Tue, 10 Mar 2026 15:19:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D994D1800576;
	Tue, 10 Mar 2026 15:19:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62AFJcnA024189
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 11:19:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62AFJcRo024188;
	Tue, 10 Mar 2026 11:19:38 -0400
Date: Tue, 10 Mar 2026 11:19:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/24] scsi: sd: support multipath disk
Message-ID: <abA2irnI-P8kkcgj@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-22-john.g.garry@oracle.com>
 <aa-EtdqIOX603PVu@redhat.com>
 <c204b634-8df8-4495-916b-1209cbd869d6@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c204b634-8df8-4495-916b-1209cbd869d6@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Mar 10, 2026 at 10:12:07AM +0000, John Garry wrote:
> On 10/03/2026 02:40, Benjamin Marzinski wrote:
> > > +static int sd_mpath_probe(struct scsi_disk *sdkp)
> > > +{
> > > +	struct scsi_device *sdp = sdkp->device;
> > > +	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
> > > +	struct device *dma_dev = sdp->host->dma_dev;
> > > +	struct scsi_mpath_head *scsi_mpath_head =
> > > +				scsi_mpath_dev->scsi_mpath_head;
> > > +	struct sd_mpath_disk *sd_mpath_disk;
> > > +	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
> > > +	struct queue_limits lim;
> > > +	struct gendisk *disk;
> > > +	int error;
> > > +
> > > +	/*
> > > +	 * sd_mpath_disks_list is kept locked if no disk found.
> > > +	 * Otherwise an extra reference is taken.
> > > +	 */
> > Again, I personally think the logic is easier to follow when all the
> > locking isn't split over multiple functions.
> 
> Sure, but I am considering removing the mpath_disk structure, so things may
> change here anyway. Removing mpath_disk should simplify things for the nvme
> driver transition.

Sure.

> 
> > 
> > > +	sd_mpath_disk = sd_mpath_find_disk(sdp);
> > > +	if (sd_mpath_disk) {
> > > +		mutex_lock(&sd_mpath_disk->lock);
> > > +		sd_mpath_disk->disk_count++;
> > > +		mutex_unlock(&sd_mpath_disk->lock);
> > > +		goto found;
> > > +	}
> > > +
> > > +	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
> > > +	if (!sd_mpath_disk) {
> > > +		error = -ENOMEM;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
> > > +	device_initialize(&sd_mpath_disk->dev);
> > > +	mutex_init(&sd_mpath_disk->lock);
> > > +	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
> > > +
> > > +	blk_set_stacking_limits(&lim);
> > > +	lim.dma_alignment = 3;
> > > +	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
> > > +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
> > > +
> > > +	sd_mpath_disk->mpath_disk = mpath_alloc_head_disk(&lim,
> > > +						dev_to_node(dma_dev));
> > > +	if (!sd_mpath_disk->mpath_disk) {
> > > +		error = -ENOMEM;
> > > +		goto out_free_disk;
> > > +	}
> > > +	disk = sd_mpath_disk->mpath_disk->disk;
> > > +	mpath_get_head(mpath_head); /* undone in mpath_free_disk() */
> > > +
> > > +	sd_mpath_disk->mpath_disk->mpath_head = mpath_head;
> > > +	sd_mpath_disk->mpath_disk->parent = &sd_mpath_disk->dev;
> > > +
> > > +	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
> > > +	if (error < 0) {
> > > +		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
> > > +		goto out_put_disk;
> > > +	}
> > > +	sd_mpath_disk->disk_index = error;
> > > +	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
> > > +				disk->disk_name, DISK_NAME_LEN);
> > > +	if (error)
> > > +		goto out_free_index;
> > > +
> > > +	error = dev_set_name(&sd_mpath_disk->dev, "%s",
> > > +				dev_name(&scsi_mpath_head->dev));
> > > +	if (error)
> > > +		goto out_free_index;
> > > +
> > > +	/* undone in sd_mpath_disk_release() */
> > > +	scsi_mpath_get_head(scsi_mpath_head);
> > > +
> > > +	error = device_add(&sd_mpath_disk->dev);
> > > +	if (error) {
> > > +		put_device(&sd_mpath_disk->dev);
> > > +		goto out_unlock;
> > We should clean up when we fail here, instead of just unlocking without
> > fully setting things up.
> 
> I think that the release function is called from put_device(), which should
> do the class tidy up. Something similar is done in sd_probe() for the
> disk_dev.

Oops. You are correct.

-Ben

> Thanks,
> John

