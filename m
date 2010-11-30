From: Maggie <xmzhang@brocade.com>
Subject: [PATCH 1/2] bfa: fix regular sparse check warnings.
Date: Mon, 29 Nov 2010 18:21:32 -0800
Message-ID: <1291083692-18870-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44275 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab0K3Ci3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2010 21:38:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie <xmzhang@brocade.com>

Fix all sparse check warnings from make C=2. 

Signed-off-by: Maggie <xmzhang@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    6 ++--
 drivers/scsi/bfa/bfa_fcs_rport.c |    8 -------
 drivers/scsi/bfa/bfa_ioc.h       |    2 +-
 drivers/scsi/bfa/bfa_ioc_cb.c    |    2 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |    2 +-
 drivers/scsi/bfa/bfad.c          |    4 +-
 drivers/scsi/bfa/bfad_attr.c     |    8 +++---
 drivers/scsi/bfa/bfad_debugfs.c  |   42 +++++++++++++++++++++++++++++++++----
 drivers/scsi/bfa/bfad_drv.h      |    6 ++--
 9 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 377cbff..372ed14 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2103,7 +2103,7 @@ bfa_fcs_lport_fdmi_timeout(void *arg)
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_TIMEOUT);
 }
 
-void
+static void
 bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 			 struct bfa_fcs_fdmi_hba_attr_s *hba_attr)
 {
@@ -2147,7 +2147,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	hba_attr->max_ct_pyld = cpu_to_be32(FC_MAX_PDUSZ);
 }
 
-void
+static void
 bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
@@ -4150,7 +4150,7 @@ bfa_fcs_lport_ns_query(struct bfa_fcs_lport_s *port)
 	bfa_sm_send_event(ns, NSSM_EVENT_NS_QUERY);
 }
 
-void
+static void
 bfa_fcs_lport_ns_boot_target_disc(bfa_fcs_lport_t *port)
 {
 
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 47f35c0..7272688 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2359,14 +2359,6 @@ bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
 }
 
-/*
- *	Called by fcptm to notify that the ITN cleanup is done.
- */
-void
-bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport)
-{
-	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
-}
 
 /*
  *	brief
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 9c407a8..eb1b005 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -421,7 +421,7 @@ bfa_cb_image_get_chunk(int type, u32 off)
 		return bfi_image_ct_cna_get_chunk(off);	break;
 	case BFI_IMAGE_CB_FC:
 		return bfi_image_cb_fc_get_chunk(off);	break;
-	default: return 0;
+	default: return NULL;
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 9099450..61f03cb 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -32,7 +32,7 @@ static void bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
 static void bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc);
 
-struct bfa_ioc_hwif_s hwif_cb;
+static struct bfa_ioc_hwif_s hwif_cb;
 
 /*
  * Called from bfa_ioc_attach() to map asic specific calls.
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 115730c..79fb312 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -32,7 +32,7 @@ static void bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
 static void bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc);
 
-struct bfa_ioc_hwif_s hwif_ct;
+static struct bfa_ioc_hwif_s hwif_ct;
 
 /*
  * Called from bfa_ioc_attach() to map asic specific calls.
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 1f93897..ff7af36a 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -61,12 +61,12 @@ int		msix_disable_cb = 0, msix_disable_ct = 0;
 u32	bfi_image_ct_fc_size, bfi_image_ct_cna_size, bfi_image_cb_fc_size;
 u32     *bfi_image_ct_fc, *bfi_image_ct_cna, *bfi_image_cb_fc;
 
-const char *msix_name_ct[] = {
+static const char *msix_name_ct[] = {
 	"cpe0", "cpe1", "cpe2", "cpe3",
 	"rme0", "rme1", "rme2", "rme3",
 	"ctrl" };
 
-const char *msix_name_cb[] = {
+static const char *msix_name_cb[] = {
 	"cpe0", "cpe1", "cpe2", "cpe3",
 	"rme0", "rme1", "rme2", "rme3",
 	"eemc", "elpu0", "elpu1", "epss", "mlpu" };
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index ed9fff4..d727f05 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -25,7 +25,7 @@
 /*
  * FC transport template entry, get SCSI target port ID.
  */
