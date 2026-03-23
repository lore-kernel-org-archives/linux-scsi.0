Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1953C0638
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 17:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286978; cv=none; b=aIDtbGlVujnH8DMEmjlHYF/tqzBZEGmwOpE2ufWGFeFn/EOOfY4MW5nReuTQWsmlD5zq/AnBvHu8jF72EyuJaCTnLvmHFFL0CmhL/k7ZV9KZF/OLTIPhI4ft4bOrELH/akv/gzURn4jBzv4i3YntRhRPvqEB6zWL9jfMDlzRh0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286978; c=relaxed/simple;
	bh=Jr53n69mVRiKSltoAN/p55y14xfpX+faZJ3p05zJG0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GaWVUj4jM/2IepKkHXKzqHymhNZwK45758fPplRbAGvhaIc13tPnFucUvxMGWBFrtrM8j0tWS8X8wse2TTqD3wzApCJQzr4ma/j8nhrfOX4w+KvzoNCDocX4kp1AXn20AEzCPghVboxqJ10Y4777ruv+Y/qMzz2T6DuoSjSiAlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U7GRTdil; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U7GRTdil"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774286974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oQOCDtCjRRTkJWp7YxTtsv8eCd8g+/fXL3Qr5qe3IFo=;
	b=U7GRTdilEyH63rWutTRLN4tM6jcYI/6aiBhzhMTe4ROsXu/Km5hacucSYvcqFBsdbL1yz9
	GYSq9QlKxx0zjfUg+Wp2utAm6n3rWRc0XbS7+u0VrodokTOU9KmfhGT9EJC10+1b31ewmQ
	BAqIVry48kLTAYPwlQbmBJmv5SCE8Fg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-Xb25JK_tPZeP5eY4SeQ8-g-1; Mon,
 23 Mar 2026 13:29:31 -0400
X-MC-Unique: Xb25JK_tPZeP5eY4SeQ8-g-1
X-Mimecast-MFC-AGG-ID: Xb25JK_tPZeP5eY4SeQ8-g_1774286970
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBDE2195608B;
	Mon, 23 Mar 2026 17:29:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44AE018001FE;
	Mon, 23 Mar 2026 17:29:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62NHTRix1027000
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 13:29:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62NHTRCe1026999;
	Mon, 23 Mar 2026 13:29:27 -0400
Date: Mon, 23 Mar 2026 13:29:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] scsi: core: Add implicit ALUA support
Message-ID: <acF4d-uap6KdfAsc@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-14-john.g.garry@oracle.com>
 <acCeVabspYFjQHPu@redhat.com>
 <1f6d5e0c-41f9-440b-a7f0-4850477309fe@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f6d5e0c-41f9-440b-a7f0-4850477309fe@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Mar 23, 2026 at 12:52:18PM +0000, John Garry wrote:
> On 23/03/2026 01:58, Benjamin Marzinski wrote:
> > On Tue, Mar 17, 2026 at 12:07:03PM +0000, John Garry wrote:
> > > For when no device handler is used, add ALUA support.
> > > 
> > > This will be equivalent to when native SCSI multipathing is used.
> > > 
> > > Essentially all the same handling is available as DH alua driver for
> > > rescan, request prep, sense handling.
> > > 
> > > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > > ---
> > >   drivers/scsi/scsi_alua.c  | 93 +++++++++++++++++++++++++++++++++++++++
> > >   drivers/scsi/scsi_error.c |  7 +++
> > >   drivers/scsi/scsi_lib.c   |  7 +++
> > >   drivers/scsi/scsi_scan.c  |  2 +
> > >   drivers/scsi/scsi_sysfs.c |  4 +-
> > >   include/scsi/scsi_alua.h  | 14 ++++++
> > >   6 files changed, 126 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> > > index d3fcd887e5018..ee0229b1a9d12 100644
> > > --- a/drivers/scsi/scsi_alua.c
> > > +++ b/drivers/scsi/scsi_alua.c
> > > @@ -562,6 +562,90 @@ int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
> > >   }
> > >   EXPORT_SYMBOL_GPL(scsi_alua_stpg_run);
> > > +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
> > > +					      struct scsi_sense_hdr *sense_hdr)
> > 
> > This seems like it should be shareable with scsi_dh_alua as well.  In
> > might need to take a function to call for rescanning and have
> > alua_check_sense() be a wrapper around it, but since the force argument
> > to alua_check() is now always set to true in scsi_dh_alua, it's
> > unnecessary, so both it and scsi_device_alua_rescan() can have the
> > same arguments.
> 
> Yeah, I tried it and I just thought that adding the rescan callback was a
> bit messy. I can go with the single function if we think it's better.

