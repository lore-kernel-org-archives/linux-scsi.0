From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 2/2] bfa: Changes to existing source repository to support BFA debugfs node operations.
Date: Mon, 11 Jan 2010 15:56:24 -0800
Message-ID: <1263254184-18723-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:11943 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0ALABb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2010 19:01:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, xmzhang@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

---
 drivers/scsi/bfa/Makefile   |    2 +-
 drivers/scsi/bfa/bfad.c     |   53 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfad_drv.h |    9 ++++++-
 3 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index 619e62a..6549d8a 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
 
-bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o
+bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o bfad_debugfs.o
 
 bfa-y += bfa_core.o bfa_ioc.o bfa_ioc_ct.o bfa_ioc_cb.o bfa_iocfc.o bfa_fcxp.o
 bfa-y += bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 9b09053..849b64e 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -32,7 +32,9 @@
 #include <fcb/bfa_fcb.h>
 
 BFA_TRC_FILE(LDRV, BFAD);
-static DEFINE_MUTEX(bfad_mutex);
+
+struct mutex bfad_mutex;
+int bfad_scan_done;
 LIST_HEAD(bfad_list);
 static	int	bfad_inst;
 int bfad_supported_fc4s;
@@ -85,6 +87,44 @@ module_param(bfa_linkup_delay, int, S_IRUGO | S_IWUSR);
  */
 static int	num_sgpgs_parm;
 
+bfa_boolean_t
+bfad_is_ready(void)
+{
+	struct bfad_s *bfad = NULL;
+
+	mutex_lock(&bfad_mutex);
+	if (!bfad_scan_done) {
+		mutex_unlock(&bfad_mutex);
+		return BFA_FALSE;
+	}
+
+	list_for_each_entry(bfad, &bfad_list, list_entry) {
+		if (!(bfad->bfad_flags & BFAD_DRV_INIT_DONE)) {
+			mutex_unlock(&bfad_mutex);
+			return BFA_FALSE;
+		}
+	}
+	mutex_unlock(&bfad_mutex);
+
+	return BFA_TRUE;
+}
+
+struct bfad_s *
+bfad_find_bfad_by_inst_no(int inst_no)
+{
+	struct bfad_s         *bfad = NULL, *rc = NULL;
+
+	mutex_lock(&bfad_mutex);
+	list_for_each_entry(bfad, &bfad_list, list_entry) {
+		if (bfad->inst_no == inst_no) {
+			rc = bfad;
+			break;
+		}
+	}
+	mutex_unlock(&bfad_mutex);
+	return rc;
+}
+
 static bfa_status_t
 bfad_fc4_probe(struct bfad_s *bfad)
 {
@@ -1229,6 +1269,12 @@ bfad_init(void)
 		goto ext;
 	}
 
+	/* Initialize the bfad_mutex */
+	mutex_init(&bfad_mutex);
+
+	/* Debugfs init */
+	bfad_debugfs_init();
+
 	if (!strcmp(FCPI_NAME, " fcpim"))
 		bfad_supported_fc4s |= BFA_PORT_ROLE_FCP_IM;
 	if (!strcmp(FCPT_NAME, " fcptm"))
@@ -1245,6 +1291,10 @@ bfad_init(void)
 		goto ext;
 	}
 
+	mutex_lock(&bfad_mutex);
+	bfad_scan_done = 1;
+	mutex_unlock(&bfad_mutex);
+
 	return 0;
 
 ext:
@@ -1259,6 +1309,7 @@ static void __exit
 bfad_exit(void)
 {
 	pci_unregister_driver(&bfad_pci_driver);
+	bfad_debugfs_exit();
 	bfad_fc4_module_exit();
 	bfad_free_fwimg();
 }
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 15703b8..1422782 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -252,7 +252,8 @@ do {                                            	\
 	(*x) = (*x) >> 1;                       	\
 } while (0)
 
-
+bfa_boolean_t   bfad_is_ready(void);
+struct bfad_s*	bfad_find_bfad_by_inst_no(int inst_no);
 bfa_status_t    bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 				  struct bfa_port_cfg_s *port_cfg);
 bfa_status_t    bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
@@ -289,10 +290,16 @@ void bfad_os_rport_online_wait(struct bfad_s *bfad);
 int bfad_os_get_linkup_delay(struct bfad_s *bfad);
 int bfad_install_msix_handler(struct bfad_s *bfad);
 
+/* debugfs */
+void		bfad_debugfs_init(void);
+void		bfad_debugfs_exit(void);
+
 extern struct idr bfad_im_port_index;
 extern struct list_head bfad_list;
 extern int bfa_lun_queue_depth;
 extern int bfad_supported_fc4s;
 extern int bfa_linkup_delay;
+extern struct mutex bfad_mutex;
+extern int bfad_scan_done;
 
 #endif /* __BFAD_DRV_H__ */
-- 
1.6.5.3

