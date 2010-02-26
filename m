From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 19/32] bfa: AEN and byte alignment fixes.
Date: Thu, 25 Feb 2010 17:49:03 -0800
Message-ID: <1267148943-22940-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:27249 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955Ab0BZBwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:52:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- Replace enum types with int and rearrange the fields
	  to fix some alignment issue.

	- Local var ioc_attr is causing the stack to overflow, so removed
	  the usage of the local ioc_attr var and now invoking an API to return
	  the ioc_type.

	- Fix some AEN issues.
---
 drivers/scsi/bfa/bfa_fcport.c                  |    1 +
 drivers/scsi/bfa/bfa_ioc.c                     |   32 ++++++++++-----
 drivers/scsi/bfa/bfad.c                        |    9 +----
 drivers/scsi/bfa/bfad_drv.h                    |   12 +-----
 drivers/scsi/bfa/include/aen/bfa_aen.h         |   50 +++++++++++++-----------
 drivers/scsi/bfa/include/defs/bfa_defs_aen.h   |   10 +++++
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h   |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_lport.h |    4 +-
 drivers/scsi/bfa/include/defs/bfa_defs_port.h  |   17 ++++----
 9 files changed, 73 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index 29c8a6a..82858db 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -142,6 +142,7 @@ bfa_pport_aen_post(struct bfa_pport_s *pport, enum bfa_port_aen_event event)
 	char            pwwn_ptr[BFA_STRING_32];
 	struct bfa_ioc_attr_s ioc_attr;
 
+	memset(&aen_data, 0, sizeof(aen_data));
 	wwn2str(pwwn_ptr, pwwn);
 	switch (event) {
 	case BFA_PORT_AEN_ONLINE:
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 0019ff7..2f09d17 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1731,6 +1731,21 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 	ad_attr->cna_capable = ioc->cna;
 }
 
