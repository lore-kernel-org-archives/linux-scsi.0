From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 23/32] bfa: IOC fixes, check for IOC down condition
Date: Thu, 25 Feb 2010 17:49:23 -0800
Message-ID: <1267148963-23118-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:27234 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934907Ab0BZBvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- Currently BFA was not checking for IOC down condition when issuing getstats/clearstats

    - Add check to see if IOC is operational, before issuing getstats/clearstats.
---
 drivers/scsi/bfa/bfa_ioc.c   |   11 ++++++++---
 drivers/scsi/bfa/bfa_iocfc.c |   10 ++++++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 2f09d17..4d9a47c 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1129,9 +1129,6 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
 		boot_type = BFI_BOOT_TYPE_FLASH;
 	fwimg = bfa_ioc_fwimg_get_chunk(ioc, chunkno);
-	fwimg[BFI_BOOT_TYPE_OFF / sizeof(u32)] = bfa_os_swap32(boot_type);
-	fwimg[BFI_BOOT_PARAM_OFF / sizeof(u32)] =
-		bfa_os_swap32(boot_param);
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
@@ -1166,6 +1163,14 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
 		      bfa_ioc_smem_pgnum(ioc, 0));
+
+	/*
+	 * Set boot type and boot param at the end.
+	 */
+	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_TYPE_OFF,
+			bfa_os_swap32(boot_type));
+	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_PARAM_OFF,
+			bfa_os_swap32(boot_param));
 }
 
 static void
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index 6677f83..a76de26 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -801,6 +801,11 @@ bfa_iocfc_get_stats(struct bfa_s *bfa, struct bfa_iocfc_stats_s *stats,
 		return BFA_STATUS_DEVBUSY;
 	}
 
+	if (!bfa_iocfc_is_operational(bfa)) {
+		bfa_trc(bfa, 0);
+		return BFA_STATUS_IOC_NON_OP;
+	}
+
 	iocfc->stats_busy = BFA_TRUE;
 	iocfc->stats_ret = stats;
 	iocfc->stats_cbfn = cbfn;
@@ -821,6 +826,11 @@ bfa_iocfc_clear_stats(struct bfa_s *bfa, bfa_cb_ioc_t cbfn, void *cbarg)
 		return BFA_STATUS_DEVBUSY;
 	}
 
+	if (!bfa_iocfc_is_operational(bfa)) {
+		bfa_trc(bfa, 0);
+		return BFA_STATUS_IOC_NON_OP;
+	}
+
 	iocfc->stats_busy = BFA_TRUE;
 	iocfc->stats_cbfn = cbfn;
 	iocfc->stats_cbarg = cbarg;
-- 
1.6.5.3

