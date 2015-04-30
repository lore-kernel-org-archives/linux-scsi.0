From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] qla2xxx: prevent board_disable from running during EEH
Date: Thu, 30 Apr 2015 09:13:05 -0300
Message-ID: <1430395985-17101-1-git-send-email-cascardo@linux.vnet.ibm.com>
Reply-To: Thadeu Lima de Souza Cascardo <cascardo@debian.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:55929 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbbD3MNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 08:13:42 -0400
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <cascardo@linux.vnet.ibm.com>;
	Thu, 30 Apr 2015 09:13:40 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com, qla2xxx-upstream@qlogic.com, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, cascardo@debian.org, mauricfo@linux.vnet.ibm.com

Commit f3ddac1918fe963bcbf8d407a3a3c0881b47248b ("[SCSI] qla2xxx:
Disable adapter when we encounter a PCI disconnect.") has introduced a
code that disables the board, releasing some resources, when reading
0xffffffff.

In case this happens when there is an EEH, this read will trigger EEH
detection and set PCI channel offline. EEH will be able to recover the
card from this state by doing a reset, so it's a better option than
simply disabling the card.

Since eeh_check_failure will mark the channel as offline before
returning the read value, in case there really was an EEH, we can simply
check for pci_channel_offline, preventing the board_disable code from
running if it's true.

Without this patch, EEH code will try to access those same resources
that board_disable will try to free. This race can cause EEH recovery to
fail.

[  504.370577] EEH: Notify device driver to resume
[  504.370580] qla2xxx [0001:07:00.0]-9002:2: The device failed to resume I/O from slot/link_reset.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: <cascardo@debian.org>
Cc: <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a04a1b1..8132926 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -116,7 +116,7 @@ bool
 qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
 {
 	/* Check for PCI disconnection */
-	if (reg == 0xffffffff) {
+	if (reg == 0xffffffff && !pci_channel_offline(vha->hw->pdev)) {
 		if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags) &&
 		    !test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags) &&
 		    !test_bit(PFLG_DRIVER_PROBING, &vha->pci_flags)) {
-- 
1.7.10.4

