Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDB81D0F44
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728428751; cv=none; b=I8YMu/GVO76e38vy1B01f6ptdgS8LdiP2bgBBdAcQQHOa3nYZU7fukFwrYs4BTbSucHMwg4Ir7fc0jKUah3Wn1yIDrA1eXRiulAJmh8RQUanH6CLGpTFSy6MsYZA0mVQebBJgbwIE6YMGJZUvCBuRZ83rHmhrC7115tfSQsghWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728428751; c=relaxed/simple;
	bh=TD6QsDQkRazhFZ4GkpJh8h9GW1sRA+jLhNtAhUzDt5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=INzJBkA8sGyHEgaoZ6YwVK7vby0AlcrOPMiYsgiDVO5VEaJGxdbpyAfUg8wJoGx6ZXHpJwXLL0eOTwHEpMmzB2hksCNJbZd3TgNR15BW8vCIJXhtq8Lz0Nzv/g4SpSK7nF0f7Mhq6i4uaCFWHi39tMesdxTis2jbVqGsJzEtoq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oR/b2nAl; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oR/b2nAl"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XNWpP2XfPzlgTWP;
	Tue,  8 Oct 2024 23:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728428747; x=1731020748; bh=TD6QsDQkRazhFZ4GkpJh8h9G
	W1sRA+jLhNtAhUzDt5w=; b=oR/b2nAl7elXD3Afi1onO/xCNOXZeLXtGYY478jf
	RlFwy7K68Xdf+7tO/TOT0aPogyS15pm1rTVPEHUkdGjvikeANzm809W8NcLEfLc2
	97DJY4VUrdocgQb1pJvFCgt0AJBsDef+EQvnM3oQQ7TGzdQQtA2u/8UtdLfYiRDI
	lTe1SjHDKZ1Wyd9DEcac0xfi5eRuRKFKc+i5CMmZn54DHqNuAMXD8plGmmfRTtts
	7zM4QCDkdyQld/tOZ7qrNhatAQ4hVXi3MFLFqbgxbjNuDW7LnGd/JyJELGYSK3eW
	QaD2NnXgja3aemFARqWD0w/dvOCnHEAhQjA7x5rxzsbMMw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0JvutsizaXv1; Tue,  8 Oct 2024 23:05:47 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XNWpM23bwzlgTWK;
	Tue,  8 Oct 2024 23:05:46 +0000 (UTC)
Message-ID: <a07e83ae-bec7-4738-8c79-328492dbce79@acm.org>
Date: Tue, 8 Oct 2024 16:05:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: core: Rename .slave_alloc() and
 .slave_destroy() in the documentation
To: Randy Dunlap <rdunlap@infradead.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-3-bvanassche@acm.org>
 <ba58a12b-9745-4fb0-8be0-199bd8827201@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ba58a12b-9745-4fb0-8be0-199bd8827201@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 4:00 PM, Randy Dunlap wrote:
> It sure would be nice to know what changed between v2 and v3 of your patches
> (or vN .. vN+1 any time).

Hi Randy,

The changelog is available in the cover letter:
https://lore.kernel.org/linux-scsi/20241008205139.3743722-1-bvanassche@acm.org/

Thanks,

Bart.

