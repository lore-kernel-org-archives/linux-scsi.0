Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AAC21420B;
	Sun, 18 Jan 2026 06:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768716335; cv=none; b=n35nZeD4St5Q7yinAUcCIWNh/9ID8AmBC89cMiTdVdYsT4YmTO2yc5O6ZD3ns+tWkP8eDv6h37PrMAcRGnyB1033EoqjW0tVY8wcQBofL8QCy0r8OjNMeu9qlQL9M33KVVlVd1iIJgBXZGUKFDJh2yuJ/48qjRxpQMJRkx3ZHhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768716335; c=relaxed/simple;
	bh=6EuwmEz2nXIfd1dYdX0EgSlHeq6oWuMDS7B90IkRLFk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=I3LaT9cU65B2X3VY+Za++os1Bw1QXvhfPwTnNoEIPbU6JTcISMkj6crdfIE8a8FiWzR//jEI3GFLZOVs2n62igWa+3ErwsDVguDpVRgAlKvmLArbcWIJJ9G2FcW4KfWLqxsEPUn2U08hzSxz6IMcq8478c4Z8EG1j96P4qLpgpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=hZZPd1kS; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="hZZPd1kS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768716321; x=1769321121; i=markus.elfring@web.de;
	bh=grYMzd4pc1Tojxtbi+B7Ld4gtKO6qPAVyHNGZIUhZmY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=hZZPd1kSE/wbFa2i4Kq743SF8wp2cIa7kBXscA0x/UOhLOPmOnZW2p0zVfPDUCVY
	 pJK/uBdt3aI6ZdKi/6xGryg84855w0VUSaRh+EUHIq3VIj2NAU7zp1z3vD9Bb2evC
	 t8RvmaiptG6lZyDNvBAUFV6EpbinP+lZLtjA0Pgp7U6oeSn1GJzJCEHZ4WiyfxAjb
	 yEX8d1kVHHrOjqzb2YM7TN5yusG1Lfr0npsX1lq1GDFO8Lv3Q26bb+9krxdFoMSKT
	 +V5kxjwT4vZxaOkhe3Cl/3f2Fuf/wVYqDSmCksyCcV0lOMT94Sakv7NjW/Wh6bZ84
	 z42XuxJm13//h+NeZg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.1]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M9qhD-1vkuou0I7R-005mL7; Sun, 18
 Jan 2026 07:05:21 +0100
Message-ID: <fba6aaf6-3487-426c-bc57-618c30644c18@web.de>
Date: Sun, 18 Jan 2026 07:05:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Chengfeng Ye <dg573847474@gmail.com>, linux-scsi@vger.kernel.org,
 MPT-FusionLinux.pdl@broadcom.com,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260118053050.313222-1-dg573847474@gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix use-after-free race in event log
 access
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260118053050.313222-1-dg573847474@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rI9Nb/o9gv/5u8xaV7Iho2vWRIpvBgBjo0UgBrYArhROeQg8P1V
 GW0jP1LAc59tDtKEd24G6NyoY+Jik/hTAgOEuPMgQCEyDFM1KHoOI+iRBBqGRnbJQZwmZ2z
 0Gizo8FtBljolLPD0xqUNI2h27VIYAGrEy8q8E7X5z/0FbrDXQoF6lufUlO01IO/t+aQbb2
 It54/XeChky586TPpCEwg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wN8/54TPDXc=;Fr0BR8jUTX7f1lBHuR/7HrzbXfP
 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

=E2=80=A6
> Fix by setting ioc->remove_host while holding pci_access_mutex. This
> ensures the ioctl path either completes before removal starts, or sees
> the flag and returns -EAGAIN.

How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?


=E2=80=A6
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -11264,7 +11264,10 @@ static void scsih_remove(struct pci_dev *pdev)
>  	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
>  		return;
> =20
> +	/* Set remove_host flag under pci_access_mutex to synchronize with ioc=
tl path */
> +	mutex_lock(&ioc->pci_access_mutex);
>  	ioc->remove_host =3D 1;
> +	mutex_unlock(&ioc->pci_access_mutex);

Would it become feasible to apply a scoped_guard() call?
https://elixir.bootlin.com/linux/v6.19-rc5/source/include/linux/mutex.h#L2=
53


> =20
>  	if (!pci_device_is_present(pdev)) {
>  		mpt3sas_base_pause_mq_polling(ioc);


Regards,
Markus
