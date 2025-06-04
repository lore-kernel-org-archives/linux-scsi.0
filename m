Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D688E226CE6;
	Wed,  4 Jun 2025 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999113; cv=none; b=lalMlPbmkPtfMXdR641aVZeBpZKg2d6SM/UboGFCVBWZtgui3MmWhDgt8QXzFK+OASAvSsm9CBO8WoeJ+tZPM+peRtgJPvhEKKc5WIV2yovgYmDCtTjy4BkHYNdwmPd17RFHNMfpQ3jGWGUUtFfitQEpZkmXoLowuReiUTAjqG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999113; c=relaxed/simple;
	bh=TD7uelryibcaY/MeMCvcUy83Ks8WQGFqNblrjeqokIs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DkCljsx5Ltu78wqjOmBuI822kFK6syWSM330xKTj0cxDpxKugYOy4AGIxnARhhHRaUoPrjiHzxO00mp/6KIdPVqKR1fisOsh8ziskTCrF9mOSoVFKxYIiSveJ2l84B66BZBxYAYRtRdQJ9YsMp9kX/wwsLb4ZJdFUv1Ys/sXit0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdShNq7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdShNq7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61F3C4CEEF;
	Wed,  4 Jun 2025 01:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999113;
	bh=TD7uelryibcaY/MeMCvcUy83Ks8WQGFqNblrjeqokIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdShNq7p2slD5tO2L+zhJYnx2x7gwmJz3w45UrTa/EUrbl3QUyCVSN7lexp+EPpRf
	 UZ7qYCi5g02OVdHEENpUBHaioSmrwSQaRL09A5NNK12/IRjyLroUIuoRjm2CyYSlPx
	 chCYdepgPxeF/bcEU0VSnMAxmtKsVi4YT88sjDQ90/Oz6mJTYRXB6GIZPoqQHfsrW+
	 dWpKRHm9HtLbqweWtU8zCb7Hs/4VaMYvpH4turjpGnstUiWyUvBUfwgl+EZttD6pRE
	 wvBzJlSglFXJp90hB7FkVK9qp6Kpd4p8Mu8y71nJMnl93iS9IsPhsqSouoQf8EDCo/
	 Io7cltpMwZnLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Wagner <wagi@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 40/46] scsi: lpfc: Use memcpy() for BIOS version
Date: Tue,  3 Jun 2025 21:03:58 -0400
Message-Id: <20250604010404.5109-40-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010404.5109-1-sashal@kernel.org>
References: <20250604010404.5109-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit ae82eaf4aeea060bb736c3e20c0568b67c701d7d ]

The strlcat() with FORTIFY support is triggering a panic because it
thinks the target buffer will overflow although the correct target
buffer size is passed in.

Anyway, instead of memset() with 0 followed by a strlcat(), just use
memcpy() and ensure that the resulting buffer is NULL terminated.

BIOSVersion is only used for the lpfc_printf_log() which expects a
properly terminated string.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Link: https://lore.kernel.org/r/20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Let me understand the actual problem by examining the function more
carefully. Based on the commit message, this is about a FORTIFY panic
when using strlcat(): **YES** This commit should be backported to stable
kernel trees. Here's my extensive analysis: ## Bug Analysis **Root
Cause:** The commit fixes a kernel panic triggered by FORTIFY_SOURCE
when using `strlcat()`. The FORTIFY infrastructure incorrectly detected
a potential buffer overflow in the BIOS version string handling code.
**The Problem Code:** ```c memset(phba->BIOSVersion, 0,
sizeof(phba->BIOSVersion)); strlcat(phba->BIOSVersion, (char
*)cntl_attr->bios_ver_str, sizeof(phba->BIOSVersion)); ``` **The Fix:**
```c memcpy(phba->BIOSVersion, cntl_attr->bios_ver_str,
sizeof(phba->BIOSVersion)); phba->BIOSVersion[sizeof(phba->BIOSVersion)
- 1] = '\0'; ``` ## Technical Details 1. **Buffer Sizes:** `BIOSVersion`
is a 16-byte character array (`char BIOSVersion[16]` in lpfc.h:1267),
while `bios_ver_str` is a 32-byte array (`uint32_t bios_ver_str[8]` in
lpfc_hw4.h:3798). 2. **FORTIFY Issue:** The `strlcat()` function with
FORTIFY enabled was triggering a false positive, causing kernel panics
when it incorrectly calculated potential overflow conditions. 3. **Safe
Solution:** The fix uses `memcpy()` for the exact buffer size and
explicitly null-terminates the string, which is simpler and avoids the
FORTIFY false positive. ## Backport Criteria Analysis ✅ **Fixes
Important Bug:** This resolves kernel panics in production systems with
FORTIFY enabled ✅ **Small & Contained:** Only 3 lines changed in a
single function ✅ **Minimal Risk:** The change is functionally
equivalent but safer ✅ **No Architectural Changes:** Simple string
handling improvement ✅ **Clear Side Effects:** No behavioral changes
beyond fixing the panic ✅ **Critical Subsystem:** SCSI driver stability
is important for storage ## Comparison with Similar Commits This closely
resembles **Similar Commit #2** (marked YES for backport) which fixed an
overflow build issue with FORTIFY. Both commits: - Address FORTIFY-
related compilation/runtime issues - Make minimal, safe code changes -
Fix real problems affecting users - Have low regression risk ## Risk
Assessment **Low Risk:** The change maintains identical functionality
while eliminating the false positive. Both code paths copy BIOS version
data into a 16-byte buffer and ensure null termination. The `memcpy()`
approach is actually more predictable than `strlcat()` with an empty
target buffer. ## Conclusion This commit fixes a real kernel panic issue
that affects users running kernels with FORTIFY_SOURCE enabled. The fix
is minimal, safe, and follows stable tree guidelines perfectly. It
should definitely be backported to prevent production systems from
experiencing these panics.

 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1e04b6fc127af..d5e21e74888a7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6031,9 +6031,9 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
 	phba->sli4_hba.flash_id = bf_get(lpfc_cntl_attr_flash_id, cntl_attr);
 	phba->sli4_hba.asic_rev = bf_get(lpfc_cntl_attr_asic_rev, cntl_attr);
 
-	memset(phba->BIOSVersion, 0, sizeof(phba->BIOSVersion));
-	strlcat(phba->BIOSVersion, (char *)cntl_attr->bios_ver_str,
+	memcpy(phba->BIOSVersion, cntl_attr->bios_ver_str,
 		sizeof(phba->BIOSVersion));
+	phba->BIOSVersion[sizeof(phba->BIOSVersion) - 1] = '\0';
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"3086 lnk_type:%d, lnk_numb:%d, bios_ver:%s, "
-- 
2.39.5

