Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4A5570842;
	Mon, 19 Oct 2026 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418293; cv=none; b=kw0GFNAnYMf4/n3wjievGQSuvNA9guDS7uDWfNixg6kOQl0GB2OZnyfOTWEKJHNw9T9yzj/XB/JtSyMWN0e05QrQXxJOsrj0IiQHoolgSUV6e0ESYe1ebfdXDY45ekTow9KtysaBQvAxh9fgMxQUu8qWg/fbzGMchkvrwo84huU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418293; c=relaxed/simple;
	bh=NP3gvf6a34mwh5taukdEUml/wKzNStiNfPjD8uO1j5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MKoRPitzhIjZsKkGPvf6X1PSxIJoNEWxIzmAVeuflNZaGJIj49sd502jpL60v+s76q6qgK/FrdQyUwhxMbDAcWBkq3K77bOTMyT2S3FKGwJ/5tVG6jszkV/dF0JszMtDak7TT3k/fN7djQB9HBln050GjgYA7GWlZY6gJfGuCmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEB57Bcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEB57Bcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9091F000C7;
	Mon, 19 Oct 2026 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418291;
	bh=mlRDR92nhUdgHs3nQ41LKCHnUfuuZoYEUdnUm1tHsls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEB57BcfaQQZhsK2sAlFAeNSYgiUkzmGu8QaqdY8TgsaL89Jxqto5CIbR2j5DmHAw
	 Z6+F3sJEAEg7Hmb0jQTUjPBvMF408iyp9EaygaqblfYXaRRvY3ALPepo+kRieD0c6m
	 6NZvrsdMoEDOZmbqPy1frD3iN4HEUYSeIhAmQzwY2PzjGASzwExUr6B4yH2c7wj4YF
	 JQn3d+sRHzy98IhQC8mW0P8O5iXo+/1UZv5M6rsaXK8KJ+7rqB5dmig8BpWxWzgUOe
	 i/tC8AoYftveyR+CA1AHhDzltQNGvcj8OjkBh608cXUsiJM73pB+jCzo6MPLrcw2ZT
	 o8G6MGiWztKYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Kyle Mahlkuch <kmahlkuc@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: qla2xxx: Handle INTx not connected while passing through
Date: Mon, 19 Oct 2026 09:47:14 -0400
Message-ID: <20261019135441.1420968-143-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit 7268e509b43ac1734e1bdb7d18553f7e1080dfb4 ]

The PCI_INTERRUPT_PIN reports if the device supports the INTx.  However,
when the device is assigned to a guest via vfio, the PCI_INTERRUPT_PIN
is set to 0 (i.e none) if the line is not connected and/or the platform
cannot route the interrupt.

In such cases, the guest PCI_INTERRUPT_PIN is 0 and the port number
becomes -1 (255, uint8_t underflow) for qla[25|27|28]xx and qla2031
devices.  The flt_region_nvram is never set, and subsequently the LUN
detection fails.  Below warnings show the NVRAM configuration failure:

 []-0073:1: Inconsistent NVRAM checksum=0xffffffc0 id=HCAM version=0x100.
 []-0074:1: Falling back to functioning (yet invalid -- WWPN) defaults.
 []-0076:1: NVRAM configuration failed.

Handle this case and set the port_no to devfn like its done everywhere
else.

Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN if no pdev->irq")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Link: https://patch.msgid.link/177885270578.1573.14283751510936407585.stgit@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[scsi/qla2xxx] [Handle] Handle INTx not connected while passing
through`
Subsystem is the QLogic Fibre Channel driver. The verb “Handle” is a
correctness/workaround fix, not a feature add.

**Step 1.2: Tags**
Record:
- `Reviewed-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>`
- `Link: https://patch.msgid.link/177885270578.1573.14283751510936407585
  .stgit@linux.ibm.com`
- `Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>` (author)
- `Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>` (SCSI
  maintainer)
- `Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN
  if no pdev->irq")` (not a `Fixes:` tag)
- No `Fixes:`, no `Cc: stable`, no `Reported-by`/`Tested-by` on the
  committed version (those were requested on-list but not folded in)
- Ignore pipeline-added Sasha Levin SOB if present (not on this commit)

**Step 1.3: Body**
Record:
- **Bug:** Guest VFIO assignment virtualizes `PCI_INTERRUPT_PIN` to 0
  when INTx is not connected / not routable.
- **Mechanism:** For qla25/27/28xx and qla2031, the driver does
  `ha->port_no--` on that register. `port_no` is `uint8_t`, so 0 wraps
  to 255.
