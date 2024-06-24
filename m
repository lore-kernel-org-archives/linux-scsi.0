Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D913C3DD;
	Mon, 24 Jun 2024 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719246564; cv=none; b=Sq5JlT9xerAHHXkOOwGPrmugHjfK+MJ/WW3+yJGG1rFGywnVhCfu6vKUVJ/DBTq6Qi31kAKQi6BVcLFj07GQGEqKNH0mlLKfFJTZKu3umieQxEtVYQYsWPVzSk25MkteYRP7MUx5OjfWJI79NJ9wHoihlHc5tzEn7ddapxMYgd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719246564; c=relaxed/simple;
	bh=y0XI1/zWy/ZAVLOadjpPIu2VmYpe0M8bW12T4D1J86I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U57OTf0rbpoaOfmuwBuLMv8ZUpjoN99nMft9Jc3Iax/wGqujHA0CcghFssGXom6WhBRUBfJXEDnwwR/glPsCiUKE6FSf6chQgHs820qBu/qthUV6r3Z7HPeLnHc0kXgkMRblLdiwHxq6NR31dxRRSyYqJFkPfnnU9bXf5Rc6hTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GQSNA8rX; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GQSNA8rX"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W7D1t3zL4zll9by;
	Mon, 24 Jun 2024 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719246557; x=1721838558; bh=XzBxWYiHnenCqjx10h/fb7Ug
	T2+m8FdPyZracq6MfuY=; b=GQSNA8rXtyINheNGuFl4l9zKrSYImTDgHttLOADY
	PRVJTWm0V2+XBTcRW2wsFnxqzB2tHkJWRWOFuMpHAplIn/Wie9sK8PIgv+G9YOOd
	kX06mVgHmyoiGmoO8yUymVUILTd54YOFDLjNGt+7kJqnn42RQ5XZCn/wiky1Js2v
	R6zPfpYRhcltpEdfVyB3JIyRyqCBkL+JkKaViTphd3IjwfqWW2vMveR9zVczt4s5
	JO1qkvCueBhkizswEOg3YaMb7E7HnTMfcdt4mJOZCQ2kK0GRuVv9/1k3+ViBcISS
	V2TZvGXvx/uRbhSdA8v0cppxGZgtjcb+ulQ2nNvwSoNzJg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id usmbtpjiE8Fr; Mon, 24 Jun 2024 16:29:17 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W7D1j6PhJzll9Zx;
	Mon, 24 Jun 2024 16:29:13 +0000 (UTC)
Message-ID: <b1173b6f-445c-4d6d-9c78-b0351da2893a@acm.org>
Date: Mon, 24 Jun 2024 09:29:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 mani@kernel.org, beanhuo@micron.com, avri.altman@wdc.com,
 junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
 <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
 <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/24 2:56 AM, Ziqi Chen wrote:
> 1. Why do we need to call blk_mq_quiesce_tagset() into 
> ufshcd_scsi_block_requests() instead directly replace all 
> ufshcd_scsi_block_requests() with blk_mq_quiesce_tagset()?

Because ufshcd_scsi_block_requests() has more callers than the clock
scaling code and because all callers of ufshcd_scsi_block_requests()
should be fixed.

> 2. This patch need to to do long-term stress test, I think many OEMs 
> can't wait as it is a blocker issue for them.
Patch "scsi: ufs: core: Quiesce request queues before checking pending
cmds" is already in Linus' master branch. I will rebase my patch on top
of linux-next.

Best regards,

Bart.
