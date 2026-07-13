Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043893537F7
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783963633; cv=none; b=UHNgmA0EqrN8PhevgEMro/h3FOe4V2Type/d7T2Xo9hD5y6+loSp3ZFdBfy9eqEk5ta1gNWMAQpgfUfRi1Rzsaf0jSmNaKAojUsGoi89tiJf13g+VvKfPFUh5U+WT6SpUDojvoCh2b0ASQzz0zKAEWczL5ftK/IreMCymamWnb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783963633; c=relaxed/simple;
	bh=qXr3esOiGouSblxay/VM+vjsfO/JEhG1cUi6SCkc8QM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=daXUqPO2niyOjeH3atbCFSWNTQIHM6qSVvNDqh592mQdNIxbJ117lh9dAM1GueebqTSCZ//u0im5iFTPf0VHNNUML34FcrCPNuvKky6Ga0E3239/cK+ftk7iZ1JvLHlVVhtjS8Y9Q71kVXoeiCeNrUpzAdR5neVdbtx1lS7Mi1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v2+y2nZB; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v2+y2nZB"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gzTrj3n4jz1XM6J6;
	Mon, 13 Jul 2026 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783963618; x=1786555619; bh=qXr3esOiGouSblxay/VM+vjs
	fO/JEhG1cUi6SCkc8QM=; b=v2+y2nZBsFWN/Ydl6yxWF6KCxZquwdmj2x/5kdA0
	lOnUSDpBlfnFtUbbrMFVaSoJbQGLQmxDXPHPFtcyplPxUT0JXUFT13pjj9+CDC/I
	eKo7HVxyj/aL9fy+z2I27IODUAI0+YVBXqvuxI4jFTM0+d+ssorDmAUG3VUdV7EB
	h2wC/j5Y7octcScPlRW1DDGFIYrjVMKQ6gbXHrZrdgss79ONGpWgVY+h8eVAgGeE
	kTrT4Ajf7rdWmG33S9u5heZ6qf3vtDaWOvANinT3+q/ZEBqbMcc/Ml1X/naBt+qA
	wlnRYCq05OfUtawRv8F0d5Lc2Chk7GF4+4cK9RL/6OPEXQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N9_JBl7vuATG; Mon, 13 Jul 2026 17:26:58 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gzTrc4DHtz1XM5kW;
	Mon, 13 Jul 2026 17:26:56 +0000 (UTC)
Message-ID: <60f358dd-82b7-486d-baba-a51c3fa5e9d5@acm.org>
Date: Mon, 13 Jul 2026 10:26:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1JGQ10gU2lnbmlmaWNhbnQgUmFuZG9tIEkvTyBQ?=
 =?UTF-8?Q?erformance_Regression_in_Linux_Kernel_6=2E18_=28Up_to_27=2E7=25?=
 =?UTF-8?Q?=29_Likely_Caused_by_Commit_3c7ac40d7322?=
To: =?UTF-8?B?5a2Z6a2BIChLdWkgU3VuKQ==?= <kui.sun@unisoc.com>,
 Neil Armstrong <neil.armstrong@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "andre.draszik@linaro.org" <andre.draszik@linaro.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 =?UTF-8?B?5ZSQ5pyI5p6XIChZdWVsaW4gVGFuZyk=?= <yuelin.tang@unisoc.com>,
 =?UTF-8?B?6ZmI5paH6LaFIChXZW5jaGFvIENoZW4p?= <Wenchao.Chen@unisoc.com>
References: <12a8417dc8644a71b9cb25c53c93805a@zeshmbx08.spreadtrum.com>
 <d426b4d5-cdf5-4090-8e94-62e652f712dc@acm.org>
 <7863f3e51a8e4d52acdd24a6aea9cf5f@zeshmbx08.spreadtrum.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7863f3e51a8e4d52acdd24a6aea9cf5f@zeshmbx08.spreadtrum.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/11/26 4:21 AM, =E5=AD=99=E9=AD=81 (Kui Sun) wrote:
> We have already included these two fixes, which are related to
> stability. The issue we're encountering is performance-related.
Does this patch series fix the performance regression? Please note that=20
patch 4/4 of this series is not yet present in the upstream kernel:
[f2fs-dev] [PATCH 0/4] Reduce the time spent in interrupt context
(https://sourceforge.net/p/linux-f2fs/mailman/linux-f2fs-devel/thread/4b3=
37c7f-2fbd-47b6-9c8c-587e7b5513f1%40kernel.org/#msg59345049).

Thanks,

Bart.
