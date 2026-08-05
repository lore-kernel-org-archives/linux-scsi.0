Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D813EDE43
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785966464; cv=none; b=c96sVwpbkskTrqmM5QdpzbGSJub6wdqIWyVSLlXFfsl+drlMuCf5Il1llThmVYRO68DlwYxvoyTesxSalKBl45M1UBDiw9FDq+HSF65adNh67iDkHkO4y+zkg588/kPR3tQuqL8imxJ2O5dfNHZkCbf1nZBJrH8mHQMb6l/Itw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785966464; c=relaxed/simple;
	bh=fRitetQA5te/TVG8EU2+t1i2KCXGTq3G51zyH3f0l1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MiOFZGSqSn7569p3X0dDjo4HIKViMoIb6ZRWIbv0eI1p9UuV2R9gTUbqOCUvL5nAjHTVJJgdUgu6a5dQ0aVDnBUZapU0hP/yKh8PCOI3/HUPrQM9S/WYUkcDmgZpReZvnkvmfs3WVeVXVmaTPxkkRitjvJtHfGTDAgjhgYbsnzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aoCjKYPa; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aoCjKYPa"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFkXt31Ldz1XM4TB;
	Wed,  5 Aug 2026 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785966458; x=1788558459; bh=4yw2kr+jghfGXpj2hzJQ/PcH
	Iq3DU/5YqBzwmZTpA/U=; b=aoCjKYPavmyYi+BvuRXbm9SrydeXGDOOxOb4d+jW
	KacqhOSN7Rt+L0rd//81Sv+1YKyNC9Jwhzz8ZdBv2/UQScsZAPbafE5mUs1q2PF0
	cVjaX6yxTykSGIf0cqOEcM1kSdv1sCdkJIur0/3Buf3XgD2lbIPCpld+fxvsuP8Q
	if1n2jdfpTHTxrnZ6redOWLe95ynoxEKO3g40ie+xuukpdStl3f0PChBnqkAKRD5
	/v7ZNDaQefz/P0ASxBU/mqKhItMiOA94q3Jj5gmx+LIaNkqfupi29+ScSekNedbG
	Noe7kN8BYKugVhxuOrDYmbCb/3OfaaQg1VN2+7yhzh90kA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mwX5jurRZmap; Wed,  5 Aug 2026 21:47:38 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFkXm2rCmz1XM30n;
	Wed,  5 Aug 2026 21:47:35 +0000 (UTC)
Message-ID: <559552b3-1336-4fbd-b0cb-6a96ae57b3c3@acm.org>
Date: Wed, 5 Aug 2026 14:47:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: core: Drop Scsi_Host.default_lock
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de, John Garry
 <john.garry@linux.dev>, Arnd Bergmann <arnd@arndb.de>
References: <20260804113436.2373404-1-john.g.garry@oracle.com>
 <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
 <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com>
 <9a4ed570-5b19-44ca-9d22-41ab37d21014@acm.org>
 <18de6750-7668-4855-b24d-515760a31032@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <18de6750-7668-4855-b24d-515760a31032@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/5/26 6:45 AM, John Garry wrote:
> I do have to question why we maintain support on modern kernels for such 
> obsolete HW. The maintenance burden is not zero, as we see here ...

(+Arnd)

Agreed. From
https://lore.kernel.org/all/20241204102904.1863796-15-arnd@kernel.org/:
"ARM: mark RiscPC as deprecated [ ... ] Since there is little hope of
this being maintainable much longer, plan to remove it in early 2025
while it is still expected to mostly work."

Arnd, is removal of Acorn RiscPC still planned? That platform relies on
several SCSI drivers. API changes for the SCSI core, although rare,
would be easier if we wouldn't have to support the Acorn RiscPC anymore.

Thanks,

Bart.
