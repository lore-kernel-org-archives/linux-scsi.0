Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111853;
	b=wglJnandhS7gamWvm74xD3/uzIh7cp1AqjDDfDB+s2G4xKeUjX84EQXOha+21bGF5O7f
	 AJAVAJ/Z4JrknPb4WaMv3b46k00f9eO8uCDhuWugsTG+NGfczbcUlonru7qyd3W3ObzdD
	 a6OoyLz1k495L1p9teYgsbHDxJC/Bmsl/V7fVyNnCC5nWN5/9kG8+xdxhLbPTdLcpyA4u
	 l25d9rLg22HJaSQ6TNSJZX3mfpWIrL5SHg+sW12e1wFngy1//u9icxe79q2MNCI8YRzZ0
	 +UffnQOsRkNGz3YYgKEZqKdrV8S6RJLk1GVDoR25JgDNPNj+0BA2OXrq78SQqk4yC7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111853;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=A7bqVXK9mc0vEANhbyypwW4ZooF+kXFAyHaNlh/JpOQ=;
	b=YEzDFADNwDJqr/UeuZZHHiGKquWRwgmIsvOwRNGOxVss51gVTYSBfJcePU7bjKo/Brpg
	 9QRulZ/MlgzulgR/FoqZqfWuGbjvTaT6ipkTWvI7pG2QA4m4pndPqlAgg8axkLnKvYOO6
	 STv4XzdS4q07MiZoF4a3qsWi7oGMEs58tGQfOqPnKUz6/6pvAa8+s0M8t1IhRLWt7lnlj
	 tYrJqwJINNAnGbLzUxcj3/I/1pR40FrdQ95So9uX2gjGBoxa8EpVoPksosgv/cWsTbm20
	 OsYY98BxyXa7mYR6m1xCG6tZoi/JlbPIGUvv80yKukdGq44KpxYng7TVWhEwNxBE1hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IkGZBK4R;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fo8h6cZn;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB59606A332
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 18:10:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBB59606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IkGZBK4R;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fo8h6cZn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795111851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A7bqVXK9mc0vEANhbyypwW4ZooF+kXFAyHaNlh/JpOQ=;
	b=IkGZBK4RLgP4wUiS+PU9DDehL4bKcVTGv3rsaZ//nZYd8oNHcg1MFpNgaAu983GflBmMWp
	MQcw4FE+oiUl8GisQRMPGUX9ZG4LIQqT7Q8BN/5/DWBgdWnaLougEIDqQKzge3cWQyRzY1
	VQUNtRgWCGITUfF1cNTC+LQkYSy2hW4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-FIf1APICNWGCvYw5-28d2w-1; Thu, 19 Nov 2026 13:10:50 -0500
X-MC-Unique: FIf1APICNWGCvYw5-28d2w-1
X-Mimecast-MFC-AGG-ID: FIf1APICNWGCvYw5-28d2w_1795111849
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-92106c98714so1668076d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 10:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795111849; x=1795716649; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=A7bqVXK9mc0vEANhbyypwW4ZooF+kXFAyHaNlh/JpOQ=;
        b=fo8h6cZnX5uNj6bctT3rAY8TCEQSldgvn2313+b7vccz3+/os/9wDPVTmp2HilSWtw
         +Tz9Sod+3UmsiGDAfs/S2oX+S383JRtv3GxoThMfazPRv6IVJZ/V+zxNeR2WQCdiuTiP
         5mzRHYI0uqJ3OQ6Xw/DvwPC3rHNimXsJq+9T5Gxke63bMi/70uSWritOvJq0fgPMWaAe
         yCrjY1vpw5HAEALAnC9dCJ4zaPRQtgQneargGF6SrD0kH/mFVzIVAybGxf0wy9rEWMJm
         PLbOZ4o+qRKJBzBho8MOCSKJJfHDhK+u9OAbk4kZHA3TNZhC48Nb0e1zaDz7YulG3aKU
         BEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795111849; x=1795716649;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A7bqVXK9mc0vEANhbyypwW4ZooF+kXFAyHaNlh/JpOQ=;
        b=yNb5KU7XUfKUw7+QYGVy6WFlhUcxm20z8eHPWWrzP+cZ/Digup1616TKz9qseEicj8
         tnPenlLE3KNPwGxyQt4Ym7nofJDg6uxL2+fvELCp9pgDBHlt7JGiJ5SKk2x5tmb+xhHD
         Nl5ICJRZhqXlWen2GRssYqz+aBuf6BBEGWk9fnUAziqbLUmysNITTzQ60+AyMykhfg4X
         O3+dmPywZHo5pJGIupffsmhGsxW4idyZRcO9jF5YYIbIkc5gUgIFdm8ElKjtIN1/elK9
         q3IkQSJRaUkBp7Iprc4BnFBnKNXcjlVsIcYhBMfJihiMrKutuFxxhVkZELUdsW1BPPrm
         cQ7Q==
