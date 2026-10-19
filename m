Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0688533D02;
	Mon, 19 Oct 2026 14:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418656; cv=none; b=tv4RIB0vxi9Bo4wH0tQP1zdafvXjctc9ZksJz5RfmTXUxquXWQpyBC/ax0hM//CWW3TAobwFVcN2YE+0BN/bY3Y2+KKQVGwjE4j/qFWIvn8Rl2neevccXv+7kTSOeOhQxRkN6dHaLLrcq9dHgbHHmV014TYziXsFvXF3+9Aphzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418656; c=relaxed/simple;
	bh=C1bgs5jaFhTTg1reKUnIiNRWJYbvls4rGwTNxbfQfjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCkzMmDEyCfy9lzrT6N3liGKd/tDXgrAOB1ZU23YdgpKzJDOx5aZyd3XOY5fDjPTP+KWbF02eDhiSWT5O3cLu85uTNYUnZ1ckKGJk8G/LJPdzUUy6V7BwWj9N7LlNrl3XnrZ8puoq7DxdNYtelcP+4bE1fA+H/NgwH68GAFesiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIIjvSe+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIIjvSe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1431F000CA;
	Mon, 19 Oct 2026 14:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418653;
	bh=yMtq3J68VL+kcl1SdaOWIUMZYTtpupDYw937qffVKRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIIjvSe+zh5eqyHsWRUV5R9hRaol2oaf2vn2QxOHQ6n9z2v7cfoEk0rltJH45ZztL
	 sDCvcpGV2wwIfbORZUXlgkA5DPb6R7fDMzbAPri3tZdVmxqLg2Q5PDGdenT8nouFPH
	 5V4PF5XbcGsTUJbgJTBmAwU4teLGGa0ktLQ1Zf0UK5OZRnHXEJf6m1KWehtKCLOCKy
	 LAWz/LrmzLRwb/2BXfVMYuSG4q64/oCNQY20hgyt4AXRCBAvpdqmzVKpX7wvbh7rhC
	 xKdWioEbeGlYSO6bEt2jL5VWRCNzAhWsFbf/yaQFgiQugJE3Lsh9VWtuvcCHwgDEO7
	 igmpYJ9Cpo3WA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	maddy@linux.ibm.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
Date: Mon, 19 Oct 2026 09:51:33 -0400
Message-ID: <20261019135441.1420968-402-sashal@kernel.org>
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

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 99143433f7f14139ac373c553ec8e1317d0ae58a ]

The ibmvfc_target *tgt structures for discovery are allocated using
mempool_alloc but in turn free'd via kfree in ibmvfc_release_target
breaking pool guarentees.

Fixup ibmvfc_release_target to call mempool_free instead so that memory
is properly returned to the mempool instead of the general allocator.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260723000149.969416-5-tyreld@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a one-line mempool/kfree mismatch in
ibmvfc that can drain the target pool and hang discovery. The local
7.3-rc4 tree has the driver and the bug’s code path.

## Phase 1: Commit message forensics

**Step 1.1: Subject**
Record: `[scsi/ibmvfc] [free] free ibmvfc_target allocations with
mempool_free` — claimed intent: stop freeing mempool-allocated target
structs with `kfree`.

**Step 1.2: Tags**
Record:
- `Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>` (author; IBM
  ibmvfc maintainer)
- `Link:
  https://patch.msgid.link/20260723000149.969416-5-tyreld@linux.ibm.com`
- `Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>` (SCSI
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)

**Step 1.3: Body**
Record:
- Bug: `ibmvfc_target` objects are allocated with `mempool_alloc()` but
  released with `kfree()` in `ibmvfc_release_tgt` (message says
  `ibmvfc_release_target`; the function is `ibmvfc_release_tgt`).
- Symptom: “breaking pool guarantees” — reserved mempool elements never
  return to the pool.
- Root cause: allocator/free mismatch (`mempool_alloc` vs `kfree`).
- No stack trace, reproducer, or version range. Failure mode is implied
  (pool accounting), not a reported oops.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. It is an explicit allocator-mismatch fix. The cover
letter for the series later names it as one of four pre-existing bugs,
not NVMe feature work.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File at commit time: `drivers/scsi/ibmvscsi/ibmvfc.c` (`1 insertion, 1
  deletion`)
- Function: `ibmvfc_release_tgt`
- Scope: single-file, one-line surgical fix

