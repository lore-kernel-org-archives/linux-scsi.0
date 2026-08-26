Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F8F3246E8;
	Wed, 26 Aug 2026 15:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758616; cv=none; b=CnkLHiSw/h9WR/sECyl6adGZLJgsDGFtuUxEjuKYAS7jrcJrE7xj9YvmPj51KcZiEKuKYAgOKhqXLpvXjAzDabnE1lzCNVf/mkZQpmb3ybaAw61ur5x2m3AZ1kvnOoAQnwHZKAj6rKBL+JGO/Wkgm9gfZ6kh/L8fvXqh3afOl3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758616; c=relaxed/simple;
	bh=qO/Q/TKE2PtRDxFyIJIz9cbaAMmMc5prP8N+5Jy5yaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CWzopLUdM2shRzpetfulB7bnQPnUCw36VCuey/RjHNb1YUiG3g+fcjp0J5vVvp9wKhW/PwyVmjoc2zzUhFVVHdKu5MWsVYH7OkPqhepdyjEnNtdsHLgNh9cgmiKGgG6yu3u9WJhQcfq7CfXcoIFzAtZ/6YW6d9CPU5C8asUT+jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AXU4M62t; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AXU4M62t"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hVTKJ6mPJz1XM6Jf;
	Wed, 26 Aug 2026 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787758609; x=1790350610; bh=kP/daIapXnuz2z6qvUP5Y5lp
	GTgWQqoWHD66qAXBaiU=; b=AXU4M62tt+M4L9Ek5gxHaOdHRXES6OEDOMdBnixB
	sZNpRLmnUA/0AnMlf2f5U5nL8wJ97KE0BWWQAtTCc0TEO9zwNSodXQ+sN6K1NN+2
	srbEncFpk5Q3YEydZWKV/nKOwBTRkzAnQRveKFnWhC9cB0tdwJVr+wKr1jXu3PW0
	uOy6mLbvR4Pc78GFUxWcEB9KxNXRAzdb99r+L9U35p9bdqqa9gUIx8xKRl7XEWUa
	cKpHIAfTQ8tm9Tcwhf1Wyp6p+60YCmmRWYcRWzTkYnbUOm/QGx4PHvuTVdEPdhQj
	jyzN8z424pWSLKZ5cQqDU1IadVJ+rs8nzrSeB9iNcoC5Uw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cM3_naodxlgN; Wed, 26 Aug 2026 15:36:49 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:f6e3:ef81:c380:703b] (unknown [104.135.182.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hVTKB5RVBz1XM4Tn;
	Wed, 26 Aug 2026 15:36:46 +0000 (UTC)
Message-ID: <378e02d3-bc7f-4c2b-9e48-cb0610e9f421@acm.org>
Date: Wed, 26 Aug 2026 08:36:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers
 into ufshcd-dwc
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
 NXP S32 Linux Team <s32@nxp.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/26 6:40 AM, Larisa Grigore wrote:
> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
> +{
> +	struct ufshcd_dme_attr_val phy_write_attrs[] = {
> +		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> +	};

This array and similar arrays should be declared 'static const'.

Thanks,

Bart.
