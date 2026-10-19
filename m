Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4075BB51D;
	Mon, 19 Oct 2026 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418457; cv=none; b=UXyjA+KPJLIZrwSSsxbhwYPYNR6x59csvIYZvtvrMM6kNBCQxT4tXJZVevwe3nwwispXta1MWYj1c8eCJeT8Oc8/2PaFreZFozBIm8YhkFXcip+GUV8rHSpnmHl8Jhc7vqWtdGQ/IOPTZBb4Nf7h0uMFsoZBsKcayftkk3B/uuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418457; c=relaxed/simple;
	bh=WxNPLJPDOBprheBWeMRcp9aK5//+9PUV06ZtROZL5q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edE+dVaM4l9b35J+NFlO5NdXJQtRLmJrVphCja/+ZRc/NQjlldK9BN//EpaQuJm2od0DOtERKxwP0YWlWiu1JzGU05V80op5+XZaSL/G5q5xG61xgvEdmMiGk7miaA+etsEUaGtFEWs/wLkDrzf/I0qYnjcCJe2rdN5hws2IUBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVXfKoyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVXfKoyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C991F000C6;
	Mon, 19 Oct 2026 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418455;
	bh=gLYo+ZptyWNcradEon9AJ0IpeIgAlajqjarb/KKBy24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVXfKoynGsSBSCci1s47Hqt9AsA7/FPmvAlvfegWqaMDDQWQmf2FaaqaRHwUAV0Co
	 2pfI565fcPLh/taJKlcU357IgK1B6jRUHN+AKGYyyv1Wdw7POvJOOSwatw6LoJ8cJN
	 kV2zzW45pQBHZAr9aFEJrX8zVdQWoBGoWxzDbg+klEQDohPPy0FqyNcXWholvmvx/5
	 B0DPXhjCOKu5RwxU9VEN4kmyGZvBKe4ruu553psDFEopoVv4xFV3G39E8Fia6eaDX+
	 xvtcrK66X4CU6vlrE3+5zGQJ7AEcEdMSLWpCfdcNmOqDIheo2kwn+nn+AjRfSZjFdp
	 utHNjAZGKfJgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for EMC Symmetrix
Date: Mon, 19 Oct 2026 09:49:12 -0400
Message-ID: <20261019135441.1420968-261-sashal@kernel.org>
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

From: "Ewan D. Milne" <emilne@redhat.com>

[ Upstream commit f06a44e235ef188689ba23ffc72e9e89b10951a9 ]

EMC Symmetrix returns an error on MODE SENSE for page 0Ah subpage 05h
because it does not implement the SBC-5 I/O hints.  These commands began to
be sent as a result of commit 4f53138fffc2 ("scsi: sd: Translate data
lifetime information").  Add BLIST_SKIP_IO_HINTS to avoid sending these
commands because in large configurations the failed commands are displacing
other useful information in internal error logs.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Link: https://patch.msgid.link/20260915173800.39117-1-emilne@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **6.18.y** (`v6.18.57-155-gcdf239ca885b2`, `VERSION=6`
/ `PATCHLEVEL=18` / `SUBLEVEL=57`). The verdict is only for this tree.

The I/O-hints path and `BLIST_SKIP_IO_HINTS` are already here. At
`v6.18`, the EMC `SYMMETRIX` blacklist entry does **not** skip those
queries, so the bug exists.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject**
- Record: **[scsi/devinfo] [Add] hardware blacklist flag
  `BLIST_SKIP_IO_HINTS` for EMC Symmetrix**

