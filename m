Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCBB4189BA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801669; cv=none; b=Hct05YdTwFxUuelURqqz+dHrH51v9vGbe392nKisIX8Mvlzw5S8MSJJ75EGzWGQxhYi+ZXQrZldjO47Psg7kpCdaq6vCJ3L/UcgBa7+G9XozorI7sE5ePi98S5GwL8F9m6tSyUkA8bCvJhYGC34BN1BzaTg7fj8QqoRIe+yUxVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801669; c=relaxed/simple;
	bh=118hLk67mU2MXBMQ7dgCpgkcqRi+nFQq38cRv1Cq5Ig=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LVCalwaF837FbGeTvYZdk+YIrCCCDrSPv/xG0isK+tLZuU2EDyAlp1siV6lsV2vOQI7wjybTurqHkC5ouekwXMxFktlCI17Hrk/kUI+fLpF6I/FzibILQbqVHutRWOP9OEk2ltoXLd01q4O6VHRZDHKs0JyKmhJjROMCuHc5DAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBGkAD8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBGkAD8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC72B1F000E9;
	Thu, 23 Jul 2026 10:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801667;
	bh=118hLk67mU2MXBMQ7dgCpgkcqRi+nFQq38cRv1Cq5Ig=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KBGkAD8epFf5QhSsD/MSpA5PPyUqAWQ6O4fJqI7SB58SsuIITB9T1dDTd6+viH3x4
	 3ZC8NaUj2hITsi/mo0CPWicVw1qhEK71XXIWSFvaDd8ORw9gaiUpwZpPx693uyKA8n
	 mPYZVxFl55qnBNM9SBlVjohfCOkPmKjsIbvMxYPWJXZeL90WgC0LcaXfpyAvGqgxD4
	 qyCBkE6ttgRhkwyWMJdSTZOfDXjkd+RW2NZGX2YwQKQsYnLFM1FmgLIw502d8JZsRS
	 S7f41+ANYC0I5Y4V1AY0XR2UNDrqodJxT076A2dOxoORxHna/8Rvo6cNImsDgnKJPk
	 igI9eLDtxoQ6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/28] scsi-multipath: introduce basic SCSI device
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-13-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-13-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:14:27 +0000
Message-Id: <20260723101427.AC72B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Typo in the SPDX License Identifier comment.
--

--- Patch [12]: [PATCH v4 12/28] scsi-multipath: introduce basic SCSI devic=
e support ---
commit c8c9718e45aaf5b29f96266700711505a59de724
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: introduce basic SCSI device support

This commit introduces basic native SCSI multipath support by adding the
scsi_mpath_device structure and a module parameter to control the feature.
It integrates multipath device allocation and release hooks into the SCSI
scanning and sysfs device release paths.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> new file mode 100644
> index 0000000000000..b9b58a3641aa2
> --- /dev/null
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Indentifier: GPL-2.0

[Severity: Low]
This isn't a bug, but there is a typo in the SPDX license identifier
(Indentifier instead of Identifier). Will this cause automated SPDX
compliance tools like scripts/spdxcheck.py to fail to recognize the license
tag?

> +/*
> + * Copyright (c) 2026 Oracle Corp
> + *
> + */

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D12
