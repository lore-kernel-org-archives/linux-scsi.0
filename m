Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E595C96
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 16:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221005; cv=none; b=V+N8M1rKAYy2O1TRChhhwEo95os5YVLR+llvUn7keFhSk6YHFO0GXupnydHhqFbOUzgNX3nTbVCvQyOWBFOniOujkCvHy4hAN5yY/SlKe0NWLw++5WKHTQxV+wlLcHV3b4IdJQBnKGpgR1i6f9rmDn2bF3M/EcRXI9alalQ2c2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221005; c=relaxed/simple;
	bh=r5ebSzNPq/AIMMFjWZGDXuMrsAy2j32AWEsn9JnzPsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9BNRcwHTQ4YBozxuiXKTNRGJHJRQ2cClSK9Q4JG9VThM/N0sxT8NNckpJS7L3OoKbYrhElH2aGg5E2eq2S/qz8mfolDVap0wD3Z0GkWEyke22T8o9x3cqtc9wYLDUnqVlJW7cMazdAOsDIJClvWNnGSpyJ/OumOTSC2KXjNAZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g92oUuVs; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g92oUuVs"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XdGcj1VxrzlgMVd;
	Tue, 29 Oct 2024 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730220995; x=1732812996; bh=r5ebSzNPq/AIMMFjWZGDXuMr
	sAy2j32AWEsn9JnzPsU=; b=g92oUuVs2DcmqhCuDpEc2x6u7fp/jf93ERbcu+Z3
	kM9NdoCbZzGZ4/1X+6+x4IHb/cld0g6IrIPd6fsskAEv1b/kdsoaxIlRjKGxk902
	agE+9M+QZUXPLRz9Brmdpx32AzgcLocuMKFTMag2ELEkT8jyV0svsnKiLc/qK7W3
	YGFKWfjITLWFy6rjD5iwdTBHuz+GB5PvSkpiJ7JLvne+DzJ9FyRB56sUKtJJzyEQ
	QB1ncHL5GMjPGIzj/GB9pmRb99VxAGtd57g4uRjqB2UViON2AGKDnarSlXufHOXX
	v6Py83rXvI8eaXZAWFkE6JenGW8DJz4f8b4DOVQNv3wJKQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id V935U6FvE25J; Tue, 29 Oct 2024 16:56:35 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XdGcd1pbmzlgMVY;
	Tue, 29 Oct 2024 16:56:32 +0000 (UTC)
Message-ID: <ab068e04-ddf7-4fd5-ab0a-ecf8bc78ddfd@acm.org>
Date: Tue, 29 Oct 2024 09:56:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
To: Bean Huo <huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>
Cc: beanhuo@micron.com, cang@qti.qualcomm.com, linux-scsi@vger.kernel.org,
 opensource.kernel@vivo.com, richardp@quicinc.com, luhongfei@vivo.com
References: <330e0b7fce03b2970db80c4b73b611af220b6349.camel@gmail.com>
 <20241029120346.591-1-tanghuan@vivo.com>
 <04ebe6420034ca3d791ea3cac10ebd61970a7093.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <04ebe6420034ca3d791ea3cac10ebd61970a7093.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 6:18 AM, Bean Huo wrote:
> I see, easyshare is a case, but we have interface which allows user to
> configure UFS attributes, such as ufs-bsg, you can use this interface
> to achieve this in your application easily, right?

ufs-bsg should not be suggested as an alternative for a sysfs interface
since the bsg interface bypasses a significant amount of logic in the
UFS core driver (clock scaling, clock gating, ...).

Thanks,

Bart.