**Step 1.2: Tags**
- Record:
  - `Signed-off-by: Ewan D. Milne <emilne@redhat.com>` (author, Red Hat
    SCSI)
  - `Link:
    https://patch.msgid.link/20260915173800.39117-1-emilne@redhat.com`
  - `Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>` (SCSI
    maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence is
    expected)
  - Pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit …]`
    ignored

**Step 1.3: Body**
- Record: **Bug:** EMC Symmetrix does not implement SBC-5 I/O hints, so
  `MODE SENSE` page `0Ah` subpage `05h` fails. Those commands started
  after `4f53138fffc2` ("scsi: sd: Translate data lifetime
  information").
- **Symptom:** In large configs, failed commands fill the array’s
  internal error logs and displace useful entries.
- **Root cause:** Kernel probes a mode page the device does not
  implement.
- **Version info:** The probing started with `4f53138fffc2`
  (`v6.9-rc1`); that commit is an ancestor of this tree.

**Step 1.4: Hidden bug fix?**
- Record: **No disguise.** This is an explicit hardware quirk. It is not
  cleanup/refactor.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Record: **1 file**, `drivers/scsi/scsi_devinfo.c`, **+1 / -1**, one
  table entry.
- Function: static `scsi_dev_info_list` initializer (EMC `SYMMETRIX`
  row).
- Scope: **single-file surgical quirk**.

**Step 2.2: Code flow**
- Record: **Before:** flags `BLIST_SPARSELUN | BLIST_LARGELUN |
  BLIST_REPORTLUN2 | BLIST_RETRY_ITF`.
- **After:** same plus `BLIST_SKIP_IO_HINTS`.
- Affected path: `sd_read_io_hints()` during `sd_revalidate_disk()`
  (probe, open/revalidate, rescan). With the flag set it returns
  immediately and does not send `MODE SENSE 0x0A/0x05`.

**Step 2.3: Bug mechanism**
- Record: **[Hardware workaround]** Device-specific skip of an
  unsupported SCSI mode page. Same pattern as USB storage and the Iomega
  ZIP `BLIST_SKIP_IO_HINTS` entries already in this tree.

**Step 2.4: Fix quality**
- Record: **Obviously correct.** One flag bit on an existing
  vendor/product match. Regression risk is **very low**: only EMC
  `SYMMETRIX` skips a feature it does not implement. No API, locking, or
  allocation changes.

---

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- Record: EMC `SYMMETRIX` row is old (`3441afc672bc` / `29cfc2ab71d96`
  for `BLIST_RETRY_ITF`, 2018). The **new** failure is not that row; it
  is `sd_read_io_hints()` from `4f53138fffc2` (**v6.9-rc1**,
  2024-02-26).

**Step 3.2: Fixes: tag**
- Record: **None.** The message names `4f53138fffc2`. `git merge-base
  --is-ancestor 4f53138fffc2 HEAD` → **yes**. `git describe --contains
  4f53138fffc2` → `v6.9-rc1~12^2~8`.

**Step 3.3: File history**
- Record: Related: `74b25178943fe` ("scsi: devinfo: Add
  BLIST_SKIP_IO_HINTS for Iomega ZIP") — same quirk class, already in
  this 6.18 tree. `633aeefafc9c2` introduced the flag (**v6.10-rc5**),
  also an ancestor. **Standalone**, not patch X/Y.

**Step 3.4: Author**
- Record: Ewan D. Milne is a long-time SCSI contributor (Red Hat).
  Applied by SCSI maintainer Martin K. Petersen. Related flag work by
  Bart Van Assche (`BLIST_SKIP_IO_HINTS` intro, `Cc: stable` there).

**Step 3.5: Prerequisites**
- Record: Needs `BLIST_SKIP_IO_HINTS` and `sd_read_io_hints()` skip
  check. Both exist in `v6.18` (`include/scsi/scsi_devinfo.h:73`,
  `drivers/scsi/sd.c:3235`). **Applies standalone.**

---

## PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1: Original discussion**
- Record: `b4 dig -c f06a44e235ef` →
  https://patch.msgid.link/20260915173800.39117-1-emilne@redhat.com
- **v1 only** (`b4 dig -a`). No NAKs. Laurence Oberman: “Looks good” +
  `Reviewed-by`. Martin Petersen: applied to **7.3/scsi-fixes**
  (`https://git.kernel.org/mkp/scsi/c/f06a44e235ef`). No `Cc: stable` in
  review.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Author + `linux-scsi@vger.kernel.org`. SCSI list was CCed;
  maintainer applied it.

**Step 4.3: Bug report**
- Record: No syzbot/bugzilla. Description is operational: array error-
  log overflow in large configs. That is a real enterprise SAN issue,
  not a theoretical one.

