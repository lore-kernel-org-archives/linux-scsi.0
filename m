Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113D812D747
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709681767; cv=none; b=Ox4RWIfAP0rw/2kOFXiDCDpy5t1mIeBDoBE3/GL708ow8fToedNW60GjsPiDQL9N7yZzMa3AdiJ2TgJi6oOq05+DmHVPRu0rbjhJl7iDVZN+LsIDt/l15J95+zPXU2fzbetGqDJW/4v9CWrTBF6lSr1AWPGWf+qgBTWNjzVeMDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709681767; c=relaxed/simple;
	bh=PG9dPNyzq6JVaBBw+HFrzAHEWMQl1R7aRqbEgTh3gMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwNUNM0qiSz9fr1d+uLP67VCvfYQ/SRQGn9dW5/MbqKNjlY9TSMvMe6g2omhCGuDH6AJDKRKdi38NzUqi3ahc31/0XcRVJ5bfbxIHZpS4W1FobZp8XPfz575tM7XqweXO5gbi+Xv6Ufs1+3DtkPK4SaYJ6cnEOYjSG93dM4OeBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KskmwLjO; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KskmwLjO"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d26227d508so3319821fa.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709681764; x=1710286564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PG9dPNyzq6JVaBBw+HFrzAHEWMQl1R7aRqbEgTh3gMc=;
        b=KskmwLjOg4zuOKK+qISkV70xL6R+FwjTDVbalus6AUf4n2qZMXLZ2pIge3J+TR/OPH
         gb5O0zjq7v4tCNeURLCTpfvBmk0h2A706fyova/gF+eSIOW5YeXtimSqJ2pKiGD/kvwV
         kgn9SWutLbo8v4aLFGdfvp/8+c30KjeVyeRQ4Bbrp75+HktNLF4X7ViJf5q6bp8atVf5
         bKuI3B3ADYozWffO9/TdTxDl5NWIxfYOS5slABWfwSdg+soM8M2IQAO7GWin6CKtRAp9
         HNQwkHBuSQfcjySLMJBVmZrhHTAwNuoUUXrZsSGkYNPshHDkIlOqkQildHro11pClUA3
         1f/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709681764; x=1710286564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PG9dPNyzq6JVaBBw+HFrzAHEWMQl1R7aRqbEgTh3gMc=;
        b=E4GBuVavD/SItrm0NrfmCXWsH/ujksR5VbC7A1tqvRs4YGkFKIRoGU4T7OqlaY+W63
         sa34LItDZ7mTbihzDDHEZNTsvk+rZTL1tinKRgRwzGOrFdDbMjrWaxHLo9djtbStRbfa
         robppLEe16Zf+s6TiZXEKSj4zY+rBCpnfeY7b8ZWtHpoBEcMz69ncb+l4LYCBfc/D+mI
         z1dg7odQZZsteBh3ocqRrdfUcUFlyuzTyZMNs1ITII/JDqCvJ9u/DjTrRwOMghlDgWa8
         MftSMi43uxkzAq5QJW3p4RkSYbFi8Bb/l1Az47RL7RjzuF5prfFBZEKN7vJWBPcfwfMP
         Zkww==
X-Forwarded-Encrypted: i=1; AJvYcCUyhBghgpBn/ayvwEQBs0JIrlgOsdbYeXNgDXXBhE8o5M3ypAy2FEtQBrhUALWKoYZsABx2rTU/NJnU+Pc/N3VwTpaz72GLZH/VEw==
X-Gm-Message-State: AOJu0YxVj8v+7Q9EJ0ETKJlYQAMpOWhSRAfG8VcRXVlCq1JlSvaFliVc
	y/D3APfvvjc5esVETIr/PkSNyeTk0RoaXTuVuvKZxU6xN3+HGexCbp0zxhhKCaysVBZZGWXI36S
	GopHPusg1f1TFR/HGCxcPFUP+2zlZWYillQvI
X-Google-Smtp-Source: AGHT+IGpSN+I9ELO3EEtLN6HV+ncZHwDlK/bM8JASdlvQji2M0BQ7DI+znDfQMnETpZtHBNJpmDxLtKKdRzScr/3jcA=
X-Received: by 2002:a2e:7a18:0:b0:2d2:a443:9c64 with SMTP id
 v24-20020a2e7a18000000b002d2a4439c64mr2110734ljc.45.1709681763937; Tue, 05
 Mar 2024 15:36:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
 <202402281617.807B1B7@keescook>
In-Reply-To: <202402281617.807B1B7@keescook>
From: Justin Stitt <justinstitt@google.com>
Date: Tue, 5 Mar 2024 15:35:51 -0800
Message-ID: <CAFhGd8qvdnyvtGv+nDfQNSQr1mjttHGUqa+==nVLQPqRvEwWgg@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] scsi: replace deprecated strncpy
To: Kees Cook <keescook@chromium.org>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Ariel Elior <aelior@marvell.com>, 
	Manish Chopra <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Don Brace <don.brace@microchip.com>, 
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com, netdev@vger.kernel.org, 
	storagedev@microchip.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 4:18=E2=80=AFPM Kees Cook <keescook@chromium.org> w=
rote:
>
> On Wed, Feb 28, 2024 at 10:59:00PM +0000, Justin Stitt wrote:
> > This series contains multiple replacements of strncpy throughout the
> > scsi subsystem.
> >
> > strncpy() is deprecated for use on NUL-terminated destination strings
> > [1] and as such we should prefer more robust and less ambiguous string
> > interfaces. The details of each replacement will be in their respective
> > patch.
> >
> > ---
> > Changes in v2:
> > - for (1/7): change strscpy to simple const char* assignments
> > - Link to v1: https://lore.kernel.org/r/20240223-strncpy-drivers-scsi-m=
pi3mr-mpi3mr_fw-c-v1-0-9cd3882f0700@google.com
>
> I think you lost my tags for the later patches. I re-reviewed a few and
> then remembered I'd already reviewed these and they were unchanged. :)
>
> Please run:
>
> b4 trailers -u 20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-0-9cd3=
882f0700@google.com

Gotcha, I've resent [1]

I've also added this into my scripting so I shouldn't miss any future
trailers from vN to vN+1. :)

>
> :)
>
> -Kees
>
> --
> Kees Cook

[1]: https://lore.kernel.org/r/20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_=
fw-c-v3-0-5b78a13ff984@google.com