**Step 2.2: Code flow**
Record:
- Before: last `kref_put` on a target calls `kfree(tgt)`.
- After: same path calls `mempool_free(tgt, tgt->vhost->tgt_pool)`.
- Path: target teardown / kref drain (discovery logout, rport delete,
  sysfs starget accessors, host teardown), not an error-only path.

**Step 2.3: Bug mechanism**
Record: `[resource / mempool accounting]` plus a possible `[hang]`
- Alloc: `tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO)` in
  `ibmvfc_alloc_target`.
- Pool: `mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
  sizeof(struct ibmvfc_target))` with `IBMVFC_TGT_MEMPOOL_SZ == 64`.
- `kfree` of a reserved pool object returns that slab object to the page
  allocator without incrementing `pool->curr_nr`. After 64 alloc/free
  cycles the reserved pool is empty.
- `mempool_alloc()` with `GFP_NOIO` (`__GFP_RECLAIM` /
  `__GFP_DIRECT_RECLAIM`) first tries `kmalloc`; on failure it waits
  uninterruptibly on `pool->wait` until `mempool_free` refills. If
  nothing ever calls `mempool_free`, that wait never ends.
- Commit `5c66d9393f583` (2017) removed the NULL check on this
  `mempool_alloc` because “mempool_alloc() cannot fail when passed
  GFP_NOIO”. That is only true if the pool is actually returned to.

**Step 2.4: Fix quality**
Record: Obviously correct matching free. Minimal. `tgt->vhost` is set
before `kref_init`, so the pool pointer is valid on the free path.
Regression risk is low. Theoretical extra requirement vs `kfree`: the
pool must still exist; `ibmvfc_remove` does `fc_remove_host` /
`scsi_remove_host` and target `kref_put`s before `ibmvfc_free_mem()` →
`mempool_destroy()`. No later revert of this change.

## Phase 3: Git history

**Step 3.1: Blame**
Record: `kfree(tgt)` in `ibmvfc_release_tgt` comes from `b3c10489cb464b`
/ original driver `072b91f9c6510` (“[SCSI] ibmvfc: IBM Power Virtual
Fibre Channel Adapter Client Driver”, 2008-07-12, contained in
v2.6.27-rc1). The mismatch is as old as the driver. `tgt_pool` was
created in that same commit.

**Step 3.2: Fixes tag**
Record: None. Introducer is the original 2008 driver, present in this
tree’s history.

**Step 3.3: File history**
Record: This commit is `99143433f7f14`. Neighbors from the same
submission:
- `9c2aa65000f6f` 01/33 MAD send-failure deadlock
- `7e35396ec8539` 02/33 rport_add_work_q teardown
- `0122eab60b151` 03/33 NULL evt deref
- **this** 04/33 mempool_free
- `de7ac0f3f08b1` 05/33 move target list (NVMe prep, not required for
  this line)

Standalone relative to 05/33+. Later `848c70852e3fb` split `ibmvfc.c`
into `ibmvfc-core.c`; current tree has the fixed `mempool_free` in
`ibmvfc-core.c`.

**Step 3.4: Author**
Record: Tyrel Datwyler is the IBM ibmvfc maintainer (majority of recent
`drivers/scsi/ibmvscsi/` commits). SCSI maintainer Martin K. Petersen
applied the series.

**Step 3.5: Dependencies**
Record: None for the one-line change. It does not need NVMe/FC patches.
`mempool_free` / `tgt_pool` / `ibmvfc_release_tgt` all exist in this
tree.

## Phase 4: Mailing list

**Step 4.1: b4 dig**
Record:
- Lore:
  https://patch.msgid.link/20260723000149.969416-5-tyreld@linux.ibm.com
- Subject on list: `[PATCH v2 04/33] ibmvfc: free ibmvfc_target
  allocations with mempool_free`
- Series: `[PATCH v2 00/33] ibmvfc: NVMe/FC support over IBM Virtual FC`
  (2026-07-22)
- Cover letter (from saved mbox): “Patches 1-5: Bug fixes and
  preparatory refactoring. Four pre-existing bugs are fixed before any
  NVMe/FC work is introduced: … an allocator mismatch where mempool-
  allocated ibmvfc_target structs are freed via kfree rather than
  mempool_free.”
- Martin K. Petersen: “Applied to 7.3/scsi-staging, thanks!”
- No NAK on this patch. No reviewer asked for `Cc: stable` on this
  specific patch.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: `james.bottomley@hansenpartnership.com`,
`martin.petersen@oracle.com`, `linux-scsi@vger.kernel.org`, `linuxppc-
dev@lists.ozlabs.org`, `brking@linux.ibm.com`, `davemarq@linux.ibm.com`.
Right SCSI/PPC/IBM lists.

