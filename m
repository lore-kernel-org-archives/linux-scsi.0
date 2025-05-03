Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A82DC789;
	Sat,  3 May 2025 19:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746299316; cv=none; b=MmWYygqvpoSm5F8l3Jk/9xULemJe+Bx53QIgJXvk2gSnfihtGgcjdESwxNjPPX84B9UfM6OFSV4kAH2uwEr47irXOoBwuFMuddcxm05SKZJRiRrG5ZifMO1391/tQo8GRVAu/YoRryj3IgJtBO19veq/AUkNl4m71lpFg187dIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746299316; c=relaxed/simple;
	bh=jvvG37KAbI59JUlaTYZdzQe6qpr7rWpxcAPSbfNKf54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eXcCGVBacOdxmhJnkXKubIRa4xqzC7bN1fV+aiehkDxb7YgY8IvOSxrW81Iroz5M15ttRoTn1vp8bCzp4lW2X1NV4494H7qhVWW2XrpYLspcvFoOUMAImb06eiOlbW07WBTY7NUQ/F3aBMP6mA+pkBW6RnG4xi62whay8v6Mo7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=01OHnSf9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="01OHnSf9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Zqcl63cfxzlgqV0;
	Sat,  3 May 2025 19:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746299312; x=1748891313; bh=jvvG37KAbI59JUlaTYZdzQe6
	qpr7rWpxcAPSbfNKf54=; b=01OHnSf9Ix0g38JrXYhc7n5oVyRYYVQdrf2LsJ5J
	yX5QMDIIshGr9jy5tP1bqbzoVJ4iWdDGlIcpqmZUf//Ccr5x2HuCHTVDxBxZ5p0t
	8u99WsVoH393gGU+u0aY+fMTbBdUbxNwCLDEWcM/Kbz6DLZfE2Z0Z1KdIesdJPiv
	lP/r+Eup3zoMSyyw4tsmGk0cWZVY/VkK3gJnMWFcXbQx+HcJS6uE8YZDv1K24ulT
	OoX4gdXPRxMAAC6zgriKG4wdGHEP8sUU3/Mf8X5nCdla/g0L5ZgHAT46Aa6ASUUL
	cwc0xAuKpV236rJdi6rcR9gKoC8K6hl3YUX9ilTBFAT28w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id By_zUa0p23QT; Sat,  3 May 2025 19:08:32 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zqcky33Y6zlgqTv;
	Sat,  3 May 2025 19:08:24 +0000 (UTC)
Message-ID: <33d7a1b3-4bf7-4337-ba82-dbd4b95ad0b8@acm.org>
Date: Sat, 3 May 2025 12:08:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2][next] scsi: sd: Avoid -Wflex-array-member-not-at-end
 warning
To: Christoph Hellwig <hch@infradead.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aBO_32OsMj3hsJsv@kspp> <aBRrP8EuNkeAtPC9@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aBRrP8EuNkeAtPC9@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 11:50 PM, Christoph Hellwig wrote:
> (I still wish we'd kill the stupid struct and this test and just used
> the simpler and cleaner bitshifting and masking)

Bit-shifting and masking results in faster code. For slow path code I
prefer bitfields because this results in much more compact source code.

Bart.
