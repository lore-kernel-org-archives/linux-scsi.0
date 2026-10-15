Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE2B30BBB1;
	Thu, 15 Oct 2026 01:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792026904; cv=none; b=beuVmK6RJOl1B/IhuvQ3/TBUXJZOvpSMg5W0Ll7uhXN0Mh+eiakGVtOx18lWMYvN7zLOoCOZhVaMKTG4gV8GTkulJtm6V06TLCWL2J2488uFwjlT+baL1DLPnrVAVowziYRnpcNjD9m7aMCz/cQcaO44p9GDKVmZxp7IDgxKg+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792026904; c=relaxed/simple;
	bh=erW7A3MkrwoWwIe8BSGmCS8a/s7Y7Ao/ekOAhWWvirg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=FNVwaFYVCpCMxZdWWSX4Qs6XHdMIvheerBVxooJxO5UZsg96Pv9Jr3Gsid/Ki4AFkvVSso68Y+KdA6wNy7xlZeylI6wIH7d0scM6JwkAzyyboLg0T5KjeYj7XMCujcZvYhwux/5YC3BRgxhJBH1dwfN3g1Tbvry/p7ZmEzN/QXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wqiWnI2k; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wqiWnI2k"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j4qqj4QsxzlfvpK;
	Thu, 15 Oct 2026 01:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:subject:subject:from:from
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792026893; x=1794618894; bh=LCDp0vtEPTe3O3sIXmdMEe15
	vdzr2WupeRMUX/FA6R4=; b=wqiWnI2kVVkW68+j3zvkb5p8g1Fe81taajvqJ9eP
	Wl0hDPZuFs9TJ2bMFHftH8IMADjzz2qK7TWmwxN1jm9Suy88/efRMSudSQAXDMIj
	xW9dVpadfUhECzdOqGPGeVxcDvDdv5+nggKABHUChzB/qIWOrU4ADlWZD7mJOoAz
	zd0T0NiUQf9TDMTqAM+oCMtpvHLpy5Nqm6c8s+Gyfxz9KY67tPoQDOuQJ1Dv+2/7
	qr2/K5qrmXhJiruXVF77KGzBV6kM7Oe1rMFK5tIIK4LSdwQll+2CfzKOgKBjpzO+
	+XmoafRjzmYRVkXXeNDX5bo3F8yi0q7YY9WMTwxy+1hnHQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NM7PU9k0h8Zp; Thu, 15 Oct 2026 01:14:53 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j4qqc6QCqzlfvpH;
	Thu, 15 Oct 2026 01:14:52 +0000 (UTC)
Message-ID: <db212304-4ae4-4b5c-a39f-74c3f0b7d791@acm.org>
Date: Wed, 14 Oct 2026 18:14:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: ufs: docs: Describe how to test with QEMU
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Jeuk Kim <jeuk20.kim@samsung.com>,
 Bean Huo <beanhuo@iokpp.de>, linux-scsi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261012120059.1371653-1-stanleyjhu@google.com>
Content-Language: en-US
In-Reply-To: <20261012120059.1371653-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/12/26 5:00 AM, Stanley Jhu wrote:
> +Enable the following kernel options on top of the architecture
> +defconfig::
> +
> +	CONFIG_SCSI_UFSHCD=y
> +	CONFIG_SCSI_UFSHCD_PCI=y
> +	CONFIG_BLK_DEV_SD=y

CONFIG_BLK_DEV_ZONED has not been mentioned. Does this mean that zoned
storage is not yet supported?

Thanks,

Bart.
