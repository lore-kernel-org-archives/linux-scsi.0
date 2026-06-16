Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CCF3C8724
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 04:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781583741; cv=pass; b=pha5sKT4oJzymuAbp5+TiX/4ip9tNOG/FvdaUZE0w5m8zXJhpnZuhK9eYKlsIgatKSbSOfiTO0YJDYxiWRkG3lHn9x46K8aV9yc1JyKeb2RcyR234ZMiaXQf2Jold4KqXAkUuSuMv2OTVfXmv0BM+A2qKBC0ZLxh7T5AkTHVVMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781583741; c=relaxed/simple;
	bh=dra/zZ5km3G29j+KitrrAM8pW8NVH10i4w0w0qc8jaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cf0GleyThPE/3eB0q841FBnzKCxP11KGb0lCsNPhOVIc267QI7hUuCko4nl9G1blEv30GUcA9q6Rlq46f28i2AcJt8lwhFAUuATyhzzvxFHK1BFgDtymu+kQ/QC3LgbOuB+oRpMEoNzQIJZRAH4KqvU6JVDTbXHQrnMTyTKlAyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N07oIaQn; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N07oIaQn"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5177d1ff061so90081cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 21:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781583739; cv=none;
        d=google.com; s=arc-20240605;
        b=MZztYV/27JCEA+N7INSUkBE21qNyUamY1tlIepUy7mPniirsyjNowyQ5Gc/RM5muAZ
         QGV4t6jZQ2cTI2DIbkX3Lw2wIsTcheoSMuesGAii46veszoIv3i5n+Cw5KJnshHDgtdl
         XjJv5zVMi/K7qTsmzTxs2H7zTVKZES4kClN5PglWoIwJT+50adTuFzBxTp+MZnCFfFpO
         MjR9PauH9G4Rxw++o8WwpKB1IosMjzkNVAl6jCnl9AqdNJoT2ahtKKbNScYofvXwziZv
         BrwY2y8AfWoy9PLDg868etZCa4qaXwyfkB0VjsBrhYiN2so8mSqg6xcZ7baPVpI8yfkJ
         uTkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lA0yH24+Cezyn773tJy1ut9HT5Wj3zCnOg1wQgKUTog=;
        fh=MOjR3yb81ceRZFicq8RMia8BTWBE/Gu/epxevgUD/Bo=;
        b=jY7TWsGprlZzbIR8GB1iOf2nhLuT/6eNyM4mdeNzoyzIWPP9eRCcEDuPf2liJfDGQI
         zDJDPJzwReMfGE2Lq2MM1O1TV+JVu4gOedeyIBMnxnQt20c834XRoHu/NzrfI1pW8PTO
         A/5LK3rt0jFhRcXB9rmutAbbD0/CBISXNdLhfMjbjO1ausHSHvgWheO6f/bdDv62XYKQ
         AO9Rd/97xiYdR6KCWbmzmyEuOZ60msOUeKQWqVwca3pJnqPMbfC8x0UCSaBAisxKZEq5
         eMDOZHuZKeertModxnZ8r4qEV1hbxu1BHv21t0+TMvxpq8JpwC8Uou00Uh/0Eblc2sxp
         CJPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781583739; x=1782188539; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lA0yH24+Cezyn773tJy1ut9HT5Wj3zCnOg1wQgKUTog=;
        b=N07oIaQneR6d5DIukOgVdpj6UkVcE8hRwNnB3Uv0JsRQ9HaMrIEwc3NysLikPTm9TJ
         PXh39AX1YzDp8fDSOZ96gbgx2q53lDzvUk59BHc/g280H09RqFshUdSDGOoHZKQ8jMKb
         KsUML/39Wpk2OqJ8AYRNR/onysTlIqXoDXlOIz2MIUmp6AKPzmcdI70WjrAnPgzID0Ud
         k8Mrek2FJ+sZLj64nZRP886LsmOFxFl/NFxz9PX8fzOdTLo/ufuG7kXkbxX/rKAwXzi2
         QrMprHgtYvahLHRKKp+26zzmEcvJQCWFLBv5yZRf+po65FOmL8KYiDLR4r29+DFeoEx3
         EvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781583739; x=1782188539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lA0yH24+Cezyn773tJy1ut9HT5Wj3zCnOg1wQgKUTog=;
        b=Q1oUW5cpnBn7KUwUX0jDbTbWA+IFxuv48ODVazYzBz3V0jHSl9mIxSMAAvkRQ5d1mn
         asJ9RyDW+A1H3SOTSMxRwKPG4YnPDfZl6rba6b49sGJJQGrsxrUG9CT2V+kOXkTefS7n
         H9RIE9vtamwe5YS6jRoUhKkVZnxFloNSxz2Sy+pIAZUuaTXAmIO2/er4aN63zNnhkK+4
         cUfywCLArTkKRIjN6f68vAAJUzQhFy3umxrZoKv1F+K/ZD3Ekh0ALLpWgx/zunqD1DVy
         FACWX846tTFhKNFCAB2ixqEAZqb6lHdTtqTSAjkJljUOjuw3dOlCVcmcRmYr6bg3LIk7
         3YHw==
