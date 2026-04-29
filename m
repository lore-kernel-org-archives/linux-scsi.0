Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E040244D;
	Wed, 29 Apr 2026 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479812; cv=none; b=cjKyFAC2CnlKc9JepQYn49FM3NsDT/InasXm1nnxz5/SkgkqOEyLfOEuDwW+b7CQeQOPCTJCvcIQLxcMxy4JdYczSZkW4FJjBeeEZdhYtfA197dyw/a1jgte4MSyn3Tp6NMu6wdNAlVPdOsiv47SynYsPxSLg/Q/nD46t8Ez71o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479812; c=relaxed/simple;
	bh=dnqHrmT5VPZkTNRmTphdRksXZWhqrpf0NN0qGUAbhoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDVdypiM6ssNWCk0e5cwjamAW96Kmit+kDurFUt30gYjhLyccgNADKL1N60VS9PpWftXGwiWbbubDMg8+J3A4Is3ofNYt1mrKA+0yr3xjMpwSwrheR2wv4wiYrNDymw7YUhsBjsOlnOgQlISVmAioUg3jkl51J/JeCsZ7gNgh64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eR++XvLA; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eR++XvLA"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g5N014M7fzllNRl;
	Wed, 29 Apr 2026 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777479806; x=1780071807; bh=geGlugbLYLam4hmtd70go/fA
	tU3af8jXDjDtWv4PsKw=; b=eR++XvLASWVBYuqJk/CjXODLQlzzdu/lPYVh5H03
	JGg5hoM/Q2GBx4wBm8IkaIDB/3jYl8u0hBhCa/EGZDoIs3318mEW79i4pEz5xegz
	7OvRYg1G7FaVzVyaaEFcGn+lgeYN+O9BQzwOTpmo5ULGBMMqlLr71p2WbrOphAYI
	VhzSTFZwsruPPLDZFEjunnPqd4LZUQ/p2EdovnfGV/2fvSAFAiqzabwF1QXG+kAs
	OClxu/szgMfZpkKE5lJNbYwXHVV3ojcw97uQnMN9lB3utHri+BJFQQOwVqh6IYlg
	Wzk9ke3WY59Fva4bmoZMqjxjhVYF9yBjjE7KPh5r7qqQRw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vGf7MxrIut9v; Wed, 29 Apr 2026 16:23:26 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g5Mzv5b15zlfl7l;
	Wed, 29 Apr 2026 16:23:23 +0000 (UTC)
Message-ID: <13b1b7e8-4cd1-420a-94a4-e8528d2eb723@acm.org>
Date: Wed, 29 Apr 2026 09:23:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260429112355.4125408-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260429112355.4125408-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/26 4:23 AM, Hongjie Fang wrote:
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 8563b6648976..c1cb30d8aa4a 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -355,7 +355,8 @@ struct ufs_hba_variant_ops {
>   				  bool is_scsi_cmd);
>   	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
>   	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
> -					enum ufs_notify_change_status);
> +					enum ufs_notify_change_status,
> +					int cmd_ret);
>   	int	(*apply_dev_quirks)(struct ufs_hba *hba);
>   	void	(*fixup_dev_quirks)(struct ufs_hba *hba);
>   	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op,

Passing the full 'cmd_ret' value to the hibern8_notify vendor operation 
may make the UFS driver harder to maintain than necessary.
Implementations of this vendor operation may test for specific values of
'cmd_ret'. Hence, when making any change in the code that calls
.hibern8_notify() regarding the return value, all implementations of
.hibern8_notify() would have to be reviewed.

Has it been considered to add a third value in enum 
ufs_notify_change_status, e.g. ROLLBACK_CHANGE? That should be
sufficient for hibern8_notify implementations, isn't it?

Thanks,

Bart.
