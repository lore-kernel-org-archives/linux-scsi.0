Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7624D8BF;
	Thu, 30 May 2024 20:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099698; cv=none; b=BNQUiYJpA+Z47hEzKtFlm4maxDa1C2p0DwavPrtcHS72i8BteOuUmBNB85KeCbHChXRCJ+rXTbj6hhmyzzQSExSSODjywXKvnKQzDBtWIp/2j3ShlJfAGx/TiuCClQXVWqkyppQxl+wv9aR5OFv1EeVSTWxE+Q59L7Q9cZgpvYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099698; c=relaxed/simple;
	bh=HAP2WXDhccKrBY2e7nb7eVhKKMZLSAfPEEOn8QVjvBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hjw2nVRVUe+Fe92jO2bdLSX47S1f8zNobZZ3jlIJLUrshGeaUee8eWiDtdspCslO4hy3xWDEbA3Y3SyCpLuPFIX41i4+53/gPN2G00lWe9jwrnkTFH+CmLZDuV3riqvUOEfr5sak57N4X9+3SFMLwS+8kwMZr9WIUJkM14e2opA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=obeHdmp9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="obeHdmp9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vqy411LtgzlgMVW;
	Thu, 30 May 2024 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717099693; x=1719691694; bh=HAP2WXDhccKrBY2e7nb7eVhK
	KMZLSAfPEEOn8QVjvBM=; b=obeHdmp9YsUXuOZQLqScMEmH6Ih7ZfY/4iMCkRPI
	LYigt/zOg1B/psGhSXL1A6Nun9Xb4ACnTmneav70Y/d2lCEMW1iyAULS0JOi7N+M
	4D0Z++5JAW5CvV9F2QsCWiTxD25HQJrjl8jRDIIicgxUnyiQBaH4qocTpaXWsRpQ
	NFHwx9+r/3FZrmIkDJAMiSIYHaIZ4Dz1EiaeUipwbed35LdTnRzrbsLX4Btd/RQ/
	RHjxP9YfAad0XG4VPmEW2MotDp1hU4Cf4txtLNGvfUWjW59v/jqig6nN1/pf0pbD
	Jb5Rn6a1EQX7UKGspz9POkgxHq+rMXXDAO1vlh1wffB6ow==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1HkePWDZ3j6e; Thu, 30 May 2024 20:08:13 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vqy3w21PZzlgMVV;
	Thu, 30 May 2024 20:08:12 +0000 (UTC)
Message-ID: <f4bf4ccd-04fe-4067-a658-270887abb50d@acm.org>
Date: Thu, 30 May 2024 13:08:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/12] block: remove unused queue limits API
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
 <20240529050507.1392041-12-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Remove all APIs that are unused now that sd and sr have been converted
> to the atomic queue limits API.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

