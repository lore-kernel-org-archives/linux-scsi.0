From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 08/32] cxlflash: Fix to avoid CXL services during EEH
Date: Tue, 29 Sep 2015 09:05:11 +1000
Message-ID: <87h9meuouw.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222852-9229-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36468 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbbI1XFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 19:05:18 -0400
Received: by pablk4 with SMTP id lk4so89579097pab.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 16:05:17 -0700 (PDT)
In-Reply-To: <1443222852-9229-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


You have two versions of check_state() below, which is a bit
confusing. It looks like you've moved the function and also added the
up/down of the read semaphore. I assume that's all that changed?

>  
>  /**
> + * check_state() - checks and responds to the current adapter state
> + * @cfg:	Internal structure associated with the host.
> + *
> + * This routine can block and should only be used on process context.
> + * It assumes that the caller is an ioctl thread and holding the ioctl
> + * read semaphore. This is temporarily let up across the wait to allow
> + * for draining actively running ioctls. Also note that when waking up
> + * from waiting in reset, the state is unknown and must be checked again
> + * before proceeding.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int check_state(struct cxlflash_cfg *cfg)
> +{
> +	struct device *dev = &cfg->dev->dev;
> +	int rc = 0;
> +
> +retry:
> +	switch (cfg->state) {
> +	case STATE_LIMBO:
> +		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
> +		up_read(&cfg->ioctl_rwsem);
> +		rc = wait_event_interruptible(cfg->limbo_waitq,
> +					      cfg->state != STATE_LIMBO);
> +		down_read(&cfg->ioctl_rwsem);
> +		if (unlikely(rc))
> +			break;
> +		goto retry;
> +	case STATE_FAILTERM:
> +		dev_dbg(dev, "%s: Failed/Terminating!\n", __func__);
> +		rc = -ENODEV;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +/**
>   * cxlflash_disk_attach() - attach a LUN to a context
>   * @sdev:	SCSI device associated with LUN.
>   * @attach:	Attach ioctl data structure.
> @@ -1523,41 +1563,6 @@ err1:
>  }
>  
>  /**
> - * check_state() - checks and responds to the current adapter state
> - * @cfg:	Internal structure associated with the host.
> - *
> - * This routine can block and should only be used on process context.
> - * Note that when waking up from waiting in limbo, the state is unknown
> - * and must be checked again before proceeding.
> - *
> - * Return: 0 on success, -errno on failure
> - */
> -static int check_state(struct cxlflash_cfg *cfg)
> -{
> -	struct device *dev = &cfg->dev->dev;
> -	int rc = 0;
> -
> -retry:
> -	switch (cfg->state) {
> -	case STATE_LIMBO:
> -		dev_dbg(dev, "%s: Limbo, going to wait...\n", __func__);
> -		rc = wait_event_interruptible(cfg->limbo_waitq,
> -					      cfg->state != STATE_LIMBO);
> -		if (unlikely(rc))
> -			break;
> -		goto retry;
> -	case STATE_FAILTERM:
> -		dev_dbg(dev, "%s: Failed/Terminating!\n", __func__);
> -		rc = -ENODEV;
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	return rc;
> -}
> -
> -/**
>   * cxlflash_afu_recover() - initiates AFU recovery
>   * @sdev:	SCSI device associated with LUN.
>   * @recover:	Recover ioctl data structure.
> @@ -1646,9 +1651,14 @@ retry_recover:
>  	/* Test if in error state */
>  	reg = readq_be(&afu->ctrl_map->mbox_r);
>  	if (reg == -1) {
> -		dev_dbg(dev, "%s: MMIO read fail! Wait for recovery...\n",
> -			__func__);
> -		mutex_unlock(&ctxi->mutex);
> +		dev_dbg(dev, "%s: MMIO fail, wait for recovery.\n", __func__);
> +
> +		/*
> +		 * Before checking the state, put back the context obtained with
> +		 * get_context() as it is no longer needed and sleep for a short
> +		 * period of time (see prolog notes).
> +		 */
> +		put_context(ctxi);

Is this needed for the drain to work? It looks like it fixes a
refcounting bug in the function, but I'm not sure I understand how it
interacts with the rest of this patch.

Anyway, the patch overall looks good to me, and makes your driver
interact with CXL's EEH support in the way I intended when I wrote it.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel
