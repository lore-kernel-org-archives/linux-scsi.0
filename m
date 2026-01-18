Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44E0155326;
	Sun, 18 Jan 2026 08:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768725068; cv=none; b=FOLK9exM4FZsi4m6N4eoeSKfAUSXyHIU8BCEUkSzRE/6TUKQeQuJ3HXa6t0rtGXAzgAAtuWWcJHpRk1nSGx0i9P1VbB5WkYU9eoddAukU4zi9qn0HBzAPGpHbS8h1WtsrZyQUqoWHshxt7N8hauC6vN0zP8WIu4TWHsB5pxN/LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768725068; c=relaxed/simple;
	bh=aga8zgVFV/96QH9tqz5NORCGXO/SSH9L/ymRcHgi1gM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=DIlPamJcGv2o/ehKznkRDGRdDXeSFjb5xKZgjiiQF04czWR1ZeLGqvlu50SWFxBzp2DmGi+tkF6vMG3RBGo/4hvLyEqPCNxbG/z+VZheryA7Ib9c5ABuWVOnPwpK+DKKDzLxm93c7URG1qRiqAjl0HAab2Mm6dUbYQudXdk8lvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=FPgxI5Zw; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="FPgxI5Zw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768725062; x=1769329862; i=markus.elfring@web.de;
	bh=pTQuzTJRC0IN2G2QMAFobegji2tWMTsLzEwJfOXUWlg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=FPgxI5ZwfvaCn8SXSIQNlWNlfaNaXNc1hh/m9N8nAZhObOkAWxE+IZGQq6+EUaJo
	 iLAtEqUsqTBHy9pJkVE+I6ZPpGlfetAQtLVBs8KFMEqpdQ1XzlDzXcOOF0Z6jSYr0
	 vvFXNRrZIZZUCbUgF8MX6GIrZbuSVYMU8bn8EQeaIEOCJ6Cl6JE6wn0BV03zJXet7
	 G4RS5fLZDRTKBmNQj1HbfiqZxLG3jouYTG35SaWNlL3vZ+FcjjWGp+JclhhHABUMi
	 7q2zSbvblCBHTvlJz3rVw+WBzeNDFMTjOAP5aOgvRRp1+11O9mFzrxm0uj645icsT
	 kmdoi4IedlaASQ0R9A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.1]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MWQuP-1vK5kr0yZH-00IuEx; Sun, 18
 Jan 2026 09:31:02 +0100
Message-ID: <92c065e1-ff38-4e38-859b-ae67b60cba4c@web.de>
Date: Sun, 18 Jan 2026 09:31:00 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Chengfeng Ye <dg573847474@gmail.com>, linux-scsi@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20260118070256.321184-1-dg573847474@gmail.com>
Subject: Re: [PATCH v2] scsi: mpt3sas: Fix use-after-free race in event log
 access
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260118070256.321184-1-dg573847474@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lIaXPRKpA3oZNe9M1ciLvs6RmMlJLIxHfNwvO6viV9SmesYOsXz
 /5hpul4CI1toNlwGH4/9fF15yl3MFNv2fQa5oQcOlU9tLjjr3c9RlFv5/gQ9JjmPEuiQa03
 E33RJbprbbr7Zny9N8YFkXx0SZRq84tobnHtzgPbsCmj9I0hg0tYTXqN4/Sgrka31CyUPMG
 stCIUrpqFscLn4ROBk6ww==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:v7FGugGrfjw=;RcEPzSp06+M8gUfSrQYSnuJ/bfN
 +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
 IK+jFkMwdSTDaZr03N8h+YFtkFHOG

=E2=80=A6
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 ++++-
=E2=80=A6

Some contributors would appreciate patch version descriptions.
https://lore.kernel.org/all/?q=3D%22This+looks+like+a+new+version+of+a+pre=
viously+submitted+patch%22
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc5#n310

Regards,
Markus
