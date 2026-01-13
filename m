Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33478314D3A;
	Tue, 13 Jan 2026 16:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768322536; cv=none; b=ctP09x4tx3gGjiRmI0AZks96JP1AnEoc5UMQp2cVe8KUCu9tesWS5NKZcE8FAEmdV4G61I1TEF3K7ihxZKqekAUvr9eRF5nGqi6AH/DmtdAqWQ+9MFqldvVwR5I835RPa/K92nrvRW+g4VqEWxbxittuZkfWfGx0puoHR+TL3KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768322536; c=relaxed/simple;
	bh=Bg7HGqApBU8sYl4hiOSLKTuhjPdNv1bYvFSkRwntxGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJXWnjZLqRcjHyeFII9thC/xtXpqdEpYm1a11IYPwL09z+/u61ITLmtA1Dz+8ZNTqsHnWItMndieMknNHpf7WIoP8twhLkuXBFwYaoHZzdSwDyU8Ub7/ATUoq2BtcY730LyMT7zg9e9kZ6wfS8cogdh2xpUzmemuqTaw3MF6x8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g5WH04nU; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g5WH04nU"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4drFQY4HWwz1XMFjQ;
	Tue, 13 Jan 2026 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768322531; x=1770914532; bh=Bg7HGqApBU8sYl4hiOSLKTuh
	jPdNv1bYvFSkRwntxGw=; b=g5WH04nUUL2SkCcrhkfs1DNad3yRn8M2n4gi20Cg
	gyDtqMvezs4/Lw1ZaL5e30Ie3weEdJaGfZotJArPpcbrf56UtvNZIbxKKYZFpUlF
	MhhQFDoOGGsej+KSEVVYaiqFifWCb/tZQJfPfbetfH92e7fc+qtItvU7bn7eOnTV
	tTOUG5ShviJH6rMq5UQbYfX4JCCVaF2Ng4frOtg0PFCnGrsoO8gvklboCRWxGEy9
	pg51fGglLeoS/ECEYdCJW+MPXEUPR2v3NAvDJ1f2p8qm/3J+nQi3/hzeS++O+HGF
	nxj6reCpThk1MqnIjv4XmQr9pa3xITiJecYadmYkeWgpOw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fnFqmMuCCiSS; Tue, 13 Jan 2026 16:42:11 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4drFQS21H6z1XLyhG;
	Tue, 13 Jan 2026 16:42:07 +0000 (UTC)
Message-ID: <abde89aa-502a-482d-a56e-a0fd4112d5e7@acm.org>
Date: Tue, 13 Jan 2026 08:42:07 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Handle sentinel value for
 dHIDAvailableSize
To: keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "tanghuan@vivo.com" <tanghuan@vivo.com>,
 "zhongqiu.han@oss.qualcomm.com" <zhongqiu.han@oss.qualcomm.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>,
 "chullee@google.com" <chullee@google.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
 <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/25/25 9:28 PM, Keoseong Park wrote:
> JEDEC UFS spec defines 0xFFFFFFFF for dHIDAvailableSize as indicating no
> valid fragmented size information. Returning the raw value can mislead
> userspace. Return -ENODATA instead when the value is unavailable.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
