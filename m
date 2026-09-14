Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB6D492E22;
	Mon, 14 Sep 2026 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789418085; cv=none; b=syu1HuMTJ1sO8F6PHasRYZSMgP8ljYmTsS6z76TegI7YgACUQFxlKZLAC9f822UOOmQ+rzW6j92Mose7LoVad95KoT6mhphh1MaBsmOOFn67lq60BUx69IFHxPZFn8q5seQm4Gs02cZiGDi41huIRvjPoycDqMKgPvTKoP4MbdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789418085; c=relaxed/simple;
	bh=jEQ8CE7CKU2UnvxHX9+tcJ3HwSmZhySR1mXh0FnP6GU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BidmlnNYMD/RP8IbUgIVnaqFIuaTmdxxbWpkcj+782fjBqki/ocsfcau2IQho58zf3dbBeOEeRaijdxqwu+Efar5tv8hLUrh4/MC9/Kv4gGJV8y39hgy2Ct0Zd45+hFa2pq+ih2arQ1oSBt8j531wj3uAGdyoYxgyo87jqe/P8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Cay9H5rv; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Cay9H5rv"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hkH295w4Mzlfvq2;
	Mon, 14 Sep 2026 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789418077; x=1792010078; bh=jEQ8CE7CKU2UnvxHX9+tcJ3H
	wSmZhySR1mXh0FnP6GU=; b=Cay9H5rvJRLxvk93raGnVXZZgmypbSJjyzBCYEdX
	p0ZGstV7yJECM0z6J4EM0PhJ5kcNJCikB6ZTm9hFReHEfLFkhVLhXg8jMKCR9x3u
	oREhwH5C8fK+IyHzk8rSwdjqZB7LqJ0DPytlAZ1M0H/z7mYXqcwYkuxPpAE75tFf
	onXd1ShyH29GLqNQWzV7fuQAcWg7WDF464jWogbPawcTshMFRAf6UQUzEK/eNzQj
	OQAUV1PZatjiAJrhjGphctxPvhD2ulSsYqrOuHtWsho5EEymQRSLBu7Zo9cn6gKK
	ay9m0lRRFlDcfdLhjZNTttcnTBV/ls4/0cIvwC/KsY0d0w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6lYq-wfZVHpw; Mon, 14 Sep 2026 20:34:37 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:e88:b67e:bf8c:1880] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hkH226SDBzlfvq1;
	Mon, 14 Sep 2026 20:34:34 +0000 (UTC)
Message-ID: <88818f5d-d730-40c8-b935-180df1924bb6@acm.org>
Date: Mon, 14 Sep 2026 13:34:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: core: Keep internal commands dispatchable
 during error handling
To: Stanley Jhu <stanleyjhu@google.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>,
 Brian Kao <powenkao@google.com>, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260912131625.2301486-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260912131625.2301486-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/26 6:16 AM, Stanley Jhu wrote:
> Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
> switched UFS internal commands to allocate requests on
> hba->host->pseudo_sdev->request_queue, which shares the host tagset with
> regular LUNs.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
