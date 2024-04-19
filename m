Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71D6137920
	for <linux-scsi@vger.kernel.org>; Fri, 19 Apr 2024 18:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550591; cv=none; b=eNtmDWaK5CBjnrBT1v3LsF9ckCUdFrsfmfdxJIxuDHggf28J4SexZ5bS5a7+LBcAaFhvOUZBh3CqQHKGgz0H3NHZgKCS2ls8HqGMol13mXz9qomyQ9XIfjS3FktoLSRGO/VnP3Qpjbc3Ahm+BgIx0tuvDkUU4OSILBhsf/XjUSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550591; c=relaxed/simple;
	bh=J5PTlpCU7KMDSdAEuDI3hSiJrU3mfAJvH/mA21R+mnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nTWv8DuJtKvg+miVz2yZWVTMfD6TYsVQJay9btyoEqHkxPWjg+XG01Mx5YhSvpe5gf4B6qIJN0P8vQlWVDv78WYBAUl7Fv/IACVEAVy7K95g+0GqwjuPUy3AOrYqoo46JAqKxfnrSWjYW2zl+5h6+d6KfJDHg7SBa14AMBE8y/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ittPujsq; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ittPujsq"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VLjWq4Fv2z6Cnk9B;
	Fri, 19 Apr 2024 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1713550580; x=1716142581; bh=J5PTlpCU7KMDSdAEuDI3hSiJ
	rU3mfAJvH/mA21R+mnc=; b=ittPujsq7mjEmACkOXmNcN1BZYANAUJIoq2X2EVH
	3u+ygtGYKTIumcqqRRTOEjXSIhyYsXxHo9otapmiEEJ1Vwtvwhtb/Sr89Si1l0Ye
	WVo0Ck7PRNIV6Y/7Rdx5Rgq6gvnM4rrAUn332P0ObaENxolXIlyEW0eq0UAUjJFH
	x9unHK+1YWOKkB2WwUeedWutXekJDznfbxr+qmen2CFSrbBwCDESc4KjpIotxwxQ
	I/G7xteT6Q6AxmpRAGAEzT6HzxeD86AEUfcL7rrVen0tE8SDz2SL7E6ctsRGD9Ks
	0jbcdt9RWUurbw0YlevBrcGUq6O0XdYiRnf2nEinZRrgRw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RpyLaE4ShCIB; Fri, 19 Apr 2024 18:16:20 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VLjWl2HM2z6Cnk98;
	Fri, 19 Apr 2024 18:16:19 +0000 (UTC)
Message-ID: <de973d50-8f57-49ce-9a66-cc1f0570ea2e@acm.org>
Date: Fri, 19 Apr 2024 11:16:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] V2 scsi_mod: Add a new parameter to scsi_mod to control
To: Laurence Oberman <loberman@redhat.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, emilne@redhat.com, jpittman@redhat.com,
 jmeneghi@redhat.com, Bart.VanAssche@wdc.com
References: <20240418181038.198242-1-loberman@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240418181038.198242-1-loberman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/24 11:10, Laurence Oberman wrote:
> This new parameter storage_quiet_discovery defaults to 0 and behavior is
> unchanged. If its set to 1 on the kernel line then sd_printk and
> sdev_printk are disabled for printing. The default logging can be
> re-enabled any time after boot using /etc/sysctl.conf by setting
> dev.scsi.storage_quiet_discovery = 0.
> systctl -w dev.scsi.storage_quiet_discovery=0 will also change it
> immediately back to logging. i
> Users can leave it set to 1 on the kernel line and 0 in the conf file
> so it changes back to default after rc.sysinit.
> This solves the tough problem of systems with 1000's of
> storage LUNS consuming a system and preventing it from booting due to
> NMI's and timeouts due to udev triggers.

Are there any alternatives to introducing a new kernel module parameter?
Has it e.g. been considered to rate-limit the messages related to newly
discovered logical units? How about reporting information about new
logical units only if less than ten logical units are discovered per
second?

Thanks,

Bart.

