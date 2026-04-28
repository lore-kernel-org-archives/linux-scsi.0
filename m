Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C484219EF;
	Tue, 28 Apr 2026 10:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372976; cv=none; b=I7h/5yqQMq02fnWKAkz1OxUV+L+pX2t/IQOT1Gzrl5ffJOR3y37sxHPU+lJdB0ldNklLCrvzLVm458c+JEeEUD4WeRHbH116rjR1810RXfWsnwl18vIWGSUe7Fficz4zojUuPC0d15jfPE4bxts1fDYp8ObbKe2z0bmy/8oMz58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372976; c=relaxed/simple;
	bh=M1qs1/2NC+mhUZDFEbHz/pFDtWkwrwhHjHN2qrUw8PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uw/jtf3RBnaf7wHp4FGv9RGXTUQ3mR6Wvaz1063qarrTT05CZon7xxrs7PPIDi7nvZB9sXzdXSf1zfJdmWbg/akVrZv9TrdbNjFn/GNaU6LE/5zKF/ny0My96I9zh5E2hRxrCZdQnxyBRbRv1UuH5/ogMAoL5HeeCZ8BN1PulBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CO6vML2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CO6vML2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBC7C2BCB7;
	Tue, 28 Apr 2026 10:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372976;
	bh=M1qs1/2NC+mhUZDFEbHz/pFDtWkwrwhHjHN2qrUw8PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CO6vML2l89PmIIU+8mNboexgvZ+F+jx+/zRTJl5u/NPEIsAtRlfeiE2cxjjSg13L3
	 YJU3uPCqiTsRs8r8ivtG6Erzur2qgL6IYjjj5m/tDwBcmXhVpeReZlRGVWLhg/6qRx
	 4+K2J8kM8e9hLgL89GSWlEjSdc2RP9mA+lUF+Kega6CZQZozwl/HrN0L1pSu3tdSgu
	 /92fqK97SJ0kQ0j2r6GRoxulJAO1a8vrCBZfIbctFb/uyDcVynaPQE7v/1qhkqRdL4
	 jzjmZbBFU5dbP+6DrXumNhxecgIHT4viKbppCu9+YFmD9W/IcMsjlJUJ3bHRHY5+m/
	 axjijWtLHLbYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linuxdrivers@attotech.com,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] scsi: esas2r: Fix __printf annotation on esas2r_log_master()
Date: Tue, 28 Apr 2026 06:41:08 -0400
Message-ID: <20260428104133.2858589-57-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 67557418905b103eaa7bacf81999be83accda334 ]

clang-22 started warning about functions that take printf format
strings:

drivers/scsi/esas2r/esas2r_log.c:160:50: error: diagnostic behavior may be improved by adding the 'format(printf, 3, 0)' attribute to the declaration of 'esas2r_log_master' [-Werror,-Wmissing-format-attribute]
  121 |                 retval = vsnprintf(buffer, buflen, format, args);
      |                                                                ^
