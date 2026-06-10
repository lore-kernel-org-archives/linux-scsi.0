Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC196348C51
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781112559; cv=pass; b=loVRMi8M7FDpBCq0h+PFiX+af6NyJgfEAERweFuS7Ir0K+I58ZwNwGMgPZHjwOC4tIFexzRBTlykWSj89TvGSZXUbaX4wBwKT77cVgaKBdrgNr8DctU+zupBgOW8/oDrOwArTx+VEZAhVSLkBZiaBi1p0K88Le1R3Qyqvka+oUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781112559; c=relaxed/simple;
	bh=dZtPxZ7QvCP8QQ0yBF7ZU2Un31AenUtTLmqw2AbkwR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SeVjpQFiyU8CoGscCi8rb5wx94/ofQUvLOoJ0p4j4L9vPRXp2XW/Y0DR7JaU7UQXIs7xcGF67oFaQEmRdJfh+c3vhDi4uHT6KCX4B2swDnxa7XZNWSE6NuATX8sxgSy0bjL7OTteuI5BWWs0nOk/SLxO5P9GiPCL7PO7ZpmxfoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lge5Djye; arc=pass smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lge5Djye"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-91591f19716so854101285a.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 10:29:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781112558; cv=none;
        d=google.com; s=arc-20240605;
        b=gb70qSiNlj/Rs5WKlSUZIqbpfrMuGZf4IC30No8WGy+F//rH45yICuJ4F3VkPPxiUJ
         j7HLr/EjRNCR783B+mSPQT1xaz5xEqiUa7j0BdJxGp6tXfPoHwDB41yPetbWwhnxoAqj
         EJKZw+ONWb8QxP/Lww9dsFKKKB+bawfnnASRNpzZUipIPbgCyI+qihzJpNaa3WUh2TJ5
         i6nkfrPjv22cxspShcTqBSYDu0VDwqV4OJGb63ocFXhLDfr3JoVSVYW0AgYhltzXnB8E
         P1av2nXTWPm1eZeXO3RFv2vpvJFl1JWhs5fczEZPgl5Y2vUmNKDDbD2wIiGUdF1LBatY
         K+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YvcRBNwGrBXez69ZPOl81reRTKhIzImY1y43ld3hni8=;
        fh=UsFEpIfo2ci/QaMjGmquMwMwO0Mw6/JWjkLnYSCjhRc=;
        b=Jd4Muz8MAstSj8/xilYiSSKcE9kTi3BJjaUsaMosEUFlH48S2oYVbYtLibO25bzxSt
         PBQCAq3dJA6Y5NArWHSaD3yDlK1hkEbvHrAZeDzdL6wt/HIUWFGj7GdVTXn5tgXRsGa2
         o3p7+xu/VwhwxqEXubZaUzBR3oZ268LeT/exOPGOvY8J1G4K6BWOwqcy+BnloYbMZvxt
         HGu+QVoh4PQg1V1sK+9w34o049+bBlpB3Ho/MzVTKM1GbvK2fpZcx1rJdJ7GjHO0QHlX
         wD5ydlbNPwg3lIFPhnHUrYGYGfTgjgp6NKoosOAzfvRDuHp4Xjdja/iRrsRAqwI/JR90
         iFKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781112558; x=1781717358; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YvcRBNwGrBXez69ZPOl81reRTKhIzImY1y43ld3hni8=;
        b=lge5Djye+DBe/ykOA/LaRSmTMgG9b0L6j1M+r5mkT9PwZn1LU42MJi7K6jAzq5tHjG
         o5WnT0IQAD1R3P3BctgGHyo5QchZl6YGJGkTforj3wqV/oC7hZjSXaL2SdkvaBaXU2iG
         iKTNuc9JF/ERouWZsn+fU6kiDSig7L/+fSIxtR0PD4YF6ZmKU9M4ivfJ2tXXvzT9mGEH
         hb7nm3t8qJxWL+YkEM8d6Ja6TPJu4Wt5oq1ZlFtOOwVfZNi+/U7KYEA1uk2QfsvlTjZ2
         NfQhezC9yAEitkBl5+O97wd+BcUJZYwVpxy+6ntOuzCXH1vCxL/hsup7R4k4y+DpoROq
         zGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781112558; x=1781717358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YvcRBNwGrBXez69ZPOl81reRTKhIzImY1y43ld3hni8=;
        b=D0h5dFssXSXpck0sg1PrDIGHwB1is5M5yaSXWZDlsE0Wt5K0uN9Z+NvOqY7a/13o/w
         OFMOqPdurSEfAshiSP9sCDcWcQHM1hWUVWo7Y826TZnwGrJwa5Vm3sH7za0yeTc2IvL9
         IwJXI6Ir3Ng7ap6Kuw10UZsbx15Hwh8x14iQ9gZgTy6jmO9GKf14mlv/koSNvVYiEDUo
         ijfa5/KQVuM39qmZDYPdzfz9U5laS82qt1dF2NisaGjnCAFtbP7rKuMhqBcsdT2JCgBD
         eUTcliUwhUW13aeV9y5DKLCuFwUwTvEZnesVbbkc9xcvEN6NNLkPjE1fFxGst7YgeUk7
         ySmw==
