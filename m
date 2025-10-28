Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E12FBF6
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 03:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761620464; cv=none; b=t4vWLpXRM0Hfvuo5SAcZYfUtw5KzeGC6GkP6Q4b9VMdmyQeyTKtTehrUhNj+lJSaTSFoxtWuuwkKdyO394E9cbl5u1mmJ293jNy7Wy7UGakGeVhm0A0yGX6uoYUWxzR31+wVBtRVpNp1wmWQOyQFxs1UWPp2ZfZ3EvTy41tmRj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761620464; c=relaxed/simple;
	bh=EDu7rhN25EJwal6L4eEvbAtFuaZbSrfsM21I52rQSVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lw/d8pY6/tAA1gv9TeGT3F3vuH9Dwj8bL9K4/ZkwB9dFVlx6waFhEupQEsElZzPcNsOpDkzIkmkFcH1jwCfJ8F0jXg8LMTffGjDKixvHeTt8VMhqqSGS5dJlA+5qRtHtD43ytwHXcy067HQ4l26K+A9hu0A2W0k1muZ7bVHjIDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVYAcUsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVYAcUsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3371AC4CEF1;
	Tue, 28 Oct 2025 03:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761620463;
	bh=EDu7rhN25EJwal6L4eEvbAtFuaZbSrfsM21I52rQSVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVYAcUsiMS/3xlY20CwpZnsulrwmcZV0RQCMfNvQ8FgKgTtyd225cb685FbewpVt0
	 kZWb0P4OuvIP5+5t8Vb4aj7ene+pAoubTUo1gYxlYu4ebZD9m+3tenXkdRLx8Eb3WU
	 vvHz68+uCVrE6Bvgx0+8TjZkoVRFnkMV/pEHsYSUNfQRza9TPeTt1lLrgYHumsjuWB
	 /whFSyfT+psMU4ScFvSxCuqO1DRiCjy7S2AiUx61X3Cu7WjSQPx5MmL1UDr4jle67/
	 HG+UiKZywHGj19GdZmiPeTjzUftsp24+3YcdbQbTQ8RgMobt9v6IcJt8ShPtim+gx6
	 CbZ6GdlafhS0Q==
Date: Mon, 27 Oct 2025 22:03:58 -0500
From: Bjorn Andersson <andersson@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>, 
	Peter Wang <peter.wang@mediatek.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Gwendal Grignou <gwendal@chromium.org>, 
	Liu Song <liu.song13@zte.com.cn>, Bean Huo <huobean@gmail.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Can Guo <quic_cang@quicinc.com>, Eric Biggers <ebiggers@kernel.org>, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 2/2] ufs: core: Really fix the code for updating the
 "hid" attribute group
Message-ID: <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
References: <20251027170950.2919594-1-bvanassche@acm.org>
 <20251027170950.2919594-3-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027170950.2919594-3-bvanassche@acm.org>

On Mon, Oct 27, 2025 at 10:09:30AM -0700, Bart Van Assche wrote:
> Recently a sysfs_update_group() call was added in ufs_get_device_desc().
> ufs_get_device_desc() may be called from the error handler and the error
> handler may be activated before ufs_sysfs_add_nodes() is called. This
> causes creation of the "hid" directory before ufs_sysfs_add_nodes() is
> called and hence causes this function to fail.
> 
> Fix this by tracking whether or not ufs_sysfs_add_nodes() has already
> been called. This patch fixes the following kernel warning:
> 

I don't fancy the spirit of this fix. The device driver should be
designed such that initialization happens in a controlled manner, and we
should not have to rely on conditionals sprinkled across the driver to
seemingly get the result we expect (and as this isn't the first attempt,
are we sure you got whacked all the moles now?).


In the message above you're talking about "the error handler", but you
don't specify which error handler this would be.

Looking at the driver, there are a bunch of places where we might end up
calling:

ufshcd_host_reset_and_restore()
  ufshcd_device_init()
    ufshcd_device_params_init()
      ufs_get_device_desc()
  ufshcd_probe_hba()
    ufshcd_device_init()
      ufshcd_device_params_init()
        ufs_get_device_desc()

But we seem to only end up here in the event of suspend/resume or if
ufshcd_schedule_eh_work() has been invoked. I'm guessing that this is
the error handler you're referring to, but I don't see why we would end
up in either suspend or the error handler while we're still half-way
through the initialization of the controller.


Going back to ufshcd_init() on the other hand, we have the following
flow:

