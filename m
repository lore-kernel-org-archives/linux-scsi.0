Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C40277030;
	Fri, 28 Feb 2025 19:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740770317; cv=none; b=uHtMHqDb8YoV7ad6jSLHH9AFNgcLlDInPp+1UhKJP1cbf1YplQNULbSJe/nlCFMGcE+rWjfVBitZZsSZk8bK+sbyTKKYJZ629bs7W4CXHgtdxabwL389hij0HrqcpS4hSLJWMFVw/96gasMlPt1P59/Kcz17Pq9a5fIvHpJidMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740770317; c=relaxed/simple;
	bh=unEoQMS0JgfkdF4lGIQGEgpeq4vSV1wWAg2gu27vyD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OogNkoeRqsABLZoEhwSKbEHBLefxdp6ukEHp1D/6cERnkXR1t15e66vmYzPwuzc5IlMR7vbh8cw9wTP2n/JZ4OLajELxwBdpO3EnkpxqoXlDcMddXhbHTdBKI1DKYCHkH0SmGfURbTwC8r6Kvii3twjrPQiFS83cjc0/7RysG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dYhmjvIc; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dYhmjvIc"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z4J0B2qdczmP5c7;
	Fri, 28 Feb 2025 19:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740770312; x=1743362313; bh=I3KgZ7v6Ac3qNC5ZXayA/TVd
	4J7v++7VBhLT8uenwA4=; b=dYhmjvIcrnsbOzvnnHlzoURlRaeubcVxk4HL2/8i
	Jp/JunGL0GcZOS8uVtJ22qqHtnw0bDvyAYkU5ZSBgvNLfS4uT3GmbtuJCrPYL2Fz
	0VmgUcqeM7iOgB9aZYTA0FQdLdrmi/BRCXv/HSD1c150QGmfWvw8QJomMYDSsX54
	TJDmriNqjaxFRGjSJ94rV+kFQqIQZ/mdiYFBD3ufAPwHDltBAINvJVjTAbY1lw6B
	YnR361bhhDiaD/JSFWPm3kBXcPzQwFVH1qw4VaJSL8VtaCIOXOthcvUSYt18Yvqw
	QNQGkmBAB7QNcZkPbwl0GAYMmpUc3tZjQRtf+UdFbbJprg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zmz81sBKZJiv; Fri, 28 Feb 2025 19:18:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z4J064hDqzmRY85;
	Fri, 28 Feb 2025 19:18:30 +0000 (UTC)
Message-ID: <bb595629-f975-4417-af28-8f4924a5ca5c@acm.org>
Date: Fri, 28 Feb 2025 11:18:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] scsi: ufs: exynos: Enable PRDT pre-fetching with
 UFSHCD_CAP_CRYPTO
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 krzk@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 willmcvicker@google.com, tudor.ambarus@linaro.org, andre.draszik@linaro.org,
 ebiggers@kernel.org, kernel-team@android.com
References: <20250226220414.343659-1-peter.griffin@linaro.org>
 <20250226220414.343659-5-peter.griffin@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250226220414.343659-5-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 2:04 PM, Peter Griffin wrote:
> -	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_TXPRDT_ENTRY_SIZE);
> +
> +	if (hba->caps & UFSHCD_CAP_CRYPTO)
> +		val |= PRDT_PREFECT_EN;

In a future patch series, please consider renaming PRDT_PREFECT_EN into
PRDT_PREFECTH_EN.

Thanks,

Bart.
