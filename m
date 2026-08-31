Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1369753A8B3;
	Mon, 31 Aug 2026 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183935; cv=none; b=C1+xnjcHs0OD8/F2GIXI+BY53QFcKRS46Yp5HPZO/GeQYZCZAs4EwrIF4PU6YGYZHt0Lt3Y1L5sQQ5lTHrVrWc4/RIFckREYohqauD9rRQKFST2e3CHP14QRa8Uq8fSEy4m1D8HhhNhSA3009JBlSdiGA7zhBaTLlgYy1/TIMhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183935; c=relaxed/simple;
	bh=u2VbWB1KOfslj0Y7EK2JZGHgIF4SYu7D6lhQ0Tns460=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cock+0ItA7/tZdDsPKVmU0sZPVFYFk4zwlHSFz/h6ScamnVNRPNtr65rPKUuEAz3OAIbCCvvH+P9hGwExzhGKQunSWbwMz49MdIF8GNkPUqJZHlLIhyTRwrL1o/FLA2PmNpuzCUnfsUOZ49GgmBmLsLu8qrPAKpyK59DZIrI3ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9SQnUUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9SQnUUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EC01F000E9;
	Mon, 31 Aug 2026 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183933;
	bh=2PhcN9tAPCIbV4oOF7CSg18XLXgOjlOxm46iEzvCf64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9SQnUUsphwzUJdaVIFMG/vO03CzQJtIw+UqIrTz8RJjjE1/Ow64p8tk762H92/3j
	 ASgkN+Qq+czf7LY3MclXr6ynN4PHamz+PwI+N67vJ4xoVUGvYGUmIk8d6dFL1dqZpK
	 UMbs0lfofgLjWfwusY+PwQVt6dgwp3YMDLv6Jdt6iriUcUPf77EEPvOnHEfKerD/Xc
	 VmtqjxMASFThYgjghRCtkv7pGwzuUr+8q4gAtgNTYQyM8CO6DmDmQCvjfq5AhiSXFO
	 KxUJU8PejWFcn5fL22cmS74cVoIxSx2Rd/W3TAXu2Xk2N/1zHMTMMW2batEbfaf35U
	 KNP/JtACJnsXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()
Date: Mon, 31 Aug 2026 09:26:57 -0400
Message-ID: <20260831133314.4125787-389-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 57a6ed0b41677ccc5e28cc0976e495c1dfa33747 ]

bfa_fcs_fdmi_get_portattr() gets inlined into multiple places and has
two fairly large variables on the stack, to the point of causing a
warning in some randconfig builds:

drivers/scsi/bfa/bfa_fcs_lport.c:2198:1: error: stack frame size (1560) exceeds limit (1280) in 'bfa_fcs_lport_fdmi_build_portattr_block' [-Werror,-Wframe-larger-than]
 2198 | bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
      | ^
drivers/scsi/bfa/bfa_fcs_lport.c:1856:1: error: stack frame size (1600) exceeds limit (1280) in 'bfa_fcs_lport_fdmi_build_rhba_pyld' [-Werror,-Wframe-larger-than]
 1856 | bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
      | ^

Mark the inner function as noinline_for_stack to keep it separate from
the other variables and prevent multiple copies of the same variable to
get inlined here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260611125601.3385418-1-arnd@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[scsi: bfa] [reduce] Reduce kernel stack usage in
bfa_fcs_lport_fdmi_build_portattr_block()` — prevents excessive stack
frame size from compiler inlining in the Brocade BFA FC driver's FDMI
attribute-building path.

### Step 1.2: Parse All Tags
**Record:**
- **Link:**
  https://patch.msgid.link/20260611125601.3385418-1-arnd@kernel.org
- **Signed-off-by:** Arnd Bergmann `<arnd@arndb.de>` (author)
- **Signed-off-by:** Martin K. Petersen `<martin.petersen@oracle.com>`
  (SCSI maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer Signed-off-by; no syzbot or user bug reports

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `bfa_fcs_fdmi_get_portattr()` is inlined into callers that
  already hold large stack variables, pushing frame sizes to 1560/1600
  bytes.
- **Symptom:** Build failure with `-Werror,-Wframe-larger-than` (limit
  1280) in randconfig builds.
- **Affected functions:** `bfa_fcs_lport_fdmi_build_portattr_block`
  (1560 bytes) and `bfa_fcs_lport_fdmi_build_rhba_pyld` (1600 bytes).
- **Root cause:** Inlining duplicates `struct bfa_port_attr_s` and
  `struct bfa_lport_attr_s` locals from `get_portattr` into parent
  frames.
- **Fix:** Mark `bfa_fcs_fdmi_get_portattr()` as `noinline_for_stack` to
  keep its stack usage in a separate frame.
- No kernel version info in the message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not a hidden runtime bug fix. This is an explicit **build
fix** for `-Wframe-larger-than` treated as error (`-Werror`). No crash,
corruption, or deadlock at runtime.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/scsi/bfa/bfa_fcs_lport.c` — 1 line changed
  (attribute added to function declaration)