I would defer to the opinion of an acutal SCSI maintainer (which I am
not) on this.

> 
> > 
> > > +{
> > > +	switch (sense_hdr->sense_key) {
> > > +	case NOT_READY:
> > > +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> > > +			/*
> > > +			 * LUN Not Accessible - ALUA state transition
> > > +			 */
> > > +			scsi_alua_handle_state_transition(sdev);
> > > +			return NEEDS_RETRY;
> > > +		}
> > > +		break;
> > > +	case UNIT_ATTENTION:
> > > +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> > > +			/*
> > > +			 * LUN Not Accessible - ALUA state transition
> > > +			 */
> > > +			scsi_alua_handle_state_transition(sdev);
> > > +			return NEEDS_RETRY;
> > > +		}
> > > +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
> > > +			/*
> > > +			 * Power On, Reset, or Bus Device Reset.
> > > +			 * Might have obscured a state transition,
> > > +			 * so schedule a recheck.
> > > +			 */
> > > +			scsi_device_alua_rescan(sdev);
> > > +			return ADD_TO_MLQUEUE;
> > > +		}
> > > +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
> > > +			/*
> > > +			 * Device internal reset
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > > +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
> > > +			/*
> > > +			 * Mode Parameters Changed
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > > +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
> > > +			/*
> > > +			 * ALUA state changed
> > > +			 */
> > > +			scsi_device_alua_rescan(sdev);
> > > +			return ADD_TO_MLQUEUE;
> > > +		}
> > > +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
> > > +			/*
> > > +			 * Implicit ALUA state transition failed
> > > +			 */
> > > +			scsi_device_alua_rescan(sdev);
> > > +			return ADD_TO_MLQUEUE;
> > > +		}
> > > +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
> > > +			/*
> > > +			 * Inquiry data has changed
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > > +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
> > > +			/*
> > > +			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
> > > +			 * when switching controllers on targets like
> > > +			 * Intel Multi-Flex. We can just retry.
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > > +		break;
> > > +	}
> > > +
> > > +	return SCSI_RETURN_NOT_HANDLED;
> > > +}
> > > +
> > > +static void alua_rtpg_work(struct work_struct *work)
> > > +{
> > > +	struct alua_data *alua =
> > > +		container_of(work, struct alua_data, work.work);
> > > +	int ret;
> > > +
> > > +	ret = scsi_alua_rtpg_run(alua->sdev);
> > > +
> > > +	if (ret == -EAGAIN)
> > > +		queue_delayed_work(kalua_wq, &alua->work, alua->interval * HZ);
> > > +}
> > > +
> > >   int scsi_alua_sdev_init(struct scsi_device *sdev)
> > >   {
> > >   	int rel_port, ret, tpgs;
> > > @@ -591,6 +675,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev)
> > >   		goto out_free_data;
> > >   	}
> > > +	INIT_DELAYED_WORK(&sdev->alua->work, alua_rtpg_work);
> > >   	sdev->alua->sdev = sdev;
> > >   	sdev->alua->tpgs = tpgs;
> > >   	spin_lock_init(&sdev->alua->lock);
> > > @@ -638,6 +723,14 @@ bool scsi_device_alua_implicit(struct scsi_device *sdev)
> > >   	return sdev->alua->tpgs & TPGS_MODE_IMPLICIT;
> > >   }
> > > +void scsi_device_alua_rescan(struct scsi_device *sdev)
> > > +{
> > > +	struct alua_data *alua = sdev->alua;
> > > +
> > > +	queue_delayed_work(kalua_wq, &alua->work,
> > > +				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
> > 
> > This code doesn't support triggering a new rtpg while the current one is
> > running.  I'll leave it to people with more scsi expertise to say how
> > important that is, but the scsi_dh_alua code now will always trigger a
> > new rtpg in this case (or at least it would, with the issues from patch
> > 12 fixed).
> > 
> 
> If the work is running and we call queue_delayed_work() on the same
> work_struct, then it is enqueued again. If the work is pending and we call
> queue_delayed_work(), then it is not requeued (as it is already queued).

Oops. You're correct.

-Ben

> Thanks,
> John