drivers/scsi/esas2r/esas2r_log.c:121:12: note: 'esas2r_log_master' declared here
  121 | static int esas2r_log_master(const long level,
      |            ^

The warning already got silenced for gcc but not clang in the past.
Rather than modify that hack to turn it off for both, just add the
attribute as suggested and remove the pragma again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260323100027.1975646-1-arnd@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete my analysis.

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line parse**
- Subsystem prefix: `scsi: esas2r:`
- Action verb: "Fix"
- Record: [scsi/esas2r driver] [Fix] [Adjust `__printf` annotation on
  `esas2r_log_master()` to silence a clang-22 `-Wmissing-format-
  attribute` compile error]

**Step 1.2 — Tags present**
- Signed-off-by: Arnd Bergmann (author), Martin K. Petersen (SCSI
  maintainer)
- Reviewed-by: Bart Van Assche (SCSI/block reviewer)
- Link:
  https://patch.msgid.link/20260323100027.1975646-1-arnd@kernel.org
- No `Fixes:` tag, no `Reported-by:`, no `Cc: stable@vger.kernel.org`
- Record: Reviewed by a well-known SCSI reviewer; no explicit stable
  nomination or Fixes reference.

**Step 1.3 — Commit body**
- clang-22 introduced a new diagnostic `-Wmissing-format-attribute`
  which is promoted to error by `-Werror` (e.g. `CONFIG_WERROR`). The
  message shows the exact error text referencing the `vsnprintf(buffer,
  buflen, format, args)` call inside `esas2r_log_master()`.
- A previous GCC-only workaround used `#pragma GCC diagnostic ignored
  "-Wsuggest-attribute=format"` guarded with `#ifndef __clang__`. That
  pragma silenced GCC but left clang with no annotation, and clang-22
  now emits an error.
- Fix: drop the pragma hack and add the real `__printf(3, 0)` attribute,
  which is the portable, compiler-correct solution.
- Record: Build-only change; no runtime behavior description; no user-
  visible symptom beyond compilation failure with clang-22.

**Step 1.4 — Hidden bug fix?**
- Not hiding any runtime bug. The fix is exactly what it appears to be:
  a compiler-attribute cleanup that also happens to be required for
  clang-22 builds.
- Record: Not a hidden runtime fix; it is a compilation/annotation fix.

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Single file: `drivers/scsi/esas2r/esas2r_log.c`, +3 / -11 lines
- Functions modified: `esas2r_log_master()` only (prototype annotation)
- Scope: single-file surgical annotation change.

**Step 2.2 — Code flow**
- Before: `static int esas2r_log_master(...)` with `#pragma GCC
  diagnostic push/pop` around it to hide `-Wsuggest-attribute=format`
  for GCC only.
- After: `static __printf(3, 0) int esas2r_log_master(...)` with no
  pragma wrappers.
- Execution flow is unchanged. `__printf(a, b)` expands to
  `__attribute__((format(printf, 3, 0)))`, a compile-time hint to the
  format-string checker. It affects compiler diagnostics, not generated
  code.

**Step 2.3 — Bug mechanism**
- Category (h) hardware workaround: N/A
- Category closest fit: **build/annotation fix** (compiler-attribute
  correctness). No runtime resource leak, race, UAF, deref, etc.

**Step 2.4 — Fix quality**
- Obviously correct: `esas2r_log_master(level, dev, format, args)` —
  `format` is argument 3, `args` is `va_list`, so `__printf(3, 0)` is
  the textbook annotation for a vprintf-style function (second argument
  `0` for va_list variants).
- Minimal, surgical, zero regression risk; binary output is effectively
  unchanged.

## Phase 3: Git History

**Step 3.1 — blame / introduction**
- `git log` on `drivers/scsi/esas2r/esas2r_log.c` shows the pragma
  workaround was introduced in commit `1c666a3e0a54e` ("scsi: esas2r:
  Supply __printf(x, y) formatting for esas2r_log_master()", Lee Jones,
  2021-03-12), which first appeared in **v5.13-rc1**.
- Record: Pragma present since v5.13; the clang-specific gap has existed
  ever since.

**Step 3.2 — Fixes: target**
- No Fixes tag. Logically references `1c666a3e0a54e`, which is present
  in 5.15.y, 6.1.y, 6.6.y, 6.12.y. (5.10.y does not carry 1c666a3e0a54e
  — neither the pragma nor the warning baseline exist there.)
- Record: Implicit target is in stable trees ≥5.15.y.

**Step 3.3 — File history**
- Recent churn on the file is minimal; the only other commit touching it
  around the pragma is the original Lee Jones cleanup. No competing
  changes that would complicate backport.

**Step 3.4 — Author context**
- Arnd Bergmann — prolific kernel build-fix contributor; many of his
  compiler-warning fixes have been backported to stable (e.g.
  `5c3de2cae7ced`, `09dc5be323d4f`, `7ebd51c3f032d`, `81fdecac3f2c0`).
- Record: Author is a trusted build-fix maintainer.

**Step 3.5 — Dependencies**
- No prerequisite patch required. Standalone. `__printf` and friends are
  kernel-wide macros present in all supported trees.
- Record: Standalone; applies without dependencies.

## Phase 4: Mailing-list research

**Step 4.1 — Original submission**
- `b4 dig -c 67557418905b103eaa7bacf81999be83accda334` resolved to `http
  s://lore.kernel.org/all/20260323100027.1975646-1-arnd@kernel.org/` — a
  single-version patch (no v2/v3).
- Thread pulled via mbox and inspected directly. Contents:
  - Bart Van Assche replied with `Reviewed-by:` immediately.
  - Martin K. Petersen replied first with "Applied to 7.1/scsi-staging"
    then "Applied to 7.1/scsi-queue" — no discussion about stable.
  - No NAKs, no alternative proposals, no stable request.

**Step 4.2 — Reviewers**
- `b4 dig -w`: To/Cc included Bradley Grove (driver author), James
  Bottomley, Martin K. Petersen, Nathan Chancellor, Nick Desaulniers,
  Bill Wendling, Justin Stitt, linux-scsi, linux-kernel, llvm list.
  Appropriate audience reviewed.

**Step 4.3 — Bug report**
- No Reported-by. The clang-22 diagnostic is self-reported by Arnd from
  his own build with clang-22.

**Step 4.4 — Series context**
- Single standalone patch; not part of a series.

**Step 4.5 — Stable mailing list**
- No stable-list discussion found via `b4 dig`. The SCSI maintainer
  explicitly queued to `7.1/scsi-queue`; no indication of stable intent.

## Phase 5: Code Semantic Analysis

**Step 5.1 — Functions in diff**
- Only `esas2r_log_master()` annotation changes.

**Step 5.2 — Callers**
- `esas2r_log_master()` is `static` in `esas2r_log.c`; callers are
  `esas2r_log()` and `esas2r_log_dev()` in the same file (visible in the
  full file read). These in turn are called from throughout the esas2r
  driver for logging. Reachability is normal driver code paths — all
  with constant format strings inside the module.

**Step 5.3 — Callees**
- `esas2r_log_master()` calls `spin_lock_irqsave`, `memset`, `snprintf`,
  `strlen`, `vsnprintf`, `printk` — standard kernel APIs, unchanged.

**Step 5.4 — Call chain**
- Logging path; nothing security-sensitive. Annotation change has no
  semantic effect on this path.

**Step 5.5 — Similar patterns**
- Similar clang-22 `-Wmissing-format-attribute` fixes exist in the same
  tree:
  - `d2fd4225d8de3` ("bug: avoid format attribute warning for clang as
    well")
  - `096abbb6682ee` ("clk: qoriq: avoid format string warning")
  - These confirm the clang-22 diagnostic is broadly hitting the kernel
    and is being addressed across subsystems the same way.

## Phase 6: Stable-tree cross-reference

**Step 6.1 — Does buggy code exist in stable?**
- The pragma `#pragma GCC diagnostic ignored "-Wsuggest-
  attribute=format"` (with the `#ifndef __clang__` guard) exists in
  5.15.y, 6.1.y, 6.6.y, 6.12.y. Those trees will emit the clang-22
  `-Werror=missing-format-attribute` and fail to build with
  `CONFIG_WERROR=y` + clang-22.
- 5.10.y does NOT carry the pragma commit and is not affected.

**Step 6.2 — Backport complications**
- File has seen virtually no churn since 2021. Pre-change context
  matches exactly between mainline and 5.15/6.1/6.6/6.12. Patch applies
  cleanly with no rework.
- Record: Clean apply to 5.15.y, 6.1.y, 6.6.y, 6.12.y.

**Step 6.3 — Related fixes already in stable?**
- No prior version of this fix exists in stable. Companion commits
  (`d2fd4225d8de3`, `096abbb6682ee`) are recent mainline only at this
  point.

## Phase 7: Subsystem context

**Step 7.1 — Subsystem / criticality**
- `drivers/scsi/esas2r/` — ATTO ExpressSAS SAS/SATA RAID driver.
  PERIPHERAL criticality (specific hardware, still "Supported" per
  MAINTAINERS).

**Step 7.2 — Activity level**
- Very low activity; only treewide mechanical changes recently.

## Phase 8: Impact / Risk

**Step 8.1 — Who is affected**
- Only users building affected stable trees with clang-22 (and typically
  with `CONFIG_WERROR=y`, which defaults to `COMPILE_TEST`). This is a
  limited audience today (clang-22 is brand new) but will grow over the
  life of these LTS trees.

**Step 8.2 — Trigger conditions**
- Compile-time only; never triggered at runtime regardless of
  configuration.

**Step 8.3 — Severity**
- With `-Werror`: build failure (prevents module compilation with
  clang-22).
- Without `-Werror`: a warning only.
- No runtime severity.

**Step 8.4 — Risk/benefit**
- Benefit: Low but real. Keeps stable trees compilable with newer
  compilers (important for CI/distros that build with clang).
- Risk: Near-zero. The diff only adds a format-checking hint; it cannot
  cause a regression.

## Phase 9: Synthesis

**Evidence FOR backport**
- Explicitly falls under the "BUILD FIXES" exception in stable-kernel-
  rules.rst.
- Fix is trivial (+3/−11), obviously correct, self-contained, and
  applies cleanly to 5.15/6.1/6.6/6.12.
- Reviewed by a maintainer (Bart Van Assche) and applied by Martin K.
  Petersen.
- Arnd Bergmann has a well-established pattern of similar compiler-
  warning fixes being AUTOSEL'd into stable (e.g., `5c3de2cae7ced`
  gcc-16 warning, `09dc5be323d4f` hwmon `__printf`, `7ebd51c3f032d`
  gcc-16 Wnonnull, `81fdecac3f2c0` Wformat-security). Those were also
  small cleanups without Cc: stable that were nonetheless picked up.
- Zero runtime risk — the attribute affects only compiler diagnostics.

**Evidence AGAINST backport**
- No `Fixes:`, no `Cc: stable`, no reviewer asking for stable.
- No runtime bug is being fixed.
- The warning requires clang-22 + `CONFIG_WERROR` to become a hard
  failure. clang-22 users on older LTS kernels are a narrow audience.

**Stable rules checklist**
1. Obviously correct and tested? Yes — tested by build with clang-22
   (shown in commit message) and reviewed.
2. Fixes a real bug affecting users? Yes, a real build-failure bug for
   clang-22 + WERROR users.
3. Important issue? Medium — build break, no runtime impact.
4. Small and contained? Yes, +3/−11 in one file.
5. No new features/APIs? Correct — just adds an attribute hint.
6. Apply to stable? Yes, cleanly to 5.15.y/6.1.y/6.6.y/6.12.y; not
   relevant to 5.10.y.

**Exception category**: BUILD FIX — explicitly enumerated as acceptable
stable material.

**Decision rationale**: The commit is exactly the kind of trivial, risk-
free build-fix that keeps stable trees compilable with current
toolchains. It mirrors other clang/gcc warning fixes already AUTOSEL'd
for LTS. The downside of backporting is effectively nil; the upside is
that 5.15+ LTS users can build this driver with clang-22 +
CONFIG_WERROR.

## Verification

- [Phase 1] Parsed tags via direct inspection of commit message and `git
  show 67557418905b1`: found Reviewed-by (Bart Van Assche), Link
  (patch.msgid.link), no Fixes, no Cc: stable, no Reported-by.
- [Phase 2] Diff inspection confirms: +3 lines (`__printf(3, 0)` +
  restructured prototype) / −11 lines (removed `#pragma GCC diagnostic
  push/ifndef __clang__/ignored/pop`). Only `esas2r_log_master()`
  prototype touched; function body unchanged.
- [Phase 3] `git log -- drivers/scsi/esas2r/esas2r_log.c` confirmed
  pragma workaround was added by `1c666a3e0a54e` (Lee Jones,
  2021-03-12).
- [Phase 3] `git describe --tags --contains 1c666a3e0a54e` →
  `v5.13-rc1~103^2~273`, confirming pragma first appeared in v5.13.
- [Phase 3] Verified `esas2r_log_master(level, dev, format, args)`
  argument numbering by reading the full function: `format` is the 3rd
  arg, `args` is `va_list`, so `__printf(3, 0)` is correct.
- [Phase 4] `b4 dig -c 67557418905b103eaa7bacf81999be83accda334` found
  the lore URL; saved full thread mbox to `/tmp/esas2r_thread.mbox` and
  read all messages. Only responses: Bart Van Assche's Reviewed-by and
  Martin K. Petersen's "Applied to 7.1/scsi-staging" then "Applied to
  7.1/scsi-queue". No stable nomination, no NAKs.
- [Phase 4] `b4 dig -w` confirmed Bradley Grove, James Bottomley, Martin
  K. Petersen, Nathan Chancellor, Nick Desaulniers, Bill Wendling,
  Justin Stitt, linux-scsi, linux-kernel, llvm list were on the
  recipient list.
- [Phase 5] Read full `drivers/scsi/esas2r/esas2r_log.c`: confirmed only
  callers of `esas2r_log_master()` are the same-file wrappers
  `esas2r_log()` and `esas2r_log_dev()`; function body and callees are
  unchanged by the patch.
- [Phase 6] Verified with `git log --oneline stable-
  push/linux-{5.10,5.15,6.1,6.6,6.12}.y --
  drivers/scsi/esas2r/esas2r_log.c` that 5.15/6.1/6.6/6.12 all have
  `1c666a3e0a54e` (the pragma commit) and thus are affected; 5.10.y
  lacks it and is NOT affected.
- [Phase 6] Printed `stable-
  push/linux-6.12.y:drivers/scsi/esas2r/esas2r_log.c` lines 98–125 to
  confirm pre-patch context matches mainline exactly; the diff will
  apply cleanly.
- [Phase 7] `grep -A5 "ATTO EXPRESSSAS" MAINTAINERS` confirmed the
  driver is "Supported" with Bradley Grove as maintainer.
- [Phase 8] Inspected `init/Kconfig` `config WERROR`: defaults to
  `COMPILE_TEST`, meaning builds that enable COMPILE_TEST (including
  many CI/distro builds) would see the clang-22 error as a build
  failure, not a mere warning.
- [Phase 8] Confirmed similar precedent: `git show 09dc5be323d4f` and
  `git show 5c3de2cae7ced` — both are Arnd Bergmann compiler-warning
  fixes that landed in `stable-push/linux-6.12.y` via AUTOSEL, both of
  similar trivial scope; this establishes the pattern.
- UNVERIFIED: Whether any specific distro/CI is already building these
  stable trees with clang-22 and hitting this break — but the risk of
  backporting is essentially zero regardless.

The fix is a textbook stable-eligible build fix: tiny, obviously
correct, no runtime impact, applies cleanly to all affected LTS trees,
written by a trusted build-fix author, and matches the pattern of
similar compiler-warning fixes already carried in stable.

**YES**

 drivers/scsi/esas2r/esas2r_log.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index d6c87a0bae098..46f489b2263cb 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -101,11 +101,6 @@ static const char *translate_esas2r_event_level_to_kernel(const long level)
 	}
 }
 
-#pragma GCC diagnostic push
-#ifndef __clang__
-#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
-#endif
-
 /*
  * the master logging function.  this function will format the message as
  * outlined by the formatting string, the input device information and the
@@ -118,10 +113,9 @@ static const char *translate_esas2r_event_level_to_kernel(const long level)
  *
  * @return 0 on success, or -1 if an error occurred.
  */
-static int esas2r_log_master(const long level,
-			     const struct device *dev,
-			     const char *format,
-			     va_list args)
+static __printf(3, 0)
+int esas2r_log_master(const long level, const struct device *dev,
+		      const char *format, va_list args)
 {
 	if (level <= event_log_level) {
 		unsigned long flags = 0;
@@ -175,8 +169,6 @@ static int esas2r_log_master(const long level,
 	return 0;
 }
 
-#pragma GCC diagnostic pop
-
 /*
  * formats and logs a message to the system log.
  *
-- 
2.53.0

