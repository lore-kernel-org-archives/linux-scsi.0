Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F7F2F5B;
	Sat, 25 Oct 2025 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408701; cv=none; b=U2Z3ddL65rIxJAwpKgxOjp7z5D/pvTRMG3EPgj4rIVOKQ7euCCF9Y67KLDtv1MzjVSdZ27eGx6EHCbaWu9hCZxwJ9N+/AHc351evCuTEcwwBSTCfvibDWozYv2Ox8b008lRVEOp8X0FmPWmUR+dqa14ffHPuFgRdZ9ftKj8E16I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408701; c=relaxed/simple;
	bh=c+KxOQM1hdqOoWL5E0ejofcyZci2aCqJVEcaq1R1KPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQeb8QU+fwuXgdKLfYYdfKFYU3o9h8D3lLyk/j/QG8KsajF/amjuSkcmELhd4NhhWITVztoutp2Lmq5nSaLiDsx5pR3ZCc5GRabUyZHLh1O/QrwFA05v3AXLZvKc70+wbxA1LLj1ew5ZIZ6L59srjLk5x0j4WxZFCcgGlSkpAfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Goe8MHMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Goe8MHMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D5BC4CEF5;
	Sat, 25 Oct 2025 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408701;
	bh=c+KxOQM1hdqOoWL5E0ejofcyZci2aCqJVEcaq1R1KPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Goe8MHMI8QdZWY3cQDSlfGKv3+k0MBvjMtwN7DaB2mIgFOfQ0ofK5tbzPGva/5l/l
	 jolb6n78IxeXy5OjqjKfJxGo7mjMgAA39BQcAEKVEdlHTec9n6yTUJjkIGW2M4rW2U
	 XBpTneF8+dn0O+Jxm7y6Wy/yJkjinluvEZ7Gz24gbGSaWaMkJuEP7YdXnNRYztSBTU
	 QLedoWpgFRyjE6R6OQXjw/3uuEcsYd6ikcdn8geQmyJXpHywXRGw2YLQnVUqvENufE
	 SMtYhcY4gHk1YuH4cmVbzZ/wmpm0G5FidKvDe2NtHLayhCnAhwqs92n1fnJfyudqZD
	 ZM+OuG2BZNkCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	shshaikh@marvell.com,
	manishc@marvell.com,
	GR-Linux-NIC-Dev@marvell.com,
	mahesh@linux.ibm.com,
	njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	netdev@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] PCI/ERR: Update device error_state already after reset
Date: Sat, 25 Oct 2025 11:54:37 -0400
Message-ID: <20251025160905.3857885-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 45bc82563d5505327d97963bc54d3709939fa8f8 ]

After a Fatal Error has been reported by a device and has been recovered
through a Secondary Bus Reset, AER updates the device's error_state to
pci_channel_io_normal before invoking its driver's ->resume() callback.

