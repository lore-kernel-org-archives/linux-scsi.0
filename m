Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF67F34D4C4;
	Mon, 26 Jan 2026 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769451141; cv=none; b=LQdDBAODB+EnLhLzNvun+Ue8VhRCtIi3X5JiERzPiTVm7FtALWEOiBAB6ETlqMzeLIm99CQvgcjNRNOyXkdZWoZZbm3fZEBPs8aC3GQAODEHttsX4yz9+ndBNuCBEeMbsOXdThODMtCTG4BlFA/vb7rqwHMuJujLGg4wY8H0sWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769451141; c=relaxed/simple;
	bh=P9x4rgegu6R7VYAEuCIwSz2aEbcYb7r94Vf4E8FXl9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSUawQBCOgqVvama23ojL3sczgRU8r1Xs6FylqT3ig/Tj3J8p68hZ21PSORjDUpFvso9fBWIfCyGTQOJjGqQRiZrS2QqarxRiyhO7FXAIXgSHxA4nx0WcJa94+aBzl9k4/lVtq1gZSZO8wXLZH0kADA8EorJc387CqLqz/CZg/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5E/Xfw5O; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5E/Xfw5O"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4f0GpW391jz1XLyhK;
	Mon, 26 Jan 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769451136; x=1772043137; bh=CU1Ni5nQy2EgyaZnRU/WLtLj
	P9nJsl9M8yNMwcpohcI=; b=5E/Xfw5OwJXqM8kH4EiOhJlZ9jWbZRqkNmvy74w4
	pNe+oCBY2PfpFW03RAr4iTcCvUrILQ+Fq081Xvhy2gEh/8KxzINBd5ENzPe30TOO
	G0WQFjgjK2mRzFkycyuRI6FHz5WX/A+fldrUlpf7qAWqHnvrLWTTFYYnK9NTpcx2
	lB0ep32zREqtFbrek/HgiBuqaAcZtg44Gt4FytGev3IUSzFOhoRucNje23NlRjom
	xsJHNFym7KXziXyHaEzMK2W3ik+l6z/6mTssp81aLkaLY4IdRv2kSO4M6JsOUwl6
	gLzyRc4d8L864HEHOZUE11yzcPUqR8m5Ia8B69LJRTH7dQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k0s2T7fX-occ; Mon, 26 Jan 2026 18:12:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4f0GpQ2VZLz1XM5kt;
	Mon, 26 Jan 2026 18:12:14 +0000 (UTC)
Message-ID: <29008631-7994-4afc-9f4a-43d6b98862b9@acm.org>
Date: Mon, 26 Jan 2026 10:12:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: core: Flush exception handling work when
 RPM level is zero
To: Thomas Yen <thomasyen@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260126031921.2511736-1-thomasyen@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260126031921.2511736-1-thomasyen@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/25/26 7:19 PM, Thomas Yen wrote:
> Ensure that the exception event handling work (&hba->eeh_work) is
> explicitly flushed during suspend when the runtime power management
> level (rpm_lvl) is set to UFS_PM_LVL_0.
> 
> When the RPM level is zero, the device power mode remains active and the
> link remains in an active state. In this specific configuration, the UFS
> core driver previously bypassed the flushing of exception event
> handling jobs. This created a race condition where the driver could
> attempt to access the host controller to handle an exception after the
> system had already entered a deep power-down state, leading to a system
> crash.
> 
> By explicitly flushing this work before the suspend callback proceeds,
> pending exception handling tasks are guaranteed to complete, preventing
> illegal hardware access during the power-down sequence.
> 
> Signed-off-by: Thomas Yen <thomasyen@google.com>
> ---
>   drivers/ufs/core/ufshcd.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0369043ca010..3a0e6c9ba86a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9997,6 +9997,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   
>   	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
>   			req_link_state == UIC_LINK_ACTIVE_STATE) {
> +		flush_work(&hba->eeh_work);
>   		goto vops_suspend;
>   	}
A "Cc: stable" tag is missing. Since otherwise this patch looks good to
me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
