Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C6A28CF77;
	Tue, 30 Dec 2025 07:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767079744; cv=none; b=leebz+18wWL9gTQYhREqYJW+DVVYt9spDAEw/iGgClZWLhJPeAJ3hro+OLPeplsW3VXuYnbwNbfMYk6kJxJYsS68J/5vSYImc7vhNG6u+yhc+NAgKShxUhZlShBTDYQgQp/Lk5wJBweDbRhEE198hjmXWCIOS35IEf9tnjlUJDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767079744; c=relaxed/simple;
	bh=8jbJzUWTC5ePn/ST6tSvBSsk4+SQNmCVrriMcxLII8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gNuHcnoE8MwJkW+8yUYDG+02rsTIhEe2/kxAqAfFxiixC7oM/FUDfLKY6BlzE/p+r6AaoeJztuDFAKDWeVb/ELU03aZCJMNveXCOgqNWVAjYCf0N8UaPKpIqNZz9XaUeYmldaV8rn8Cujxo+tfp/Qd01iyvssB8fgs5iqe2odic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=P9xqTW2E; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="P9xqTW2E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767079729; x=1767684529; i=markus.elfring@web.de;
	bh=NZFIqgsZdHI2qM57s9Q4IuuTT5QlCzwPZ+zRlkz893M=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=P9xqTW2EA9+KoSWNUtkY6Xmbww6vfYylHOLJ/lgkrGWu6M8q76mcCnxiGG6S3+Yr
	 cBmVMs2oKZtqtCSsoV5FMGwl87y4hXACqTjbOBOuQBwQNTPQIYD+pKnPT6Ei2aguc
	 GhJ93D044bzbaqccdSLeYu7CYxrOJtEUqzg7cOs5Gqrr7BQ6q0u4Np5mT+E2n+1Ls
	 x1YqK1Ncal9gbPUPqu8KrbLuiTPcs0U934tEbWxHxXWLnFfequIjXpPZMbpS+lKTS
	 hiKxDZtFJcI77kmk+l4KuM186FbUPpK8MKwJS+FMl+alt5WfQCApJL6PRuvUzK1HF
	 KaWln/mzFdcfo4m7sw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.0]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MdwNg-1wAMg302lS-00iPno; Tue, 30
 Dec 2025 08:28:49 +0100
Message-ID: <c8d2af7e-5ddf-4de2-ac1a-8a938280a0f4@web.de>
Date: Tue, 30 Dec 2025 08:28:37 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
To: Zilin Guan <zilin@seu.edu.cn>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Jianhao Xu <jianhao.xu@seu.edu.cn>, Justin Tee <justin.tee@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paul Ely <paul.ely@broadcom.com>
References: <149a576a-6a21-48c6-b121-b20c6173f7cb@web.de>
 <20251230062008.1021449-1-zilin@seu.edu.cn>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251230062008.1021449-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oXjKfTMfh0GAPiw6WjVSO43D1L3a4r6wQ3VwHq5eX/9gwZPf+RJ
 AjYBD5tNHsnX6O69HBO3N7k/Fk2SMePjB3eV7dcTpttq5xqMhePqSq56dix9cLYSdS43nnZ
 ya7+86hDEujvJn5HnqjsZZvisZuZmlCUrDAyum2rSkcUaJ3fpqnRHDoN5AdQ5GhmNTlQZgl
 sKWald/FUKO3+WAepnP7g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ERz66Kfr+YE=;CBQYwhOwtTJBowAGKoPQkeAVfgU
 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

>> See also:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst?h=3Dv6.19-rc3#n262
=E2=80=A6
> Regarding the stable kernel rules, do you consider this bug severe enoug=
h=20
> to warrant a Cc: stable tag?

I suggest to take another look at information from previous discussions on
severity filters.


>                              Since this error path is unlikely to be=20
> triggered during normal operation and the leak is small,

It seems that basic data processing was not hindered so far by the affecte=
d
function implementation.


>                                                          I didn't think=
=20
> it was critical enough to bother the stable maintainers.

The tag =E2=80=9CFixes=E2=80=9D is also an indication for related developm=
ent considerations,
isn't it?

Regards,
Markus
