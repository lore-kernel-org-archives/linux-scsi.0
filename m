Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464DE20E312
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729270988; cv=none; b=uK/+auasNJTVLEbR1SZoS4UtVrdQAYahcxbEYT8Dj/cjRxEgXQxRqNoeS+1Bst802wjOm1WMV0e9JrVMWfX5V+Ebx7fbL2JZpynfwS1yhOQe3lCNW8Ptp3+t8Ut+y8Yqr2vkSYGzNacym4Ou/kU2TwQqn2uJJuQTu/V1+YM/irM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729270988; c=relaxed/simple;
	bh=FhfCRHIqdhCGcaRcCgTeNDU+QgS1EepXkpw93oY/Eh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cz/VyggnQM/cZ8pagQf7wb3/z/hU6tfVVLzQpSGfBoBGZI4C9MY+kGeO/6QX10oAofadnEGu6ow+1LduydbiHN/C3q6EFXjVUvTqlSRDNp7gs/RgYzE1p5mzHtrMoDw2/XhkSnVYO66jq/Rp3Uuwwfmt5ruG2tl55C73KGU1I1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hhMinwvq; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hhMinwvq"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XVWHG510dzlgT1K;
	Fri, 18 Oct 2024 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729270982; x=1731862983; bh=K9EKc+2QTVnFd3/1j+pf80qR
	5TpVKpFGR+7+IqshgGg=; b=hhMinwvqOAIWg3ZNNayzCltSdOZO4is9tuS3jo/g
	pZBuedttw0P47i5AkZVMe5slgu+46wnZrBlla30bj6KaeysgNX9vymQm/2xriCKW
	+F4Od8iCjl1ecb66b/13Luf7LSZ4xJU1JPco6rw8QwwObZzRuvjAwUqZZKu970im
	Iqhka4DayAMOpfjnjit+YlH+FJZrfzZ/Yan7Ls6hdcPiFBoXbLqsv03jZaBf39kh
	BOZlpzzhIQ1LHOa54aGinTZjR+vRiVS/qlxYwpbf0xZJBYgySnP5RSYAp7U5T12c
	mrR/+8NCI7yqYQePh7js6lO3fhlsP1Nf8yaHFVjXrOnXaA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GTKutd2XnvO2; Fri, 18 Oct 2024 17:03:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XVWH65LlCzlgTWG;
	Fri, 18 Oct 2024 17:02:58 +0000 (UTC)
Message-ID: <75cebe46-278a-465b-9051-4e39e8465265@acm.org>
Date: Fri, 18 Oct 2024 10:02:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] scsi: ufs: core: Make DMA mask configuration more
 flexible
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-8-bvanassche@acm.org>
 <DM6PR04MB6575D9849E5A1BA869ACE445FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575D9849E5A1BA869ACE445FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 11:03 PM, Avri Altman wrote:
>> Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
>> ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver accordingly.
>> This patch prepares for adding 36-bit DMA support. No functionality has
>> been changed.
 >
> It looks like this patch belongs to a different series,
> e.g. the one that adds the 36-bit DMA support.

OK, I will separate this patch from this patch series.

>> -       hba->quirks |= UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS |
>> UFSHCD_QUIRK_HIBERN_FASTAUTO;
>> -
> Was it intentional to remove the UFSHCD_QUIRK_HIBERN_FASTAUTO as well?

I will fix this.

Thanks,

Bart.

