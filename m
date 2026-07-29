Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE063EC81B
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785337183; cv=none; b=Aj5S9K8ngNldDQsH8ziiNqmh66ER41Ug4+SW3kayxiDMi6CQjtZHQIj+Sm3dA7Lv+5cX25DKE9o5JO0GPnjQbZQDmGfaTWyaYoBwfO8qrms81iVrHQPOyhAvhduG04XqnSHcZR0NUg24fhcY1uVvUJop6jNUCviaZm5/rVRWqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785337183; c=relaxed/simple;
	bh=kATbDLLCdqpse1conjZk4cBIASdZjMbUfd9aSjB8DAw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tvoQoltnaeVrEnnnHmiOh3Kn1iWUJe6cNoW6z8GCfblLo0+3Mh3SwITGp6dugUIWX8ipRQaiJvSaRwXbr45WRAdXk6Tg4Yub8gW5osnSQMSIaMsnvnjOPOwLbHzXDHKGwgl0d5p0Xv1CmNVb5a2qHKyN1lEPB1x9es2PZeBfBjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ja4hB9gD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ja4hB9gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EC51F000E9;
	Wed, 29 Jul 2026 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337181;
	bh=4m7LNs0nlUtZILCmqdWC3zvhvU/YupwQCR1H+0Iw75o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ja4hB9gDN6Qd44P5Z65l8T973RYdYPIwf9/OHJibnu6SWESi6A8updOFru/YD9Ics
	 1aU95bBRFgNJN/dmNdqIHW13HLK4Ji1xT1h1DxBQiCGpj8UgggeROuNI2x7dbwPC/T
	 fqxFw5AMD38sHOH/nQmhYSbA5vllsuGDALAilmv1LKqlgPEVyZJuAX2p3HxV5yN5C6
	 3qTy8izN2+of02mwLNjrOHAtu+lmwUD3H340wzwJtvGdJZ2y+TMV6S8r1bIWHI3vaF
	 4+Xi6gr7AjRjPDT2Je9XnASL6q+sBoLieJYRnIJXFKAHmjeOyizkhxMp5FDjZuuFap
	 EmJ34XgXCY35w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] scsi: lpfc: Replace strlcat() with seq_buf in
 lpfc_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Bridges" <icb@fastmail.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729144617.1388646-2-icb@fastmail.org>
References: <20260729144617.1388646-1-icb@fastmail.org>
 <20260729144617.1388646-2-icb@fastmail.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 14:59:41 +0000
Message-Id: <20260729145941.69EC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unsafe lockless iteration over the `pdev->bus->devices` list cause=
s use-after-free vulnerabilities.
--

--- Patch [1]: [PATCH 1/5] scsi: lpfc: Replace strlcat() with seq_buf in lp=
fc_info() ---
commit f8c11b7b237ed1d074a50074665c19f1c5567a78
Author: Ian Bridges <icb@fastmail.org>
Subject: scsi: lpfc: Replace strlcat() with seq_buf in lpfc_info()

This commit replaces strlcat() and intermediate buffers with the seq_buf API
in lpfc_info(). This simplifies string construction while maintaining memory
safety and silent truncation behavior.

Link: https://github.com/KSPP/linux/issues/370 [1]

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index f2cab134af7f1..8a795c65e3c3e 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
[ ... ]
> @@ -5103,57 +5104,37 @@ lpfc_info(struct Scsi_Host *host)
[ ... ]
>  		/* PCI resettable */
> -		if (!lpfc_check_pci_resettable(phba)) {
> -			scnprintf(tmp, sizeof(tmp), " PCI resettable");
> -			strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf));
> -		}
> +		if (!lpfc_check_pci_resettable(phba))

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to call
lpfc_check_pci_resettable() without holding the pci_bus_sem read lock?

Looking at lpfc_check_pci_resettable() in drivers/scsi/lpfc/lpfc_scsi.c,
it iterates over the pdev->bus->devices list:

drivers/scsi/lpfc/lpfc_scsi.c:lpfc_check_pci_resettable() {
    ...
	/* Walk the list of devices on the pci_dev's bus */
	list_for_each_entry(ptr, &pdev->bus->devices, bus_list) {
		/* Check for Emulex Vendor ID */
    ...
}

If a concurrent PCI hot-remove operation occurs, could the bus_list pointers
be freed while list_for_each_entry is following the next pointer, leading
to a use-after-free?

> +			seq_buf_printf(&s, " PCI resettable");
>  	}
> =20
> -buffer_done:
>  	return lpfcinfobuf;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729144617.1388=
646-1-icb@fastmail.org?part=3D1
