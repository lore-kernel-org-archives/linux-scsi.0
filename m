Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF1444CF56;
	Tue, 10 Mar 2026 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133335; cv=none; b=Gh4g/WcGeRdIUr3Li6RDmV0W/t5TtuUJUSpKUKntfIOibl8hAfo3NZHR2vsHhuLrJ2q7uovv1CJCDTEjPiIziJmh7FLLjNGCb1zpzRqliCyburdRcfcm8mYoO49LJeSp086jTeYvxSDi+omXIVR1sH2wf9SBU+81AH7kcWlZyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133335; c=relaxed/simple;
	bh=1htoEh3NDCqqv9KOFybHKUKc4qxnVoAnCxDH0gfr1wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ0qfr27cQ+Z/V+h0sq0bpY8+pKF0V20SYGee6faFhyDPaaI7DteYL4muZKQ8f7yr/G62yqiu2mgU0NDbM6MfPZX1O7baoX1WqjDU1z5goyfn9MGzFfp6HQp5makO9pbO8iFRUxb+DS2HHsAwF25HKXPC7Cj/6Kg6eEUn+JROXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4JnNPOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4JnNPOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5EBC19423;
	Tue, 10 Mar 2026 09:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133334;
	bh=1htoEh3NDCqqv9KOFybHKUKc4qxnVoAnCxDH0gfr1wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4JnNPOogqVLFIJQUnxGNniiLBaT1AZ9TnQD7RkwW0m0WfZLeiwrMRBdf6kPLY4OK
	 WNU5LrsN1NPA7j1ZSOuhlanOIleAB6TcSGxtoYLkjzL+XtoGnSmNFtcZZnYhgK2a4V
	 axOEGvwkeUD7qfHwRR4JoIVJ/QlKiwHOxHgNeAcvu7ShtffIGkzQ9lKBPevPK89km2
	 pJ3k6wKmR4ePtD8tCP9ROBP+MQGwu32XwzW2yQ41XKZyKbM0HZrfpX0CmDmHb1+4AN
	 IQ78fi2ShmszH/nQ6GceCnPVCjzEvqmmUZe2cU0VsCeaklvTVgwX12KCUVgcBxilYL
	 sAdJEeHIQEK2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] scsi: mpi3mr: Clear reset history on ready and recheck state after timeout
Date: Tue, 10 Mar 2026 05:01:19 -0400
Message-ID: <20260310090145.2709021-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit dbd53975ed4132d161b6a97ebe785a262380182d ]

The driver retains reset history even after the IOC has successfully
reached the READY state. That leaves stale reset information active during
normal operation and can mislead recovery and diagnostics.  In addition, if
the IOC becomes READY just as the ready timeout loop exits, the driver
still follows the failure path and may retry or report failure incorrectly.

Clear reset history once READY is confirmed so driver state matches actual
IOC status. After the timeout loop, recheck the IOC state and treat READY
as success instead of failing.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://patch.msgid.link/20260225082622.82588-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear picture of the changes. Let me finalize my analysis.

## Analysis

### What the commit does

This commit makes two small changes to `mpi3mr_bring_ioc_ready()` in the
mpi3mr SCSI driver:

1. **Clears reset history on READY** (line 1533): When the IOC
   transitions to READY state inside the polling loop, it now calls
   `mpi3mr_clear_reset_history()` before returning success. Without
   this, stale reset history bits remain set, which can confuse
   subsequent recovery logic that checks
   `MPI3_SYSIF_IOC_STATUS_RESET_HISTORY`.

2. **Rechecks state after timeout** (lines 1553-1560): After the
   `do...while` timeout loop exits, the code does one final check to see
   if the IOC became READY right at the boundary. Previously, if the IOC
   transitioned to READY during the last `msleep(100)` (after the
   elapsed time already exceeded the timeout), the driver would fall
   through to `out_failed` and potentially retry unnecessarily or report
   failure.

