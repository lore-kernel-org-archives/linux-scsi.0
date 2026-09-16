Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF05175A88;
	Wed, 16 Sep 2026 03:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789527614; cv=none; b=j9MDYSXOGHGNB/ZG2g18ee3YvIJSI3RyyHuivGpDJGJhd68FNIpbFbkH35YarIsNgtQnZJVmF4CIJ0PZNmhhzDR0/iGPp1x6DKJKoE518TWl7Pi95vvYueRNE+8i+v7UFv7tcGMVYt0sMF/NRpAK5cWlSRNZcrjHhLPGm8S8S/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789527614; c=relaxed/simple;
	bh=+SacVXUkr8j5POKRnHb0Al+tmH5nubSQVqCvfMvF4U8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=bS4z28PC2cxoib7XOZsXqnQHM8f+i9/VBK6VvFJcVdu/rPggkBLgj+f0NpXJD/Mm6bKb632jzdz1cTX/PDtpmVr5SQoKziuusAy/czX176Fw/te4Z+HMEze9O1qrdMlHHGwpEzDctQ3oe69fgDQMT303sOj2eDw/e1aGcMZ9vO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1IaNBKR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1IaNBKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85C71F000FF;
	Wed, 16 Sep 2026 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789527612;
	bh=2bdF78kpI2KMtKEo1UhtIDs9SRrcav8S/mCxdPezFrE=;
	h=From:Subject:Date:To:Cc;
	b=L1IaNBKRMh7tkpx0TO4JxumQ+lDv54WoXC7lQc6Vff1HOHQ3LntVjYadJvNJ6qC5P
	 mHY2MLjxGtBjg3Mx/CDJ7uy8kSvKdWZrb+kz08oyT84rsYROD9Ot9CU1Ba/3BZPx/8
	 VrY+3oqpPiZ4fCByRXh5BNG7TVUry4Y7hauks/HMQgk90ihspl62d7n5ly0vHqPoP6
	 SGfQmQV8VkKbN4YqaE0ksYjb0HjCBjdPQw0AV5Py8dMefOqb3e0HNdy/2T8Cgs0Q+I
	 VHQJow0bRLwuxHVsLP2Z5xfd4YmL5OSEoKX8vb6PR7qdzduG6j7v25oNjTS9RM3E8i
	 N1Sj5v+/GU1kA==
From: Yixun Lan <dlan@kernel.org>
Subject: [PATCH v5 0/3] Add UFS Host driver support for SpacemiT K3 SoC
Date: Wed, 16 Sep 2026 02:59:52 +0000
Message-Id: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23OQW6DMBAF0KtEXtfVeMYYJ6veo8rChiFxUwGyw
 UoVcfeaZJFWYfml+e/PTSSOgZM47G4icg4pDH0J1dtONGfXn1iGtmSBgAYMVBKsvJCcuyTTPI5
 DnGRjPYFlrSpGUXpj5C5c7+bn8ZHT7L+4mVZovTiHNA3x5z6a1Xr38GvADT8rCVI5ox05r9B2H
 xeOPX+/D/Ek1oGMfwjcejEXV+oKyDh0qJV9IehJWDBbBBUCqO48Ibqm9S+EfhL70t8gdCFK2aF
 v93VL/4llWX4BoBGquI4BAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3425; i=dlan@kernel.org;
 h=from:subject:message-id; bh=+SacVXUkr8j5POKRnHb0Al+tmH5nubSQVqCvfMvF4U8=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqqgYrD6CluHigzTNYp9BAViOiHlWDbTZB+eC8q
 XP28inYDTmJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCaqoGKxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0FFg/9FLomF8pxFXX8jY0C0hu25u5AKgzCurSfBEExbJ65t4SfMgTDCZh6q
 L5wTX5yeSAJy9upPc5KjXyECAWFqPD0Anl3zloVs/v4OJfhA5eQ2ILIMGnYT5jgYthEAiRwAEmN
 4ntY2aXhw3r093ukfQIc//TqnPlck0JamdQD1u2jUIEZI72QsBW1AIWBwnr/KejQyCOyZjdgcnY
 PG4vesQOUPOeUBmhv54tNlLyvUubOZQ/bjOlEZRGPsnyFO6BtCH/ThzdrwvIxkPDl1FZXRawq0t
 +Xe1nbL86+XUHzv2ZC0iLQoyi8xeK6g3hnt2CANG+bEoHhwZhDCHLowoR8DKpaw0dYUQ1y+U9b1
 WEyaSLyyogYfSPX4al1rbI+hA8YtQjvuqYrk1D1eYt8HHiqY3wrVRcR8cXtbYcwQfI78Gbd9pYS
 Jj6RNfAHQxhL/6bqDwSK2Nz4IdIllAeA9miGbwkcDCJRKri+XXoMIcr+Ia92zK/+o7Yfrj7MvnY
 lArLsnQ66XLrjJQhZDJdvoxVFAHyTHLiZs4ALLxmINoR0laqfJ4NuSGj5bccNQHKz+QCZRLtCFx
 D+2f+QQYe3CsHrWJH7YcHpsZw10XUWHu9quVmRhGa5wwzhPrwGM0VrRR2y5ov7Mr7hZMsVJSi4N
 YWzuVg8uPdQT09zP4xsnyoNh1VICQc=
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
Changes in v5:
- adjust clock names
- add runtime power support
- collect tags
- Link to v4: https://patch.msgid.link/20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org

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
 drivers/ufs/host/ufs-spacemit.c                    | 688 +++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h                    |  79 +++
 8 files changed, 866 insertions(+)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Best regards,
--  
Yixun Lan <dlan@kernel.org>

