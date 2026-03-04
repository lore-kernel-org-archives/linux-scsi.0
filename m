Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00879336882
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 05:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772603210; cv=none; b=JXHcNuZAr10XS2p1YWX2kejPkU9xg7dfzItXCZXTCNwi92x5rR9C/HdaV2/d6pcn/t4qMxbY2VfLnksSoE8IeVCtJd0KvvFG0vmcwZVwgVqPmzpCgBdAV5J/5I0rVk8PyXsdcYbl06n/2Aq7JDISVKrRvlf8dX+NV/FsaZWMho0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772603210; c=relaxed/simple;
	bh=hUIfmPCBilfP0Xqq8pH0ZUucRs2CUWQ8XFLyALPYOuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spiqufoIlq+Cv4UmFugxVjDMYSyb2QpH3d5YBUV9YTCJyf/B+D7lHRNI7lucvAaNuCHmup4LCbH++55f4ZjvqD/NO4M9ZcQCG5t22NLWh1ZTh25kKX+jyqQK355EtUl07aAGjUXPJlb1L/A4EDR2Pd0xlQz8HhMfdWh/RUASmXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E+YCHsEn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+YCHsEn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772603207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YwA0ezg/TFuorG4SmLYdxWUhuc54KWNW48ti3csISxk=;
	b=E+YCHsEnrdUVAZximunagApmzvzFpczKzEd9fP4pavZjA1wdtbSn+qHWU4vgk9+zIjiNC4
	DsNfnxhRmz5aTWRgMGbFyi+VWcETDqJIzJkjyB6QxhIlmbul0CgFrvV+jeDy9J+iWabIao
	leVc7y2fnJQsrumRwtvW2UmHwBUdScI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-1g9MKLyDNZC5E5YDYvfhVA-1; Wed,
 04 Mar 2026 00:46:43 -0500
X-MC-Unique: 1g9MKLyDNZC5E5YDYvfhVA-1
X-Mimecast-MFC-AGG-ID: 1g9MKLyDNZC5E5YDYvfhVA_1772603201
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9934C1956096;
	Wed,  4 Mar 2026 05:46:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8845619560AB;
	Wed,  4 Mar 2026 05:46:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6245kbZD1917094
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Mar 2026 00:46:37 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6245kaS41917093;
	Wed, 4 Mar 2026 00:46:36 -0500
Date: Wed, 4 Mar 2026 00:46:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/24] scsi-multipath: failover handling
Message-ID: <aafHPC3yncBxuBVx@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-10-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153627.1032500-10-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Feb 25, 2026 at 03:36:12PM +0000, John Garry wrote:
> For a scmd which suffers failover, requeue the master bio of each bio
> attached to its request.
> 
> A handler is added in the scsi_driver structure to lookup a
> mpath_disk from a request. This is needed because the scsi_disk structure
> will manage the mpath_disk, and the code core has no method to look this
> up from the scsi_scmnd.
> 
> Failover occurs when the scsi_cmnd has failed and it is discovered that the
> original scsi_device has transport down.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_error.c     | 12 ++++++
>  drivers/scsi/scsi_lib.c       |  9 +++-
>  drivers/scsi/scsi_multipath.c | 80 +++++++++++++++++++++++++++++++++++
>  include/scsi/scsi.h           |  1 +
>  include/scsi/scsi_driver.h    |  3 ++
>  include/scsi/scsi_multipath.h | 14 ++++++
>  6 files changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index c3e0f792e921f..16b1f84fc552c 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -518,6 +518,86 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
>  
> +bool scsi_is_mpath_request(struct request *req)
> +{
> +	return is_mpath_request(req);
> +}
> +EXPORT_SYMBOL_GPL(scsi_is_mpath_request);
> +
> +static inline void bio_list_add_clone_master(struct bio_list *bl,
> +				struct bio *clone)
> +{
> +	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio;
> +	struct bio *master_bio;
> +
> +	if (clone->bi_next)
> +		bio_list_add_clone_master(bl, clone->bi_next);
> +
> +	scsi_mpath_clone_bio = scsi_mpath_to_master_bio(clone);
> +	master_bio = scsi_mpath_clone_bio->master_bio;
> +
> +	if (bl->tail)
> +		bl->tail->bi_next = master_bio;
> +	else
> +		bl->head = master_bio;
> +
> +	bl->tail = master_bio;
> +
> +	bio_put(clone);
> +}
> +
> +void scsi_mpath_failover_req(struct request *req)
> +{
> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
> +	struct scsi_device *sdev = scmd->device;
> +	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
> +	struct mpath_disk *mpath_disk = drv->to_mpath_disk(req);
> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> +	unsigned long flags;
> +
> +	scsi_mpath_dev_clear_path(scsi_mpath_dev);
> +
> +	spin_lock_irqsave(&mpath_head->requeue_lock, flags);
> +	bio_list_add_clone_master(&mpath_head->requeue_list, req->bio);
> +	spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
> +	req->bio = NULL;
> +	req->biotail = NULL;
> +	req->__data_len = 0;
> +
> +	/* End old request with clone detached */
> +	scmd->result = 0;
> +	blk_mq_end_request(req, 0);
> +
> +	kblockd_schedule_work(&mpath_head->requeue_work);
> +}
> +
> +static inline bool scsi_is_mpath_error(struct scsi_cmnd *scmd)
> +{
> +	struct scsi_device *sdev = scmd->device;
> +
> +	if (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE)
> +		return true;
> +	return false;
> +}
> +
> +int scsi_mpath_failover_disposition(struct scsi_cmnd *scmd)
> +{
> +	struct request *req = scsi_cmd_to_rq(scmd);
> +
> +	if (is_mpath_request(req)) {
> +		if (scsi_is_mpath_error(scmd) ||
> +		    blk_queue_dying(req->q))
> +			return FAILOVER;
> +		return NEEDS_RETRY;
> +	} else {

nitpick: this else block is unnecessary.

-Ben

> +		if (blk_queue_dying(req->q))
> +			return SUCCESS;
> +	}
> +
> +	return SUCCESS;
> +}
> +

