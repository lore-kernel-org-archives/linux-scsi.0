Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F75358D38;
	Fri, 30 Jan 2026 22:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769813724; cv=none; b=pBBtTjAWVz7xDiDA2AjjQiNH+nnWSZC0p2W3esnfwMiLZdhTqUsdw7UAMvGyH/5H6J6GRC537WlnmPgnXx9vlVRfR2wYPSzA3rJLXjZuZuXCnwi6EAaDYiKJiSC3Z0Ozx5bP+7H/FT8fvp30DgUx2QK5HV0tncfq9J55DUCU0kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769813724; c=relaxed/simple;
	bh=nceO9DBK1g1J+m59DLcRZ1DFZIiq90/ev+ZFFvIdauA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4OEh7/+cf90KMC2sqK7iipduxBU7ac3r5AWcIN4J1gVjT8tD6QTE7B6tsRjQMC/eyHanbuJKVtP4uYPLf4C0xmTvb9Eyso3x3cCPMenLMm70Soh6RJVFbjpD8QXEBpshxROZ1HHqDGc1COaGR3Ufy4Qq5HJ4rPC4bHOIi2AFgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lpLAc76L; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lpLAc76L"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4f2rvG5QF0z1XLkw7;
	Fri, 30 Jan 2026 22:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769813720; x=1772405721; bh=Kxe9stvi5NaaW5kLwRrsYdA5
	53TN9yncbBBcYmM4xlU=; b=lpLAc76LGkK6lUBrpiOaRcX3Jm3yOXzEkb6gK+r9
	1FdKi0VcUd8KRfxMQzreTDNpGG2PpEz+iNYuJ9omldu4lpcWr0CzLaZxqCJZekJL
	MvovBbOywAp1txUY2L6TGNyRSmsz05GMpHGVwjgyuHafGqY3N48ESRslgqOBAlg+
	RNzzcGML4u/BDxn3rmfVNUzjYJR935mgT9yL9w49m0iFmlUOvTsJrFX5+0xCHS3A
	sBss9XNBEXplaEfvnWaqe/mcrjG7KOTKdblgV0hJdcKwCYfhleZb2ec8k5i4tX80
	jQ72oiKNbCkQjnRmIuamK4n5CR+EH4UKn8OdSl+rsPwBQQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NNsBJQSfinGW; Fri, 30 Jan 2026 22:55:20 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4f2rvB1RSjz1XM6Jn;
	Fri, 30 Jan 2026 22:55:17 +0000 (UTC)
Message-ID: <29741121-9edd-4833-9346-e4c6c427cd2c@acm.org>
Date: Fri, 30 Jan 2026 14:55:17 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: core: Schedule EH on WLUN resume failure
To: Po-Wen Kao <powenkao@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260123045504.3507948-1-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260123045504.3507948-1-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/26 8:54 PM, Po-Wen Kao wrote:
> From: Brian Kao <powenkao@google.com>
> 
> On WLUN resume failed, core driver leaves wlun dev in error runtime
> PM state without taking further action. To ensure the driver can recover
> from such errors, this patch schedules the error handler to perform
> a full reset when error occurs during WLUN resume.
> 
> Signed-off-by: Brian Kao <powenkao@google.com>
> ---
>   drivers/ufs/core/ufshcd.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 057678f4c50a..ac4db8484ee5 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10236,6 +10236,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	hba->clk_gating.is_suspended = false;
>   	ufshcd_release(hba);
>   	hba->pm_op_in_progress = false;
> +
> +	if (ret) {
> +		/* ufshcd_reset_and_restore() might set host to UFSHCD_STATE_ERROR */
> +		scoped_guard(spinlock_irqsave, hba->host->host_lock)
> +			hba->ufshcd_state = UFSHCD_STATE_RESET;
> +
> +		ufshcd_force_error_recovery(hba);
> +	}
> +
>   	return ret;
>   }
Isn't the hba->ufshcd_state assignment needed for all
ufshcd_force_error_recovery() callers? I'm wondering whether that
assignment should be moved into ufshcd_force_error_recovery().

Thanks,

Bart.
