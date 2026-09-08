Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECDA359A70;
	Tue,  8 Sep 2026 07:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788853346; cv=none; b=WS9OfHijxt2f37VG2qsFU1bvOgiCWLo0Un1Q9W0hHtNnIwE972OJ4hlcFLvd42bTf8jhqp5MPKC3gbRye9L/6TUDNfVn71Ztqe2ljW1iltBg8KINmY8SxPLonhOuwQjr3r/lEewkM1wI5T1XUh8IFu9lpXrUs3o8Dha7XMk4fpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788853346; c=relaxed/simple;
	bh=mbQgsh1zPtyhIoEc7mEatFQs0vx3FMGzb/CQNHQ7ksQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NKJqVVpT2ED44AHT2G9jzEZie8SD/ein3CM7tT8eUE8q2Yuxpc9ICsw5NnS04TeTKJurFSiI2KeU/wSHyKuj825Ho/W5wastrab74rJINbvEcDNRKm3oXJVUa74pfHT/3bX639yH/SI+RU1y/wwmoBfGPiCSPaEwR8we0XufGbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQ40zBgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQ40zBgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CB21F00A3A;
	Tue,  8 Sep 2026 07:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788853344;
	bh=Yt1ZLsvwz/wveJofjkyiXfvUzjQechzWtb2oZEGlA/w=;
	h=From:Subject:Date:To:Cc;
	b=jQ40zBgc23lic+NuVuVAzpZG44j577aLye3z8QU9/+wDtcXrubdlZdLtSUQScKw5F
	 jF1OAysQcfhMobuKNk33dLg9xzM0OYMN1AQV84fhaSNhxGWrt6mmsXTgD1E3vlSGdj
	 Pb24Me2QTue/rJCqxEf/rFLDRxc0FmYh3fdz88uVFhEC6+gvRDWDjUISHASB5CI1/a
	 eH/VcGgJMWES8MtHgfIZ3n1xRHjekd0M4IQ8tBkWAdg27ksuUAmFv7Sj/u9Lbhw+1N
	 Z2srWtd92wqhhGB/2KqwLzkOO+bK9O0gX4AXyFdByozKyWGwiA/LQ/diSm2DOAL8Dl
	 TgogVUPLh18xA==
From: Yixun Lan <dlan@kernel.org>
Subject: [PATCH v4 0/3] Add UFS Host driver support for SpacemiT K3 SoC
Date: Tue, 08 Sep 2026 07:42:02 +0000
Message-Id: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEq8n2oC/23OQW7CMBAF0Ksgr5lqPHaMxYp7VF3YYZK4VElkJ
 xYI5e51YNEisvzSn/fnLhLHwEkcd3cROYcUhr4Evd+JunN9yxDOJQtCMmiwArRwUTA3CdI8jkO
 coLZeoWUtKyZR7sbITbg+zM+vZ06z/+Z6WqG10YU0DfH2GM1y7T39A9KGnyUgSGe0U85Lss3pw
 rHnn48htmIdyPSPoK0Xc3FBV6iMI0da2jdC/REWzRahCoHq0HhF5OqzfyGWZfkF2kpctEsBAAA
 =
