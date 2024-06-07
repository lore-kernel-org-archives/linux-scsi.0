Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312E1847;
	Fri,  7 Jun 2024 12:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717763598; cv=none; b=pv2qDZvnxa3Rczi2ysYUlJIUf9Hbq0eAlK8sZ+9fENK4g1moLp9sgx1dVdAnKkweyyLvu/bKh3uurjU4ZCiV1na7ZAKhf1RjFv/toB2S+7cjAqCez0snZMWqpFSXqAyM7Qhy3szlvSWmxfrTmaMvWcz6sNdExRbr12tEVJX7qQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717763598; c=relaxed/simple;
	bh=AR9GXoON3/k2badnWF2BeKHHrn98BVtFh4OO3pVN4/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PtCCB4wvaZ807++/9+hQ+Jzk6I3807njj4GgpMDklMe9XSAjeHZ57X4od7Mq5/KZWerFPsZ5bNvUjU2JduG8WqXjVcpX1gxmS2gXp4fpiuRWQPK07RwoK4ejXNMrn6OOEieQBxQbd8015Ws0b6kPhtuB4lFQJu1iz3CCBP5fQs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tsBm8jaj; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tsBm8jaj"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VwgbH6Yd3zlgMVV;
	Fri,  7 Jun 2024 12:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717763589; x=1720355590; bh=J6oK6LXjhpnidqJtTp/dzjp8
	NhFpbd/C54hDc6t/sNQ=; b=tsBm8jajqKEOJVfn4/sQlYWUtE7PmiAHzZdgat6b
	abuFihYxAZ4BIk0JmZpPspv/M/LAOk11t49HVFNITArlDGgvYAjUfiWby9k3Axsv
	9Bi2vEBIsGubsukmh7oS+4VypS2gD4iljFLnflYB8IT2EtQ9bEsFSJtL/27LarvB
	RClZFSrXTwnZQ5gm36Lbvy/oq05ePJhRF6T6rHtvfPrZHOTWS0Tzx0Q1nuNEwVd4
	eyXU6m6HYMGhI7ClHJCCks3B7CWWuhhJuLIvPxfDj7u0iBJ4vvJ5/ejtuKbWIOFI
	06OsHv60O98llRu4tz1mAogwBM51PehbRmu+Cfjq2I7Jjw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7iwW5zoGjqgu; Fri,  7 Jun 2024 12:33:09 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vwgb50k80zlgMVS;
	Fri,  7 Jun 2024 12:33:04 +0000 (UTC)
Message-ID: <7ba3bbb8-a5c3-4ecd-9c2a-c9586c9d6bf2@acm.org>
Date: Fri, 7 Jun 2024 06:33:03 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 mani@kernel.org, beanhuo@micron.com, avri.altman@wdc.com,
 junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 04:06, Ziqi Chen wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 21429ee..1afa862 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1392,7 +1392,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
>   	 * make sure that there are no outstanding requests when
>   	 * clock scaling is in progress
>   	 */
> -	ufshcd_scsi_block_requests(hba);
> +	blk_mq_quiesce_tagset(&hba->host->tag_set);
>   	mutex_lock(&hba->wb_mutex);
>   	down_write(&hba->clk_scaling_lock);
>   
> @@ -1401,7 +1401,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
>   		ret = -EBUSY;
>   		up_write(&hba->clk_scaling_lock);
>   		mutex_unlock(&hba->wb_mutex);
> -		ufshcd_scsi_unblock_requests(hba);
> +		blk_mq_unquiesce_tagset(&hba->host->tag_set);
>   		goto out;
>   	}
>   
> @@ -1422,7 +1422,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
>   
>   	mutex_unlock(&hba->wb_mutex);
>   
> -	ufshcd_scsi_unblock_requests(hba);
> +	blk_mq_unquiesce_tagset(&hba->host->tag_set);
>   	ufshcd_release(hba);
>   }

Why to replace only those ufshcd_scsi_block_requests() /
ufshcd_scsi_unblock_requests() calls? I don't think that it is ever safe to
use these functions instead of  blk_mq_quiesce_tagset() /
blk_mq_unquiesce_tagset(). Please replace all ufshcd_scsi_block_requests() /
ufshcd_scsi_unblock_requests() calls and remove the
ufshcd_scsi_*block_requests() functions.

Thanks,

Bart.

