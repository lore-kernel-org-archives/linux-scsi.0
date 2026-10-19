Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006F7538798;
	Mon, 19 Oct 2026 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418670; cv=none; b=DJZcdUR8v4GS0pcCYKeHp0bE6tRQeesqtiS+mpTJvaPCrY4m5Fz2BCYV86ZXtzBkG9L9Ms1UrjOqJy/je53WnrQlphygWS6xjuqhwkgzRw2gufZZI26Fc55l0jgGCkjVHoudnqAAR45K5ZygNyaUhf1X+rR96c42DYiWRZEi3ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418670; c=relaxed/simple;
	bh=VLDFUnzYr/kJP7X9v9D8JhmnEzPCrODBEDVnGGHUFI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpDmXBrFftadO7d59hw4jha5TGPQLm64mYWhkky3VVJegCJBM/eGFV1oKc5XbaI0roQNQJnuGy8VGj8xHkEXjYy+CByVLnb08CPV0cW6Kkxfr3ZKlwUeM84+Ns6WUbe387Md4LiQa56PjvlKIphfvBE/WKw7FEAcSC/OUXs9G0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izT9Gbk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izT9Gbk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6CF1F000C4;
	Mon, 19 Oct 2026 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418667;
	bh=omVqzHTN2MdhSixPARI+dTwl1yirIrYLAitKRdp+isA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izT9Gbk4hwu4a4ZJ+/cTwzyWE+A64Gu27ecgW/8CdynPHGZ14Sx2iXvgPjGGrEuQO
	 RaG2KhDL3g2eHIulYiD2kDi3GUWp51W2SY8IabwI0LKnRE41MTQ9UAiiKwaTdy+CSg
	 UhVGgg6m+PI/9vmoy6qecaJhIUQL3wTAxjePds56VTu5NXlFQfMg3rV9u0j+aYa60a
	 8HDYkhiHrzOBpt317QzrK25/3ZTLOq3lxBVcz7+2cnBiwRE+azOlWe2PiYylxEGPqd
	 +CvIREAi+g8D+BZXfuQO3u5C4/OVjYfjUkGwYVQQudtUWBjKVpBklkpULLSUELErZP
	 yPd8ook3udxXw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Mon, 19 Oct 2026 09:51:43 -0400
Message-ID: <20261019135441.1420968-412-sashal@kernel.org>
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

[ Upstream commit 0122eab60b151d7815f420a91c7315944a037714 ]

Unlike ibmvfc_tgt_implicit_logout the ibmvfc_tgt_implicit_logout_and_del
path fails to check for a NULL evt returned from
ibmvfc_get_reserved_event and passes that directly to ibmvfc_send_event
which will unconditionally derefence the evt.

Check for a NULL evt and perform same escalation as
ibmvfc_implicit_logout.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260723000149.969416-4-tyreld@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real NULL-deref crash fix in ibmvfc’s target-delete path. The
local tree is **v7.3-rc4** (`7.3.0-rc4`); the driver and the buggy call
path exist here, and the change is an 8-line match of the sibling logout
error path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `scsi: ibmvfc`
- Action verb: `check` (safety check; commit body describes a NULL
  deref)
- Intent: stop passing a NULL event into `ibmvfc_send_event` on the
  implicit-LOGO + delete path

Record: [scsi/ibmvfc] [check] [NULL evt before send on implicit
logout/delete]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Signed-off-by: Tyrel Datwyler \<tyreld@linux.ibm.com\> (author; IBM
  ibmvfc maintainer/contributor)
- Link:
  https://patch.msgid.link/20260723000149.969416-4-tyreld@linux.ibm.com
