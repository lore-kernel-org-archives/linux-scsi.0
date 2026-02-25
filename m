Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CEF2E7635;
	Wed, 25 Feb 2026 18:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772045978; cv=none; b=rQyUZlVWUi2pwW4vJWJkd90+ZClnUb4GG6Gr09QIY4w0YKdg6zQWNTZfPhz5Rm7adzdKQ+uhcSEO+FEtnL6+f/+0od3QcTHx+1RPS7OzXN7ViIfr1zLSPBOJI3/TSEwVByeca2IxZkxnGownv/Mmk6Y3BLpvROFeq388xdzTTew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772045978; c=relaxed/simple;
	bh=yMZeqy/GSqSkA/2A0f/cDaeT/xYJrinzhGCkTDNMdKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I5nN/BfOAgm3mPiFMUQ+pZ+yKoCLrBxGGfy5t6tv3J9HtF+G7hX2nwXT2tOMgLmF0KRT6WDvHHIp3mVfIQwnQ04Rqse2DLtFl8cD8Dx128pymoZxySBvD+9DPRmpfzimtLlKM8klJhF4a2PTlm6bf0tgRsBZ+JOaNEq/RNNrsVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k7IZ17zq; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k7IZ17zq"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fLkRF174xzlgyGm;
	Wed, 25 Feb 2026 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772045974; x=1774637975; bh=9XuNfkNGSadqStoIBeojRlgz
	cTcIUl+2+WYLgDpH+hs=; b=k7IZ17zqw+5KeGdHVluEDKBNitF6NXKL/sgETBH5
	E7JnRhRqAzPlsFWovSkSWdly1N5VO5fElk/oKHaYuNPR64YEW8vg2Mx+J/ZkDUFD
	EoTAqmJM7GuQknwXjvzotiPq2dGbLi/SLgLJlTat+8ShAlIcKVyeK0N6kmrmp6Xs
	RZueiatna/Dk3LMGnbZ6hOGYGy1uNgzkh1XNzrqLhxJWm4hbECR0tGXvHfZI41XY
	/hfbdM0FEI+CeUN/g6GWG+5IFsjbo7O1fv/0XlLfv6dzw6Q3h+iS+IcLknGD958r
	VaCovaGi3ebZC6QF1dhkp5T8lDiAe64JjznGs9S83j8tkQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1Pp3Y7Tw57y9; Wed, 25 Feb 2026 18:59:34 +0000 (UTC)
Received: from [172.20.2.156] (unknown [4.28.11.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fLkR6082PzlgyGh;
	Wed, 25 Feb 2026 18:59:29 +0000 (UTC)
Message-ID: <7782e4fe-ddc5-4ef4-b632-5c137b31ed73@acm.org>
Date: Wed, 25 Feb 2026 10:59:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Add a sysfs entry for
 ufshcd_state
To: Can Guo <can.guo@oss.qualcomm.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Huan Tang <tanghuan@vivo.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Daniel Lee <chullee@google.com>,
 Liu Song <liu.song13@zte.com.cn>,
 Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
 Bean Huo <huobean@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260225022942.345564-1-can.guo@oss.qualcomm.com>
 <20260225022942.345564-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260225022942.345564-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/26 6:29 PM, Can Guo wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/ufshcd_state
> +What:		/sys/bus/platform/devices/*.ufs/ufshcd_state
> +Date:		February 2026
> +Contact:	Can Guo <can.guo@oss.qualcomm.com>
> +Description:
> +		This attribute shows the state of ufshcd.
> +
> +		The attribute is read only.

Please expand "state of ufshcd", e.g. into "state of the UFS host 
controller driver".

> +static const char * const ufshcd_states[] = {
> +	[UFSHCD_STATE_RESET]			= "reset",
> +	[UFSHCD_STATE_OPERATIONAL]		= "operational",
> +	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_scheduled_non_fatal",
> +	[UFSHCD_STATE_EH_SCHEDULED_FATAL]	= "eh_scheduled_fatal",
> +	[UFSHCD_STATE_ERROR]			= "error",
> +};

Please follow the kernel coding style with regard to spaces around "*".

> +static ssize_t ufshcd_state_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "%s\n", ufshcd_states[hba->ufshcd_state]);
> +}

In the above function, please check that hba->ufshcd_state does not 
exceed the bounds of the ufshcd_states[] array and also that
ufshcd_states[hba->ufshcd_state] is not NULL.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c6c7de7a0603..32a508e1582e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7917,6 +7917,8 @@ static void ufshcd_process_probe_result(struct ufs_hba *hba,
>   		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
> +	sysfs_notify(&hba->dev->kobj, NULL, "ufshcd_state");
> +
>   	trace_ufshcd_init(hba, ret,
>   			  ktime_to_us(ktime_sub(ktime_get(), probe_start)),
>   			  hba->curr_dev_pwr_mode, hba->uic_link_state);

Shouldn't there be one sysfs_notify(&hba->dev->kobj, NULL, 
"ufshcd_state") call after every hba->ufshcd_state change?

Thanks,

Bart.
