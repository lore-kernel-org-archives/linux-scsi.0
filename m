Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1053360EC9;
	Fri, 31 Jul 2026 22:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535464; cv=none; b=WzvOoxQb4Kj5vbNXesHmntDfvcHKGqegbeEA0r2L4oEpuYtylOX44sM4inEAW38lXP56yqXqf18lwLEJgDX9maft+QKof6OqI21EakwM0nPfI/WG5Q9kpZpU+PVSsEkHEayGXpxZSdxJ1CVOQ21rfgpIU49rZxyKVdi4nC04Cww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535464; c=relaxed/simple;
	bh=6v+e8J7Ga2ga/S5tc0dgUxipO+HsB0nFME2cR1qdf7g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TinuhUgIiZkxRWJtR2p7D//scR7QFTxLisBD1QLuDvOiXOpx4tv3QrnK7bWwQHfejRKN9C268h89mOD+ex2zZSvaUoJmg/TpwcBl2I2d6POUuwUMLOBqupBzL7F1+fBY5Aj0r+BPR9vtjtAQPlKlaviHLR6PUNZR2O7Wj+rTkyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLJU7mEF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLJU7mEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9801F00AC4;
	Fri, 31 Jul 2026 22:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535462;
	bh=ItEfHUu31oEr5goCuZzh/Bx49TX+DqsN7M+GTN7i3g0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fLJU7mEFJv2EyAH3w6K2m7q7WqLWBxnlA8vxTxt2RolC6YL7tTlR470Hbwya0wvT3
	 GtEKLwoAHjMGlnAoXAxH9zvpiNBzsyiHnQjANH1RBFgyEgS5IrjtlppR7ySVhmckpL
	 MGnoGWKbDagO4eASeyY4e7dv51DAzSabwPV7IuYDSbnHulC7DLsQUAIX36WZfodn+A
	 Wqs/xvuzjHnlFn7V9f4WNOGh3T2RMkgzmxe/OotWIdJsyh5u+0bMMjtL1tsBcyGsFi
	 54XTpQvXUFXRnC0Mq+2/yQXvvH5CPpzOkvvxxkM9vuONtsdVHtXZ6OMxB6BtKhivAX
	 ckCPiEV9PPwLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/6] scsi: add BLIST_NO_LUN_1F blacklist flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260731213503.2379771-5-philpem@philpem.me.uk>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <20260731213503.2379771-5-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 22:04:22 +0000
Message-Id: <20260731220422.8F9801F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Concurrent modification of `struct scsi_target` bitfields introduc=
es a data race, potentially causing updates to `pdt_1f_for_no_lun` or `expe=
cting_lun_change` to be lost.
--

--- Patch [4]: [PATCH v8 4/6] scsi: add BLIST_NO_LUN_1F blacklist flag ---
commit 90f0f3c59ea5fbec1b6c95c81d334666e21cd3a9
Author: Phil Pemberton <philpem@philpem.me.uk>

scsi: add BLIST_NO_LUN_1F blacklist flag

This commit adds the BLIST_NO_LUN_1F blacklist flag to allow devices to
suppress spurious "No Device" entries for unpopulated LUNs returning
PQ=3D0/PDT=3D0x1f. The flag is wired up in scsi_probe_and_add_lun() to set
starget->pdt_1f_for_no_lun.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c

[ ... ]

> @@ -1296,6 +1296,9 @@ static int scsi_probe_and_add_lun(struct scsi_targe=
t *starget,
>  	 * PDT=3D00h Direct-access device (floppy)
>  	 * PDT=3D1Fh none (no FDD connected to the requested logical unit)
>  	 */
> +	if (bflags & BLIST_NO_LUN_1F)
> +		starget->pdt_1f_for_no_lun =3D 1;
> +
[Severity: High]
This isn't a bug introduced by this patch, but could this bitfield assignme=
nt
introduce a data race with other bitfields in struct scsi_target?

Looking at include/scsi/scsi_device.h, pdt_1f_for_no_lun shares the same
memory word with other bitfields:

    unsigned int            single_lun:1;
    unsigned int            pdt_1f_for_no_lun:1;
    unsigned int            no_report_luns:1;
    unsigned int            expecting_lun_change:1;

If a multi-LUN device reports a LUN change (REPORT LUNS DATA HAS CHANGED) on
an active LUN, scsi_report_lun_change() will set expecting_lun_change =3D 1=
 in
softirq context.

Simultaneously, if the system handles the LUN change by rescanning the
target, scsi_probe_and_add_lun() executes in process context and sets
pdt_1f_for_no_lun =3D 1.

Because these contexts perform read-modify-write operations on the same
memory word without mutual exclusion (the softirq does not hold
shost->scan_mutex), one of the updates might be lost.

If expecting_lun_change is lost, the SCSI layer fails to handle a LUN change
UNIT ATTENTION correctly, which on removable devices triggers a spurious
media-change event (cmd->device->changed =3D 1 and ACTION_FAIL), failing
in-flight I/O. If pdt_1f_for_no_lun is lost, spurious LUNs may be added.

>  	if (((result[0] >> 5) =3D=3D 1 || starget->pdt_1f_for_no_lun) &&
>  	    (result[0] & 0x1f) =3D=3D 0x1f &&
>  	    !scsi_is_wlun(lun)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731213503.2379=
771-1-philpem@philpem.me.uk?part=3D4
