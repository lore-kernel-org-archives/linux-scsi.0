Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED4924DCE8;
	Wed, 20 Aug 2025 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755712663; cv=none; b=f5tcPswx4EoK04u44inaO6o5Y1XBCs8pjCVT47aQhHlfEpkFyIFnVlQL9NcTE5vtbVHVEBBwEsQtS8V/Cx15CwCX8dy0bXNzwHlnSVGnEPAFJ9EA+nhNKOYMKXiqeeMgD4xwl4/Ni2v/s4hIFVG0dRjAC6o20grKdQ54BHKebPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755712663; c=relaxed/simple;
	bh=YgOyd1md4yh3PvGF0lWJK+9ZhKIDFB441+Lc7xSmBuo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGp4DY6GhH2ntpr/ZldQD1lPNpKsV0jRY3yVF5mKMp9mbH46MrTFe37c3k+wYaidWy5jIXJ4G23ihWDz4u9dwFq7qSMtp8y0Zhcke4hmwULu8toxlhZzR6/rwVs2Q6hK2Dfo9B8Jk+BryIgBNj04HvKmrwO3c4Qk6XMpdcBb8Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nKhvLx61; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nKhvLx61"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b0d224dso765655e9.3;
        Wed, 20 Aug 2025 10:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755712660; x=1756317460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNRyeTj6JP2zchDiFIJuoMZDsJl1Picm6cQPtxKj9O8=;
        b=nKhvLx617L4HNBrcyQHv3zapQ8IH0UYAnsNP35GosiTNazq3sanXj2xSv0c2nCQvEa
         lHOoDcWuUQmofkDAKNmuyxA46lCKQwPU3uLQUosJw3DpVKPgqIfNOHI1qWzPmIxKS1Y4
         ijaBnmumJyAqeZkmRLknM6tC8++2BOYps8U5QSbTkphJutLMlMvuxKiiwde3nBILSDWd
         BaNkFTPP6fblHcpYSt6p7ewjcuTjZUCtGTpQe7hOlkuee55IjFRlPCKlm+lwSwLoXNeQ
         tPNT0VXYL2hgUo7KZXr2HjpRYHKkXt1NMf88NLDXJ0J1TbHY4xWds7jz5EuqxLDAcecJ
         OnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755712660; x=1756317460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNRyeTj6JP2zchDiFIJuoMZDsJl1Picm6cQPtxKj9O8=;
        b=ew73abhY8yuppELxzQcLntbjziZ42cSSq6gT807ZNFxD7umKqkUd84y7LfW5o0NlD5
         U7jedZ8dziv8JT8iC7tzQm75tP0gxMmGmwtsSGafs1sK800Owux/rMkLqaz7dledCn61
         kLLRzFiH9LDHRrSBg5ksgzoI/fhAkfh9qEGxahDtHmuWrcOsLWK92TZTkXo5YC51Ftja
         xZ1Osi0pacIhFlvEFahJ6FRNSWJrkivvt0vth76mRAkAekdUMsaC/PyCE49/jKWcNEww
         6Ly3EnKtKo8fq4sXpdMnqggBDcJfGNwnEgDdOjgw/2tefTZY1jCjoCIqYshDBI1Srzu4
         zFFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjydz2yaKFW8lqTF8hw4U1Udq5msQjTMXS1H7tLMKR/OsalGWdS3QdXMZYyziPWQXfzjDQrdpdVd0Mog==@vger.kernel.org, AJvYcCXvFGgPnsLYCV7B+geJd/XcyMgUgHhq31RrKHA5daOsHvppkLoxhVRLV/BNAqDPaEwyrWFy8AH3mqXPpTY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWykIujbuOXmxR3gOD6OU0UBpewZV+r+CGHn1O/hr1JEE5f/Nq
	5a6byRJQ+GttJ+zR5Mpzh2GV/BQ8lgDRTrepBoBXx95iEGFif3ARE7jS
