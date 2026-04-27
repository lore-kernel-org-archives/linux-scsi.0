Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0823D22A4FC;
	Mon, 27 Apr 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305336; cv=none; b=k7lCX/vMGUVUWjUMxYX7zNodkYf4k3dqxOIXJIvYXQFvWbuZ3Y/7dM8sVEzQXO8yMFlnjD0+ltaNPSC1IjMuHVo5KTSkJ/icQu9c9oFFTHjEr2N19GIVnx+kQkCrIlDvroIeCfVOFOkg+CYD6yXjyV288sDuB6+sRLp8B74WtjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305336; c=relaxed/simple;
	bh=bfablBcSvq/pkydEoa5ckLSoZ3t/Do+pQHzQLx6VJWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LdM569emHMVf8uBU1+7lNWNXdxf4YAF2Am2waJ//VFQke6wDltXEBV30oTQ6JithysmlfNbI6TxXc4ahvpO76pB9XAsNhnsjBaJfPs61H040rzeGEgGxQ1GLHKszu5CWfffrp2Ccl9dOmu+ojXJcMeIC331zENcqz+CNOD7vPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AS9ot/w/; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AS9ot/w/"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g47Sk47zbzlfl8H;
	Mon, 27 Apr 2026 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777305324; x=1779897325; bh=N44/hUn/rxHKj0zNAbb1s+J5
	HUDW8JRG1lbLFljrYmY=; b=AS9ot/w/9A9vR1R65POxmh5t9/Aj96s4ZI0AEiD+
	jcCrQU7rczUOWUSNHe9o0Z92MUJtXOvW6XAYI8TRdwA2nH5XXByKhCCgWK/RzEVC
	F57InLaCupU3IavRMmDPIhWuVCD2sr+P4dBKj7Cc0KEwcbDsEt61J7xAgzIC6I3S
	5WwoMJb6Xop8pJzgmTFNGmbGWDV6aJb40z6vT8zNuzo1Jgu4aYsMTj69odB1QHu1
	FwofbHUg3GgRxVWW2XQje7XeKU3hOs/nV0rzlJfMcMiHp0ROh134ZUtd2tA5l44N
	jJWbTsX6uMFo1exml2S6aFVOf3AzbYJatMHFGeYijHUg0g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RxkvdlmE0D7E; Mon, 27 Apr 2026 15:55:24 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g47SN4npKzlfl7s;
	Mon, 27 Apr 2026 15:55:16 +0000 (UTC)
Message-ID: <4190071d-0eb0-4b3a-b2a7-78ea31d4fe37@acm.org>
Date: Mon, 27 Apr 2026 08:55:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: remove ucd_rsp_dma_addr and
 ucd_prdt_dma_addr from ufshcd_lrb
To: ed.tsai@mediatek.com, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 peter.wang@mediatek.com, alice.chao@mediatek.com, naomi.chu@mediatek.com,
 chun-hung.wu@mediatek.com, stable@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260427035856.1610363-1-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260427035856.1610363-1-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/26/26 8:58 PM, ed.tsai@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4805e40ed4d7..02fa61322e77 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -621,7 +621,8 @@ static void ufshcd_print_tr(struct ufs_hba *hba, st=
ruct scsi_cmnd *cmd,
>   	ufshcd_hex_dump("UPIU REQ: ", lrbp->ucd_req_ptr,
>   			sizeof(struct utp_upiu_req));
>   	dev_err(hba->dev, "UPIU[%d] - Response UPIU phys@0x%llx\n", tag,
> -		(u64)lrbp->ucd_rsp_dma_addr);
> +		(u64)(lrbp->ucd_req_dma_addr +
> +		offsetof(struct utp_transfer_cmd_desc, response_upiu)));
>   	ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
>   			sizeof(struct utp_upiu_rsp));
>  =20
> @@ -633,7 +634,8 @@ static void ufshcd_print_tr(struct ufs_hba *hba, st=
ruct scsi_cmnd *cmd,
>   	dev_err(hba->dev,
>   		"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
>   		tag, prdt_length,
> -		(u64)lrbp->ucd_prdt_dma_addr);
> +		(u64)(lrbp->ucd_req_dma_addr +
> +		offsetof(struct utp_transfer_cmd_desc, prd_table)));

I don't think that it is useful to log DMA addresses and I prefer that=20
this information would not be logged at all. Logging this information
might even involve a security risk. Here is some information about this
topic that comes from an LLM:
------------------------------------------------------------------------
Why is logging pointer addresses from kernel code considered a security=20
risk?

Exposing kernel pointer addresses=E2=80=94a practice often referred to as=
=20
pointer leaking=E2=80=94is considered a major security risk because it by=
passes=20
a fundamental defense mechanism called KASLR (Kernel Address Space=20
Layout Randomization).
[ ... ]
2. Facilitating Exploit Chains

A pointer leak is rarely an exploit on its own, but it is almost always=20
the first step in a sophisticated attack.

* Return-Oriented Programming (ROP): To hijack execution flow, an=20
attacker needs "gadgets" (small snippets of existing code). Without=20
knowing the exact addresses of these gadgets, their exploit will simply=20
crash the system (a Denial of Service).

* Targeted Corruption: If an attacker wants to overwrite a specific=20
security structure (like a process's UID to gain root access), they need=20
the pointer to that specific object in kernel memory.
[ ... ]
------------------------------------------------------------------------

Thanks,

Bart.
