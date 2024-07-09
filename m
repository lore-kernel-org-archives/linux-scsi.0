Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027517B03A
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 17:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720547553; cv=none; b=NkZpeK9iloJ6bVuz04bs3yVHPXfQAZaxRknWNx7L5HSrl4g/5mkBia7+6jhdSe3zq4ul/rsNEW8g4yb6WQE9eTnLfL4KoW8u4dcA9b/5SkRKjkwpoNSun1D7tnYnPHoFoqLgn5aMMsNhDpsvDtr4y5TSZdvejLko/hDcbJvGLMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720547553; c=relaxed/simple;
	bh=OecM9s7a3+L7vtQ5xMBhsSXiYU+245/LraeUdbuh+5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lzhwFn+37iuOnAyAW2xzOyETOtB1MwXJJ9hORFDXB32fgRppW9aXbQn3iu7aB/wxdqgZlf1+gF8ji7Cyh9NHHfUSDfpkIOvje/4InNAX3oSMlLcByk5HViXOuB6SztlzUex8q38cLLmVetfHFTQs/dGF+a+I9m0rfmKMQs0/aG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=b6ZOoTtl; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="b6ZOoTtl"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WJT8n5BsmzllBcr;
	Tue,  9 Jul 2024 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720547544; x=1723139545; bh=OecM9s7a3+L7vtQ5xMBhsSXi
	YU+245/LraeUdbuh+5s=; b=b6ZOoTtl8ogDN8P3C6wj5dSwm/K77sWL4wr/pEkd
	kw9EnbK+oBrnY6HZb5yJgPQ8DLs7WN03IprLE+iDSLAjvg0Hhjz5xClXpyCC0bWM
	pyhlIKTmwdQCvgFpmwej+7JbeExq2z4eaaKqteWtAhsXjSLZaLkOy1ZdtnNALg2f
	vrw3ePLPsu9Ydkw/ARLExK30KXxOUmP3XKJS7ntPiae/g0nsdomqQKSBDklYOBQw
	NtNy+uIqci+Zw+5YXCzvgK+z16fPFw9p/NVMNBIWGJ2s993VEXKhy2AiuzDjEHd2
	J5noC510K4XdpK0qJrL46X+AUWiUWKf2A8g0HF8MZJ00Qg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q-UUedYyEV6N; Tue,  9 Jul 2024 17:52:24 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WJT8l61kBzllCS7;
	Tue,  9 Jul 2024 17:52:23 +0000 (UTC)
Message-ID: <fcf26a23-110b-453a-9742-ce8d20f0e3d4@acm.org>
Date: Tue, 9 Jul 2024 10:52:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/mpt3sas: fix a KASAN report
To: flyingpenghao@gmail.com, martin.petersen@oracle.com,
 sathya.prakash@broadcom.com
Cc: linux-scsi@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
References: <20240709105511.64266-1-flyingpeng@tencent.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240709105511.64266-1-flyingpeng@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 3:55 AM, flyingpenghao@gmail.com wrote:
> Although it appears to be a KASAN report, it is actually a concurrency issue.

Please explain the concurrency issue. Please also explain why the
introduction of WRITE_ONCE() / READ_ONCE() solves the concurrency issue
rather than papering over it. Note: I expect the latter rather than the
former.

Thanks,

Bart.
