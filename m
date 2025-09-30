Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011EB23C8AA;
	Tue, 30 Sep 2025 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759252749; cv=none; b=BkRGh2E5qXR3KjadIDxkotYpql1yBb2lpx8gnKVULS4g2NvS1ZyRO+vpejpfjJ7PyITtbHc9+1T3EA6ez70Zt7Q+vKdnf/hJrNI1cRltMT2fTuJd6I12UYTHC1ikE6rQYXSPbJQ/KJMh8eWOLrUtcQJVJyw91LXDpEHXctt+oKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759252749; c=relaxed/simple;
	bh=HEaqO3wiY94loFX04+0yTbW309zKn4cJ26tOIuIA0Nw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hevFdlgglEH7IRgMD7gltqJcOhyT3chCfAnJ7QR7WdMwtfF7uxJt4kR/7/twZLZGVfEOuRGJX03Odl6S7Bres1Feewv0zkLZ4zo9iCa4bLK1Ll7meZocC7id3ewMlTrc23tiaThUjrvDszbCEo9w0tNiMelr/zwNyyxFUo1p9ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SYujEwYY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SYujEwYY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cblCS2QRdzm0ysd;
	Tue, 30 Sep 2025 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759252738; x=1761844739; bh=HEaqO3wiY94loFX04+0yTbW3
	09zKn4cJ26tOIuIA0Nw=; b=SYujEwYY/EiZ6sh3ygsdKPOWAChilJ705VLNRqqi
	N625fFoWNgC2skFkLq3fK9To+CByT5qwSGXIx70WR0gtdrdQ31LODvw1Dg+wJ5XZ
	6YDxmY7UQknBGHZPMMzVLbygQCo+3O8M+wX4O2SuEcU4P1Mn3Xd6nD2mEp5OTTxz
	Ln4yNBUiSWFMT+2TgR/uRycBLgAxHJE9BmGCYLeNlAl6y/+R+cXrjhkO7HgA6Xyj
	b/gzpX6WlcHq0mjSCMWWotC8bflJDz2dPJUpko7dfDerFZtQoWSPV2pN+ou7a4jR
	7N7G+OI3Ff7wVZ6WF8zhpzZzx3Gbo/gRYimXtwRMFEosBQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pLW2vgBOt-6P; Tue, 30 Sep 2025 17:18:58 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cblCK4zYkzm0yT6;
	Tue, 30 Sep 2025 17:18:52 +0000 (UTC)
Message-ID: <026aceb8-41c4-4495-9990-25f62ed0f192@acm.org>
Date: Tue, 30 Sep 2025 10:18:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: sysfs: Make HID attributes visible
To: Daniel Lee <chullee@google.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, tanghuan@vivo.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250930010939.3520325-1-chullee@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250930010939.3520325-1-chullee@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/25 6:09 PM, Daniel Lee wrote:
> Call sysfs_update_group() after reading the device descriptor
> to ensure the HID sysfs attributes are visible when the feature
> is supported.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
