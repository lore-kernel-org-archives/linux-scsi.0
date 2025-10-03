Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA7C286418
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 15:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759506304; cv=none; b=moHYRfpTNfHmtwUYNdqgCscRk/2CbGrFJXh/emlsVc/vvhsqVfliWEHq/WuZE8OjIjwVjQddyB2tNDGkxaQHzRz0AwPg+fS5iNsO7slay/KuRUf36zos4j9Ry56tlbO4o4yG/YwArSIyNGGIlKMLjVdSDtVKnx/4UqN1cLmax28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759506304; c=relaxed/simple;
	bh=7sRK9RWciym1y/DC8AUkp9yCKjAU/CUiTjUmm7e8LkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xq8J1xbqJfv6PILMul5Vy+Sf6AU3NKEyMyZINraTueOj6dFp0fwZsbFmsiRPhgbT0JSSsAEmjig05BGnjPInru2YDusarImUrh5SC+OzI4ixMxpxkSWMp2m0u4tH/r+KaIy1rc9PEDijPo7szCHH8FWMfuRfTlPfU571vj8dh8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gxzPWnZB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gxzPWnZB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cdXzW6gzwzlscj2;
	Fri,  3 Oct 2025 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759506294; x=1762098295; bh=FL2qVJB5fo+vXrmsQW8d4vqz
	Csm/4Drc+PSjUaEib7A=; b=gxzPWnZBld7qIR7qY5cQuQZJ02/p6AM5iAvWxhds
	u1P/X2JGY1MhEsAdz8dHWkGxtcSE9MDr9qvN5JERwhZqsqaa1dfi7zkHTuU+ivkV
	A4J935uH6YsiewS9xJyqtdOgH+2q7rlZ/5CcSQ9nJKlBklfG3QMs9IMu2rZmTlgd
	fOFTXX80C/tCo5yqWbzgS1QRwYNlpTaoo6AWUbS+cJ4xAOuOoMoUXXwYrHc6snAt
	xQWFdTzbO/JuIZejgZquAihf8GTSwrBpW3sGi6x4VNBn/CDW0OwQdUoQaEM3JY9z
	46t7Nxu34DrWb6T4KktU2DDk92JvLMYaFPdjDNnsjXFwsw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4-w_9V38t5kZ; Fri,  3 Oct 2025 15:44:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cdXzQ6HkZzlgqyj;
	Fri,  3 Oct 2025 15:44:50 +0000 (UTC)
Message-ID: <4a5394d5-6608-4a81-8f8d-006ea2bdcd61@acm.org>
Date: Fri, 3 Oct 2025 08:44:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] scsi: sd: Do not retry ASC 0x3a in
 read_capacity_10() with any ASCQ
To: Ewan Milne <emilne@redhat.com>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, michael.christie@oracle.com,
 dgilbert@interlog.com, hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-3-emilne@redhat.com>
 <8f250e77-5069-416d-9389-9c3e99535dbc@kernel.org>
 <CAGtn9rkZX-C7DgaMCABsF66RVGomQeK1RyRW5knLPsPEzvajOA@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAGtn9rkZX-C7DgaMCABsF66RVGomQeK1RyRW5knLPsPEzvajOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/3/25 7:40 AM, Ewan Milne wrote:
> On Fri, Oct 3, 2025 at 12:24=E2=80=AFAM Damien Le Moal <dlemoal@kernel.=
org> wrote:
>>
>> On 10/3/25 04:25, Ewan D. Milne wrote:
>>> This makes the handling in read_capacity_10() consistent with other
>>> cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
>>> result in wildcard matching, it only handled ASCQ 0x00.  This patch
>>> changes the retry behavior, we no longer retry 3 times on ASC 0x3a
>>> if a nonzero ASCQ is ever returned.
>>>
>>> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
>>
>> Doesn't this need a Fixes tag ?
>=20
> I don't normally add a Fixes: tag for things like this, since I don't k=
now
> if any device actually returns a nonzero ASCQ.  (I think either you or
> Bart asked for this change in an earlier patch series, which is fine.)

I think that I asked for this change. From=20
https://www.t10.org/lists/asc-num.htm:

3Ah/00h  DZT ROM  BK    MEDIUM NOT PRESENT
3Ah/01h  DZT ROM  BK    MEDIUM NOT PRESENT - TRAY CLOSED
3Ah/02h  DZT ROM  BK    MEDIUM NOT PRESENT - TRAY OPEN
3Ah/03h  DZT ROM  B     MEDIUM NOT PRESENT - LOADABLE
3Ah/04h  DZT RO   B     MEDIUM NOT PRESENT - MEDIUM AUXILIARY MEMORY=20
ACCESSIBLE

In other words, a Fixes: tag is probably appropriate.

Thanks,

Bart.
