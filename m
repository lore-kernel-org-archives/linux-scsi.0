Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF0B1898F8
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736272225; cv=none; b=rdZlllbU4E/yYJYq0dvMy1fcZYcqvHHLc80zYBRJdZzD+TGpZu4GO3n5slaBgdVTes/sHZzQYNvOZ53Ne9jA0S0sC0ujHn/OsdwR3akOLMoFx6QpRf+5oXE/OHO9dr5EJjZqX8Vwn4ilqqswBDUoMtE0OxIlbiploAiMEOgiU5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736272225; c=relaxed/simple;
	bh=CdOd06Hrglkv4hyGlHbKCF6KmQxd6PSX9bH6KdnpXiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQyR26uJBEF8YcR75VdYFgHRanAmX88hd5pJ0Wn20H9E96KXTbkyjr2gM7p8xVZSW359XwHaD3QMpAAi0I5abuQyzicXh1eREbGpz0QTVfc11Goa8RCfS/3mbvj6JJJrdMYeHHpOL766/SQi2zEMMPODHU7bOXf2HiJS6eSwBsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Qrrf/Coi; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Qrrf/Coi"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YSJVP4lJnz6ClY91;
	Tue,  7 Jan 2025 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736272219; x=1738864220; bh=CdOd06Hrglkv4hyGlHbKCF6K
	mQxd6PSX9bH6KdnpXiU=; b=Qrrf/Coio5/seZkoCI6CkXY/gzceu8pCgcXVSF84
	R9C2rd3jYhAT1fI3uEFjlSbbr6ySxcW0Hzmq1t4MkRWF5M3RbWrbSB69uMVQi44X
	1RHQ5l767xcnwnZxepsbsDTzG/CoMzDLYP1r5NvBzweDQU9giLjWMeZrZLsWjhA1
	GbwU15ACkc97VCwyPdijFZC9FTV3vjp9CfqNH7lnjpHL/vngsuAxoj990VfW9xC8
	BIwFTlfxcVdButdhr2qDS6nQU4yQp+fNm67K8TO36/e859o7GJpj+NFiRa+BTNi+
	kZDd+rCJ5gpqZUflfy1vz/l88G5+MSYRqQ0hSmnoMZs+bw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VV9vSaAsweWR; Tue,  7 Jan 2025 17:50:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YSJVM11JMz6ClY8x;
	Tue,  7 Jan 2025 17:50:18 +0000 (UTC)
Message-ID: <23cab973-d189-40c8-b843-a135378386d7@acm.org>
Date: Tue, 7 Jan 2025 09:50:18 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: Constify sdebug_driver_template
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20250107153325.1689432-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250107153325.1689432-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 7:33 AM, John Garry wrote:
> It's better to have sdebug_driver_template as const, so update the probe
> path to set the shost members directly after allocation and make that
> change.

The patch description does not explain why 'const' is better. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