- Signed-off-by: Martin K. Petersen \<martin.petersen@oracle.com\> (SCSI
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable
- Ignore pipeline SOBs if present; none besides author + SCSI maintainer

Record: Author + SCSI maintainer SOB; lore/msgid link; no
Fixes/Reported-by (expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Bug: `ibmvfc_tgt_implicit_logout` checks for NULL from event
  allocation; `ibmvfc_tgt_implicit_logout_and_del` does not
- Failure: NULL `evt` is passed to `ibmvfc_send_event`, which
  dereferences it
- Fix: same escalation as the sibling path (drop discovery thread, put
  kref, reset host)

Record: [NULL deref of evt] [kernel oops on target delete when reserved
pool is empty] [no version pins in message] [missed sibling NULL check]

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit NULL-deref fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- File at commit: `drivers/scsi/ibmvscsi/ibmvfc.c` (+8 / -0)
- Function: `ibmvfc_tgt_implicit_logout_and_del`
- Scope: single-file surgical error-path

Record: [ibmvfc.c +8] [ibmvfc_tgt_implicit_logout_and_del] [surgical]

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before: `discovery_threads++` → `__ibmvfc_tgt_get_implicit_logout_evt()`
→ `ibmvfc_send_event(evt)` with no NULL test.
After: if `!evt`, decrement `discovery_threads`,
`ibmvfc_set_tgt_action(NONE)`, `kref_put`, `__ibmvfc_reset_host`,
return.

Record: [error path only: unguarded send → guarded recovery matching
sibling]

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: memory safety (NULL pointer dereference), plus leak/refcount
on that path.

Verified mechanism:
- `__ibmvfc_tgt_get_implicit_logout_evt()` does `kref_get` then
  `ibmvfc_get_reserved_event()`; on failure it returns NULL (`ibmvfc-
  core.c` 4424–4427)
- `__ibmvfc_get_event()` can return NULL when the reserved pool is empty
  (1615–1630)
- `ibmvfc_send_event()` starts with `*evt->xfer_iu = evt->iu` (1787) —
  unconditional deref

Record: [NULL deref] [empty reserved event pool → NULL evt → oops; fix
mirrors implicit_logout]

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct as a crash fix: must not call
`ibmvfc_send_event(NULL)`, must undo `discovery_threads++`, must
`kref_put` the get done inside the helper.

Caveat (verified in `ibmvfc_set_tgt_action`): this path is entered with
`tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT` (set in
`ibmvfc_del_tgt`). From that state, only `LOGOUT_RPORT_WAIT` or
`DEL_RPORT` are accepted; `ACTION_NONE` is silently ignored. The send-
failure arm already uses `DEL_RPORT`. An automated review (sashiko-bot)
flagged this. It does not reintroduce the NULL deref: `kref_put` still
balances the helper, and `__ibmvfc_reset_host` still runs. Worst case,
the target stays in `LOGOUT_RPORT` and is retried after reset — far
better than an oops.

Record: [minimal, matches sibling; ACTION_NONE is a no-op here but not a
crash regression]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
- `ibmvfc_tgt_implicit_logout_and_del` introduced in `ed830385a2b1f`
  (“Avoid loss of all paths during SVC node reboot”), contained in
  **v5.7-rc1**
- NULL-returning `get_event` and sibling check added in `b39f2d10b86d0`
  (“Remove BUG_ON in the case of an empty event pool”), contained in
  **v6.7-rc1**. That commit updated
  `__ibmvfc_tgt_get_implicit_logout_evt` and
  `ibmvfc_tgt_implicit_logout` but **left `and_del` unchecked**
  (verified in the post-commit function body)

Record: [and_del: ed830385a2b1f / v5.7] [NULL return + incomplete call-
site update: b39f2d10b86d0 / v6.7]

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Effective buggy change is b39f2d10b86d0 (in this
tree; `git merge-base --is-ancestor` → YES)

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Series msgid `…969416-4` is **[PATCH v2 03/33]** of “ibmvfc: NVMe/FC
support over IBM Virtual FC”. Cover letter: patches 1–5 are **pre-
existing bug fixes** so the series is bisect-safe. This patch does not
depend on NVMe patches. Neighbors: `9c2aa65000f6f` (MAD send deadlock),
`7e35396ec8539` (teardown flush). Later `848c70852e3fb` split `ibmvfc.c`
→ `ibmvfc-core.c`.

Record: [standalone bugfix in a feature series] [no functional prereq on
later NVMe patches]

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Tyrel Datwyler is the ibmvfc author of the 2023 event-pool change and
this follow-up, plus the NVMe/FC series. Martin K. Petersen applied it.

Record: [subsystem author] [completes his own 2023 call-site sweep]

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Needs `__ibmvfc_tgt_get_implicit_logout_evt` returning NULL,
`ibmvfc_send_event`, `__ibmvfc_reset_host`. All present. Applies as 8
lines with no new APIs.

Record: [standalone vs current driver; prereq b39f2d10b86d0 is in this
tree]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- `b4 dig -c 0122eab60b151` → [PATCH v2 03/33],
  https://patch.msgid.link/20260723000149.969416-4-tyreld@linux.ibm.com
- `b4 dig -a` → v2 series only in the match: “NVMe/FC support over IBM
  Virtual FC” (2026-07-22)
- Cover letter: this is one of four pre-existing bugs (NULL event deref
  in `and_del`)
- Martin K. Petersen: “Applied to 7.3/scsi-staging, thanks!”
- Direct replies to 03/33: sashiko-bot only (ACTION_NONE concern). No
  human NAK.

Record: [lore msgid above] [v2 03/33] [SCSI maintainer applied] [AI note
on ACTION_NONE, no NAK]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w`: Tyrel Datwyler; James Bottomley; Martin K. Petersen; linux-
scsi; linuxppc-dev; linux-kernel; Brian King; Dave Marquardt.

Record: [SCSI maintainers + IBM ibmvfc people + linuxppc-dev]

**Step 4.3: SEARCH FOR THE BUG REPORT**
No Reported-by / syzbot / bugzilla. Bug described by the driver author
from code comparison with the sibling.

Record: [author-found incomplete 2023 update; no external repro]

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Standalone among 33; first four are bugfixes. Later patches are NVMe
feature work and must not be required.

Record: [self-contained; do not pull the NVMe series]

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
WebSearch of lore for this subject did not find a stable@ thread. Direct
lore.kernel.org fetches returned 403.

Record: [no stable-list hit found; lore HTTP 403 on direct fetch]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: [ibmvfc_tgt_implicit_logout_and_del]

**Step 5.2: TRACE CALLERS**
- Declared static; `ibmvfc_del_tgt()` sets `tgt->job_step =
  ibmvfc_tgt_implicit_logout_and_del` when action becomes `LOGOUT_RPORT`
  (687–694)
- Work thread `IBMVFC_HOST_ACTION_TGT_DEL` / `TGT_DEL_FAILED` invokes
  `tgt->job_step(tgt)` for `LOGOUT_RPORT` targets (6085–6097)

Record: [ibmvfc_del_tgt → work queue TGT_DEL → and_del; host work
thread, not IRQ]

**Step 5.3: TRACE CALLEES**
`__ibmvfc_tgt_get_implicit_logout_evt`, `ibmvfc_send_event`,
`ibmvfc_set_tgt_action`, `kref_put`/`ibmvfc_release_tgt`,
`__ibmvfc_reset_host`

Record: [event alloc/send, tgt state, kref, host reset]

**Step 5.4: FOLLOW THE CALL CHAIN**
Trigger: target removal / path loss on IBM Virtual FC (the v5.7 commit
was SVC node reboot / WWPN move). Userspace SCSI/FC path loss on a POWER
guest can reach this. NULL only if reserved CRQ events are exhausted
(`IBMVFC_NUM_INTERNAL_REQ` is small: `1+1+1+2+(disc_threads*2)`).
Unlikely but the 2023 change exists specifically because it can happen;
without this check it is a hard oops rather than recovery.

Record: [reachable on target delete] [NULL when reserved pool empty]
[oops from driver work thread]

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Sibling `ibmvfc_tgt_implicit_logout` already has the same 8-line guard
(4458–4464). This is the missed twin.

Record: [same pattern already in implicit_logout; and_del was the hole]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- `git describe HEAD`: **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion`: **7.3.0-rc4**
- Function lives in `drivers/scsi/ibmvscsi/ibmvfc-core.c` (file split
  after this commit)
- `git merge-base --is-ancestor 0122eab60b151 HEAD` → YES (landed in
  **v7.3-rc1**)
- Current `ibmvfc_tgt_implicit_logout_and_del` already has the NULL
  check (4530–4536)
- The hole existed from v6.7 until v7.3-rc1; this lineage had it and now
  has the fix
- `CONFIG_SCSI_IBMVFC` depends on `PPC_PSERIES && SCSI`

Record: [code path present in this tree] [bug from v6.7; fix already on
this HEAD]

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Against this HEAD the original diff would not apply as-is (`ibmvfc.c` →
`ibmvfc-core.c`, NVMe churn). Against a pre-split tree matching
v6.7–v7.2, the hunk is a clean 8-line insert next to the sibling.

Record: [clean on pre-split ibmvfc.c; this HEAD already contains the
equivalent]

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
This exact fix is already an ancestor. Sibling NULL check from
b39f2d10b86d0 is also here.

Record: [this fix already present; no alternate incomplete fix]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [SCSI ibmvfc / IBM POWER Virtual FC] [IMPORTANT for pseries
guests, not core-universal]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Mature client driver; recent NVMe/FC work. This NULL check is a pre-
existing SCSI-path bug, not NVMe enablement.

Record: [mature; this fix is independent of NVMe feature work]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: [platform-specific: PPC_PSERIES Virtual FC; enterprise POWER
VMs]

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: [target delete / implicit LOGO while reserved event pool empty]
[uncommon but real] [not a syscall smash; storage path loss on the
guest]

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: [NULL deref in ibmvfc_send_event → oops] [CRITICAL/HIGH]

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Benefit: avoid host oops during target logout/delete. Risk: 8 lines,
error path only; ACTION_NONE is a no-op from LOGOUT_RPORT but send-
failure already recovers via reset/delete. No API change.

Record: [high benefit vs low risk]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real NULL deref: `ibmvfc_send_event` uses `evt` without a check
- Incomplete 2023 call-site update left only `and_del` unguarded
- 8-line clone of the proven sibling path (thread count, kref, host
  reset)
- Author is the ibmvfc owner; SCSI maintainer applied it
- Cover letter calls this a pre-existing bug, not NVMe feature
- Reachable on IBM Virtual FC target delete (production POWER path)

AGAINST:
- Bundled as 03/33 of a large NVMe series (the patch itself is
  independent)
- No Fixes:/Cc:stable/user report (absence is expected)
- `ACTION_NONE` does not stick from `LOGOUT_RPORT`; `DEL_RPORT` would
  match the send-fail arm
- This HEAD already contains the commit (v7.3-rc1); original file name
  has changed

UNRESOLVED:
- Could not fetch lore.kernel.org HTML (403); used b4 mbox instead
- No stable@ discussion found

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mirrors sibling; applied by
   SCSI maintainer
2. Fixes a real bug that affects users? **PASS** — oops on target delete
   if reserved events are gone
3. Important issue? **PASS** — NULL deref / oops
4. Small and contained? **PASS** — +8 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** for this lineage (code exists;
   equivalent already in tree). A naive apply of the original `ibmvfc.c`
   diff onto current split sources would not be needed here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: [none; ordinary crash fix]

**Step 9.4: MAKE YOUR DECISION**
This tree is Linux **7.3-rc4**. The ibmvfc client, `and_del`, and NULL-
returning event allocator are all here. The bug is a missed NULL check
that oopses in `ibmvfc_send_event`. The patch is small, matches existing
recovery, and does not pull in NVMe/FC. The ACTION_NONE no-op is a minor
state-machine nit, not a reason to withhold a crash fix.

------------------------------------------------
What the commit solves for stable users
------------------------------------------------
On IBM POWER Virtual FC, deleting a target does an implicit logout. If
the reserved event pool is empty, allocation returns NULL. The sibling
logout path handled that; the delete path did not, so the host work
thread would oops. Users see a kernel crash during path loss / target
teardown rather than a host reset.

------------------------------------------------
Stable rules / risk vs benefit
------------------------------------------------
Meets the rules: real oops, tiny, no features. Benefit is crash
avoidance on a production pseries driver. Risk is low; recovery matches
the sibling. Do not backport the rest of the 33-patch NVMe series with
it.

------------------------------------------------
Concerns
------------------------------------------------
`ACTION_NONE` is ignored from `LOGOUT_RPORT`; `DEL_RPORT` would be the
closer match to the send-failure arm. Still prevents the oops. On this
7.3-rc4 tree the fix is already present (`0122eab60b151`); that is not
“already selected by the pipeline,” it is the mainline landing. The
driver code this commit exists to protect is in this tree.

Verification:
- [Phase 1] Subject/tags: scsi: ibmvfc NULL evt check; SOB Tyrel
  Datwyler + Martin K. Petersen; Link msgid 20260723000149.969416-4; no
  Fixes/Reported-by
- [Phase 2] Diff: +8 in `ibmvfc_tgt_implicit_logout_and_del` only
- [Phase 2] `__ibmvfc_get_event` can return NULL (ibmvfc-core.c
  1615–1630); helper returns that NULL (4424–4427); `ibmvfc_send_event`
  derefs at 1787
- [Phase 2] `ibmvfc_set_tgt_action`: LOGOUT_RPORT allows only
  LOGOUT_RPORT_WAIT or DEL_RPORT (531–537)
- [Phase 3] and_del from ed830385a2b1f (v5.7-rc1); incomplete sweep
  b39f2d10b86d0 (v6.7-rc1); this fix 0122eab60b151 (v7.3-rc1)
- [Phase 3] `git merge-base --is-ancestor b39f2d10b86d0 HEAD` YES;
  `0122eab60b151` YES
- [Phase 3] After b39f2d10b86d0, and_del still called
  `ibmvfc_send_event(evt)` with no NULL check
- [Phase 4] `b4 dig -c 0122eab60b151`: v2 03/33 NVMe/FC series; cover
  letter lists this as a pre-existing NULL deref
- [Phase 4] `b4 dig -w`: linux-scsi, linuxppc-dev, James Bottomley,
  Martin Petersen, Brian King
- [Phase 4] `b4 dig -m`: Martin applied to 7.3/scsi-staging; sashiko-bot
  ACTION_NONE comment; no human NAK
- [Phase 4] lore HTML fetch 403; WebSearch found no stable@ thread for
  this subject
- [Phase 5] Caller: `ibmvfc_del_tgt` → TGT_DEL work → `job_step`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4; NULL check present at ibmvfc-core.c 4530–4536
- [Phase 7] CONFIG_SCSI_IBMVFC: PPC_PSERIES Virtual FC client
- [Phase 8] Failure mode: NULL deref oops; severity HIGH/CRITICAL
- UNVERIFIED: human-tested repro on hardware (author analysis +
  maintainer apply only)

**YES**

 drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 8d7c304636d99..63cc569284ded 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4403,6 +4403,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
 						   ibmvfc_tgt_implicit_logout_and_del_done);
 
+	if (!evt) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
+
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
 		vhost->discovery_threads--;
-- 
2.53.0

