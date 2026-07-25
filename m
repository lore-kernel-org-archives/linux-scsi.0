Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C88C31E838;
	Sat, 25 Jul 2026 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784975890; cv=none; b=GW24TE1YxOlcTYIS4roEG9VaXXWc9T3KQuCYaZvH9XWT/bD6EqMYojKs9Xu21e8FwAl6AX2TZIQgR9ICGYXwnhyL0n2AaYC3ZJkQ+iv+6EFuWDtymkM/I8KZARF78K+XuvPqYAUCktvrxMOdmf0mvfriiGCP0N+eMPTAByFpuUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784975890; c=relaxed/simple;
	bh=eXmWEEtkAKfn2G2yb6xl9rxhX/kxgd95q3ICmCrmT0Q=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=u6tYIZnTwGe1nrMUrESYiT6FpvfyMOTStbWcP9nYRZMmg9mecAPsA3/FMs+SnqP9CZrKPKnqcLU1Ii/ZpjGYWbWceoRytvG7oshTOEeT8uRpSJNCfaTZLmhCxzRM/RP1Miid1dC2fyRLuatuXK2Yh2/bhWXwfR95cB893uewAIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lexp+GPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lexp+GPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FEF1F000E9;
	Sat, 25 Jul 2026 10:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784975888;
	bh=HegWZo03+miiGxFg8RsqoHrY8wX5N/AFPIXsZy4iCxs=;
	h=From:Subject:Date:To:Cc;
	b=Lexp+GPxaKGhu9E5tRAWObKkCBVbt8PNkRVKPpkJ3rQr8axpkdO2t0knAhw9AvU+y
	 3WmBLm4WNoOe+yfq2D75GShwuKThLZBYbGOg08Ms8x0IpkI8Qp0B5+IJ4b8KZbd5s/
	 NrSuYyNpWcQldTFXgXzwg1BAON5KO4819Cmh2zTuPc2n1BhydiBTX08RogNFd62cdQ
	 AhJet3LyOZ2gBFc4nUmjm3OxFOpGRvmlbJah8/0Wd+R4ZV+3SdMN3YrVEGCjevPns6
	 RVh30UaYwYBvdxu6LBOFCM5sdzfslzVsQEyeWayOxSnNA6NJt3rlhucyiqrcplHzJ8
	 rsg/buKJg8QBw==
From: Yixun Lan <dlan@kernel.org>
Subject: [PATCH v2 0/3] Add UFS Host driver support for SpacemiT K3 SoC
Date: Sat, 25 Jul 2026 10:37:43 +0000
Message-Id: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPiRZGoC/22Nyw6CMBBFf4XM2jFtedi44j8Mi4IDVAwlM0A0h
 H+Xx9blSc49dwEh9iRwjxZgmr340G9gLhFUresbQv/cGIwymcpUispiF+NUC8o0DIFHrGwZK0u
 JTsnAthuYav85mo/iZJnKF1XjHtqN1ssY+Hucznr3zv5NmT/9WaNC7bLExa7UxtZ5R9zT+xq4g
 WJd1x/EF11MxQAAAA==
X-Change-ID: 20260605-08-k3-ufs-support-c8b308e415e2
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 Aurelien Jarno <aurelien@aurel32.net>, 
 Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yixun Lan <dlan@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2622; i=dlan@kernel.org;
 h=from:subject:message-id; bh=eXmWEEtkAKfn2G2yb6xl9rxhX/kxgd95q3ICmCrmT0Q=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqZJH/e0x+MI4+srFGYmIU2WqXMVZqV9ND7hD46
 EDyW28OybKJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCamSR/xsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+1vEg/9G+RSeaOTMxh69wJb+BEjPjM3iSo9VeUBEwpUPbpgZ/2nkPQM2AoT7
 hFkF/QJDwxwrxh2ny7YB6orUPkfyrdJBtbiuNizd/2SaH4G5uaxnRue+OcF5RuWam/OuL0IVOdH
 bwvK0H8KE3HLzf2uHEzgZ9z7EH8qrtczMln7ifiJOQhePUG6tKRDGnccLjqGYzXHLgijgVRJKjU
 aXmlgoDIupH/t1UgAqD3dpIjkB8jiU5PjnhymCKzZtagdla5vcPOuWTgL21tPo7IPvtI9c4GRTH
 ueKxl6HwiwJg/PLQ6jWLdvJc/D/Ii2kgDJwXnTcrI14QtK13BtlEA0/wKCDdq7TIKQZ/G9JEtcQ
 YNoekZj1sN1C7qD310pZz9T5ho4gAJ38mDR77Zzob80HJNJBdleNNNKCGOVsZz7+g221vk6YEqa
 RZON6b/5Nk7b81fGcm73wN0RmzGXVeH4G180RQx29U64NUcFputdIW7njpNjUOmpRkR0iXBsSS+
 dgH0JBWnepgxsmmfvD4NhvCPQWrIGOdgio+jHN4cqolPdZZHrCUX9ztj+QVWGzKsIbz5t1FpSvo
 lSaA6h+bhHC5uzvyUvuFlK4lpQ5DvhtKtpmqE0MHRvf2ES3/05psRaPhBElE8ar5WAWQR2G4F0k
 TJWsbuflzYw+55KGZbKvLIe8//dhRo=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

This series try to add UFS support for SpacemiT K3 SoC, the controller
components consists of System Bus Interface Unit, UFS Host Controller
Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
Management Entity (DME), Transport Layer, Network Layer, Data Link
Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
block diagram can be found in SpacemiT website, chapter 9.7.3 [1]

Please note, in order to test this driver, the UFS clock driver[2] here
should be applied first as a prerequisite patch.

One known issue is that the device will occasionally raise BKOPS interrupt
when doing some high load test, log from dmesg shows

[  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1

Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
Link: https://lore.kernel.org/all/20260630-06-clk-ufs-support-v1-0-cf7521d1d0fe@kernel.org/ [2]
Signed-off-by: Yixun Lan <dlan@kernel.org>
---
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
 arch/riscv/boot/dts/spacemit/k3.dtsi               |  27 +
 drivers/ufs/host/Kconfig                           |  12 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-spacemit.c                    | 686 +++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h                    |  79 +++
 8 files changed, 869 insertions(+)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Best regards,
--  
Yixun Lan <dlan@kernel.org>

