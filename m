Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3001DA62E
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 20:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784924152; cv=none; b=Q9fe4DmG1pLbuaJd6s5x6HT9GjzdBPrjoUOHHuIU0Q3mbbfQBy53z+SJ5A/po/+faYpN0nyTLO1RtWGMxSqwTR4M/LRpVYvTyo6896u8exyMWs+0oPQxdd/RVLB1hp4Xh+9s4PNkoNEDbAv6W2gpsZilneQJr91Ah3cwJGUmnGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784924152; c=relaxed/simple;
	bh=kKHuHJXhj6htLAxyHt4jlvisrHJxA2Ixg1rE1ca/iHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qkYlwPPITPvkT02WwKt5eylKd+YuyM9upHv/OZaN6hWU8TBi6K9LT1mzjECgsvVXEVy0/cHamsc29XQD9050Ix4m+g5N3S7eVChByXAEq6r2K5lkpSOLlHbDIHqxP7wxA8INKPbrmTr1gas53ikxh3T6OuUQtouy38k/JQS3kek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JW1BOx88; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JW1BOx88"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h6K4D5J4Qz1XM4Tn;
	Fri, 24 Jul 2026 20:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784924138; x=1787516139; bh=6ihtli0dB4IFTanZA8ZCsng8
	fXisU1fFhJaDQxyoAng=; b=JW1BOx88e3Zl2qvS0KRkupzPLBOxz14+Mek3JCHK
	hk8zP60ZIHQUP6+Is0X2o71lqc7qnFza61DKiJ2DD5GFhZwp5xtuMmHQpgH+iton
	SrZr/dy25hdNZkiWlbih89SFvHBYCmXkBrIaRqb7137hEnzjJqBUp/Q2gaofKy1m
	8BPdeWL2spfWPyLGpMUG94WmDSDiL2FbNcNxy27F/iKHY3B45A1fBN47DLa0fNau
	KcpH4XQOu8M+Ch3eaAYK7qjaLAwQ2gwPF0Aj03mScJZSKPHKFcITmTI0PwWX0Hss
	0+WZSiYXKyCmkFkw+9Ar9sm413xqL4K8XaKAVGgic9M7nw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CiUs2TW1z14V; Fri, 24 Jul 2026 20:15:38 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h6K4B1350z1XM4Tl;
	Fri, 24 Jul 2026 20:15:37 +0000 (UTC)
Message-ID: <3c4fd73f-61c0-46d7-b36b-da33ab0c97cb@acm.org>
Date: Fri, 24 Jul 2026 13:15:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add support for the aggregated read
 query opcode
To: sashiko-reviews@lists.linux.dev,
 Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Cc: linux-scsi@vger.kernel.org
References: <20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
 <CGME20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
 <20260724031215epcms2p4d3f734cacf21104ef1396e893edd141d@epcms2p4>
 <20260724032754.E5D281F000E9@smtp.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260724032754.E5D281F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 8:27 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider: - [High] The patch introduces a dedicated DMA
> allocation for the device management command descriptor
> (`devman_ucd_base_addr`) and restricts its Physical Region
> Descriptor Table (PRDT) size to only 2 entries
> (`UFSHCD_DEVMAN_SG_ENTRIES`). However, Advanced RPMB requests
> originating from userspace via the block layer's BSG interface are
> mapped into scatter-gather lists without enforcing this 2-entry
> limit. Because userspace can submit highly fragmented I/O vectors
> (or even a contiguous 4KB buffer that spans across three memory
> pages), the block layer can generate an `sg_cnt` greater than 2. The
> driver blindly passes this `sg_cnt` to `ufshcd_sgl_to_prdt()`, which
> iterates over the scatterlist and writes beyond the bounds of the 2-
> entry `prd_table`. This results in a silent out-of-bounds write that
> corrupts adjacent DMA-coherent memory.
I think this comment should be addressed. How about addressing this by 
checking payload->sg_cnt in ufs_bsg.c before calling dma_map()?

Thanks,

Bart.
