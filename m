Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BC83EDAB5;
	Wed, 20 May 2026 11:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276034; cv=none; b=BxCXMoj4egF0VhEbfa8usChXRHQJl7sFd857yYPAJE8+HuHc8S2QAKU0NntPXqSSp771TGfkDrPZGVcdvHLzzvEbk66Wnb9WK6tGFUw8BjTV0SpkLJJCvZSHQRUgbsVsWYjpFnGkRUZWjp9Rq24G+FmnzP/WNGwuuUPYLFn2Qq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276034; c=relaxed/simple;
	bh=UVhRiCtsGtIVCO89w0KLFi9gBuY1+5o6JU2fTLcrA9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQTV9uz9ODQO11ZgdUmc7F+ivWOVUZDOzW9KXaUUa5znOz8VG9mAcLU0/SlChF8dFFZLyfKcJSroz0cIuvdQVb634C+QWc2Inr2lYg1gUIpXUovt6tfyFPyo162koTQ94DgcUbkodUX6dloHhW0u73qMHqhls5pTEFBK/osq38k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHT3ZQG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHT3ZQG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B551F00894;
	Wed, 20 May 2026 11:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276032;
	bh=mT3StINC2mhgXtCPfN7MARxMNwpBDP7Qp6+YyFXOb/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHT3ZQG2Q3IMWWgwIVesAv3DnLeZCOYT2WA3gizGJXlGxd0SXIS5jThqQ7U86Hwpq
	 kAQ92Mjuoi3UvZ0HIPn6ourVcvwqBR3gYkbeyqiWDCV3ijCZlnefL61RrO5AU/BmOg
	 JWmpN9FWWT5QWcHYUtf43JLxQx8UWvhed6KQK15oN7WmWTCsfu+J5S1kpQ3gD2uv0B
	 D9WqPKDUTltkeYrK+Pyn8ZR6j3YMxb+rOoLbnEdRKS9yKUGuHTPKVomW4LOhK8MOoe
	 7j+9KYQMYUEBYiCp9fYUb7exwOGmSPiDtrT9HjcHOq9Ayq67jpDLkCQKRtTmT0NVU3
	 lk5ZNCzfpP1/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>,
	Riya Savla <rsavla@purestorage.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] scsi: scsi_dh_alua: Increase default ALUA timeout to maximum spec value
Date: Wed, 20 May 2026 07:19:05 -0400
Message-ID: <20260520111944.3424570-33-sashal@kernel.org>
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

From: Brian Bunker <brian@purestorage.com>

[ Upstream commit 68c3a65a5a8e85643745fdde02cb63904e165620 ]

The ALUA handler maps a 0 value (no implicit transition timeout provided
by the target) to the ALUA_FAILOVER_TIMEOUT constant, currently 60
seconds. This means the kernel already does not accept an infinite
transition time.

However, 60 seconds is insufficient for some arrays that may take longer
to complete ALUA transitions. Since the highest value allowed by the
SCSI specification for the implicit transition timeout is a single byte
(255 seconds), change the default to 255. This way, when a target does
not provide an explicit transition timeout, we default to the maximum
value the spec allows rather than an arbitrary 60 second limit.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Co-developed-by: Riya Savla <rsavla@purestorage.com>
Signed-off-by: Riya Savla <rsavla@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://patch.msgid.link/20260416165512.26497-2-brian@purestorage.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Walkthrough

Phase 1 Record: Subsystem is `scsi: scsi_dh_alua`; action is “increase”;
intent is to raise the default ALUA implicit transition timeout from 60s
to 255s. Tags verified from commit
`68c3a65a5a8e85643745fdde02cb63904e165620`: co-developed/SOB by Krishna
Kant and Riya Savla, SOB by Brian Bunker, `Reviewed-by: Hannes
Reinecke`, `Link:` to the v4 posting, SOB by Martin K. Petersen. No
`Fixes:`, `Reported-by:`, `Tested-by:`, or `Cc: stable`. Body describes
a real behavior problem: targets that omit an explicit ALUA transition
timeout get capped at 60s, which is too short for some arrays.

Phase 2 Record: One file changed,
`drivers/scsi/device_handler/scsi_dh_alua.c`, 1 insertion/1 deletion. No
function body is modified; only `ALUA_FAILOVER_TIMEOUT` changes. The
macro is used by `submit_rtpg()`, `submit_stpg()`, `alua_tur()`, and
`alua_rtpg()` for command and transition expiry timing. Before: missing
target timeout defaults to 60s. After: defaults to 255s. Bug category is
logic/correctness for storage failover timing. Fix quality is very small
and obvious; main regression risk is slower failure detection for arrays
that omit timeout and remain stuck.

Phase 3 Record: `git blame` shows the 60s default came from
`3588c5a21aef8c` (`[SCSI] scsi_dh_alua: implement 'implied transition
timeout'`), first contained in `v3.6`. That original commit added the
implicit transition timeout machinery and made 60s the finite fallback.
Recent local history shows ALUA-related fixes but no prerequisite for
this one. Author Brian Bunker previously authored ALUA transition-state
fix `6056a92ceb2a7`, so this is from a contributor with direct ALUA
history. No standalone dependency was found.

