From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] bnx2fc: fix incorrect DMA memory mapping in bnx2fc_map_sg()
Date: Mon,  4 Aug 2014 10:20:13 +0200
Message-ID: <1407140413-4561-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaHDIVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2014 04:21:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: eddie.wai@broadcom.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@lst.de

In the bnx2fc_map_sg() function, the original behaviour is to
allocate the DMA memory by directly calling dma_map_sg()
instead of using scsi_dma_map().

In contrast, bnx2fc_unmap_sg_list() calls scsi_dma_unmap().

The problem is that bnx2fc_map_sg() passes to the dma_map_sg() function
the pointer to the "device" structure taken from pci_dev
and not from Scsi_Host (as scsi_dma_map/unmap() do).

In some circumstances, the two devices may be different and the
DMA library will be unable to find the correct entry
when freeing the memory.

This patch fixes the bug by replacing dma_map_sg() with scsi_dma_map().

[56068.747547] WARNING: CPU: 1 PID: 12048 at lib/dma-debug.c:1080 check_unmap+0x90a/0xa00()
[56068.785706] fcoe ctlr_0: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x0000000202a1aa00] [size=36 bytes]
[56068.846700] Modules linked in: 8021q garp stp mrp llc fcoe bnx2fc cnic uio libfcoe libfc scsi_transport_fc scsi_tgt cfg80211 rfkill x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul iTCO_wdt crc32_pclmul gpio_ich crc32c_intel iTCO_vendor_support ghash_clmulni_intel joydev lpc_ich hpwdt nfsd mfd_core microcode hpilo serio_raw pcspkr ipmi_si auth_rpcgss nfs_acl lockd shpchp ipmi_msghandler sunrpc xfs e1000e mgag200 i2c_algo_bit drm_kms_helper ttm ptp drm ata_generic pata_acpi bnx2x i2c_core pps_core hpsa mdio libcrc32c
[56069.077673] CPU: 1 PID: 12048 Comm: bnx2fc_thread/1 Not tainted 3.16.0-rc7+ #1
[56069.115286] Hardware name: HP ProLiant DL120 G7, BIOS J01 07/01/2013
[56069.145091]  0000000000000009 ffff8801f36dbbd8 ffffffff816c323a ffff8801f36dbc20
[56069.185083]  ffff8801f36dbc10 ffffffff8108350d ffff8800e9880960 ffff8801f36dbd00
[56069.222738]  0000000000000024 0000000202a1aa00 0000000000000001 ffff8801f36dbc70
[56069.263389] Call Trace:
[56069.275945]  [<ffffffff816c323a>] dump_stack+0x45/0x56
[56069.302133]  [<ffffffff8108350d>] warn_slowpath_common+0x7d/0xa0
[56069.334050]  [<ffffffff8108357c>] warn_slowpath_fmt+0x4c/0x50
[56069.364537]  [<ffffffff8135214c>] ? debug_dma_mapping_error+0x7c/0x90
[56069.398268]  [<ffffffff8135423a>] check_unmap+0x90a/0xa00
[56069.423761]  [<ffffffff81354485>] debug_dma_unmap_sg+0x65/0x110
[56069.474134]  [<ffffffff8145ee93>] scsi_dma_unmap+0x73/0xb0
[56069.499313]  [<ffffffffa04cd9bc>] bnx2fc_process_scsi_cmd_compl+0xcc/0x2a0 [bnx2fc]
[56069.535588]  [<ffffffffa04c759b>] bnx2fc_process_cq_compl+0x21b/0x280 [bnx2fc]
[56069.570311]  [<ffffffffa04c2d76>] bnx2fc_percpu_io_thread+0x106/0x180 [bnx2fc]
[56069.604560]  [<ffffffffa04c2c70>] ? bnx2fc_get_src_mac+0x20/0x20 [bnx2fc]
[56069.635801]  [<ffffffff810a4392>] kthread+0xd2/0xf0
[56069.659421]  [<ffffffff810a42c0>] ? kthread_create_on_node+0x170/0x170
[56069.689416]  [<ffffffff816ca3bc>] ret_from_fork+0x7c/0xb0
[56069.715510]  [<ffffffff810a42c0>] ? kthread_create_on_node+0x170/0x170

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 7bc47fc..fe2cd9b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1640,8 +1640,6 @@ static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
 
 static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
 {
-	struct bnx2fc_interface *interface = io_req->port->priv;
-	struct bnx2fc_hba *hba = interface->hba;
 	struct scsi_cmnd *sc = io_req->sc_cmd;
 	struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
 	struct scatterlist *sg;
@@ -1653,8 +1651,8 @@ static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
 	u64 addr;
 	int i;
 
-	sg_count = dma_map_sg(&hba->pcidev->dev, scsi_sglist(sc),
-			      scsi_sg_count(sc), sc->sc_data_direction);
+	sg_count = scsi_dma_map(sc);
+
 	scsi_for_each_sg(sc, sg, sg_count, i) {
 		sg_len = sg_dma_len(sg);
 		addr = sg_dma_address(sg);
-- 
Maurizio Lombardi