- **Symptom:** `flt_region_nvram` is never selected (only ports 0–3 are
  matched). NVRAM is read from the wrong/zero flash offset. Logs:
  - `Inconsistent NVRAM checksum=0xffffffc0 id=HCAM version=0x100`
  - `Falling back to functioning (yet invalid -- WWPN) defaults`
  - `NVRAM configuration failed`
- **User-visible result:** LUN detection fails; the HBA does not present
  storage in the guest.
- **Fix:** If PIN is 0, set `port_no` from `PCI_FUNC(devfn)`, matching
  other qla2xxx paths.

**Step 1.4: Hidden bug fix?**
Record: No. This is an explicit functional bug fix, not cleanup
disguised as a fix.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/scsi/qla2xxx/qla_os.c` (+10 / −5)
- Function: `qla2x00_set_isp_flags()`
- Scope: single-file surgical change

**Step 2.2: Code flow**
Before (verified on `7268e509b43ac^`):
```c
pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
IS_QLA28XX(ha))
    ha->port_no--;
else
    ha->port_no = !(ha->port_no & 1);
```
After: if PIN is 0, `ha->port_no = PCI_FUNC(ha->pdev->devfn)`; else keep
the old mapping.

This is probe/init (`qla2x00_probe_one` → `qla2x00_set_isp_flags`), not
an error path.

**Step 2.3: Bug category**
Record: **Logic / correctness + hardware/virt workaround**, with a
**uint8_t underflow**.

Verified:
- `qla_def.h`: `uint8_t port_no` — decrement of 0 → 255.
- `qla_sup.c` `qla2xxx_get_flt_info()` only assigns `flt_region_nvram`
  when `port_no` is 0, 1, 2, or 3. 255 never matches.
- `ha` is `kzalloc`’d, so `flt_region_nvram` stays 0; NVRAM is then read
  from flash offset 0.
- `qla81xx`/`27xx` NVRAM path at `qla_init.c:10044–10288` emits exactly
  log IDs 0x0073 / 0x0074 / 0x0076 from the commit message.
- Fallback WWPNs are invalid → LUN discovery fails.

**Step 2.4: Fix quality**
Record: Obviously correct. PIN 0 means “no INTx”; using PCI function
number is already how this driver sets `ha->portnum` for 83xx/82xx/etc.
Bare-metal cards with PIN 1–4 are unchanged. Regression risk is low: the
new branch only runs when PIN is 0, which previously produced a useless
port number (255) on the 25/27/28/2031 path.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- `pci_read_config_byte(..., PCI_INTERRUPT_PIN, &ha->port_no)`
  introduced in `a9083016a5314b` (2010, ISP82XX support).
- Decrement / `!(pin & 1)` mapping in `f73cb695d3eccd` (2014, ISP2071).
- The underflow is old; it became commonly hit after VFIO started
  virtualizing PIN as 0.

**Step 3.2: Fixes tag**
Record: No `Fixes:` tag. Related cause: `2bd42b03ab6b` (`vfio/pci:
Virtualize zero INTx PIN if no pdev->irq`, 2025-04-14). That commit
**is** an ancestor of this tree (`git merge-base --is-ancestor` exit 0).
It was reported/tested by the same author (Shivaprasad G Bhat).

**Step 3.3: File history**
Record: Standalone one-patch series. Later `3571ef0515640` (QLA29xx
support) merged this PIN==0 check with an extra `IS_QLA29XX` in the
decrement branch. No prerequisite refactor is required for the original
hunk.

**Step 3.4: Author**
Record: Shivaprasad G Bhat (IBM). Other nearby work is
powerpc/vfio/iommu, not qla2xxx maintainer. Reviewer Kyle Mahlkuch is
also IBM. SCSI maintainer Martin K. Petersen applied it.

**Step 3.5: Dependencies**
Record: Self-contained. No new APIs. Does not require vfio source
changes; it only reacts to PIN=0 in config space. Can apply standalone
to any tree that still has the old decrement logic.

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record:
- `b4 dig -c 7268e509b43ac` → https://patch.msgid.link/177885270578.1573
  .14283751510936407585.stgit@linux.ibm.com
- `b4 dig -a`: **v1 only** (single standalone patch).
- Thread saved to mbox (lore HTTP 403 via WebFetch; mbox succeeded).
- Reviewer feedback:
  - Priya A: tested, asked for `Reported-by`/`Tested-by` (not added in
    the committed version).
  - Kyle Mahlkuch: “look reasonable and fix a known bug” + `Reviewed-
    by`.
  - Madhavan Srinivasan: ping for comments; no NAK.
  - Martin K. Petersen: applied to **7.3/scsi-queue**.
  - Author then asked to also land in **7.2**. Martin: left it in 7.3
    because of conflict with a large qla2xxx update that cycle, and told
    the author they **can post a stable backport request** once Linus
    merged SCSI.

No NAKs. Maintainer explicitly treated this as stable-worthy.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Marvell qla2xxx maintainers (`njavali@marvell.com`, `GR-QLogic-
Storage-Upstream@marvell.com`), James Bottomley, Martin K. Petersen,
`linux-scsi`, Alex Williamson (vfio), Kyle Mahlkuch.

**Step 4.3: Bug report**
Record: Concrete guest logs in the commit. Independent tester Priya A
confirmed it fixes LUN detection. This is a real IBM-reported VFIO
passthrough failure, not theoretical.

**Step 4.4: Series**
Record: Standalone `[PATCH]`, not `N/M`.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable search returned HTTP 403. From the scsi
thread, the maintainer invited a stable request; no evidence of a NAK
against stable.

---

## Phase 5: Semantic analysis

**Step 5.1: Functions**
Record: `qla2x00_set_isp_flags()` only.

**Step 5.2: Callers**
Record: Called once from `qla2x00_probe_one()` (`qla_os.c:3090`), the
PCI `.probe` callback (`qla_os.c:8360`). Probe context, once per
adapter.

**Step 5.3: Callees**
Record: `pci_read_config_byte()`, `PCI_FUNC()`, ISP type macros. No
alloc/lock changes.

**Step 5.4: Reachability**
Record: Yes. Trigger: VFIO-assign a QLogic 25/27/28xx or 2031 HBA into a
guest whose kernel runs this driver, when the platform does not connect
INTx (`pdev->irq == 0` or `IRQ_NOTCONNECTED`). Confirmed in
`vfio_pci_config.c:1833–1835`. Userspace (hypervisor admin) can trigger
this; unprivileged guest users then just see missing LUNs.

**Step 5.5: Similar patterns**
Record: `PCI_FUNC(ha->pdev->devfn)` is already used for `ha->portnum` in
`qla_os.c` (83xx and others) and `qla_nx.c`. The fallback matches
existing driver convention.

---

## Phase 6: Local tree (this checkout)

**Step 6.1: Does the buggy code exist here?**
Record:
- Tree: **Linux 7.3.0-rc4** (`git describe HEAD` =
  `v7.3-rc4-27-gf0100363d8c37`).
- `qla2xxx` is present. `port_no` is still `uint8_t`. FLT NVRAM
  selection still keys off `port_no` 0–3.
- VFIO PIN=0 virtualization is present (`2bd42b03ab6b` is an ancestor).
- The underflow logic **did exist** on this 7.3 line before
  `7268e509b43ac`; that commit is already an ancestor of HEAD. Current
  `qla2x00_set_isp_flags()` already has the PIN==0 fallback, plus a
  later `IS_QLA29XX` merge.

**Step 6.2: Backport difficulty**
Record: On this 7.3-rc4 tree the fix is already merged. Cherry-picking
again would be a no-op / conflict with the already-applied hunk plus
QLA29xx. For *this* tree, the code change is already in place; no extra
backport rework is needed for 7.3.

**Step 6.3: Related fixes already here?**
Record: This is the fix. The only later related edit is QLA29xx
extending the same `else if` (still keeps the PIN==0 path). No
alternate/competing fix.

---

## Phase 7: Subsystem context

**Step 7.1:**
Record: `drivers/scsi/qla2xxx` — **IMPORTANT** (widely used FC HBA in
servers/SAN, including VFIO passthrough). Not core mm/vfs, but storage
init failure is user-visible and serious for those systems.

**Step 7.2:**
Record: Actively developed (QLA29xx series and hardening landed after
this commit in 7.3). The buggy PIN mapping itself dates to 2010/2014.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Driver-specific + config-specific: `CONFIG_SCSI_QLA_FC` guests
(and hosts) where `PCI_INTERRUPT_PIN` reads as 0. Primary real-world
trigger is VFIO passthrough when INTx is not routed (IBM Power and
similar). Dual-port 25/27/28xx and 2031 adapters.

**Step 8.2: Trigger**
Record: Adapter probe in the guest. Deterministic once PIN is 0 — not a
race. Hypervisor admin can trigger it; then LUNs never appear.

**Step 8.3: Failure mode**
Record: HBA comes up with invalid NVRAM/WWPN; **LUN detection fails**.
Not a panic/UAF. Severity: **HIGH** (device non-functional, storage
unavailable). Matches stable-rules “hardware quirk” / “oh, that's not
good”.

**Step 8.4: Risk-benefit**
Record:
- Benefit: high for VFIO+qla2xxx users (adapter actually works).
- Risk: very low (10 lines, PIN==0 only, existing `PCI_FUNC`
  convention).
- Ratio: strongly favors including the fix in this tree.

---

## Phase 9: Synthesis

**Evidence FOR:**
- Real, tested LUN-detection failure with matching driver logs.
- uint8_t underflow is verified in this tree’s types and FLT matching.
- Tiny, obviously correct, no new API.
- Reviewed, maintainer-applied to 7.3; maintainer invited a stable
  backport.
- This 7.3 tree has both qla2xxx and the VFIO PIN=0 behavior.

**Evidence AGAINST:**
- Not a crash, UAF, or CVE.
- Affects VFIO passthrough more than bare metal (PIN is usually 1–4 on
  real silicon).
- Committed message omitted the tester’s `Reported-by`/`Tested-by`
  (quality of tags, not of the fix).

**Unresolved:** HTTP 403 on lore WebFetch (mbox was used instead).
Stable-list search unverified beyond the scsi thread.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** (review + Priya A test +
   maintainer apply)
2. Real bug affecting users? **PASS** (LUN detection fails)
3. Important? **PASS** (HBA/storage unusable in VFIO guests — HIGH)
4. Small and contained? **PASS** (~15 lines, one function)
5. No new features/APIs? **PASS**
6. Applies to this local tree? **PASS** (7.3 already contains the
   change; the surrounding driver is present)

**Exception category:** Hardware/virt workaround (handle virtualized
INTx PIN=0), analogous to a device quirk.

This tree is **7.3-rc4**. The qla2xxx PIN-to-`port_no` bug and VFIO PIN
virtualization both exist on this line. The patch is a small, tested
correctness fix that restores NVRAM/LUN discovery for passed-through
QLogic adapters. It meets stable-kernel rules and belongs in this tree.

Verification:
- [Phase 1] Parsed subject/tags/body from `git log -1` on
  `7268e509b43ac`; no Fixes/Cc-stable; Reference 2bd42b03ab6b.
- [Phase 2] Diff is 15 lines in `qla2x00_set_isp_flags`; parent blob
  still has unconditional `--`.
- [Phase 2] `port_no` is `uint8_t` in `qla_def.h:4319`; FLT NVRAM only
  matches ports 0–3 in `qla_sup.c`.
- [Phase 2] Log IDs 0x0073/0x0074/0x0076 verified in `qla_init.c`.
- [Phase 3] Blame: PIN read `a9083016a5314b` (2010); decrement
  `f73cb695d3eccd` (2014).
- [Phase 3] `git merge-base --is-ancestor 2bd42b03ab6b HEAD` = yes; same
  for `7268e509b43ac`.
- [Phase 3] Author log: IBM powerpc/vfio contributor; one qla2xxx
  commit.
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; scsi CCs including vfio and
  Marvell; mbox has Priya test, Kyle R-b, Martin apply + stable-backport
  invitation.
- [Phase 4] lore WebFetch 403 — UNVERIFIED via HTTP; used mbox instead.
- [Phase 5] Only caller: `qla2x00_probe_one`; VFIO sets PIN=0 at
  `vfio_pci_config.c:1833–1835`.
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4; current `qla_os.c` already has the PIN==0
  path.
- [Phase 8] Failure: NVRAM fail → invalid WWPN → no LUNs; not a panic.
- UNVERIFIED: whether a stable@vger thread was later posted (lore/stable
  HTTP 403).

**YES**

 drivers/scsi/qla2xxx/qla_os.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 07ccfe0226c5e..5b1fb7e5e0980 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2803,11 +2803,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 	else {
 		/* Get adapter physical port no from interrupt pin register. */
 		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
-		if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
-		    IS_QLA27XX(ha) || IS_QLA28XX(ha))
-			ha->port_no--;
-		else
-			ha->port_no = !(ha->port_no & 1);
+		if (ha->port_no == 0) {
+			/* None of INT[A|B|C|D] may be virtualized by vfio */
+			ha->port_no = PCI_FUNC(ha->pdev->devfn);
+		} else {
+			if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
+			    IS_QLA27XX(ha) || IS_QLA28XX(ha))
+				ha->port_no--;
+			else
+				ha->port_no = !(ha->port_no & 1);
+		}
 	}
 
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,
-- 
2.53.0

