Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24C01607A4;
	Mon, 29 Dec 2025 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766999358; cv=none; b=sJP92L2SNrmS/3d38vWgFrlBUwVbovtaJUXAQaDdtIsQY7J3e7tK13A0Ovf47mF9CrNq/lQsLVkImX6teNyWDate0iawl63vvAR9uejgf3bRC7EA7ct5BPyzHrxynwVzOXEiurXujE0eiKOtkUuGhIFzu2fAmZnZseA0zyvmBig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766999358; c=relaxed/simple;
	bh=P9EzqLXfB2H0KdcBuTMeM/6pFaXMYjgN89HueHmvS04=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=PbzKHrBXoItkV4hGKlGHPJd99PD+lJP2bKgDCooppLDaRgIaYgYDC33j3GxUHRaInVlJxffNMp9o4+31iV2UR0k4wVJdYhStxC5vk2lc3w6fMDqVp7Kp+zxZwJuqvuAOI+JqSa3zEOz1L8T5z3oiwLQedUcRV1IpJwL4Pv3vs3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=E3Da1FSY; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="E3Da1FSY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1766999346; x=1767604146; i=markus.elfring@web.de;
	bh=P9EzqLXfB2H0KdcBuTMeM/6pFaXMYjgN89HueHmvS04=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=E3Da1FSYfR8o1AhEbFHtnMZPr+/EHb5DII+nNs2calVCa6WneqYkDJirCGp9mIlU
	 cIVxS66oewkY2wvTlsHztfN24zgG3nCvaE2pz+9VZWKwolClJvatAmo3p7jrWxQwv
	 w7B+tCHh+lDtMc93qfasvXe9fyxOZDzUAFJJDCdPiqwhga5SWUwSXTCE2TUmGhOW2
	 B0zGVzd8qub/o4XVUeBggSVsTL3QHx/fnRrpQnJwLOyjQmsZVUiazAt8PNtnMP4ba
	 SMtbwGZ1/Vi21ecyJqkPGvmIzNDnz/VqYDNevJz58OY2n2bzYoKxFqKLRqK1V+PbD
	 Eps14pQG4Tz9F/4Lgw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.231]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M7Nmq-1vZ4Nq3MvE-00AbJT; Mon, 29
 Dec 2025 10:09:06 +0100
Message-ID: <149a576a-6a21-48c6-b121-b20c6173f7cb@web.de>
Date: Mon, 29 Dec 2025 10:09:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jianhao Xu <jianhao.xu@seu.edu.cn>, Zilin Guan <zilin@seu.edu.cn>,
 linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paul Ely <paul.ely@broadcom.com>
References: <20251229071515.155412-2-zilin@seu.edu.cn>
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix memory leak in
 lpfc_config_port_post()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251229071515.155412-2-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pYJUYJru8AnUXWG6KwV8VxBBzAsPuOfg+GANq9kzIrS6jrR7HVz
 A8K2DhI/K/fHBquCkACU70K3OfuJmgtSKaEhV+ih6ybSj7iX2QgNHoK0rsrLBMbo9Z7dM/K
 tF6kdQ1WXtRPnkPgzHjq/vW6AETdeWO6OrL1OqBG+SDutzIWyu5/20pif+HiNA9oby9Hx58
 7cLgy+f8RQwHhMKOzrrrg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rjjZPfN2t60=;1IgpGk3gfYsk1RDv1im4V8PLywQ
 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

=E2=80=A6
> Fix this by adding mempool_free() in the error path.

Please avoid duplicate source code here.
https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/scsi/lpfc/lpfc_i=
nit.c#L563-L564


See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc3#n262

Regards,
Markus
