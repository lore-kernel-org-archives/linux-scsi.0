Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8E2226CFE;
	Fri,  2 Oct 2026 03:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790910635; cv=none; b=PFg6yHKRtsQU9QhCPKPyGwgGwxysaClnjbKpAKJZQArCpSfmA8GwsRuYFbrY8i9SCePiiraFNcer1kNRdZfyriy7+XOT32bueCU2a9nCdkiRlsHP9IknKRf8N9kWa3n+yo9U/oXNkXaoeS2Rgeaf2SAITJxkzfip23HBajgKGlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790910635; c=relaxed/simple;
	bh=lAjjOL1iN6oD9G81tmPcFeRHvpr2kdEl8tqiCr0bu/I=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=IImkBHfc/5v2I8xNib4kIPHschozjkbzsopjr+JoBE5tmJHg7cyqaNFinvysYHope+SpkEAEtVtHgjaZCIRmrqcg7QsbCmFz2fH1OkMzX05J/IOqWohmn6G1HvbI4trz91AI+oeCZJH50XrTyXms3jKH6SjPSnzLiwv/B7zYYpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFY/2H+Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFY/2H+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E781F000FF;
	Fri,  2 Oct 2026 03:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790910634;
	bh=NF2fbfNb82pR9cpxwGmRhFNQN2aoikVriPTPVY+ihpo=;
	h=From:Subject:Date:To:Cc;
	b=cFY/2H+QzQtGjRtgPMXo+vc0QfUFBQL5F1NKnJx38UbHw0gK4pb2IoX9rktJwc8gL
	 Zk8TujFOFCyFvghC0yTTACPlNmtvleWozQVYKuRI/C0YxH4mLM9T4SbEaYHAcRkY6+
	 I6Yrmht/vWgKqh1ea+CcubuCQl5AiqS9ncXpV/RsBrtyhWNqzRYkH0rAZzZUSHaPc1
	 I/5x+QCUaiUrKdfQdFIDDL/4XC2VREJDO86uyoaTFJJ0cLBx3QaVlfWE5fZtxuV6SJ
	 whYM8efXHpScKVoi16R+CJ07RakJsugHd+H2/5vjO015XVSJ3bUkskRjLzPYWjM3O9
	 GETaI3QsiKVqg==
From: Yixun Lan <dlan@kernel.org>
Subject: [PATCH v7 0/2] Add UFS Host driver support for SpacemiT K3 SoC
Date: Fri, 02 Oct 2026 03:10:09 +0000
Message-Id: <20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23QTW7DIBAF4KtErEsFw6+76j2qLsBAQlPZFtioV
 eS7FyeLuDLLJ837ZjQ3lH2KPqO30w0lX2KO41CDejmh/mKGs8fR1YyAgCSSCEw0vjK8hIzzMk1
 jmnGvLSPacyo8oNqbkg/x525+fD5yXuyX7+cN2iYuMc9j+r0vLXSbe/iKQMMvFBNMjeSGGUtBh
 /erT4P/fh3TGW0LCuwIaJ1Yqou5IEwaMMCpPhDsSWgiWwSrBGEqWAZgemcPBH8SXe03CF6JWjZ
 gXaccOxJiR9DmFWL7RRBO0UAJKHcg5I4A2iKqixlXnZLaAHTdP2Jd1z9c3mzDFAIAAA==
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
 Yixun Lan <dlan@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4004; i=dlan@kernel.org;
 h=from:subject:message-id; bh=lAjjOL1iN6oD9G81tmPcFeRHvpr2kdEl8tqiCr0bu/I=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqvyCba38GBLb9oEfHEIj/Z5ncFGezk4DWIKAGR
 5ASW6SHmK6JAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCar8gmxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+07lQ//Wbh1AAlbXQBM1m+5jg4XxRVeDg4P9zUZ2hKtV/XNlgPEfy8rRrzLI
 YHSjXtpbehligiCdVuML0ot4L0nwPlbZFvt+R4nqIEF5scdEF/7TRov1UxzGhHNY8XBkItrnZ4F
 x9KIhgZah2DgHi8L6qJaQdNtKRJ5w43XPokmiKZfu9Q9FQhf0jlYEqANf7IGduLK5vWzzmv2M43
 7djBFuiczRIEMKIMGiKyx42I7iQWstEfzCooyJoG0GsMvUwuMOCDAsqsQd1FIp1piA9gSsO7KQr
 744k8oY9BjnTZgdK//kkmYwGAoz00j7PjNtZvKl9skP9duWOpA0euvh+V2wjsRYPnJCuyOYippm
 pPi+fveoI+SFOrUCC1S9xKVBajCpMF4zpoDBzxYxTqY5WtZL3XrclNjPU3mCZqsOs78kpFb6R0W
 h9QdpF0va4OrEo3Ar4Qd2qKyz3ylc9KSkQathSrjda+oW2zB5UPwKcGkopUAhuYpIVlyLm9M4By
 FhSXzsfqXbGlV3PBS7b2eQAbEFvx9ZGEPmuZ3xT9D8aqxYhNkSXR1yAzFGSiswNF8qm+GTrxmgD
 1hcvmtc8lYwiuS4/fn8EVeN9s9oAAhPYtYsdDmk9PmNFTsYTyzOv15K5nmoUPMWXJ5fW+dzqSPK
 NVKM3REkEm56uIlt4yWfHhfSB9hbBQ=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

This series try to add UFS support for SpacemiT K3 SoC, the controller
components consists of System Bus Interface Unit, UFS Host Controller
Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
Management Entity (DME), Transport Layer, Network Layer, Data Link
Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
block diagram can be found in SpacemiT website, chapter 9.7.3 [1]

The DTS patch has been dropped in this series [2], and will send
in separate series once this patch accepted. For people who want to
test UFS driver, please grab the DT patch from version v5 [3].

One known issue is that the device will occasionally raise BKOPS interrupt
when doing some high load test, log from dmesg shows

[  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1

Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
Link: https://lore.kernel.org/all/20260918-belligerent-succinct-kraken-7fa592@quoll/ [2]
Link: https://lore.kernel.org/all/20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org/ [3]
Signed-off-by: Yixun Lan <dlan@kernel.org>
---
Changes in v7:
- check err return value of ufs_spacemit_quirk_host_pa_saveconfigtime()
- Link to v6: https://patch.msgid.link/20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org

Changes in v6:
- drop unused macro and dev_req_params
- use global PX_xx macros
- fix axi clock name
- drop dts patch
- collect tags
- Link to v5: https://patch.msgid.link/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org

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
Yixun Lan (2):
      scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
      scsi: ufs: spacemit: k3: Add UFS Host Controller driver

 .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml |  56 ++
 drivers/ufs/host/Kconfig                           |  12 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-spacemit.c                    | 652 +++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h                    |  77 +++
 5 files changed, 798 insertions(+)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Best regards,
--  
Yixun Lan <dlan@kernel.org>

