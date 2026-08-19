Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C292A3D0C07;
	Wed, 19 Aug 2026 07:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123966; cv=none; b=rRknX0p6Tz21VWFY+u1hdIZtS9cJb6SdilpjjF+aoYrAGvtOEs2TrJaYzytGl0vlCuv5sR0QJG3tvZnn0GzxZWXd2VJRhDHpVnoD6db3o47HOzyhyIwPPMnGgyUv4ymrzUVhqAXaw2Qpd4f/v6h+MVwtc1csKiQM5mloaaD88ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123966; c=relaxed/simple;
	bh=2YJGk+Ka4OQITfkedD/9HibRw2V/mrQ2UPvs52ppaU4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=b4sionzP/tQbn4b9OFgVq9BvqzGOEHNAbAeE3x6aPJYNLJvz+fhwxy7jM+ZSW9NfcwzvpnxitBBrhG/cFTfu0ftQUqeIviOsWEWWb++UWBrfsyrq1X316SXWiKswPLhavNxJOetWeSIy+zwgD7i3SPNxtQKIjP56sX7uEbMfKno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Y6SgdD0L; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Y6SgdD0L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1787123957; x=1787728757; i=markus.elfring@web.de;
	bh=2YJGk+Ka4OQITfkedD/9HibRw2V/mrQ2UPvs52ppaU4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Y6SgdD0Lm8OSyArMYR84P58hPQ2O6Ae0FaQuMMoyTGtPduFcmf0eVkRkS+MqjDCy
	 Dm3re+1U9piu9Por3fqoka0Upo1GHae2hrZYA7kbPdycaDvhEpcpXtO9uQbKdLxin
	 QiPUAzVCwn1oxG8qxT88MBrtgK7mS3vrESUTSVOoBJ4Lp4LHFKIXUd9PRhNCRlgbG
	 /TUYB94TFHG+mv+GX/9uc08aMceZwsnecbY53JShpDEIvn0Y5yqz8PLRx0x/K5vq8
	 TJRp+oV99cOorLA1AXLnSLFvanWwsoSXYjdeoehqI4+xS0LirGZDwkzPI860baSxW
	 3Fuv/s3cgX2+gPvvZg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M2PdU-1wyEjz1xLK-007N4o; Wed, 19
 Aug 2026 09:19:17 +0200
Message-ID: <6ac1f868-f822-486b-899f-7ddbbe166076@web.de>
Date: Wed, 19 Aug 2026 09:19:15 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Triet Hoang <triet.hoang.dev@gmail.com>, linux-scsi@vger.kernel.org,
 mpi3mr-linuxdrv.pdl@broadcom.com,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260817052619.810762-1-triet.hoang.dev@gmail.com>
Subject: Re: [PATCH] scsi: mpi3mr: Handle SAS port and rphy allocation
 failures
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260817052619.810762-1-triet.hoang.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0UrPNhTAOoy/9UrceMEBT71T39EygAJNCttJeHSRautj04jOVu1
 GUBXEAAiuHWcmVnpcZa/F8Z4RSs7tKtd0QAAxwCLkEEg1mTxxe6YbbiAsLGPvBl4jsjWk2s
 Xg6RYGZu1qwPRF0KH4o/lHXsFkDyqN6TvBp6IcWlDq+st5LlBnl37qiTSUxTxhTxRMDJhPB
 YDpPI52gq8MBEhMXNr8OQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+2keBSshgYw=;lKRmtfWl3v2g3ODVdLHadSHuvaF
 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

> Check the return value of sas_port_alloc_num() and handle failures
> before attempting to add the port.
>=20
> Free the SAS port if sas_port_add() fails. Also handle failures from
> sas_end_device_alloc() and sas_expander_alloc() by removing the PHYs
> from the port, deleting the SAS port, and returning failure.
=E2=80=A6

How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.2#n145
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/stable-kernel-rules.rst?h=3Dv7.2#n34

Regards,
Markus
