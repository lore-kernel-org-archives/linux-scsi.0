Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64165938A1;
	Mon, 19 Oct 2026 13:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418337; cv=none; b=VLGLUbW1zuCoMyrTZivBKAwHEyTNBa7iHwaCAujVPLSa+GEGoxrv18khazfKe+shYQhCqZCxS+4/4qBrPl6Xs3OnM1//0htfavRXwo9umr3qnUd4vqnDeRPG9XCSniHLqjZCJXQC87rg5Jdj7SONP57Xm3m/R8pnybzjkMusPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418337; c=relaxed/simple;
	bh=bT3u0ml0R3Y0Kb4s1tT9sFu/HeQUpRwvtWKkgy2VdjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gDMOi93gJcOZXFqzgglS4zeIMABIYT+aq1B9IOf6wxQCQ44cpgmFFEabm92OL9HCV13xDo/gPWlWbUzZIeqDIdgbv1unsGMCbMYlU/lgW825Xzjp0SmVbTWvHN8o92m0h1iGWYNl2zxjVmrvnwqO6k78LVzi85/jEO+qbgmVaxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+44V+UY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+44V+UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDCF1F000C7;
	Mon, 19 Oct 2026 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418334;
	bh=NfE3wKi/vWXI5Wn/P+ZAA3BY3B/je2LljBAGpFdwS1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+44V+UYyAfSmjtEoAaLb0XEskmUK3iEnvyVyvtTJgGZaW4H8EA+DjdxFxItnqSxC
	 Y5Em2UoftWRUy06/FRS6D+B9f92KaGK4yMHbSlx28C3tVDYY9rC0jprNcXB+MtwByA
	 rzTSzHPuT7TdfyqL3AFicehZDuY9fSJEhvgAWCx/LftD5kuFStJDmAGntBzFhBCen+
	 XMJjs3eCc/U+s+RmkZUgJnXiU1tvnWTB6hsz2RhKT7PpOObAKb4Jb3yp85/keIW36C
	 /jPTfHJKRrFjsA1VXfG0BnqM/aS0GuIXDubgMi29lC3QMZGw+75pa5mi3K/mZKbInw
	 2CR51JqufDQRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Changcheng <chenchangcheng@kylinos.cn>,
	Narsimhulu Musini <nmusini@cisco.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kartilak@cisco.com,
	sebaddel@cisco.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: snic: Fix SCSI host leak on workqueue allocation failure
Date: Mon, 19 Oct 2026 09:47:45 -0400
Message-ID: <20261019135441.1420968-174-sashal@kernel.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 12e67eb89eb2b9516685c744d3f7de0a2d1bd701 ]

In snic_add_host(), if scsi_add_host() succeeds but
alloc_ordered_workqueue() fails, the function returns -ENOMEM with
shost->work_q left as NULL. The caller's error path then calls
snic_del_host(), which returns early when !shost->work_q without calling
scsi_remove_host(). The Scsi_Host remains registered in sysfs as a zombie
device even after the probe has failed. This causes:

 - The leaked host remains visible in /sys/class/scsi_host/ after probe
   failure, with state "running".

 - Subsequent SCSI host numbering is permanently shifted (the leaked host
   ID from ida_alloc() is never reclaimed).

 - Memory leak: the Scsi_Host allocation can never be freed because
   device_add() took a reference that can only be released by device_del()
   inside scsi_remove_host().

Fix by adding scsi_remove_host() in the workqueue allocation failure path
inside snic_add_host(), undoing the successful scsi_add_host() before
returning the error. This is cleaner than modifying snic_del_host() because
snic_del_host() is called from a shared error label that also serves paths
where snic_add_host() was never invoked.

