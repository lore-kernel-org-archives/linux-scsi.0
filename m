Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8110294A10;
	Tue, 17 Feb 2026 19:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771356366; cv=none; b=SIk156lm+rmoV8v0wuczPbdmNux3N61nHAqPYPcDj/dU+1fDONEtucy2Ma5sF8W86gEhG35O+DbByZfXYzGo4RF+hfGOZDE4mdzwzoybeR3cUOBrvjg3cClDsgsvkVgz76VfkJyuaPKLOOGrrdEUcqyYAv3S6TGepSOguyKRTL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771356366; c=relaxed/simple;
	bh=HMhq+q2YhFC+cxrAnPfr9IT2151Th3pDAVDr2aXKnzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N4DjKfl1Dxc941b24ZlTNo2nOzGxbYJhiPURHUb4MzO4X9PwpsD3Iv94vOSFaOOXonXgbcBs1EBRMUpSfYxadZcDn9Ic06Ass9DHcDndmct456bmPAEdOovlPPRudbUo6CrHhb9biTgowVIuzErxvCdBwOSYKNuFa8o9s+e+Pd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FNdY1BGQ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FNdY1BGQ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fFqPM2cFFzlfl8N;
	Tue, 17 Feb 2026 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771356357; x=1773948358; bh=Q/dy/mCL1L8B1QMUSYUopnFw
	uAwqOl7aQk4BGp7SVf0=; b=FNdY1BGQ5ZtPeeVZusZN3MdN+DfAg4qLQt6kD9yF
	LeYDlWW+AdDa4N1uWcv+gm8TRGFTXIL+XC7weJd/v+GqBttphUhbLWP+5n4bdt2G
	7nrnqAi4gOqDOsyXbDo5unrHRVfxzzgTTRVZU6o+rkjbhOJguDUpuq7vLPIFd6V5
	RaqHOG1rodOoxXsTLTOTWpv31JYV7sE9Z7Ph3OccDFNEFT2HHolpjC/A8lABSaGA
	OsrT5CEQca5iDqSVxqtGxSsSWAEmfFfAAjavEe4PeYzF063hSrh8PvMq7b9AUCp0
	/WXIahEA6TjUKRI25rLhppmdglFYM3JBaB3p5nbsxYXBxg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ui_qCjFeZn0y; Tue, 17 Feb 2026 19:25:57 +0000 (UTC)
Received: from [10.237.57.149] (173-255-98-114.utilitytelephone.net [173.255.98.114])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fFqPH107mzlfjRJ;
	Tue, 17 Feb 2026 19:25:54 +0000 (UTC)
Message-ID: <532ecccc-a225-44d2-bab9-52f0f758fb8b@acm.org>
Date: Tue, 17 Feb 2026 11:25:53 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
To: Igor Pylypiv <ipylypiv@google.com>, Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260209212151.342151-1-ipylypiv@google.com>
 <d61a1830-d9d0-4697-b547-80106ce57023@suse.de> <aYtiDLvRotCE0hEt@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aYtiDLvRotCE0hEt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/26 8:51 AM, Igor Pylypiv wrote:
> On Tue, Feb 10, 2026 at 12:38:51PM +0100, Hannes Reinecke wrote:
>> On 2/9/26 22:21, Igor Pylypiv wrote:
>>> +	if (sn_size < len + 1)
>>> +		return -EINVAL;
>>> +
>>> +	memcpy(sn, d, len);
>>
>> 'len' might well be '0' after 'strim()', please check
>> before calling 'memcpy'.
> 
> It looks like calling a memcpy() with zero length is a no-op. Is checking
> for len > 0 really necessary in this case?

It seems to me that the Linux kernel memcpy() implementation handles len 
== 0 fine. From lib/string.c:

void *memcpy(void *dest, const void *src, size_t count)
{
	char *tmp = dest;
	const char *s = src;

	while (count--)
		*tmp++ = *s++;
	return dest;
}
EXPORT_SYMBOL(memcpy);

Bart.
