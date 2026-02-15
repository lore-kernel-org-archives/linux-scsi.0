Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FB222E3E9;
	Sun, 15 Feb 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167821; cv=none; b=KohzczkQ7rhizO33tf/mmkTx6Ynqana7JAJmNqYrQw+pRR56VPtdmlmlp90Sm/OLJ6CDormjsGZ3Ni7EW6YwCyD/XBH17dhy5cP2RDWpGTppPVA/mqwipzAiVGZxiu1XHE+bgdnz5CfPmJRItnrLwbdmz6Jm15KCxv8zzsvQrAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167821; c=relaxed/simple;
	bh=2dPrBu8j0us7nEkgdVmbRUJlm2QdZGJiygdk1zHhv/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPbzFPzkusdA7MGx2heuOeCovWaEcM5ZNbhCnSDtk1JHFugESKZovuRoKb54sd64oLnFCQBTMjIhuZ4nF9DROJyY8Q8DseXR7ME7bGYevu221z6t1xiiSlIvt/hGuh1ZZBcxQrG4VoE5/rXpuCfdKxv8qPuf7WRrb0B7/xUKf5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UP+XQui/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UP+XQui/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD387C4AF09;
	Sun, 15 Feb 2026 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167821;
	bh=2dPrBu8j0us7nEkgdVmbRUJlm2QdZGJiygdk1zHhv/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UP+XQui/Wcfntg4fIG60JHyYKiQy+wfymi/ysZfSQ46cdcg10WtEqKyD1MAFt2CYp
	 pTC8w7eraesatQOYjPPSW7C63zGxQU7+ewg2lvHWfJmC766CY5wc8G4YdACVP6MPft
	 FfTl8hlt964Ib5g1KE03hyxEs3dlYXD2nyEgxiWAu8aaEWd2OZlsMCZCFYflCxBRKS
	 AZUDER/jZXs58qAv1TrARY4rClzXKtYQW/MwvpbEqzmYkU3s1nJiPAq7qDWgnG92+I
	 AsnLqib9dDeUcjHZ6Kpe+obzvtB0kDeaVn6xFTagpVy+HX2vhWbqtYPxKN9WfKswY4
	 yW8NYWMCaheFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	khalid@gonehiking.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] scsi: buslogic: Reduce stack usage
Date: Sun, 15 Feb 2026 10:03:22 -0500
Message-ID: <20260215150333.2150455-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215150333.2150455-1-sashal@kernel.org>
References: <20260215150333.2150455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e17f0d4cc006265dd92129db4bf9da3a2e4a4f66 ]

Some randconfig builds run into excessive stack usage with gcc-14 or
higher, which use __attribute__((cold)) where earlier versions did not do
that:

drivers/scsi/BusLogic.c: In function 'blogic_init':
drivers/scsi/BusLogic.c:2398:1: error: the frame size of 1680 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

The problem is that a lot of code gets inlined into blogic_init() here. Two
functions stick out, but they are a bit different:

 - blogic_init_probeinfo_list() actually uses a few hundred bytes of kernel
   stack, which is a problem in combination with other functions that also
   do. Marking this one as noinline means that the stack slots get get
   reused between function calls

 - blogic_reportconfig() has a few large variables, but whenever it is not
   inlined into its caller, the compiler is actually smart enough to reuse
   stack slots for these automatically, so marking it as noinline saves
   most of the stack space by itself.

The combination of both of these should avoid the problem entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260203163321.2598593-1-arnd@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of commit: "scsi: buslogic: Reduce stack usage"

### Commit Message Analysis

The commit addresses a **build failure** (-Werror=frame-larger-than=)
that occurs with gcc-14 or higher on certain randconfig builds. The
function `blogic_init()` exceeds the 1536-byte stack frame limit
(reaching 1680 bytes) due to excessive inlining by the compiler.

The fix is to mark two functions as `noinline_for_stack`:
1. `blogic_init_probeinfo_list()` - uses significant stack space that
   compounds with other inlined functions
2. `blogic_reportconfig()` - has large local variables that the compiler
   can reuse stack slots for when not inlined

### Code Change Analysis

The change is extremely minimal and surgical:
- **Two functions** have their declarations changed from `static ...
  __init` to `static noinline_for_stack ... __init`
- **Zero logic changes** - no behavior modification whatsoever
- **Zero new code paths** - the functions still do exactly the same
  thing
- The `noinline_for_stack` annotation is a well-established kernel
  mechanism specifically designed for this purpose

### Classification: Build Fix

This is a **build fix** — one of the explicitly allowed exception
categories for stable backports. With gcc-14+, the kernel fails to
compile with `-Werror=frame-larger-than=` enabled in certain
configurations. Build failures prevent users from building the kernel at
all, which is a critical issue.

### Scope and Risk Assessment

- **Lines changed**: Effectively 2 lines (function signature annotations
  only)
- **Files touched**: 1 (drivers/scsi/BusLogic.c)
- **Risk**: Extremely low. `noinline_for_stack` only prevents the
  compiler from inlining these functions. Since they are `__init`
  functions (called once during initialization and then discarded), the
  negligible performance impact of preventing inlining is irrelevant.
- **Regression potential**: Near zero. The functions still execute
  identically; only their calling convention changes slightly.

### User Impact

- Users building kernels with gcc-14 or newer (increasingly common as
  distributions adopt newer toolchains) will hit build failures on
  certain configurations
- The BusLogic SCSI driver is a legacy driver, but it still has users
  and is compiled in many kernel configs
- Build failures are binary — either you can build or you can't — making
  this high impact for affected configurations

### Stability Indicators

- **Author**: Arnd Bergmann — a very well-known and respected kernel
  developer who regularly contributes build fixes and architecture
  improvements
- **Reviewer**: Martin K. Petersen — SCSI subsystem maintainer
- The fix uses `noinline_for_stack`, the standard kernel annotation for
  exactly this type of stack reduction

### Dependency Check

- No dependencies on other commits
- The `noinline_for_stack` macro has been available in the kernel for
  many years
- The BusLogic driver exists in all stable trees

### Conclusion

This is a textbook stable backport candidate:
1. **Build fix** — explicitly allowed in stable rules
2. **Trivially correct** — annotation-only change with no logic
   modification
3. **Zero risk** of regression — functions behave identically
4. **Real impact** — prevents build failure with modern gcc versions
5. **Tiny scope** — 2 annotation additions in a single file
6. **Well-established pattern** — `noinline_for_stack` is the standard
   kernel solution for this class of problem

**YES**

 drivers/scsi/BusLogic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index a86d780d1ba40..026c3e617cb1c 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -920,7 +920,8 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
   a particular probe order.
 */
 
-static void __init blogic_init_probeinfo_list(struct blogic_adapter *adapter)
+static noinline_for_stack void __init
+blogic_init_probeinfo_list(struct blogic_adapter *adapter)
 {
 	/*
 	   If a PCI BIOS is present, interrogate it for MultiMaster and
@@ -1690,7 +1691,8 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
   blogic_reportconfig reports the configuration of Host Adapter.
 */
 
-static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
+static noinline_for_stack bool __init
+blogic_reportconfig(struct blogic_adapter *adapter)
 {
 	unsigned short alltgt_mask = (1 << adapter->maxdev) - 1;
 	unsigned short sync_ok, fast_ok;
-- 
2.51.0

