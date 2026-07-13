Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1223B0AD1;
	Mon, 13 Jul 2026 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947323; cv=none; b=Isfbrxi70/kOOPaoE8BTlOr13oWkeBU6vSx2Ap69wF+OQDdU+IYFjOTPVzJV9FLD4RkU3pmyMH2H9fWSE3Na4asHhB5YuHm2n/0lWpWSA/RWFUX9Zm6HPTWexkEOg/wqrpXdNxLc+Iv3NSH17gZ6xdqNMPbBYEnhrJw6LJau0c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947323; c=relaxed/simple;
	bh=cYr1+KwtV4KNwQRSLNKJMkkhT4wWNQ8pYJ9i6VxfJe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6SfDvg9/LLxEPhrbGwWrRkfFHcyKyuBVBtWzHXB1+DIZ1M819vjW7G+eq2OH0T2/ImL6kDiPTxtGrwoIwvzh1Xrw+XDz03B6TuwhS63goGi7sTdWo4/UYxDIMljSAT/dB6fNv4v5DXWoDYIvLlBsX8CQioLEoRC8lWv3bWXtKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tG6QDpcl; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tG6QDpcl"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gzMq71qr2zlfpM9;
	Mon, 13 Jul 2026 12:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783947309; x=1786539310; bh=cYr1+KwtV4KNwQRSLNKJMkkh
	T4wWNQ8pYJ9i6VxfJe4=; b=tG6QDpclc3jtoZyK/dILhZSrzED1bWpWYfbRrWV+
	SHPJUg4uH6IsiLreSCdMQnQqpsH6QCCksAH6UbvQACjrZZKGJbzWIENuCTsq0Pc9
	HVOxy3Gj1YRkePYcONgh9f7tSikksrveWfyhFmGlvZ9MRJjzjl7ILbe7sKUOiYup
	KH5IvjpPLYqZlpGdrr8aHje3QpQsDPPpjWmK26qbGjp42o6v1lAXCAS3yVs9hd3v
	nAj19JXgynCKFU/dCRztLf7Ayl/7F/zlrHtyPQoFg5EO2TNzoNmHsMx9JSKKU0G5
	lTKHExn9mlujYlDa2QyON8SjoZ7ZzgYI1otHWG9E9dQhEg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yNl0xkdai_q6; Mon, 13 Jul 2026 12:55:09 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gzMpw0yXCzlfl7l;
	Mon, 13 Jul 2026 12:55:03 +0000 (UTC)
Message-ID: <a0d5f2bc-c343-43c5-93c9-a7b58be13242@acm.org>
Date: Mon, 13 Jul 2026 05:55:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Add support for the aggregated read query
 opcode
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
References: <6d087f28-5795-4929-b5d3-3f78d9b9bc60@acm.org>
 <20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450@epcms2p6>
 <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p4>
 <20260713025227epcms2p41de509bb713eb7a6be2c945073be6b3a@epcms2p4>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260713025227epcms2p41de509bb713eb7a6be2c945073be6b3a@epcms2p4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/26 7:52 PM, Hyeoncheol Jeong wrote:
> Would it be okay to keep utp_transfer_cmd_desc as is and give
> just the reserved tag a dedicated 4 KiB response descriptor?
> Regular tags and normal I/O would stay unchanged.

That sounds better to me but how to implement the above proposal
without slowing down the hot path?

Thanks,

Bart.
