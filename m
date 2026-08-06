Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE4035966;
	Thu,  6 Aug 2026 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785985009; cv=none; b=PdmuwcEFAoRBl3+0ilC8I8HCCQmbEbXssmkmCUHclMFyzBYGbjbDIMneOXASJR9nB1lbT+kCp8k2UFKK2t8t2Bpm5MtgRtCWD4Gsb+nM+8OqmQU1PxUgSBYL5oWzBRM6VvzNO8NDxTA1tLVI6vOgn/v8SAtF84g4bNHtjjYIrZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785985009; c=relaxed/simple;
	bh=zcSzdlzyWa0mKFqVpOYEi+B1OyPvwV8NmQMTBJZrgzY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=iCQe7jqJ82b424Fnf6R3GwrrZehfaIW0cGVBCzfZEpHbV/i/AVASIetCL0VsUAEU2/hm309mShMzO0TrovLXQB6BZdBi3npgqiM0zB3+O5x13YKuxEJ+qyYspvNPVw2hdio/DaZcFR2zLavqeJprtXeEXKB5EbGWkS+dvg2bvIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxUhun3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxUhun3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993DF1F000E9;
	Thu,  6 Aug 2026 02:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785985007;
	bh=Mtlk4l6af3fzvSGOSr294FtMvnZ9cn+MUN0ayXIPEvo=;
	h=From:Subject:Date:To:Cc;
	b=dxUhun3b1k6kU/7+Gs3hMKTOyJKD77tbB89xWk7rAYfJ/lD3PH4OaR3eJCCC+5JQ1
	 wv/Ffwfiw89BCMNo4l9IVcu0ntn/hOpgbP27jD9DN2mpdkBXQEzMwnEvLCtiVl4pf3
	 LyuEN7zckkJJVf+dFA2gXA/MNM3jkq6/cjHM4MaFpJ7J4q1A2PoU7b8cgywtoLrzjZ
	 erAM91N1hjnRwW2VNbtjiKUepWC4jCYFD1xZnudPjVowaH4pFISx9IFtPW4Vh6MF2c
	 hUhNTiIzS2n0AiyZ1cYVl7v0Iz32CyJXbt8OfjmpiJEzM93lwSEfOTrUU6lsbM0ksV
	 6bFSOwpe1I9fQ==
From: Yixun Lan <dlan@kernel.org>
Subject: [PATCH v3 0/3] Add UFS Host driver support for SpacemiT K3 SoC
Date: Thu, 06 Aug 2026 02:56:17 +0000
Message-Id: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANH3c2oC/23OTQ6CMBAF4KuYrh3TTkttXHkP46LgABVDSQuNh
 nB3+dlowvIlb743I4sUHEV2OYwsUHLR+XYO8nhgRW3bisA95syQo+aaZ8ANNBKGMkIcus6HHgq
 TS25IiYyQzXddoNK9V/N233Ic8icV/QItjdrF3ofPOprE0tv8M8cdPwngIKxWVtpcoCmvDYWWX
 icfKrYMJPwhcO/FNLugMi61RYtKmD9imqYvnWbO0QgBAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2938; i=dlan@kernel.org;
 h=from:subject:message-id; bh=zcSzdlzyWa0mKFqVpOYEi+B1OyPvwV8NmQMTBJZrgzY=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBqc/fdabSNyEO2K8Bpl0O0qzkZpTLGdu8fLOMjL
 p5CrwDnyqOJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCanP33RsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0AnQ//fbP/5c6ebaF7T8MCrBaC4OLAARjvbWki5OTHR1ATHWRjANdgq13DZ
 6M01Orju8Gk7XORYhQMQn56FalwJemys9YHx33Ph2J4saHr8cVT7LSM+hTPjblUEq9W8jhSTUG4
 x1/emThCm7r6zU0uuA0J3YGcv/qxRHZnsKHnTq3Ef+g4xRjdSanPmBZLmJ0hbfL9e6pANS1BbR7
 Rdm3fnPkIEhjf2J4ZPKG+j33vG7P+6JrzFkl9nvZRKubeWjfcMFztPIepeR/0+/jlaES+TWlwNq
 wtfZ14I07Bqgy018nN7A35R211dc5rcEK68OdvCqFmbXFgCddXbTU5sd/RvUeBi4Lu99jfuF25L
 6matdsEnMOdQPj+pXCgjTZ7NpruEFMBqA0o3Xnh2435uY1ULcMqP59PA546EEh/VFHgFphNBcoA
 r7TFHjRwzcINlRoeWC43VSFsx5a4VWr2LQYe7YVdZ4CVEfwKkBb+bqhBShJ0AP1zIHXsZnFqQP2
 CS842ids0CTJ/lcOVGhwrNLLHzxwYaS9BSlAbfsLAtMIlyRm9axRQOhX/KhAOe7O70x+MnlVOpe
 IqKBTm96gb0ljcqSiSEOI0H3yDFdbCYCCHTuYI88OWQ1lC66JO1VWa2md6qYwj3zwCCAWFxxH9t
 8sbZV13ei2aYZGek7eOhDZXxhLjeKM=
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
Changes in v3:
- fix dt-binding warning reported-by sashiko
- fix low freq in opp-2 table
- fix err checking in check_hibern8()
- propagate err code in link_startup_notify()
- update documents for event_notify()
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
 drivers/ufs/host/ufs-spacemit.c                    | 687 +++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h                    |  79 +++
 8 files changed, 865 insertions(+)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Best regards,
--  
Yixun Lan <dlan@kernel.org>