X-Change-ID: 20260605-08-k3-ufs-support-c8b308e415e2
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, "Martin K. Petersen" <mkp@kernel.org>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 Aurelien Jarno <aurelien@aurel32.net>, 
 Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yixun Lan <dlan@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3244; i=dlan@kernel.org;
 h=from:subject:message-id; bh=mbQgsh1zPtyhIoEc7mEatFQs0vx3FMGzb/CQNHQ7ksQ=;
 b=kA0DAAoBMarqR1lNu+0ByyZiAGqfvE7I3t+a7bAehgD0o2WyQ3zVqB7WU61ZsNQvgOxfOjw8H
 YkCrwQAAQoAmRYhBLW6uMnDG3EVZwIj3DGq6kdZTbvtBQJqn7xOGxSAAAAAAAQADm1hbnUyLDIu
 NSsxLjEyLDIsMl8UgAAAAAAuAChpc3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9
 yc2VtYW4ubmV0QjVCQUI4QzlDMzFCNzExNTY3MDIyM0RDMzFBQUVBNDc1OTREQkJFRAAKCRAxqu
 pHWU277b5SD/wJL7El+uDwLn7vZJ2CtIW6GJUtmhMSIjA/F1PNlWTj/StgaNRpkRR6dRDsMPfp0
 7PUZQ8N4VN8423CmoZA2/Y6h6c9E9tWuUQerR8tS3lWRkubfRUVe0gfc2wbyjMMirABZIOg5isx
 Y05PIDPxVvyNwpzAZhQG2MHtjhj+/wosWg939Sni/yNwa2NfUIMB+0SFrWcJqRtbY0MhhcU7dqS
 Kg6wDsZC5hVn+HRmcjtdoDfJOq4EBEVzwU8pazstfquTU/O3djISyja4DQl3KokAGH9A/aHU9fK
 i2I9Mm4DB8w10ZLjhnAmpKKS6DJJ88QnAujoPBJgNFsZYNDZTjsC8PrjAebYj+E1BkE+QbP5nCD
 RyHahIUaLxpCKOtfWhteCjcDCZuXSAKd4k1x9oZPiuztj3EPjIohA8f8sc2Day8o7o5C8nZyUKQ
 O3fo495M0idcPnv7fzaPVt7vyN9qUytT3OlwddpVNBtXN5LuTCcHowHlJ9A/zj/3XyQV6zB+cL9
 KyAwxxjfXjROsJ4+cZLBv5plhf/YJL4v/jwxy162S0O4Zz8AM5wEQen0OZ6mN+0ChVKGdeRhOVp
 LVAcjNVFNiZ2f18rxryodcdOg/2pGrAqXLG8TIiMddeCi3/VUiTkrYGe8Y8ycsCnZarKDNJimHO
 HEDMiEq0e2RtZC1M8POPA==
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

This series try to add UFS support for SpacemiT K3 SoC, the controller
components consists of System Bus Interface Unit, UFS Host Controller
Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
Management Entity (DME), Transport Layer, Network Layer, Data Link
Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
block diagram can be found in SpacemiT website, chapter 9.7.3 [1]

One known issue is that the device will occasionally raise BKOPS interrupt
when doing some high load test, log from dmesg shows

[  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1

Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
Signed-off-by: Yixun Lan <dlan@kernel.org>
---
Changes in v4:
- fix clock and reset settings
- drop function which retrieve value of tx_lanes
- propagate return error of ufs_spacemit_dme_set()
- check return value ufs_spacemit_check_hibern8()
- drop call to ufshcd_vops_phy_initialization()
- handle compiling warning if CONFIG_OF not enabled
 add __maybe_unused to ufs_spacemit_of_match
- Link to v3: https://patch.msgid.link/20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org

Changes in v3:
- collect tags
- fix dt-binding warning reported-by sashiko
- fix low freq in opp-2 table
- fix err checking in check_hibern8()
- propagate err code in link_startup_notify()
- update documents for event_notify()
- ufs clock driver is merged into v7.3-rc1, update cover letter
- Link to v2: https://patch.msgid.link/20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org

Changes in v2:
- fix missing interrupts property
- move ufs node to k3-com260.dtsi
- convert freq-table-hz to operating-points-v2
- rework reset_control, fix header and drop global variable
- drop dump_host_regs() debug interface
- converge and refactor dme_set() operations
- massive reduce of busy delay() loops
- drop vendor specific hce_enable_notify(), fallback to default
- drop unused member from struct ufs_spacemit_host
- add COMPILE_TEST support to Kconfig
- comment style fix
- Link to v1: https://patch.msgid.link/20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org

---
Yixun Lan (3):
      scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
      scsi: ufs: spacemit: k3: Add UFS Host Controller driver
      riscv: dts: spacemit: k3: Add UFS support

 .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml |  56 ++
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi        |   4 +
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts       |   4 +
 arch/riscv/boot/dts/spacemit/k3.dtsi               |  22 +
 drivers/ufs/host/Kconfig                           |  12 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-spacemit.c                    | 678 +++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h                    |  79 +++
 8 files changed, 856 insertions(+)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Best regards,
--  
Yixun Lan <dlan@kernel.org>

