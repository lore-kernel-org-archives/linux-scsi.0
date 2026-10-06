Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1A388E76;
	Tue,  6 Oct 2026 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330770; cv=none; b=EpHxS2S0duEYRBdi7Kx/WvUdFGUAPCadU/SU7ujU2748zYY3hp9yIWpnQqveqf4AdraWMl2TzeZbZfNlHRqGsTch1XODXfFMPmbYCIhcbNhBEgrtInqM5j1E/8ZoCLYmyIyLv+vN9qRvTRVVxJLcJ7F/KjUvoGgr5iLp5obnav4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330770; c=relaxed/simple;
	bh=2Vqjq8TtVtJ/EtFYNTVjMITquBIXW0D1ZW3r1RUbXFw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OE2Zsr1fbLd4ah2nXCyyI3xNGawxJrNIVwOIVFQdtq8p32tZ5PnFmc8pAxJlGv5nHgFgZBCC1jhFon97BNZc9AyCQBQw8b3Vl5K8oZ1sWsz75K3Nqxw0F7TGslbe84erNDXoOOzNUoRBAZpdeFmtLm0uZJY3GseFFxIL8JOmwG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THDnYGbP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THDnYGbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2A61F0089B;
	Tue,  6 Oct 2026 23:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330768;
	bh=2Vqjq8TtVtJ/EtFYNTVjMITquBIXW0D1ZW3r1RUbXFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=THDnYGbPYn9OM1dFEG0ail0KrF50HEkj8/XZcdLPnKUhkg4YtA14fhRRdnIUJgw6A
	 lx1vXJBUBKzwUYr5XxBDU4B/u3XQ6Dcjd06Enk6ND3dxvIv6WuR8pV1prJ6SOFM34i
	 t+KonqFSYu8vxG2iZLYCbRsKn2YEoaU3gl1tuxqCR6JjLlKFXNVa32Xv+e4At4WYM2
	 TLjE4iO+sodvz+41MCUCybQd6mWDxGuT9EhyQLKbgBAA9Jo+sECtfgIyQ6167zFwXM
	 MIKa4DArDevOf+XaXM0YvpVYPntadAWeQV5/lGr2pbULM5ztCVuNEZXKey5wevoDla
	 O+NZUisy6oNoQ==
Message-ID: <sashiko-outbox-162532@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 05/11] scsi: sr: retry unfinished media revalidation
 on the next open
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20261006234202.1139018-6-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
 <20261006234202.1139018-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:52:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: sr: uninitialized stack memory read of sshdr in sr_revalid=
ate_disk()
--

commit 6831e2d4751ec5b84e9b7b08a5e93e7b6123ef75
Author: Phil Pemberton <philpem@philpem.me.uk>

scsi: sr: retry unfinished media revalidation on the next open

This commit updates the scsi sr driver to keep media revalidation pending
until it completes, handling cases where a new disc is still spinning up.
It introduces a mechanism to return -ENOMEDIUM for blocking opens if the
drive reports it is becoming ready, ensuring the queue limits update is
eventually completed.

[Severity: Medium]
Could the new check in sr_revalidate_disk() result in an uninitialized stack
memory read if the scsi command fails early?

In drivers/scsi/sr.c at line 485 within sr_revalidate_disk(), the code
evaluates scsi_sense_valid(&sshdr) and reads sshdr.sense_key, sshdr.asc,
and sshdr.ascq. However, sshdr is allocated on the stack without
zero-initialization.

If scsi_test_unit_ready() encounters an early failure (such as an allocation
failure in scsi_alloc_request() returning -ENOMEM or -ENXIO), it returns the
negative error code immediately without populating sshdr. Since the new log=
ic
checks scsi_sense_valid() whenever scsi_test_unit_ready() returns non-zero,
it will read the uninitialized sshdr.response_code.

If the random stack data happens to match the 0x70 mask required by
scsi_sense_valid(), the code will further evaluate the uninitialized
sense_key, asc, and ascq fields. Can this cause unrelated errors to be
incorrectly masked as -ENOMEDIUM, or trigger KMSAN uninitialized memory
warnings?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006234202.1139=
018-1-philpem@philpem.me.uk?part=3D5
