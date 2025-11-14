Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D684233FE02
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763141570; cv=none; b=RGoRZbQyOtCX6Fcbw4P5KwatZ1HPOqBD8wnYj7nZ3vYsoRoscj6iAQ9TxavLjTTvbN9aka1umME4paeqxm1m53RJTURrhxOxJWQQ0f66LuQKCMw7LCwDelOakTQ/IwH7I41BNsi3wBrPM/m1GY5r++EPIma+00fMWoNm/S34e54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763141570; c=relaxed/simple;
	bh=jZlKa3VfMskB1iRAuMmVMVCO03pUwLrei03uI8Oon4Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HKdZuQzsk/pEEO0RQSg7j1Ixp4cfxT01AgVjK+mJTNeIJyGZGbODI8/TF4bUmxhqgKNaiElIa9E6qNDUXaEhlmaAnxfHZcBswsRwacVIMEHKVQdyJj2Fm6lpLwkQRge37PrLvOYkK8warymMvywbTdMxKuUk3Vu+woRjuHZdnG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fnYVdA3d; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fnYVdA3d"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4777707a7c2so25984775e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 09:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763141565; x=1763746365; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GHGlxTyM1S9bVA7OPYYI98vIum/cNEfrzEzPEF41E2E=;
        b=fnYVdA3dSRHXAqS3+tSOpe7CD8FPkiakslbZQak4IpI2LSoLbelrMTcHExuN6I5+si
         bd8+fx0uUzvt3YSxzBu3HDgGLt+p1Rg+GBQCZZLKOTK2NJobpH6jk67n4Urab9rJFfTi
         m51jGBFSFxvbfPC2YaXYQALGzA8zL3R+sfC9dwxftI7pDVsAFTR1ZNUuJEF6baT5dWwj
         lXKDiUKBSdn52m7V4rkOyIL85lXL7syNGa+jWtyVVgG+BsHn332CCIAlTJhAObPDaMVJ
         VAbispXa2u1T6AIF2AZetjQgd3hQ1tfoJAi8E+/lEaaihAyL7tOWwB2R+56J4uOW67Xt
         pteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763141565; x=1763746365;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GHGlxTyM1S9bVA7OPYYI98vIum/cNEfrzEzPEF41E2E=;
        b=L3fn3SY6wgzdE/FyEGSnh1O290P/aIVAdjTbSj3pPoZoe2WnbPJGvHsNN0Bkuuutgq
         f7+Eb/Y+gQ9zj+9n8iOKD8bhkAsCg5Ty0ai8oqIMU4//m2zsPORbzAB2vfeCaNLy7kcp
         r6Xl1b3Fuk9yz0jrKKtBNw57a+py6JBuMXNxF+HdhyjiIIw1YZMxzv/F5NLCnFm49QWx
         dDda74qM6gTJGu/lpXNKpEinWIBoJ71YwyALMXvgOJ96WpP3iah15zfzRPoPCC4G1EvP
         sFAlmCBZW/wUUyEAodtrYZ2efvPtokpdU5+iKC0tYKn6JBQjA9lgw0XR2hJZdn0++gy2
         qBBQ==
X-Gm-Message-State: AOJu0YzMJhG2dyTQyeyS+hywQ/EShszB6e4vCx/lvykRkCPUaJpJ80yf
	yJ4+eM6s0Cyiowf3dbTkeO7RipNfnvPKd6QcRQ/H16/aJLGYb/Cb469nUEeQ8KOq5nA=
X-Gm-Gg: ASbGncsA+FpPiUJfBbogQ4MWiyuMB++0WURHTVRKqaNiWTwg5Sgf8YxT8YHgN7Ii1EP
	fEKTce1ExyU1HuSiQz7QF+yidjvHmB0V8FVnS/58Utm1n9qC/6sVCv84MneDhHB40+BXCG1PGIx
	HQ9ETZkKpBNQzAh9joczJON0OSAb5aBgaO3mWN+cNLbj9v5IwQ+/Awt3lFrEpucXK2kjKEobykE
	eeGRuxZrf2IIOQRaCMIqS7Eccf+We9uuw+KNqsg9t5EpX2RLz4l7BheQQyzqi7YFfpXDV5HqlQt
	9d+TIobMhdyHS90yCgHZMZX4IhyU9G9y5Q4d/rz/0+mpTIpfWYkPFkYZZJ8hbhZHMqBkCcrl8RM
	SnDstgxr0PYxNVclg8QRORCQ/8WXHFAzz9gwBThWDDcTO67xv0f38BcfliYzsdbgsv2IVHh2HDV
	7pKEB84ZGsdfFV1pCS
