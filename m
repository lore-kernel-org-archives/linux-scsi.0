Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFE516DED2
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 17:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719853954; cv=none; b=lRpDWbXXqra5/QMkfrG8mAuyfjW/1B4MdJB7Lpb13UchiNWONL5FFiANTBIllqQN+NuQuTVsGoegdS18UP45RzKhM6Tk2yJy8P5ocge+NJfyMDHhlGmyH6QEo8VVo5alYJXOdkurUBSUU9uKT1fUyE6XoogQHpH250A/UUyD/v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719853954; c=relaxed/simple;
	bh=Xz2YHTGMUN4dIBcZCc2g9jKBgJxwUH2mATjEA1ETkM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XbB0H6Shk523ldHdKkYl7m86Sx3P6x+l1TexrNREenYtDOmbjm7wKqQhgI4sm/s5NKsU2Cu61VjcYRu0ftPzOrgkY5b6VSBCRKEZkVfeR9q626BbLuv+mq5H9sUXBtXK+PGibS8qHuhjFMEJGUkxctOce3RAtnT9OlXHQ7PgLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XA6bYTgj; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XA6bYTgj"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCXfS21sNzlnNF7;
	Mon,  1 Jul 2024 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719853950; x=1722445951; bh=Xz2YHTGMUN4dIBcZCc2g9jKB
	gJxwUH2mATjEA1ETkM4=; b=XA6bYTgjj9dPStDoGSYrpFLmCC6EjA8CxxKwBvZ/
	Q0g6ADPoNQI90tpjgesY89KJ811IldpHvdaSX8MLAXgs9wiysdl9Mg4okdmpEUO1
	EDAJNmZU5gwF4+Eab9da+sG+3TNuANbw0F7v2BxZw3UI49UBmDAtVtLgmQK+BddP
	DQ3xo+6PzgUaO2Qcm+n96Mha9PXLyJ/NDrZ4Q0ERj8YRHX71X2FJB6uIZ7TyjzfT
	lYZ2/nWf6yE45ZNFOnIwWPdn0Eb3Ockx4oHtOFbJRfKCiWlB7xmvUyPE4nxouE6G
	G5T4FRm/p4OLU4uEXY0zQXIapnQNRb5Y0/UgNHxHH3mZqQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1steOw0Hc9Dh; Mon,  1 Jul 2024 17:12:30 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCXfP1SzRzlnNDx;
	Mon,  1 Jul 2024 17:12:28 +0000 (UTC)
Message-ID: <a1417e9a-e10d-49b6-be84-9d1e68fe577e@acm.org>
Date: Mon, 1 Jul 2024 10:12:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Remove scsi host only if added
To: k831.kim@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 =?UTF-8?B?7J6E66+87Jqw?= <minwoo.im@samsung.com>
References: <CGME20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
 <20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/27/24 1:51 AM, =EA=B9=80=EA=B2=BD=EB=A5=A0 wrote:
> If host tries to remove ufshcd driver from a ufs device, it would cause
> a kernel panic if ufshcd_async_scan fails during ufshcd_probe_hba befor=
e
> adding a scsi host with scsi_add_host and MCQ is enabled since scsi hos=
t
> has been defered after MCQ configuration introduced by Commit
> 0cab4023ec7b ("scsi: ufs: core: Defer adding host to SCSI if MCQ is
> supported").
>=20
> To guarantee that scsi host is removed only if it's been added, set the
> scsi_host_added flag to true after adding a scsi host and check whether
> it's set or not before removing the scsi host.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
