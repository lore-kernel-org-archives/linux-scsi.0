Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E803388E58
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407999; cv=none; b=S4TEutlCk7RVcALO/HYXX+IoT6L68AMw41vhewc4r3hYpyg1F05oILp7MRLV9sieg1ex6mvUeIwAvnMDq83KEAHtNDQhahHEJ00AeDkVlVEaqu31O7vTQIQrG2Dyzg8Ga8GhiDxjGlhidj1TshEYCm7hF5AYQyUAt6MmgMXbJxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407999; c=relaxed/simple;
	bh=nmvMIbd5iqtiu32DP5VP86u65ZEGaCejkXITqcWzR+E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WrOOmu7XQASZzg/tVjB2OCCPgUdFPsMxqSoON5nA+Umen6FmVcAuaaO36Bb3Uu/6LSJf9KbwHUVd1Mz7MwOn6iKxswjgCqxorsyiIfPX/1BY0UsD3nG95hURkRBR/R3/6JYcPHtWVosR7aOpMeMMjYkbT7w7AkuciHYafqQw6+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZQHnNEn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZQHnNEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E081F000E9;
	Tue,  7 Jul 2026 07:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407998;
	bh=KkHANDaqXC3+DiJhPoBWVYXPLthfRFe9+ErRFVSsLNU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dZQHnNEna9MdaXR2FqwSuRMIs3FFrOSNaSoV1LLKgUMMQIQS2k6VDc7498t+NI+ca
	 r+0sKex4tNtXgMIYajcC/yTvnGZn6TJkDoMEc1iG+v6NDaVGoxL11JQXWllxH9T7Er
	 yx0UcDk+Gj1JnQlLppLamH9k/p3YTAi4GC+z7wxj10xapHuU1XqN1NTRCY7d2EEbX4
	 pT66eux4KrwgTd6FCEPClSoMZ3e042loMriJCb+UjrHvS2iEG9qPP54uuv6s4tcg9D
	 W5k/GrfW4djElDy1wM5PvFoCY8Ex5LG0KwCVebDn3NVbAbPVEnWpO2YC1RlPNOtstC
	 xpjQOynKll9qQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 56/88] scsi: qla2xxx: Clamp MSI-X derived queue
 counts to avoid truncation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-57-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-57-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:06:37 +0000
Message-Id: <20260707070638.50E081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch failed=
 to fully resolve the ZERO_SIZE_PTR vulnerability it aimed to fix. A malici=
ous or misconfigured PCI device returning a capability offset that causes h=
a->msix_count to become 0 still leads to a ZERO_SIZE_PTR allocation and sub=
sequent out-of-bounds write.
--

--- Patch [56]: [PATCH v3 56/88] scsi: qla2xxx: Clamp MSI-X derived queue c=
ounts to avoid truncation ---
commit 96603c11bc04fcf9f524adb1b5140a4ef7b1d7f9
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation

This commit adds qla_calc_queue_count() to clamp the derived MSI-X queue
count into a valid range. This prevents an allocation of zero elements
that leads to memory corruption when too many vectors are advertised.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 186c6c7a39448..5209dda454596 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2132,7 +2132,7 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
>  		ha->msix_count =3D msix + 1;
>  		/* Max queues are bounded by available msix vectors */
>  		/* MB interrupt uses 1 vector */
> -		ha->max_req_queues =3D ha->msix_count - 1;
> +		ha->max_req_queues =3D qla_calc_queue_count(ha->msix_count);

[Severity: High]
This isn't a bug introduced by this patch, but it looks like the ZERO_SIZE_=
PTR
vulnerability this patch aims to fix might still be reachable through a
different path.

If a malicious or misconfigured PCI device returns 0xFFFF for
QLA_PCI_MSIX_CONTROL, could ha->msix_count wrap to 0?

drivers/scsi/qla2xxx/qla_os.c:qla2x00_iospace_config() {
    ...
    pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
    ha->msix_count =3D msix + 1;
    ...
}

Later in qla24xx_enable_msix(), if pci_alloc_irq_vectors() successfully
allocates vectors (e.g., returning 2), the condition (ret < ha->msix_count)
evaluates as (2 < 0) due to type promotion, which is false:

drivers/scsi/qla2xxx/qla_isr.c:qla24xx_enable_msix() {
    ...
    } else if (ret < ha->msix_count) {
        ...
        ha->msix_count =3D ret;
    }
    ...
    ha->msix_entries =3D kzalloc_objs(struct qla_msix_entry, ha->msix_count=
);
    ...
}

This leaves ha->msix_count at 0, resulting in kzalloc_objs() returning
ZERO_SIZE_PTR.

When the base vectors are unconditionally initialized shortly after, does
this cause an out-of-bounds write by dereferencing ZERO_SIZE_PTR (0x10)?

drivers/scsi/qla2xxx/qla_isr.c:qla24xx_enable_msix() {
    ...
    /* Enable MSI-X vectors for the base queue */
    for (i =3D 0; i < QLA_BASE_VECTORS; i++) {
        qentry =3D &ha->msix_entries[i];
        qentry->handle =3D rsp;
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D56
