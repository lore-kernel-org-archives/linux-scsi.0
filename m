Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A374B26156B;
	Tue, 11 Feb 2025 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739295707; cv=none; b=pZI22wzG9xe2eBqz89UqljDD+G9YB4avFyUDFnyxX/mzdvzy25DMTsG55gHXvxMhyum+oD9tleU8A9o4HGml53hq4XtVFIqDnurC9lHSnWIb/R/TQEiB+v4Y+BDNpt43MPx22bG2zWGJsefdx3SJZWM6WKn+nVY0UecLDogAxRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739295707; c=relaxed/simple;
	bh=l+7I5M7UGIUBIUp7sSRPvu0KIGdGdG8yaIad6MYHd9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owWXPFfAPRUBi/jFRI0Sr3a7b69bSyzimSI9r8pn9TYWfZht8XDIoqS9H9nKoocQ35DaT7FWfs0d0I0kv/tm7YyP9bzu5s5Asv2YsFBdyR1/KXKfMyZeSC3k7m+VI2KRTX7l5DeiKRw4V90uraQ86luJA0pRV14P9pIJ31iHzGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ym/PXYuU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ym/PXYuU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YspfK0B7bz6Cl0kC;
	Tue, 11 Feb 2025 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739295702; x=1741887703; bh=o0ZebZGDB40d6FYINzC5swd8
	gx9rqaADH5graC65wXo=; b=ym/PXYuU3kXFMe+AojaIHWOCet2cioACQ8ZA1nz8
	mmov0fapw+K5i2+n0FCYs9a/Bq/bBxe8cMJ2cDG0+egm3HAJiAxnrPUywdHDw/B7
	F2s9wJkoI4lp5oohvZ7J3L0imlGDJRCbMQBImmNNmwgqISFjObGbyGwTfCHf7HuJ
	/7vHN04o5luqQvnSoUZ/kZJnD8XlgbPNUu6aqFrweFA5asDMFWdJFL8oA07TnV+2
	3tcRntXqDRi8PYYgp+UhmibNS/eKCujOW0ZUMZn8nR+6gGPBheC1GhTsWdMrUmaD
	hBcqu+8X1kF04kyJJBQ0I5wqPkFM66iQ52ym0OeKdSkn5g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w--FYRWX24dW; Tue, 11 Feb 2025 17:41:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YspfF50vHz6Cl0k1;
	Tue, 11 Feb 2025 17:41:41 +0000 (UTC)
Message-ID: <527e89a3-0994-4da3-a474-e4bd1e6569f0@acm.org>
Date: Tue, 11 Feb 2025 09:41:40 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: ufs: critical health condition
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250211065813.58091-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250211065813.58091-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/25 10:58 PM, Avri Altman wrote:
> The UFS4.1 standard, released on January 8, 2025, added a new exception
> event: HEALTH_CRITICAL, which notifies the host of a device's critical
> health condition. This notification implies that the device is
> approaching the end of its lifetime based on the amount of performed
> program/erase cycles.
> 
> Once an EOL (End-of-Life) exception event is received, we increment a
> designated member, which is exposed via a `sysfs` entry. This new entry,
> will report the number of times a critical health event has been
> reported by a UFS device.
> 
> To handle this new `sysfs` entry, userspace applications can use
> `select()`, `poll()`, or `epoll()` to monitor changes in the
> `critical_health` attribute. The kernel will call `sysfs_notify()` to
> signal changes, allowing the userspace application to detect and respond
> to these changes efficiently.
> 
> The host can gain further insight into the specific issue by reading one
> of the following attributes: bPreEOLInfo, bDeviceLifeTimeEstA,
> bDeviceLifeTimeEstB, bWriteBoosterBufferLifeTimeEst, and
> bRPMBLifeTimeEst. All those are available for reading via the driver's
> sysfs entries or through an applicable utility. It is up to user-space
> to read these attributes if needed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
