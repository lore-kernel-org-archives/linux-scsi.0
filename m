From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v5 2/3] cxlflash: Superpipe support
Date: Thu, 13 Aug 2015 20:53:07 +1000
Message-ID: <1439463187.21643.49.camel@neuling.org>
References: <1439423471-15648-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:48935 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbHMKxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 06:53:09 -0400
In-Reply-To: <1439423471-15648-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> Add superpipe supporting infrastructure to device driver for the IBM CXL
> Flash adapter. This patch allows userspace applications to take advantage
> of the accelerated I/O features that this adapter provides and bypass the
> traditional filesystem stack.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Thanks for incorporating my suggestions.  One minor issue below but if
you fix that and add the ioctl version advertising as we talked about
offline, I'm happy if you add my reviewed by.

Reviewed-by: Michael Neuling <mikey@neuling.org>

> +static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
> +				       struct cxl_context *ctx, int ctxid,
> +				       int adap_fd, struct file *file,
> +				       u32 perms)
> +{
> +	struct device *dev = &cfg->dev->dev;
> +	struct afu *afu = cfg->afu;
> +	struct ctx_info *ctxi = NULL;
> +	struct llun_info **lli = NULL;
> +	struct sisl_rht_entry *rhte;
> +
> +	ctxi = kzalloc(sizeof(*ctxi), GFP_KERNEL);
> +	lli = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*lli)), GFP_KERNEL);
> +	if (unlikely(!ctxi || !lli)) {
> +		dev_err(dev, "%s: Unable to allocate context!\n", __func__);
> +		goto out;

If only one of these allocations fails you'll leak some memory.  I
suggest making this "goto err", remove the "out" label and make err
look like this:

err:
	if lli
		kfree(lli);
	if ctxi
		kfree(ctxi);
	return NULL;

> +	}
> +
> +	rhte = (struct sisl_rht_entry *)get_zeroed_page(GFP_KERNEL);
> +	if (unlikely(!rhte)) {
> +		dev_err(dev, "%s: Unable to allocate RHT!\n", __func__);
> +		goto err;
> +	}
> +
> +	ctxi->rht_lun = lli;
> +	ctxi->rht_start = rhte;
> +	ctxi->rht_perms = perms;
> +
> +	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
> +	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
> +	ctxi->lfd = adap_fd;
> +	ctxi->pid = current->tgid; /* tgid = pid */
> +	ctxi->ctx = ctx;
> +	ctxi->file = file;
> +	mutex_init(&ctxi->mutex);
> +	INIT_LIST_HEAD(&ctxi->luns);
> +	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
> +
> +	atomic_inc(&cfg->num_user_contexts);
> +	mutex_lock(&ctxi->mutex);
> +out:
> +	return ctxi;
> +
> +err:
> +	kfree(lli);
> +	kfree(ctxi);
> +	ctxi = NULL;
> +	goto out;
> +}