- **Functions modified:** `bfa_fcs_fdmi_get_portattr()` only
- **Scope:** Single-file, surgical (1-line change)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `static void bfa_fcs_fdmi_get_portattr(...)` — compiler
  may inline it into `bfa_fcs_lport_fdmi_build_portattr_block()`,
  `bfa_fcs_fdmi_get_hbaattr()` (called from
  `bfa_fcs_lport_fdmi_build_rhba_pyld()`), and other callers.
- **After:** `static noinline_for_stack void
  bfa_fcs_fdmi_get_portattr(...)` — function stays out-of-line; its
  `pport_attr` and `lport_attr` stack variables live in its own frame,
  not duplicated in callers.
- **Path affected:** FDMI attribute gathering during FC fabric
  registration (RHBA/RPRT/RPA CT payloads). Normal operation path, not
  error-only.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Build failure / stack frame size (not a runtime memory-
  safety bug).
- **Mechanism:** Compiler inlining expands caller stack frames beyond
  `CONFIG_FRAME_WARN` limit. With `-Werror`, this becomes a hard compile
  error.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — standard kernel pattern for stack
  pressure (`noinline_for_stack` is defined as `noinline` in
  `include/linux/compiler_types.h`).
- **Regression risk:** Very low. Slight code-size/call-overhead cost on
  an infrequent FDMI registration path; no behavioral change.
- **No red flags:** No API changes, no locking changes, no data
  structure changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `bfa_fcs_fdmi_get_portattr()` introduced by Krishna Gudipati,
  2010-09-15 (commit `a36c61f9025b89`).
- `struct bfa_lport_attr_s lport_attr` added 2013-05-13 (commit
  `d7cbc3044f2b2`).
- Buggy inlining pattern has been present for many years; exposure
  depends on compiler inlining decisions and `CONFIG_FRAME_WARN`.

### Step 3.2: Fixes: Tag
**Record:** No Fixes: tag. N/A.

### Step 3.3: Related File History
**Record:**
- Prior related fix in same file: `a7a11b6cfec2c` (Mar 2021) — "Move a
  large struct from the stack onto the heap" for
  `bfa_fcs_lport_fdmi_build_rhba_pyld()` (1200-byte frame > 1024 limit).
  That fix is **present in this tree**.
- Recent changes: strscpy conversion, unused code removal, state machine
  type fixes — unrelated.
- **Standalone:** Yes — single one-line patch, not part of a series.

### Step 3.4: Author Context
**Record:** Arnd Bergmann is a prolific contributor of `-Wframe-larger-
than` build fixes across the tree. Martin K. Petersen is the SCSI
maintainer. Neither is the BFA driver author, but both are credible
reviewers for this class of fix.

### Step 3.5: Dependencies
**Record:** No dependencies. `noinline_for_stack` exists in this tree
(`include/linux/compiler_types.h:278`). Patch applies cleanly to current
`bfa_fcs_lport.c` at line 2630.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Lore/patch.msgid.link fetch blocked by Anubis bot
protection. Could not retrieve thread. Commit message Link tag present
but content unverified.

### Step 4.2: Reviewers
**Record:** `b4 dig -c` failed (commit hash not in local tree).
Recipients unverified.

### Step 4.3: Bug Report
**Record:** No external bug report. Failure mode documented in commit
message (compiler error output from randconfig).

### Step 4.4: Related Patches
**Record:** Related prior fix `a7a11b6cfec2c` (heap allocation for HBA
attr struct) addresses the same class of problem in the same file and is
already in 6.18.y.

