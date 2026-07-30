Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519693C1D72
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453745; cv=none; b=B/JKBV45ZsaJS/GSG1IhBNbit2RQu0FoI2wceSadRoQBjChuy1pvkDIScd/iNMr3hzrek95FN4I3SR6mfuaWGNZgJtM6gY8WKaFNeeppWEs/KzsDvwRW5B1M246yHdSqlW0FzdwH9nv2jqN7vrKBAPztKsIsFqX5TuF6zldNBU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453745; c=relaxed/simple;
	bh=hbc9xmKd9jd61tB9HCW9ST8MvxglmpHCVfXeGvEJ9LM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pic+gHM10oqFezNxfB4+cElqZXbPwzLor0S/jZ25pkl8z9vC1lcacPzQWcHkav0kVYyVSrJdF2LoKUuehrmuxxnaF3yyzB4hJ8zCdV1cfFV7QXHDGMi62udp7jwXy1rHNzPZvLAmXOLj86dcdXNKrW+G0gknHtqx0OQaBlJSWJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tn+FnH6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tn+FnH6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D51F000E9;
	Thu, 30 Jul 2026 23:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453744;
	bh=hbc9xmKd9jd61tB9HCW9ST8MvxglmpHCVfXeGvEJ9LM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tn+FnH6kPifTDXEpljyr47b+dgbfyZQHeZahzS7z8VEu36GpYpN05GZqNPrsTHlyK
	 +74d+tNzon2HafoegIcgYPzDh46h0Fc5Vwyot/PrYnD4DFN+9pRlSLybNwEMumm28E
	 RHkprDNeBuYjWk4oWKO89S+NYlPpoiSWdVFahunzLTEVm+/yMXmrZUEzUbFQrRQIkI
	 2CnFbNMHNL3aE6hw3rQ6N28OdyI0punsjVtRAywZ4hKbB+beV5yAxUJKy5mb5Ne0wE
	 8u1970MdCG1wT89re4F+JN6fDWvIy9U8pXnbHbxbYj4bQNUMRlcpRwejdtK7wOXgy5
	 LY6ZelZ68WgHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 52/57] scsi: smartpqi: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <47e31945d3981b05b9e1a94045f0e2f62bcd8cca.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <47e31945d3981b05b9e1a94045f0e2f62bcd8cca.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:22:23 +0000
Message-Id: <20260730232223.CA3D51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Medium] The patch introduces fake `__acquire()` directives to artificial=
ly balance the static analyzer's lock count, and the commit message incorre=
ctly claims to use `__must_hold()` and `__no_context_analysis()` which are =
entirely absent.

Pre-existing issues:
- [High] The driver violates strict `struct mutex` ownership rules by acqui=
ring mutexes in one execution context and releasing them in another, result=
ing in cross-task unlock violations.
- [High] Error paths in `pqi_resume_or_restore` return early without releas=
ing `scan_mutex` and `lun_reset_mutex`, causing a permanent lock leak.
- [High] Blindly unlocking `ofa_mutex` during an OFA cancellation event in =
`pqi_ofa_process_event()` without verifying it is held causes undefined beh=
avior.
--

--- Patch [52]: [PATCH v3 52/57] scsi: smartpqi: Enable lock context analys=
is ---
Please note that due to recitation restrictions, this review uses a free-fo=
rm
summary format rather than quoting the original patch diff directly.

commit 8564515b7a0cc93357264da233ee9448ed603eee
Author: Bart Van Assche <bvanassche@acm.org>
scsi: smartpqi: Enable lock context analysis

This patch aims to document locking requirements in the smartpqi driver usi=
ng
sparse annotations like __acquires() and __releases() to enable lock context
analysis.

[Severity: Medium]
The commit message states that this patch annotates functions with
__must_hold() and __no_context_analysis, but neither of those seem to be
used in the actual code.

Additionally, in functions like pqi_process_soft_reset() and
pqi_update_device_list(), the patch adds fake __acquire() directives with
comments asking what guarantees the mutexes are held. Does this misuse
the sparse annotations by artificially balancing the lock count just to
suppress warnings, instead of fixing or properly documenting the locking
design?

[Severity: High]
This isn't a bug introduced by this patch, but the driver appears to
violate strict struct mutex ownership rules. For example,
pqi_ofa_memory_alloc_worker() acquires the ofa_mutex, but the lock is later
released by a completely different worker thread in pqi_ofa_quiesce_worker()
(via pqi_process_soft_reset()).=20

Similarly, pqi_suspend_or_freeze() locks scan_mutex and lun_reset_mutex
prior to sleep, which are then released by resume operations, potentially
across different async PM threads.

Since struct mutex requires the locking task to be the one that unlocks it,
could this lead to DEBUG_LOCKS_WARN_ON, workqueue lock leak warnings, and
potential internal mutex state corruption during firmware events or system =
PM
operations?

[Severity: High]
This is a pre-existing issue, but in pqi_resume_or_restore(), if the driver
encounters a disconnected device (ctrl_removal_state !=3D PQI_CTRL_PRESENT)=
 or
if pqi_resume_ctrl() fails, the function returns early.=20

Since it returns without calling pqi_ctrl_unblock_device_reset() and
pqi_ctrl_unblock_scan(), does this cause a permanent resource leak of
scan_mutex and lun_reset_mutex? This could leave the driver deadlocked for
any future operations requiring these locks. The patch seems to legitimize
this leak to sparse by adding __cond_releases() annotations.

[Severity: High]
This is a pre-existing issue, but in pqi_ofa_process_event(), when handling
the PQI_EVENT_OFA_CANCELED event, the code calls pqi_ctrl_ofa_done() which
blindly unlocks ofa_mutex.

If a cancellation event is received from the controller firmware when no OFA
memory allocation is in progress, or before the worker thread has had a
chance to acquire the mutex, wouldn't unlocking an unheld mutex trigger a
DEBUG_LOCKS_WARN_ON and corrupt the mutex state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D52