X-Gm-Gg: ASbGncuzYKt/eetifQI3kU8vCGc5wUidfMixxezeV4EWDgt4aJEiOOddEzRlYV0F0Qh
	4lKZxLQmKuL3U3bEUObO6cWXVYTPJidMVnGL7k2J1rRsrBhl1XOytxLQfSOojT7k/tllLYAZ3Fh
	cbcw6rpgV02n4/gFAgJEZ4zXUPE5r0fatlVnGAqonhwuMczXnDEM2BpK4iGpiWI4WTA1VqGygOo
	Tl9QGAlDCHG0t9bBTbqKREbHbbTBHbDuyzhno47QLxR3gcebF+ao746nhr2WGQx1gq9LkNwn+hN
	dVUfM95Qt4Kqz0HxCjA8O63hqXzw40cJdUX4NTYWUlHDmgUQbLgcFhsgUxBCj888bwleac0JvHo
	j2ucADfbiPZVWx7e7SvB+6BvdDsnAUWoci4d9cdZYF5yK6RHDgSUacLJmS3BbfYNE
X-Google-Smtp-Source: AGHT+IGO9cP1IoD1trDUUw+EfjPUt69BwvZtgepLa76EO/eu7DfLC5c6gd+ECukky3h1zGOw8/4dVw==
X-Received: by 2002:a05:600c:1c9d:b0:45b:43cc:e559 with SMTP id 5b1f17b1804b1-45b4bdb5f70mr10581205e9.36.1755712659923;
        Wed, 20 Aug 2025 10:57:39 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c1aa3sm8147073f8f.32.2025.08.20.10.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 10:57:39 -0700 (PDT)
Date: Wed, 20 Aug 2025 18:57:38 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Don Brace <don.brace@microchip.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "open list:HEWLETT-PACKARD SMART ARRAY RAID
 DRIVER (hpsa)" <storagedev@microchip.com>, "open list:HEWLETT-PACKARD SMART
 ARRAY RAID DRIVER (hpsa)" <linux-scsi@vger.kernel.org>, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] scsi: hpsa: use min()/min_t() to improve code
Message-ID: <20250820185738.098a49f9@pumpkin>
In-Reply-To: <deee5abe-1992-426d-a62d-51249014bdc9@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
	<20250815121609.384914-3-rongqianfeng@vivo.com>
	<20250820130237.111cc3a7@pumpkin>
	<deee5abe-1992-426d-a62d-51249014bdc9@vivo.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Aug 2025 20:50:08 +0800
Qianfeng Rong <rongqianfeng@vivo.com> wrote:

> =E5=9C=A8 2025/8/20 20:02, David Laight =E5=86=99=E9=81=93:
> > [You don't often get email from david.laight.linux@gmail.com. Learn why=
 this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >
> > On Fri, 15 Aug 2025 20:16:04 +0800
> > Qianfeng Rong <rongqianfeng@vivo.com> wrote:
> > =20
> >> Use min()/min_t() to reduce the code in complete_scsi_command() and
> >> hpsa_vpd_page_supported(), and improve readability.
> >>
> >> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> >> ---
> >>   drivers/scsi/hpsa.c | 11 +++--------
> >>   1 file changed, 3 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> >> index c73a71ac3c29..95dfcbac997f 100644
> >> --- a/drivers/scsi/hpsa.c
> >> +++ b/drivers/scsi/hpsa.c
> >> @@ -2662,10 +2662,8 @@ static void complete_scsi_command(struct Comman=
dList *cp)
> >>        case CMD_TARGET_STATUS:
> >>                cmd->result |=3D ei->ScsiStatus;
> >>                /* copy the sense data */
> >> -             if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
> >> -                     sense_data_size =3D SCSI_SENSE_BUFFERSIZE;
> >> -             else
> >> -                     sense_data_size =3D sizeof(ei->SenseInfo);
> >> +             sense_data_size =3D min_t(unsigned long, SCSI_SENSE_BUFF=
ERSIZE,
> >> +                                     sizeof(ei->SenseInfo)); =20
> > Why min_t() ?
> > A plain min() should be fine.
> > If it isn't you should really need to justify why the type of one param=
eter
> > can't be changes before using min_t().

> SCSI_SENSE_BUFFERSIZE is a macro definition and is generally of type int.
> The return type of sizeof(ei->SenseInfo) is size_t, so I used min_t()
> here.=C2=A0 However, as you mentioned, min() can also be used.=C2=A0 Do I=
 need to
> send v2?

The thing to remember is that min_t(type, a, b) is just min((type)a, (type)=
b))
and you really would never write the latter.

	David

>=20
> Best regards,
> Qianfeng