X-Forwarded-Encrypted: i=1; AFNElJ/la/H5a9Woiat3br5q1Ia8xiIgVLeCX8knE7HvIYXyE4bH8at4TSV68mg87zhNkFD10mD+piNT+f+j@vger.kernel.org
X-Gm-Message-State: AOJu0YwfGwCiOTcHbqYaafUMRAXUhuzoM0d9tljhdnAfqF4eJ96qCBk9
	aAaaGomo+DMrCJDXLaRWq5DSm2IpLtg1ikIzsmtT/ndaTE9pesgrsjZP2E+/F2Ij5M/yHJt2oOK
	ZPdkDUxt0zkdBeC3E8gnCy6iB1t+oAKYn7p2Klqyb
X-Gm-Gg: Acq92OE7z06KzGLVMulKniGGIQ9Co43iuF+3S3joLTq3fh2H/sBwC074acgulZvjpDa
	15HLGx8iYuu3NfLlaM3VmnjM79xTloc9Jd8DltN37MO5KNRZ5Pug/3TdQ8gor7Op+T8T2XNJkPH
	jhkNE7KCWp+b6SHLEIdNREEGzZWYqSF/+rgNpq1PgWZOLQKwJSi4516GrwQw1xpKGxnNrvgy5S8
	ro1n7KWpnCU+GZ8WGkMi/1QkyYPgvWht/n9+rHBBm3CBIQZEmOMLZmeJZ/UTlUJTTADCh5ZSfyw
	1EvZYRq12QMlCQyzTxsVdkTxcQkE+YBzff4r4w==
X-Received: by 2002:ac8:7f83:0:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-519904708a9mr5607221cf.16.1781583738356; Mon, 15 Jun 2026
 21:22:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615142605.2795757-1-himanshubatra@google.com>
In-Reply-To: <20260615142605.2795757-1-himanshubatra@google.com>
From: VAMSHI GAJJELA <vamshigajjela@google.com>
Date: Tue, 16 Jun 2026 09:52:06 +0530
X-Gm-Features: AVVi8CfudAAoXZ1vjq5ljvzCudhnb0iul2FENa9nlP6SO9vtHlrgOdFbKFQbIOo
Message-ID: <CAMTSyjpR455jn8pMFe43ozp1b0Jj9Vy9dKuD8LrcbMCY-cT+zA@mail.gmail.com>
Subject: Re: [PATCH] ufs: Add HS_GEAR6 string in power_info/gear sysfs output
To: himanshubatra <himanshubatra@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, 
	manugautam@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

scsi: ufs: sysfs: Add ....

On Mon, Jun 15, 2026 at 7:56=E2=80=AFPM himanshubatra <himanshubatra@google=
.com> wrote:
>
> In power_info/gear sysfs, currently it supports output only till gear 5.
> If operating mode is gear 6, it is giving output as "UNKNOWN".
it outputs "UNKNOWN"
> Add support for HS_GEAR6 string in sysfs output when operating mode
> is gear 6.
>
> Signed-off-by: himanshubatra <himanshubatra@google.com>
> ---
>  drivers/ufs/core/ufs-sysfs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 99af3c73f1af..d1f5041fc3c8 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -54,6 +54,7 @@ static const char *ufs_hs_gear_to_string(enum ufs_hs_ge=
ar_tag gear)
>         case UFS_HS_G3: return "HS_GEAR3";
>         case UFS_HS_G4: return "HS_GEAR4";
>         case UFS_HS_G5: return "HS_GEAR5";
> +       case UFS_HS_G6: return "HS_GEAR6";
>         default:        return "UNKNOWN";
>         }
>  }
> --
> 2.54.0.1189.g8c84645362-goog
>
