Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39A83054FB
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 08:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764665526; cv=none; b=LtLxwlauHz44WhvvQihWfhOAV39MHhVNIu+uyk+qnucDQ9xg4MLzI+l2VRh3D9XeS6nMGHWrJqi3xWWsku7KMf5h3abr9g5qYymhH4GyDHr4iDyddi0mLXfwT6z+Tjxb5Syr2Kpji5Smg22I5pdHl0MNp50LJZ2VUJSiIxH0mG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764665526; c=relaxed/simple;
	bh=ZeUi4KksstmuHNQbjfHNMzs0EU84mGi/0hRIqZULqAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PCyoei7DxHkJyAvgl70ze/F2mCg4TTNfo1ysWyXm//gN7kGyLmS/mPrIrHI56O3Ie61dpfL8hZnB+v+m8q1zMYXkHpRQeVSHY6iT2hJIHUQmWVgCE2g/gVXNB9eXztzMtavM90U9KHr81CMdw6Y/Jlgw9fTVc3KCRGd8RhUDQ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZntmE8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZntmE8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5526C4CEF1;
	Tue,  2 Dec 2025 08:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764665526;
	bh=ZeUi4KksstmuHNQbjfHNMzs0EU84mGi/0hRIqZULqAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UZntmE8ZBo9rSENSSqWSTzfadNQ9FXmPMOqUY4akSJC0Kid47cBRMRJabPIrqW53o
	 hj8qNlsrw/gWo9mIMRgTogduXXEzt9Ovql60M/a4K/ohKFnZOsswRq8NxGK4iuq9rR
	 dTPpTG0KOm1b3QxRAziSH18anldAgRZ2zvj0Gp3+eNB1LZszb8zKVvXdSxZPiNuhC4
	 HcNxO0i1l5xrVcHp+zXwRkddHgTR/Wu268YPVkw6m04iQfhD9OMa9aWU9DgF5/iIjq
	 nzyCs6V7cBlPV8TQVs064bwx3Qt9dLGHdlIqGvCustqmAHYx0f4NtK5Fy+J0PmBjGZ
	 osWU+9H3ZEI3Q==
Date: Tue, 2 Dec 2025 14:21:56 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Roger Shimizu <rosh@debian.org>, Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
Message-ID: <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>

On Mon, Dec 01, 2025 at 09:37:32PM -1000, Bart Van Assche wrote:
> On 12/1/25 6:46 PM, Manivannan Sadhasivam wrote:
> > I checked out 1d0af94ffb5d and applied the diff, but it didn't help:
> > 
> > [    3.878314] scsi host0: ufshcd
> > [    3.881687] scsi host0: nr_reserved_cmds set but no method to queue
> > [    3.888310] ufshcd-qcom 1d84000.ufshc: scsi_add_host failed
> > [    3.895031] ufshcd-qcom 1d84000.ufshc: error -EINVAL: Initialization failed with error -22
> > [    3.903705] ufshcd-qcom 1d84000.ufshc: error -EINVAL: ufshcd_pltfrm_init() failed
> > [    3.911572] ufshcd-qcom 1d84000.ufshc: probe with driver ufshcd-qcom failed with error -22
> > 
> > I'm running out of time to debug this issue. I hope Nitin can also look into
> > this.
> 
> Unfortunately the series is not bisectable. Does this patch on top of
> commit 1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
> request") help? If not, does the combination of the patch below and the
> previous patch help?
> 

I applied below diff and the previous one on top of 1d0af94ffb5d, the board
booted fine. Even without the previous diff, the below one is sufficient enough
to fix the issue.

But I tried the below diff on top of next-20251127, and the issue still
persists. Please share a fix on top of scsi-next or next/master.

- Mani

> Thanks,
> 
> Bart.
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e047747d4ecf..ad1476fb5035 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -231,12 +231,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost,
> struct device *dev,
>                 goto fail;
>         }
> 
> -       if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
> -               shost_printk(KERN_ERR, shost,
> -                            "nr_reserved_cmds set but no method to
> queue\n");
> -               goto fail;
> -       }
> -
>         /* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
>         shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>                                    shost->can_queue);
> 

-- 
மணிவண்ணன் சதாசிவம்
