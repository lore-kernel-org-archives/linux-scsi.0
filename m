Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3CE32BF5D;
	Sat, 18 Jul 2026 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784402795; cv=none; b=OMl+bO8VL+VBEh9rk4J3GZu1p6lfrUDIw0tw9sxiolGZ3/ENw4dVjlstGlX7f2C5+HjCO/OzyKCO7LlbFIOVRfe155tR9ZapgrE0n8y78X5+w4GKVaLL0CFCGeeS52B8NsiwQIyq+Y0oUAdbIBRh4OmDv5GNwY4NVXbfnESnRn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784402795; c=relaxed/simple;
	bh=DwaZsoS00lL5fb6GQo2rcOCCHP4lnaGBq5gIlXYcZqc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=nVKLdUNTWwEV2lTaFSmrXBmbMif4uXmXjvf2HLUiQ/7RtsfRQfxc06wnn3XbyiHLPvg+nSmk30hyG++f9UtjMF0EgBV5DPLmAv+SG9LcqGRIYXw3ba2P7KqDJg38qyycNa40SJVP0dV72WsgkoAxJpnczobuuglllaslyFoUBIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=CMqqlYZO; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="CMqqlYZO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784402792;
	bh=DwaZsoS00lL5fb6GQo2rcOCCHP4lnaGBq5gIlXYcZqc=;
	h=Message-ID:Subject:From:To:Date:From;
	b=CMqqlYZORTjhqpfxQoP3p2VR1V4DZS5FyCtFa3eZTSisBGAmWrsXGimNkBghlKkvK
	 zaaoHqsGTwygppi/98ydrZxJvLL2EIXpb8XeoatAnOAZjZF04C0seEbvq1D7m2BTus
	 88tnpUK581wI0I2ksFa1EoGn4WwJ5XzcNqhFOXts=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 151D71C0364;
	Sat, 18 Jul 2026 15:26:32 -0400 (EDT)
Message-ID: <910bf36b4027bfa4ea7cd0e01a97de2d4f082300.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.2-rc3+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 18 Jul 2026 15:26:31 -0400
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

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482=
:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to e166bafc483e927150cb9b5f286c9191ea0df84e:

  scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path (2026-07-12 22:21=
:22 -0400)

----------------------------------------------------------------
The biggest core change is the reliable wake fix for scsi_schedule_eh
which is used by both libata and libsas which could otherwise cause
error handler hangs due to rare races.  All other fixes are in drivers
(well except the export symbol removal) the next biggest being the
target PR-OUT transportid parsing fix.

Note, Steve Rostedt managed to push his ufs fix separately through
the tracing tree, but git was OK with it on a test merge so we didn't
want to rebase the tree to remove it.
----------------------------------------------------------------
Abdun Nihaal (1):
      scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()

Arnd Bergmann (1):
      scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_port=
attr_block()

Bryam Vargas (2):
      scsi: target: Bound PR-OUT TransportID parsing to the received buffer
      scsi: target: core: Fix iSCSI ISID use-after-free in REGISTER AND MOV=
E

Catalin Iacob (1):
      scsi: core: Remove export for scsi_device_from_queue()

David Jeffery (1):
      scsi: core: wake eh reliably when using scsi_schedule_eh

Haoxiang Li (2):
      scsi: elx: efct: Fix I/O leak on unsupported additional CDB
      scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path

Martin K. Petersen (1):
      Merge branch 7.2/scsi-queue into 7.2/scsi-fixes

Michael Bommarito (2):
      scsi: xen: scsiback: Free unsubmitted command instead of double-putti=
ng it
      scsi: xen: scsiback: Free the command tag on the TMR submit-failure p=
ath

Steven Rostedt (1):
      scsi: ufs: core: tracing: Do not dereference pointers in TP_printk()

WenTao Liang (1):
      scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()

Xu Rao (1):
      scsi: sg: Report request-table problems when any status is set

 drivers/scsi/bfa/bfa_fcs_lport.c        |  2 +-
 drivers/scsi/elx/efct/efct_hw.c         |  2 +
 drivers/scsi/elx/efct/efct_unsol.c      |  1 +
 drivers/scsi/hosts.c                    |  2 +
 drivers/scsi/hpsa.c                     |  4 ++
 drivers/scsi/lpfc/lpfc_init.c           |  3 +-
 drivers/scsi/scsi_error.c               | 22 +++++++-
 drivers/scsi/scsi_lib.c                 |  8 ---
 drivers/scsi/scsi_priv.h                |  2 +
 drivers/scsi/sg.c                       |  7 ++-
 drivers/target/target_core_fabric_lib.c | 89 +++++++++++++++++++++++++----=
----
 drivers/target/target_core_internal.h   |  3 +-
 drivers/target/target_core_pr.c         | 12 +++--
 drivers/ufs/core/ufs_trace.h            | 36 +++++++++----
 drivers/xen/xen-scsiback.c              | 30 ++++++++---
 include/scsi/scsi_device.h              |  1 -
 include/scsi/scsi_host.h                |  3 ++
 17 files changed, 168 insertions(+), 59 deletions(-)

Regards,

James
