From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/5] bfa: remove unused variables
Date: Tue,  2 Aug 2016 17:22:47 +0200
Message-ID: <20160802152250.1964074-3-arnd@arndb.de>
References: <20160802152250.1964074-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:58769 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965061AbcHBPXP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 11:23:15 -0400
In-Reply-To: <20160802152250.1964074-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Baoyou Xie <baoyou.xie@linaro.org>, Arnd Bergmann <arnd@arndb.de>

Building with W=1 shows some warnings about local variables that
are initialized but never used:

bfa/bfad_attr.c: In function 'bfad_im_vport_delete':
bfa/bfad_attr.c:490:22: error: variable 'port' set but not used
bfa/bfa_fcs_rport.c: In function 'bfa_fcs_rport_process_adisc':
bfa/bfa_fcs_rport.c:2259:21: error: variable 'adisc' set but not used
bfa/bfa_fcpim.c: In function 'bfa_fcpim_lunmask_delete':
bfa/bfa_fcpim.c:2366:22: error: variable 'rp' set but not used
bfa/bfa_ioc.c: In function 'bfa_iocpf_sm_fwcheck_entry':
bfa/bfa_ioc.c:720:27: error: variable 'pgoff' set but not used
bfa/bfa_ioc.c: In function 'bfa_ioc_fwver_get':
bfa/bfa_ioc.c:1463:13: error: variable 'pgoff' set but not used
bfa/bfa_ioc.c: In function 'bfa_ioc_fwsig_invalidate':
bfa/bfa_ioc.c:1685:13: error: variable 'pgoff' set but not used
bfa/bfa_ioc.c: In function 'bfa_ioc_download_fw':
bfa/bfa_ioc.c:1884:13: error: variable 'pgoff' set but not used
bfa/bfa_ioc.c: In function 'bfa_diag_memtest_done':
bfa/bfa_ioc.c:4763:13: error: variable 'pgoff' set but not used
bfa/bfa_ioc.c: In function 'bfa_flash_fifo_flush':
bfa/bfa_ioc.c:6803:6: error: variable 't' set but not used
bfa/bfa_svc.c: In function 'uf_recv':
bfa/bfa_svc.c:5605:17: error: variable 'fchs' set but not used

This removes all those variables.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfa_fcpim.c     |  6 +-----
 drivers/scsi/bfa/bfa_fcs_rport.c |  3 ---
 drivers/scsi/bfa/bfa_ioc.c       | 18 ++++++------------
 drivers/scsi/bfa/bfa_svc.c       |  3 ---
 drivers/scsi/bfa/bfad_attr.c     |  3 ---
 5 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 2132ab2ca88e..6dc3e8afa652 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2363,9 +2363,7 @@ bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 			 wwn_t rpwwn, struct scsi_lun lun)
 {
 	struct bfa_lun_mask_s	*lunm_list;
-	struct bfa_rport_s	*rp = NULL;
 	struct bfa_fcs_lport_s *port = NULL;
-	struct bfa_fcs_rport_s *rp_fcs;
 	int	i;
 
 	/* in min cfg lunm_list could be NULL but  no commands should run. */
@@ -2383,9 +2381,7 @@ bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 				vf_id, *pwwn);
 		if (port) {
 			*pwwn = port->port_cfg.pwwn;
-			rp_fcs = bfa_fcs_lport_get_rport_by_pwwn(port, rpwwn);
-			if (rp_fcs)
-				rp = rp_fcs->bfa_rport;
+			(void)bfa_fcs_lport_get_rport_by_pwwn(port, rpwwn);
 		}
 	}
 
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 1d722e272f18..24e6a126edb0 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2256,15 +2256,12 @@ bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 	struct bfa_fcxp_s *fcxp;
 	struct fchs_s	fchs;
 	struct bfa_fcs_lport_s *port = rport->port;
-	struct fc_adisc_s	*adisc;
 
 	bfa_trc(port->fcs, rx_fchs->s_id);
 	bfa_trc(port->fcs, rx_fchs->d_id);
 
 	rport->stats.adisc_rcvd++;
 
