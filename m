Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AD33F54DB;
	Wed, 20 May 2026 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276055; cv=none; b=juniZ39si0LtODDEYdsjdBAIQfh2ILEKvSduPvFW5+2fOTHV+vowZzLjnscCdxW4HGODvld2Za0Vb+z/LdXp8O12ocXVaEArwcV60yf2bQ+/cQQdn5YV+0mbKJPyPFvdohcgtG0LLMNIu/JK9yguS8pPxudUT7XgZSQzznBX1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276055; c=relaxed/simple;
	bh=MSSv7cZG4QR4CTe1tyXdoTYxertwGmgfBqtd9Nohg+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJunGqjopsik5P0JPssvU4x4xgCXRvF5eHD7tdyT+MkOxo0l9XzBLNYH7754iy80XKZG0RQZ6rwKQDBZZurDpWyr2G/shI8lx8yVAJuAcOgVKRJSMn/7/If8FR045TXG5oaA+X0KpRPBZmFSZ7rRKwJgDsYR/ZyYQDJEuaBisjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rulbb9lA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rulbb9lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E8A1F000E9;
	Wed, 20 May 2026 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276053;
	bh=vo7xLNpRRxHEcNbThS8imVCpKzJpc9GuQTSEECQtEYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rulbb9lA0EbzBso6sdZzUlxWfynxQNJaCbdzGrqQPt3EYmMQhNWy6bzS90B7CI5LL
	 K+MWJFOyi2ZGy7k2jkbT8ODmTPH1iJVV9f4ZTvjjMW7EWeLfPTBFbfwusbmH3Sdhcg
	 RPasKQ30oTUGIChJlPKQe8dUI3YR9WQqr3cvwIXfJ1rIOs+Hohmj/xpcQCLc5t/7Kk
	 mk5ngTNj1juVE2z1XDQijR1pQj35JWgBZvQ6h1DTr9aZ4Fh2DWN/K1uJZiZvqKQn1V
	 vN36Fqmd9AkLdmXuud1UnNPNmohfTezHbkH+dBDfE4h7efXeM6GNWHAWM154Mi7i7A
	 6UnKAakfsllEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] scsi: smartpqi: Silence a recursive lock warning
Date: Wed, 20 May 2026 07:19:20 -0400
Message-ID: <20260520111944.3424570-48-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit d65efdf467ff935e35dfe6aa9a7ab93f17ac07ee ]

On systems with multiple controllers debug kernel shows

  WARNING: possible recursive locking detected

during shutdown.

Each controller does have its own ctrl_info (and mutex) and that isn't
correctly recognized by debug kernel.  Suppress the warning by releasing
the mutex at the end of pqi_shutdown().

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Don Brace <don.brace@microchip.com>
Link: https://patch.msgid.link/20260414124118.23661-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Decision Summary
Backport this to stable trees that contain the mutex-based
`pqi_ctrl_block_device_reset()` shutdown path, verified in `v5.15`,
`v6.1`, `v6.6`, `v6.12`, `v6.16`, and `v6.19`. Do not apply it as-is to
`v5.10`, where that helper only sets `block_device_reset = true` and no
`pqi_ctrl_unblock_device_reset()` helper exists.

This is a one-line fix for an imbalanced `lun_reset_mutex` lock in
`pqi_shutdown()`. The direct user-visible symptom is a lockdep “possible
recursive locking detected” warning during shutdown/reboot on systems
with multiple smartpqi controllers. The impact is mostly debug-kernel
noise rather than data loss or a production crash, but the patch
corrects real locking hygiene, is tiny, subsystem-reviewed, and has very
low risk.

## Phase Walkthrough
Phase 1:
- Record 1.1: subsystem `scsi: smartpqi`; action `Silence`; intent is to
  stop a recursive lock warning during shutdown.