### Step 4.5: Stable List History
**Record:** Could not search lore (bot protection). No stable discussion
found.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `bfa_fcs_fdmi_get_portattr()` — builds port attribute
structure from HAL/driver info.

### Step 5.2: Callers
**Record:**
- `bfa_fcs_lport_fdmi_build_portattr_block()` — line 2212 (direct)
- `bfa_fcs_fdmi_get_hbaattr()` — line 2617 (indirect, via
  `bfa_fcs_lport_fdmi_build_rhba_pyld()` at line 1873)
- `bfa_fcs_lport_fdmi_build_portattr_block()` also called from
  `build_rprt_pyld()` and `build_rpa_pyld()`
- FDMI paths triggered from state machine during FC port online/fabric
  registration

### Step 5.3: Callees
**Record:** `bfa_fcport_get_attr()`, `fc_get_fc4type_bitmask()`,
`bfa_fcs_lport_get_*()` — attribute queries, no allocation in
`get_portattr` itself.

### Step 5.4: Reachability
**Record:** Reachable during FC HBA operation when FDMI registration
runs (port coming online on fabric). Not directly syscall-triggered, but
normal driver operation for Brocade FC hardware. Requires
`CONFIG_SCSI_BFA_FC`.

### Step 5.5: Similar Patterns
**Record:** Same file already uses heap allocation (`kzalloc`) for
`fcs_hba_attr` in `build_rhba_pyld()` (from `a7a11b6cfec2c`). This patch
uses the lighter-weight `noinline_for_stack` approach for
`get_portattr`.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **v6.18.44** (`stable/linux-6.18.y`).
At line 2630, function is still `static void
bfa_fcs_fdmi_get_portattr(...)` without `noinline_for_stack`. Large
stack variables (`pport_attr`, `lport_attr`) and callers
(`build_portattr_block`, `build_rhba_pyld`) all present. Fix commit is
**not** in this tree.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — single-line attribute addition. No
conflicting recent changes in this area. File line numbers differ
slightly from commit message (2198→2198 area, 2630 for the function) but
context matches.

### Step 6.3: Related Fixes Already Present?
**Record:** Prior heap-based stack fix `a7a11b6cfec2c` is present. This
`noinline_for_stack` fix is **not** present — `git log -S
"noinline_for_stack"` returns nothing for this file.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `drivers/scsi/bfa/` — Brocade BFA Fibre Channel HBA driver.
**Criticality: PERIPHERAL** (niche PCI FC hardware, `CONFIG_SCSI_BFA_FC`
tristate module).

### Step 7.2: Activity
**Record:** Moderate maintenance activity (strscpy migration, dead code
removal, type fixes in 2024–2025). Mature, stable driver code with long
history.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** **Config-specific** — kernel builders with
`CONFIG_SCSI_BFA_FC=y/m` and `-Werror` (W=1/randconfig CI). Not runtime
users of already-built kernels.

### Step 8.2: Trigger Conditions
**Record:**
- `CONFIG_FRAME_WARN` default is **1280 on 32-bit** (`!64BIT`) and
  **2048 on 64-bit** (verified in `lib/Kconfig.debug:441-449`).
- Reported frame sizes: 1560/1600 bytes — **exceed 1280** (32-bit
  default) but **under 2048** (64-bit default).
- Build error requires `-Werror` treating the warning as error.
- **Practical trigger:** 32-bit kernel builds with default
  `FRAME_WARN=1280` and W=1, or any arch with `FRAME_WARN ≤ 1560` and
  W=1, with BFA enabled.
- On typical 64-bit stable builds with default `FRAME_WARN=2048`, this
  does **not** fail even with W=1.

### Step 8.3: Failure Mode Severity
**Record:** **Compilation error** — kernel fails to build. **Severity:
LOW-MEDIUM** for stable (blocks builds for a narrow config subset; no
runtime crash, security issue, or data corruption).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** LOW — unblocks randconfig/W=1 builds for BFA on 32-bit
  (or low FRAME_WARN configs). No runtime user benefit.
- **Risk:** VERY LOW — one-line `noinline_for_stack`, zero behavioral
  change, standard kernel idiom.
- **Ratio:** Low benefit, very low risk. Qualifies as a build-fix
  exception but is not a high-priority stable item.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backporting:**
