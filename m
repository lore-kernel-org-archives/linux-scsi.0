Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4B3221DAC;
	Tue, 30 Dec 2025 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767100996; cv=none; b=Uh70vrMOJJDfAIGF4vH73YvvtRNoTph00d0HYg24TPiYgj/iMp+N72LxkJqckD8o7hgG9+w2ESZkCSxPKPh+kEnu8I+DSBr63oaLBuHcWUhBGeKZnQYyRA65VeSvB38MexAKBIA8Fiu07Z1wob3TkCJUMdXc6yDQKxxICTZ3S8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767100996; c=relaxed/simple;
	bh=n0MxktSwBtNOrmVeS/82OoBx9VViwbfvZ/KkkHjHR7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZ0udBTtLFuipBz081DtD6T5kS4csREmL0UctIeiQZeMiCtEqxdqX8cIV0xv33eTZ0O5purnZ7VV1fIKpe3HorHnq3MRvPt79Qrc/dlA2CosEv8XVsS1EIMI75afd2JxIkaUG59xULS/ckwOrRnLEVLWccmlYMmrj2EFj2n7Kr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNLukpD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNLukpD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A42C116D0;
	Tue, 30 Dec 2025 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767100996;
	bh=n0MxktSwBtNOrmVeS/82OoBx9VViwbfvZ/KkkHjHR7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNLukpD6fmJ9bqbAhZsPUmyrcFkTurzxPfFpoihG4DL7LsJ6PqaqwoOpHsP0ZJUN+
	 5HwzNkQ5kP9xVzFB07XTSx1RLaB9eLWHFdn5F4PDKGeVniy+iDsNAXl8JFkDy4DFjU
	 cVdvc1A3v1ayicQ9buNbGa6Gfp1L2qv4LGODU1B3n6y38YXKzZjJr1vMTrxy/C+n0e
	 sSFmxPYdnTQWbyjOv5B6uxgremMWPdo/tY+1rWwtEElZyZ6cncF4ShebC3ojMQP09H
	 nGCD2hyjCXN/HNhbt9THqyQn15C70e98FSo0a3QgVihmcPdlwjPgWennT/csDmpRZ1
	 7AmaLPWBfcDrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Michal=20R=C3=A1bek?= <mrabek@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	Changhui Zhong <czhong@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: sg: Fix occasional bogus elapsed time that exceeds timeout
Date: Tue, 30 Dec 2025 08:22:59 -0500
Message-ID: <20251230132303.2194838-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251230132303.2194838-1-sashal@kernel.org>
References: <20251230132303.2194838-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Transfer-Encoding: 8bit

From: Michal Rábek <mrabek@redhat.com>

[ Upstream commit 0e1677654259a2f3ccf728de1edde922a3c4ba57 ]

A race condition was found in sg_proc_debug_helper(). It was observed on
a system using an IBM LTO-9 SAS Tape Drive (ULTRIUM-TD9) and monitoring
/proc/scsi/sg/debug every second. A very large elapsed time would
sometimes appear. This is caused by two race conditions.

We reproduced the issue with an IBM ULTRIUM-HH9 tape drive on an x86_64
architecture. A patched kernel was built, and the race condition could
not be observed anymore after the application of this patch. A
reproducer C program utilising the scsi_debug module was also built by
Changhui Zhong and can be viewed here:

https://github.com/MichaelRabek/linux-tests/blob/master/drivers/scsi/sg/sg_race_trigger.c

The first race happens between the reading of hp->duration in
sg_proc_debug_helper() and request completion in sg_rq_end_io().  The
hp->duration member variable may hold either of two types of
information:

 #1 - The start time of the request. This value is present while
      the request is not yet finished.

 #2 - The total execution time of the request (end_time - start_time).

