From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: fix EEH recovery
Date: Wed, 25 Nov 2009 20:13:43 -0200
Message-ID: <1259187223.4938.45.camel@zeppelin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:36639 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934655AbZKYWNl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2009 17:13:41 -0500
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp03.br.ibm.com (8.14.3/8.13.1) with ESMTP id nAPL7BXs020577
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2009 19:07:11 -0200
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nAPMDk5O3522644
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2009 19:13:46 -0300
Received: from d24av01.br.ibm.com (d24av01 [127.0.0.1])
	by d24av01.br.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nAPLLAcA012598
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2009 19:21:10 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Brian King <brking@linux.vnet.ibm.com>, Wayne Boyer <wayneb@linux.vnet.ibm.com>

Hi,

After commits c82f63e411f1b58427c103bd95af2863b1c96dd1 (PCI: check saved
state before restore) and 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff (PCI:
Clear saved_state after the state has been restored) PCI drivers are
prevented from restoring the device standard configuration registers
twice in a row. These changes introduced a regression on ipr EEH
recovery.

The ipr device driver saves the PCI state only during the device probe
and restores it on ipr_reset_restore_cfg_space() during IOA resets. This
behavior is causing the EEH recovery to fail after the second error
detected, since the registers are not being restored.

One possible solution would be saving the registers after restoring
them. The problem with this approach is that while recovering from an
EEH error if pci_save_state() results in an EEH error, the adapter/slot
will be reset, and end up back in ipr_reset_restore_cfg_space(), but it
won't have a valid saved state to restore, so pci_restore_state() will
fail.

The following patch introduces a workaround for this problem, hacking
around the PCI API by setting pdev->state_saved = true before we do the
restore. It fixes the EEH regression and prevents that we hit another
EEH error during EEH recovery.


Thanks,
Kleber



Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 76d294f..c3ff9a6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6516,6 +6516,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 	int rc;
 
 	ENTER;
+	ioa_cfg->pdev->state_saved = true;
 	rc = pci_restore_state(ioa_cfg->pdev);
 
 	if (rc != PCIBIOS_SUCCESSFUL) {
-- 


-- 
Kleber S. Souza
IBM Linux Technology Center

