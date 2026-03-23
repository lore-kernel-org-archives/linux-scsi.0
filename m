Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D624954654
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 01:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774231135; cv=none; b=ZMSr1AcDqCLFigZfOY1a4kffG/LOp3NB8zkQfnk9gkT/A3c91+ep3iDkiuhbdBuVUE7uDWnHhOHvxB2t05zIxTCcp4WBaRKIo9YU2Z3LYzWig8M1FPWpudptrbml2GMkc9f3KzqCJG/DZPc4aN0luOslg8E1+cmVdkXaYwZFBOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774231135; c=relaxed/simple;
	bh=61Dq36XY87M1JZcZvZL+tMAXXJ4ZA4Rhxvjq+Lqz3Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+Iu5JFEeFhBLGr9fJFkfBoBl9SZU74q+ytlOiuIXy90pFCPIlJ7N8adAZgmFwa6SKK/Zdn2A+ESTO/5XxZyf8zq3jCmAxULRayixNhimDXus67nLXYQzcEATHae9di2GER2jFi3stwWqHP9RagCCpEfHBSUq53I4GUNDXrl3Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FRcNI1+9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRcNI1+9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774231133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+FaKjvgSlxh5v5V3BgfcZvMURWE5LbSpzWyWRWOSIag=;
	b=FRcNI1+9GpxBglXvtn8M4tpuCaHtGoK4ka1jaASPxbLMOP+hVUvZMu8gr37xL5DfBTHPfP
	GILa0uaP9UhM+1fpjIqLPz4fmyC/v6eTshCdtzDS+V4t65lxvR+5n71OV/fn75Rj8Eoru/
	tnSjt08NUuEjAo8MseMzml/ZX/Utac8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-NrTY-ooFOC-FLtdw8gwv2Q-1; Sun,
 22 Mar 2026 21:58:49 -0400
X-MC-Unique: NrTY-ooFOC-FLtdw8gwv2Q-1
X-Mimecast-MFC-AGG-ID: NrTY-ooFOC-FLtdw8gwv2Q_1774231127
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FE0F18005B3;
	Mon, 23 Mar 2026 01:58:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9B4119560B7;
	Mon, 23 Mar 2026 01:58:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62N1wjs21003473
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 22 Mar 2026 21:58:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62N1wjit1003472;
	Sun, 22 Mar 2026 21:58:45 -0400
Date: Sun, 22 Mar 2026 21:58:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] scsi: core: Add implicit ALUA support
Message-ID: <acCeVabspYFjQHPu@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-14-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317120703.3702387-14-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Mar 17, 2026 at 12:07:03PM +0000, John Garry wrote:
> For when no device handler is used, add ALUA support.
> 
> This will be equivalent to when native SCSI multipathing is used.
> 
> Essentially all the same handling is available as DH alua driver for
> rescan, request prep, sense handling.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_alua.c  | 93 +++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_error.c |  7 +++
>  drivers/scsi/scsi_lib.c   |  7 +++
>  drivers/scsi/scsi_scan.c  |  2 +
>  drivers/scsi/scsi_sysfs.c |  4 +-
>  include/scsi/scsi_alua.h  | 14 ++++++
>  6 files changed, 126 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> index d3fcd887e5018..ee0229b1a9d12 100644
> --- a/drivers/scsi/scsi_alua.c
> +++ b/drivers/scsi/scsi_alua.c
> @@ -562,6 +562,90 @@ int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
>  }
>  EXPORT_SYMBOL_GPL(scsi_alua_stpg_run);
>  
> +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
> +					      struct scsi_sense_hdr *sense_hdr)

This seems like it should be shareable with scsi_dh_alua as well.  In
might need to take a function to call for rescanning and have
alua_check_sense() be a wrapper around it, but since the force argument
to alua_check() is now always set to true in scsi_dh_alua, it's
unnecessary, so both it and scsi_device_alua_rescan() can have the
same arguments.

