Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984D02DE1F0
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 04:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764650802; cv=none; b=DvLv3+vOekceAmCFcRzgtn1igka6njEHc1wueITMHpgqChTvoD4oewUaYqnI6xnj1t5LFc8kb/dIBtuUwwliqA6QNoNubo/RayyNgBZuKaQisIhEb+EYN3b0Pb2kTKSxIfsfcTKmAUqiESeTL2OJ5AQc0jXAT2ctZBckk3aQEpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764650802; c=relaxed/simple;
	bh=dObeCZZAFuiq8nj48yclMVM2QKkvyTq76yxfXR66FqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKjkvGmRbe7ye9Qzj6417Wm+nl+J8MDSNU2Y2K9KXiYPOcKLAKKXB4aSfvFhoCdqnDzIlYw8gGCpTnQSGa+/6EDN7qImF101XsjG0S/vQ7kMwqH1+t3MyTucPuUkE+OcqxcYQgkPvEHac48fD1z4GpTpe9en2/PBa/EWmZdsGEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUlSacZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUlSacZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B93FC4CEF1;
	Tue,  2 Dec 2025 04:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764650802;
	bh=dObeCZZAFuiq8nj48yclMVM2QKkvyTq76yxfXR66FqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gUlSacZN5M/hROoI93GNspZACuJMi18GXLybZrxTcWCV8JQsOoHsm9MXmT5ivgm21
	 WjtQo0eK6CesZss7h1Oz0BuezfnR1+EDgtN9FBJSmnpjOPCXWsln5yaZ2df/FK9HcH
	 HEwzqHmjh/gH9Al1XTG5/q2yFpJi8VR/erkgJpVremIGBxrvjibKsKJJDVGywmPWI5
	 7PwW4wPVS93fG2wThduwwOTba5n8uABSUKamqCvuYntXEd5vs8gWyTEzI66t+ZDJot
	 vBqJO+yseMWt1n7ZkovLvf9yeClBMGdwatWQDAeKwsR1sQOJzKIo79l/5chzH2ojIm
	 FG4CYqgi6GCyg==
Date: Tue, 2 Dec 2025 10:16:29 +0530
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
Message-ID: <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>

+ Nitin

On Mon, Dec 01, 2025 at 03:29:38PM -1000, Bart Van Assche wrote:
> On 11/28/25 6:51 PM, Manivannan Sadhasivam wrote:
> > On Fri, Nov 28, 2025 at 06:31:36PM -0800, Bart Van Assche wrote:
> > > On 11/27/25 8:59 AM, Manivannan Sadhasivam wrote:
> > > > [1] https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@acm.org/
> > > 
> > > This log fragment is only 55 lines long. Please provide the full kernel
> > > log.
> > > 
> > 
> > I just copied the relevant log. But you can find the full log here:
> > https://gist.github.com/Mani-Sadhasivam/770022b53f11340fbaba06d8eaac1843
> > 
> > Unfortunately, there is not much useful information in the log.
> 
> (+Roger since he ran into a similar issue with a similar UFSHCI
> controller)
> 
> Does the untested patch below help if it is applied on top of commit
> 1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
> request")? I'm wondering whether changing hba->reserved_slot from 31 to
> 0 triggers some controller behavior that has not been fully documented.
> 

I checked out 1d0af94ffb5d and applied the diff, but it didn't help:

[    3.878314] scsi host0: ufshcd
[    3.881687] scsi host0: nr_reserved_cmds set but no method to queue
[    3.888310] ufshcd-qcom 1d84000.ufshc: scsi_add_host failed
[    3.895031] ufshcd-qcom 1d84000.ufshc: error -EINVAL: Initialization failed with error -22
[    3.903705] ufshcd-qcom 1d84000.ufshc: error -EINVAL: ufshcd_pltfrm_init() failed
[    3.911572] ufshcd-qcom 1d84000.ufshc: probe with driver ufshcd-qcom failed with error -22

I'm running out of time to debug this issue. I hope Nitin can also look into
this.

- Mani

> Thanks,
> 
> Bart.
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 20eae5d9487b..95f5b08e1cdc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2476,7 +2476,8 @@ static inline int ufshcd_hba_capabilities(struct
> ufs_hba *hba)
>         hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB)
> + 1;
>         hba->nutmrs =
>         ((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) +
> 1;
> -       hba->reserved_slot = 0;
> +       WARN_ON_ONCE(hba->host->nr_reserved_cmds <= 0);
> +       hba->reserved_slot = hba->host->nr_reserved_cmds - 1;
> 
>         hba->nortt = FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT,
> hba->capabilities) + 1;
> 
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index d36df24242a3..46c98910dbfb 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -135,7 +135,7 @@ enum {
>  #define MINOR_VERSION_NUM_MASK         UFS_MASK(0xFFFF, 0)
>  #define MAJOR_VERSION_NUM_MASK         UFS_MASK(0xFFFF, 16)
> 
> -#define UFSHCD_NUM_RESERVED    1
> +#define UFSHCD_NUM_RESERVED    2
>  /*
>   * Controller UFSHCI version
>   * - 2.x and newer use the following scheme:
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