If sg_proc_debug_helper() executes *after* the value of hp->duration was
changed from #1 to #2, but *before* srp->done is set to 1 in
sg_rq_end_io(), a fresh timestamp is taken in the else branch, and the
elapsed time (value type #2) is subtracted from a timestamp, which
cannot yield a valid elapsed time (which is a type #2 value as well).

To fix this issue, the value of hp->duration must change under the
protection of the sfp->rq_list_lock in sg_rq_end_io().  Since
sg_proc_debug_helper() takes this read lock, the change to srp->done and
srp->header.duration will happen atomically from the perspective of
sg_proc_debug_helper() and the race condition is thus eliminated.

The second race condition happens between sg_proc_debug_helper() and
sg_new_write(). Even though hp->duration is set to the current time
stamp in sg_add_request() under the write lock's protection, it gets
overwritten by a call to get_sg_io_hdr(), which calls copy_from_user()
to copy struct sg_io_hdr from userspace into kernel space. hp->duration
is set to the start time again in sg_common_write(). If
sg_proc_debug_helper() is called between these two calls, an arbitrary
value set by userspace (usually zero) is used to compute the elapsed
time.

To fix this issue, hp->duration must be set to the current timestamp
again after get_sg_io_hdr() returns successfully. A small race window
still exists between get_sg_io_hdr() and setting hp->duration, but this
window is only a few instructions wide and does not result in observable
issues in practice, as confirmed by testing.

Additionally, we fix the format specifier from %d to %u for printing
unsigned int values in sg_proc_debug_helper().

Signed-off-by: Michal Rábek <mrabek@redhat.com>
Suggested-by: Tomas Henzl <thenzl@redhat.com>
Tested-by: Changhui Zhong <czhong@redhat.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Link: https://patch.msgid.link/20251212160900.64924-1-mrabek@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of commit: "scsi: sg: Fix occasional bogus elapsed time that
exceeds timeout"

### 1. COMMIT MESSAGE ANALYSIS

The commit clearly describes two race conditions in the SCSI sg driver:
- **Race 1:** Between reading `hp->duration` in `sg_proc_debug_helper()`
  and request completion in `sg_rq_end_io()` - duration gets updated
  before `srp->done` is set, causing incorrect timestamp subtraction
- **Race 2:** Between `sg_proc_debug_helper()` and `sg_new_write()` -
  userspace can set arbitrary values for `hp->duration` via
  `copy_from_user()` before the kernel resets it

The bug was observed on real hardware (IBM LTO-9 SAS Tape Drive).
There's a reproducer available and the fix has been tested.

**Quality indicators:**
- `Tested-by:` tag present
- `Reviewed-by:` from 3 different reviewers
- Link to reproducer code on GitHub
- Detailed technical explanation

### 2. CODE CHANGE ANALYSIS

**Change 1 - `sg_new_write()` (~line 734):**
Adds `hp->duration = jiffies_to_msecs(jiffies);` immediately after
`get_sg_io_hdr()` returns. This fixes race #2 by ensuring userspace-
supplied values are overwritten with the correct timestamp right away.

**Change 2 - `sg_common_write()` (~line 820):**
Removes the `hp->duration = jiffies_to_msecs(jiffies);` line since it's
now set earlier in `sg_new_write()`.

**Change 3 - `sg_rq_end_io()` (~lines 1341-1392):**
Moves the duration calculation **inside** the write lock:
```c
write_lock_irqsave(&sfp->rq_list_lock, iflags);
// ...
srp->done = done;
ms = jiffies_to_msecs(jiffies);
srp->header.duration = (ms > srp->header.duration) ? (ms -
srp->header.duration) : 0;
write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
```
This makes `srp->done` and `srp->header.duration` updates atomic from
`sg_proc_debug_helper()`'s perspective.

**Change 4 - `sg_proc_debug_helper()` (~lines 2550-2570):**
- Uses `READ_ONCE(hp->duration)` for proper memory ordering
- Fixes format specifier `%d` to `%u` for unsigned int values
- Adds local `duration` variable to capture the value atomically

### 3. CLASSIFICATION

- **Type:** Bug fix (race condition)
- **Impact:** Incorrect elapsed time values displayed in
  `/proc/scsi/sg/debug`
- **Not a security issue**, not data corruption, not a crash

### 4. SCOPE AND RISK ASSESSMENT

- **Files touched:** 1 (`drivers/scsi/sg.c`)
- **Lines changed:** Moderate - mostly code movement and reordering
- **Complexity:** Low - uses existing locking mechanisms, no new logic
- **Risk:** LOW - the fix applies proper locking discipline; no
  fundamental behavioral change

### 5. USER IMPACT

- **Affected users:** Enterprise users with SCSI tape drives (backup
  systems), users of sg interface for direct SCSI access
- **Severity:** Medium - incorrect diagnostic information can mislead
  troubleshooting, but not a crash or data loss
- **Reproducibility:** Confirmed reproducible with reproducer tool

### 6. STABILITY INDICATORS

- 3 `Reviewed-by:` tags (Ewan D. Milne, John Meneghini, Tomas Henzl)
- 1 `Tested-by:` tag
- Authors from Red Hat (enterprise relevance)
- Reproducer publicly available

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- Uses `READ_ONCE()` - available in all stable kernels
- `rq_list_lock` and related structures are long-standing
- The sg driver is mature and present in all stable trees

### STABLE KERNEL CRITERIA EVALUATION

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Yes - proper locking discipline |
| Fixes real bug | ✅ Yes - documented race condition with reproducer |
| Tested | ✅ Yes - Tested-by tag present |
| Small and contained | ✅ Yes - single file, focused changes |
| No new features | ✅ Yes - only fixes race |
| No new APIs | ✅ Yes |

### RISK VS BENEFIT

**Benefits:**
- Fixes race conditions causing incorrect timing values in /proc
- Enterprise relevance (tape backup systems)
- Well-tested and reviewed

**Risks:**
- Minimal - code movement under existing locks
- No functional changes to I/O path

**Concerns:**
- The bug is diagnostic in nature (incorrect display) rather than
  crash/corruption
- However, the fix is safe and meets all stable criteria

### CONCLUSION

This commit fixes two real race conditions in the SCSI sg driver that
have been observed in production environments with tape drives. The fix
is surgical, well-tested, thoroughly reviewed (3 reviewers), and follows
proper locking discipline. While the bug manifests as incorrect timing
information in /proc rather than a crash, it affects enterprise users
relying on accurate diagnostic information. The fix has low regression
risk and cleanly applies to the long-standing sg driver code.

**YES**

 drivers/scsi/sg.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b3af9b78fa12..57fba34832ad 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -731,6 +731,8 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
+	hp->duration = jiffies_to_msecs(jiffies);
+
 	if (hp->interface_id != 'S') {
 		sg_remove_request(sfp, srp);
 		return -ENOSYS;
@@ -815,7 +817,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		return -ENODEV;
 	}
 
-	hp->duration = jiffies_to_msecs(jiffies);
 	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
 	    (SG_FLAG_Q_AT_TAIL & hp->flags))
 		at_head = 0;
@@ -1338,9 +1339,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 				      "sg_cmd_done: pack_id=%d, res=0x%x\n",
 				      srp->header.pack_id, result));
 	srp->header.resid = resid;