> +{
> +	switch (sense_hdr->sense_key) {
> +	case NOT_READY:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> +			/*
> +			 * LUN Not Accessible - ALUA state transition
> +			 */
> +			scsi_alua_handle_state_transition(sdev);
> +			return NEEDS_RETRY;
> +		}
> +		break;
> +	case UNIT_ATTENTION:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> +			/*
> +			 * LUN Not Accessible - ALUA state transition
> +			 */
> +			scsi_alua_handle_state_transition(sdev);
> +			return NEEDS_RETRY;
> +		}
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
> +			/*
> +			 * Power On, Reset, or Bus Device Reset.
> +			 * Might have obscured a state transition,
> +			 * so schedule a recheck.
> +			 */
> +			scsi_device_alua_rescan(sdev);
> +			return ADD_TO_MLQUEUE;
> +		}
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
> +			/*
> +			 * Device internal reset
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
> +			/*
> +			 * Mode Parameters Changed
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
> +			/*
> +			 * ALUA state changed
> +			 */
> +			scsi_device_alua_rescan(sdev);
> +			return ADD_TO_MLQUEUE;
> +		}
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
> +			/*
> +			 * Implicit ALUA state transition failed
> +			 */
> +			scsi_device_alua_rescan(sdev);
> +			return ADD_TO_MLQUEUE;
> +		}
> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
> +			/*
> +			 * Inquiry data has changed
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
> +			/*
> +			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
> +			 * when switching controllers on targets like
> +			 * Intel Multi-Flex. We can just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		break;
> +	}
> +
> +	return SCSI_RETURN_NOT_HANDLED;
> +}
> +
> +static void alua_rtpg_work(struct work_struct *work)
> +{
> +	struct alua_data *alua =
> +		container_of(work, struct alua_data, work.work);
> +	int ret;
> +
> +	ret = scsi_alua_rtpg_run(alua->sdev);
> +
> +	if (ret == -EAGAIN)
> +		queue_delayed_work(kalua_wq, &alua->work, alua->interval * HZ);
> +}
> +
>  int scsi_alua_sdev_init(struct scsi_device *sdev)
>  {
>  	int rel_port, ret, tpgs;
> @@ -591,6 +675,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev)
>  		goto out_free_data;
>  	}
>  
> +	INIT_DELAYED_WORK(&sdev->alua->work, alua_rtpg_work);
>  	sdev->alua->sdev = sdev;
>  	sdev->alua->tpgs = tpgs;
>  	spin_lock_init(&sdev->alua->lock);
> @@ -638,6 +723,14 @@ bool scsi_device_alua_implicit(struct scsi_device *sdev)
>  	return sdev->alua->tpgs & TPGS_MODE_IMPLICIT;
>  }
>  
> +void scsi_device_alua_rescan(struct scsi_device *sdev)
> +{
> +	struct alua_data *alua = sdev->alua;
> +
> +	queue_delayed_work(kalua_wq, &alua->work,
> +				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));

This code doesn't support triggering a new rtpg while the current one is
running.  I'll leave it to people with more scsi expertise to say how
important that is, but the scsi_dh_alua code now will always trigger a
new rtpg in this case (or at least it would, with the issues from patch
12 fixed).

-Ben

> +}
> +
>  int scsi_alua_init(void)
>  {
>  	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9c..a542e7a85a24d 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -29,6 +29,7 @@
>  #include <linux/jiffies.h>
>  
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_alua.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_device.h>
> @@ -578,6 +579,12 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>  		if (rc != SCSI_RETURN_NOT_HANDLED)
>  			return rc;
>  		/* handler does not care. Drop down to default handling */
> +	} else if (scsi_device_alua_implicit(sdev)) {
> +		enum scsi_disposition rc;
> +
> +		rc = scsi_alua_check_sense(sdev, &sshdr);
> +		if (rc != SCSI_RETURN_NOT_HANDLED)
> +			return rc;
>  	}
>  
>  	if (scmd->cmnd[0] == TEST_UNIT_READY &&
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d3a8cd4166f92..e5bcee555ea10 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -26,6 +26,7 @@
>  #include <linux/unaligned.h>
>  
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_alua.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_device.h>
> @@ -1719,6 +1720,12 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>  	if (sdev->handler && sdev->handler->prep_fn) {
>  		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
>  
> +		if (ret != BLK_STS_OK)
> +			return ret;
> +	} else if (scsi_device_alua_implicit(sdev)) {
> +		/* We should be able to make this common for ALUA DH as well */
> +		blk_status_t ret = scsi_alua_prep_fn(sdev, req);
> +
>  		if (ret != BLK_STS_OK)
>  			return ret;
>  	}
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3af64d1231445..73caf83bd1097 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1744,6 +1744,8 @@ int scsi_rescan_device(struct scsi_device *sdev)
>  
>  	if (sdev->handler && sdev->handler->rescan)
>  		sdev->handler->rescan(sdev);
> +	else if (scsi_device_alua_implicit(sdev))
> +		scsi_device_alua_rescan(sdev);
>  
>  	if (dev->driver && try_module_get(dev->driver->owner)) {
>  		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 6c4c3c22f6acf..71a9613898cfc 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1152,7 +1152,7 @@ sdev_show_access_state(struct device *dev,
>  	unsigned char access_state;
>  	const char *access_state_name;
>  
> -	if (!sdev->handler)
> +	if (!sdev->handler && !scsi_device_alua_implicit(sdev))
>  		return -EINVAL;
>  
>  	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
> @@ -1409,6 +1409,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	scsi_autopm_get_device(sdev);
>  
>  	scsi_dh_add_device(sdev);
> +	if (!sdev->handler && scsi_device_alua_implicit(sdev))
> +		scsi_device_alua_rescan(sdev);
>  
>  	error = device_add(&sdev->sdev_gendev);
>  	if (error) {
> diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
> index 2d5db944f75b7..8e506d1d66cce 100644
> --- a/include/scsi/scsi_alua.h
> +++ b/include/scsi/scsi_alua.h
> @@ -24,6 +24,7 @@ struct alua_data {
>  	unsigned char		transition_tmo;
>  	unsigned long		expiry;
>  	unsigned long		interval;
> +	struct delayed_work	work;
>  	struct scsi_device	*sdev;
>  	spinlock_t		lock;
>  };
> @@ -35,11 +36,15 @@ void scsi_alua_handle_state_transition(struct scsi_device *sdev);
>  
>  int scsi_alua_check_tpgs(struct scsi_device *sdev);
>  
> +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
> +				struct scsi_sense_hdr *sense_hdr);
> +
>  int scsi_alua_rtpg_run(struct scsi_device *sdev);
>  int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
>  
>  blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req);
>  
> +void scsi_device_alua_rescan(struct scsi_device *sdev);
>  bool scsi_device_alua_implicit(struct scsi_device *sdev);
>  
>  int scsi_alua_init(void);
> @@ -53,6 +58,12 @@ static inline int scsi_alua_check_tpgs(struct scsi_device *sdev)
>  {
>  	return 0;
>  }
> +static inline
> +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
> +				struct scsi_sense_hdr *sense_hdr)
> +{
> +	return SCSI_RETURN_NOT_HANDLED;
> +}
>  static inline int scsi_alua_rtpg_run(struct scsi_device *sdev)
>  {
>  	return 0;
> @@ -66,6 +77,9 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  {
>  	return BLK_STS_OK;
>  }
> +static inline void scsi_device_alua_rescan(struct scsi_device *sdev)
> +{
> +}
>  static inline bool scsi_device_alua_implicit(struct scsi_device *sdev)
>  {
>  	return false;
> -- 
> 2.43.5

