Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC8C26E173
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2025 16:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754584535; cv=none; b=kRanLmmWlXpyqCJYK8X88PVUPrDDT5Zs/OvdmbXQKq41XHFdemJHIZHqcC0uykFEV2BFGROmTFX+EfS+HvMeeLLEZKo/gaUKAW3BnxIUoxnGWa/YSqTdhFCvKkbAheMiR+eN+QjPfEbq0G7gc3G9xuBn53zsljrE0kJlfCqZeuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754584535; c=relaxed/simple;
	bh=QvKcfi1roqQEDucIfNSPPtN25j8B+TEWLS3XRQRbCPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sy0XxGY8iXGOhoBs5/N8z3wKOeIoJA8Wi5TCbUgvILIUhRFRR0K/2UjB4g8NoCa2E7rb5a8fp1lyb2NElhCVa6mEZt6TsnBJougAOB2UxJpwdtZ35BbceJqauLiE1npdHxNrWkKIvuhCnU49RKL9Q5HN2D9E7Rmf57JxsGIXjms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TFclSWGt; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TFclSWGt"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4byXpD3HLpzlgqyj;
	Thu,  7 Aug 2025 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754584531; x=1757176532; bh=qsMxqDAlu8RAOAfuAdOTXCW8
	fb156S+EqdRC3/iWft4=; b=TFclSWGtuiWO8RyIVGPv0zxyJ3HnwpVNUHo3rbJs
	cm4azCKkYMryYtGqcVOsL2RJWiVSJ6HMsDXAThveSYAJlYO37UC7sorq/dPOq1i8
	a6hre0/ISF60CJHlSWlfMH4GlLIRrl2k8xuyjQhNjRKCs02B/ZAgsV1tIFKaD3Kl
	dGs27hs1eGkn9THgZhAxtCmfz//gOs8AOS4ISNv4yRAyZrns8AipvWSkP5ueK79h
	ozhyusJ6trrjHeHo6jithdePT7F14gSLRR7eYHvxf4eDBwQkWArpaASmgZ2i9Rg+
	vmjrzC1UmuailaIlGwFsJaPe29WFNdudOhl9YMcNde9btA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qKgeIYQIrDXB; Thu,  7 Aug 2025 16:35:31 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4byXp725lpzlgqVy;
	Thu,  7 Aug 2025 16:35:26 +0000 (UTC)
Message-ID: <6187e1bf-73e0-49e1-8f30-4cc31f197c78@acm.org>
Date: Thu, 7 Aug 2025 09:35:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
 <74679b46-a823-426e-9406-29ce7b5807ed@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <74679b46-a823-426e-9406-29ce7b5807ed@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/16/25 12:33 AM, Hannes Reinecke wrote:
> As rightly noted, we need an sdev to use the reserved command handling
> trick. There are two choices:
> -> use the existing sdev for per-LUN TMFs. If the driver only uses
>  =C2=A0=C2=A0 ABORT TASK/ABORT TASK_SET/RESET LUN we already know which=
 sdev to
>  =C2=A0=C2=A0 use, so that is easy.
> -> allocate a 'fake' scsi device for the host. Not pretty, but gives
>  =C2=A0=C2=A0 us a nice combined interface to deal with reserved comman=
ds.
>=20
> Bart, from my reading the UFS driver only requires a TMF for command
> abort and device reset, in both cases we should have a scsi device
> available. Can't you use that?

(replying to an email from four months ago)

The UFS driver submits multiple reserved commands to the UFS device
before LUN scanning starts, e.g. to initialize the UFS device.
Submitting these reserved commands to the UFS device after the WLUN has
been scanned is not possible. So I prefer the pseudo SCSI device
approach. I'm referring here to all the code that is called by
ufshcd_init() after the SCSI host has been added
(ufshcd_add_scsi_host(hba)) and before LUN scanning happens
(async_schedule(ufshcd_async_scan, hba)).

Thanks,

Bart.
