Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C3A3D565B
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058724; cv=none; b=gSgiKmnuGPeta+qVuOABHNu21+YsvIdqs45nVkmRYetjpEDTD04z5GwaottfXhec4Y4pUHtJJFxKgZt9BMyIBhanM78J7gDgWfAFfbsTALw/PVmPloQEemu0cw9N0UECMr6t0Mgl9zxAgVRuW/7ym4NAvPfPdaYckxWvPDAZSho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058724; c=relaxed/simple;
	bh=jyYrIAXCY8A3BcUYUJ7sUyAdXleGwRcdiVABgI7kPGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLTqQaPI2Ix7VwUv4lvDEVniuidmnUIZz/N7Rw4GNQUXdU49ZO3faNPqgen2BoUr2SoAQxf4sUHH0iAZOr+muSNFp+ISanuB07jVN86Ltr/ary8UGxNcTLdYpHjISfbJqxwKbAcJIs5/+Bw1SUx1kk86uLhDT4Ub9bweBQzFius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MM6LBoQo; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MM6LBoQo"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fm8cg1ksLz1XM6JQ;
	Wed,  1 Apr 2026 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775058718; x=1777650719; bh=jyYrIAXCY8A3BcUYUJ7sUyAd
	XleGwRcdiVABgI7kPGA=; b=MM6LBoQoeKbePK6AWSTqE562T2qVn0GLp4U8P2NJ
	YsMFQTQToZYp8V/3S2snzcH2tB8i0PAtsaWJsh/EEU1L3F6aQukGr7vMWkLQJ2mp
	zR8zWf+rH6Wdw73XePo8fMfFzkcxDRnut5xZStgX/qsa1S/JJM7Uts2CtyTnLckz
	UEA+w7jbuQt4Kfpv/dCNibocvO0impoPDousSLG0WlcqX7KZ/nW2dqZXKYTGaA/8
	XWq/hxwWS8QaBDLRDYx1OdyUFu1j2tadwDgQZK065P8ObJeCqB0goDWa+6/OZAUq
	66WbXN3L/pe5mMph6LoZZZGetROqfMWLjwKz0cjW5CM9bg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EzH_MSx56YHu; Wed,  1 Apr 2026 15:51:58 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fm8cV6TFcz1XM5kW;
	Wed,  1 Apr 2026 15:51:54 +0000 (UTC)
Message-ID: <ff03f3fe-489f-42b2-8e98-72791da214a7@acm.org>
Date: Wed, 1 Apr 2026 08:51:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <20260330183311.1941942-3-bvanassche@acm.org>
 <b76180520d10f2811c072f0944a0864e779e3868.camel@mediatek.com>
 <a043946b-14e7-43da-8b68-dc47a08c12ff@acm.org>
 <3d2ed2d4027f508c48897c40d11d0cc905568feb.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3d2ed2d4027f508c48897c40d11d0cc905568feb.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/1/26 6:11 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Yes, I got it. But I think you mean that "tail" is read
> before processing, right?

Yes.
