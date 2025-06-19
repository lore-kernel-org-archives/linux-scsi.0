Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4231C11712;
	Thu, 19 Jun 2025 16:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750351146; cv=none; b=CVN3qshGtmizyhKAr+D056Bb/he/LPcFnH06h1uQtm2LcMb49UT6y+ElwzMLpulD/ECiW0ZvaxdiwlejYfmhkCiwyXVowuB5I6UxUCmCROFn0wOUouuwE9NJ6mRUuJYfFqI+sY0tcsBZy4fq7/Zm88wP4P/HBJmqU4bbnlEOHNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750351146; c=relaxed/simple;
	bh=uHFC2Zuf4ATdEfc3EczL2xFWh06gjwF2yI92iK+dBL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KzLt15bOVMveVIc3USakBMr/7MvpgSothqQTf2qgKKFHMfPAX0wQ/fdgnqeD+D3xV+sjqocSZopMcKRxCotSLvd3irQ3Yerqqr13Pek+Pp6PKykO/1bXmerqmz3cwuTvJX4kdDnhvr09OqkEHOIgm1dQYtHiwFSk5Ej1erXtaaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ebu+6Ly8; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ebu+6Ly8"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bNRBv0QBhzm0jvw;
	Thu, 19 Jun 2025 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750351141; x=1752943142; bh=uHFC2Zuf4ATdEfc3EczL2xFW
	h06gjwF2yI92iK+dBL8=; b=Ebu+6Ly8UsL3+CtGuZ17sVHhihxTWEZQG20X1z4P
	Wfxk7bz8DEZbI6Jh6E+0/NWt3wIjnUN2x8QoQdjqb67Welay8XAsWX5zZfCMxuWb
	edSG8jcsVyB7DmbHcw6JXaqCtAtw7mg4nfX+5q/xzXxqUK3MUDjXVkzisEn96GQP
	J1Ro8CO2779M9KMxJFS3yR09TdFudzGVcmUluM+lMMajWT4wRfQS8vnTyxxYhMAv
	vxRCtnhSYnDuE2teWNaqSkfoteezbeC9tcnEoZn9fO8bspXm4DfyoFnSinnCpQxN
	aZuCRx9/uC9tHd18AMvoQaUwn0FTwQJ7Hb+Y2NwhHJw1og==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S7PMG4qRlAVh; Thu, 19 Jun 2025 16:39:01 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bNRBg2hlRzm0ySs;
	Thu, 19 Jun 2025 16:38:50 +0000 (UTC)
Message-ID: <ef0c0a3f-4c8a-4073-b20c-5371c1ebe27e@acm.org>
Date: Thu, 19 Jun 2025 09:38:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 12/12] scsi: ufs: Inform the block layer about write
 ordering
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "avri.altman@wdc.com" <avri.altman@wdc.com>, "hch@lst.de" <hch@lst.de>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "dlemoal@kernel.org" <dlemoal@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-13-bvanassche@acm.org>
 <efda2d4c27346f03acdd2c7b7d98ad57da7fb332.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <efda2d4c27346f03acdd2c7b7d98ad57da7fb332.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/19/25 5:49 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> How can we ensure that there is ordering across different HW queues?
> For example, req0 is sent to hwq0 and req1 is sent to hwq1,
> but req1 might be dispatched first?

Hi Peter,

Please take a look at patch 06/12 from this series. That patch prevents
that the reordering mentioned above can happen. It prevents this by
queuing all zoned writes to the same hwq as long as any zoned writes are
in progress. See also
https://lore.kernel.org/linux-scsi/20250616223312.1607638-7-bvanassche@ac=
m.org/

Bart.
