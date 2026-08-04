Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564A82AD37
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 20:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785874108; cv=none; b=mFcsCd2td5ljqnhwPbgVD86c9vmsXF3dK7lhnkOnbdUy21CmuhSfLrMDyIiFH83hwR1Sw2h9q5AOzg2PbgGQ6LhRABe6TXdKxmgP41r1UEutr6BOWOjEdTvHUKVZu1V5WuR2HjhDFtFhIk0wjtGn23GSmgLgDmOE0xE900XzQuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785874108; c=relaxed/simple;
	bh=Aa1amtEE+KqL3lrY29QPwh/a7iRx9wfNzwyxmYHctrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3O+yMYN4hGOd3s0xn/9TsH7X5ku9l6EOZ2SMhaFiwB0zhG8QnO0ZTzhdK8ioVA9HQvwOOajVeieMNDxc66hRNBp3xMuG2hpWhvCxv/yN8kfqio8fMLOsggaBY2+4R7MxH5CRe8P1kqgz9fizi4FrA/TioDCLI0o3tOhfKVEDTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rtsejOFt; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rtsejOFt"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hF4Nn5RzDzlfvpS;
	Tue,  4 Aug 2026 20:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785874102; x=1788466103; bh=kiUk17fMRdpHS6BirPtnUCPI
	Zp4armcOziWsDueXW30=; b=rtsejOFtQNVantEByyCRWyvmYduo5PN37a+62wgE
	+j4sgfN1oBmFl90t1nRwOYJdu+zML33bgGuRzu+PgVl2voDgEpJHZhKpCOVhoaE0
	lpL+mqvBTQig7oJevQeopqapOKWTsOQlJWAfK05b3muiHzmJawd48+e2SiT5iikv
	0CvCpY2Vu1SqTsnfiID8MNgCICHihoX7LxDzkkYQNbb4NmLB3GFpTlHRhR65VR3x
	HLFKzYUZ8PbMqV8pUhH2pIsUkLimgqVsfE+VG0RIn7frDmAtVR6+O044ZogNijxM
	D8FqsJEGMKlpp9uTJvX5ZyWJKm6aVxMV18eBUhHg5KyCAg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OUjW5AtrkAZ2; Tue,  4 Aug 2026 20:08:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hF4Nh41sgzlfvpN;
	Tue,  4 Aug 2026 20:08:20 +0000 (UTC)
Message-ID: <9a4ed570-5b19-44ca-9d22-41ab37d21014@acm.org>
Date: Tue, 4 Aug 2026 13:08:19 -0700
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
Cc: linux-scsi@vger.kernel.org, hch@lst.de, John Garry <john.garry@linux.dev>
References: <20260804113436.2373404-1-john.g.garry@oracle.com>
 <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
 <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 12:42 PM, John Garry wrote:
> Cool, I'll go through this. But how does it handle the arm v3-related 
> drivers, like fas216? At a glance, the script requires gnu- 
> a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07 - but I thought that HW like 
> this requires an even earlier toolchain version.
Correct. I think that gcc-8 or older is required to generate correct
code. But generating correct code is not required to do build testing.
Hence the following hack in my script for 32-bit ARM architectures that
deletes a GCC version check from a Kconfig file:

     if [ "${arch%-*}" = "arm" ]; then
	# gcc-9 and later do not support armv3m. Hence the sed commands below.
	local f
	for f in arch/arm/Kconfig arch/arm/mach-rpc/Kconfig; do
	    if [ -e "$f" ]; then
		sed -i 's/GCC_VERSION < 90100 && //' "$f"
	    fi
	done
	sed -i 's/select CPU_32v3/select CPU_32v4/' arch/arm/mm/Kconfig
     fi

Bart.