X-Google-Smtp-Source: AGHT+IEy740Uwa2HGGm2xBqeM/jYhBLvGwzC4iK3av/XNgZEhsM6+bXME38A/OnNstOD2syUIzS08g==
X-Received: by 2002:a05:600c:58cc:b0:477:632c:47bc with SMTP id 5b1f17b1804b1-4778bccf574mr51428485e9.6.1763141564842;
        Fri, 14 Nov 2025 09:32:44 -0800 (PST)
Received: from draszik.lan ([212.129.74.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4778bcf75b8sm52008775e9.1.2025.11.14.09.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 09:32:44 -0800 (PST)
Message-ID: <83ffbceb9e66b2a3b6096231551d969034ed8a74.camel@linaro.org>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Bart Van Assche
	 <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Avri Altman <avri.altman@sandisk.com>, Bean Huo
 <beanhuo@micron.com>, "Bao D. Nguyen"	 <quic_nguyenb@quicinc.com>, Adrian
 Hunter <adrian.hunter@intel.com>
Date: Fri, 14 Nov 2025 17:32:43 +0000
In-Reply-To: <c988a6dd-588d-4dbc-ab83-bbee17f2a686@samsung.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
		<20251031204029.2883185-22-bvanassche@acm.org>
		<CGME20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5@eucas1p1.samsung.com>
	 <c988a6dd-588d-4dbc-ab83-bbee17f2a686@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-2+build3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

On Fri, 2025-11-14 at 11:12 +0100, Marek Szyprowski wrote:
> Hi,
>=20
> On 31.10.2025 21:39, Bart Van Assche wrote:
> > Instead of letting the SCSI core allocate hba->nutrs - 1 commands, let
> > the SCSI core allocate hba->nutrs commands, set the number of reserved
> > tags to 1 and use the reserved tag for device management commands. This
> > patch changes the 'reserved slot' from hba->nutrs - 1 into 0 because
> > the block layer reserves the smallest tags for reserved commands.
> >=20
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>=20
>=20
> This patch landed in today's linux-next as commit 1d0af94ffb5d ("scsi:=
=20
> ufs: core: Make the reserved slot a reserved request"). In my tests I=20
> found that it causes boot failure on Qualcomm Robotics RB5 board. Here=
=20
> is the log from UFS probe failure:
>=20
> ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
> ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find=20
> vdd-hba-supply regulator, assuming enabled
> ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
> ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find=20
> vdd-hba-supply regulator, assuming enabled
> scsi host0: ufshcd
> scsi host0: nr_reserved_cmds set but no method to queue
> ufshcd-qcom 1d84000.ufshc: scsi_add_host failed
> ufshcd-qcom 1d84000.ufshc: error -EINVAL: Initialization failed with=20
> error -22
> ufshcd-qcom 1d84000.ufshc: error -EINVAL: ufshcd_pltfrm_init() failed
> ufshcd-qcom 1d84000.ufshc: probe with driver ufshcd-qcom failed with=20
> error -22

FWIW, I'm seeing the same on Pixel 6:

exynos-ufshc 14700000.ufs: ufshcd_populate_vreg: Unable to find vdd-hba-sup=
ply regulator, assuming enabled
exynos-ufshc 14700000.ufs: ufshcd_populate_vreg: unable to find vcc-max-mic=
roamp
exynos-ufshc 14700000.ufs: ufshcd_populate_vreg: Unable to find vccq-supply=
 regulator, assuming enabled
exynos-ufshc 14700000.ufs: ufshcd_populate_vreg: Unable to find vccq2-suppl=
y regulator, assuming enabled
exynos-ufshc 14700000.ufs: scsi_add_host failed
exynos-ufshc 14700000.ufs: error -EINVAL: Initialization failed with error =
-22
exynos-ufshc 14700000.ufs: ufshcd_pltfrm_init() failed -22
exynos-ufshc 14700000.ufs: probe with driver exynos-ufshc failed with error=
 -22

>=20
> The 1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved=20
> request") is the first commit which breaks UFS probe, but=C2=A0next-20251=
114=20
> fails in a bit different way:
>=20
> ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
> ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find=20
> vdd-hba-supply regulator, assuming enabled
> ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
> ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find=20
> vdd-hba-supply regulator, assuming enabled
> scsi host0: ufshcd
> Unable to handle kernel NULL pointer dereference at virtual address=20
> 0000000000000000
> Mem abort info:
> =C2=A0=C2=A0 ESR =3D 0x0000000096000004
> =C2=A0=C2=A0 EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> =C2=A0=C2=A0 SET =3D 0, FnV =3D 0
> =C2=A0=C2=A0 EA =3D 0, S1PTW =3D 0
> =C2=A0=C2=A0 FSC =3D 0x04: level 0 translation fault
> Data abort info:
> =C2=A0=C2=A0 ISV =3D 0, ISS =3D 0x00000004, ISS2 =3D 0x00000000
> =C2=A0=C2=A0 CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> =C2=A0=C2=A0 GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> [0000000000000000] user address but active_mm is swapper
> Internal error: Oops: 0000000096000004 [#1]=C2=A0 SMP
> Modules linked in:
> CPU: 0 UID: 0 PID: 131 Comm: irq/148-ufshcd Not tainted=20
> 6.18.0-rc5-next-20251114 #11692 PREEMPT
> Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
> pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : ufshcd_compl_one_cqe+0x24/0x4ac
> lr : __ufshcd_transfer_req_compl+0x24/0x64
> ...
> Call trace:
> =C2=A0=C2=A0ufshcd_compl_one_cqe+0x24/0x4ac (P)
> =C2=A0=C2=A0__ufshcd_transfer_req_compl+0x24/0x64
> =C2=A0=C2=A0ufshcd_poll+0xe4/0x204
> =C2=A0=C2=A0ufshcd_transfer_req_compl+0x44/0x54
> =C2=A0=C2=A0ufshcd_sl_intr+0x1f0/0x670
> =C2=A0=C2=A0ufshcd_threaded_intr+0xb8/0x198
> =C2=A0=C2=A0irq_thread_fn+0x2c/0xa8
> =C2=A0=C2=A0irq_thread+0x1d4/0x410
> =C2=A0=C2=A0kthread+0x150/0x228
> =C2=A0=C2=A0ret_from_fork+0x10/0x20
> Code: a9025bf5 aa0203f5 f9401c00 f9413000 (b9400002)
> ---[ end trace 0000000000000000 ]---
> genirq: exiting task "irq/148-ufshcd" (131) is an active IRQ thread (irq=
=20
> 148)
> ufshcd-qcom 1d84000.ufshc: ufshcd_abort: cmd at tag 0 already completed,=
=20
> outstanding=3D0x0, doorbell=3D0x0
> ------------[ cut here ]------------
> WARNING: drivers/scsi/scsi_error.c:305 at scsi_eh_scmd_add+0x110/0x118,=
=20
> CPU#1: kworker/u32:1/61
> Modules linked in:
> CPU: 1 UID: 0 PID: 61 Comm: kworker/u32:1 Tainted: G D=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
> 6.18.0-rc5-next-20251114 #11692 PREEMPT
> Tainted: [D]=3DDIE
> Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
> Workqueue: scsi_tmf_0 scmd_eh_abort_handler
> pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : scsi_eh_scmd_add+0x110/0x118
> lr : scmd_eh_abort_handler+0x84/0x1c8
> ...
> Call trace:
> =C2=A0=C2=A0scsi_eh_scmd_add+0x110/0x118 (P)
> =C2=A0=C2=A0scmd_eh_abort_handler+0x84/0x1c8
> =C2=A0=C2=A0process_one_work+0x208/0x604
> =C2=A0=C2=A0worker_thread+0x244/0x388
> =C2=A0=C2=A0kthread+0x150/0x228
> =C2=A0=C2=A0ret_from_fork+0x10/0x20
> irq event stamp: 15902
> hardirqs last=C2=A0 enabled at (15901): [<ffffd07807e1da44>]=20
> _raw_spin_unlock_irq+0x30/0x6c
> hardirqs last disabled at (15902): [<ffffd07807e12970>]=20
> __schedule+0x410/0xf94
> softirqs last=C2=A0 enabled at (13916): [<ffffd07806b46b64>]=20
> handle_softirqs+0x4c4/0x4dc
> softirqs last disabled at (13905): [<ffffd07806a90688>]=20
> __do_softirq+0x14/0x20
> ---[ end trace 0000000000000000 ]---
>=20
> Let me know how can I help debugging this issue.

The commit that makes it crash is:

  08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")

the ones leading to it just fail probe.

LKFT link https://lkft-staging.validation.linaro.org/scheduler/job/198696

Cheers,
Andre'
