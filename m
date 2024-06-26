Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B98E180A7C
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 21:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719438888; cv=none; b=pj9DDCL7hOi6+BTUXGn2Sdxrf8AjdWDYwGfyVBUzqynoXzhCpFB19t7w4xQPrm0WqMfBMF4u1oGERXUWvufrJ9WTcSmfjWBF+Urs2u4UW2BP/9AShVCF32ciOIcrGZW10jvAkLqkR8I0Ze/ler3jlrHvISu/7todnuDgAkkPopg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719438888; c=relaxed/simple;
	bh=7x9svGEV/+fJmxBqhLW1s1wGHZ7R34jG/b0YdBWZJ4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NRwXUE669wI21Ld164EXLEo+IE2vsZFHzzPFNFkQVoW+0GQQstatgZLjszvwyUr20sQ7jubcdULrNjahGW6UJpAsUgC/2xol3zL3cg3c41awg9mE9yih/W1Dcgi9iVgUjMLtXUBCwntXC6C9/UBsnb3IPFJByCxQkJVaNAiIdws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oYpfr3TZ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oYpfr3TZ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W8b8H64XNz6Cnk9W;
	Wed, 26 Jun 2024 21:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719438876; x=1722030877; bh=/qGCeRm42cC1+PCPalKdoJC7
	cGQ77xKvlvoYAua0cqo=; b=oYpfr3TZeKtbrk9JSIwQRNv5+H5qTRD3AelxiJpv
	Jne3mnv2P+bX8SsC8SG8SyalqDQB0u1hrb+FyxWUUsfVUfaU7PAVJWKUrGkC/Dzh
	RWE+/oBQtepdSTt6hLp5nfQBizkhGgOv3ih2aujxUltxASoPu6AeuMJzsVMNFpEH
	n5OXSs0E6pKKnbS0bPD4ZdnhbeudnuBChc6gxfgJyQ+kCxI5xrRXP6hoKQLu0Zbn
	ohayYnOrlCkX/KrRthPTOMUekIrWK1RAjDQL2UCn9+9Negq+ienb//NCUs0bZFTf
	Li0QeMkEjKXz42eXbB7F0rZy8EvJvyRdDeD942uWZn5TJA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id od1eaqEjwj0z; Wed, 26 Jun 2024 21:54:36 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W8b8C6ZdCz6Cnk9V;
	Wed, 26 Jun 2024 21:54:35 +0000 (UTC)
Message-ID: <edd84a4b-839f-44a6-b7fb-9e875a2598f9@acm.org>
Date: Wed, 26 Jun 2024 14:54:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-9-bvanassche@acm.org>
 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
 <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
 <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
 <167b737c45ff3c9b9422933d45b807929d0b83de.camel@mediatek.com>
 <b302c1ae-2cbb-4906-81f2-285c2b913109@acm.org>
 <5bcf25bb6f0d3338febf350716df8590a41af852.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5bcf25bb6f0d3338febf350716df8590a41af852.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/25/24 8:54 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> And why ufshcd_queuecommand got null pointer? which pointer is null?

I'm not sure. faddr2line reports that the crash happens in the source
code line with the following assignment: "sg_dma_len(sg) =3D sg->length".
That seems weird to me. If the sg pointer would be invalid then an
earlier dereference of the 'sg' pointer should already have triggered a
crash. The entire function is as follows:

int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int=20
nents,
		enum dma_data_direction dir, unsigned long attrs)
{
	int i;
	struct scatterlist *sg;

	for_each_sg(sgl, sg, nents, i) {
		sg->dma_address =3D dma_direct_map_page(dev, sg_page(sg),
				sg->offset, sg->length, dir, attrs);
		if (sg->dma_address =3D=3D DMA_MAPPING_ERROR)
			goto out_unmap;
		sg_dma_len(sg) =3D sg->length;
	}

	return nents;

out_unmap:
	dma_direct_unmap_sg(dev, sgl, i, dir, attrs | DMA_ATTR_SKIP_CPU_SYNC);
	return -EIO;
}

Bart.
