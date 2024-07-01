Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE8022066;
	Mon,  1 Jul 2024 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719835977; cv=none; b=QZOtk1Ks0u9irXa8GhpIvs++7Zng7fHL4LHm0gjq3LKW4L5yFZUUe7CAN/OGRje1oVSiXoLkT5Z/AF2WSf/i0U1f9J49jTiD7Rxqj6JKA115P87RWjefi+oghxIODLTn3rv5mvNoGiP8vP5Fl9jHEu8wjVr9TdEjrtR4wHV3a6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719835977; c=relaxed/simple;
	bh=8pqS8Ajx7jf3KVnlDFP3xFvmDy2FXwv4PylF1RVd6NE=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=Vfd7M+FUYuTxVUeeFtAdqCo5bEQvOFoONOY6ttWs/wS3ElOR/UufJ7AfTQSDxaHGpK3+fy5ZrGC/HTjrAMhdDS5eiELaqQEdvY0jyhEdXgWThLMsZKIHaG6sjYhcEUKoIfQbgFCwQXjSkvfnJrkt67lTBAnZDriyQ/2kljYSM+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=XRx7kIbL; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="XRx7kIbL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1719835958; x=1720440758; i=markus.elfring@web.de;
	bh=XDSReHTPBLyXmOEtu/8phohbfWHRG0oRy8C/Bacjz68=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XRx7kIbLjp4eiM498TMXYizXVzt5i8kPuWyyqjYVx1jSzmdnXaWjvRj7G4x6lu2U
	 a0oIfBdwblYVjgXVxNPmGY8VPMJg+uSfZFH0Phd24KTRHsC0yhTTRzf7KJC+RY829
	 cHaLeh/riOVfGrRCiec8427W9zZMjVGf+6IJBDXl8tccqJL/iqSjdeJMK8xsB//4V
	 cvkC1Do6TE+94MR0PZTrHC5fSsAYX/+3rBO9tGx0gUQRwIuVTdtlkBHolR2J4Rys8
	 kbpsDTVxdCzaJwsrZ5GO5w3wC09uTvZ3Ijoq3gRQ/I+bmSwuMTW2jhlb4Icz9i5oI
	 ZdGv297qe0zGkoaf7g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mho04-1rtIrG2F5k-00pdm5; Mon, 01
 Jul 2024 14:12:38 +0200
Message-ID: <e751f992-0510-478e-a714-6299e8650333@web.de>
Date: Mon, 1 Jul 2024 14:12:33 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Haoxiang Li <make24@iscas.ac.cn>, megaraidlinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>, Suraj Upadhyay <usuraj35@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20240701034102.84207-1-make24@iscas.ac.cn>
Subject: Re: [PATCH] drivers: scsi: megaraid: Add missing check for
 dma_set_mask
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240701034102.84207-1-make24@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nqlPM28yXVNsz2mN0+RXvs0BOcKP4jxoTiJxM3Q01MTetMb/Xy3
 9W4NHHocBl5b3PtGtgYtjCAaDVrDrwv1lJOgr1R0fSKFrKcOhkgp239EdGn5NG12U7taEGS
 bSmQZHlrUChc5MRcdRwmKwbt64hK+aih3Ty9w+FH8OzlTqwmrnWKeqZUeJ1MOPb+uf4Ue7I
 Ne9B3zXUN8JsPO65qYtZg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hQ0MFYfpSRY=;t1qNq503LNmnGomSGZAJriFOe/9
 v7osqV01ZPMeZVp5Asc0uLWDxoELqqTgvIbRmrFZvARv7jsKYAKq64b7E/SyDQJrLWmkQmZPe
 fpiExYCMRVF2z6AMCSuCigQuEJTXrqlYluhtAMw5w9F4bPeR+fV9ujscNxfrwsae8eVCNjpB1
 uZ/wseZM54n5Jk8EDWuxVCTJjWT4Twke3ZAYu4ChbGJTYPw8zQviPNbDiVKcNjhURcrxhxWgE
 ehIhh96ppeHRknvC8VAlm8ccd4UIzkQDe0NvfOP9lys1fL0CXJjXYM6s4rtDgMVukKup+2V7x
 LhJD5xxAsS2ADhhyssi8hroD4Ug3XuxGFwTMjvd8QIbCPJWYT4p0N1ydfDtFSJjKd7yIQ4m+j
 AJ8xlBNQclctvrsXb5hwhb5+/EcR3QrITaHGKshgPhNaojggYyA2jnanJqeUolXvItMTG/DtN
 Rz+SnnCjbXG5faTiRg+DXYMcvmK/Q8JoFaNpV4A2DfQMiE0WetIgAT8gNtRZzwa394IYOOJ0g
 tRkMP16vNfOS5tQuApdebE7iFaVKkEjyAuKMF2ejDYCoLUSCEqGBNzZEUrZQSgC+kcZ9J3aDy
 /D+h000U94dm4ySMaVewLB3/Ci1mohXkXNqnfXoRCKzrNHJ5Qq138LAJjVtPXWDHFkW9FItkq
 gxOJuJs8YqGBwhRbdQFT5rv3Xp5VPz1Fta2W/ZT7PDEMntplGFXxHQvDQmI5INfFSz9SQOhsa
 pVDtin4Trieyb9tOlPhT0SxeAdd9/S+pIDZrFLCxpu59mYb4i28sj9N6hnz3qZFDEMThh1rWX
 hzGkp/v3qgOVAME9lrssoPv648HTiuiVA9bBNSbhxGbvU=

> pdev->dev cannot perform DMA properly if dma_set_mask() returns non-zero=
.

Can a wording approach (like the following) become a part of a better chan=
ge description?

  Direct memory access can not be properly performed any more
  after a dma_set_mask() call failed.


> Add check for dma_set_mask()

How do you think about to avoid a repeated reference to a function name?


>                                  return the error if it fails.

How can this happen after you did not store the return value (in the local=
 variable =E2=80=9Cerror=E2=80=9D)
for further usage (according to your proposed source code adjustment)?


=E2=80=A6
> Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>

I find it interesting that another personal name is presented here.
I noticed that some patches were published with the name =E2=80=9CMa Ke=E2=
=80=9D previously.
How will requirements be resolved for the Developer's Certificate of Origi=
n?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.10-rc6#n398


How do you think about to use a summary phrase like =E2=80=9CComplete erro=
r handling
in megaraid_probe_one()=E2=80=9D?

Regards,
Markus
