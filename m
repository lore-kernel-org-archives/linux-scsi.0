Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56C225B09D;
	Fri, 10 Jul 2026 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783706436; cv=none; b=EQeqJx6DX1kwUTyyk5lqVNXbnikg1eTdyGKYEw0BbFQVOiV2DTGEWcHAeEQ//MNvqJi89D3J2z2ZNhqQcwl/jevcu3qGnGL3/qJYMgZC6OVE9Hep33fxDoy3OXMoknw31lo7X8v+7WC8WZGNZLyO+kA+way8NZYtHCvWyOJtTLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783706436; c=relaxed/simple;
	bh=X8MoT2l8Nsuba6Q+qZ/vp3bRgt0zWyj8n8NBTZvy2yI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=XMIHc6LrWfMh9jPN/b6mXyRmrySz3B49TmfG2rkWCldi9jjZDCK7dKYpndyjQZnfiPFEON5/YkJqaPZG6BJ7D/hFzbezcY5SCYfkVJ5asjyE01TOpV8K7EvjaybNuGJjoWhpj9cfHh4NF1LQHKn7oavmrWNxbdcF9z2+o/oea1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=T1kZ0kLj; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="T1kZ0kLj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1783706421; x=1784311221; i=markus.elfring@web.de;
	bh=7Wrb4+TQ9BMKTwTeWMYP9Y+NAxhxyHNn2bZG60kFM1E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=T1kZ0kLj4jigwncfxtn0mIvXKGQBBT8/1onoTBYz69hyLnfJwSiZ07UziKMbwCbS
	 DUqrrbAN16UYHiVfcaKxcPw+P6oxRm/10GD2QH2w48cMCPk4N5qNm9Yr2U3ZJnNtO
	 wrsoDHCLW2G3UGvcuxn7+8ar6CAiA/vshYx61kbHqqHBj5nPSIb+CBKgmZg1Qy3II
	 SeLgfq4ZgjHLL7JCuGIjeQWqOnDX9xEDNSPfyv3O61GvS3q6UMY2FIRtDUTcd4/MZ
	 +vfRAlF1hkLAwwpUO9WPiFaZ4xC2Qt4m5CYEsn6C9lDaigAYqse61ieVT71h3IDiB
	 NtsibIRZKhvsou11FQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1McIki-1xKtj72EUW-00fA6B; Fri, 10
 Jul 2026 20:00:21 +0200
Message-ID: <e9ecb5d3-cb77-43b0-ae75-f15a28bc86c6@web.de>
Date: Fri, 10 Jul 2026 20:00:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>, linux-scsi@vger.kernel.org,
 Justin Tee <justin.tee@broadcom.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paul Ely <paul.ely@broadcom.com>
References: <20260707065304.949135-1-nihaal@cse.iitm.ac.in>
Subject: Re: [PATCH] scsi: lpfc: Fix memory leak in
 lpfc_sli4_driver_resource_setup()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260707065304.949135-1-nihaal@cse.iitm.ac.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:14GMndEIsGNEAvNTIUmT7ePgkRDg3GhXYRoj04nnlqo3SXzHCtd
 up7lMF7sS1G/Sjg/1Avi389Fttjz/55nBW2tLLx+JaZFwdyetCJee2sr0baaLLmEtdbGldS
 j2taE5ZtIQtTab2sxx8OnfluuUn4mp/2fFUrv5Ntw1iVJVEXYnn0srGO/TJQ33+OxNQrvsD
 fc4NXk531ngsYTpzDkmFg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xq1iVVYnmAo=;G12U0/r9qZaXLa3tW0RY+LuUJzx
 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
 BgScooIIj1g4wq17HaNPG4TIWWg+zp

> The memory allocated for mboxq using mempool_alloc() is not freed in
> some of the early exit error paths. Fix that by moving the
> mempool_free() call to an earlier point after last use.
=E2=80=A6
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8189,6 +8189,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *p=
hba)
>  		mempool_free(mboxq, phba->mbox_mem_pool);
>  		goto out_free_bsmbx;
>  	}
> +	mempool_free(mboxq, phba->mbox_mem_pool);
> =20
>  	/*
>  	 * 1 for cmd, 1 for rsp, NVME adds an extra one

How do you think about to move the mempool_free() call directly behind
the statement =E2=80=9Crc =3D lpfc_get_sli4_parameters(phba, mboxq);=E2=80=
=9D?
https://elixir.bootlin.com/linux/v7.2-rc2/source/drivers/scsi/lpfc/lpfc_in=
it.c#L8180-L8191

Regards,
Markus
