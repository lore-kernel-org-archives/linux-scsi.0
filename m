Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FEB386454;
	Thu,  5 Mar 2026 12:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772712471; cv=none; b=K9nNzxGKIupJ5yVltLvJ/1Kh61DyJejE8h8zeFVPxqeoSoWlR8p2Y6LjMImb756AjL/aHaZiHMYSe68gEfEWfpsX0OXrefqH9twhavuooCzciDVR5Qf7f8SVQ7FW1gHErR2LfbsF576dVpyPaC2Mbe2gVsbSfd5SdOYX4G+KU3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772712471; c=relaxed/simple;
	bh=NrbTb/B1v0CegWzHD/upQ2yDRyI0frM188j6u4zbniI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eKsppLn7fnDYlydkdSCClwW4HlGg30nNwLXF9CtRnXzy0d+mThUsPARW8KnAnxAXh7WwsBX/MqVvNhYs4c+jM2r+CbRwXWa5q41IpklZ8dBY0OwdtBbJAkmGH6k7HVJUknyJdm9farV5HdfLv+UMSkC6os41bju7r0VlfTSBzMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DENBj7KP; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DENBj7KP"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRSwP6gbNz1XM5kW;
	Thu,  5 Mar 2026 12:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772712464; x=1775304465; bh=gOowmA5B1oWJwieakOu5Izok
	1ou5AhGMuJKjrOHZe9o=; b=DENBj7KPmqMTaIIwNPoEbBu2hOW0pxCwxIvJ0j8A
	/V4f/J32CTMfh7R4YFGUSKYxNsro1BLqs53zEU7C1rO5vq84KH4wQNN4JwB5ao/e
	krvfbUF02TcTyjcGQldBjsnPrDILgQe+4L4xutyQLG85vsnk9MGaK92jG5B6G2Ee
	6Reir899AqLoofIMGnUIo4uco/iQ8r23lZ0KFxDrO1diw0mYqTQm8nCNkYY8Wgfh
	g36i1LB3i8iUPOcxe9MyXakf0CKJXAC/8st2dGMYCj13Zl1dZnDGKrpVpTxx9ZLk
	TWLPnWSTuwN4cn0nTNIWpjESVwpDVIrM56/hrC7UNyf3yQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4NtkS9dJrLoo; Thu,  5 Mar 2026 12:07:44 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRSwD5LKTz1XM5kD;
	Thu,  5 Mar 2026 12:07:40 +0000 (UTC)
Message-ID: <c18581fb-d44a-4aff-973c-27cdcc9683fa@acm.org>
Date: Thu, 5 Mar 2026 06:07:38 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Handle MCQ IAG events
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "arthur.simchaev@sandisk.com" <arthur.simchaev@sandisk.com>
References: <20260302180117.2797184-1-vamshigajjela@google.com>
 <1fa500fdfbfff7d43bea1839ce1992fb4283c5eb.camel@mediatek.com>
 <2cdc620b-b521-4058-a802-87591aa4c253@acm.org>
 <151ef927de40cd3e663b816194761a029c07ab23.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <151ef927de40cd3e663b816194761a029c07ab23.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/4/26 9:28 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> I know this is absolutely correct, but reading this code is confusing:
> if (cq event)
>      handle cq event
> if (iag event)
>      handle cq event
> If we cannot change it to:
> if (iag event)
>      handle iag event

Hi Peter,

It is not clear to me why the above code is considered confusing?

UFS controllers are the only storage controllers I know of
that generate different interrupts depending on whether or not interrupt
aggregation is enabled. All other storage controllers I know of use the
same completion interrupt whether or not interrupt aggregation is
enabled.

To me the above code means that whether or not interrupt aggregation is
enabled, ufshcd_handle_mcq_cq_events() is called to process the pending
completions.

Thanks,

Bart.
