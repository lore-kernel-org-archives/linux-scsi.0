Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91154C98;
	Sat,  3 Jan 2026 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455692; cv=none; b=mPpK1J526bsnCd08Ukvy5VMjaq8Bd9dwQmRIskzszudcqSqEh0l4wQCrBETEvcUELB9r0OgFSUo80axoaZZdMGhszVrXHgqToG2oaQjFuBjz6P00LwnZ7Lcm/YjCuzHMr9sleXCpZNhmzmW3NhxzJvPS0ekbjAihYhLCLzQGnz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455692; c=relaxed/simple;
	bh=WqlYf/6ZFoZDof1vuyXzapF6sFsIuMSa3aC5pkiFj6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N7uf4smetRUktl4pfwcny7NUC3Bai8R+1ii6GtoBHPhi7u99tgjWSJ4Adewr3xK9vstY5ME1nLENG/BRuwJsZ1jDvRvnCveTpQIde06UqpRE+SQGiKQhfvPgs2faXusBOrRoeQIAUeB9VmODyN4XH8OBO2JsfxS+LZ9IBEs44Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=jIJMlCNP; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="jIJMlCNP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767455683; x=1768060483; i=markus.elfring@web.de;
	bh=gUh+xBUu031SEfp2wN9qBt6ACtuXy88/uodMHeIu/cs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jIJMlCNPgN/KgUTFycfTIOaYyKHnls3dTYCQVxXNyQrRfsWiLYljU69Uq4HPBEYq
	 VunNzSb0atNfZ7vjrQvKCBsH0eMAB67QbfhInIqkIBwBJk0saIT7gUNtkrp5p51UP
	 qNW7UIBe0dlmr/JGakNaTxyF5JMuEp7PzmTK+0lQLlNEoVKnwtqSKRQT8l7EjYsed
	 ZFNyTLI+wpdUR8HfBj5GeaaNj06R+G6wBGpgzxpwbn3ACSLgYdjOE5/543+4Y/yFc
	 rVZ2TCUNiAMv0Q69qDGeAuj3xEqCzeeFs++X5Qpgfhf2dCzmHtuimHs6IugzaFNye
	 ptGqjjrARK6AaKrL+g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.243]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MrOdp-1wH7ci0IA3-00dnA8; Sat, 03
 Jan 2026 16:54:43 +0100
Message-ID: <3d1aa2f6-37fb-48f3-936e-95c779a8e7ff@web.de>
Date: Sat, 3 Jan 2026 16:54:39 +0100
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
References: <411ef9b1-ff0c-4f68-8af8-f3a478ca0d7d@web.de>
 <20260103152514.304387-1-zilin@seu.edu.cn>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260103152514.304387-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1Bq5WPJ+LyjXLyBk/tri0SlywIzezX30cN3ge/R7BxLgkGlRM7u
 9ZkoqFdFWDmdCqTbbVpaFWAq8wLDpmOOcVr1hZLpINGaVUV0lTztqik5WdMvG9bFsnd8YCW
 qMN/twYR19HaXv2Au9ng7y0A7MsPNp4KElw5m6i5wQRe5/iF+tjWQEyIVYSEYFvyBiHvHO6
 YSoDykpmqzrSpKBgyVRXg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4wCz/pf2jtY=;0UKp6ecM6cpv6OZQWpZjvocd1ih
 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

>> You presented interesting development ideas.
>> Will any related concerns become relevant here?
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/researcher-guidelines.rst?h=3Dv6.19-rc3#n5
>>
>> Did your analysis approach get a corresponding name?
=E2=80=A6
> We are aware of these ethics requirements and strictly respect them.
> For example, we responsibly disclose our findings (i.e., bugs, in the=20
> form of patches),

Thanks for your contributions.


>                   and we will make our paper and code public after=20
> publication. However, we cannot disclose our tool at this moment because=
=20
> our research is still ongoing.

Do the researcher guidelines indicate a need to point research activities =
out
in more explicit ways?

Does your email address indicate a relationship with the Southeast Univers=
ity?
Is the School of Information Science and Engineering involved here?

Regards,
Markus