**Step 4.4: Series**
- Record: **Standalone 1/1.** ZIP quirk is a sibling pattern, not a
  dependency.

**Step 4.5: Stable list**
- Record: No lore.kernel.org/stable hit for this subject. WebFetch to
  lore returned 403; stable search via WebSearch found nothing relevant.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions**
- Record: No function body change. Table consumed via
  `sdev->sdev_bflags`. Consumer: `sd_read_io_hints()`.

**Step 5.2: Callers**
- Record: `sd_read_io_hints()` is called only from
  `sd_revalidate_disk()` (`drivers/scsi/sd.c:3773`).
- `sd_revalidate_disk()` is called from:
  - `sd_probe()` (disk attach)
  - `sd_open()` if `sd_need_revalidate()`
  - `sd_rescan()`
  - sysfs cache-type store path
- **Process context**, SCSI disk attach/revalidate. In a large Symmetrix
  config this runs once per LUN (often thousands).

**Step 5.3: Callees**
- Record: Without the flag, `scsi_mode_sense(..., modepage=0x0a,
  subpage=0x05, ...)`. On failure (`res < 0`) it already returns; the
  kernel does not oops. Harm is the failed command on the array.

**Step 5.4: Reachability**
- Record: **Yes.** Any EMC Symmetrix LUN probed as `sd` hits this. Not
  an obscure config path.

**Step 5.5: Similar patterns**
- Record: USB storage/`uas` set `BLIST_SKIP_IO_HINTS` because some
  devices **reset** on that page. Iomega ZIP uses it because the query
  makes the drive unusable. Same skip, milder Symmetrix symptom (error-
  log flood).

---

## PHASE 6: LOCAL TREE CROSS-REFERENCE

**Step 6.1: Buggy code in this tree?**
- Record: **Yes.** `v6.18` has `sd_read_io_hints()` and the flag check,
  and the EMC row **without** `BLIST_SKIP_IO_HINTS`. Bug since
  `4f53138fffc2` (v6.9), so it is in 6.18.

**Step 6.2: Backport difficulty**
- Record: **Clean apply.** Parent of the candidate still has the same
  two-line EMC entry as `v6.18`. No refactor of that table.

**Step 6.3: Related fixes already here?**
- Record: Flag infrastructure and ZIP/USB skips are present. **No**
  existing skip for EMC Symmetrix at `v6.18`.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
- Record: **[SCSI disk / scsi_devinfo] [IMPORTANT]** — not core mm/VFS,
  but enterprise block storage. EMC/Dell Symmetrix (VMAX/PowerMax
  lineage) is still used on LTS kernels.

**Step 7.2**
- Record: SCSI is actively maintained; this file is a mature quirk
  table, not a new subsystem.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1: Who is affected**
- Record: **Driver/hardware-specific:** hosts with `INQUIRY` vendor
  `EMC` / product `SYMMETRIX`. Typical: datacenter SAN on 6.18 LTS.

**Step 8.2: Trigger**
- Record: **Every disk revalidate** (probe, rescan, some opens). Common
  on boot and device discovery. Unprivileged users do not trigger it
  directly; udev/scan does. Not a race.

**Step 8.3: Failure mode**
- Record: **Not a kernel oops.** Failed `MODE SENSE` is ignored in
  `sd_read_io_hints()`. User-visible issue is **array error-log
  pollution** in large LUN counts, hiding real faults. Severity
  **MEDIUM** for the kernel, **HIGH** operationally on big arrays.
  USB/ZIP cases of the same flag were crash/unusable-device; this is the
  same class of quirk.

**Step 8.4: Risk/benefit**
- Record: **Benefit: high for Symmetrix users, zero for others. Risk:
  very low (1 flag bit, existing match).** Ratio favors backport.

---

## PHASE 9: SYNTHESIS

**Step 9.1: Evidence**

For:
- Real hardware incompatibility with a command 6.18 already sends
- Enterprise arrays, large LUN counts, error-log displacement
- 1-line quirk; `BLIST_SKIP_IO_HINTS` already in this tree
- Same class as USB/ZIP skips; ZIP already on 6.18
- Reviewed and applied to scsi-fixes by the SCSI maintainer
- Applies cleanly to `v6.18`

