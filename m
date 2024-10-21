Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB571F7092;
	Mon, 21 Oct 2024 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729535751; cv=none; b=eTcQt6TAUYObZrvfixnuBvDKYVoTJmQeY3rQ9GKLg7DJ8bO8NLIV94hjlx68cjxoK3B8XYfv+AT3PxnJtWi15OeXRGpG1vzL8BZGrbVkrovYYJPL1s8ffUl/mw4oka56zx64z7uyNSxMuF9G9HfVRsKSrwPGoVA0bM8bwSh5Nd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729535751; c=relaxed/simple;
	bh=fcoHIyU9BrTO1ywot1l5OJbuuqqdunCfWz/jYowpd4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kj4HBld+ufRvsND2AE/OAVb8LmPnIkpTnXtnPHqMt8iQSRjY+Vw6P1vcVZCh/INVmvMlWd99zRrAqEbmdp6KqDVb8jnegLSMV42ykoocs+gTtP7nk0VAA4ectpGnn5sXmcrD+yZfU3OhTOhxvEvGLYgAYAfjOw/SHXLRHl86t4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LG02yGNt; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LG02yGNt"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XXPBs1dgjz6ClY9V;
	Mon, 21 Oct 2024 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729535748; x=1732127749; bh=s7TCnzUvTpenS3OvUHYIdx3d
	5tzL0dzFXbiwthYD1lI=; b=LG02yGNtfZ0JIfMMx/R+5dfXe9B4v+NRisWI0/YB
	413sDcVtbOgM+ggufwmuz3QF2p70qfeI/nWiS3aJ/l9ST46F6tXz93objocAwtn6
	6dmgjqIGcxetZlOJnJJSDCz1E2OTGrgvHwmF26ARdOQJptZbXgEv6cmBN4uK2D4s
	lPhuGRgJTUhf2TyT6eW7UON7qbRE3YgnfCqOIEueRZCvc3LftEerp/lQlvce92Hq
	4naFH+CJczTa/Tt5q1ioP16WhRcxpArifVRXrCNUmk/ESX6vU7FOfPW5DUYLywQl
	iDoxMqM9ZwS+OZF77TAFvOHQhU9jPQSaaS1/uWIDDzRPrw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z-sTrmJdF5Tt; Mon, 21 Oct 2024 18:35:48 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XXPBp4Kw1z6ClY9R;
	Mon, 21 Oct 2024 18:35:46 +0000 (UTC)
Message-ID: <85d2cb9b-75ba-4ab3-a50d-0f8161456fcb@acm.org>
Date: Mon, 21 Oct 2024 11:35:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: ufs: core: Introduce a new host register lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241021120313.493371-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 5:03 AM, Avri Altman wrote:
> Introduce a new host register read/write lock.  Use it to protect access
> to the task management doorbell register: UTMRLDBR.  This is not the
> UTRLDBR which is already protected by its own outstanding_lock.

Why is this necessary? I think it is allowed to submit host controller
reads and writes simultaneously from different threads. Only 
read/modify/writes have to be serialized.

Thanks,

Bart.

