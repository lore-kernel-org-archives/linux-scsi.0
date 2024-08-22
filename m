Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02DF1CC151;
	Thu, 22 Aug 2024 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724338474; cv=none; b=eBMTYwPjJkGYqZAeleYJ9g48u8u81hWCPvryl5SeoWZSYSDeMazKpLn8SytPirCOvGYJ7Cz846SePrEca9gW7tK3S/d3TLROFDclM0MPAlM6M2uTR+ocLcnBt5uSKGQwYuOH1EB2CAgexw/Yn4sqcNGWQXx1QeVRJUvpnBj4w8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724338474; c=relaxed/simple;
	bh=+TUSP11wjCwnjRuybst5FS9wNxTbnJ3fnYQiOquRoXE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m7i6+HaXX+8KU6GAw4NHrmw4+pDERlVBZ5KxcFgd3X3/FEryZCI3RTuKTVMH8YoAV6PCPUWtuSvTEwKj2MmPAqd2pXfg9Qr4b7CNwtpqP+Be5dMx8VUWRQfq5JF8Nsf9dYdiBYPyCVyYZJn8SfPPFrqc6alFwbldoWqI8pZ+g6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWXuVKr4; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWXuVKr4"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2f3e071eb64so13241801fa.1;
        Thu, 22 Aug 2024 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724338471; x=1724943271; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TUSP11wjCwnjRuybst5FS9wNxTbnJ3fnYQiOquRoXE=;
        b=GWXuVKr4Zbqx8CXdUR8NIkcFBXUXeSVfYpOdiddRoyjewC5b4eFjmu7uB1z5AoV6+3
         eGryZ0tgyPBRjAZLPttRPQ/FsUbPGohnHmnzkvNt42ENMadv2bckZHyt1t7enqXcr3Ce
         tdSVhT/NPfXLUbvshngqbOBtfSEHh7D19FGrjtTfpZwEMsDXTFh2xnGUh1vbJ4bIdNAo
         KA751ip7w56uUxe6X7hrTGqNVv4NVeXAPymlCeag/lCFltm6YZVZ2kgBPR5bnMST3sgw
         g4utAp2Xjtrz3h8rUP5yaZ9awORbBQ/xCWfwTmJAf4Ow5jAaOeg7uS0//S0JvW5lBj5W
         7Kwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724338471; x=1724943271;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+TUSP11wjCwnjRuybst5FS9wNxTbnJ3fnYQiOquRoXE=;
        b=Td6S24NUZOYUPNOW5Qs1OZ/tPOsQGBwZLGUiwmQAF3N81AXcDOtlvJGfTdsQ1fDQVp
         AX9IuM+3+excMxvpfjat5HiPAqN/cCTnWRkRDDFJ7ca53enHgxCmvXG5GDttMi4i5aEo
         zVd92xNhJVYcCLd/1i+0tbYStswBkfEhYlKEQSE3WcxfqdinSsUuBoxnuM20sec9ilTq
         7VB908/naCGAkfZWKv6bsWuAv6nzb2DEeKJSeyyuixXizlwZn3gLXPkQgJwyW4JmyRdR
         UsWt29Oa/6B/OiMojYw1sK7YnQctveXkRuXu8aVFScJTj87S55mGo1e2tMcVIEfJTMyF
         WTKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUydCTUadLqUOrxcy9fJ6r8LZMF4S7ZRXPXIglUw/jVTTfakifLZpyvYwnCZewzY59CwyT1ZIAKyaBXOA==@vger.kernel.org, AJvYcCV/tf9k92yn+TZruHjd+P2xziIjakJTdNGB0lhJXoH23zO/Tsa/Oe81EQ/7keTXtkK4VYuTeMuc290d1I8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcnsWkAsqSTGrePEWDr56TxJ5UtUoFTx6W2LmsTPfZKfswFlsp
	PxOoyx3FxGMafUpTqFtIMGiUeT0ElvZ7pDhThkhPEhgbBu5Zq+Vw
X-Google-Smtp-Source: AGHT+IHHQLJky14YCYfHmGvcL+P+t82R4pEsMMJV8VeNqUl5LX/0oZXRvjHMpvuElGzR1USJVojd0A==
X-Received: by 2002:a05:651c:154b:b0:2ef:2ba5:d214 with SMTP id 38308e7fff4ca-2f405c8bf3cmr16014141fa.4.1724338469809;
        Thu, 22 Aug 2024 07:54:29 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f29a568sm129477266b.53.2024.08.22.07.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 07:54:29 -0700 (PDT)
Message-ID: <ed370c6355dee6a4af15587cdbb3b06a1fe0b842.camel@gmail.com>
Subject: Re: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
From: Bean Huo <huobean@gmail.com>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
  bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com, 
 beanhuo@micron.com, adrian.hunter@intel.com, h10.kim@samsung.com, 
 hy50.seo@samsung.com, sh425.lee@samsung.com, kwangwon.min@samsung.com, 
 junwoo80.lee@samsung.com, wkon.kim@samsung.com
Date: Thu, 22 Aug 2024 16:54:27 +0200
In-Reply-To: <cover.1724325280.git.kwmad.kim@samsung.com>
References: 
	<CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
	 <cover.1724325280.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-22 at 20:15 +0900, Kiwoong Kim wrote:
> UFSHCI defines OCS values but doesn't specify what exact
> conditions raise them. So I think it needs another callback
> to replace the original OCS value with the value that works
> the way you want.
>=20
> v1 -> v2: fix build error for arguments
>=20
> Kiwoong Kim (2):
> =C2=A0 scsi: ufs: core: introduce override_cqe_ocs
> =C2=A0 scsi: ufs: ufs-exynos: implement override_cqe_ocs

Hi kiwoong Kim,

I didn't see your above two patches following your cover-letter, did
you send patch with "--thread" optioin?


Kind regards,
Bean

>=20
> =C2=A0drivers/ufs/core/ufshcd-priv.h |=C2=A0 9 +++++++++
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 ++++++=
+----
> =C2=A0drivers/ufs/host/ufs-exynos.c=C2=A0 |=C2=A0 8 ++++++++
> =C2=A0include/ufs/ufshcd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A04 files changed, 25 insertions(+), 4 deletions(-)
>=20