ufshcd_init()
  if not UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
    ufshcd_device_params_init()
      ufs_get_device_desc()   <- the cause, at least on my target

  ufs_sysfs_add_nodes()   <- your callstack

  initialized:
  ufshcd_async_scan() <- also the cause, prior to c74dc8ab47c1 ("scsi: ufs: core: Fix a race condition...
    ufshcd_probe_hba()
      ufshcd_device_init()
        ufshcd_device_params_init()
          ufs_get_device_desc()


Which would imply that unless you're on Exynos, you will always
ufs_get_device_desc() and then ufs_sysfs_add_nodes().


So, unless I'm missing something with regards to the error handler that
you refer to, I think you should solve this problem in ufshcd_init(), by
making sure that syfs attributes are created before the
ufshcd_device_params_init() call.


While it does complicate error handling a little bit, I think it makes
total sense to ensure that all such initialization happens before you
start operating the link.


PS. How come these are attributes on the host device and not on the SCSI
host device (i.e. ufshcd_driver_template::shost_groups)? It seems like
more structured place to have such properties, and would avoid having to
dynamically create/destroy them from the ufshcd driver itself.

Regards,
Bjorn

> sysfs: cannot create duplicate filename '/devices/platform/3c2d0000.ufs/hid'
> Workqueue: async async_run_entry_fn
> Call trace:
>  dump_backtrace+0xfc/0x17c
>  show_stack+0x18/0x28
>  dump_stack_lvl+0x40/0x104
>  dump_stack+0x18/0x3c
>  sysfs_warn_dup+0x6c/0xc8
>  internal_create_group+0x1c8/0x504
>  sysfs_create_groups+0x38/0x9c
>  ufs_sysfs_add_nodes+0x20/0x58
>  ufshcd_init+0x1114/0x134c
>  ufshcd_pltfrm_init+0x728/0x7d8
>  ufs_google_probe+0x30/0x84
>  platform_probe+0xa0/0xe0
>  really_probe+0x114/0x454
>  __driver_probe_device+0xa4/0x160
>  driver_probe_device+0x44/0x23c
>  __device_attach_driver+0x15c/0x1f4
>  bus_for_each_drv+0x10c/0x168
>  __device_attach_async_helper+0x80/0xf8
>  async_run_entry_fn+0x4c/0x17c
>  process_one_work+0x26c/0x65c
>  worker_thread+0x33c/0x498
>  kthread+0x110/0x134
>  ret_from_fork+0x10/0x20
> ufshcd 3c2d0000.ufs: ufs_sysfs_add_nodes: sysfs groups creation failed (err = -17)
> 
> Cc: Daniel Lee <chullee@google.com>
> Cc: Peter Wang <peter.wang@mediatek.com>
> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufs-sysfs.c | 7 ++++++-
>  drivers/ufs/core/ufshcd.c    | 3 ++-
>  include/ufs/ufshcd.h         | 3 +++
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 7150c15287d1..714c611b85b0 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -2095,13 +2095,18 @@ void ufs_sysfs_add_nodes(struct ufs_hba *hba)
>  	int ret;
>  
>  	ret = sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
> -	if (ret)
> +	if (ret) {
>  		dev_err(dev,
>  			"%s: sysfs groups creation failed (err = %d)\n",
>  			__func__, ret);
> +		return;
> +	}
> +
> +	WRITE_ONCE(hba->sysfs_attrs_added, true);
>  }
>  
>  void ufs_sysfs_remove_nodes(struct ufs_hba *hba)
>  {
> +	WRITE_ONCE(hba->sysfs_attrs_added, false);
>  	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
>  }
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9521aa38211c..4a543a2a10a4 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8499,7 +8499,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>  				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
>  				UFS_DEV_HID_SUPPORT;
>  
> -	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
> +	if (READ_ONCE(hba->sysfs_attrs_added))
> +		sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
>  
>  	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>  
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 9425cfd9d00e..de7420ee127e 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -869,6 +869,8 @@ enum ufshcd_mcq_opr {
>   * @ee_ctrl_mutex: Used to serialize exception event information.
>   * @is_powered: flag to check if HBA is powered
>   * @shutting_down: flag to check if shutdown has been invoked
> + * @sysfs_attrs_added: Whether or not the sysfs attributes have been added to
> + *	hba->dev.
>   * @host_sem: semaphore used to serialize concurrent contexts
>   * @eh_wq: Workqueue that eh_work works on
>   * @eh_work: Worker to handle UFS errors that require s/w attention
> @@ -1021,6 +1023,7 @@ struct ufs_hba {
>  	struct mutex ee_ctrl_mutex;
>  	bool is_powered;
>  	bool shutting_down;
> +	bool sysfs_attrs_added;
>  	struct semaphore host_sem;
>  
>  	/* Work Queues */
