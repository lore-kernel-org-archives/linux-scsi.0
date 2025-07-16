Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A845B2E36EE
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752679623; cv=none; b=N6BjlACyW4/92TZ9q+ObzIwgALBGaZAw1npwOZzmcyw69HmbfxcJz+aa7ZUtFuQJ787Xce15+IB9ELiySNhzusgudiZGHKs1jzcHbYpxvp+LqV3GM6qc0Fy57QmhCdE7iec+mMoxeRi8fR+HhaeN2d/bANorsJu/EG5gFhETtAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752679623; c=relaxed/simple;
	bh=7AZzHTlZDl92eKhQYBPcd4wCGmchl0p0P4LmuvUZhfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BL5umLbo4Bl4pb7x71pT51trZGYhJORnqcnswkE0EoGZPjyUe5vGkwQhxld1mJZWZnK1bhxFyTU7BiDtOt1m+PONQQcQKFbngOamfxK7TAR4HvpArhffbwhOWQydXS8GEGSugJZUwVRy42NrA8QM7vwZT6x2coZb4EQLYezGp7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TcTmTiR7; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TcTmTiR7"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bj0KJ4DKGzm174B;
	Wed, 16 Jul 2025 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752679617; x=1755271618; bh=3iQt/zB03J2a7Go2W2ieiuX/
	6pPinyjnvVUDponP+uI=; b=TcTmTiR7FoDphKmR+qsR/BK/eXyX85qLnFVp2W/o
	NJsYZR+mS1iqYKaFS6PX8+L+XyKbePcn9ZXYKSIDHJR7VoTVTLkRFyAvRmPYV5K5
	n1N/TKamsven7M7nI33WR1rPkiXLYY0jT5gnIPz8iIHAZjy7+cfQ9HqHr6ZFnD/P
	K18NiDlUEkVe7nzEAY4CrfmxI7yMMgpWoZChCVqT+OxePdNqor+2pO3dtJlBZ59u
	MIkAu9bwv4m76oH/7+T5L5kqKUX4YxzI4pl4jYLetG23E0b6TtiM024nh6gLYg7n
	nYVp4z97aBygRyMo7LvinciG7wlLayiyAljlaWdziDwVng==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N-ctaWuHE1r5; Wed, 16 Jul 2025 15:26:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bj0K040WFzm174g;
	Wed, 16 Jul 2025 15:26:43 +0000 (UTC)
Message-ID: <da89b12d-84e2-445e-9f60-936b41418713@acm.org>
Date: Wed, 16 Jul 2025 08:26:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/10] ufs: host: mediatek: Add memory barrier for
 ref-clk control
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
 <20250716062830.3712487-4-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716062830.3712487-4-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 11:25 PM, peter.wang@mediatek.com wrote:
> +	/*
> +	 * Make sure that ref-clk on/off control register
> +	 * is writed done before read it.
> +	 */
> +	mb();

A memory barrier doesn't guarantee that an MMIO write has been
completed. A memory barrier enforces ordering of MMIO writes but does
not guarantee completion of MMIO writes. What you need is an MMIO read.
See e.g. commit 4bf3855497b6 ("scsi: ufs: core: Perform read back after 
disabling UIC_COMMAND_COMPL").

Bart.
