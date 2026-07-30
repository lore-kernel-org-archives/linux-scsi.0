Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E9B37E5D9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453558; cv=none; b=DQWmziV1usfqycCUECOqyjcwXDRLNKIlofehz+Ksrji3F3R5/diedEwY7JNrEoTRpd2FoJg+xEkUyU4q+eD++gJIrMmhNWyuDF1ZMhB7O7UDwuKFO535MOU4j2GkgvuVWmQyCwhGtkoG4J03RCQfoGQ3fDuZJ2mR5ivkMJnwcAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453558; c=relaxed/simple;
	bh=X28w2d6Hz6ReJpvfxyUIpmdp/YlP0tyn5dVONZgR918=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tg1psVq85QdEd0uBSDOS3fEMwVbnpE0kBqm1pF7YBj/4j3PVf69guoZM+8wbrth0p2eOKkHWRHBXiOVBPTPCBmpGtX1ESVovLTr7ALmdWq8Ua1keXxWkyUOqCCRXr53j04YtqGJImGglPE4kQmChxcy1rmCMJd1lt4b2K+Uvm7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxWICf5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxWICf5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF5C1F000E9;
	Thu, 30 Jul 2026 23:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453557;
	bh=0gcTBOnB0yBLxoBSeZYNATZNTUyNdplMCbk7vwE0ASs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JxWICf5IjC5E9y1E9XtUo5l2zccHDRgWqnUb13xX1AfdMxPQeovBEjIOHy9MYmRqb
	 5IDpQfZqTTXdd0U0PaKyBb4wlyRLEQQ8V34MbUKPWnSZ1ekh5nfqyIbHpjh0NOJiQG
	 ox/UTIbMS6UOuoUzffdPtILoH/aFrmifOn49GTbWaDcuQIjB4CbxxQn8UaBKstPY+K
	 UyybgRpB5K+ZzcxGMcHTQmzes9EXC2cSek7ntYxe7VGw8q4PrW/O75NfOU9/uSx7C1
	 L3+q83s1cyl/dhaWDsK5MYXJVtLkbbzZ5u/v7oG37TUVa3K1EiNYVMUMwX6BtKNOuz
	 v/jiltmUt7glg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 34/57] scsi: libfc: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <3c7650cbbecbaf615e264bf7c21e7eb101b818dd.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <3c7650cbbecbaf615e264bf7c21e7eb101b818dd.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:19:16 +0000
Message-Id: <20260730231916.DEF5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incomplete lock context annotations for intermediate and explicitly=
 locked functions, triggering static analysis warnings.
--

--- Patch [34]: [PATCH v3 34/57] scsi: libfc: Enable lock context analysis =
---
commit 713891d004459388a5a60d9452963a9f124605ff
Author: Bart Van Assche <bvanassche@acm.org>

scsi: libfc: Enable lock context analysis

Document locking requirements with __must_hold().

> diff --git a/drivers/scsi/libfc/Makefile b/drivers/scsi/libfc/Makefile
> --- a/drivers/scsi/libfc/Makefile
> +++ b/drivers/scsi/libfc/Makefile
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # $Id: Makefile
> =20
> +CONTEXT_ANALYSIS :=3D y
> +

[Severity: Low]
Does enabling context analysis here trigger compiler warnings for other
functions that are missing annotations?

For example, shouldn't fc_disc_stop_rports() and fc_exch_done_locked() be
annotated? They both explicitly require locks but appear to be missing the
__must_hold() annotations:

drivers/scsi/libfc/fc_disc.c:fc_disc_stop_rports() {
    ...
    lockdep_assert_held(&disc->disc_mutex);
    ...
}

[ ... ]

> diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
> --- a/drivers/scsi/libfc/fc_disc.c
> +++ b/drivers/scsi/libfc/fc_disc.c
> @@ -200,6 +200,7 @@ static void fc_disc_recv_req(struct fc_lport *lport, =
struct fc_frame *fp)
>   * @disc: The discovery object to be restarted
>   */
>  static void fc_disc_restart(struct fc_disc *disc)
> +	__must_hold(&disc->disc_mutex)
>  {

[Severity: Low]
Does fc_disc_recv_rscn_req() also need the __must_hold() annotation?

It calls this newly annotated fc_disc_restart() function, so without its own
annotation, could it break the analysis chain for its callers?

[ ... ]

> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -1950,6 +1953,7 @@ EXPORT_SYMBOL(fc_queuecommand);
>   * The fcp packet lock must be held when calling.
>   */
>  static void fc_io_compl(struct fc_fcp_pkt *fsp)
> +	__must_hold(&fsp->scsi_pkt_lock)
>  {

[Severity: Low]
Does fc_fcp_complete_locked() also need to be annotated?

It calls fc_io_compl(), so lacking a __must_hold() annotation might cause a
context imbalance warning during analysis.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D34
