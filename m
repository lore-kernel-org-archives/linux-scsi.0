Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982725588B;
	Thu, 30 May 2024 20:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099657; cv=none; b=PXf8xeLY+WevK2HR5WBSL7kHWEQGu0v90u4MpbmjUaYzsqpoYBJS1tRCOid9Qe/XBeCLF6dLcccXFmVwD3tecT7smTBYHyB78Vlb4JVI7xS+Z7wUHam8azJNX8QLK/DT0knA1xuKOJnrQj+RiQxqsBcjVlD5/0seVwOIJN9FbSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099657; c=relaxed/simple;
	bh=+yfFxI5vXGgBtiGU+D99/ljEG0kpvZXmxQcSkudrr9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D/mwqghCTV7nArKSvaUu4KfJYzIkOxtV5o99j5nBElFycvzAmTKqF0aam4nraD2HKHnVNC/+5JRo4g5n3piJUp65zfLAgs+blGfVY2/vRW8RgxCAjneFIPfkSubTWu5N9reblgX/OKPUHLAoXAx59hYZ94PUOGj+Ck7+t9Bc/Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SqjKoZZd; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SqjKoZZd"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vqy352wXTzlgMVW;
	Thu, 30 May 2024 20:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717099644; x=1719691645; bh=+yfFxI5vXGgBtiGU+D99/ljE
	G0kpvZXmxQcSkudrr9s=; b=SqjKoZZdpT4MNXYDyRUM4JuIL15+lNbQrcfJuZsH
	5i+fsrz5hnUl5DlaKW9QovdJ8SbgPABGz/lXk+zTUX3IvVSOZF4hWm47ReZABvHU
	1s1mscyI3oBlHP5Trs1lvEnLVrL3MR78iVb0m7+89cOwsGpuvycL4ADEymuw7yOK
	9MD9bMpEl08HInq9MOQgt8+vi3M9lBRE3UqeLb9J4kdp+Fh7/qcGLKjRlZCsb8Bx
	RHiqCZS/DM7HHcWymvBmLE2Q9l8U7sARF6UgjfX76g9qvw1SryWswVnTVCdSLau+
	ynch4c8cn09wBIf16ogwWgDF+qVJWH9byKOSFXu+7Qieag==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rlAwti_y4elY; Thu, 30 May 2024 20:07:24 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vqy2z2TfbzlgMVV;
	Thu, 30 May 2024 20:07:23 +0000 (UTC)
Message-ID: <53fc8442-e27b-4e05-b93e-7b39b9146cce@acm.org>
Date: Thu, 30 May 2024 13:07:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] sd: cleanup zoned queue limits initialization
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-9-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Consolidate setting zone-related queue limits in sd_zbc_read_zones
> instead of splitting them between sd_zbc_revalidate_zones and
> sd_zbc_read_zones, and move the early_zone_information initialization
> in sd_zbc_read_zones above setting up the queue limits.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