-	ms = jiffies_to_msecs(jiffies);
-	srp->header.duration = (ms > srp->header.duration) ?
-				(ms - srp->header.duration) : 0;
 	if (0 != result) {
 		struct scsi_sense_hdr sshdr;
 
@@ -1389,6 +1387,9 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			done = 0;
 	}
 	srp->done = done;
+	ms = jiffies_to_msecs(jiffies);
+	srp->header.duration = (ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (likely(done)) {
@@ -2533,6 +2534,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 	const sg_io_hdr_t *hp;
 	const char * cp;
 	unsigned int ms;
+	unsigned int duration;
 
 	k = 0;
 	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
@@ -2570,13 +2572,17 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
-				seq_printf(s, " dur=%d", hp->duration);
+				seq_printf(s, " dur=%u", hp->duration);
 			else {
 				ms = jiffies_to_msecs(jiffies);
-				seq_printf(s, " t_o/elap=%d/%d",
+				duration = READ_ONCE(hp->duration);
+				if (duration)
+					duration = (ms > duration ?
+						    ms - duration : 0);
+				seq_printf(s, " t_o/elap=%u/%u",
 					(new_interface ? hp->timeout :
 						  jiffies_to_msecs(fp->timeout)),
-					(ms > hp->duration ? ms - hp->duration : 0));
+					duration);
 			}
 			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
-- 
2.51.0

