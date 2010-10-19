From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/6] bfa: fix frame size over 1024 compile warning
Date: Mon, 18 Oct 2010 17:14:01 -0700
Message-ID: <1287447241-29860-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:48677 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566Ab0JSAOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 20:14:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Fix compile warning for frame size over 1024 in gcc 4.4.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_defs_fcs.h |    2 +-
 drivers/scsi/bfa/bfad.c         |   17 -----------------
 drivers/scsi/bfa/bfad_drv.h     |    1 -
 drivers/scsi/bfa/bfad_im.c      |   27 ++++++++++++++-------------
 4 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_defs_fcs.h b/drivers/scsi/bfa/bfa_defs_fcs.h
index 96905d3..ae06258 100644
--- a/drivers/scsi/bfa/bfa_defs_fcs.h
+++ b/drivers/scsi/bfa/bfa_defs_fcs.h
@@ -93,7 +93,7 @@ struct bfa_lport_cfg_s {
     wwn_t	       pwwn;       /*  port wwn */
     wwn_t	       nwwn;       /*  node wwn */
     struct bfa_lport_symname_s  sym_name;   /*  vm port symbolic name */
-	bfa_boolean_t       preboot_vp;  /*  vport created from PBC */
+    bfa_boolean_t       preboot_vp;  /*  vport created from PBC */
     enum bfa_lport_role     roles;      /*  FCS port roles */
     u8	     tag[16];	/*  opaque tag from application */
 };
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index d3966bc..79f8b86 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -861,20 +861,6 @@ bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
 	pci_set_drvdata(pdev, NULL);
 }
 
-void
-bfad_fcs_port_cfg(struct bfad_s *bfad)
-{
-	struct bfa_lport_cfg_s  port_cfg;
-	struct bfa_port_attr_s attr;
-	char		symname[BFA_SYMNAME_MAXLEN];
-
-	sprintf(symname, "%s-%d", BFAD_DRIVER_NAME, bfad->inst_no);
-	memcpy(port_cfg.sym_name.symname, symname, strlen(symname));
-	bfa_fcport_get_attr(&bfad->bfa, &attr);
-	port_cfg.nwwn = attr.nwwn;
-	port_cfg.pwwn = attr.pwwn;
-}
-
 bfa_status_t
 bfad_drv_init(struct bfad_s *bfad)
 {
@@ -1065,9 +1051,6 @@ bfad_start_ops(struct bfad_s *bfad) {
 	bfa_fcs_init(&bfad->bfa_fcs);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-	/* PPORT FCS config */
-	bfad_fcs_port_cfg(bfad);
-
 	retval = bfad_cfg_pport(bfad, BFA_LPORT_ROLE_FCP_IM);
 	if (retval != BFA_STATUS_OK) {
 		if (bfa_sm_cmp_state(bfad, bfad_sm_initializing))
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 98420bb..a9045a8 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -309,7 +309,6 @@ void		bfad_bfa_tmo(unsigned long data);
 void		bfad_init_timer(struct bfad_s *bfad);
 int		bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad);
 void		bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad);
-void		bfad_fcs_port_cfg(struct bfad_s *bfad);
 void		bfad_drv_uninit(struct bfad_s *bfad);
 int		bfad_worker(void *ptr);
 void		bfad_debugfs_init(struct bfad_port_s *port);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 236922b..7a6f48b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -915,12 +915,16 @@ bfad_im_slave_alloc(struct scsi_device *sdev)
 static u32
 bfad_im_supported_speeds(struct bfa_s *bfa)
 {
-	struct bfa_ioc_attr_s ioc_attr;
+	struct bfa_ioc_attr_s *ioc_attr;
 	u32 supported_speed = 0;
 
-	bfa_get_attr(bfa, &ioc_attr);
-	if (ioc_attr.adapter_attr.max_speed == BFA_PORT_SPEED_8GBPS) {
-		if (ioc_attr.adapter_attr.is_mezz) {
+	ioc_attr = kzalloc(sizeof(struct bfa_ioc_attr_s), GFP_KERNEL);
+	if (!ioc_attr)
+		return 0;
+
+	bfa_get_attr(bfa, ioc_attr);
+	if (ioc_attr->adapter_attr.max_speed == BFA_PORT_SPEED_8GBPS) {
+		if (ioc_attr->adapter_attr.is_mezz) {
 			supported_speed |= FC_PORTSPEED_8GBIT |
 				FC_PORTSPEED_4GBIT |
 				FC_PORTSPEED_2GBIT | FC_PORTSPEED_1GBIT;
@@ -929,12 +933,13 @@ bfad_im_supported_speeds(struct bfa_s *bfa)
 				FC_PORTSPEED_4GBIT |
 				FC_PORTSPEED_2GBIT;
 		}
-	} else if (ioc_attr.adapter_attr.max_speed == BFA_PORT_SPEED_4GBPS) {
+	} else if (ioc_attr->adapter_attr.max_speed == BFA_PORT_SPEED_4GBPS) {
 		supported_speed |=  FC_PORTSPEED_4GBIT | FC_PORTSPEED_2GBIT |
 				FC_PORTSPEED_1GBIT;
-	} else if (ioc_attr.adapter_attr.max_speed == BFA_PORT_SPEED_10GBPS) {
+	} else if (ioc_attr->adapter_attr.max_speed == BFA_PORT_SPEED_10GBPS) {
 		supported_speed |= FC_PORTSPEED_10GBIT;
 	}
+	kfree(ioc_attr);
 	return supported_speed;
 }
 
@@ -944,9 +949,8 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	struct Scsi_Host *host = im_port->shost;
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfad_port_s    *port = im_port->port;
-	struct bfa_port_attr_s pattr;
-	struct bfa_lport_attr_s port_attr;
 	char symname[BFA_SYMNAME_MAXLEN];
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(&bfad->bfa);
 
 	fc_host_node_name(host) =
 		cpu_to_be64((bfa_fcs_lport_get_nwwn(port->fcs_port)));
@@ -964,15 +968,12 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	/* For fibre channel services type 0x20 */
 	fc_host_supported_fc4s(host)[7] = 1;
 
-	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
-	strncpy(symname, port_attr.port_cfg.sym_name.symname,
+	strncpy(symname, bfad->bfa_fcs.fabric.bport.port_cfg.sym_name.symname,
 		BFA_SYMNAME_MAXLEN);
 	sprintf(fc_host_symbolic_name(host), "%s", symname);
 
 	fc_host_supported_speeds(host) = bfad_im_supported_speeds(&bfad->bfa);
-
-	bfa_fcport_get_attr(&bfad->bfa, &pattr);
-	fc_host_maxframe_size(host) = pattr.pport_cfg.maxfrsize;
+	fc_host_maxframe_size(host) = fcport->cfg.maxfrsize;  
 }
 
 static void
-- 
1.6.5.2

