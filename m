Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE72279DDD;
	Mon, 11 Aug 2025 10:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909440; cv=none; b=IYiH/1DdulmHYzCYx91rG3vMbM5NIaLtUcG18aTLmzgiKmf+w63Idf6BVvJrp5PdpK8iJUOCKaUnhOvBfOXmLdckBE2P0XuxAQewyF5pSG7axQIPgy0j0gOAfAbtwvvQ90OQDQvWHhL1EUsa8tzqcSVnsEYkrWDP2sz9oE4aFf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909440; c=relaxed/simple;
	bh=Hl6PUz3Kfv8MqYnoNOh7I3Qa6yRSuiRqv4AJGT3kw8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZUFWbkG8bQ9k/J21gaNfC7lgkDgfnyuatgebU8CaZO44MAQJmQFkY/0CaUt4NtDAg8z2M3yY7VGvYZy4xA6zKVjrr2h45dtcBJsnOhSYdKd0Wm759M62j3kt0vJUQmErdEdip9AMgWUKp5W2T8J4gW7qXehAfvHp8pCfejhqHxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kbSWOiXP; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kbSWOiXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1754909426; x=1755514226; i=markus.elfring@web.de;
	bh=Hl6PUz3Kfv8MqYnoNOh7I3Qa6yRSuiRqv4AJGT3kw8Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kbSWOiXPuYKJw7Bk7nb0llX6AT9VCbJp1NH/VuyQtMXEJSY+GdN+x1RvoV+iWLLG
	 6JFR6deC/ZGT6xEzY07P4e1mzaUQid3zmQUwChpOLW4B9QMW31Cb+e1OgZcg7E8hk
	 BTAWIgRGPJUou96H/hRA/YDS1UuNoMo/0z2W/5JePlMlSWiOQ845QElNYEWkU4qTL
	 6XXRqyfM+vyes/sVSLXURSj4LND0BHQ7od5Y4F1iw28hbpKM5+ohWKPJU/r498T2P
	 qB9GDGFVVoq1C7t3eeWdKNnW4WO99Oy5ZZU2R3NoMH2Mv8oJOQvFOJJJRy0niPdBA
	 MYieO1xr6f8t/WDVCA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.213]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MgAJ8-1u794e21B0-00ksuD; Mon, 11
 Aug 2025 12:50:26 +0200
Message-ID: <7010c6e0-009c-49d7-9621-b20ff5122602@web.de>
Date: Mon, 11 Aug 2025 12:50:24 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5.10] scsi: pm80xx: Fix memory leak during rmmod
To: Shivani Agarwal <shivani.agarwal@broadcom.com>,
 bcm-kernel-feedback-list@broadcom.com, linux-scsi@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, Viswas G <Viswas.G@microchip.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Ajish Koshy <Ajish.Koshy@microchip.com>, Jack Wang <jinpu.wang@ionos.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Tapas Kundu <tapas.kundu@broadcom.com>
References: <20250811052035.145021-1-shivani.agarwal@broadcom.com>
 <7c7aedbf-389d-4e5a-83d0-33c51cda1d8a@web.de>
 <CANTE3ihiPx2GZDcUWcO-YR8h-tNrsCtJ=jH7Kzd08Y8qDxZk9A@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CANTE3ihiPx2GZDcUWcO-YR8h-tNrsCtJ=jH7Kzd08Y8qDxZk9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EmzXRg6n1DrZdkjj3d3P/1BozKvFgCKgkkg6ogpsV0pF7lax3Gn
 3vfr785EjgEWCHONrCP01FCniSpSrjYfOc9V5B6EiE7pf2d8jsA3f+etaMJF8Cs3LoP0FQw
 jyQw+OoGcxLTJHV7DMTwGCnFiNbTdY9rJrlNI779AvA7zoud3OWp63sSujJprGlnL+yB8RD
 ZizxsMtNm5S2mCUSui5eA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:H3iuu21fSHY=;0KdzH8Hp0u3Z6WYiPs9wO8em7GJ
 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

>> May curly brackets be omitted here?
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/coding-style.rst?h=3Dv6.16#n197
>=20
> Thanks, Markus. I agree with you and have no objection. However, for
> the stable branches, we usually keep the patches unchanged.

I am unsure how many source code adjustments would be supported
also according to coding style concerns.


> I think it would be good to remove these curly braces in the Linux
> master branch as well. Should I go ahead and submit a patch for the
> master branch too?

Corresponding refinements would be nice.
https://elixir.bootlin.com/linux/v6.16/source/drivers/scsi/pm8001/pm8001_i=
nit.c#L1311-L1316

Regards,
Markus
