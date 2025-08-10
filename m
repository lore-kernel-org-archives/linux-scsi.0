Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A848F40;
	Sun, 10 Aug 2025 00:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785278; cv=none; b=dB1gYK9jR2+MdUmKsk9OliTA4rHJJ1nS4VvPKM96DPFuD4opa1BxlKYLp0fdRekbPMIMaeVdzAJnmx/VvvTgRWGNxQjoc9IfhqD7L0pvVrWUz1JS7n5rvEyRoVsMRf4uNXiBCCGqX0y5wwfInj0QB9qSLW34t7L/POji1eGT/tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785278; c=relaxed/simple;
	bh=jF5+vpSw1piGFAaLgeRuqY58Lkc7w1syTJvqiPUdCr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GDkr7qH+kHky1lPkQb8IuARiXk2uQaLTYOzMxIwz7eJEEXW0E7BJNx7FKF10C4w52ErTV4bQ4IR+yIXbrDcxHC/PQSH/fZt+9Y3yHF3/CE/49P3bOED27V1aPZaGDwn5qWZFxLI65aHsxJ7QoEs57Oax7zs6tXSSACHHktu+8l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRS+qyVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRS+qyVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15C0C4CEF1;
	Sun, 10 Aug 2025 00:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785277;
	bh=jF5+vpSw1piGFAaLgeRuqY58Lkc7w1syTJvqiPUdCr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRS+qyVDE1pxq3VSNcoEz/u9x2woqXgw6BIQUo/gIgOZsCLW/2RAwaFOpEK0ip91A
	 u01y6tB6Bp27bQIHnoVgtqj/r1aeCf1Rf6ivu5QjBsF6nVteoNnaFsNlpQsjztPuZR
	 uNG3p/k0mgAXJhwLT580tcO1Xq3VlSWVNucFFRzD6ucoQ5mu4DrZj3MWccqKy3y9+e
	 GTNpbACPmucKTThkUluBiOqatCp7QF6MiFoANYYbxelrHwBctTu4TmcttdZ5g2yUSq
	 l1wr5r6uDIQEgZyXmD0HHurXJ74KPLJmPQqMA1hmCc7ub/FsXzZoTuwWqYpRkNoudv
	 C0xrtJj57Bj+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	aacraid@microsemi.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
Date: Sat,  9 Aug 2025 20:20:53 -0400
Message-Id: <20250810002104.1545396-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit dafeaf2c03e71255438ffe5a341d94d180e6c88e ]

When PCI_IRQ_AFFINITY is set for calling pci_alloc_irq_vectors(), it
means interrupts are spread around the available CPUs. It also means that
the interrupts become managed, which means that an interrupt is shutdown
when all the CPUs in the interrupt affinity mask go offline.

Using managed interrupts in this way means that we should ensure that
completions should not occur on HW queues where the associated interrupt
is shutdown. This is typically achieved by ensuring only CPUs which are
online can generate IO completion traffic to the HW queue which they are
mapped to (so that they can also serve completion interrupts for that HW
queue).

The problem in the driver is that a CPU can generate completions to a HW
queue whose interrupt may be shutdown, as the CPUs in the HW queue
interrupt affinity mask may be offline. This can cause IOs to never
complete and hang the system. The driver maintains its own CPU <-> HW
queue mapping for submissions, see aac_fib_vector_assign(), but this does
not reflect the CPU <-> HW queue interrupt affinity mapping.

Commit 9dc704dcc09e ("scsi: aacraid: Reply queue mapping to CPUs based on
IRQ affinity") tried to remedy this issue may mapping CPUs properly to HW
queue interrupts. However this was later reverted in commit c5becf57dd56
("Revert "scsi: aacraid: Reply queue mapping to CPUs based on IRQ
affinity") - it seems that there were other reports of hangs. I guess
that this was due to some implementation issue in the original commit or
maybe a HW issue.

Fix the very original hang by just not using managed interrupts by not
setting PCI_IRQ_AFFINITY.  In this way, all CPUs will be in each HW queue
affinity mask, so should not create completion problems if any CPUs go
offline.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20250715111535.499853-1-john.g.garry@oracle.com
Closes: https://lore.kernel.org/linux-scsi/20250618192427.3845724-1-jmeneghi@redhat.com/
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here is my determination:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a Critical Bug**: The commit fixes a system hang issue that
   occurs when CPUs go offline. The code change shows it removes
   `PCI_IRQ_AFFINITY` flag from `pci_alloc_irq_vectors()` call (line 485
   changing from `PCI_IRQ_MSIX | PCI_IRQ_AFFINITY` to just
   `PCI_IRQ_MSIX`). This prevents managed interrupts from being shut
   down when CPUs go offline, which was causing I/O operations to never
   complete and hang the system.

2. **Long-Standing Issue with History**: The commit message reveals this
   is addressing a long-standing problem that has been attempted to be
   fixed before:
   - Commit 9dc704dcc09e tried to fix it by mapping CPUs properly to HW
     queue interrupts
   - That fix was reverted in commit c5becf57dd56 due to other hang
     reports
   - The revert commit (c5becf57dd56) was even marked with `Cc:
     <stable@vger.kernel.org>`, indicating the severity of the issue

3. **Small and Contained Change**: The actual code change is minimal -
   just removing the `PCI_IRQ_AFFINITY` flag from a single function
   call. This is a one-line change that doesn't introduce new features
   or architectural changes.

4. **Well-Tested Fix**: The commit has both "Reviewed-by" and "Tested-
   by" tags from John Meneghini, indicating it has been properly tested
   and validated.

5. **No Side Effects Beyond the Fix**: The change simply reverts to non-
   managed interrupts, allowing all CPUs to be in each HW queue affinity
   mask. This is a conservative approach that avoids the complexity of
   trying to properly coordinate CPU-to-queue mappings with interrupt
   affinities.

6. **Affects Production Systems**: The linked bug report
   (https://lore.kernel.org/linux-
   scsi/20250618192427.3845724-1-jmeneghi@redhat.com/) and the previous
   kernel bugzilla entry (#217599) indicate this affects real production
   systems experiencing hangs.

7. **Driver-Specific Fix**: The change is confined to the aacraid driver
   subsystem and doesn't affect other kernel components, minimizing the
   risk of regression in other areas.

The fix follows stable tree rules perfectly: it fixes an important bug
(system hangs), is minimal in scope (one-line change), has low
regression risk (reverting to simpler interrupt handling), and is
confined to a specific driver subsystem.

 drivers/scsi/aacraid/comminit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 28cf18955a08..726c8531b7d3 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -481,8 +481,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
 		min_msix = 2;
 		i = pci_alloc_irq_vectors(dev->pdev,
-					  min_msix, msi_count,
-					  PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+					  min_msix, msi_count, PCI_IRQ_MSIX);
 		if (i > 0) {
 			dev->msi_enabled = 1;
 			msi_count = i;
-- 
2.39.5

