Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E92C312819
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761583055; cv=none; b=lH6DaVl8c/3GdfI0to1h44A6wtoTCs3PV8w7kMcqjwOhKByHkzjIDPUZjWYiaPOYR4EQRbkoK1+4q3AbEOGgTyfCIcCo2iJm8GvKJicXmDnDJdVZhQZ1N6rSji+HGbUwXuWBkfWuYLY8zf/bWc+sN9KZqHOis/eiczv74DssTe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761583055; c=relaxed/simple;
	bh=UQpUt9sFf9nCAkotJ3hhnSNq+dzLwD6DK3hikC1nFrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ye6bnZtkhXr1E9xlgKa6mqZdZOb+TDgzv5kIVZlw1nd9fGpro0LO4k8cHudPMaMj9j6Cyofk4Q2+LHsa/W4ekzv+UMfZokJrWMah6+38ADrgGGbye7NM5NJ/lC0BWDmTNCivJiTIfDJDF8pI79oaOLDxo9/1Js6R3F1I1dwoFwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0cbHLdJb; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0cbHLdJb"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cwK184YJvzm0yTt;
	Mon, 27 Oct 2025 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761583051; x=1764175052; bh=UQpUt9sFf9nCAkotJ3hhnSNq
	+dzLwD6DK3hikC1nFrY=; b=0cbHLdJbh2LYndolETpSWxq5W+i4nOulwDuPZWQr
	7LIMTz0aWeCRi39n6HmoBRLJp8jmg4JzKmd5+YwBu2JEHQjXWZOUcvYBf1f+pD3r
	2DFngyorybNtrfQS8spYu98gb0dqQ8CWwppxRuahkKjKavGXhrLaAru4sV1SN9dC
	E62Uwk35ux7+v9FF2zSXGsBJl3SAdKa0VywDnQhPAwIn6cz1P7MULWrwKwPUGZ1m
	QtgF3kPOYibDbc8LiWO6XWasPDBNslr+jRfFNl3vQNhs2R5oweHGxnEnhFEcs7OQ
	Ntf3NYPSjixnC5IP+IeUkcaYu0KwUl6Vf11GHM59xC0Ocg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L7g53Jh2lu3l; Mon, 27 Oct 2025 16:37:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cwK151g9Jzm0yVL;
	Mon, 27 Oct 2025 16:37:28 +0000 (UTC)
Message-ID: <8e3342b7-e8cc-44a4-a746-d35cb95613ce@acm.org>
Date: Mon, 27 Oct 2025 09:37:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: pm: Drop unneeded call to
 pm_runtime_mark_last_busy()
To: nuno.sa@analog.com, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20251027-scsi-pm-improv-v1-1-cb9f0bceb4be@analog.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251027-scsi-pm-improv-v1-1-cb9f0bceb4be@analog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/27/25 8:20 AM, Nuno S=C3=A1 via B4 Relay wrote:
> There's no need to explicitly call pm_runtime_mark_last_busy() since
> pm_runtime_autosuspend() is now doing it.

"now"? Please mention the commit that introduced this behavior change in
the description of your patch.

Thanks,

Bart.
