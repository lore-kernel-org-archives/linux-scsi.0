Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C422E54CC
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 17:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761758727; cv=none; b=EJm2ZWI+fAyOk5MmCdJhF1kkZydgH3P39Czk5EigOGBZY7TsZrVs0euZUe/oYruUrM6XFa9581k1E6xL3ax47YSOYO2APbIG7zz8r84JMVLwd+0iGAojjubhQ7g2XZt/GaG0xMtes1Q+ULj6D6w0NIzGiDtlCgg/tLnWxYlYOtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761758727; c=relaxed/simple;
	bh=knbE+q1pgvfVUdqILk/A/goXKbrThZO8QvCagpQmC0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S76q77XH6KrxFrN0KG2R4Nj0N5C4Nby4cZFibGp0YH+y5p8i+DDOc/R5x07Eq3DvI4hf3Z2+2OpCQX0Q7Vr2XRCY4d0r2XybleGmadRFFiEgsI4bSNrgZCyIMhygJtt9khewVeZVMKoLq1nlN8m2QuuCFMj/NN/EGvt5iJTzRx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ueJbNa0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ueJbNa0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80A7C4CEF7;
	Wed, 29 Oct 2025 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761758727;
	bh=knbE+q1pgvfVUdqILk/A/goXKbrThZO8QvCagpQmC0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ueJbNa0Z1WSQ77RPYS7jaZJiVX1kFe+/j51AZZ1zdBLvfkxzKonz3izcQA57W7eXL
	 7U3APTNzWtRXRs0kJ+yEYQNxsEqsYWOAAbjDPE+WcjqHUTBFeXMvue1sq1lmqaonBa
	 vu3ef4l9/a+Lgd11rJiJOu2ucUuTbSfzvYVqSdtmQJjYkJuVwC77Uvb8Ykk0gCStIm
	 WNSSrcjheu9gcLnU+e/sJKZCCRj/ufqJN6HUt8tHy6HjQO+4kERrI1ei5VZLli4uGc
	 eiIlaWP0NTjBwffbM3fchqM2yk63tp2xAi+kXbNZ2qpAWR7lEJzo4P487F5itABsVN
	 5X7eJCURAGw7Q==
Date: Wed, 29 Oct 2025 12:28:30 -0500
From: Bjorn Andersson <andersson@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>, 
	Peter Wang <peter.wang@mediatek.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>, 
	Liu Song <liu.song13@zte.com.cn>, Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Bean Huo <huobean@gmail.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	Gwendal Grignou <gwendal@chromium.org>
Subject: Re: [PATCH] ufs: core: Revert "Make HID attributes visible"
Message-ID: <xinigkv7z6ukyb7jgls3dubvxoni5ar2bp4dvtupenpvemaz6w@l67yzcnvicw3>
References: <20251028222433.1108299-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028222433.1108299-1-bvanassche@acm.org>

On Tue, Oct 28, 2025 at 03:24:24PM -0700, Bart Van Assche wrote:
> Patch "Make HID attributes visible" is needed for older kernel versions
> (e.g. 6.12) where ufs_get_device_desc() is called from ufshcd_probe_hba().
> In these older kernel versions ufshcd_get_device_desc() may be called
> after the sysfs attributes have been added. In the upstream kernel however
> ufshcd_get_device_desc() is called before ufs_sysfs_add_nodes(). See also
> the ufshcd_device_params_init() call from ufshcd_init(). Hence, calling
> sysfs_update_group() is not necessary.
> 
> See also commit 69f5eb78d4b0 ("scsi: ufs: core: Move the
> ufshcd_device_init(hba, true) call") in kernel v6.13.
> 
> This patch fixes the following kernel warning:
> 
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
> Cc: Bjorn Andersson <andersson@kernel.org>

Thanks for continuing the research, this looks even better than what we
discussed :)

Reviewed-by: Bjorn Andersson <andersson@kernel.org>

Regards,
Bjorn

> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
> ---
>  drivers/ufs/core/ufs-sysfs.c | 2 +-
>  drivers/ufs/core/ufs-sysfs.h | 1 -
>  drivers/ufs/core/ufshcd.c    | 2 --
>  3 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index c040afc6668e..0086816b27cd 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobject *kobj,
>  	return	hba->dev_info.hid_sup ? attr->mode : 0;
>  }
>  
> -const struct attribute_group ufs_sysfs_hid_group = {
> +static const struct attribute_group ufs_sysfs_hid_group = {
>  	.name = "hid",
>  	.attrs = ufs_sysfs_hid,
>  	.is_visible = ufs_sysfs_hid_is_visible,
> diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
> index 6efb82a082fd..8d94af3b8077 100644
> --- a/drivers/ufs/core/ufs-sysfs.h
> +++ b/drivers/ufs/core/ufs-sysfs.h
> @@ -14,6 +14,5 @@ void ufs_sysfs_remove_nodes(struct device *dev);
>  
>  extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
>  extern const struct attribute_group ufs_sysfs_lun_attributes_group;
> -extern const struct attribute_group ufs_sysfs_hid_group;
>  
>  #endif
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5d6297aa5c28..2b76f543d072 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8499,8 +8499,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>  				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
>  				UFS_DEV_HID_SUPPORT;
>  
> -	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
> -
>  	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>  
>  	err = ufshcd_read_string_desc(hba, model_index,
