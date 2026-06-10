Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351C732E12E
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781112758; cv=pass; b=cgZWA1GfTNzK2rwKU/h0nDXij6hF3vpTOayQwK/Ro3fD50IZ2nS6phCMazB0h9XyiBjSP4m14s21hmWeuUKlBNrMaaO8+ZQeaYmEVKdWA3txLShkbeCRsgjYO3zvNuE5pdCXPJBjCx+b5nTx8Mr8kc59RTNEtEQhfb/qFSgid1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781112758; c=relaxed/simple;
	bh=pv27nD72m+0lU+Zg8Sfz05ZN+Nn05pr71ShMvkiRWec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=niSvW0ftxJeBQiUpjcn+q+IygrDA56E+t6fS3b+bIW2lnBvYLoLnUBrVr2NO9Xwz6VpsMotpI+/Z9TCjvny2FnlyVye1JdJFLlClqKFmkDcUqJW/Y7zTvz8+82R+32Eqziy7dx2XJxGygcmFD+H733r7eFT2NSKn4XxOUQrFsOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KP7Dn7GQ; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KP7Dn7GQ"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7dfceeaf168so66933167b3.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 10:32:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781112756; cv=none;
        d=google.com; s=arc-20240605;
        b=PtwTK9dmt033aGqVWeIn7ohCwGi5m2prmTdj5rRo3egsS3PDx9RfTmiDDNy5CICB2j
         1hO27fDiokEMdmXizHeUuzZkrys0bE7citPDhoN9qvHuosjvyxGlHlyM7DcY4DAHmm4l
         /+iiIETIXs8mddDmYccFm7WqzGWGhzEYFntqXLR4JxOphcEW77qbO30IHKplXjw9IAKP
         q088fMCTr3Omu1wysajo6UFhZMPG4Dp5ihqTL4JbLlSJrOJg8FCEXMZjNBeCWCL341I2
         /goVTC9ZXAWiGmTVGbz2tkDUaJLvIYgwIhknIJ/ydXM55fCu/4bQNAAABxsYEup1/M/0
         sOAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TwPccAVt1qmj9UT4eXbvYpUbw68SGsfYYMuRUSdO1Mw=;
        fh=uX6OuyPaMcFxvbwcHRLbQktINC6g2jhTkRT8t8rxjTc=;
        b=MSBqDaqDQH/8ePA2lEzH6UGhOR6LNZyszOt73Cc6/LDtCNUWTybemoe9NKuAKm3olJ
         Z91Ar3Re5k48gyrsV3Cu13xIodsdcaVzR+3EzBer721PLPrh6RlWHv6Qolx6VbLHsN6k
         t6DDKM/fk9BO7YAfPGLgo4pCJm27k9PL30N9UtP+taA96L+GCPvU0dtct1ggpNNwsiDb
         q4t5/ctwqOjMxm+26IVxFYXeZugyBHlJv+kWlTCdw4ll/p9ykf8QJd8pMCKunBVeZaLC
         rQfUjYu0JHu5D6axqjBx0RXi1seMVEvLaliK/10kP1xB6XTfEzyYIllBs1QdH776E1NJ
         IhAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781112756; x=1781717556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwPccAVt1qmj9UT4eXbvYpUbw68SGsfYYMuRUSdO1Mw=;
        b=KP7Dn7GQBNvb471v+u4CUHwOVL5SvkytqQzQ7g6dm7yTO6JGqxI95SdH5pS2+P8HW/
         kE/Pu26RsRA5Gudt+TtWrBANl/gqH7E5hhy2tiFS/vOLkCdww4mMtOchzTSiq/zd7YaQ
         rTe/PebNxpzavdzds/3A2j4caXPCgRzexSiia1vGnmv0EsfOERiGEvfAQBVknXfVF82t
         zWE0OS9LOJBpAIeXu3QEczdsfvBQ1oIBXHc0QLKHxUm1mTMW/KYMZkCudsPegrtGwPUL
         FGk8I1q0j3+F3GPT5oEfpdLS5f4YObwvXCBxTJxeMN7XzNyOXUiLZp8cVQXczDGMA89z
         +a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781112756; x=1781717556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TwPccAVt1qmj9UT4eXbvYpUbw68SGsfYYMuRUSdO1Mw=;
        b=p/C7uTjpOjCLPTrsVeq1sJ10n8cfvk7FR9ltOj0MlP1UYLJ+Z+SlukL/szQlH8U1Di
         URxY9sJEg7MXdK0Q3rXYn2IXYRGysXkFo4JWA0UUSMfyrcaS5qwfwBy3IHeNu9WnLlym
         ALTrXyGWrw+QlWODms3jxniGIo4fc2XL3rGg77T11k0GcuLnFCoXnu6AR+59YPkh+Y8e
         Bt/74sefSTU7ZCH1N0UvG1HQT0DlzPs8Mz3hq9mb/d27XLow0aUA28yCxmhvsIA1CLy6
         qszQ/fNrCmQHDRID7Vb/UpfEKqkjal/JJOs8g+vANkk7zedQ2t2kx9lkX2jA1WeUKfe1
         x+PQ==
