Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0C435DCFE;
	Thu,  5 Feb 2026 16:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770307734; cv=none; b=r7+e+qCTMSdwWLJgS1QmyZ+79+IMYipWH2ncGZAuFN10/CgRdKrCDyR77xah16WUsgehrzeZh/2IXx2rFE5WMWI8mZeuHnttYVEj+g5LymsTiJQbnmZU3RmPoERnFjIudow+TG+FKmpsyfkzvwzAUl8rT5gpinLN6iCl9ADaysY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770307734; c=relaxed/simple;
	bh=aEhSud6cnAJoWtN/RNPNhckS1Iq/m5t0SiX203GbJYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nvJZzPJ/M6VH5mVyEf5zSwI3tlF0zmv1KvYSi1cdJp7O9enWNBpw1wGrey0V9iKPF0Nxxp3z8U5cI/RMN8EampaHHJZExSd7MWBJRttaIYgba94mg9NotNJkufW7Cs/gQOH/0Vh5PowgPIL6v6ygmoJGHvY5/WNgloy/w1bJQk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ev2V2eRx; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ev2V2eRx"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f6MbL726CzlgyGn;
	Thu,  5 Feb 2026 16:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1770307724; x=1772899725; bh=hp6rvc1jxgVoKEqtG3lZoD90
	xZNi00ZtkekQucS8rwU=; b=Ev2V2eRxx2DuJM8FX6o9hYsKZwOGIR0kAJ2koyRX
	aB5D87C6WC5toMdC/s39KNRbCU44TwnUoQ1DaPAwSGaM/B2l8qpXllWMPsyHJTny
	MCwICFcXpZXRD8bYjXpCy5WWd/qaLLuZALzmqFwaLe45HaYVMTPgErpElU+6/QOL
	qpq6xK0QWNfkJiWluruLdVTAmcNsdNHrpinSKZtMbOH0rufz2UGIDHW5SPAs7kjQ
	OaF8OCGF7I7U52h8iHhVSIK7Ol71+B8CU7JMF/PrwXHznkb0WovKcC34F44eEmr/
	MPymDFe4Dwy5FMIOes2jBuLFOnF5Th5Yre0Cd9d5kebfPw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vYFdGREbJkpT; Thu,  5 Feb 2026 16:08:44 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f6MbF3crZzlh1Wl;
	Thu,  5 Feb 2026 16:08:40 +0000 (UTC)
Message-ID: <acc28d2d-3a85-4fba-8c15-fb956c34edf0@acm.org>
Date: Thu, 5 Feb 2026 08:08:40 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix RPMB region size detection for
 UFS 2.2
To: Alexey Charkov <alchark@flipper.net>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260205-ufs-rpmb-v2-1-5e1572ee52bf@flipper.net>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260205-ufs-rpmb-v2-1-5e1572ee52bf@flipper.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/26 12:30 AM, Alexey Charkov wrote:
> @@ -5249,6 +5250,20 @@ static void ufshcd_lu_init(struct ufs_hba *hba, struct scsi_device *sdev)
>   		hba->dev_info.rpmb_region_size[1] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION1_SIZE];
>   		hba->dev_info.rpmb_region_size[2] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION2_SIZE];
>   		hba->dev_info.rpmb_region_size[3] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION3_SIZE];

Executing the above code if (hba->dev_info.wspecversion <= 0x0220) is
risky, isn't it?

> +		if (hba->dev_info.wspecversion <= 0x0220) {
> +			/* These older spec chips have only one RPMB region,
> +			 * sized between 128 kB minimum and 16 MB maximum.
> +			 * No per region size fields are provided, so get it
> +			 * from the logical block count and size fields for
> +			 * compatibility
> +			 */

Please follow the Linux kernel coding style for source code comments.
 From Documentation/process/coding-style.rst:

The preferred style for long (multi-line) comments is:

.. code-block:: c

	/*
	 * This is the preferred style for multi-line
	 * comments in the Linux kernel source code.
	 * Please use it consistently.
	 *
	 * Description:  A column of asterisks on the left side,
	 * with beginning and ending almost-blank lines.
	 */

Thanks,

Bart.