X-Forwarded-Encrypted: i=1; AL+hErGZnyZ/AkwCXouYriUl/cjBVR5R094qERE03s/GI8JC486grTuF6Bd+HwsTdm/HoqQ24ltrBQpDDjyi@vger.kernel.org
X-Gm-Message-State: APuU4Z+cb/BZmgaPfptQMQIZdk002gs2qzXxmp4l4FXmD2HtekI8rqN4
	5zT9MRfRQQIvu/LCr6YDhvTcHlGXVK6EYDBFYiQ8c4TZme9K34irJQply58J5Wncj4/uegC1Zy3
	epdFv04iEHeQ7SK3giJ9ztAlKH+8Bcgp4eiCwCCiztESUAs+O4Od7IMYC8G8j/2dB9Mf3fxM=
X-Gm-Gg: AZFdTZdiM/WFi0T+1gYwCzbFz/zF+SampY7f96mlw12mkUmH0TfFf3endC6qYXIfDSM
	cGpNmQaU65vawggzQuHF8CGUCnTw4kK7vO372NWPZl7EHZci2VJE7wym5oKWgk8AVcJORCiBD2Q
	zIzdfLqlIRnR6Bp1S9tDT6aH0a72uVl7vEAeiXXdBP0si/XM8mLhoocOJp2dCR18dg+F/zHrAv4
	nbAQqwMw/hEnHu4VfRC66h6IFJvgi+ut7r2bmNSjFkA95o5R9p43/aMqbDAFNbcLGOxmhe50RV8
	gNRFmPs5mPv3xVoEwI821dAfshJRhSdB2I00JCwSE8NNgaU1YmU+1V+hgDPMS+ypU6N0/CwodnL
	Z+eV223gShVyU6vTqMDxBm9tkqlBV0sxGGahMXXiZsFGdAkUhpzig2a1sBp38Al9ObNImGlY6/e
	jfI3LWF4zvOaHw6SVZUp+yFU+KILIZwyHxMCljsUlBpijJFRf2JKFEere+dsjHrQv/+YSeDlo=
X-Received: by 2002:a05:6214:6014:b0:921:2e2d:2a7f with SMTP id 6a1803df08f44-92134aaeb70mr5411646d6.14.1795111849053;
        Thu, 19 Nov 2026 10:10:49 -0800 (PST)
X-Received: by 2002:a05:6214:6014:b0:921:2e2d:2a7f with SMTP id 6a1803df08f44-92134aaeb70mr5411016d6.14.1795111848224;
        Thu, 19 Nov 2026 10:10:48 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349f8c34sm5127806d6.32.2026.11.19.10.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 10:10:47 -0800 (PST)
Message-ID: <89162d17096ddf7d4ca98a087f1517bcfb935869.camel@redhat.com>
Subject: Re: [PATCH] scsi: mpi3mr: Fix start_time and error return in
 mpi3mr_bring_ioc_ready()
From: Laurence Oberman <loberman@redhat.com>
To: Ian Rogers <irogers@google.com>, Sathya Prakash Veerichetty	
 <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, Elkin Cruz
 <elkin@google.com>