**Step 4.3: Bug report**
Record: No `Reported-by` / Bugzilla / syzbot. Bug was found by the
maintainer while preparing NVMe/FC.

**Step 4.4: Series**
Record: 33-patch NVMe/FC feature series. This patch is explicitly a pre-
existing bugfix (phase 1, patches 1–4). Self-contained.

**Step 4.5: Stable list**
Record: UNVERIFIED. lore.kernel.org search hit Anubis bot-protection
(403). No stable discussion in the saved scsi thread mbox.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `ibmvfc_release_tgt` only.

**Step 5.2: Callers**
Record: Many `kref_put(&tgt->kref, ibmvfc_release_tgt)` sites in
`ibmvfc-core.c` and `ibmvfc-nvme.c`: starget node/port name/id sysfs,
implicit logout / delete, PLOGI/PRLI, rport add/delete, host work
thread, module remove. Reachable from FC discovery, link events, and
sysfs.

**Step 5.3: Callees**
Record: `container_of`, then `mempool_free`. No new locks or
allocations.

**Step 5.4: Reachability**
Record: Yes, from normal IBM Power virtual FC use (target
discovery/logout and host removal). Not an obscure debug path.
`CONFIG_SCSI_IBMVFC` depends on `PPC_PSERIES`.

**Step 5.5: Similar patterns**
Record: Only this kfree/mempool mismatch for targets. Event pools in the
same driver already used mempool correctly. No follow-up fix after
`99143433f7f14`.

semcode MCP: not available in this session; used `git grep` / file
reads.

## Phase 6: This tree

**Step 6.1: Local tree and buggy code**
Record:
- `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion`: `7.3.0-rc4`
- `git merge-base --is-ancestor 99143433f7f14 HEAD`: yes — the fix is
  already in this checkout
- Current code (`ibmvfc-core.c:1431-1434`) already has
  `mempool_free(tgt, tgt->vhost->tgt_pool)`
- The mismatch existed here from v2.6.27 until this commit; the driver
  and `tgt_pool` still exist

**Step 6.2: Backport difficulty**
Record: Clean one-liner against pre-split `ibmvfc.c`. This 7.3-rc4 tree
already contains it; later split to `ibmvfc-core.c` does not change the
correctness of the fix.

**Step 6.3: Related fixes already here**
Record: The fix itself is here. `5c66d9393f583` (NULL-check removal) is
also here, which makes restoring pool refill more important.

## Phase 7: Subsystem

**Step 7.1**
Record: SCSI LLD `drivers/scsi/ibmvscsi/` — IBM Power Virtual FC.
Criticality: IMPORTANT for `PPC_PSERIES` storage (enterprise PowerVM),
PERIPHERAL for everyone else.

**Step 7.2**
Record: Actively developed in 7.3 (large NVMe/FC series). The bug itself
is old, not a new-subsystem issue.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Users of `CONFIG_SCSI_IBMVFC` on IBM POWER (pSeries) with
Virtual Fibre Channel. Not universal.

**Step 8.2: Trigger**
Record: Target alloc/free churn (discovery, logout, rport delete, host
reset). After 64 such cycles the reserved pool is empty. Hang requires
subsequent `mempool_alloc(GFP_NOIO)` while `kmalloc` fails (memory
pressure, no `__GFP_FS` reclaim). Unprivileged users do not call this
directly; fabric events and scans do.

**Step 8.3: Failure mode**
Record: Permanent mempool drain; under memory pressure, uninterruptible
hang in `mempool_alloc` during discovery (storage bring-up / recovery
stuck). Severity: HIGH for that platform (hang / lost discovery), not a
KASAN UAF from `kfree` of kmalloc-backed pool memory.

**Step 8.4: Risk-benefit**
Record: Benefit HIGH for ibmvfc users (restore mempool guarantees; avoid
discovery hang). Risk VERY LOW (1 line, matching alloc/free, maintainer-
authored, SCSI maintainer applied). Ratio favors including the fix.

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real allocator mismatch present since 2008
- One-line, obviously correct `mempool_free`
- Can empty the 64-element pool and then hang `mempool_alloc(GFP_NOIO)`
  under memory pressure
- 2017 change already assumes mempool never fails on this path
- Cover letter labels it a pre-existing bug, independent of NVMe/FC
- IBM/SCSI maintainers; applied to 7.3 scsi-staging
- Driver and bug exist in this 7.3-rc4 tree