By contrast, EEH updates the error_state earlier, namely after resetting
the device and before invoking its driver's ->slot_reset() callback.
Commit c58dc575f3c8 ("powerpc/pseries: Set error_state to
pci_channel_io_normal in eeh_report_reset()") explains in great detail
that the earlier invocation is necessitated by various drivers checking
accessibility of the device with pci_channel_offline() and avoiding
accesses if it returns true.  It returns true for any other error_state
than pci_channel_io_normal.

The device should be accessible already after reset, hence the reasoning
is that it's safe to update the error_state immediately afterwards.

This deviation between AER and EEH seems problematic because drivers
behave differently depending on which error recovery mechanism the
platform uses.  Three drivers have gone so far as to update the
error_state themselves, presumably to work around AER's behavior.

For consistency, amend AER to update the error_state at the same recovery
steps as EEH.  Drop the now unnecessary workaround from the three drivers.

Keep updating the error_state before ->resume() in case ->error_detected()
or ->mmio_enabled() return PCI_ERS_RESULT_RECOVERED, which causes
->slot_reset() to be skipped.  There are drivers doing this even for Fatal
Errors, e.g. mhi_pci_error_detected().

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/4517af6359ffb9d66152b827a5d2833459144e3f.1755008151.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Summary
  - Fixes a long-standing AER vs EEH inconsistency by setting
    `dev->error_state = pci_channel_io_normal` immediately after reset
    (before `->slot_reset()`), matching EEH behavior and removing per-
    driver hacks.
  - Small, targeted behavioral fix that improves error recovery
    reliability for drivers that gate hardware access on
    `pci_channel_offline()`.

- Why it’s a bug
  - Under AER, `error_state` was previously restored to normal only
    before `->resume()`, causing `pci_channel_offline()` to return true
    during `->slot_reset()`. Drivers that correctly re-initialize
    hardware in `->slot_reset()` could incorrectly self-gate and skip
    needed accesses.
  - EEH has set `error_state` to normal before `->slot_reset()` since
    c58dc575f3c8 for exactly this reason. The mismatch forces drivers to
    add workarounds under AER.

- What changes (code specifics)
  - Core AER: Set `error_state` early in the slot-reset phase
    - Adds early state transition in `report_slot_reset()` so drivers
      see the device as online during `->slot_reset()`:
      - `drivers/pci/pcie/err.c:156`: `if (!pci_dev_set_io_state(dev,
        pci_channel_io_normal) || !pdrv || !pdrv->err_handler ||
        !pdrv->err_handler->slot_reset) goto out;`
    - Keeps the existing update before `->resume()` to cover flows where
      `->slot_reset()` is skipped (e.g., when `->error_detected()` or
      `->mmio_enabled()` returns RECOVERED):
      - `drivers/pci/pcie/err.c:170`: `if (!pci_dev_set_io_state(dev,
        pci_channel_io_normal) || ... ) goto out;`
    - Transition gating is safe: `pci_dev_set_io_state()` only returns
      false for `pci_channel_io_perm_failure` (see semantics in
      `drivers/pci/pci.h:456`), so we avoid calling `->slot_reset()` on
      permanently failed devices (sensible safety net).
  - Remove driver workarounds that manually forced `error_state =
    normal`
    - QLogic qlcnic:
      - `drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:4218`:
        remove `pdev->error_state = pci_channel_io_normal;` from
        `qlcnic_83xx_io_slot_reset()`.
      - `drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c:3770`: remove
        `pdev->error_state = pci_channel_io_normal;` from
        `qlcnic_attach_func()` (used in 82xx `->slot_reset()` path at
        `...:3864`).
    - QLogic qla2xxx:
      - `drivers/scsi/qla2xxx/qla_os.c:7902`: remove the workaround and
        comment in `qla2xxx_pci_slot_reset()` that set
        `pdev->error_state = pci_channel_io_normal;` to avoid mailbox
        timeouts.
  - The commit also notes drivers like MHI can return RECOVERED from
    `->error_detected()`, skipping `->slot_reset()`; the resume-path
    normalization remains to handle that path correctly (consistent with
    code in `drivers/pci/pcie/err.c:170`).

- Risk/compatibility assessment
  - Scope is minimal and contained: a single earlier state transition in
    core AER and removal of redundant per-driver hacks.
  - Aligns AER with EEH behavior proven since 2009 (c58dc575f3c8),
    reducing platform-dependent behavioral differences in recovery
    paths.
  - Drivers that previously avoided IO in `->slot_reset()` because
    `pci_channel_offline()` returned true will now proceed as intended
    once the device is reset and accessible. This improves recovery
    success rates rather than risking harm.
  - The core change is guarded by `pci_dev_set_io_state()` semantics; it
    will not “normalize” devices in permanent failure.
  - No new features or architectural changes; no ABI/API changes.

- Backport assessment
  - Fixes real recovery failures/workarounds (e.g., qla2xxx mailbox
    timeouts), affects users, and reduces platform-specific divergence
    in error recovery semantics.
  - Change is small and surgical; drivers touched only remove redundant
    assignments now handled in the core.
  - Even in stable, these driver-line removals are safe once the core
    change is present; alternatively, stable could carry just the core
    change and leave driver workarounds (harmless duplication). As a
    single commit, it remains suitable.
  - While the commit message snippet doesn’t show a “Fixes:” or “Cc:
    stable” tag, the rationale, history, and limited blast radius make
    it an appropriate stable backport candidate.

 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c    | 2 --
 drivers/pci/pcie/err.c                              | 3 ++-
 drivers/scsi/qla2xxx/qla_os.c                       | 5 -----
 4 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index d7cdea8f604d0..91e7b38143ead 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -4215,7 +4215,6 @@ static pci_ers_result_t qlcnic_83xx_io_slot_reset(struct pci_dev *pdev)
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	int err = 0;
 
-	pdev->error_state = pci_channel_io_normal;
 	err = pci_enable_device(pdev);
 	if (err)
 		goto disconnect;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 53cdd36c41236..e051d8c7a28d6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -3766,8 +3766,6 @@ static int qlcnic_attach_func(struct pci_dev *pdev)
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 
-	pdev->error_state = pci_channel_io_normal;
-
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index a4990c9ad493a..e85b9cd5fec1b 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -141,7 +141,8 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
 
 	device_lock(&dev->dev);
 	pdrv = dev->driver;
-	if (!pdrv || !pdrv->err_handler || !pdrv->err_handler->slot_reset)
+	if (!pci_dev_set_io_state(dev, pci_channel_io_normal) ||
+	    !pdrv || !pdrv->err_handler || !pdrv->err_handler->slot_reset)
 		goto out;
 
 	err_handler = pdrv->err_handler;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d4b484c0fd9d7..4460421834cb2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7883,11 +7883,6 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	       "Slot Reset.\n");
 
 	ha->pci_error_state = QLA_PCI_SLOT_RESET;
-	/* Workaround: qla2xxx driver which access hardware earlier
-	 * needs error state to be pci_channel_io_online.
-	 * Otherwise mailbox command timesout.
-	 */
-	pdev->error_state = pci_channel_io_normal;
 
 	pci_restore_state(pdev);
 
-- 
2.51.0

