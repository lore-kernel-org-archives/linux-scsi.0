Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5B7221D9E;
	Fri, 19 Sep 2025 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758303316; cv=none; b=aFou8ikAV+VrcLr9xdDMJF1V6oFgKL9KzGIBxfm88mtLBoXE+PR4tNnjyY62y9Lqg4zoL7cepTyuvNhohapu8dlCRuDTpQCsRByCIriG25CfCCpmAR5zDlA+rRtxy0J4mE97OIcldyS1TPnbdoFo7UDg/QqSFckt7EaGVA82Rl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758303316; c=relaxed/simple;
	bh=loC9KzaKeHCRPlVSVARAYBeZ7jUr94Onk64kaDgn1yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PBrHhyAVVXmlsxKywgEUYBa9zGDR8z4UBhrZNgMlQs1GbMhhoW9mt3DIFGhlB4xHJpIeR5hAn2vOS/7zMLM6X5O1IBfP1NIHTVa3nRxwQO2RIEEoS5cU8mDyAVyI3y76ZQJzW3KnDgroh8lC/Yh2daE+vhjC4mWYu0QuJZJ/qcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kFNWe1ma; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kFNWe1ma"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cT05F2L1fzlgrtT;
	Fri, 19 Sep 2025 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758303310; x=1760895311; bh=eiq7VVzykfp191mRlVNE0Qy7
	GIGkAdjLq7NaP7tcDaE=; b=kFNWe1maVFphxxWWq8eyNmm/uZJWWZkOp424tsag
	EpUB/cpNb4TUjpU765y+JWn+ANFwIT/Mvk+V6cvWBTLHHO/2/+d0gNWfouHf2ZrR
	ilr4t3pf63M6UpxeHaxxLLScpft22Raeg6Jo2kFkBA+sNmi/8dR+TX8rwxLgxTnY
	sM14oY2quPZprkmJN0o0vSxH/ZARRAJA9DO0MLLrS4/XWPh8+eUQ4+6nho0FzY7C
	y0RHG3h6izeMwurdbxRVQuJCHLTe+vEBAedbzXwZYP90yzVpTh4Ezb+LA6YiVAFG
	GR3H1fEe9deJaImceWApuUjX3keC1yU5SXpaO6FhxO2hLw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2OIJTmyC9Wqr; Fri, 19 Sep 2025 17:35:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cT0500ZwCzlgrtN;
	Fri, 19 Sep 2025 17:34:58 +0000 (UTC)
Message-ID: <d2a66ef0-1f01-4ef2-afa8-8ea6f392c365@acm.org>
Date: Fri, 19 Sep 2025 10:34:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] ufs: core: Add vendor specific ops to handle
 interrupts
To: Ajay Neeli <ajay.neeli@amd.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, pedrom.sousa@synopsys.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, git@amd.com, michal.simek@amd.com,
 srinivas.goud@amd.com, radhey.shyam.pandey@amd.com,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
 <20250919123835.17899-5-ajay.neeli@amd.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250919123835.17899-5-ajay.neeli@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/25 5:38 AM, Ajay Neeli wrote:
> Some vendors will define their own interrupts, current interrupt service
> routine handles only interrupts defined by the JEDEC standard.
> Add provision to handle vendor specific interrupts by defining vendor
> specific vops.

Yikes. Please comply to the standard or contribute to the standard
instead of using reserved interrupt status bits for vendor-specific
purposes.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5442bb8..7a6dde8 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7069,6 +7069,9 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>   	if (intr_status & MCQ_CQ_EVENT_STATUS)
>   		retval |= ufshcd_handle_mcq_cq_events(hba);
>   
> +	if (intr_status & UFSHCD_VENDOR_IS_MASK)
> +		retval |= ufshcd_vops_isr(hba, intr_status);
> +
>   	return retval;
>   }

[ ... ]

> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 612500a..2844772 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -185,6 +185,9 @@ static inline u32 ufshci_version(u32 major, u32 minor)
>   #define CRYPTO_ENGINE_FATAL_ERROR		0x40000
>   #define MCQ_CQ_EVENT_STATUS			0x100000
>   
> +/* Other than above mentioned bits are treated as Vendor specific status bits */
> +#define UFSHCD_VENDOR_IS_MASK			0xFFE8F000

That's a violation of the UFSHCI standard. In the UFSHCI standard bits
31:22 and 15:13 are marked as reserved and hence must not be marked as
"vendor specific". Please either drop this patch or remove the
UFSHCD_VENDOR_IS_MASK definition from this patch and remove the
"if (intr_status & UFSHCD_VENDOR_IS_MASK)" condition from the interrupt
handler.

Bart.
