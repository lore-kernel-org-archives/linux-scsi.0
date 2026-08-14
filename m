Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129F7480DED
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786729873; cv=none; b=sG9lwqpvWFmVUS2RPE/s/FDnI6g50vG5kkFnzq6/jRcZ3KQq/BwbAzrzP51CGtERsY5nm4Kk4wtFj01cblBCVPvpVIa7MGpStpwl/yshBN+EBqbyP4m4g5PFYSv6yuH+VohH5T8q6ClsvEPHSXyxo63rdUh920Kxs1odOHujf8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786729873; c=relaxed/simple;
	bh=BMmk0tMym7+viEAbSql3mofBm0kxHpAm2sPAPX9FeDQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EQK3uq6Z0GJwNquIgcfTBx/rTQLTtpPfPLJulTBnTnyBnyc3bzIhHOXSpbJ9TOaSedGF+qJlSbYVL84mmNx4Tn0q6NU98JxWc+FzvzAB8kCcoTw3idWb7jlz1/7W/Gcf96LoEMsl4SEJ/6yQnacLK/Wusmv15FFRkJ05K8AJj3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+sxAeEb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=isOkYdpF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+sxAeEb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="isOkYdpF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786729870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/7J9iFZ/zyBKdui9xdbgNhSJDRiyBqfyVHmdu7/Up0=;
	b=N+sxAeEbf1Wrw6ogKZ7z3EA3b0Z/tcPTwz6rnqd41aXcqG64L6TyRGIch3GvPfZfiKwQpW
	1D3bK1VJxmqAWzoAhIDWPHaKpRJhTNWZJnQSWeV+hUz0/+pDsOr3nQuZgfoPhAXKDstSf1
	kVOzDVO4Nw+cDVa/JLSiBwlGgNyF3P0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-qkrgfHZVMfWyzXpkQCBtzA-1; Fri, 14 Aug 2026 13:51:04 -0400
X-MC-Unique: qkrgfHZVMfWyzXpkQCBtzA-1
X-Mimecast-MFC-AGG-ID: qkrgfHZVMfWyzXpkQCBtzA_1786729864
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93494cce712so148855285a.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 10:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786729864; x=1787334664; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=t/7J9iFZ/zyBKdui9xdbgNhSJDRiyBqfyVHmdu7/Up0=;
        b=isOkYdpF1fS2WiPG0Be/43BFARdJ19vsQa11kUxBI+gsUILThnL9Ors0MvRmW5lLPV
         CHqrOOLKun9tGk6ouaMk2Ov01qj/O/6w9tFaci/AktU3My2aDTkZfa5npZonL10YktcX
         0KR3muDyTzKwIsGZeaPtWTe8rCOiHffL2Rd3GB83qDZmmxCv/XrVXCw5krMeslOZ/wWK
         fuQg//d6v/RI1VOoW8AnZU2mFoZaSfewqwIxwAVrgk1eVGcJeW964yRQyBeUuKs1pyZw
         hYYjxgeAgQY+rr7xXSKCmuldF1E1U3Sz3WHm12UCgsf2QN95kLXdrWbhzoWNGTXqSFXS
         AYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786729864; x=1787334664;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t/7J9iFZ/zyBKdui9xdbgNhSJDRiyBqfyVHmdu7/Up0=;
        b=p9eImUwDyxcbr/JtKULBauLwMeAgAFKo9lbHaKHB8NTIV/UPagg7QRr4fEzGgkUBAc
         CTnkSyPyfc0KAhDqymauezq0PfvLCM4NrOOd2X2+3XFRdfVm4s3D/uX8IMqkL4g+8EGb
         QJDF/rzxqd1T+68GFGsTNd4N6mIgFr9Y/ODTuqm/j/mYprMWgmuzW25CPXDBaSvdpIaJ
         3xdnOcA8aENKyTfbS9D+mL6UCvXK2tmzfumFuF0LVgYumVnyg7MDp8qtQTFxuo2QcSU6
         6Hsas1LGDwWHxrc3GIHttWx8456i0u3TnuWcNc5y5Z6xVO5axB1YVzhnzdCl6H5aF/Rt
         wh3A==
