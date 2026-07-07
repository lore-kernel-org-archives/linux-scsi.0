Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECD13876B8
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783404777; cv=none; b=d9iMe3mpSJmk/B5Lx5+yhcl9lfKI+sIRyv0R0D5BOls4mKrVbkGp/UQ9SR+CCG06RV10RpHAHfUTKTjzYxRZl8ivKwP7pBVzf2RR7wY9DXp/zO3juhq8Hqk7AyLka7xS/KUUM0ZrRLpFsZrc3FtcmD2XG5nVfDT6Ngr+xLqpDF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783404777; c=relaxed/simple;
	bh=5iTLNgCRjpBand1jZBIoI4h68aLmc0KpQTt5drnHm5E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WVIMt7oZzye3uRooCsrvYHyZr80Mstyvo78jflnIqVHXdQs0kL2roK7spCQETADUzBWKC6OaVPOi9c+x3xTpCwZwnw/I/8vSCFw1Plen9cYFCcFrEzJzszSK4X8W1hswBx2lIVy4LRpUnkjC3fw3FsBy8sdaaA4ggpMn87683x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3QpXrRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3QpXrRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34ED1F000E9;
	Tue,  7 Jul 2026 06:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783404776;
	bh=5iTLNgCRjpBand1jZBIoI4h68aLmc0KpQTt5drnHm5E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V3QpXrRodxdkoptGDWZlYXxfi69ETe0x7kEo3vvRNst6AgNPwLj7ZFLPujAvfkXsj
	 YDBLPH1QnDl26HkSJirafdVXi9qXrm8VQ0ZI0XMh02Rmw/IXkbq3lw9QqINtQ1TtI9
	 S/X14/UHu9hZalA1lNtKii2qwh8XLty6BqazzR6+q275S9XQMHI8rOweX6S7+lsxuA
	 H+5FARUW7E47JBvigPVGjWPS201mWg+Wlaw2c48Qc1eel8p/QhG10BdUPcKtUj/ws7
	 40iV1B3rO/qGaxjJ5o84p6xfQMAtMZe39NetNjTirc+S1jbEqoZe/KcqpzXU8atny0
	 dxCyRUhf0bfkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/88] scsi: qla2xxx: Skip image-set-valid attribute
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-13-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-13-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:12:55 +0000
Message-Id: <20260707061255.E34ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected read-modify-write on vha->dport_status can lead to sta=
te corruption.
--

--- Patch [12]: [PATCH v3 12/88] scsi: qla2xxx: Skip image-set-valid attrib=
ute for 29xx ---
Note: Due to automated recitation restrictions, the diff is not quoted inli=
ne=20
below. Instead, a free-form summary of the findings in the context of the=20
modified file is provided.

commit 2275f80f5bc3cc74a549d7aa22a8aac6742fae34
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Skip image-set-valid attribute for 29xx

The 29xx adapter does not support the QLA_IMG_SET_VALID_SUPPORT driver
attribute. This commit gates the attribute behind an IS_QLA29XX() check to
provide accurate capabilities to userspace.

[Severity: High]
This is a pre-existing issue and was not introduced by this patch, but while
reviewing the related code in drivers/scsi/qla2xxx/qla_bsg.c, I noticed a
potential race condition in qla2x00_do_dport_diagnostics_v2().

Does the bitwise modification of vha->dport_status (specifically when setti=
ng
DPORT_DIAG_IN_PROGRESS) need to be protected by a lock, such as the
hardware_lock?

Since this read-modify-write happens in process context, it seems like it
could race with the asynchronous event interrupt handler. If a user issues a
BSG diagnostic command concurrently with the hardware completing a previous
command, the interrupt handler might clear a bit while this process context
overwrites the status using a stale read.=20

Could this cause flag updates to be lost, potentially leaving the diagnosti=
cs
state machine permanently stuck in an in-progress state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D12
