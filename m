Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B950623394E;
	Sun,  2 Aug 2026 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785675102; cv=none; b=F7BIVwcXAgKKvnJaoe9RC9W0ri9+dxZpg9C2HbpcyBOHB30PJXpTBUzT1eNsSg4ulZKpqBIj3SYcSpiaM6xpfAaHcOD2D3xTv0f5SgX2u3dR84bCxoJeLw7UQZwT3UgBjFtDQ9xtNOBM85qCRzmIH+97/uWWJ6dbNF+lPbsDkr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785675102; c=relaxed/simple;
	bh=sCmUdCDeG3i7l7+2gbADV/ogHNLL9GDIdIroKNatETo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=uaasy4xunzvWJHfR+pdw0aEpzPH72B6iRL049VrpWk0j6pT7W5uEnlVgRA2/880Lfywff9t9stvglQocVUGZYaL+q04AAjoNI1chVAah1fItA4CzPIB0+YdpeS/x30EAwiqVH8u6BELYscij4D6gpZtl33mfHqzKhF6C8KB0ZBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=cwdIl6Ma; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="cwdIl6Ma"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1785675099;
	bh=sCmUdCDeG3i7l7+2gbADV/ogHNLL9GDIdIroKNatETo=;
	h=Message-ID:Subject:From:To:Date:From;
	b=cwdIl6Maquhg/51LmVuQ3WyFw+44lvpYCoRTGWeFJEMqBmh2Qe1dLc0Z1npav+6hw
	 l23c83IIw3DKPcyiZVtvpY5Tj2l4srLgbV0AW4vcv4oBeqwdghtEXXCqq218BUoLIt
	 vGn/QdfunqTS7JBsHdUE4D92Xqgl/zdi37x7yK0o=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 75DC11C014D;
	Sun, 02 Aug 2026 08:51:39 -0400 (EDT)
Message-ID: <62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.2-rc5+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sun, 02 Aug 2026 08:51:38 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The following changes since commit
e166bafc483e927150cb9b5f286c9191ea0df84e:

  scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path (2026-07-12
22:21:22 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/
tags/scsi-fixes

for you to fetch changes up to
0279fd451a9971c0d5b959fc59f3e11b55e1694e:

  scsi: ufs: core: Initialize hba->rpmbs list in ufshcd (2026-07-28
22:26:51 -0400)

----------------------------------------------------------------
SCSI fixes on 20260802

No core changes.  The largest driver fix is the reversion of threaded
interrupt handlers in UFS and the next is the resume deadlock fix in
hisi_sas which extends into libsas.

Sorry for the last minute pull request.  This time I managed to spill
soup in my laptop on a business trip and fried the motherboard, so I've
only just got back home to a desktop.
----------------------------------------------------------------
Ao Sun (1):
      scsi: ufs: core: Initialize hba->rpmbs list in ufshcd

Bart Van Assche (1):
      scsi: ufs: core: Revert "Delegate the interrupt service routine to a =
threaded IRQ handler"

Benjamin Block (1):
      scsi: zfcp: Fix memory leak during adapter release by destroying gid_=
pn_req

Chandrakanth Patil (1):
      scsi: mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit

Guangshuo Li (1):
      scsi: ufs: core: Cancel RTC work in active-active suspend

HyeongJun An (2):
      scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer
      scsi: libiscsi_tcp: Bound SCSI Response data segment to the connectio=
n buffer

Ibrahim Hashimov (1):
      scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write

Leon Romanovsky (1):
      scsi: target: Clear cmd_cnt when initial counter enrollment fails

Shawn Guo (1):
      scsi: ufs: dt-bindings: Add missing mcq reg for qcom,sa8255p-ufshc

TanZheng (1):
      scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE

Xingui Yang (1):
      scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race

 .../bindings/ufs/qcom,sa8255p-ufshc.yaml           |  9 ++++-
 drivers/s390/scsi/zfcp_aux.c                       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 10 +----
 drivers/scsi/libiscsi.c                            |  2 +-
 drivers/scsi/libiscsi_tcp.c                        |  8 +---
 drivers/scsi/libsas/sas_init.c                     | 37 +++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  9 ++++-
 drivers/scsi/scsi_debug.c                          |  8 +++-
 drivers/target/target_core_iblock.c                |  6 +--
 drivers/target/target_core_transport.c             | 12 +++++-
 drivers/ufs/core/ufs-rpmb.c                        |  2 -
 drivers/ufs/core/ufshcd.c                          | 46 ++++--------------=
----
 include/scsi/libsas.h                              |  1 -
 13 files changed, 64 insertions(+), 87 deletions(-)