- Record 1.2: tags present: `Signed-off-by: Tomas Henzl`, `Acked-by: Don
  Brace`, `Link:
  https://patch.msgid.link/20260414124118.23661-1-thenzl@redhat.com`,
  `Signed-off-by: Martin K. Petersen`. No `Fixes:`, no `Reported-by:`,
  no `Cc: stable`.
- Record 1.3: message describes debug kernels warning on multi-
  controller systems because distinct per-controller mutexes are not
  recognized as distinct after shutdown leaves one held.
- Record 1.4: hidden bug fix: yes. It is described as silencing a
  warning, but the code adds a missing unlock for a mutex acquired
  earlier in the same function.

Phase 2:
- Record 2.1: one file, `drivers/scsi/smartpqi/smartpqi_init.c`, one
  insertion in `pqi_shutdown()`. Single-file surgical fix.
- Record 2.2: before, `pqi_shutdown()` locked
  `ctrl_info->lun_reset_mutex` via `pqi_ctrl_block_device_reset()` and
  returned after `pqi_reset()` without unlocking. After, it unlocks via
  `pqi_ctrl_unblock_device_reset()`.
- Record 2.3: bug category is synchronization/lock balancing. The
  changed helper is verified as
  `mutex_unlock(&ctrl_info->lun_reset_mutex)`.
- Record 2.4: fix quality is high: one existing helper call, no new API,
  no refactor. Main risk is allowing a reset waiter to proceed late in
  shutdown; Tomas explicitly discussed this risk on-list and said he
  checked it.

Phase 3:
- Record 3.1: blame shows the shutdown call to
  `pqi_ctrl_block_device_reset()` is old, but `9fa8202336096` changed
  the helper to a mutex-based block/unblock model. That is the relevant
  introduction point for the missing unlock.
- Record 3.2: no `Fixes:` tag, so no tagged introducing commit to
  follow.
- Record 3.3: recent file history shows normal smartpqi churn, including
  fixes and device-ID updates; no prerequisite for this one-line helper
  call was identified for v5.15+ style code.
- Record 3.4: Tomas Henzl has SCSI commits in history but no recent
  smartpqi commits found; Don Brace is listed as smartpqi maintainer and
  acked the patch.
- Record 3.5: dependency is the existing
  `pqi_ctrl_unblock_device_reset()` helper. It exists in v5.15+ verified
  tags, not in v5.10.

Phase 4:
- Record 4.1: candidate commit hash was not available locally, so `b4
  dig -c` could not be used for this candidate. `b4 mbox` and `b4 am`
  using the Link fetched the original thread.
- Record 4.2: original recipients were `linux-scsi` and Don Brace; Don
  Brace acked it; Martin Petersen applied it.
- Record 4.3: external thread and an earlier related LKML post show a
  real lockdep splat with call trace through `__do_sys_reboot ->
  device_shutdown -> pci_device_shutdown -> pqi_shutdown`.
- Record 4.4: no newer v2/v3 was reported by `b4 mbox -c`; thread had
  six messages. A separate 2025 lockdep-key proposal for the same
  warning was found, but it is not present in this tree.
- Record 4.5: web search found no relevant stable-list discussion.

Phase 5:
- Record 5.1: modified function: `pqi_shutdown()`.
- Record 5.2: caller is PCI driver `.shutdown = pqi_shutdown`; this is
  reached from PCI/device shutdown during reboot/poweroff paths.
- Record 5.3: relevant callees are `pqi_wait_until_ofa_finished()`,
  `pqi_scsi_block_requests()`, `pqi_ctrl_block_device_reset()`,
  `pqi_ctrl_block_requests()`, `pqi_ctrl_wait_until_quiesced()`,
  `pqi_flush_cache()`, `pqi_crash_if_pending_command()`, `pqi_reset()`,
  and now `pqi_ctrl_unblock_device_reset()`.
- Record 5.4: verified external call trace reaches `pqi_shutdown()` from
  reboot. Trigger requires multiple smartpqi controllers and a
  debug/lockdep kernel.
- Record 5.5: similar lock/unlock pairing exists in OFA and
  suspend/resume paths; shutdown was the unmatched case.

