Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC292D0C63;
	Tue, 28 Jul 2026 21:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785272916; cv=none; b=DDVKSkignMo4Hv5BOhGHCOrhJwB3C4lHNTIPEHcie0be7D+hUoIYyo5ZGZpgm6MAPR0b9sVLY7GtNVpdYsYO6hy5GtwdxaS+R9iGVGyc2VV93OpVQCYOcXfRXnRoyjmYuhU1R3me1cUfMriawS4YWI9T+wz6v+0Oua945TlFn04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785272916; c=relaxed/simple;
	bh=yMRAY3jbf0LeJtaUFF1EM1mJO01/HnesQnwtpScQqQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eGGANauEqcJ/st4n7AsRhgPN7OPhs5SHEUdIo9/5pTHk2YjE6bENUwjqRKD+vk4ZuPcKqY4LCi8U9Pk6XYljSvpVUjIk7XKS7mFMoYAwB7lRytvRSmqvDX+ApA0553Zrv4R5vrPUUZ+XV+GJgFZ0a1uKJBxXRYJyuE0np31q0wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OSW1hWaN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OSW1hWaN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h8p3J0LW1z1XM6JT;
	Tue, 28 Jul 2026 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785272901; x=1787864902; bh=yMRAY3jbf0LeJtaUFF1EM1mJ
	O01/HnesQnwtpScQqQA=; b=OSW1hWaNcetNQW7dXAhl9V2Rzz5x1g8LJbY/Ptx+
	8MAxI2HaKEv/0Rj6Zcbdng0TcL+imdiyBzQJloHmayE7rsgvpeiUK5XUY0RbiT50
	jv6Cr+JEgwFehrfD318sx8kgX1q+vg+ianJcfMjiJ2K0e/mTAIQ1QznR0ciANVo5
	QNyWKBvC2OWTP/4m0vUtIcliJ2Wq1RHUsiCmlOB/gNe1eDd6q7ytyPjwXirhbadi
	NHUSJt68D5KziZF7F7j+SA9awz9YchiNSo992rgohX+9XisItdTEKhoh6APyAg6O
	llU58ZCx67Ge/aPii1P4gRbRqPqUffiU/QErKR3K43bikw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WI8bANWpdM14; Tue, 28 Jul 2026 21:08:21 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h8p3630VHz1XM5kD;
	Tue, 28 Jul 2026 21:08:18 +0000 (UTC)
Message-ID: <4190d16b-b7a6-4171-88dc-adcf36da971d@acm.org>
Date: Tue, 28 Jul 2026 14:08:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] scsi: ufs: Use unsigned types for the BSG query
To: hyenc.jeong@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jinyoung Choi <j-young.choi@samsung.com>,
 Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon Seol
 <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>,
 Yunjae Jo <yunjae00.jo@samsung.com>
References: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
 <CGME20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p5>
 <20260728092434epcms2p56b013ab7a2df90d3df9186322de54340@epcms2p5>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260728092434epcms2p56b013ab7a2df90d3df9186322de54340@epcms2p5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/26 2:24 AM, Hyeoncheol Jeong wrote:
> The UPIU query length field is an unsigned 16-bit value per the UFS
> standard, but ufs_bsg carried it around in signed int. Switch the
> descriptor length and buffer pointer to u16/u8, fold the trivial
> ufs_bsg_get_query_desc_size() helper into its only caller, and replace
> min_t(int, ...) with min(). No functional change intended.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
