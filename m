Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F242947D448
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786036765; cv=none; b=EbrUg1m0r3v60yPLwwMVf4p7GBf2BEWluOuA+jjsBHXYMjGW/wZJ6UyBM+tEYFvsNPhM0P/S1SCj3MhdxmB8JbKaGMx5V9fuV9vApMA5LdVRS72UAOIC7BtlvrQiJVI4RgSdTeYFmmKhzARjWVToELUjYKklNbDfZPQYktWLMu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786036765; c=relaxed/simple;
	bh=Vn3avY5vzHrpF0yJtH0KD2oG6DNhP5a/rrBLXZ+75Pk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyKj6Z9EXy+NKE+3DwqOh1S/QDgXjUiQxYtNds+2wNT7D1uiOrVM80MRGrnWaOvfZoUUvYaJgd9drAsbx2xPdp4laDJI+4cKZLxHZXHQBRkILqj7xbjitkfsAZXhO8fIkUrNVv3rRJBscqOvuiMQBjgtiVAbggdSM90a7MWb1cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DKUlZeDL; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DKUlZeDL"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hGDXq3HKyz1XM6JY;
	Thu,  6 Aug 2026 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786036754; x=1788628755; bh=Vn3avY5vzHrpF0yJtH0KD2oG
	6DNhP5a/rrBLXZ+75Pk=; b=DKUlZeDLevQDmYmHRzXcj/FlCdVa6HZXLyrkpcy5
	Wvf4WC0cKZbIVyW9T9cHQ0+h9+OkXbpgyKNWs4eoPX0QBSezhQaCnza812I67lp8
	C1KkKj7Q9/Ep1mgY00EPye7UAmdM3B9gQ1QJEIixsjSqRGAFju57nhwhoZWBA2mV
	UiZYaPHZrEc/5PWje2sPUaGakrIDUIT5WDICIz1aF8lfz5ON7D05UlT340uvM304
	tYz0HWBm/BLh8BAdfNFOjgWa+adY4LKgL++mV+F49Y1uMzS7xxj0iM5wxCA39BkF
	bu4KOYgq+XdKqt1Xy2Bz+N5vX+gABUMvbErhj72sKhn0tw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZIKw-byvmp3m; Thu,  6 Aug 2026 17:19:14 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hGDXX6Vpcz1XM31H;
	Thu,  6 Aug 2026 17:19:08 +0000 (UTC)
Message-ID: <b861a237-eb60-45a9-b932-1bdaa29abc46@acm.org>
Date: Thu, 6 Aug 2026 10:19:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] scsi: core: Protect host state changes with the
 host lock
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 Jianzhou Zhao <luckd0g@163.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, Nilesh Javali
 <njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com
References: <cover.1785965531.git.bvanassche@acm.org>
 <d5b40794ca80ed83888a83847c293349e7f1de43.1785965531.git.bvanassche@acm.org>
 <6d4a31c0-308d-4f4e-9708-11a559137ee3@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6d4a31c0-308d-4f4e-9708-11a559137ee3@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/6/26 2:13 AM, John Garry wrote:
> On 05/08/2026 22:36, Bart Van Assche wrote:
>> @@ -785,11 +785,18 @@ static inline struct Scsi_Host=20
>> *dev_to_shost(struct device *dev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return container_of(dev, struct S=
csi_Host, shost_gendev);
>> =C2=A0=C2=A0 }
>> +static inline enum scsi_host_state scsi_get_host_state(struct=20
>> Scsi_Host *shost)
>> +{
>> +=C2=A0=C2=A0=C2=A0 return context_unsafe(READ_ONCE(shost->shost_state=
));
>=20
> I am wondering if it may be better to protect reading this with the=20
> spinlock as well. We could lose the READ_ONCE and WRITE_ONCE. And we=20
> would be more symmetrical with the set function.
>=20
> I really don't feel strongly about this, though.

I slightly prefer READ_ONCE() because READ_ONCE() makes it clear that a
race condition is triggered. Protecting the host state read with a
spinlock is misleading in my opinion because it suppresses data race
reports while the host state can change as soon as the spinlock has
been unlocked.

>> +int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state=
=20
>> state)
>> +=C2=A0=C2=A0=C2=A0 __must_hold(shost->host_lock);
>=20
> How come we have this in the prototype and not the actual function itse=
lf?

Adding __must_hold() to the function declaration is sufficient. Adding
__must_hold() to the function definition is optional if it has already=20
been added to the function definition.

Thanks,

Bart.
