Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C283519C561;
	Mon,  9 Dec 2024 21:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733781265; cv=none; b=oVyxb2GFr8OrRY0AWBk02xP1wlv9ukO7MI0UvmFFGdRrvPMiUTs0CmaEI4Co6gmHbASYuwrjHPZeDVgtRGgFeeT3fwc5ibVpKJfKrlf7wrk6/KfhtLRLvyu7lw5b50NPbT16FAMgCbMJtv0YgiExR2/NebrSEZV9LdCZqF33JJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733781265; c=relaxed/simple;
	bh=ZrRCLe8p7MbTrHB1VAysrsoSnyPE1tTECkyjO7/dNgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NFXFXreEj1b/QaBKUphuL4Fx/+3wxB9fjnV/OyrSE5T4C/FkcQr70dNy7i6achT1lDsZduicphfUTfIU9ZxgsNIjbwosDH8Cm2Rsv6doW4bN0P0zbY8C33n5MJfc9sZmWuLbUh1k6XyINYhYEzSDt7Rf8IZWdfbMn1/K0M0djXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G4sMGhD4; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G4sMGhD4"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Y6bHK0R8Lzlfflk;
	Mon,  9 Dec 2024 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733781253; x=1736373254; bh=9sgB1Xfr/cwENdJWfeZe9l0S
	l5Itmk2Pe4rUGDVEgjQ=; b=G4sMGhD4hccjRsO/nkbCoH7XNn58eJmQT9UCRHn+
	HEnmMYFsfi5YFuMx73ZV8QQ+tOroqtc+jEKUVrscdC9Mj7glMEktcBdlr2f86CYN
	9ogl1KwZGqXodq6hOiueQpFh1ILyEtQ36C/XGv3SHs/Fg9Wqi5NVdzFNxjU9npZ0
	nVine2cCHSmuHL694l3j0lLBJtprSEBWwTIZJpEgE2ppBwbE2/K/Vf7lCBSWTise
	m7x8iSjKELOF+s1Ui4zmadyjVp/snVDTFpNPYXnL8SzwFSGs8rACyhz9BiQ/Nxv0
	y3LD0x83Qk3qjCQZ44rWdJzxoptLITu0Nz+A0WmDfGICxQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZFoJCw0eQ_Yx; Mon,  9 Dec 2024 21:54:13 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Y6bH31xBbzlfflB;
	Mon,  9 Dec 2024 21:54:06 +0000 (UTC)
Message-ID: <e2693069-2f8f-458b-98c2-f9d43514061b@acm.org>
Date: Mon, 9 Dec 2024 13:54:04 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi:ufs:core: update compl_time_stamp_local_clock
 after complete a cqe
To: liuderong@oppo.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 ahalaney@redhat.com, beanhuo@micron.com, quic_mnaresh@quicinc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1733470182-220841-1-git-send-email-liuderong@oppo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1733470182-220841-1-git-send-email-liuderong@oppo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/5/24 11:29 PM, liuderong@oppo.com wrote:
> From: liuderong <liuderong@oppo.com>
> 
> For now, lrbp->compl_time_stamp_local_clock is set to zero
> after send a sqe, but it is not updated after complete a cqe,
> the printed information in ufshcd_print_tr will always be zero.
> So update lrbp->cmpl_time_stamp_local_clock after complete a cqe.
> 
> Log sample:
> ufshcd-qcom 1d84000.ufshc: UPIU[8] - issue time 8750227249 us
> ufshcd-qcom 1d84000.ufshc: UPIU[8] - complete time 0 us
> 
> Fixes: c30d8d010b5e ("scsi: ufs: core: Prepare for completion in MCQ")
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: liuderong <liuderong@oppo.com>
> ---
> v1 -> v2: add fixes tag
>   drivers/ufs/core/ufshcd.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 6a26853..bd70fe1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5519,6 +5519,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   
>   	lrbp = &hba->lrb[task_tag];
>   	lrbp->compl_time_stamp = ktime_get();
> +	lrbp->compl_time_stamp_local_clock = local_clock();
>   	cmd = lrbp->cmd;
>   	if (cmd) {
>   		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))

Although this patch looks good to me: an infrastructure for gathering
I/O statistics should not occur in the UFS driver. This functionality
should be moved into the block layer core.

Thanks,

Bart.