- Real build failure with `-Werror,-Wframe-larger-than` (documented
  compiler errors)
- Build-fix exception category per stable rules
- One-line, obviously correct, zero regression risk
- Same file had prior stack-frame fix (`a7a11b6cfec2c`) already in
  6.18.y
- Buggy code confirmed present in local 6.18.44 tree
- Applies cleanly

**AGAINST backporting:**
- **No runtime bug** — purely a compilation issue
- Affects only `CONFIG_SCSI_BFA_FC` (niche Brocade FC hardware)
- On 64-bit (majority of 6.18.y deployments), default `FRAME_WARN=2048`
  means frames of 1560/1600 do **not** trigger the error
- Primary impact is 32-bit + W=1 + BFA — very narrow audience
- No user reports, syzbot, or security implications
- Stable rule #3 ("important issue") is weakly satisfied — this is not
  crash/corruption/security

**Unresolved:**
- Lore discussion content (bot-blocked)
- Whether reviewers nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard
   `noinline_for_stack` idiom; maintainer SOB
2. Fixes a real bug affecting users? **PASS (narrow)** — real build
   failure, but only for specific build configs
3. Important issue? **BORDERLINE/FAIL** — build break, not
   crash/corruption/security; narrow config
4. Small and contained? **PASS** — 1 line
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply to 6.18.44

### Step 9.3: Exception Category
**Record:** **BUILD FIX** — prevents compilation errors with `-Wframe-
larger-than` + `-Werror`.

### Step 9.4: Decision Rationale

This is a legitimate, surgical build fix that applies cleanly to
linux-6.18.y and follows a pattern already used in this same file.
However, the practical impact on 6.18.y is narrow: the documented frame
sizes (1560/1600) exceed the 32-bit default limit (1280) but not the
64-bit default (2048), so typical 64-bit stable builds are unaffected.
The failure only manifests in randconfig/W=1 CI with BFA enabled on
32-bit or low-FRAME_WARN configs — a peripheral driver on an uncommon
build path.

Per the instructions, build fixes are backport-eligible, and the fix is
trivially safe. The benefit is low but real for kernel builders hitting
this configuration. Given zero regression risk and the established
precedent of stack-frame fixes in this driver already being in stable,
this qualifies for backport under the build-fix exception.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff analysis: 1-line `noinline_for_stack` addition to
  `bfa_fcs_fdmi_get_portattr()`
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9
  (linux-6.18.y)
- **[Phase 3]** `git blame -L 2630,2640`: function from 2010,
  `lport_attr` from 2013
- **[Phase 3]** `git show a7a11b6cfec2c`: prior heap-based stack fix in
  same file, present in tree
- **[Phase 3]** `git log -S "noinline_for_stack"`: no match — fix not
  yet in tree
- **[Phase 4]** WebFetch/curl lore.kernel.org: blocked by Anubis —
  discussion unverified
- **[Phase 4]** `b4 dig -c 8c9d423129c07`: commit not in local tree,
  failed
- **[Phase 5]** `grep bfa_fcs_fdmi_get_portattr`: callers at lines 2212,
  2617 confirmed
- **[Phase 5]** Read call chain: FDMI state machine → send_rhba/rprt/rpa
  → build_*_pyld → get_portattr
- **[Phase 6]** Read `bfa_fcs_lport.c:2630`: `static void` without fix —
  buggy code present
- **[Phase 6]** `git log --oneline -20 --
  drivers/scsi/bfa/bfa_fcs_lport.c`: no conflicting changes
- **[Phase 7]** `drivers/scsi/Kconfig:1502`: `CONFIG_SCSI_BFA_FC`
  tristate, PCI FC
- **[Phase 8]** `lib/Kconfig.debug:441-449`: FRAME_WARN default 1280
  (!64BIT), 2048 (64BIT)
- **[Phase 8]** Struct size estimate: inlined frames ~1380+ bytes,
  consistent with reported 1560/1600
- **[Phase 8]** `include/linux/compiler_types.h:278`:
  `noinline_for_stack` defined as `noinline`

**YES**

 drivers/scsi/bfa/bfa_fcs_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 9a85f417018f9..cabe408214b3f 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2627,7 +2627,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 
 }
 
-static void
+static noinline_for_stack void
 bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
-- 
2.53.0

