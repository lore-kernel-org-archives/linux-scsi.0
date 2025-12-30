Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2C32264D5;
	Tue, 30 Dec 2025 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767110509; cv=none; b=Th6wRr7l1x7frYuPSCeCIZOP9iGhL6fZ5I2gfKnH6ftt6Ari11u6JfyAt9GrzPQEgiORQjgzW14laD36XEJXrhrzrPyZdDTLtmY7VgoGxVwDPg6zjCuDk8onMFb8LNBbX4gVcXHI26TrJ+ZJVKIhsvE+snSISbEQ3h9oKbQbUVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767110509; c=relaxed/simple;
	bh=WapCiDDtQBSmoRDkytpYpWm2Qgf/MnAyGtkkvl3/w98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7nUbPCT1Uut5kE9o65+U/TEnxu3aXr+nF9WHaBDlFzTQ30HxCT3EBj6cScvAXokrQytaFC9pMXh5NlhtSq2euAAmtKnWD2O1EdAPBsjMz/cOSFQ7+p+gxTD0xZRqexoHHgJ/+L+b68dSJMONr94peczK5caMWkH4A/mFmut4BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ok5Ia5Fb; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ok5Ia5Fb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767110495; x=1767715295; i=markus.elfring@web.de;
	bh=FGjFaFf0HL1j2gePG7USzk85iI8oKvV0t/kLps5KE+c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ok5Ia5FbRpWGYmvrI0+RMjjimrkMHNtPvZ2qphNhjT+tWFvvFVjEK6XtymJqlJ+/
	 Hnv7RTmGUox4aTBBgDl3DgUqsD7FPW5PriS3Kz7fwTCtvvxg3LO7PI+O5wUkv1ne0
	 pX0XmyNZ6fx6RqRWgATJRrBnOIkPt2fjGXQnKR9F8LsyjZTqMFBkARWMsM27wqhHM
	 cBAEN59YamyHvxtf4A/+4FQovVhdFaiUGiNW3ZEy02RVlAp06yTb8vBPYCvhBf4FS
	 wNeC10LubnFwUfJRVazkmB8qUgh279bEXQqmYxhtMJOn/MfbyOhrlxl2gRd1n6g1G
	 RzXs7HCuZJsPfbbVVQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.0]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MwR4R-1vspKs0OI9-010KjG; Tue, 30
 Dec 2025 17:01:35 +0100
Message-ID: <8ab71d11-ef77-4181-a5d5-e785576c85be@web.de>
Date: Tue, 30 Dec 2025 17:01:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: lpfc: Fix memory leak in
 lpfc_config_port_post()
To: Jianhao Xu <jianhao.xu@seu.edu.cn>, Zilin Guan <zilin@seu.edu.cn>,
 linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Justin Tee <justin.tee@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paul Ely <paul.ely@broadcom.com>
References: <20251230145858.1356864-1-zilin@seu.edu.cn>
 <20251230145858.1356864-2-zilin@seu.edu.cn>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251230145858.1356864-2-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0p8/PbxCPm98KSQcX0JsWR7O/mmtKbydpOg3pCCpjbcvuzuuao1
 hO30undRQmT1hXrRyKpaVOyz0VLfg2gGS2xpt9zXROfU04S5pQ6yRWTJqwZcQGJvT91lMmL
 KieBHumfuGZZPCn4dqdP02vnRnYusym25M/+4WAg4p0CvDflpUSCsMidbooryyA+ziP5N4w
 SqCmb64cwvmEHi+0Q/P/w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:36xOvTcHY+o=;SxpIXUSNRIqSS31lb2vWBYJ0DHU
 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
 vrhJPl9A=

=E2=80=A6
> +++ b/drivers/scsi/lpfc/lpfc_init.c
=E2=80=A6
> @@ -550,8 +549,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
>  	if (phba->intr_type =3D=3D MSIX) {
>  		rc =3D lpfc_config_msi(phba, pmb);
>  		if (rc) {
> -			mempool_free(pmb, phba->mbox_mem_pool);
> -			return -EIO;
> +			goto out_free;
>  		}

You may omit curly brackets here.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.19-rc3#n197


>  		rc =3D lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
>  		if (rc !=3D MBX_SUCCESS) {
=E2=80=A6


Regards,
Markus