X-Forwarded-Encrypted: i=1; AHgh+Rp+hl4c0PdQadIwLW/C/N8WmPp0wLw3srSayA3C5gdaHQUhL6fiJWRDrHiHzF3IvRzo1BQcNRpF9FHo@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jW5bxfGVw5m5OQMvaQmrq6LixvdSIWD0xJtTsJ73l4R9H30Q
	NoY/kGHtmTCTq19P7Rsq0E4qS5XXNcmvFPSBmSTIOU6OBzEIGp9LBY1w95n/Z2wlvTBsrVme3X0
	NA8vrkDp3KQenze53WgOksOH/GPRDwrH1NLetV7l6fwnS+9+RGuPDUxmUJ+d8MCw=
X-Gm-Gg: AR+sD13z4wVaDmYcI5Ly8GdqgJ/mr22LEsSXvU+/d6dmZWr6Y0U6z0N1TJMM4gaiw8x
	4Vvk5gARFJcX2P0PqLLvrnzHPpW8Ii5puh9xfa9SK3QKPtElNAC+4YXcMN7cYpbqfsSS3940aPX
	WKmN8sQg2uoE3demOvdHtAMpbEcrwco/bLaqcOpLpw9i8oEEz5MAMeo9r/jgEJsEGRuz9oiUeyF
	xUOdHMUEWBLqB/MuuHmCdH5CUb/giosCA/AvS0bc/N+S7WzGpa5zOFMsRjEtXetqtlt/p0vybJE
	duS6RH2nYdCNKLmJyxlQrjHt9EOTbvSe99xaSvAVPGCmo806lpXj6IUJya0HJtPLlfAQsCwC00v
	q170KnMoBp6LtpP5NMK549y0Ijy9ATT91yJMF
X-Received: by 2002:a05:620a:2810:b0:936:e010:5099 with SMTP id af79cd13be357-936e0105466mr332198885a.44.1786729864097;
        Fri, 14 Aug 2026 10:51:04 -0700 (PDT)
X-Received: by 2002:a05:620a:2810:b0:936:e010:5099 with SMTP id af79cd13be357-936e0105466mr332191485a.44.1786729863542;
        Fri, 14 Aug 2026 10:51:03 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936ce217c0esm331252985a.32.2026.08.14.10.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 10:51:02 -0700 (PDT)
Message-ID: <22ff0bb82c0ce4ace458130d50fa090c0a24557c.camel@redhat.com>
Subject: Re: [PATCH] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL
 buffers
From: Laurence Oberman <loberman@redhat.com>
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>, 
	linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Ranjan Kumar
	 <ranjan.kumar@broadcom.com>
Date: Fri, 14 Aug 2026 13:51:01 -0400
In-Reply-To: <20260808151010.185603-1-chandrakanth.patil@broadcom.com>
References: <20260808151010.185603-1-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-08-08 at 20:40 +0530, Chandrakanth Patil wrote:
> _base_release_memory_pools() unconditionally frees every
> ioc->pcie_sg_lookup[] entry, including ones the setup loop never
> allocated after a partial failure, causing a "bad dma" warning on
> debug kernels or a NULL pointer dereference otherwise.
>=20
> Fixes: dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
> Reported-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> ---
> =C2=A0drivers/scsi/mpt3sas/mpt3sas_base.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
> b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 79052f2accbd..11bcb8440e1c 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5870,6 +5870,8 @@ _base_release_memory_pools(struct
> MPT3SAS_ADAPTER *ioc)
> =C2=A0
> =C2=A0	if (ioc->pcie_sgl_dma_pool) {
> =C2=A0		for (i =3D 0; i < ioc->scsiio_depth; i++) {
> +			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
> +				continue;
> =C2=A0			dma_pool_free(ioc->pcie_sgl_dma_pool,
> =C2=A0					ioc-
> >pcie_sg_lookup[i].pcie_sgl,
> =C2=A0					ioc-
> >pcie_sg_lookup[i].pcie_sgl_dma);

Was also tested by a customer, Given the Sahishko analysis was
responded to and a follow up patch for that will be coming:

Reviewed-by: Laurence Oberman ,loberman@redhat.com>

