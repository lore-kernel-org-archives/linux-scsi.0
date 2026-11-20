Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795206651;
	b=KvkwrWOY6dSJOcMR1cg2OmxQE6wSCUjzaLmcihA59yAyxZ/Mj6sI9o+4Av6lcpkPBttR
	 S5FuAmgZL/+ab7KOCgrN+ZM0pLZ0RUFAjN3aaArbS/FtAnxMt2OZzJKwh1ytDL4dsTe0r
	 c9RjPqtfqoea842R5Y/ra+KRTa5jg9l/uP8W7R7AjsijAMkytJM6/9hj+GYmVjOV28mGo
	 L5cL3Jn1+5I6Jbh2usqbihrZrpgmv335psqwpi6kYlkjVVT4P48dP80xOg6b9lUn9X25r
	 LixpsziWA2BMY2nx1ZPnbN9P9EBi6VPKxjp4CTLc7mxOLdxjf0szkZSMBH6UsYau1fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795206651;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=mx8lv7UCTvTnaJ2WerqoFZH52wwM+hfy6gTfkRrFF10=;
	b=mLFUavSZd1PtMrwDfVuq0PJI37vAndeDTNljjx1vJhLGz4H/x6KGexPQnWsfWvjFfCQf
	 R+9BBOfnfA9hVF9MO7lkxvPca/q/5G2CrtfolLlBOONdNNyEW2MGqilzv4oaNCevGRS15
	 GLQhhKnVmYiMNLaI6Uws3EGRAWDqITdwJFIYBBISE87pU+kaiCLz+DqVSd76ujIZOkSQO
	 9t0oVlx9z3Vt9dOggVw/ez/pgaUlNwcELlIl3185KfbUQVcV5FykfrN2kcRvkkcz7fKBB
	 aeNi150zvo1/sjejsSWsZmCucfmSxZyw4Msll9Jca+3M3FElJUSPt0SnJpCGMssJk3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L2uoEwzH;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=chYm9dX0;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A182606A6E5
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 20:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A182606A6E5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L2uoEwzH;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=chYm9dX0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795206647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mx8lv7UCTvTnaJ2WerqoFZH52wwM+hfy6gTfkRrFF10=;
	b=L2uoEwzHjf/t2WhpJEO71ibUbxoEcxEEIxYLwyiTfxZ6qTnO0txlJMIONLr1ccSBKkKSa3
	+IpUPV5yo9XuY3AG//IuWEO+jrFt7PwudWXSFETSddOul8CbBTurYSGncGv7FnUBFPLCmA
	RIXaCu3wt4+UvTYUpdjDjoPvRc6Khyw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-LTAdLHm6MHWJFkzLbYa3pQ-1; Fri, 20 Nov 2026 20:30:44 +0000
X-MC-Unique: LTAdLHm6MHWJFkzLbYa3pQ-1
X-Mimecast-MFC-AGG-ID: LTAdLHm6MHWJFkzLbYa3pQ_1795206644
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-544019b1831so26373531cf.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 12:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795206644; x=1795811444; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=mx8lv7UCTvTnaJ2WerqoFZH52wwM+hfy6gTfkRrFF10=;
        b=chYm9dX0imvp5wyvcD+7Wpp9IlRMQOQL8ap3FSU+/lXL3pkXj6h679Zxctl538ZiuJ
         adUJgJmOWB+c0kYKEloVVdjVhLaGuR4LhYL/mD+itLGZ8PvsAR4QcY5KZLFmJ30ULqJA
         alls5klSlmTSUVXjf+fAtSDr20X+5A4Apn5Uc8Vbbkn37+5qaDpBzWrZUBiY9Myb2qri
         0yIWeM5eWHDyZtqOY8Vh/lJf/tZcCEoTdwbRZuAXNo6ymJ2jb8wtA1oev7+v2q/Tqnn4
         1oWwVxKIUYn/81Rsat/syD3mYCwS53FRTaLNpwA1L4R6k0WOV/t7UFoirTed9oo4VKkb
         sq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795206644; x=1795811444;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mx8lv7UCTvTnaJ2WerqoFZH52wwM+hfy6gTfkRrFF10=;
        b=xAglasN1N7FFRXrx1tqwiH63Xf5+PsbprgZpeEhJy7UR09Zqgc6qY6X4UuFsMebKpT
         ajSWhTnSTWeGpk2bnCnIT5lNi8nOI/J+J0/To+fufm51FsnNyPFs2+vr66HoA7gKxuzC
         XGcvAciNMZCveMGAK/E06RwTCSp5NRd3w6JRN6E5T+Yaivq9HSNGx6PNCMc5YD/baznh
         BdvzGFyFbFYfb1/NuqrGF4ouAnHjuNDt8+oreLXzR/OLf/85HKJC6mWTYDY8klMHSYqd
         VBqRftreMhGSX2uIBaYi62kC65TDQ4RwG6Wd4JbGXgPIm8naEYa4/jyVGlJg5oMXm+Gq
         w7kw==