Reproducer (requires no real SNIC hardware):

 - Build CONFIG_SCSI_SNIC=y (built-in)

 - Add snic.test_mode=1 snic.inject_wq_fail=1 to kernel cmdline

 - Boot with a PCI device matching the snic driver (e.g. QEMU edu device,
   PCI ID 0x1234:0x11e8, temporarily added to the driver's PCI ID table)

Before the fix:

  # /sys/class/scsi_host/ contains a zombie host0:
  $ cat /sys/class/scsi_host/host0/proc_name
  snic_scsi
  $ cat /sys/class/scsi_host/host0/state
  running
  # ata_piix gets host1, host2 (host0 stuck):
  scsi host1: ata_piix
  scsi host2: ata_piix

After the fix:

  # host0 is properly freed and reused by ata_piix:
  scsi host0: ata_piix
  scsi host1: ata_piix
  # No zombie host in /sys/class/scsi_host/

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Link: https://patch.msgid.link/20260727073438.209673-1-chenchangcheng@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy
`snic_add_host()` / `snic_del_host()` error path is present here and the
one-line fix applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[scsi: snic:] [Fix] [SCSI host leak when workqueue allocation
fails after scsi_add_host() succeeds]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` **absent** (expected for this review pipeline)
- `Cc: stable@vger.kernel.org` **absent** (expected)
- `Acked-by: Narsimhulu Musini <nmusini@cisco.com>` — original SNIC
  driver author / Cisco maintainer
- `Link: https://patch.msgid.link/20260727073438.209673-1-
  chenchangcheng@kylinos.cn`
- `Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>` (author)
- `Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>` (SCSI
  maintainer)
- `Reported-by:` none
- `Tested-by:` none (author included a concrete reproducer in the body)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `scsi_add_host()` succeeds, then `alloc_ordered_workqueue()`
  fails. `snic_add_host()` returns `-ENOMEM` with `shost->work_q ==
  NULL`. Probe goes to a shared error label that calls
  `snic_del_host()`, which returns immediately when `!shost->work_q` and
  **never** calls `scsi_remove_host()`.
- **Symptoms:** zombie `/sys/class/scsi_host/hostN` with state
  `running`; SCSI host ID from `ida_alloc()` never reclaimed (later
  hosts are numbered higher); `Scsi_Host` never freed because
  `device_add()`’s reference is only dropped by `device_del()` inside
  `scsi_remove_host()`.
- **Version info:** none in the message. Code dates to the original
  driver (v4.2).
- **Root cause:** error-path rollback does not undo a successful
  `scsi_add_host()` when workqueue alloc fails. Author correctly avoids
  changing `snic_del_host()` because that helper is also used on paths
  that never called `snic_add_host()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit leak/rollback fix with a documented
failure mode and a reproducer.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/scsi/snic/snic_main.c` — **+1 line**
- Function: `snic_add_host()`
- Scope: single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** on `!shost->work_q`, log, set `ret = -ENOMEM`, return.
  Host stays registered.
- **After:** same path also calls `scsi_remove_host(shost)` before
  returning `-ENOMEM`.
- Path: probe error path only (`snic_probe()` → `snic_add_host()` after
  `scsi_add_host()` succeeded).

Verified call chain in this tree:

```642:649:drivers/scsi/snic/snic_main.c
        ret = snic_add_host(shost, pdev);
        if (ret) {
                ...
                goto err_get_conf;
        }
```

`err_get_conf` later calls `snic_del_host()` (line 690). That helper
still early-returns on `!shost->work_q`, so after this fix it will not
call `scsi_remove_host()` a second time.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Error-path / resource leak.** Missing undo of
`scsi_add_host()` when workqueue allocation fails. Adding
`scsi_remove_host()` is the matching rollback. Also reclaims the host ID
(`ida_free()` in `scsi_host_dev_release()` after `device_del()`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one matching rollback for the successful
  `scsi_add_host()`.
- Not changing `snic_del_host()` avoids calling `scsi_remove_host()` on
  hosts that were never added (`err_get_conf` is also used when
  `snic_get_conf()` fails **before** `snic_add_host()`).
- Regression risk: very low. `scsi_remove_host()` is the documented
  pairing of `scsi_add_host()`. No double-remove: `snic_del_host()`
  still skips when `work_q` is NULL. No lock, API, or data-structure
  change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy control flow introduced in `c8806b6c9e824f` (“snic: driver for
  Cisco SCSI HBA”, Narsimhulu Musini, 2015-05-29).
- First appeared: **v4.2-rc1**. Present in this tree (`git merge-base
  --is-ancestor c8806b6c9e824f HEAD` succeeded).
- Nearby `alloc_ordered_workqueue()` rewrite: `6411307b63286e`
  (v6.12-rc1) — formatting only; the leak predates that.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is the original driver commit above,
which **is** in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `snic_main.c` history is workqueue-name cleanup
(`6411307b63286`, `b97c0741c7dcc`), slab-name uniqueness, const
template, SPDX. **No prior leak fix.** Standalone one-line patch, not
“X/Y” of a series (msgid `...-1` is a single patch).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: `git log --author="Chen Changcheng" -- drivers/scsi/` in this
tree is empty (author is not a historical SNIC contributor here). Weight
instead: **Acked-by original driver author** Musini, and SCSI maintainer
Martin K. Petersen applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `scsi_remove_host()`. Reproducer mentions
`snic.test_mode` / `snic.inject_wq_fail`; those parameters **do not
exist in this tree** (local test harness only). The fix itself does not
depend on them.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c <sha>` cannot be used: the candidate is **not** in this
  checkout (and the first SHA tried was an unrelated merge).
- Submission: msgid `20260727073438.209673-1-chenchangcheng@kylinos.cn`,
  2026-07-27.
- Thread: https://lists.openwall.net/linux-kernel/2026/07/27/428 and
  https://lkml.iu.edu/hypermail/linux/kernel/2607.3/06578.html
- Single revision (no v2/v3). Diff matches the candidate (1 line).
- No NAK. Cisco maintainer Acked-by in-thread. No reviewer asked for
  `Cc: stable`.
- lore.kernel.org fetches returned HTTP 403 from this environment.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc included Cisco SNIC maintainers (`nmusini`, `kartilak`,
`sebaddel`), James Bottomley, Martin K. Petersen, linux-scsi. Ack from
Musini; applied by Petersen.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author-found with an injected workqueue-fail
reproducer. Before/after sysfs and host-numbering evidence is in the
message.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not part of a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — `https://lore.kernel.org/stable/?q=...`
returned 403. No evidence of a prior stable NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `snic_add_host()` (modified). Related: `snic_del_host()`,
`snic_probe()`, `scsi_add_host()`, `scsi_remove_host()`.

**Step 5.2: TRACE CALLERS**
Record:
- `snic_add_host()` — only from `snic_probe()` (PCI probe).
- `snic_del_host()` — `snic_probe()` error path (`err_get_conf`) and
  `snic_remove()`.
- Reachable on Cisco SNIC PCI probe, including under memory pressure
  when `alloc_ordered_workqueue()` fails.

**Step 5.3: TRACE CALLEES**
Record: `scsi_add_host()`, `alloc_ordered_workqueue()`,
`scsi_remove_host()` (new). `scsi_remove_host()` sets host state,
unregisters transport, `device_unregister(&shost->shost_dev)`,
`device_del(&shost->shost_gendev)`. Final free and
`ida_free(&host_index_ida, shost->host_no)` happen in
`scsi_host_dev_release()` once refs drop.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: PCI probe (`snic_probe` → `snic_add_host`). Not a syscall hot
path. Userspace-visible effect when it fires: leftover
`/sys/class/scsi_host/` entry and shifted host numbers for **other**
SCSI drivers (author showed `ata_piix` taking host1/host2 because host0
was stuck).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: This `if (!shost->work_q) return;` before `scsi_remove_host()`
is unique to snic. Sibling Cisco `fnic` adds the host later and has a
dedicated `err_out_scsi_add_host` label. No duplicate snic copy of this
bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Local tree: `p-6.12-3-gc504cf0baa3d8`, **6.12.111**,
branch `pending-6.12`.

```305:323:drivers/scsi/snic/snic_main.c
        if (!shost->work_q) {
                SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");

                ret = -ENOMEM;
        }

        return ret;
} /* end of snic_add_host */

static void
snic_del_host(struct Scsi_Host *shost)
{
        if (!shost->work_q)
                return;

        destroy_workqueue(shost->work_q);
        shost->work_q = NULL;
        scsi_remove_host(shost);
}
```

Bug present since v4.2.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Surrounding hunk matches the candidate exactly
(`old found: True`, `new already applied: False`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log --grep` for this leak / `snic_add_host` / “workqueue
allocation failure” under `drivers/scsi/` found **no** prior fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: SCSI driver `drivers/scsi/snic/` (Cisco PCI-Express SCSI HBA,
`CONFIG_SCSI_SNIC`). **PERIPHERAL** hardware, but host-number leak is
**system-wide** for SCSI host IDs.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature/quiet. Driver added 2015; recent churn is mechanical
SCSI-wide workqueue cleanup. Long-standing bug, not a new-code issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific trigger (Cisco SNIC), **plus** any other SCSI
host on the same machine (permanent host ID shift). Config:
`CONFIG_SCSI_SNIC`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Probe-time `alloc_ordered_workqueue()` failure (ENOMEM /
workqueue creation failure). Uncommon, not a hot path, not unprivileged-
syscall. Once it happens, the zombie host and ID leak persist until
reboot.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: unreclaimable `Scsi_Host`, zombie sysfs device in
  `SHOST_RUNNING`, leaked host ID.
- Severity: **HIGH** for leak class (not a panic). Worse than a one-shot
  `kfree` leak because the object stays in sysfs and shifts numbering
  for later hosts.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium for SNIC users under memory pressure; also
  prevents global SCSI host-id skew.
- **Risk:** very low (1 line, error path only, standard SCSI rollback).
- **Ratio:** favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real error-path leak with concrete sysfs + host-ID consequences,
  reproduced by the author
- Buggy code is in this 6.12 tree (since v4.2)
- One-line, obviously correct pairing of `scsi_remove_host()` with
  successful `scsi_add_host()`
- No double-remove on the shared `err_get_conf` path
- Applies cleanly; no prerequisites
- Acked by original driver author; applied by SCSI maintainer
- Probe-path resource leaks are a common, accepted stable class

AGAINST:
- Trigger is rare (workqueue alloc fail during probe)
- SNIC is a specialized Cisco HBA (small population)
- Not a crash, UAF, or security bug
- Reproducer uses out-of-tree inject knobs (does not affect the patch)

UNRESOLVED:
- Stable-list discussion (lore 403)
- Upstream SHA not in this checkout (`b4 dig` on a local commit was not
  possible)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line rollback; author
   showed before/after; maintainer Ack
2. Fixes a real bug that affects users? **PASS** — zombie sysfs host +
   leaked ID + unreclaimable `Scsi_Host`
3. Important issue? **PASS** — unrecoverable resource leak that also
   skews SCSI host numbering for other drivers
4. Small and contained? **PASS** — +1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code matches; clean apply

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary error-
path leak fix.

**Step 9.4: MAKE YOUR DECISION**
This is a real, long-standing probe rollback bug in this 6.12 tree. The
fix is minimal, already reviewed, and undoes `scsi_add_host()` exactly
when that call succeeded and the workqueue did not. Risk of regression
is negligible; leaving it out leaves a zombie SCSI host and a leaked
host ID if SNIC probe hits ENOMEM.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: Acked-by Musini; Link msgid
  `20260727073438.209673-1`; no Fixes/stable Cc (expected)
- [Phase 2] Diff: +1 line in `snic_add_host()` error path;
  `scsi_remove_host(shost)` before `-ENOMEM`
- [Phase 2] Confirmed `snic_probe` uses shared `err_get_conf` which
  calls `snic_del_host()` even when `snic_add_host()` was never invoked
  (lines 630–690)
- [Phase 2] Confirmed `snic_del_host()` early-return on `!work_q` skips
  `scsi_remove_host()` — the leak mechanism
- [Phase 3] `git blame`: buggy code from `c8806b6c9e824f` (v4.2-rc1);
  ancestor of HEAD
- [Phase 3] `git log --oneline -20 -- drivers/scsi/snic/snic_main.c`: no
  prior leak fix
- [Phase 3] `git log --grep` for this leak under `drivers/scsi/`: empty
- [Phase 3] `git log --author="Chen Changcheng" -- drivers/scsi/`: no
  prior commits in this tree
- [Phase 4] `b4 dig -c` on a tree SHA: not applicable (candidate not in
  checkout); used msgid/openwall/lkml instead
- [Phase 4] Openwall/lkml: single-version patch, Acked-by Musini, no NAK
- [Phase 4] lore.kernel.org and lore stable search: HTTP 403 —
  UNVERIFIED
- [Phase 5] Callers: `snic_add_host` only from `snic_probe`;
  `snic_del_host` from probe error + remove
- [Phase 5] `scsi_remove_host()` → `device_del()`;
  `scsi_host_dev_release()` does `ida_free(host_no)`
- [Phase 5] `test_mode`/`inject_wq_fail` not in this tree (reproducer-
  only)
- [Phase 6] `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion`: 6.12.111
- [Phase 6] Surrounding code identical to candidate hunk; patch not
  already applied
- [Phase 8] Failure mode: zombie sysfs SCSI host + permanent host-ID
  leak; severity HIGH for leak class, rare trigger
- UNVERIFIED: whether this was already discussed on stable@ (lore 403)

This meets stable-kernel rules for this tree: real leak, small contained
fix, clean apply, no new API.

**YES**

 drivers/scsi/snic/snic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 1c24517e4e650..912f9f15dddc3 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -305,6 +305,7 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
 	if (!shost->work_q) {
 		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
 
+		scsi_remove_host(shost);
 		ret = -ENOMEM;
 	}
 
-- 
2.53.0