Against:
- No user/syzbot report in 18 years (may be rare or attributed to memory
  pressure)
- Sent as 04/33 of a feature series (the line itself does not depend on
  the rest)
- Platform-specific (PowerVM virtual FC only)
- No `Fixes:` / `Cc: stable` (not a negative per the review rules)

Unresolved:
- Stable-list discussion (lore search blocked)

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — matching free; applied by
   SCSI maintainer.
2. Real bug that affects users? **PASS** — pool contract broken on every
   target free; hang is a realistic stress case.
3. Important (crash/security/corruption/deadlock)? **PASS** —
   uninterruptible wait in discovery if the drained pool cannot be
   refilled; storage recovery hang.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features/APIs? **PASS** — not the NVMe work; just the free
   path.
6. Can apply to this tree? **PASS** — code exists; commit is already an
   ancestor of HEAD; equivalent `mempool_free` is in `ibmvfc-core.c`.

**Step 9.3: Exception category**
Record: None needed (not a device ID/quirk/DT/build/doc exception). It
is a normal bugfix.

**Step 9.4: Decision**
This should be backported to this tree. It is a one-line correction of a
long-standing mempool leak/drain in IBM virtual FC target discovery,
with hang potential under memory pressure, and no meaningful regression
risk.

---

**What it solves for this tree:** `ibmvfc_target` objects come from
`vhost->tgt_pool` but were `kfree`d, so reserved pool slots were
permanently lost. After enough discovery/logout churn,
`mempool_alloc(GFP_NOIO)` no longer has a reserved pool and can block
forever if `kmalloc` fails. This 7.3-rc4 tree still has that driver; the
one-line `mempool_free` restores the guarantee.

**Stable rules:** Small, obviously correct, no new API, real
hang/discovery-failure bug, applies here.

**Risk vs benefit:** Very low risk, high benefit for PowerVM FC users.

**Concerns:** No field crash report; bug is old. That does not make the
mismatch or the hang path hypothetical. No extra commits are required.

Verification:
- [Phase 1] Parsed tags: author Tyrel Datwyler, Link msgid
  `...969416-5`, SOB Martin K. Petersen; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: 1 line in `ibmvfc_release_tgt`, `kfree(tgt)` →
  `mempool_free(tgt, tgt->vhost->tgt_pool)`
- [Phase 2] Confirmed alloc at `ibmvfc_alloc_target`:
  `mempool_alloc(vhost->tgt_pool, GFP_NOIO)`; pool size 64; `GFP_NOIO`
  is `__GFP_RECLAIM`
- [Phase 2] `mm/mempool.c`: `mempool_alloc_noprof` retries and waits on
  `pool->wait` when `__GFP_DIRECT_RECLAIM` is set; waiters woken from
  `mempool_free`
- [Phase 3] git blame: `kfree(tgt)` from original driver `072b91f9c6510`
  (2008, v2.6.27-rc1)
- [Phase 3] `git merge-base --is-ancestor 99143433f7f14 HEAD`: yes
- [Phase 3] Related: `5c66d9393f583` (v4.12-rc1) removed mempool_alloc
  NULL check
- [Phase 4] `b4 dig -c 99143433f7f14`: `[PATCH v2 04/33]`; cover letter
  lists this as a pre-existing bug; Martin: applied to 7.3/scsi-staging
- [Phase 4] `b4 dig -w`: linux-scsi, linuxppc-dev, Bottomley, Petersen,
  IBM
- [Phase 4] `b4 dig -a`: v2 of 33-patch NVMe/FC series; this patch is in
  the bugfix prefix
- [Phase 4] UNVERIFIED: lore.kernel.org/stable search (Anubis 403)
- [Phase 5] Callers: many `kref_put(..., ibmvfc_release_tgt)` in
  discovery/teardown/sysfs
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4; current `ibmvfc-core.c` already uses
  `mempool_free`
- [Phase 7] `CONFIG_SCSI_IBMVFC` depends on `PPC_PSERIES`
- [Phase 8] Failure mode: mempool drain → possible D-state hang in
  target discovery under memory pressure; severity HIGH for that
  platform
- UNVERIFIED: whether a target kref can outlive `mempool_destroy` on
  remove (no evidence it does; remove deletes rports first)

**YES**

 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 63cc569284ded..e3853e05aa27a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1366,7 +1366,7 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 static void ibmvfc_release_tgt(struct kref *kref)
 {
 	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
-	kfree(tgt);
+	mempool_free(tgt, tgt->vhost->tgt_pool);
 }
 
 /**
-- 
2.53.0