X-Forwarded-Encrypted: i=1; AL+hErH8f70JnNJdxiqD7KaXrnYZxKPGWJk4jSXU69Yb/BlbyLXF2WROACZ9qHeO140gU9XckZAZpAmHx6jX@vger.kernel.org
X-Gm-Message-State: APuU4Z9/5UWNUnC4mwo/tdGjazXetBDtF/QKy/amNNgmxsbSNxgzcdNz
	ufY/lMMv2Vse61QIMMJyN4V+KRe2rDeoF4fispdjO73XOdu2ihHvCujLyEvThNgfFGrbKsiyql0
	qcTuhXF/JryCTpqip4a5wy9+GhxP4kinKr1+IVi7ooDhqIVYVhMsOTesq9OHcDkI=
X-Gm-Gg: AYBFou2a0l1WPmB7KIslgeI3OjUghIcC4dPDrFY1pc1apD0WCleYLKr/yl2akQlIVNO
	Xmwi3/gS52cCq88Hg2coG6Lz4aLewkM7hoA5ly6l2cSU+IYr+SaZsbs9pA8xTXu4MYKjRCgB1+5
	sbLHbpAOWTj2MB+TEe520oLbrw7tLzHE2xeN9eXuyaWor7GIZ1G9g8igo9S+D1vrBJ7b5f+An8i
	iRXxfRAGetibPPkxfrKaGERrwBfj/yGSu0sgJQbd9Gg51OOPc/JabHfJShHKGqf5T6/B17letI3
	Iqz+iYE5oEKVHtBo3Sqv5dnrM4ZbmKyvbashbenYPxF65pUuNURYQmTMpnZwpoc8yH64cIv5RtO
	uqrkoxe2dSyJcdoryki5a/qKx2EVsFGFkokHHOWvxqZgbMZanKHNjRdNVKKyE0LfmPa+fUZud6t
	HRRdooKR+ZqvKT5h+bT7hhM3wCWGm1JOiUlgU1DOgSgmWbtj14JrJmvUf5f9usI0xX5P9jyJc=
X-Received: by 2002:a05:622a:4d93:b0:55d:2e93:ffad with SMTP id d75a77b69052e-55d76ac5898mr77806251cf.37.1795206644053;
        Fri, 20 Nov 2026 12:30:44 -0800 (PST)
X-Received: by 2002:a05:622a:4d93:b0:55d:2e93:ffad with SMTP id d75a77b69052e-55d76ac5898mr77805261cf.37.1795206643352;
        Fri, 20 Nov 2026 12:30:43 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921347a0b6bsm34804246d6.1.2026.11.20.12.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:30:42 -0800 (PST)
Message-ID: <4569fb5f7f3d7c65263d4154d7cc3350d9cf8330.camel@redhat.com>
Subject: Re: [PATCH v2 0/3] scsi: mpi3mr: Fix error return, start_time, and
 timeout check in mpi3mr_bring_ioc_ready()
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
Date: Fri, 20 Nov 2026 15:30:41 -0500
In-Reply-To: <20261120190031.1587531-1-irogers@google.com>
References: <20261120190031.1587531-1-irogers@google.com>
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

