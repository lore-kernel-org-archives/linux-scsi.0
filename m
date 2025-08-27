Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A3430CD98;
	Wed, 27 Aug 2025 03:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756264727; cv=none; b=e5pNku363BMJgfIBBSR03+pTtro4G9KeRj2+A2uSQpWNmM0HiJNxPoDn6S4qBaSRY5cIHdSwW+euFdw763CwRQ2Pojbxx/LYoeefvavt4Nxh+A3mSI4JTZo97umENpkMltUJwONwAGC2sYvFRMf/o6mEOFD29z98f1qDbAUzqO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756264727; c=relaxed/simple;
	bh=4hE1oU+4pTsfvlqMOOtDJyxVzsrXq+9cfnki53nuljc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FN5SOCh8Oc4eLyxYgCoQ1Pmi1JQl1tZdQDRDaM07AOloNewKcA1570bLIOPjN28LGncyEl+MrQnbAsTq7zqncpkyzrWr4HrtfIf+NwYkkcSThRJHTwnBpIhb4TUTynQOoAdi3fbGmP7jv7Y28tQV3OcMsJJ+OUfEcKPp5HVxkN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iNvjIy7z; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iNvjIy7z"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cBV9c0ljGzlgqyS;
	Wed, 27 Aug 2025 03:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756264722; x=1758856723; bh=LOEdC127eBsOZiHvCgEzALfT
	+5Y8etm3iu37IW8m95Y=; b=iNvjIy7zqXJgv/8b7uPw4N9+++8iKyMvyCOoqm4C
	767ecvmd/crtU+DEADsGQ5wkZ0fhPDa+oTBwCk/4R1dxmroHCR+9Y3ZluDwe8sIK
	m7OHBJewJLYZmZc44259a6MAaJdlm1zmum/cpWWx24zXS7c9ffX1V7s3DsnN4ZwO
	bBMOV4ydIwQdCuN+MbPefUyUq3KPgOZ3iGiNZ2FqMO4hnHtNdxBuq47okzBN6O00
	bCGRMA/wXv9fv9GUc10Z+OV/2MLD7b6VhO2Wmc3bQ4O6owclJIzj4PaUQFLNci9k
	e45/FcNbfU/VikkmnW6MnOFyPBOomRkRIpIGXAIOX9D7yQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id h2E81GhPXYB6; Wed, 27 Aug 2025 03:18:42 +0000 (UTC)
Received: from [172.20.6.188] (unknown [208.98.210.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cBV9R6XkQzlgn8k;
	Wed, 27 Aug 2025 03:18:35 +0000 (UTC)
Message-ID: <bfdffd81-d844-4984-a8dd-ffad3e906f96@acm.org>
Date: Tue, 26 Aug 2025 20:18:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Yihang Li <liyihang9@h-partners.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, prime.zeng@hisilicon.com
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
 <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
 <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
 <62a58038-75da-4976-aec7-016491437735@acm.org>
 <f996d9cd-7be8-876e-680a-acf842afed5b@h-partners.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f996d9cd-7be8-876e-680a-acf842afed5b@h-partners.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/25 7:11 PM, Yihang Li wrote:
> In the interrupt thread context, the main tasks are handling abnormal I/O
> and calling.task_done()->scsi_done(). I believe these tasks are not
> suitable for execution in the interrupt context.

Most code that can be used in tasklet context is also safe to use in 
interrupt context. Does this patch series complete I/O requests from
tasklet context? Does that mean that it is also possible to complete
I/O requests from interrupt context? Or am I perhaps missing something?

Thanks,

Bart.
