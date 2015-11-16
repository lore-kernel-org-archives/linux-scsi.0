From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH, RESEND] qla2xxx: Fix rwlock recursion
Date: Mon, 16 Nov 2015 15:26:51 -0800
Message-ID: <564A663B.606@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0089.outbound.protection.outlook.com ([157.56.110.89]:60480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751921AbbKPX04 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2015 18:26:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch fixes the following kernel bug:

kernel:BUG: rwlock recursion on CPU#2, insmod/39333, ffff8803e998cb28
kernel: Call Trace:
kernel: [<ffffffff812bce44>] dump_stack+0x48/0x64
kernel: [<ffffffff810a8047>] rwlock_bug+0x67/0x70
kernel: [<ffffffff810a833a>] do_raw_write_lock+0x8a/0xa0
kernel: [<ffffffff815f3033>] _raw_write_lock_irqsave+0x63/0x80
kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx]
kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420 [qla2xxx]
kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx]
kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420 [qla2xxx]
kernel: [<ffffffffa07c964e>] qla2x00_probe_one+0xefe/0x2130 [qla2xxx]
kernel: [<ffffffff8130052c>] local_pci_probe+0x4c/0xa0
kernel: [<ffffffff81300603>] pci_call_probe+0x83/0xa0
kernel: [<ffffffff813008cf>] pci_device_probe+0x7f/0xb0
kernel: [<ffffffff813e2e83>] really_probe+0x133/0x390
kernel: [<ffffffff813e3139>] driver_probe_device+0x59/0xd0
kernel: [<ffffffff813e3251>] __driver_attach+0xa1/0xb0
kernel: [<ffffffff813e0cdd>] bus_for_each_dev+0x8d/0xb0
kernel: [<ffffffff813e28ee>] driver_attach+0x1e/0x20
kernel: [<ffffffff813e2252>] bus_add_driver+0x1d2/0x290
kernel: [<ffffffff813e3970>] driver_register+0x60/0xe0
kernel: [<ffffffff813009e4>] __pci_register_driver+0x64/0x70
kernel: [<ffffffffa04bc1cb>] qla2x00_module_init+0x1cb/0x21b [qla2xxx]
kernel: [<ffffffff8100027d>] do_one_initcall+0xad/0x1c0
kernel: [<ffffffff810e2859>] do_init_module+0x69/0x210
kernel: [<ffffffff810e4e5c>] load_module+0x5cc/0x750
kernel: [<ffffffff810e5162>] SyS_init_module+0x92/0xc0
kernel: [<ffffffff815f37d7>] entry_SYSCALL_64_fastpath+0x12/0x6f

Fixes: 8dfa4b5a9b44 ("qla2xxx: Fix sparse annotation")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reported-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Tested-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: stable <stable@vger.kernel.org> # v4.3+
---
 drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index eb0cc54..b6b4cfd 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -433,7 +433,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
 	if (off_in < QLA82XX_PCI_CRBSPACE)
 		return -1;
 
-	*off_out = (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
+	off_in -= QLA82XX_PCI_CRBSPACE;
 
 	/* Try direct map */
 	m = &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
@@ -443,6 +443,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
 		return 0;
 	}
 	/* Not in direct map, use crb window */
+	*off_out = (void __iomem *)off_in;
 	return 1;
 }
 
-- 
2.1.4