Phase 4 Record: `b4 dig -c 68c3a65a5a8e8` found the v4 lore submission
at
`https://patch.msgid.link/20260416165512.26497-2-brian@purestorage.com`.
`b4 dig -a` found v3 and v4; v4 is the applied revision. `b4 dig -w`
shows Brian Bunker, `linux-scsi`, Hannes Reinecke, Krishna Kant, and
Riya Savla were included. The v4 thread has Hannes’s `Reviewed-by` and
Martin Petersen’s “Applied to 7.1/scsi-staging”. Earlier v2 discussion
verified Hannes objected to tying ALUA transition timeout to device
command timeout, and the patch evolved into the simpler 255s default. I
found no stable-list discussion.

Phase 5 Record: Modified function list is empty, but impacted code paths
are the ALUA RTPG/STPG/TUR and transition expiry paths. Call tracing
verified `alua_rtpg_work()` calls `alua_tur()` and `alua_rtpg()`,
`alua_activate()` queues RTPG from dm-multipath activation,
`alua_check_sense()` is invoked from SCSI error handling, and
`alua_prep_fn()` is called from SCSI request setup. This is reachable
from SCSI disk/device-handler attach, error handling, and dm-multipath
path activation. Similar pattern search found the same 60s fallback in
active stable tags.

Phase 6 Record: The buggy 60s default exists in `v4.14`, `v4.19`,
`v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.16`, `v6.17`, and `v7.0`
tags in this repo. The exact macro line is present, so backport
difficulty should be clean or trivial for those trees. `b4 am` also
reported the v4 patch “applies clean to current tree.” No alternate
stable fix was found.

Phase 7 Record: Subsystem is SCSI device handler / ALUA multipath
storage. Criticality is IMPORTANT: it affects systems using ALUA-capable
SCSI storage, especially enterprise multipath arrays. MAINTAINERS
verifies SCSI is maintained by James Bottomley and Martin Petersen, and
the patch was committed by Martin Petersen.

Phase 8 Record: Affected users are config/hardware-specific: ALUA SCSI
disk users, commonly multipath enterprise storage. Trigger is an ALUA
transition where the target omits an explicit transition timeout and
takes more than 60s. Failure mode is premature transition expiry,
leading `alua_rtpg()` to mark the port group standby and return I/O/path
failure. Severity is HIGH for affected systems because it can break
failover or storage availability. Benefit is high for affected storage
users; risk is low because this is a one-line bounded timeout increase
and 255s matches the implementation’s `unsigned char`/`buff[5]` timeout
representation.

Phase 9 Record: Evidence for backporting: real storage failover
correctness issue, long-lived bug since v3.6, affects many stable trees,
one-line bounded fix, reviewed by Hannes Reinecke, committed by SCSI
maintainer Martin Petersen, no new API or feature. Evidence against: no
formal `Reported-by` or `Tested-by`; behavior may wait longer before
declaring a nonresponsive target failed. Stable checklist: obviously
correct yes; real bug yes; important issue yes for storage
availability/path failure; small and contained yes; no new APIs yes;
applies to stable trees yes/trivial. Exception category: none, this is
not a device ID/quirk/build/doc fix.

## Verification

- Phase 1: `git show 68c3a65a5a8e8` verified commit message, tags,
  author, committer, and one-line diff.
- Phase 2: `git show` and source read verified only
  `ALUA_FAILOVER_TIMEOUT` changes from `60` to `255`.
- Phase 3: `git blame` verified the 60s default came from
  `3588c5a21aef8c`; `git describe --contains` verified `v3.6` ancestry.
- Phase 4: `b4 dig`, `b4 dig -a`, `b4 dig -w`, and saved mboxes verified
  v3/v4 review history, Hannes review, and Martin’s apply note. Direct
  WebFetch of lore was blocked/timed out; b4 succeeded.
- Phase 5: `git grep` and file reads verified ALUA call paths through
  SCSI request setup, SCSI error handling, and dm-multipath activation.
- Phase 6: `git grep` against stable tags verified the 60s default
  exists across listed stable releases.
- Phase 7: `MAINTAINERS` search verified SCSI maintainer/list context.
- Phase 8: Source inspection verified the failure path: timeout expiry
  in `alua_rtpg()` changes transitioning state handling to standby/I/O
  error.
- Unverified: I did not independently fetch the SCSI SPC text; the “255
  maximum spec value” claim is supported by the reviewed commit text and
  by the kernel implementation storing the timeout as a single byte.

This should be backported: it fixes a real ALUA multipath storage
availability problem with a tiny, bounded, maintainer-reviewed change
and minimal regression risk.

**YES**

 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efb08b9b145a1..80ab0ff921d43 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -37,7 +37,7 @@
 #define TPGS_MODE_EXPLICIT		0x2
 
 #define ALUA_RTPG_SIZE			128
-#define ALUA_FAILOVER_TIMEOUT		60
+#define ALUA_FAILOVER_TIMEOUT		255	/* max 255 (8-bit value) */
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
 #define ALUA_RTPG_RETRY_DELAY		2
-- 
2.53.0

