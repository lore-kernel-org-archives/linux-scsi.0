Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFCE3B8BA5;
	Mon, 27 Apr 2026 12:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292948; cv=none; b=BY3xcNP1T8CuQXjhSURu9haKbpA/s2phK9GJnPnH5DTTK8Sg20nACZP5d/Q1Wne87UBJcZZ55/2eWq5f0MJ94SWD2ce0qa9fOv+V5d0gYDGxcMPMMJOZfDZHvpNNkFK44JkVL9wdq+nFGMAjERjn44kDfi5Dm/mtM/xbG8g1VTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292948; c=relaxed/simple;
	bh=BJKlCBYGOUhmmS5O7c0ImPKiB/EUQfZMo0Ys4fbhH84=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=HnDbdT+7raigNaCi74OrkLU4fPPZyU9aTqqzMAfd6OYzQ5EhVs9+Lb1kLSUzJBRk0rxRQV8myS08c7pyyXlOwcsmFUvEy2d0ElpcDfV1eMf9J+s/N+I7Uwlc6Q/up3wGQkA9spieBYYBJqYOoTTsjCUkXqDH1Y95uu+CJbci1+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=nB9dPoxN; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="nB9dPoxN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1777292944; x=1777897744; i=markus.elfring@web.de;
	bh=BJKlCBYGOUhmmS5O7c0ImPKiB/EUQfZMo0Ys4fbhH84=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=nB9dPoxNEgn5tG87qvgMsv9gsOFCokvZZdLvuUwVWdd9FaCUtxCu+hlaliiXQdRL
	 1DkSmp3Z6gcUD+s3LU5QSm8BGe3+UJvP8RZYUehokyW1hjCf6rbfUvfASani/TVuA
	 zwx9uKxb3HwnjroiEyqd51nscVVYBuD2XbdZNTgIETNceDMHmH3Qkwr2r5aknbHwI
	 rCTwDhDF2TwgPniB7D2B8rI88k+9qnocH0WM57ZlARoggzc1QPb+YFwiyhlnu3ZhZ
	 Ip4e5A+U4f1bWfQBhT6+JKhhcYZs982+omyeDam/nBiYW/A8jVgx48JwX0jmKscFz
	 ES+R5zW0SCbhfbYcVQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mtgyj-1vMUPP3VpH-014og7; Mon, 27
 Apr 2026 14:29:04 +0200
Message-ID: <0f8d53d3-372c-43ce-b0a5-f8131238de46@web.de>
Date: Mon, 27 Apr 2026 14:29:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Ijae Kim <ae878000@gmail.com>, Myeonghun Pak <mhun512@gmail.com>,
 linux-scsi@vger.kernel.org,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260427082505.57719-1-pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
Subject: Re: [PATCH] scsi: pcmcia: sym53c500: Fix probe error cleanup
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260427082505.57719-1-pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:p10bcH+M7dg0Wpqz9NPL7uUaHWSD5AYtHYEBMGebQRJ6iZKLF/V
 NMe8clygMo6mcslN+wacMZKcWoxwX1YANiF31mBviGJwEym2ftAlUUeVUXMBOOVRbzPkq9t
 JiXXDBRFo2Ou+kYjPqDF0j4RTMoJlkF8V0Z3cVH4+LrXDbRjoYsBcAgwnqO2l1WRqAKXJDS
 qI4Q0GOXmBICyT1M680Vg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/lFi9m7E9oY=;EUtWOJNuK6Sn1yte8nYK9D2/1z5
 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

=E2=80=A6
> Use pcmcia_disable_device() on configuration failures and let
=E2=80=A6

How do you think about to avoid a bit of duplicate source code
for an improved implementation of the function =E2=80=9CSYM53C500_config=
=E2=80=9D?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv7.0#n526
https://elixir.bootlin.com/linux/v7.0.1/source/drivers/scsi/pcmcia/sym53c5=
00_cs.c#L698-L810

Regards,
Markus
