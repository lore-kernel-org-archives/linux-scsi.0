Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC16B17A309;
	Tue, 18 Feb 2025 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739917134; cv=none; b=OZDhfgyHZ69UW08Mv+ud6MqQKa2z1qy0Wcl0AQozyQzGcpH5e/jhTkiRcLpW232FwCGy7Tu4VZoBAMZ0hwLaMqcHt2E1G3S0K+VZQAE9y/f8F2t5hQIH3wtyz7a1lXDlzg8aD+UiE5/Z2ao+JRSLswswmgH933pIP5hnPJRBAg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739917134; c=relaxed/simple;
	bh=YGHNtWl0iKd2UalgN/Gdz8Ml7D8PD6zdhCBU+g31YMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=njWIy+IVNm30ip2VcBXg9smswOxtFY4Uzn0krFNSGxHvAXaGKYaYAao2KYaO/T0NBchqvI4UcWBt/8qFlbXTnto+IPI25wTIvyo36wdbA6K7frB5l/c8OHrfQ2onblhoA8Nz51UVgu9s6T62gIxcY5TsMaklpUL0sZoRQszpnjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ccc7z2Al; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ccc7z2Al"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4YyDSq3fLLzm0ysx;
	Tue, 18 Feb 2025 22:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739917130; x=1742509131; bh=jqAcIAwdQNa6a+GCEb5I8Q7/
	f4ZDlzUgKoAoa3yktyk=; b=ccc7z2AlyCiFUeTWeX3N1Ug2BLsn/JPu4DQQEXkH
	EZhrGRbZ0dXTr9GvQNL6EG6kYYlBSTVYKvdCpZvg7k05xkug1y3z91GIGs9246jy
	XiY3J8ZQnDT5lgTNoniC9sjjv3dWIT6hhS2HQCW4lI6a1w4itOlaF9JmfbMCQvOS
	cV5d/AD6DwxW1+mgrhhayGSYXa6jTXqd7NhItRj2FbiZgiDOeg1OghUPNvf2EXxM
	wN2nZkbP9ElGG0xqtgElzWzoQSTiWOJzFx9eLfQ57o8NrBloBmtk+83d+5k6La6M
	uwo1pVDSbMwzNyqMiBZH13LtAc8Pe9WOY3xACogM08wmzw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6KDlywE88YYZ; Tue, 18 Feb 2025 22:18:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4YyDSh5RHVzm0ysh;
	Tue, 18 Feb 2025 22:18:43 +0000 (UTC)
Message-ID: <e4094087-f772-466f-b0a5-11528a798ff5@acm.org>
Date: Tue, 18 Feb 2025 14:18:42 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb command
 failed
To: Arthur Simchaev <arthur.simchaev@sandisk.com>, martin.petersen@oracle.com
Cc: avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
 beanhuo@micron.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 3:15 AM, Arthur Simchaev wrote:
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 8d4ad0a3f2cf..a8ed9bc6e4f1 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -194,10 +194,12 @@ static int ufs_bsg_request(struct bsg_job *job)
>   	ufshcd_rpm_put_sync(hba);
>   	kfree(buff);
>   	bsg_reply->result = ret;
> -	job->reply_len = !rpmb ? sizeof(struct ufs_bsg_reply) : sizeof(struct ufs_rpmb_reply);
>   	/* complete the job here only if no error */
> -	if (ret == 0)
> +	if (ret == 0) {
> +		job->reply_len = !rpmb ? sizeof(struct ufs_bsg_reply) :
> +					 sizeof(struct ufs_rpmb_reply);
>   		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
> +	}

Please make this code easier to read by changing !rpmb into rpmb and by
swapping the two sizeof() expressions.

Thanks,

Bart.
