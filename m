Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFA43112C1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302938; cv=none; b=XIdZDmHWGmHGkCVGsgX1QnokXbI6zHl1H9gBPxw1TkSejTIf4jnlvh8vCaFH9/8xThpgWViFCNejUf0qZ1Ayhp3FHfJCabFONqVUtBUmAWFxE++TDQisPU2rqw597KpQ//Efjv44hTOE9FPyH/JI9yrj03CaKAyo4CgZwzk/wIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302938; c=relaxed/simple;
	bh=dhMAWoHFiIfVRnu8o8IusMietvU0E5N4tlkbKUJTtEs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uUzlvpqSTrtNu8RHj1Q2/jRVN05DEJRt/kbb01Q6V8XQ9I/mYkXSVWW6Ejk/5B7BRNQsLjDVo0c1NR/M4Ro3WZAQ43pfgyIf1qeBfrBSGfkOjJ0yu6+j+vJa4HQa1cFZStbNgLRBhZle7zRyEVs+/jdFqVz2Ykqj851Iquv2Y14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQkn2QEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQkn2QEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B491F000E9;
	Fri, 17 Jul 2026 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784302937;
	bh=THiN92YnU2BGUB+xGnTcPXGKmpM/x7uFgUXN01yQ7cI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JQkn2QEQ/yS2DPrYeT1Pc+lezRi37Kpn0Eowl2qEKucirjAeUkhqxkPGPckbOH+Jv
	 be27/AWGXnptg3nCX3Thlm6veUZiyW0Myi8+cdLHCFMRD8aSqy7YU42spzcedbRvA5
	 r9zCLks/lhDHxqeeLLbT4CMxDwNBU/D9/Q6UuvEbm1EduIqNFLXDbAjGdC1zZr9sb+
	 a6tpBVOMBYD+vom4ejTvBEqVCfqQMqbviMg57lvXSWqAu49XwMerKegaB0O69YIjIm
	 RjFkfuiZLkfqDYUlFJrevNvYZhMQX/8z8xsOitDatJVExpKF6GVCdjySho149Sy+ZX
	 AYRa6Oq/DRi7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/56] scsi: qla2xxx: Add extended status
 continuation and marker IOCBs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-11-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-11-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 15:42:16 +0000
Message-Id: <20260717154217.23B491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Commit Message and Implementation Mismatch
- [Low] Architectural Inconsistency in Header Placement
--

--- Patch [10]: [PATCH v5 10/56] scsi: qla2xxx: Add extended status continu=
ation and marker IOCBs ---
commit 1df9414084849f00c05087b262dc690e15f3cf79
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Add extended status continuation and marker IOCBs

This commit adds a 128-byte status continuation entry structure for 29xx
firmware and includes the new qla_fw29.h header. The commit message also no=
tes
the addition of a marker IOCB.

>     Add the 128-byte sts_cont_entry_ext_t and mrk_entry_ext_t
>     structures required by 29xx firmware.

[Severity: Medium]
Is this commit message accurate for the provided code changes?

The diff only introduces struct sts_cont_entry_ext without the _t typedef
convention, and entirely omits the mrk_entry_ext_t marker entry structure.
It appears the marker structure was added in an earlier patch under a
different name.

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 7423687578dc9..4de0de5cccc8d 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h

[ ... ]

> @@ -2360,6 +2361,15 @@ typedef struct {
>  	uint8_t reserved_2[48];
>  } mrk_entry_t;
> =20
> +/* 29xx definitions */
> +struct sts_cont_entry_ext {

[Severity: Low]
Should this 128-byte IOCB definition be placed in qla_fw29.h instead of
qla_def.h?

The qla_fw29.h header was recently created specifically to hold new 128-byte
IOCB definitions for 29xx and isolate them from earlier generations. Placing
sts_cont_entry_ext in the generic header seems to bypass the dedicated
firmware header.

> +	uint8_t entry_type;		/* Entry type. */
> +	uint8_t entry_count;		/* Entry count. */
> +	uint8_t sys_define;		/* System defined. */
> +	uint8_t entry_status;		/* Entry Status. */
> +	uint8_t data[124];		/* data */
> +};
> +
>  /*
>   * ISP queue - Management Server entry structure definition.
>   */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D10