### Bug assessment

**Race at timeout boundary (bug #2):** This is a real timing bug. The
loop checks `elapsed_time_sec < mrioc->ready_timeout` *after*
`msleep(100)`. If the IOC becomes READY during that last sleep,
`elapsed_time_sec` has already exceeded the timeout, so the loop exits.
Without the post-loop recheck, the driver goes to `out_failed`, which
triggers up to 2 retries (unnecessary soft resets) or reports
initialization failure. This can cause:
- Unnecessary controller resets during probe/resume
- Spurious initialization failures if retries are exhausted
- I/O failures during reset recovery (since `mpi3mr_reinit_ioc` fails)

**Stale reset history (bug #1):** If reset history is not cleared when
the IOC reaches READY, subsequent iterations of the loop in future calls
to this function will see `MPI3_SYSIF_IOC_STATUS_RESET_HISTORY` set and
jump to `out_failed` (line 1537-1540), causing spurious failure.

### Stable kernel criteria

- **Fixes a real bug:** Yes - timing race causes false initialization
  failures; stale state causes spurious failures in subsequent
  operations.
- **Obviously correct:** Yes - `mpi3mr_clear_reset_history()` is already
  called elsewhere in the same function (at line 1510 after soft reset).
  The post-timeout recheck follows the same pattern as the in-loop
  check.
- **Small and contained:** Yes - 10 lines added, single file, single
  function.
- **No new features:** Correct - pure bug fix.
- **Risk:** Very low. The added code only adds a success path where
  there was none (post-timeout READY check) and clears a status bit that
  should be cleared (reset history). No existing success/failure paths
  are altered.

### Impact

This function is called on three critical paths: PCI probe, controller
reset recovery, and system resume. A false failure here means the SCSI
controller doesn't initialize, which means loss of access to all
attached storage devices. This affects real users with Broadcom MPI3
(SAS/NVMe) storage controllers.

### Verification

- Confirmed `mpi3mr_clear_reset_history` is a trivial inline that clears
  the RESET_HISTORY bit in IOC status register (lines 1256-1263).
- Confirmed the function is called from probe (`mpi3mr_init_ioc`), reset
  (`mpi3mr_reinit_ioc`), and resume paths.
- Confirmed that `mpi3mr_clear_reset_history` is already used elsewhere
  in the same function, so the pattern is established.
- Confirmed the timeout race: the `do...while` loop exits when
  `elapsed_time_sec >= ready_timeout`, but the IOC could have become
  READY during the final `msleep(100)`, which is not checked without
  this patch.
- Confirmed that falling through to `out_failed` triggers retries (up to
  2) or returns failure (line 1564-1577).
- The commit is authored by Broadcom (the hardware vendor), accepted by
  the SCSI maintainer Martin Petersen, indicating domain expertise.
- Could NOT verify specific user reports of this race triggering in the
  field (commit message implies it was found via code
  review/diagnostics), but the race window is real and the consequences
  are severe.

**YES**

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8c4bb7169a87c..6d36575997871 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1530,6 +1530,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			ioc_info(mrioc,
 			    "successfully transitioned to %s state\n",
 			    mpi3mr_iocstate_name(ioc_state));
+			mpi3mr_clear_reset_history(mrioc);
 			return 0;
 		}
 		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
@@ -1549,6 +1550,15 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 		elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
 	} while (elapsed_time_sec < mrioc->ready_timeout);
 
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state == MRIOC_STATE_READY) {
+		ioc_info(mrioc,
+		    "successfully transitioned to %s state after %llu seconds\n",
+		    mpi3mr_iocstate_name(ioc_state), elapsed_time_sec);
+		mpi3mr_clear_reset_history(mrioc);
+		return 0;
+	}
+
 out_failed:
 	elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
 	if ((retry < 2) && (elapsed_time_sec < (mrioc->ready_timeout - 60))) {
-- 
2.51.0