On Fri, 2026-11-20 at 11:00 -0800, Ian Rogers wrote:
> Split the mpi3mr_bring_ioc_ready() error-handling and retry fixes
> into
> three independent patches with individual Fixes: tags as requested by
> Laurence Oberman:
>=20
> 1. Return -1 instead of 0 on failure exits in
> mpi3mr_bring_ioc_ready()
> =C2=A0=C2=A0 when retval is 0 (such as unrecoverable controller faults, h=
ot-
> unplug
> =C2=A0=C2=A0 during reset/diag-save waits, or ready-state faults and time=
outs
> =C2=A0=C2=A0 after mpi3mr_setup_admin_qpair() sets retval =3D 0).
> 2. Initialize start_time =3D jiffies on entry and guard the post-enable
> =C2=A0=C2=A0 timestamp reset with a boolean flag so pre-enable failures a=
nd
> =C2=A0=C2=A0 subsequent retries never read an uninitialized start_time.
> 3. Rewrite 'elapsed_time_sec < (mrioc->ready_timeout - 60)' as
> =C2=A0=C2=A0 'elapsed_time_sec + 60 < mrioc->ready_timeout' to avoid 32-b=
it
> =C2=A0=C2=A0 unsigned underflow if a controller reports ready_timeout < 6=
0.
>=20
> v2:
> =C2=A0 - Split v1 into three patches, each with its own Fixes: tag
> (Laurence
> =C2=A0=C2=A0=C2=A0 Oberman).
> =C2=A0 - Move 'if (!retval) retval =3D -1;' to 'out_device_not_present:' =
in
> =C2=A0=C2=A0=C2=A0 patch 1 so a single hunk covers both out_failed fallth=
roughs and
> =C2=A0=C2=A0=C2=A0 early out_device_not_present jumps cleanly for stable =
backports.
> =C2=A0 - Add Laurence's Reviewed-by tag on patches 1 and 2, and note the
> =C2=A0=C2=A0=C2=A0 510s (570s - 60s) firmware timeout math from commit 96=
34bb07083c
> in
> =C2=A0=C2=A0=C2=A0 patch 3.
>=20
> v1:
> https://lore.kernel.org/r/20261119170900.1530138-1-irogers@google.com
>=20
> Ian Rogers (3):
> =C2=A0 scsi: mpi3mr: Return error on all failure exits in
> =C2=A0=C2=A0=C2=A0 mpi3mr_bring_ioc_ready()
> =C2=A0 scsi: mpi3mr: Initialize start_time on all paths in
> =C2=A0=C2=A0=C2=A0 mpi3mr_bring_ioc_ready()
> =C2=A0 scsi: mpi3mr: Avoid ready_timeout underflow in
> =C2=A0=C2=A0=C2=A0 mpi3mr_bring_ioc_ready()
>=20
> =C2=A0drivers/scsi/mpi3mr/mpi3mr_fw.c | 11 ++++++++---
> =C2=A01 file changed, 8 insertions(+), 3 deletions(-)

Hello Ian

Thanks for the quick v2. Tested the series on 7.4.0-rc1 with a
Broadcom SAS40xx/41xx (FW 8.5.1.0.0.1), two SAS disks attached.

Firmware advertises "ready timeout: 510 seconds" (ioc_info
0xff000000), before and after the series.

Tests, all with mpi3mr_bring_ioc_ready() reaching ready on the first
attempt and no "retrying to bring IOC ready" or "failed to bring"
messages:

 - boot probe
 - modprobe -r / modprobe (mpi3mr_init_ioc path)
 - sg_reset -H under fio 4k randread QD32 (mpi3mr_reinit_ioc path);
   host reset completed in ~45s including diag save and port enable,
   fio completed with no errors
 - PCI remove/rescan of the controller
 - 20 iterations of reload + host reset under fio: 40 successful
   ready transitions, no retries, no failures, no fio errors

The failure paths themselves were not exercised, as they are hard to
trigger on healthy hardware; this confirms no regression on the good
path.

Minor, 3/3 changelog: the IOC info timeout field is 8 bits in 2s
units, so ready_timeout tops out at 510s and the retry window at 450s;
the "510 seconds" in 9634bb07083c most likely refers to the maximum
ready timeout rather than the retry cap, so 570s cannot be advertised.
Doesn't affect the code change. Martin may be able to fix it up on
apply.

The question to Broadcom on firmware advertising ready_timeout < 60
is still open for 3/3; on this controller it makes no difference.

For the series:

Tested-by: Laurence Oberman <loberman@redhat.com>

Regards
Laurence

