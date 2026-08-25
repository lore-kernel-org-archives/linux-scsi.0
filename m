Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267F6335091
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674710; cv=none; b=LXe4OKCzJLPrgP1F4CY/piJu/o1dFDhvnkXDb1Z9pBtPx9P3EzktXBP0ZmrnesaK5lxSYeob8+oyzvFioAXpMlmUnX0NYD5u19qSNlBQQfj2jjnNIlywGeVZOkXBWuvbT/do4bUGA++k+UxrGTwLeahAWixeB2ULCnOOHTZzMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674710; c=relaxed/simple;
	bh=QQg0FFQa/OVRUXF+CjRkEvF/vM/BnloLRU7fgELlmYE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h/+KXAtmz1ONTAX+gxsW7bhA6WDYyMuKhk33J1iuKMVkTp5oWqQXx4U8mV0WoWA9r1VO+/f2YNrYFz4vGumDJsiPMeUIekj0jZ5ca5ooMVciCJwVq32TShCQU5p8hSNJ8zVHWd5kXjpD1D/1j7ojTQxAP1FWgDJZrdQuvWjlXLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXrOpI8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXrOpI8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8941A1F000E9;
	Tue, 25 Aug 2026 16:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674708;
	bh=XFJXcKV/f2feshTQt9VkG50FxAzZVB7rlgeYAQPffVU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kXrOpI8ny50gP5aONaZKWscNhs4PMzbw9aHJKUEQLp5UIPRgnwvDurE9adXHqDxCT
	 zt803AkkfPVE3XSAb8NcgN59G0elfQPt59xQ9/FuKhdjzAepNYtSo9Wmhr9hML8SbF
	 +lkuiiy3Txpo55yPBwMU5O7o6Tcch4fVCADMLgZ++BQBNLb8mn+e6wSY73qQxciodN
	 hnpxE+8cEzmCPhotRoXAuWM1HWP0Dkkog/M46F68o7bBEWV7Bd5SpgTEXZQzmnRBWP
	 4OX1L7ygu+smRXeoqjpC02tVyyHus1S5T7rc1J2j78Evefj7GaJoLqBip1m8vbh6iy
	 DqaUGFN4R3oYg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/17] mpi3mr: Fix out-of-bounds phy array access on
 link change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-13-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-13-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:18:28 +0000
Message-Id: <20260825161828.8941A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double-put on `tgtdev` causing a reference count underflow and pot=
ential use-after-free.
- [High] Bitwise shift `(1 << i)` is used to construct a `u64 phy_mask`, ca=
using sign-extension and out-of-bounds array access for i >=3D 31.
- [High] Casting a `u64` bitmask to `(ulong *)` for `for_each_set_bit()` sw=
aps bit mask halves on 32-bit big-endian architectures.
--

commit 0f7fb7e1d3f3dab2157cb8912f1ddaf0e9989416
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds phy array access on link change

This commit adds a bounds check in mpi3mr_update_links() to ensure the
phy_number from a link change event does not exceed the number of allocated
phys for the node. This prevents an out-of-bounds array access on the
node's phy array.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..2afff1a002ed9 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
[ ... ]

[Severity: High]
This is a pre-existing issue, but looking at mpi3mr_sastopochg_evt_bh()
in drivers/scsi/mpi3mr/mpi3mr_os.c, when processing events with a target
not responding reason code:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_sastopochg_evt_bh() {
    ...
            mpi3mr_tgtdev_put(tgtdev);
            break;
    ...
        if (tgtdev)
            mpi3mr_tgtdev_put(tgtdev);
}

Does this result in a double decrement of the tgtdev reference count,
causing premature freeing of the target device structure? Similar logic
appears to exist in mpi3mr_pcietopochg_evt_bh() and
mpi3mr_devinfochg_evt_bh().

[Severity: High]
This is a pre-existing issue, but looking at how the phy mask is updated
in mpi3mr_sas_port_add() in drivers/scsi/mpi3mr/mpi3mr_transport.c:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
            mr_sas_port->phy_mask |=3D (1 << i);
    ...
}

Since 1 is a signed 32-bit integer, evaluating it up to num_phys (which can
be 32 or greater on enterprise HBAs) could produce a negative value that
sign-extends to 0xFFFFFFFF80000000ULL when implicitly cast to the u64
phy_mask.

Can this cause out-of-bounds array accesses on the phy arrays?

Another instance with the identical signed shift occurs in
mpi3mr_refresh_sas_ports():

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_refresh_sas_ports() {
    ...
        h_port[port_idx].phy_mask =3D (1 << i);
    ...
}

[Severity: High]
This is a pre-existing issue, but looking at how phys_to_be_added is
processed in mpi3mr_update_mr_sas_port():

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_update_mr_sas_port() {
    ...
    for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u64)) {
    ...
}

The variable phys_to_be_added is allocated as a 64-bit u64. On 32-bit
big-endian platforms, unsigned long is 4 bytes.

Is it possible that casting the u64 bitmask to (ulong *) for
for_each_set_bit() causes it to process the most significant 32 bits first,
treating bits 32-63 as bits 0-31 and vice versa, leading to incorrect port
mappings?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D12