+enum bfa_ioc_type_e
+bfa_ioc_get_type(struct bfa_ioc_s *ioc)
+{
+	if (!ioc->ctdev || ioc->fcmode)
+		return BFA_IOC_TYPE_FC;
+	else if (ioc->ioc_mc == BFI_MC_IOCFC)
+		return BFA_IOC_TYPE_FCoE;
+	else if (ioc->ioc_mc == BFI_MC_LL)
+		return BFA_IOC_TYPE_LL;
+	else {
+		bfa_assert(ioc->ioc_mc == BFI_MC_LL);
+		return BFA_IOC_TYPE_LL;
+	}
+}
+
 void
 bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 {
@@ -1739,12 +1754,7 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 	ioc_attr->state = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
 	ioc_attr->port_id = ioc->port_id;
 
-	if (!ioc->ctdev || ioc->fcmode)
-		ioc_attr->ioc_type = BFA_IOC_TYPE_FC;
-	else if (ioc->ioc_mc == BFI_MC_IOCFC)
-		ioc_attr->ioc_type = BFA_IOC_TYPE_FCoE;
-	else if (ioc->ioc_mc == BFI_MC_LL)
-		ioc_attr->ioc_type = BFA_IOC_TYPE_LL;
+	ioc_attr->ioc_type = bfa_ioc_get_type(ioc);
 
 	bfa_ioc_get_adapter_attr(ioc, &ioc_attr->adapter_attr);
 
@@ -1860,7 +1870,7 @@ bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 	union bfa_aen_data_u aen_data;
 	struct bfa_log_mod_s *logmod = ioc->logm;
 	s32         inst_num = 0;
-	struct bfa_ioc_attr_s ioc_attr;
+	enum bfa_ioc_type_e ioc_type;
 
 	switch (event) {
 	case BFA_IOC_AEN_HBGOOD:
@@ -1884,8 +1894,8 @@ bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 
 	memset(&aen_data.ioc.pwwn, 0, sizeof(aen_data.ioc.pwwn));
 	memset(&aen_data.ioc.mac, 0, sizeof(aen_data.ioc.mac));
-	bfa_ioc_get_attr(ioc, &ioc_attr);
-	switch (ioc_attr.ioc_type) {
+	ioc_type = bfa_ioc_get_type(ioc);
+	switch (ioc_type) {
 	case BFA_IOC_TYPE_FC:
 		aen_data.ioc.pwwn = bfa_ioc_get_pwwn(ioc);
 		break;
@@ -1897,10 +1907,10 @@ bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 		aen_data.ioc.mac = bfa_ioc_get_mac(ioc);
 		break;
 	default:
-		bfa_assert(ioc_attr.ioc_type == BFA_IOC_TYPE_FC);
+		bfa_assert(ioc_type == BFA_IOC_TYPE_FC);
 		break;
 	}
-	aen_data.ioc.ioc_type = ioc_attr.ioc_type;
+	aen_data.ioc.ioc_type = ioc_type;
 }
 
 /**
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index ebeca3a..73ec190 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -677,7 +677,6 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_status_t    rc;
 	unsigned long   flags;
 	struct bfa_fcs_driver_info_s driver_info;
-	int             i;
 
 	bfad->cfg_data.rport_del_timeout = rport_del_timeout;
 	bfad->cfg_data.lun_queue_depth = bfa_lun_queue_depth;
@@ -697,12 +696,7 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_init_log(&bfad->bfa, bfad->logmod);
 	bfa_init_trc(&bfad->bfa, bfad->trcmod);
 	bfa_init_aen(&bfad->bfa, bfad->aen);
-	INIT_LIST_HEAD(&bfad->file_q);
-	INIT_LIST_HEAD(&bfad->file_free_q);
-	for (i = 0; i < BFAD_AEN_MAX_APPS; i++) {
-		bfa_q_qe_init(&bfad->file_buf[i].qe);
-		list_add_tail(&bfad->file_buf[i].qe, &bfad->file_free_q);
-	}
+	memset(bfad->file_map, 0, sizeof(bfad->file_map));
 	bfa_init_plog(&bfad->bfa, &bfad->plog_buf);
 	bfa_plog_init(&bfad->plog_buf);
 	bfa_plog_str(&bfad->plog_buf, BFA_PL_MID_DRVR, BFA_PL_EID_DRIVER_START,
@@ -799,7 +793,6 @@ bfad_drv_uninit(struct bfad_s *bfad)
 	bfa_isr_disable(&bfad->bfa);
 	bfa_detach(&bfad->bfa);
 	bfad_remove_intr(bfad);
-	bfa_assert(list_empty(&bfad->file_q));
 	bfad_hal_mem_release(bfad);
 
 	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 3740a44..05769ee 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -139,14 +139,6 @@ struct bfad_cfg_param_s {
 	u32        binding_method;
 };
 
-#define BFAD_AEN_MAX_APPS 8
-struct bfad_aen_file_s {
-	struct list_head  qe;
-	struct bfad_s *bfad;
-	s32 ri;
-	s32 app_id;
-};
-
 /*
  * BFAD (PCI function) data structure
  */
@@ -186,9 +178,7 @@ struct bfad_s {
 	struct bfa_log_mod_s  *logmod;
 	struct bfa_aen_s      *aen;
 	struct bfa_aen_s       aen_buf;
-	struct bfad_aen_file_s file_buf[BFAD_AEN_MAX_APPS];
-	struct list_head         file_q;
-	struct list_head         file_free_q;
+	void		*file_map[BFA_AEN_MAX_APP];
 	struct bfa_plog_s      plog_buf;
 	int             ref_count;
 	bfa_boolean_t	ipfc_enabled;
diff --git a/drivers/scsi/bfa/include/aen/bfa_aen.h b/drivers/scsi/bfa/include/aen/bfa_aen.h
index d9cbc2a..6abbab0 100644
--- a/drivers/scsi/bfa/include/aen/bfa_aen.h
+++ b/drivers/scsi/bfa/include/aen/bfa_aen.h
@@ -18,21 +18,24 @@
 #define __BFA_AEN_H__
 
 #include "defs/bfa_defs_aen.h"
+#include "defs/bfa_defs_status.h"
+#include "cs/bfa_debug.h"
 
-#define BFA_AEN_MAX_ENTRY   512
+#define BFA_AEN_MAX_ENTRY	512
 
-extern s32 bfa_aen_max_cfg_entry;
+extern int bfa_aen_max_cfg_entry;
 struct bfa_aen_s {
 	void		*bfad;
-	s32		max_entry;
-	s32		write_index;
-	s32		read_index;
-	u32	bfad_num;
-	u32	seq_num;
+	int		max_entry;
+	int		write_index;
+	int		read_index;
+	int		bfad_num;
+	int		seq_num;
 	void		(*aen_cb_notify)(void *bfad);
 	void		(*gettimeofday)(struct bfa_timeval_s *tv);
-	struct bfa_trc_mod_s 	*trcmod;
-	struct bfa_aen_entry_s	list[BFA_AEN_MAX_ENTRY]; /* Must be the last */
+	struct bfa_trc_mod_s *trcmod;
+	int		app_ri[BFA_AEN_MAX_APP]; /* For multiclient support */
+	struct bfa_aen_entry_s list[BFA_AEN_MAX_ENTRY]; /* Must be the last */
 };
 
 
@@ -45,48 +48,49 @@ bfa_aen_set_max_cfg_entry(int max_entry)
 	bfa_aen_max_cfg_entry = max_entry;
 }
 
-static inline s32
+static inline int
 bfa_aen_get_max_cfg_entry(void)
 {
 	return bfa_aen_max_cfg_entry;
 }
 
-static inline s32
+static inline int
 bfa_aen_get_meminfo(void)
 {
 	return sizeof(struct bfa_aen_entry_s) * bfa_aen_get_max_cfg_entry();
 }
 
-static inline s32
+static inline int
 bfa_aen_get_wi(struct bfa_aen_s *aen)
 {
 	return aen->write_index;
 }
 
-static inline s32
+static inline int
 bfa_aen_get_ri(struct bfa_aen_s *aen)
 {
 	return aen->read_index;
 }
 
-static inline s32
-bfa_aen_fetch_count(struct bfa_aen_s *aen, s32 read_index)
+static inline int
+bfa_aen_fetch_count(struct bfa_aen_s *aen, enum bfa_aen_app  app_id)
 {
-	return ((aen->write_index + aen->max_entry) - read_index)
+	bfa_assert((app_id < BFA_AEN_MAX_APP) && (app_id >= bfa_aen_app_bcu));
+	return ((aen->write_index + aen->max_entry) - aen->app_ri[app_id])
 		% aen->max_entry;
 }
 
-s32 bfa_aen_init(struct bfa_aen_s *aen, struct bfa_trc_mod_s *trcmod,
-		void *bfad, u32 inst_id, void (*aen_cb_notify)(void *),
+int bfa_aen_init(struct bfa_aen_s *aen, struct bfa_trc_mod_s *trcmod,
+		void *bfad, int bfad_num, void (*aen_cb_notify)(void *),
 		void (*gettimeofday)(struct bfa_timeval_s *));
 
-s32 bfa_aen_post(struct bfa_aen_s *aen, enum bfa_aen_category aen_category,
+void bfa_aen_post(struct bfa_aen_s *aen, enum bfa_aen_category aen_category,
 		     int aen_type, union bfa_aen_data_u *aen_data);
 
-s32 bfa_aen_fetch(struct bfa_aen_s *aen, struct bfa_aen_entry_s *aen_entry,
-		      s32 entry_space, s32 rii, s32 *ri_arr,
-		      s32 ri_arr_cnt);
+bfa_status_t bfa_aen_fetch(struct bfa_aen_s *aen,
+			struct bfa_aen_entry_s *aen_entry,
+			int entry_req, enum bfa_aen_app app_id, int *entry_ret);
 
-s32 bfa_aen_get_inst(struct bfa_aen_s *aen);
+int bfa_aen_get_inst(struct bfa_aen_s *aen);
 
 #endif /* __BFA_AEN_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_aen.h b/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
index 4c81a61..3524469 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
@@ -30,6 +30,16 @@
 #include <defs/bfa_defs_audit.h>
 #include <defs/bfa_defs_ethport.h>
 
+#define BFA_AEN_MAX_APP         5
+
+enum bfa_aen_app {
+	bfa_aen_app_bcu = 0,    /* No thread for bcu */
+	bfa_aen_app_hcm = 1,
+	bfa_aen_app_cim = 2,
+	bfa_aen_app_snia = 3,
+	bfa_aen_app_test = 4,   /* To be removed after unit test */
+};
+
 enum bfa_aen_category {
 	BFA_AEN_CAT_ADAPTER 	= 1,
 	BFA_AEN_CAT_PORT 	= 2,
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
index 6c721b1..8d8e6a9 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
@@ -144,8 +144,8 @@ enum bfa_ioc_aen_event {
  * BFA IOC level event data, now just a place holder
  */
 struct bfa_ioc_aen_data_s {
-	enum bfa_ioc_type_e ioc_type;
 	wwn_t	pwwn;
+	s16 ioc_type;
 	mac_t	mac;
 };
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_lport.h b/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
index 7359f82..0952a13 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
@@ -59,8 +59,8 @@ enum bfa_lport_aen_event {
  */
 struct bfa_lport_aen_data_s {
 	u16        vf_id;	/*  vf_id of this logical port */
-	u16        rsvd;
-	enum bfa_port_role roles;	/*  Logical port mode,IM/TM/IP etc */
+	s16         roles;  /*  Logical port mode,IM/TM/IP etc */
+	u32        rsvd;
 	wwn_t           ppwwn;	/*  WWN of its physical port */
 	wwn_t           lpwwn;	/*  WWN of this logical port */
 };
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_port.h b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
index b54b341..d898fac 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_port.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
@@ -234,14 +234,15 @@ enum bfa_port_aen_sfp_pom {
 };
 
 struct bfa_port_aen_data_s {
-	enum bfa_ioc_type_e ioc_type;
-	wwn_t           pwwn;	      /*  WWN of the physical port */
-	wwn_t           fwwn;	      /*  WWN of the fabric port */
-	mac_t           mac;	      /*  MAC address of the ethernet port,
-				       * applicable to CNA port only */
-	int             phy_port_num; /*! For SFP related events */
-	enum bfa_port_aen_sfp_pom level; /*  Only transitions will
-					  * be informed */
+	wwn_t           pwwn;         /*  WWN of the physical port */
+	wwn_t           fwwn;         /*  WWN of the fabric port */
+	s32         phy_port_num; /*! For SFP related events */
+	s16         ioc_type;
+	s16         level;        /*  Only transitions will
+					* be informed */
+	struct mac_s    mac;          /*  MAC address of the ethernet port,
+					* applicable to CNA port only */
+	s16         rsvd;
 };
 
 #endif /* __BFA_DEFS_PORT_H__ */
-- 
1.6.5.3