Against:
- Not a kernel crash, UAF, deadlock, or data corruption
- No `Cc: stable` / `Fixes:`
- Affects only one vendor/product

Unresolved:
- Lore HTTP 403; thread recovered via `b4 dig -m`. No public
  syzbot/bugzilla count of affected arrays.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — 1-bit flag; maintainer
   applied; `Reviewed-by: Laurence Oberman`
2. Real bug affecting users? **PASS** — unsupported `MODE SENSE` on
   production arrays
3. Important issue? **PASS** as a hardware quirk (array log overflow in
   large configs). Not a kernel panic.
4. Small and contained? **PASS** — +1/-1, one table row
5. No new features/APIs? **PASS** — uses existing flag
6. Can apply to this tree? **PASS** — flag, consumer, and EMC row all
   present at `v6.18`

**Step 9.3: Exception**
- Record: **Hardware quirk/workaround** (scsi_devinfo blacklist),
  analogous to USB/PCI quirks. That class is accepted for stable.

**Step 9.4: Decision**
This is a one-line device quirk for hardware this 6.18 tree already
probes with I/O-hints `MODE SENSE`. The skip flag and call site exist;
the EMC row does not skip yet. Risk is negligible; benefit is real for
Symmetrix/VMAX deployments. **YES for this tree.**

---

## What this solves for 6.18 users

Since v6.9, `sd_revalidate_disk()` calls `sd_read_io_hints()`, which
issues `MODE SENSE` page 0x0A subpage 0x05. EMC Symmetrix does not
implement that SBC-5 page and returns an error. The kernel already
swallows the error; on arrays with many LUNs those failures fill the
controller’s error logs. Adding `BLIST_SKIP_IO_HINTS` stops the query
for that INQUIRY match only.

It meets stable rules: small, obviously correct, no new API, applies
cleanly, and is a standard scsi_devinfo hardware quirk.

---

## Verification
- **[Phase 1]** Parsed tags: author SOB Ewan Milne, Link to msgid,
  maintainer SOB Martin Petersen; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: 1 line in `scsi_devinfo.c` EMC SYMMETRIX flags;
  adds `BLIST_SKIP_IO_HINTS`
- **[Phase 3]** `git describe HEAD` / `make kernelversion`: **6.18.57**
- **[Phase 3]** `git merge-base --is-ancestor 4f53138fffc2 HEAD`: yes;
  `git describe --contains`: v6.9-rc1
- **[Phase 3]** `git merge-base --is-ancestor 633aeefafc9c2 HEAD`: yes
  (flag intro, v6.10-rc5)
- **[Phase 3]** `git blame` EMC row: `29cfc2ab71d96` added
  `BLIST_RETRY_ITF` (2018); skip flag is new
- **[Phase 3]** `git show v6.18:drivers/scsi/scsi_devinfo.c`: SYMMETRIX
  **without** `BLIST_SKIP_IO_HINTS`
- **[Phase 3]** `git grep BLIST_SKIP_IO_HINTS v6.18`: flag and `sd.c`
  check present
- **[Phase 4]** `b4 dig -c f06a44e235ef`: lore URL; v1 only; Reviewed-by
  Laurence Oberman; applied to 7.3/scsi-fixes
- **[Phase 4]** `b4 dig -m`: full thread, no NAK, no stable nomination
- **[Phase 4]** WebFetch lore/msgid: **403**; used b4 mbox instead
- **[Phase 5]** Callers: `sd_read_io_hints` ← `sd_revalidate_disk` ←
  `sd_probe` / `sd_open` / `sd_rescan`
- **[Phase 6]** Parent of candidate matches `v6.18` EMC lines → clean
  apply
- **[Phase 8]** Failure: array error-log flood, not kernel oops;
  severity MEDIUM kernel / HIGH operational
- **UNVERIFIED:** Exact customer ticket / number of arrays (not in the
  thread)

**YES**

 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c51146882a1fa..a438e510f2cae 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -161,7 +161,7 @@ static struct {
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, no storage on LUN 0 */
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
-	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF},
+	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF | BLIST_SKIP_IO_HINTS},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
-- 
2.53.0