Phase 6:
- Record 6.1: verified `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.16`, and
  `v6.19` have mutex-based block/unblock helpers and shutdown lacks the
  final unblock. Verified `v5.10` does not have the mutex helper.
- Record 6.2: expected backport difficulty is clean or trivial for
  v5.15+ style trees because the exact helper and shutdown context
  exist. v5.10 is not applicable as-is.
- Record 6.3: no related fix already present in the checked local tree;
  `lun_reset_key` proposal is absent.

Phase 7:
- Record 7.1: subsystem is SCSI storage driver, `smartpqi`; criticality
  is driver-specific but storage-related.
- Record 7.2: subsystem is active; recent history shows ongoing fixes,
  device IDs, and driver updates.

Phase 8:
- Record 8.1: affected users are systems with Microchip/Microsemi
  SmartPQI controllers, especially multiple controllers with
  debug/lockdep kernels.
- Record 8.2: trigger is shutdown/reboot. The verified external trace
  shows reboot path; unprivileged triggerability was not verified.
- Record 8.3: failure mode is lockdep warning/lock imbalance, severity
  medium-low in production terms but valid for debug-kernel correctness.
- Record 8.4: benefit is moderate for affected systems and CI/debug
  kernels; risk is very low because this is one line using an existing
  helper after a matching lock.

Phase 9:
- Record 9.1: evidence for backporting: real lock imbalance,
  reproducible lockdep warning, one-line fix, maintainer ack, existing
  helper, verified affected stable baselines v5.15+. Evidence against:
  symptom is mainly debug warning, not crash/data corruption; v5.10 not
  applicable as-is.
- Record 9.2: stable rules: obviously correct yes; fixes a real bug yes;
  important issue borderline but acceptable due lockdep warning and tiny
  risk; small/contained yes; no new features/APIs yes; applies to v5.15+
  style trees likely clean/trivial.
- Record 9.3: no exception category applies.
- Record 9.4: risk-benefit favors backporting for applicable stable
  trees.

## Verification
- Phase 1: Parsed supplied commit message and `b4 am` output; confirmed
  tags and absence of `Fixes:`/stable/Reported-by.
- Phase 2: Read `smartpqi_init.c`; confirmed
  `pqi_ctrl_block_device_reset()` is `mutex_lock()` and
  `pqi_ctrl_unblock_device_reset()` is `mutex_unlock()`.
- Phase 3: Used `git blame`, `git show 0530736e40a069`, and `git show
  9fa8202336096d`; confirmed helper semantics changed to mutex model in
  the shutdown/suspend update.
- Phase 4: `WebFetch` to `patch.msgid.link` was blocked by Anubis; `b4
  mbox`/`b4 am` fetched the lore thread successfully. `b4 am` reported
  the patch applies cleanly to current tree.
- Phase 4: Read lore mirror; confirmed Bart’s “patch looks fine”
  comment, Tomas’s risk discussion, Don Brace’s ack, and Martin
  Petersen’s apply notice.
- Phase 5: Used exact searches and file reads to trace `.shutdown =
  pqi_shutdown`, SCSI reset handlers, and related lock users.
- Phase 6: Used version tags to verify affected code in `v5.15+` and
  non-applicability to `v5.10`.
- Phase 7: Checked `MAINTAINERS`; confirmed Don Brace maintains
  smartpqi.
- Phase 8: External LKML mirror provided the concrete lockdep call trace
  and trigger conditions.
- Unverified: I did not build-test the patch and did not verify stable
  branch-specific conflicts beyond version-tag code presence.

**YES**

 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b4ed991976d06..2026ac645d6ab 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9427,6 +9427,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 
 	pqi_crash_if_pending_command(ctrl_info);
 	pqi_reset(ctrl_info);
+	pqi_ctrl_unblock_device_reset(ctrl_info);
 }
 
 static void pqi_process_lockup_action_param(void)
-- 
2.53.0