Date: Thu, 19 Nov 2026 13:10:46 -0500
In-Reply-To: <20261119170900.1530138-1-irogers@google.com>
References: <20261119170900.1530138-1-irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-11-19 at 09:09 -0800, Ian Rogers wrote:
> mpi3mr_bring_ioc_ready() has three bugs in its failure and retry
> handling:
>=20
> 1. start_time is only assigned after MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC
> =C2=A0=C2=A0 when retry =3D=3D 0, after three earlier 'goto out_failed' p=
aths. If
> =C2=A0=C2=A0 soft reset, reset-state polling, or admin queue setup fails =
on the
> =C2=A0=C2=A0 first attempt, out_failed computes elapsed_time_sec from an
> =C2=A0=C2=A0 uninitialized start_time, and if a retry occurs (retry =3D=
=3D 1),
> =C2=A0=C2=A0 start_time remains uninitialized for the ready-polling loop =
as
> well.
>=20
> 2. In 'elapsed_time_sec < (mrioc->ready_timeout - 60)', ready_timeout
> =C2=A0=C2=A0 is u32, so values below 60 wrap around in 32-bit unsigned
> arithmetic
> =C2=A0=C2=A0 before zero-extending to u64, spuriously retrying past the
> timeout.
>=20
> 3. After mpi3mr_setup_admin_qpair() sets retval =3D 0 (or on entry
> where
> =C2=A0=C2=A0 retval is initialized to 0), controller fault/reset-history
> checks,
> =C2=A0=C2=A0 ready-state timeouts, and early unrecoverable or device-not-
> present
> =C2=A0=C2=A0 exits return retval =3D=3D 0 (success) to mpi3mr_init_ioc() =
and
> =C2=A0=C2=A0 mpi3mr_reinit_ioc() even though controller bringup failed.
>=20
> Initialize start_time =3D jiffies at function entry for pre-enable
> failure
> exits, reset start_time =3D jiffies the first time
> MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC is written so pre-enable waits do
> not
> drain ready_timeout, rewrite the retry window check as
> 'elapsed_time_sec + 60 < mrioc->ready_timeout', and ensure retval =3D -
> 1
> on all failure exits.
>=20
> Found via Clang -Wconditional-uninitialized on an x86_64 allyesconfig
> build. Verified by building drivers/scsi/mpi3mr/mpi3mr_fw.o with
> LLVM=3D1 W=3D1 (-Werror) and -Wconditional-uninitialized, and with a
> standalone C logic reproducer under ASan/UBSan; not runtime-tested on
> physical MPI3 hardware.
>=20
> Fixes: 59bd9cfe3fa0 ("scsi: mpi3mr: Code refactor of IOC init -
> part2")
> Fixes: 0a319f162949 ("scsi: mpi3mr: Wait for diagnostic save during
> controller init")
> Fixes: 9634bb07083c ("scsi: mpi3mr: Enhance the Enable Controller
> retry logic")
> Fixes: 4616a4b3cb8a ("scsi: mpi3mr: Improve wait logic while
> controller transitions to READY state")
> Fixes: fb6eb98f3965 ("scsi: mpi3mr: Handling of fault code for
> insufficient power")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
> =C2=A0drivers/scsi/mpi3mr/mpi3mr_fw.c | 14 +++++++++++---
> =C2=A01 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index f0d3cd398dd0..b92b2467e995 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1582,8 +1582,9 @@ static int mpi3mr_bring_ioc_ready(struct
> mpi3mr_ioc *mrioc)
> =C2=A0	int retval =3D 0;
> =C2=A0	enum mpi3mr_iocstate ioc_state;
> =C2=A0	u64 base_info;
> +	bool enable_started =3D false;
> =C2=A0	u8 retry =3D 0;
> -	u64 start_time, elapsed_time_sec;
> +	u64 start_time =3D jiffies, elapsed_time_sec;
> =C2=A0
> =C2=A0retry_bring_ioc_ready:
> =C2=A0
> @@ -1595,6 +1596,7 @@ static int mpi3mr_bring_ioc_ready(struct
> mpi3mr_ioc *mrioc)
> =C2=A0
> =C2=A0	if (!mpi3mr_is_fault_recoverable(mrioc)) {
> =C2=A0		mrioc->unrecoverable =3D 1;
> +		retval =3D -1;
> =C2=A0		goto out_device_not_present;
> =C2=A0	}
> =C2=A0
> @@ -1621,6 +1623,7 @@ static int mpi3mr_bring_ioc_ready(struct
> mpi3mr_ioc *mrioc)
> =C2=A0		if (!pci_device_is_present(mrioc->pdev)) {
> =C2=A0			mrioc->unrecoverable =3D 1;
> =C2=A0			ioc_err(mrioc, "controller is not present
> while waiting to reset\n");
> +			retval =3D -1;
> =C2=A0			goto out_device_not_present;
> =C2=A0		}
> =C2=A0
> @@ -1654,6 +1657,7 @@ static int mpi3mr_bring_ioc_ready(struct
> mpi3mr_ioc *mrioc)
> =C2=A0				if (!pci_device_is_present(mrioc-
> >pdev)) {
> =C2=A0					mrioc->unrecoverable =3D 1;
> =C2=A0					ioc_err(mrioc, "controller
> is not present at the bringup\n");
> +					retval =3D -1;
> =C2=A0					goto out_device_not_present;
> =C2=A0				}
> =C2=A0				msleep(100);
> @@ -1690,8 +1694,10 @@ static int mpi3mr_bring_ioc_ready(struct
> mpi3mr_ioc *mrioc)
> =C2=A0	ioc_config |=3D MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
> =C2=A0	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
> =C2=A0
> -	if (retry =3D=3D 0)
> +	if (!enable_started) {
> =C2=A0		start_time =3D jiffies;
> +		enable_started =3D true;
> +	}
> =C2=A0
> =C2=A0	timeout =3D mrioc->ready_timeout * 10;
> =C2=A0	do {
> @@ -1731,7 +1737,7 @@ static int mpi3mr_bring_ioc_ready(struct
> mpi3mr_ioc *mrioc)
> =C2=A0
> =C2=A0out_failed:
> =C2=A0	elapsed_time_sec =3D jiffies_to_msecs(jiffies -
> start_time)/1000;
> -	if ((retry < 2) && (elapsed_time_sec < (mrioc->ready_timeout
> - 60))) {
> +	if (retry < 2 && elapsed_time_sec + 60 < mrioc-
> >ready_timeout) {
> =C2=A0		retry++;
> =C2=A0
> =C2=A0		ioc_warn(mrioc, "retrying to bring IOC ready,
> retry_count:%d\n"
> @@ -1739,6 +1745,8 @@ static int mpi3mr_bring_ioc_ready(struct
> mpi3mr_ioc *mrioc)
> =C2=A0
> =C2=A0		goto retry_bring_ioc_ready;
> =C2=A0	}
> +	if (!retval)
> +		retval =3D -1;
> =C2=A0	ioc_state =3D mpi3mr_get_iocstate(mrioc);
> =C2=A0	ioc_err(mrioc,
> =C2=A0	=C2=A0=C2=A0=C2=A0 "failed to bring to ready state,=C2=A0 current =
state: %s\n",

Hello Ian

Thanks for this. I checked it against current mainline and all three
issues are real. Some comments below.

> 3. After mpi3mr_setup_admin_qpair() sets retval =3D 0 (or on entry
where
>    retval is initialized to 0), controller fault/reset-history
checks,
>    ready-state timeouts, and early unrecoverable or device-not-
present
>    exits return retval =3D=3D 0 (success) to mpi3mr_init_ioc() and
>    mpi3mr_reinit_ioc() even though controller bringup failed.

This is the most serious of the three. Both callers only check
"if (retval)", so with the !mpi3mr_is_fault_recoverable() exit we can
set mrioc->unrecoverable =3D 1 and still report success, and init then
carries on against a dead controller.

> 2. In 'elapsed_time_sec < (mrioc->ready_timeout - 60)', ready_timeout
>    is u32, so values below 60 wrap around in 32-bit unsigned
arithmetic
>    before zero-extending to u64, spuriously retrying past the
timeout.

Agreed that the arithmetic is wrong, but note the fix changes behavior:
today any firmware advertising a ready timeout below 60s always gets
its two retries; after this patch it gets none.

Sathya/Sreekanth, can you confirm whether any shipping MPI3
firmware reports a ready timeout under 60 seconds, and if so whether
dropping the retries entirely is the intended behavior?

> Initialize start_time =3D jiffies at function entry for pre-enable
failure
> exits, reset start_time =3D jiffies the first time
> MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC is written so pre-enable waits do
not
> drain ready_timeout, rewrite the retry window check as
> 'elapsed_time_sec + 60 < mrioc->ready_timeout', and ensure retval =3D -
1
> on all failure exits.

Would you consider splitting this into three patches, one per issue,
each with only its own Fixes: tag? The retval fix stands on its own
and is the one stable and distro kernels will want first; the
ready_timeout change may need to wait for Broadcom's answer above.
Five Fixes: tags across different commits on one patch also makes
backporting harder.

> Found via Clang -Wconditional-uninitialized on an x86_64 allyesconfig
> build. Verified by building drivers/scsi/mpi3mr/mpi3mr_fw.o with
> LLVM=3D1 W=3D1 (-Werror) and -Wconditional-uninitialized, and with a
> standalone C logic reproducer under ASan/UBSan; not runtime-tested on
> physical MPI3 hardware.

I have access to mpi3mr hardware and can run normal bring-up,
controller reset and host-reset reinit on a v2 to make sure the good
path does not regress, and will send a Tested-by.

With the split, for the retval and start_time fixes:

Reviewed-by: Laurence Oberman <loberman@redhat.com>

Regards
Laurence

