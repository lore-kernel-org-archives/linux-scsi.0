Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7691FFC48
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 17:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759946019; cv=none; b=EInj+sFZvwpvgMFUsp4zHOHaUav16nCrF5E1zIsaNv/cxKyQ4o/mR1AvV1PKPAVbXUUeHICz6SI7AnggIeuPFSwZkWbiQJ6aJ5LdGj7nPgw4GBRKEMnxIcf/UIxAvneBCBfY0HJffnfREKZBhEILim4j2GqdUGW2D/j8t7BToyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759946019; c=relaxed/simple;
	bh=NUlCV1x0RF5XpGp2+NtTv3ahaQeVLWjfxPOIKzlhvTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQRV49w+oe03jJmYygNtR0UlRb/ouI9cIeEU+c78Mye8XouY9Jr6PUZG6PI16qTqxvT1+Yx5K6K5sOrxbt02sLT/Qs2Jbq2V80Jl8UA6PN46T/IauHdm65D1Zb6as5m/AuIm8VdqZZfFgDgr1ef4yr4/DDqC/KNDCsdfGjjsrXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N90uGDTu; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N90uGDTu"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4chgbh5z0Vzlgqxk;
	Wed,  8 Oct 2025 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759946015; x=1762538016; bh=NUlCV1x0RF5XpGp2+NtTv3ah
	aQeVLWjfxPOIKzlhvTQ=; b=N90uGDTuau+RwAP8Vt4H6znqI0JYTA+Hj30IacmM
	ubBiaG4C5Nnn2B2GsXR28hDh+gKEzVZ3lmDkgekr8352ewDyL5+aXuzMZ1W5TABe
	w8AM9ciWn/XJuIISlh/kXxYO3mUzHV9o+T4fJYlYXF1e9GzETkn6Ori1RD3w1iaZ
	EeuiseB/2jofjZNmHVEWNWc4F2J+/ekscNZpI2fvkQ2UzWpU1AZox7kjEt3VJbZt
	9W99yv5yGvhVevw+QMqIuFQm+zPqiN+QerEeflWtWuWBRPpnjdZAUIqM4m4N7qyt
	SGyOhfJUUoFzTJeGAQu9tt7AFPGGIrj8OR8MHdcroigDOA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zyVlg0ztqcny; Wed,  8 Oct 2025 17:53:35 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4chgbZ4D92zlgqW1;
	Wed,  8 Oct 2025 17:53:29 +0000 (UTC)
Message-ID: <dcacefc5-110c-48a4-9114-1bc0fab0d649@acm.org>
Date: Wed, 8 Oct 2025 10:53:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <3cea82dd-197c-4aa7-9a9c-8908d2f41db8@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3cea82dd-197c-4aa7-9a9c-8908d2f41db8@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/8/25 12:03 AM, John Garry wrote:
> On 07/10/2025 22:48, Bart Van Assche wrote:
>> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
>> iterators") introduced the following regression:
>>
>> Call trace:
>> =C2=A0 __srcu_read_lock+0x30/0x80 (P)
>> =C2=A0 blk_mq_tagset_busy_iter+0x44/0x300
>> =C2=A0 scsi_host_busy+0x38/0x70
>=20
> this value is readable from sysfs, so why even print it?

That's an interesting question. The infrastructure for reporting Android
bugs includes the kernel logs in a bug report but not the values of
sysfs attributes. Hence, if something unexpected happens, having state
information available in the kernel log helps more than having it
available in sysfs. That being said, I think that the UFS kernel driver
reports more information than it should when an unexpected condition is
met, e.g. a link startup failure or starting the UFS error handler.

Bart.