-	adisc = (struct fc_adisc_s *) (rx_fchs + 1);
-
 	/*
 	 * Accept if the itnim for this rport is online.
 	 * Else reject the ADISC.
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index d2974797e52d..a503a1a0f44d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -717,7 +717,7 @@ static void
 bfa_iocpf_sm_fwcheck_entry(struct bfa_iocpf_s *iocpf)
 {
 	struct bfi_ioc_image_hdr_s	fwhdr;
-	u32	r32, fwstate, pgnum, pgoff, loff = 0;
+	u32	r32, fwstate, pgnum, loff = 0;
 	int	i;
 
 	/*
@@ -747,7 +747,6 @@ bfa_iocpf_sm_fwcheck_entry(struct bfa_iocpf_s *iocpf)
 	 * Clear fwver hdr
 	 */
 	pgnum = PSS_SMEM_PGNUM(iocpf->ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, iocpf->ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32); i++) {
@@ -1460,13 +1459,12 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
-	u32	pgnum, pgoff;
+	u32	pgnum;
 	u32	loff = 0;
 	int		i;
 	u32	*fwsig = (u32 *) fwhdr;
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
@@ -1682,7 +1680,7 @@ bfa_status_t
 bfa_ioc_fwsig_invalidate(struct bfa_ioc_s *ioc)
 {
 
-	u32	pgnum, pgoff;
+	u32	pgnum;
 	u32	loff = 0;
 	enum bfi_ioc_state ioc_fwstate;
 
@@ -1691,7 +1689,6 @@ bfa_ioc_fwsig_invalidate(struct bfa_ioc_s *ioc)
 		return BFA_STATUS_ADAPTER_ENABLED;
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 	bfa_mem_write(ioc->ioc_regs.smem_page_start, loff, BFA_IOC_FW_INV_SIGN);
 
@@ -1881,7 +1878,7 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		    u32 boot_env)
 {
 	u32 *fwimg;
-	u32 pgnum, pgoff;
+	u32 pgnum;
 	u32 loff = 0;
 	u32 chunkno = 0;
 	u32 i;
@@ -1910,7 +1907,6 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
@@ -4781,10 +4777,9 @@ bfa_diag_memtest_done(void *cbarg)
 	struct bfa_ioc_s  *ioc = diag->ioc;
 	struct bfa_diag_memtest_result *res = diag->result;
 	u32	loff = BFI_BOOT_MEMTEST_RES_ADDR;
-	u32	pgnum, pgoff, i;
+	u32	pgnum, i;
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
@@ -6821,7 +6816,6 @@ static u32
 bfa_flash_fifo_flush(void __iomem *pci_bar)
 {
 	u32 i;
-	u32 t;
 	union bfa_flash_dev_status_reg_u dev_status;
 
 	dev_status.i = readl(pci_bar + FLI_DEV_STATUS_REG);
@@ -6831,7 +6825,7 @@ bfa_flash_fifo_flush(void __iomem *pci_bar)
 
 	/* fifo counter in terms of words */
 	for (i = 0; i < dev_status.r.fifo_cnt; i++)
-		t = readl(pci_bar + FLI_RDDATA_REG);
+		(void)readl(pci_bar + FLI_RDDATA_REG);
 
 	/*
 	 * Check the device status. It may take some time.
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 5345ebb81646..9804768c8bba 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5656,7 +5656,6 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 	struct bfa_uf_s *uf = &ufm->uf_list[uf_tag];
 	struct bfa_uf_buf_s *uf_buf;
 	uint8_t *buf;
-	struct fchs_s *fchs;
 
 	uf_buf = (struct bfa_uf_buf_s *)
 			bfa_mem_get_dmabuf_kva(ufm, uf_tag, uf->pb_len);
@@ -5665,8 +5664,6 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 	m->frm_len = be16_to_cpu(m->frm_len);
 	m->xfr_len = be16_to_cpu(m->xfr_len);
 
-	fchs = (struct fchs_s *)uf_buf;
-
 	list_del(&uf->qe);	/* dequeue from posted queue */
 
 	uf->data_ptr = buf;
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 3668b02168f9..d6a5edabf1ff 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -487,7 +487,6 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) vport->drv_port.im_port;
 	struct bfad_s *bfad = im_port->bfad;
-	struct bfad_port_s *port;
 	struct bfa_fcs_vport_s *fcs_vport;
 	struct Scsi_Host *vshost;
 	wwn_t   pwwn;
@@ -502,8 +501,6 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 		return 0;
 	}
 
-	port = im_port->port;
-
 	vshost = vport->drv_port.im_port->shost;
 	u64_to_wwn(fc_host_port_name(vshost), (u8 *)&pwwn);
 
-- 
2.9.0

