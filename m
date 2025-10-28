Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6168A1531C8
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761662852; cv=none; b=B8XTdjczpfMaEgMRVXsgLUHlP+wAxFuN870H8hLmkFru2hf+2xe+q94oVRvAmIxKSsuyaHUu/4/wANokDLwxLujdUFvMaCvvDQ4Cyoh/AWgT5dWd2uQa5JCHa+bC4UgoCjT9zfJZSlCBxGE+s86pQlHLZ16BHnUG8w6wIPt9YIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761662852; c=relaxed/simple;
	bh=ZQHoiYtpkZmMG+nRgL7Ywb8/dYc+n1zTXtl7AEXirwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsvMyQOB0Kwhy+uusExWCg5ZU7/IwNLWHhATDDfR6s7KrPKWgYJ0SVl+2dhKk8s6Q71yrzWjr0TsqcKCIFVjyRAYAb0roPssO+ElGts7CtbW1JRmT+x/wEvbEQlUX+MjxxerIjEgHTxteQNEwQUBzUSRgn7jY32u9Ghxu4S6VdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LN8SkFUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LN8SkFUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A014FC4CEE7;
	Tue, 28 Oct 2025 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761662852;
	bh=ZQHoiYtpkZmMG+nRgL7Ywb8/dYc+n1zTXtl7AEXirwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LN8SkFUiB0CLZR7eb9nfpOf+DUrQLWrbvV+Gy4eXd1GmQC6Bqzmn2fyvfQkzNap7o
	 fXU9+CHFZqZxgNcO1fRQAwDQkjPJwOIXmzYhuTpVDJHdekEgkmBHljLa2bHLm1zxB0
	 mfG6tq8UMJUOOEOu33TL6+PJjPfvYLBFqPBgaUll52kpEIRwKQ7vY5VROElzt24wnn
	 0/C6mLYB6LKgkbnqjSQjPSA6wKLUm7/NO6AlEXZVyRJRdC2TFe7/l8TaYw2kXf2Sa3
	 +4ZJZRXAMk/DJQLBUg0YW6eSvwI3/csLQ1N8EwM8890M/uxpa8CHzrLCRD+ZYSqSYX
	 eTxBuVmafvjEg==
Date: Tue, 28 Oct 2025 09:50:29 -0500
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
Message-ID: <oyiecngk4n3em5m4or7ev27w2f7qcveqwhidh6bay46gbgjvds@qs2uyfmwv76h>
References: <20251027170950.2919594-1-bvanassche@acm.org>
 <20251027170950.2919594-3-bvanassche@acm.org>
 <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
 <6acc1879-ebb9-4e51-bbe9-3824f8f1711f@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6acc1879-ebb9-4e51-bbe9-3824f8f1711f@acm.org>

On Tue, Oct 28, 2025 at 06:57:07AM -0700, Bart Van Assche wrote:
> 
> On 10/27/25 8:03 PM, Bjorn Andersson wrote:
> > So, unless I'm missing something with regards to the error handler that
> > you refer to, I think you should solve this problem in ufshcd_init(), by
> > making sure that syfs attributes are created before the
> > ufshcd_device_params_init() call.
> 
> Something like this? (needs more work to make sure all state information
> that can be modified through sysfs has been initialized before the sysfs
> attributes are added)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5d6297aa5c28..3ad258922036 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10800,6 +10800,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>          */
>         ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> 
> +       ufs_sysfs_add_nodes(hba->dev);
> +
>         /* IRQ registration */
>         err = devm_request_threaded_irq(dev, irq, ufshcd_intr,
> ufshcd_threaded_intr,
>                                         IRQF_ONESHOT | IRQF_SHARED, UFSHCD,
> hba);
> @@ -10887,7 +10889,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>         if (err)
>                 goto out_disable;
> 
> -       ufs_sysfs_add_nodes(hba->dev);
>         async_schedule(ufshcd_async_scan, hba);
> 
>         device_enable_async_suspend(dev);
> 

Yes, to me that looks like it would solve the issue at hand in a clean
fashion. But you'd need cleanup in out_disable as well.

> > PS. How come these are attributes on the host device and not on the SCSI
> > host device (i.e. ufshcd_driver_template::shost_groups)? It seems like
> > more structured place to have such properties, and would avoid having to
> > dynamically create/destroy them from the ufshcd driver itself.
> 
> This choice was made before I started contributing to the UFSHCI driver.
> I'm not sure why this choice has been made. If we would start over from
> scratch, I think the UFSHCI attributes should be added to the UFSHCI
> device instance and the UFS attributes should be added to the SCSI host.
> Today the sysfs attributes created by the UFSHCI driver are a mix of
> UFSHCI and UFS attributes.
> 
> This is a change we can't make today because it would break user space.
> 

That's too bad, it would have been nice to get that cleaned up.

Regards,
Bjorn

> Thanks,
> 
> Bart.
