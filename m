Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D842FF153;
	Thu,  5 Mar 2026 12:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713625; cv=none; b=TCslTQcHm13YKN+Xm4PD0Yps3FYn0xuRMOj7WDOZWQCAU5mQpf0hxxKr900JGb7VfFJ306kMikkwcwg3DSkYLKnEcdmHh4Jki2nLejGgTn9UOik/5HH5ZTynhpil8ENbWJ1qBSQiqqWuFGkhHJWGJhWUd9ZpUepoRdNM/9zx9HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713625; c=relaxed/simple;
	bh=hXmN7HgSxZ/kmiIgN//2phVX7jGYNVc/e5KBfT5aTCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPvVY+N7cMdskzqGPqT6kZ4Tn/GBNFJmV5N2U/tphyuYsdKw2JCtO0wyDySgyx6SXagvbAEaRFI8UBBvdlOtXknDSInDjGYVc+GoEDuUBSKVsevkGT4IXwGThupU4R4h7oPweYGKwtTJ6y8DtuwXaWmqqPgq3gdHvyIgGrgg6aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jIPot4CZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jIPot4CZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fRTJ13csxzlh1TV;
	Thu,  5 Mar 2026 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772713484; x=1775305485; bh=pj8ytW+WIlrzqFuOz36nNq1f
	9KM73Fu6DAdysk2Ty+o=; b=jIPot4CZMnSmOFfj7+NiCBZ5t6W7wbVreUwe3BJ8
	8Q69lA9CGo0xObh3WZm5ThdBtp7j9NfJSmaXwe8BSEa9d09R3jRKiBaqKqpnoaGJ
	2LNdgt598gX/9eZuF6rdEDx/vZ6QKymFpxsVDor4fL4A/o1V7kshWwPY2m3/zSd8
	pGlazVJ8TlRaE4TZc98LBJ0Q8Vi+O2rV1eZiK1zN/Ow1OJFJdpq9NLf0ZNbiyc5u
	dEgI+1dbPDERSbrikOAlvZgkftyQwx/b4JCgft0T8eR2fDZ5hw9qCtlu50sXblCS
	e1saFznxZT6aoaB0NZvt4OmNigI7D+UrUaqZ1w+y8wWMsQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Se8PrpAbekFN; Thu,  5 Mar 2026 12:24:44 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fRTHr5yzNzlgqsK;
	Thu,  5 Mar 2026 12:24:40 +0000 (UTC)
Message-ID: <fd1fb573-6d02-433e-a74a-1a015c64e3be@acm.org>
Date: Thu, 5 Mar 2026 06:24:38 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ufs: core: Add quriks for VCC ramp-up delay
To: ed.tsai@mediatek.com, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20260305083610.2672344-1-ed.tsai@mediatek.com>
 <20260305083610.2672344-2-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305083610.2672344-2-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/26 2:29 AM, ed.tsai@mediatek.com wrote:
> +	/*
> +	 * On platforms with a slow VCC ramp-up, a delay is needed after
> +	 * turning on VCC to ensure the voltage is stable before the
> +	 * reference clock is enabled.
> +	 */
> +	if (hba->quirks & UFSHCD_QUIRK_VCC_ON_DELAY && !ret && vcc_on &&
> +	    hba->vreg_info.vcc && !hba->vreg_info.vcc->always_on)
> +		usleep_range(1000, 1100);

Since the value of the delay is platform-dependent, has it been
considered to introduce a new vendor operation (vop)?

Thanks,

Bart.
