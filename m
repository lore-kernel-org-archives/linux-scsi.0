Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF1A3A1E8B;
	Sat,  3 Jan 2026 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767447058; cv=none; b=HrgnrY4DM6LOaJul6rkG9WVKxYv9+Pse7fp5H0c8grYs7+A5kKaUDiRISIRdC6Ka1cE006HZse1XKAUchlucZluP/0Pv1OhBrodup+hoV/RMWQzI0GNLLkAdeY+KbujVm/2VvYjyWuKBL6Hr99jxsxQFUFVRGwihGwf+PfWXHdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767447058; c=relaxed/simple;
	bh=QnGM5euO6dqjYH66QiqxUxv4P/4ORcIW9U5f9UByzYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zw0LDxQbzwEbOi5q2rNrrIT4w283hg7pf17tjkPgSYbpOuzeeb7do8zsQqJCgvk3Ba/39nxTCjlX8ee6tGXGk7nApoSV8mj515bDEahXsV2L/09xZdr/HsEmpcz1sJW0HDBacW+Z6OWNATaF2mj0e/qg/BoY1U2J/LLpn+4Mc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=HUKFWHVq; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="HUKFWHVq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767447041; x=1768051841; i=markus.elfring@web.de;
	bh=QnGM5euO6dqjYH66QiqxUxv4P/4ORcIW9U5f9UByzYs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HUKFWHVqNM2SMHE/eVhj1PJuEk8ghco1+mOU4FreTBF36ld0zTg8hC1/TfMy1DWN
	 gXEb30CgFkPJfwP/2xK0pHz2BNvlVIkv/b2zbpzhACWlPOTz5qIG8lVSOEu4seRdY
	 LCRUTpgDvFgK6eYWDs236rpRcXElXaP2AR8fkIbqFSx31wgboBpbZa2F2HEHe/gum
	 WMgzgM4hfsY7T6BJvwWTF97Q4ODtM+lt+Tiq1pkM28V0UiMKfA8bxNJhv31l8T/de
	 VWvBWh7fDEITFNXvI5I+rXLl5y6Yi6OE5/X4aCBBn5Cs4YmklDMOFMhbCPGzNTsmu
	 TU3/41CKJdZuArxIFw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.243]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M9qd5-1vYRLo25rx-00EH5x; Sat, 03
 Jan 2026 14:30:41 +0100
Message-ID: <411ef9b1-ff0c-4f68-8af8-f3a478ca0d7d@web.de>
Date: Sat, 3 Jan 2026 14:30:36 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
To: Jianhao Xu <jianhao.xu@seu.edu.cn>, Zilin Guan <zilin@seu.edu.cn>,
 linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Justin Tee <justin.tee@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paul Ely <paul.ely@broadcom.com>
References: <4e57c44b-24e9-408a-8458-845b0b9fbbde@web.de>
 <20260103125418.179210-1-zilin@seu.edu.cn>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260103125418.179210-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Pfbi43N75Cn8GIEqt4lj27g9i+ePCUMnzrSSPQ/91aX1jUgoZ3D
 xMDni8vwoFPsFBzNrdYkPh2V1hnL5d8fIJ61W6UJp3JAF4VLI342BpiXbohgmag9iq2Hb4h
 zUKWQC9sgPwzYCuzTzi6To+mffF7MOYqcyCVn1JjUCAfjWb9/cOWBzfkhWjbF3gvTlV7NOx
 YnmCoWlcSS+sR17Xrsehg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PFYRoCxNZFg=;Y0urCjQPcqudYPZeDrdIG33jGjA
 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
 NqqAbGJ8=

>> =E2=80=A6
>>> These issues were identified during static analysis.
>>
>> How do you think about to share further information according to
>> your source code analysis approach?
=E2=80=A6
> Thank you for your inquiry.
>=20
> I believe the commit messages in each individual patch within this serie=
s=20
> already provide a clear and specific description of the identified issue=
s=20
> and the analysis of the failure paths.

You presented interesting development ideas.
Will any related concerns become relevant here?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/researcher-guidelines.rst?h=3Dv6.19-rc3#n5

Did your analysis approach get a corresponding name?

Regards,
Markus