X-Forwarded-Encrypted: i=1; AFNElJ8QFS02MhVI0NXGBOcEVZ0QFynSSCyEUZSg0n4N2KOz28zy6fj9hnglgoOXNP6UOM2DgzbVPJZfcNWQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8T+bp/b2kpuXAwTJs92LsfZcw3gyYFKi7KIZrlEDnnsarFmzh
	KKpd37LmWSWhO9FC8GbC4839D7AAEJukI4v+yDy89TKQblomgSSNz8RsD19sRMUG6nyh7F8cLyz
	bCyMo+RFY553WPIn0N/Ej8IBa89/J4qk=
X-Gm-Gg: Acq92OEAea5w/+cD3IeDMZZHrqsDcpejI4PuAWF63GbqhSHrWirMf5sQBcZT7eFEutD
	ERk1KsK8mqHZ35y556sYOFHyV0mHFAUrO4CWRozisI4C3+GTp1+WPEgj1yTv4QuvqIt0DPgrb8C
	GEzy6y8AddZTFKQJ8vb8VpDubowWtAsmsKiwfA9NOOhz2NDi1rJWAX2VnGzQ3p80zuKEAxJYtNa
	6sgxB+14gHiEj0QZKdKynVIwZfD5zbenoS4YLx2iXUorCeWP+21XBN4RE0KTN8E7nqkzgc7gCHx
	D76qVojMEs/rgXWC3avbcLd7x7WllhnQF+YUT+uP5CAlOu0=
X-Received: by 2002:a05:690e:d45:b0:652:ddea:1679 with SMTP id
 956f58d0204a3-6626582c171mr122992d50.16.1781112756029; Wed, 10 Jun 2026
 10:32:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610114120.3748526-1-michael.bommarito@gmail.com> <CABPRKS_HbtV5vWx5nHT9rwJV4TGmOPj670yUuLK-Hd-r6TBF1g@mail.gmail.com>
In-Reply-To: <CABPRKS_HbtV5vWx5nHT9rwJV4TGmOPj670yUuLK-Hd-r6TBF1g@mail.gmail.com>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Wed, 10 Jun 2026 13:32:24 -0400
X-Gm-Features: AVVi8CcXqdpLUnD172xmFbgGPxwwTP7xSfHNWUNfDHYPtVKWYaJD2heVrYF3UV4
Message-ID: <CAJJ9bXxMvSfzttjiRATN1vkVP9-RyyH-P6O4yMwVJGcpZVOCFg@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: bound RPL ACC payload size to the response structure
To: Justin Tee <justintee8345@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 1:29=E2=80=AFPM Justin Tee <justintee8345@gmail.com=
> wrote:
> Thanks for bringing this to attention.  The RPL ELS command has been
> obsoleted from Fibre Channel specifications since FC-LS-2, and there
> are current plans to remove RPL ELS handling routines from the lpfc
> driver entirely.  Therefore, the issue this patch is trying to address
> will no longer exist by the next lpfc version update.

Glad to hear!

Will you be sending the refactor through stable@ to backport too?  I'm
not sure how this works if there might be reasons to backport but
obviously next+ are safe

Thanks,
Mike
