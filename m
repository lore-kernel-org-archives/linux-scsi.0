Received: from riemann.telenet-ops.be (riemann.telenet-ops.be [195.130.137.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5522724A058
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741181675; cv=none; b=gr3Dx5CbpnEVskiHHAWRsRxJwv4dn4kYu8OoSORU8SclnATCvlZl2Akj3RjduBCIKUo1WfgnfEAGvSLvdnQvGCRRtUEP4BZOik88CQfLRQwefTS/3anSmfeBXEdPkrDV8hFONdNjKRND7EmuRcgl/ljTgu9byMoEsulHFuh0tzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741181675; c=relaxed/simple;
	bh=hLoRlqyS+e+uGVZDKx7s0osOIjH8n6sXEfL9c8+Q+ck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qQfpcUjYMyDUviMlIpOLP8AX/yrblmyMnNJtGfzrOJ3v+Mg295h6p6S8B6R0TkxzWaijearRfJSJRfIF63o55v/Ni1sMwSBUfjvmsZ0pxbRtLxPssSfly26PHZ7Bjsmn/wsZ9Hl221Q5iW2a9SOR5Tioi3Ik99CtPg7tMXLaQz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
	by riemann.telenet-ops.be (Postfix) with ESMTPS id 4Z7D6v3B0mz4x29x
	for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2025 14:34:31 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:fba:8cad:3d23:9db3])
	by albert.telenet-ops.be with cmsmtp
	id M1aL2E00D0exi8p061aLDL; Wed, 05 Mar 2025 14:34:23 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tposn-0000000Cv3p-0vwh;
	Wed, 05 Mar 2025 14:34:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tpot8-00000008woK-16wH;
	Wed, 05 Mar 2025 14:34:18 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 0/7] scsi: ufs: renesas: Add support for R-Car S4-8 ES1.2
Date: Wed,  5 Mar 2025 14:34:08 +0100
Message-ID: <cover.1741179611.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

	Hi all,

Initialization of the UFS controller on R-Car S4-8 ES1.0 requires only
static values.  However, other UFS controller variants (R-Car S4-8 ES 1.2)
require dynamic values, like those obtained from E-FUSE, and downloading
firmware.

Hence this patch series refactors the initialization code to prepare for
this, and adds support for the UFS controller on R-Car S4-8 ES1.2.
The accompanying DTS change is available at [1].

Changes compared to v2[2]:
  - Take over from Shimoda-san,
  - New patches 1/7 (DT bindings update) and 7/7 (actual R-Car S4-8
    ES1.2 support),
  - Keep MAX_INDEX check, as it is still useful,
  - Prefix data parameters of ufs_renesas_write_d0_d4() by "data_", for
    consistency,
  - Document kernel size impact of switching to init code,
  - Rename ufs_renesas_init_ufshc() to ufs_renesas_init_step1_to_3(),
  - Extract ufs_renesas_init_step4_to_6(),
  - Move ufs_renesas_write_phy_10ad_10af() just before its sole user,

Changes compared to v1[3]:
  - Postpone removing the *_INDEX* enums until all users are gone,
  - Combine declaration and initialization of ufs_renesas_init_param,
  - Drop "_param" from ufs_renesas_*() helper function names.
  - Move MODE_READ handling after MODE_POLL handling,
  - Move ufs_renesas_read() after ufs_renesas_poll(),
  - Remove not just MODE_WAIT, but all of the struct-based control.

This has been tested on:
  - Renesas Spider with R-Car S4-8 ES1.0 (broken before/after),
  - Renesas S4 Starter Kit with R-Car S4-8 ES1.2 (works after).

Thanks for your comments!

[1] "[PATCH] arm64: dts: renesas: r8a779f4: Add UFS tuning parameters in
     E-FUSE"
    https://lore.kernel.org/3e4fca228eb049d54a1ae520104558505dbdf803.1741179629.git.geert+renesas@glider.be
[2] "[PATCH v2 0/5] scsi: ufs: renesas: Refactor code for other UFS
     controller"
    https://lore.kernel.org/20240709023550.1750333-1-yoshihiro.shimoda.uh@renesas.com
[3] "[PATCH 0/5] scsi: ufs: renesas: Refactor code for other UFS
     controller"
    https://lore.kernel.org/20240708120931.1703956-1-yoshihiro.shimoda.uh@renesas.com

Geert Uytterhoeven (1):
  dt-bindings: ufs: renesas,ufs: Add calibration data

Yoshihiro Shimoda (6):
  scsi: ufs: renesas: Replace init data by init code
  scsi: ufs: renesas: Add register read to remove save/set/restore
  scsi: ufs: renesas: Remove register control helper function
  scsi: ufs: renesas: Refactor 0x10ad/0x10af PHY settings
  scsi: ufs: renesas: Add reusable functions
  scsi: ufs: renesas: Add initialization code for R-Car S4-8 ES1.2

 .../devicetree/bindings/ufs/renesas,ufs.yaml  |  12 +
 drivers/ufs/host/ufs-renesas.c                | 723 +++++++++++-------
 2 files changed, 445 insertions(+), 290 deletions(-)

-- 
2.43.0

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
