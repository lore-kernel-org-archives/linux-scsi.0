From: <kgudipat@brocade.com>
Subject: [PATCH 06/10] bfa: Fix to process mbox interrupts only if interrupts are enabled in INTx mode.
Date: Wed, 22 Aug 2012 19:52:18 -0700
Message-ID: <1345690338-21429-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:59106 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756242Ab2HWCwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 22:52:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Made changes to process mbox and error interrupts only if interrupts are
	  enabled, when running in INTx mode.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c    |    9 ++++++++-
 drivers/scsi/bfa/bfa_modules.h |    1 +
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index a4129c9..b7c326f 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -775,7 +775,8 @@ bfa_intx(struct bfa_s *bfa)
 	if (!intr)
 		return BFA_TRUE;
 
-	bfa_msix_lpu_err(bfa, intr);
+	if (bfa->intr_enabled)
+		bfa_msix_lpu_err(bfa, intr);
 
 	return BFA_TRUE;
 }
@@ -803,11 +804,17 @@ bfa_isr_enable(struct bfa_s *bfa)
 	writel(~umsk, bfa->iocfc.bfa_regs.intr_mask);
 	bfa->iocfc.intr_mask = ~umsk;
 	bfa_isr_mode_set(bfa, bfa->msix.nvecs != 0);
+
+	/*
+	 * Set the flag indicating successful enabling of interrupts
+	 */
+	bfa->intr_enabled = BFA_TRUE;
 }
 
 void
 bfa_isr_disable(struct bfa_s *bfa)
 {
+	bfa->intr_enabled = BFA_FALSE;
 	bfa_isr_mode_set(bfa, BFA_FALSE);
 	writel(-1L, bfa->iocfc.bfa_regs.intr_mask);
 	bfa_msix_uninstall(bfa);
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 2d36e48..189fff7 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -121,6 +121,7 @@ struct bfa_s {
 	bfa_boolean_t		fcs;		/*  FCS is attached to BFA */
 	struct bfa_msix_s	msix;
 	int			bfa_aen_seq;
+	bfa_boolean_t		intr_enabled;	/*  Status of interrupts */
 };
 
 extern bfa_boolean_t bfa_auto_recover;
-- 
1.7.3.rc1

