Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E947C1758F;
	Mon,  9 Sep 2024 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725899712; cv=none; b=pG+Dl+cgJHYxALCFKMoqK9dIL9xHDU8F/D87YFl7mabjk9gPFQDY7aBGYxPiVHvpG/B+b5tZSbOh2R1Q1E7zZHaUrkbBWwME8MvHh+tD6n4O+MdN7K01spVFFAPihukiE9GhzkW1f8IJ5dyiPKd9fl4Fd1W+sNmFXcWGWZfNpqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725899712; c=relaxed/simple;
	bh=KvAlKwD2KYYY2ofjcDvd+IC6dysj6vTKwvOybbO5mm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kvqoCBhc9cAvc+jjcVvP8jf/tHsSnmmjGKTfsKkukFxAtEjKDkdtYILp0moxEKN4Dm2csWMN+FH30xg+3WFBdt7bM2zLgWuVpi3CehYLkz/sPZ4OdZCcKtMU+rbB3hm8r49wcasJaCpM1w0jWzq4uy/5Nn+YosnW3teVC29o8rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uG/RojT6; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uG/RojT6"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2XW22bNtz6ClbFf;
	Mon,  9 Sep 2024 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725899699; x=1728491700; bh=rhGz1o6DQnzxBuA3jBt10TbR
	2anRakqtBYrmL8Gd4kc=; b=uG/RojT6jz5IlNwuYFUZmtUatb+JLEYE6yhFRQ37
	xk2kvuPeI0ccPf9bLCpPhYpEwGSOMN/peD20A9f+gSjhQ2FVaY6vOXj7gikS9Q8D
	4dvCmLRafT/602JO2gbtJL5f8T7BaGcbZX6nrzLQaZNx4fJ6Y7fpQ8qjDG3BxRGt
	KFUkogOOHPvqsho1zKArWqz2Cnq5FPRQZ15uZMB3LR0Sy2kDwKdXzX5eZdHySih4
	QkeaAl2nmgGEtoeVaG11QLc9gXc/dpd9kW09zQqHEorf40nVmNy9CU3CjkuUeaxC
	hrO3oyd0X1bWvh2fWnJr3OAW6QAHWl0+buUWn8ZUuJTmwQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iHK1D7E3_mxJ; Mon,  9 Sep 2024 16:34:59 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2XVk0qcwz6ClbFZ;
	Mon,  9 Sep 2024 16:34:53 +0000 (UTC)
Message-ID: <c4d22b9c-2554-4871-94dc-3dae4bd62a5a@acm.org>
Date: Mon, 9 Sep 2024 09:34:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ufs: core: requeue aborted request
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com, stable@vger.kernel.org
References: <20240909082100.24019-1-peter.wang@mediatek.com>
 <20240909082100.24019-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240909082100.24019-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 1:21 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 3903947dbed1..1f57ebf24a39 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -642,6 +642,7 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
>   		match = le64_to_cpu(utrd->command_desc_base_addr) & CQE_UCD_BA;
>   		if (addr == match) {
>   			ufshcd_mcq_nullify_sqe(utrd);
> +			lrbp->abort_initiated_by_err = true;
>   			ret = true;
>   			goto out;
>   		}

As mentioned before, I think that this change is wrong. Setting
lrbp->abort_initiated_by_err affects the value of scsi_cmnd::result.
This member variable is ignored for aborted commands. Although the
above change does not affect the SCSI error handler, I think it should
be left out because it will confuse anyone who reads the UFS driver code
and who has not followed this discussion.

> @@ -7561,6 +7552,16 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>   		goto out;
>   	}
>   
> +	/*
> +	 * When the host software receives a "FUNCTION COMPLETE", set flag
> +	 * to requeue command after receive response with OCS_ABORTED
> +	 * SDB mode: UTRLCLR Task Management response which means a Transfer
> +	 *           Request was aborted.
> +	 * MCQ mode: Host will post to CQ with OCS_ABORTED after SQ cleanup
> +	 */
> +	if (!err)
> +		lrbp->abort_initiated_by_err = true;

Please add a comment that explains that the purpose of this code is to 
requeue commands aborted by ufshcd_abort_all().

> + * @abort_initiated_by_err: abort initiated by error

The member variable name and also the explanation of this member
variable are incomprehensible to me.

Thanks,

Bart.