X-Forwarded-Encrypted: i=1; AFNElJ8H7Sd/ACScYrE1Gkuk66lgLJdON1IITO4i0okVSRJe/NL5dQ9tjbSWiHyXNxchVJV/fHlvfxBOWTCp@vger.kernel.org
X-Gm-Message-State: AOJu0YybqtZ709suhks0Oyj6CFaMP1JOrw6ytrQ1/kYXASlQ2hStGKps
	RBGylDsxOg0RQmCDRP8ZfYzoMZbTIYuF+sT9KER5bZazmY7U/6pg8w3ARoah1AUMz/0qrpvvPA3
	4SlEF0YnZihlGrnd/5XqJFx+KUItWNoFqLuHYdFI=
X-Gm-Gg: Acq92OE+s2+H2QDpkuqQUX6FMfkN1Us4z8nyUMSR5t2hLkrSrJkIbwbAzhhu9t8gKQK
	hm6JBVy/kw8C6MTFeREvQyqLGrMqHkHuBxL2R8o4yVCriA1/s2reRUT3JuuMO/919rvaO3sn4LQ
	RXXoGxCPbCp54REgjs7ItQdTbh2QSpLrceNiZYd6Boz5aQ58D083WllWtd8VDpSINgKRO3c47a2
	zWvErRF7qJyrp4c1WvRLIc+FbEbHkJrVQJlsTMX+TY1/j983ja7wYQDJJmVSMDTITjwEFNf8rSK
	wpn1q7F1B3LeVqc3JY/9pPXCzeXn/eY04gWkfbyYtKnEwUFApXY=
X-Received: by 2002:a05:620a:1d01:b0:915:9e84:85ee with SMTP id
 af79cd13be357-915a9ca7655mr3990050385a.15.1781112557739; Wed, 10 Jun 2026
 10:29:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610114120.3748526-1-michael.bommarito@gmail.com>
In-Reply-To: <20260610114120.3748526-1-michael.bommarito@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 10 Jun 2026 10:27:27 -0700
X-Gm-Features: AVVi8Cf6zx6NBJB4VzYXKUC0RH2Yw7GxC4AbEF3c7mLb_BtSx5NBpesjROBhCBM
Message-ID: <CABPRKS_HbtV5vWx5nHT9rwJV4TGmOPj670yUuLK-Hd-r6TBF1g@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: bound RPL ACC payload size to the response structure
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Michael,

Thanks for bringing this to attention.  The RPL ELS command has been
obsoleted from Fibre Channel specifications since FC-LS-2, and there
are current plans to remove RPL ELS handling routines from the lpfc
driver entirely.  Therefore, the issue this patch is trying to address
will no longer exist by the next lpfc version update.

Regards,
Justin
