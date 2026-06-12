Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C93921D8
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262155; cv=none; b=EYPzIm45EE5VV99rq53kvdTVsmcwSHSMf9CRi54/TyGurfYwZLxRxXmajJQP3/W7jUnrb2QES8xT5HQBfmOS3+u6wO+K1XLICfaTegt8+BNEddFHQRV0YL4KS2G0fN76Wgl4ub7c/hkEJ/EqT3kw0V4jcQeZXFhXP34YlHsPyIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262155; c=relaxed/simple;
	bh=FVMYSBxgVCOCPl5hW3eIOcbretvo5wTPocm8os89ocU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jWx0b09rBOfX6rGeDq30RaMQjjSCAVA6ucFOh50igjLUg9+KPzb+SMUFKad2wQqFTwbJuerWqsrhxTOpn4+/CFizxVzPh4zuUodoEJcBpEqeodVkZbMUmC9In2+wMaLTcNevWXwTJcLDc3D/O8qNiWP/rozQF8O8I/XHC/eKKwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIcbqD6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIcbqD6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF3D1F000E9;
	Fri, 12 Jun 2026 11:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781262154;
	bh=FVMYSBxgVCOCPl5hW3eIOcbretvo5wTPocm8os89ocU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DIcbqD6+nP/KhcWcxJ7TbfjcWg6Y6hPx48EUM1MRGvnkrukWV6F0HMx6qfWtmh9if
	 6QdVDPUBCfriI2mXbSwRMo+WBWfQBmsPCNxvXEZu7AERLG4F4xOBiPxpJOq7N0K+Rm
	 yEN/Q7ddQM9JvRzc2BH2oA9cKEUvJLjZ62pUg0qQ585pRB26zYcMv2G4Jtb2YqW2H5
	 4qO5VSMK4UhERImU64wR6OM1CUgKYrES/s+7JJXunErqQVZuuq2gDzUL5t9k+XXOXj
	 hMOLxkiIoX3b9QnVGLwaTqKV3IKaoMpcTs5gMaXSP0hFq2eNLos1kyjtVQS0xB3s4w
	 1ZOBzN59cNa/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 41/60] scsi: qla2xxx: Unify NVMe IOCB build path for
 29xx and legacy adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-42-njavali@marvell.com>
References: <20260612095333.1666592-42-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:02:33 +0000
Message-Id: <20260612110234.1AF3D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The commit message claims to add a `reserved_end` field to `vp_r=
pt_id_entry_24xx_ext`, but the patch does not include this modification.
--

commit 2686364fecc2e5c624549321eb96a8c16ffc376c
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Unify NVMe IOCB build path for 29xx and legacy adapters

This commit unifies the IOCB build code for struct cmd_nvme and struct
cmd_nvme_ext by writing common header fields through a single view. It also
adds BUILD_BUG_ON checks to ensure the header layouts remain identical up
through the byte_count field.

> Also add a BUILD_BUG_ON size check for struct cmd_nvme_ext during
> module initialization and a reserved_end field to
> vp_rpt_id_entry_24xx_ext to ensure proper memory allocation and data
> integrity for 29xx series adapters.

[Severity: Medium]
The commit message mentions adding a reserved_end field to
vp_rpt_id_entry_24xx_ext, but I don't see any modifications to that
structure in the patch. Is this description leftover from a previous patch,
or is the structure modification missing from this commit?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D41
