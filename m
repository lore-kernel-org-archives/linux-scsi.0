Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382FB199E86
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719505514; cv=none; b=sJFsE9/b3JIzSFfpAXfIsABCMRyRCXiyfs1MZNPdtaQrNbeS3n6aIoiHPsnRl0CPVXzVfSexm83yEEYPh/hIbohdoTTIh8/tbvot4L5mzS5QswbvGyk8c7dlxDikjMhPIN/e9UdQedkEcni344gn1P1QTHU7fVnCQtMalD0yy0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719505514; c=relaxed/simple;
	bh=hLx8WArUxXx3qhCs4BRpP2LFNSX9reuwJkVt4MOobC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AQmiznxxRVl7jDGCSZYB8M2cBZo7Fa01CHUPQJTPQypZIL0v3s54rhyhijzAnb8pEPxEqt5TEeLLX1ckHvMhuFTnXZaelSLVRNrSs0uXfKFgIzMdsrmyHmbCsAfV9n+3TMvEzXFc784kyUZvYpXCWPwwqd9H+WErRjlFLpOW16g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CiGjW1sN; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CiGjW1sN"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W93nh3fXVzlgMWM;
	Thu, 27 Jun 2024 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719505511; x=1722097512; bh=z8oXFfyN/R3jQI7jKAIY2c63
	FXp8WFJkiaCdCwbB6sc=; b=CiGjW1sNU+RYByleynUwvtlnD+Ap/v/ASJ4C/A/E
	J1cUPkkZOs7E32dvWIV2HgwViPNMc594pM7i4CdR3B1j+4OtmdmsEpj7Zltw8q+3
	4w8p9hXLF/YnE8S62UqC9LSVyRnjY63bcHraN62KNNLi5x00zFNEm9SD4yRbsV+v
	PATjKyE8M+KQjPgOxol1vrjbEJU8p99vLo/8J/iAnePxLdaPJYCZkZtwf/pScSBn
	TS2U3O33ozDyJymt/eKo+ghdEtWnW6k9FE2+MfBgavxFTk9B0bXwGZ3mHqR2zv34
	Ojf7auukqEP7LAIDsXltEnpW/cinYMJd5HXmzZv8iJVW2w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tjX62Wma6dJq; Thu, 27 Jun 2024 16:25:11 +0000 (UTC)
Received: from [100.125.79.228] (unknown [104.132.1.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W93nf4175zlgMW9;
	Thu, 27 Jun 2024 16:25:10 +0000 (UTC)
Message-ID: <2004249a-7130-42ab-8264-78f9c418bef3@acm.org>
Date: Thu, 27 Jun 2024 09:25:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Remove scsi host only if added
To: k831.kim@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 =?UTF-8?B?7J6E66+87Jqw?= <minwoo.im@samsung.com>
References: <CGME20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
 <20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/27/24 1:51 AM, =EA=B9=80=EA=B2=BD=EB=A5=A0 wrote:
> @@ -10638,6 +10639,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iom=
em *mmio_base, unsigned int irq)
>   			dev_err(hba->dev, "scsi_add_host failed\n");
>   			goto out_disable;
>   		}
> +		hba->scsi_host_added =3D true;
>   	}
>  =20

Why has no "hba->scsi_host_added =3D true" assignment been added in
ufshcd_device_init()? Isn't that a bug?

Bart.
