Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4DEC8F0;
	Sun, 18 Jan 2026 08:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768723369; cv=none; b=eR0iWPTCrnJECfcfCP+9azhZwtaEYxIahSO/o/K+xuHpZ1mTahEsNUQFBYVNQFpAu6Z4mp/E2S5MhZuXjzj+7mc+UvcqjlTpX9P4eF+Z138+Rlbf5UN1bD0cmQlBDMA0XNV4uPw1gFjRJ0S3JhaQkmRTOxU7UhknPfFFDsZISZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768723369; c=relaxed/simple;
	bh=MSqVK7VYqE0yqGtebPM/690TIkhumbPQF2muoE8HlfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OaR4weVbBx0RJwXnYj/c/bmE8Cqh/9SIeFn0aLbGTwSorQ+3JcLOInQM1YkJvTdLwM3WpmJtavjlofz8iyYBQZXtJ4D8rn98gTBM0qNnQZ2auYYKw2T3U6gTEjVxFZBbZlzjKtjI+RTEBOgkjNdtXH7cR+OBi27fNfDVkcCrrJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=wOzT+Axz; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="wOzT+Axz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768723359; x=1769328159; i=markus.elfring@web.de;
	bh=MSqVK7VYqE0yqGtebPM/690TIkhumbPQF2muoE8HlfA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=wOzT+AxzyeB8T/0fFQlyMOGc4F9CAAnDe85aZUdXcjlBb79TNILFrMlNtrYZzT8O
	 cXDszCYD6aWu6442cuvYuUXefBL0ewUrxIViQX/mzUwK8aexN2yIimyOEvPdTQgQk
	 vyn+NIw0xc2f72eeHkM7ADVhOZFrs+e4QNhXJRHUdp6LRopfxXBj+VecUw86TrJvs
	 +eRWqzv9MFI+sCpFtdT2ZU1nn2bGnzTm+JvHnO+i/WuwsVJ5Vty399HYe7wf+lDIn
	 gr6BY8lf6R6PyjfV6MWwdCEMD60GBIi6mGyQyCA+/7Q32WCwCfBg6EnMfgZq3aKuM
	 2q5wlaccID/4/3xosA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.1]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MK56y-1vN7452ycw-00VKoi; Sun, 18
 Jan 2026 09:02:39 +0100
Message-ID: <2145b6f6-7dac-40d0-8e8b-259bab774de3@web.de>
Date: Sun, 18 Jan 2026 09:02:37 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: mpt3sas: Fix use-after-free race in event log access
To: Chengfeng Ye <dg573847474@gmail.com>, linux-scsi@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20260118053050.313222-1-dg573847474@gmail.com>
 <fba6aaf6-3487-426c-bc57-618c30644c18@web.de>
 <CAAo+4rWx=iipRqeSR2FRibWfbRHAR6K3xOyi8wETUubC2ZV+kA@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAAo+4rWx=iipRqeSR2FRibWfbRHAR6K3xOyi8wETUubC2ZV+kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lfrWu06desYPQyfLAyNtC23eGWhEEOQpHH+qQD+YxOhJDtZsYtl
 AyvdAwUfXAb8Wo/FQyL5/fTsJoCIf49Jcpujs+MmWAZZ0IPFh2kAUxe5LUqYHCaFbvi48LH
 tSPiOLvcVWByzbTQJV2jsph0KaFvwY0uisns5cuDQqjHEon8NMN0AVMrknx9vGiqHAaqHe0
 /5oFcf3u05bR4VarMYxQw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:m7EP6EkkfXA=;XJ9zSeqog5RCrfLGWPgOS76uLKb
 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
 7zca7K09byHMCALFhqdny6qQchzak

>> Would it become feasible to apply a scoped_guard() call?
>> How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D an=
d =E2=80=9CCc=E2=80=9D) accordingly?
>=20
> No problem, addressed the issues in the v2 patch.

Thanks for your positive feedback.
https://lore.kernel.org/linux-scsi/20260118070256.321184-1-dg573847474@gma=
il.com/

How do you think about to increase the application of scope-based resource=
 management
occasionally also any more source code places?

Regards,
Markus
