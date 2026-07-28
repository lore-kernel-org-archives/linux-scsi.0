Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88083FC5AA
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 09:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231980; cv=none; b=t9J1JTvKsTfBkoa5qSt7shc3E2HI5aVcenxYntMglFvdS9qSzlyMfdkvuJ6Uw6axGSBj6kdwiFyRTOKxfDdiKb1nHM8qbN4iuvK5ehHn4w+7oIXCJNSs5Z+BPii8aBkSeHjWDWOeJEizeD9UD2RiJAycSf0h9V5A+ZZgcxwNawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231980; c=relaxed/simple;
	bh=VABtenmjIORlg8kfQiUSzmcykJy5J3tWs8l8dNEoVBE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DPg0Utzu8efwN2j7StkBLBe+bmRgUdXGF58K+cpVgk9H/+2bcCHOdpTpOvFhYAc2jAi0vVU8ZUYoPpctVRshUN1dXJZOrzSbfxKEMZupPFbxIYxEBduqSVN9ZptqqjBHQodiOQCVmE7b2oP2pFpaV56Pf7OpTkEXtae7q+h+63Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mf8Nr9M3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mf8Nr9M3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E551F000E9;
	Tue, 28 Jul 2026 09:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785231978;
	bh=6STWtq8lgc+ezuh00c880DiysE4bz5C7sF7BqRHRfkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mf8Nr9M3Si08sbePhqNEEaI5E4qaX1cQ0/OkV9gi56W09/fRM19lW2228HXk0l/N4
	 HqPdiuiLv3aFDI4FyoULYryin21QXB67JFswUU75TVqOudCf5xvvnnONh2zVdJi7fz
	 VUkDhZdyGyhUggULIMyrSdA+diKCsW4dBGLChxakSGvwyezq9qBehqv/qKsJmy9ia4
	 Jxnorzcve1Nl/lIW9okMGH5DGjt9q2bdzps3jcmHOAF81wHdHhLiYO+1NLZw6QX0iM
	 /Qz63jXqJBbRkqwErjY3hwi0zVYqAL55eWuFzPiQpoUc+kMPniH0cIAm4hAHVHmn7j
	 8Io8YLFw9xvvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] scsi: ufs: Add support for the aggregated read
 query opcode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hyeoncheol Jeong" <hyenc.jeong@samsung.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260728092741epcms2p8c53432ef3c2f0d6a63dd980ad5ef9f00@epcms2p8>
References: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
 <CGME20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
 <20260728092741epcms2p8c53432ef3c2f0d6a63dd980ad5ef9f00@epcms2p8>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:46:17 +0000
Message-Id: <20260728094618.55E551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Fallback to SDB mode after `ufshcd_alloc_mcq()` failure uses freed=
 or uninitialized command queues.
--

--- Patch [2]: [PATCH v4 2/2] scsi: ufs: Add support for the aggregated rea=
d query opcode ---
commit 687c47ee8e9a0aab4800ae50a40defa3e567d065
Author: Hyeoncheol Jeong <hyenc.jeong@samsung.com>

scsi: ufs: Add support for the aggregated read query opcode

This commit introduces support for the UFS 5.0 AGGREGATED READ query opcode.
It allocates a dedicated device management command descriptor (UCD) with a
larger response area to handle packets up to 4 KiB, bypassing the standard
shared pool for the reserved tag.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 79331c2bd38de..328320b8119cc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -9236,7 +9286,7 @@ static void ufshcd_release_sdb_queue(struct ufs_hba=
 *hba, int nutrs)
>  {
>  	size_t ucdl_size, utrdl_size;
> =20
> -	ucdl_size =3D ufshcd_get_ucd_size(hba) * nutrs;
> +	ucdl_size =3D ufshcd_get_ucd_size(hba) * (nutrs - UFSHCD_NUM_RESERVED);
>  	dmam_free_coherent(hba->dev, ucdl_size, hba->ucdl_base_addr,
>  			   hba->ucdl_dma_addr);

[Severity: High]
This is a pre-existing issue, but does this fallback path lead to a
use-after-free or NULL pointer dereference?

When ufshcd_alloc_mcq() is called, if the new MCQ tag depth differs from the
SDB tag depth, it frees the existing SDB queues:

ufshcd_add_scsi_host() -> ufshcd_alloc_mcq()
    ufshcd_release_sdb_queue(hba, old_nutrs);

It then attempts to allocate new queues via ufshcd_memory_alloc(). If this
fails, it restores the tag depth and returns an error without reallocating
the SDB memory:

    ret =3D ufshcd_memory_alloc(hba);
    if (ret)
        goto err;
    ...
err:
    hba->nutrs =3D old_nutrs;
    return ret;

The caller, ufshcd_add_scsi_host(), catches the error and deliberately falls
back to SDB mode:

    err =3D ufshcd_alloc_mcq(hba);
    if (err) {
        /* Continue with SDB mode */
        ufshcd_mcq_disable(hba);
        use_mcq_mode =3D false;

Since the SDB queues were freed and not successfully reallocated, won't any
subsequent command in SDB mode use freed or uninitialized command queues?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728092208epcms=
2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8?part=3D2
