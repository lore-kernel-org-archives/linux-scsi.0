Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C33D29CA
	for <linux-scsi@vger.kernel.org>; Wed,  3 Apr 2024 23:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712186453; cv=none; b=PH7mFSQJJu6y4NDFoxxU6YT/PEhGaKsTPfj9IeDMVB540DpssGoqwanBBepT5ylBg8Hiylpvg5Tx0+oewU04GyXXXKhG7/iw7s1TTnAuAKG4nDM3y4ySBtrcrlZ/otRbd1ENaZ+oDwHXOZMTU39RndXd8CHIIejwJSRO621uwtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712186453; c=relaxed/simple;
	bh=SVPJSCc/kzYeBx3Hm+KXt0+4c83hf7OMsuqnXLRM0hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mEF4+LS7t2JeC+caRnqUWaEYylRLz1BB7D2o/273Yq/1qdwAf3Gv4k+4yvKOmKLQMKu3DspDKUW84o1rq0feyMCCUgSxz0/uUEXblnPcLd/TlM7dI9Y52SuZgi0rXppfKIfuy+flYOLCF7eYv9tGf1bs4bzOG3MuvqbOCOmmMnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XZ7UJUn5; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XZ7UJUn5"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V912W4SKVzlgTGW;
	Wed,  3 Apr 2024 23:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712186450; x=1714778451; bh=4B7993YMbmrr/nj4BU6y5xaR
	P2QHKWHVqBY5+/MGLUI=; b=XZ7UJUn5XysX7rsVAe7QV3mQ40GvpE/+pL0eSb8F
	pAnE+5+Cai4im/aPZI78MPoTgRuF4LSibO1LN4Fp9tMW6tGK4xrKtL1bKMTpLVUU
	IQYeCFd6tMbHC7fM/6k5+8WIX21ReWwfoEkFEEpZ2rqyKDJ4n9Tvf8pSNHFBdIgQ
	avUL4pRuVAdX+IIyEe1zrOSFgZlZJKOHglp9hcOFKB4nwmeduyg/VXilHaPCnpS7
	4gclpilZ00XzwKLJ6LMKBMnm7BADAcX5mbskTJgbJCwIsB0YE1AZtmVc4m/V8fJj
	JmPBYUv7Rf2o3KiQMGi847nQPqu1PaJVo0e7VpRZDtbHXw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IgN042vKiPjd; Wed,  3 Apr 2024 23:20:50 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V912T21KxzlgTHp;
	Wed,  3 Apr 2024 23:20:48 +0000 (UTC)
Message-ID: <2a17e63b-6567-4d6c-abe2-309304bc9ea2@acm.org>
Date: Wed, 3 Apr 2024 16:20:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Charles Bertsch <cbertsch@cox.net>, justinstitt@google.com,
 linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/1/24 3:43 PM, Charles Bertsch wrote:
> 45e833f0e5bb1985721d4a52380db47c5dad2d49 is the first bad commit
> commit 45e833f0e5bb1985721d4a52380db47c5dad2d49
> Author: Justin Stitt <justinstitt@google.com>
> Date:=C2=A0=C2=A0 Tue Oct 3 22:15:45 2023 +0000
>=20
>  =C2=A0=C2=A0=C2=A0 scsi: message: fusion: Replace deprecated strncpy()=
 with strscpy()
>=20
>  =C2=A0=C2=A0=C2=A0 strncpy() is deprecated for use on NUL-terminated d=
estination=20
> strings [1]
>  =C2=A0=C2=A0=C2=A0 and as such we should prefer more robust and less a=
mbiguous string
>  =C2=A0=C2=A0=C2=A0 interfaces.
Justin, can you please take a look at this email and its attachments?

Thanks,

Bart.
