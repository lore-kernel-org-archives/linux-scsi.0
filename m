Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79756341660;
	Thu, 29 Jan 2026 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769695719; cv=none; b=nw4fYNTBENAWk4+d9u31nU6dqEkO5CswFVxmvwx9fb3XGQyq/uI5B6fCfaNYO7V4QaNE55hxQASNcsBT3C/sgWdS9gNFF9MfnvPn3+/RxxXt6xruFgFVDXM9Y3Al30sxxewF9XDKs1Dl4OK+vi5JEP1tpHTCDrlFSArZJcQsPMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769695719; c=relaxed/simple;
	bh=ihJlG9qUNlcUAuX2ockYsdNK2zJsa3otehqDcA+4/wc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=B1qQhoD8tr268IvFs9bHbxPTmkK3tTZM6HRhv575Qst2pcCo/op7064q0PW60FBDH1KTcBaZXkouxxbRVMV2bVtkLxNnd+L66ZDYHUd//9UuIgIDhdLnlktTxvPLO/VrSXK45Sxc/6W7ve6F+jTPYgmnmvFRbB+1Qf/9JQqcIUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=CUKlEBax; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="CUKlEBax"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1769695713; x=1770300513; i=markus.elfring@web.de;
	bh=jTYYn0MQi71YcdkOXOO3u8uXdB6IcPRey8m8jSJVOOg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CUKlEBaxEG+zCiIp4O+OzwW6KdTEv7+aa+F3GIia4Ux6rLBRw0TFmrDK0KT4J8jS
	 kCpzYH8/pBiguG0nYYEjGr7nUBGgdViEUXw66KsJ7eulKj7jFnRLbHP7FKPUX3GEH
	 JdlG0DcJOB29HZPfHuXRXpspfFR3q1YL4XR9k7qzsOdEASZGLhpn52XE5Wd4mYQ5d
	 uKiawCqFlVd4+BTqxOOCf/oHGRI1EIuW382k20sj5UVkhjv6rxxbH+rkhV6kwNchS
	 Vyky3jOclEvh3pFYNIp9V837BX0uazqW5fZO8RbpNS9h9Z3/GbTrz8RtMBoVGUnn4
	 y+gXGF1GqGxY6gsg2w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.239]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MPKFD-1vO20413UL-00YFUh; Thu, 29
 Jan 2026 15:08:33 +0100
Message-ID: <f5e18b32-1d25-4286-b869-e3cf7d23e52d@web.de>
Date: Thu, 29 Jan 2026 15:08:29 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Thomas Yen <thomasyen@google.com>, linux-scsi@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <Avri.Altman@wdc.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20260129070657.678532-1-thomasyen@google.com>
Subject: Re: [PATCH v3] scsi: ufs: core: Flush exception handling work when
 RPM level is zero
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260129070657.678532-1-thomasyen@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4PgqTlzRFr96HVobjX2v2NCxtW56g9e4LDF7PsLf3Y84lwZvbsr
 fzKiLa+bJq90D9m3YEgTM6J/Z2Y7YxzA8lKNUgXEkIrwwBe9m6LwZYvBeJHYRukdRmzqubV
 7WFfk5E8A+Rpx/yy4fOmwY6PrDuZt8RzG9C55VEJprli4rUJV22azHI3DF5XtH7ddbj7HHj
 VKd9rCdggZp3tgfqqLoNw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cNDSbYtYhlE=;htgEm8FaKV2s+pXLUVw45tXgrfy
 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

You should probably specify message recipients not only in the header fiel=
d =E2=80=9CCc=E2=80=9D.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc7#n231

=E2=80=A6
> ---
> v3:
=E2=80=A6
> v2:
>  - Add Cc: stable tag.
=E2=80=A6

Will the tag =E2=80=9CFixes=E2=80=9D become also helpful accordingly?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc7#n145

Regards,
Markus
