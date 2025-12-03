Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA0733891D;
	Wed,  3 Dec 2025 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777315; cv=none; b=WHt2C/Ww6k2JId/ZAdjVt3sD9D4bm+RqVPUNmiB8AfNQ1OYWOYdRS9hvZCYgQcOJOxUXul5IqsyyoUQ6l6nZemr8Mdxz4wRggCmOgIeKgalzuYopahzctSMKGfK8RRRR4agPt8EYtSbZvFA3y0qvCf96Lps5j3TDVCkcykFN+jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777315; c=relaxed/simple;
	bh=qr+HD8JTOLMGpC4ZatELM/KMquB3ZZXEJLWyu9fC8VA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BRK5ulq2VqOnWztIUG8N67I2YD3Jk3VpNwtI3Kto8eOqaduSBBb+qKyud3pF0avquTdJ1GK3+RUgSLVqOTZutOugqPBZ2BAPhqzPow8TsXnAQz8aOt4fdS/vV0qvIGkho/XXpy0NOfb+HOqbeYB4Yb9tg0AyNztPnssRAzn4QGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OnAmIpKw; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OnAmIpKw"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dM2KD4nllz1XM6Jk;
	Wed,  3 Dec 2025 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764777311; x=1767369312; bh=qr+HD8JTOLMGpC4ZatELM/KM
	quB3ZZXEJLWyu9fC8VA=; b=OnAmIpKwR6R4G1XlLg0z/hTDq5wnqw5KxovYUI2K
	Yn9mu5SKvUFsRey0LcYiSTXj3AK6lD2cjuxqMQTeHWe43BahhPeWK+JymfZDYIGL
	wjWfRoaCeQu1L0J04w5aF6qXRuMWHJjw5dbB3Z8tR3u89rNm7hvffDv9H9XXE5qX
	t0/dpbVO0VrucMdSpZRWmUP59WFxp0L1f9IQ5Na8CzFJCgCYRy6yMd3Edof9GbQx
	PKe50M2fchJfZJJppkvnFSoCMVapfwLiA9OKnPt8cLuPcBrKt4WvZ5QJ+Xn9j4zn
	yUHLy9v6dQGcwq6su7beoraPqkO3Eq/i2tMC7wkgfHRl5w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ctS-ESrFiAJ2; Wed,  3 Dec 2025 15:55:11 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dM2K858zYz1XM6Jg;
	Wed,  3 Dec 2025 15:55:08 +0000 (UTC)
Message-ID: <88900700-7f37-4c3e-878e-cf5f68f006cc@acm.org>
Date: Wed, 3 Dec 2025 05:55:06 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
To: Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@infradead.org>,
 Po-Wen Kao <powenkao@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20251203073310.2248956-1-powenkao@google.com>
 <aS_pE4nf7wQ031Y8@infradead.org>
 <34848777-b370-4a63-8b08-c3246d214167@suse.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <34848777-b370-4a63-8b08-c3246d214167@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/25 10:42 PM, Hannes Reinecke wrote:
> There had been an intersection with the reserved command stuff, but
> now that Bart has dusted things off there I guess I should give it
> another go.

Does that patch series perhaps involve allocating a reserved command
from inside the SCSI error handler? Won't that break SCSI LLDs that
restrict the queue depth to one? I think that the following SCSI LLDs
only support one command (.can_queue = 1):
* drivers/scsi/fdomain.c
* drivers/scsi/mac53c94.c
* drivers/scsi/ppa.c
* drivers/scsi/imm.c
* drivers/scsi/aha152x.c

Thanks,

Bart.