-void
+static void
 bfad_im_get_starget_port_id(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost;
@@ -51,7 +51,7 @@ bfad_im_get_starget_port_id(struct scsi_target *starget)
 /*
  * FC transport template entry, get SCSI target nwwn.
  */
-void
+static void
 bfad_im_get_starget_node_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost;
@@ -77,7 +77,7 @@ bfad_im_get_starget_node_name(struct scsi_target *starget)
 /*
  * FC transport template entry, get SCSI target pwwn.
  */
-void
+static void
 bfad_im_get_starget_port_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost;
@@ -103,7 +103,7 @@ bfad_im_get_starget_port_name(struct scsi_target *starget)
 /*
  * FC transport template entry, get SCSI host port ID.
  */
-void
+static void
 bfad_im_get_host_port_id(struct Scsi_Host *shost)
 {
 	struct bfad_im_port_s *im_port =
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 1fedeeb..144602c 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -208,7 +208,7 @@ bfad_debugfs_read(struct file *file, char __user *buf,
 	if (!debug || !debug->debug_buffer)
 		return 0;
 
-	return memory_read_from_buffer(buf, nbytes, pos,
+	return simple_read_from_buffer(buf, nbytes, pos,
 				debug->debug_buffer, debug->buffer_len);
 }
 
@@ -254,7 +254,7 @@ bfad_debugfs_read_regrd(struct file *file, char __user *buf,
 	if (!bfad->regdata)
 		return 0;
 
-	rc = memory_read_from_buffer(buf, nbytes, pos,
+	rc = simple_read_from_buffer(buf, nbytes, pos,
 			bfad->regdata, bfad->reglen);
 
 	if ((*pos + nbytes) >= bfad->reglen) {
@@ -279,15 +279,31 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	u32 *regbuf;
 	void __iomem *rb, *reg_addr;
 	unsigned long flags;
+	void *kern_buf;
 
-	rc = sscanf(buf, "%x:%x", &addr, &len);
+	kern_buf = kzalloc(nbytes, GFP_KERNEL);
+
+	if (!kern_buf) {
+		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
+                kfree(kern_buf);
+		return -ENOMEM;
+        }
+
+	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
 	if (rc < 2) {
 		printk(KERN_INFO
 			"bfad[%d]: %s failed to read user buf\n",
 			bfad->inst_no, __func__);
+		kfree(kern_buf);
 		return -EINVAL;
 	}
 
+	kfree(kern_buf);
 	kfree(bfad->regdata);
 	bfad->regdata = NULL;
 	bfad->reglen = 0;
@@ -339,14 +355,30 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	int addr, val, rc;
 	void __iomem *reg_addr;
 	unsigned long flags;
+	void *kern_buf;
+
+	kern_buf = kzalloc(nbytes, GFP_KERNEL);
+
+	if (!kern_buf) {
+		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
+                kfree(kern_buf);
+		return -ENOMEM;
+        }
 
-	rc = sscanf(buf, "%x:%x", &addr, &val);
+	rc = sscanf(kern_buf, "%x:%x", &addr, &val);
 	if (rc < 2) {
 		printk(KERN_INFO
 			"bfad[%d]: %s failed to read user buf\n",
 			bfad->inst_no, __func__);
+		kfree(kern_buf);
 		return -EINVAL;
 	}
+	kfree(kern_buf);
 
 	addr &= BFA_REG_ADDRMSK(bfa); /* offset only 17 bit and word align */
 
@@ -359,7 +391,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 		return -EINVAL;
 	}
 
-	reg_addr = (u32 *) ((u8 *) bfa_ioc_bar0(ioc) + addr);
+	reg_addr = (bfa_ioc_bar0(ioc)) + addr;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	writel(val, reg_addr);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 97f9b6c..732c29d 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -263,10 +263,10 @@ struct bfad_hal_comp {
  */
 #define nextLowerInt(x)                         \
 do {                                            \
-	int i;                                  \
+	int __i;                                  \
 	(*x)--;					\
-	for (i = 1; i < (sizeof(int)*8); i <<= 1) \
-		(*x) = (*x) | (*x) >> i;	\
+	for (__i = 1; __i < (sizeof(int)*8); __i <<= 1) \
+		(*x) = (*x) | (*x) >> __i;	\
 	(*x)++;					\
 	(*x) = (*x) >> 1;			\
 } while (0)
-- 
1.7.2.1

