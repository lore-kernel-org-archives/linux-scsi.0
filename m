Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBEE2A1C7
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759508151; cv=none; b=XQMM/14ZU/uzlZUmcKEUBU8aiHRctX1ZhTWJ7Bl8AFoHb0LAVfrXKiN80UVNtZAYMensRyZcdDghbIVWJ5a3qlFcHDIeTYmXGAU+wVyq7j5jI3Ap+8O/oz+ZNC71OsxRJ2kXckmSm9Z1hHf4ha8c1PoGJPDTbVdCDV0WSH0o7EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759508151; c=relaxed/simple;
	bh=/F0/yQ80JsAj+74Hi4PFi0/pF1bhXLdqT85Ga83aHoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ha6O4TfEUcGnE98pg5cce6dZ7rODmpmTkDZKOFQ7cAUKr0wdxiv4eftUnpZVAW1c039rXoIkuo1LtLnSACHPYthxYXFFjeoVNH/K6u3g/i283oeZG6kLFNlb2GMb4WaoHQaC3eVv77imOsBGbHk2jpg0iVi0t2FiUwrHkvwLqPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ueEWVnXl; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ueEWVnXl"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cdYg81fD7zlschR;
	Fri,  3 Oct 2025 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759508144; x=1762100145; bh=HQ3d8Ffh/1LgjQ6iaj4lMPyc
	IAt2rbfoQUM0RcZ4GA8=; b=ueEWVnXleyFOJg3eWN4HTF7lirvGSa30gW3VV5v6
	Hw5SMc/Y2OAgJ6em4olx8SeQ0ZnnWUenzURT5CTG01A9yEyHIYVg87Nu2LWQ/URz
	0iTOsr0tV7N6hXlcvsCLUkYTyNlhkJx7SfabRxiblXFPCe1K7iMUzyzaqR0FUVr7
	YuOyTYrj815urokiRIlBdOzqk1ao5+i+AHHxb69cS9oaT9pQOWf47zN5D1kcUTcT
	fLgOaDcHMd4UlgPO/pfqPCXGH+6KyvBEw3GFXkgNj313UTWXJCur3Zuqag5uyObx
	fIitvB3iQUyywgwe1LVE7m+iTMKX0RQjg/u4kZtro3TpkQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o9fEHU-0j7zU; Fri,  3 Oct 2025 16:15:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cdYfp47KzzlnfwY;
	Fri,  3 Oct 2025 16:15:29 +0000 (UTC)
Message-ID: <3e673104-d36a-4128-bb5c-a71093eda419@acm.org>
Date: Fri, 3 Oct 2025 09:15:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Fix error handler host_sem issue
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com, dan.carpenter@linaro.org
References: <20251003101115.3642410-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251003101115.3642410-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/25 3:10 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8185a7791923..9b1207dede64 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6670,6 +6670,14 @@ static void ufshcd_err_handler(struct work_struct *work)
>   		 hba->saved_uic_err, hba->force_reset,
>   		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
>   
> +	ufshcd_rpm_get_noresume(hba);
> +	if (hba->pm_op_in_progress) {
> +		ufshcd_link_recovery(hba);
> +		ufshcd_rpm_put(hba);
> +		return;
> +	}
> +	ufshcd_rpm_put(hba);
> +
>   	down(&hba->host_sem);
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	if (ufshcd_err_handling_should_stop(hba)) {
> @@ -6681,14 +6689,6 @@ static void ufshcd_err_handler(struct work_struct *work)
>   	}
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
> -	ufshcd_rpm_get_noresume(hba);
> -	if (hba->pm_op_in_progress) {
> -		ufshcd_link_recovery(hba);
> -		ufshcd_rpm_put(hba);
> -		return;
> -	}
> -	ufshcd_rpm_put(hba);
> -
>   	ufshcd_err_handling_prepare(hba);
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);

The purpose of hba->host_sem is to serialize power management
operations, error handling and sysfs callbacks. Hence, I think that
hba->host_sem should be held around the ufshcd_link_recovery() call
and hence that the code block that is moved by this patch should not
be moved.

Thanks,

Bart.
