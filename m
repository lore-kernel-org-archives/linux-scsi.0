From: <kgudipat@brocade.com>
Subject: [PATCH 17/33] bfa: Add cleaned up (2.3.2.0) BFA driver specific header files.
Date: Wed, 15 Sep 2010 12:10:08 -0700
Message-ID: <1284577808-19722-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34410 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646Ab0IOTKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:10:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- The following patch adds back the cleaned up BFA driver specific header files:

	- bfad_im.h  : Contains all IM specific function prototypes / structures
				   and firmware handling.
	- bfad_drv.h : Updated the driver version to 2.3.2.0
				 : Contains the BFAD related function prototypes and structures.

	- bfa_os_inc.h : Cleaned up to have only needed stuff;
					 refined BFA_LOG to internally use dev_printk & only BFA_LOG is
					 used across the whole driver now.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_os_inc.h |  144 +++++++++--------------
 drivers/scsi/bfa/bfad_drv.h   |  254 ++++++++++++++++++++++++-----------------
 drivers/scsi/bfa/bfad_im.h    |   56 ++++++---
 3 files changed, 246 insertions(+), 208 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index bd1cd3e..788a250 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -22,30 +22,20 @@
 #ifndef __BFA_OS_INC_H__
 #define __BFA_OS_INC_H__
 
-#ifndef __KERNEL__
-#include <stdint.h>
-#else
 #include <linux/types.h>
-
 #include <linux/version.h>
 #include <linux/pci.h>
-
 #include <linux/dma-mapping.h>
-#define SET_MODULE_VERSION(VER)
-
 #include <linux/idr.h>
-
 #include <linux/interrupt.h>
 #include <linux/cdev.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
-
 #include <linux/workqueue.h>
-
+#include <linux/bitops.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
-
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_transport.h>
@@ -54,97 +44,75 @@
 #define __BIGENDIAN
 #endif
 
-#define BFA_ERR			KERN_ERR
-#define BFA_WARNING		KERN_WARNING
-#define BFA_NOTICE		KERN_NOTICE
-#define BFA_INFO		KERN_INFO
-#define BFA_DEBUG		KERN_DEBUG
-
-#define LOG_BFAD_INIT		0x00000001
-#define LOG_FCP_IO		0x00000002
-
-#ifdef DEBUG
-#define BFA_LOG_TRACE(bfad, level, mask, fmt, arg...)			\
-		BFA_LOG(bfad, level, mask, fmt, ## arg)
-#define BFA_DEV_TRACE(bfad, level, fmt, arg...)				\
-		BFA_DEV_PRINTF(bfad, level, fmt, ## arg)
-#define BFA_TRACE(level, fmt, arg...)					\
-		BFA_PRINTF(level, fmt, ## arg)
-#else
-#define BFA_LOG_TRACE(bfad, level, mask, fmt, arg...)
-#define BFA_DEV_TRACE(bfad, level, fmt, arg...)
-#define BFA_TRACE(level, fmt, arg...)
-#endif
+static inline u64 bfa_os_get_clock(void)
+{
+	return jiffies;
+}
+
+static inline u64 bfa_os_get_log_time(void)
+{
+	u64 system_time = 0;
+	struct timeval tv;
+	do_gettimeofday(&tv);
+
+	/* We are interested in seconds only. */
+	system_time = tv.tv_sec;
+	return system_time;
+}
+
+#define bfa_io_lat_clock_res_div HZ
+#define bfa_io_lat_clock_res_mul 1000
 
 #define BFA_ASSERT(p) do {						\
 	if (!(p)) {      \
 		printk(KERN_ERR "assert(%s) failed at %s:%d\n",		\
 		#p, __FILE__, __LINE__);      \
-		BUG();      \
 	}								\
 } while (0)
 
-
-#define BFA_LOG(bfad, level, mask, fmt, arg...)				\
-do { 									\
-	if (((mask) & (((struct bfad_s *)(bfad))->			\
-		cfg_data[cfg_log_mask])) || (level[1] <= '3'))		\
-		dev_printk(level, &(((struct bfad_s *)			\
-			(bfad))->pcidev->dev), fmt, ##arg);      \
+#define BFA_LOG(level, bfad, mask, fmt, arg...)				\
+do {									\
+	if (((mask) == 4) || (level[1] <= '4'))				\
+		dev_printk(level, &((bfad)->pcidev)->dev, fmt, ##arg);	\
 } while (0)
 
-#ifndef BFA_DEV_PRINTF
-#define BFA_DEV_PRINTF(bfad, level, fmt, arg...)			\
-		dev_printk(level, &(((struct bfad_s *)			\
-			(bfad))->pcidev->dev), fmt, ##arg);
-#endif
-
-#define BFA_PRINTF(level, fmt, arg...)					\
-		printk(level fmt, ##arg);
-
-int bfa_os_MWB(void *);
-
-#define bfa_os_mmiowb()		mmiowb()
-
 #define bfa_swap_3b(_x)				\
 	((((_x) & 0xff) << 16) |		\
 	((_x) & 0x00ff00) |			\
 	(((_x) & 0xff0000) >> 16))
 
-#define bfa_swap_8b(_x) 				\
-     ((((_x) & 0xff00000000000000ull) >> 56)		\
-      | (((_x) & 0x00ff000000000000ull) >> 40)		\
-      | (((_x) & 0x0000ff0000000000ull) >> 24)		\
-      | (((_x) & 0x000000ff00000000ull) >> 8)		\
-      | (((_x) & 0x00000000ff000000ull) << 8)		\
-      | (((_x) & 0x0000000000ff0000ull) << 24)		\
-      | (((_x) & 0x000000000000ff00ull) << 40)		\
-      | (((_x) & 0x00000000000000ffull) << 56))
-
-#define bfa_os_swap32(_x) 			\
-	((((_x) & 0xff) << 24) 		|	\
+#define bfa_swap_8b(_x)					\
+	((((_x) & 0xff00000000000000ull) >> 56)		\
+	 | (((_x) & 0x00ff000000000000ull) >> 40)	\
+	 | (((_x) & 0x0000ff0000000000ull) >> 24)	\
+	 | (((_x) & 0x000000ff00000000ull) >> 8)	\
+	 | (((_x) & 0x00000000ff000000ull) << 8)	\
+	 | (((_x) & 0x0000000000ff0000ull) << 24)	\
+	 | (((_x) & 0x000000000000ff00ull) << 40)	\
+	 | (((_x) & 0x00000000000000ffull) << 56))
+
+#define bfa_os_swap32(_x)			\
+	((((_x) & 0xff) << 24)		|	\
 	(((_x) & 0x0000ff00) << 8)	|	\
 	(((_x) & 0x00ff0000) >> 8)	|	\
 	(((_x) & 0xff000000) >> 24))
 
-#define bfa_os_swap_sgaddr(_x)	((u64)(					\
-	(((u64)(_x) & (u64)0x00000000000000ffull) << 32)	|	\
-	(((u64)(_x) & (u64)0x000000000000ff00ull) << 32)	|	\
-	(((u64)(_x) & (u64)0x0000000000ff0000ull) << 32)	|	\
-	(((u64)(_x) & (u64)0x00000000ff000000ull) << 32)	|	\
-	(((u64)(_x) & (u64)0x000000ff00000000ull) >> 32)	|	\
-	(((u64)(_x) & (u64)0x0000ff0000000000ull) >> 32)	|	\
-	(((u64)(_x) & (u64)0x00ff000000000000ull) >> 32)	|	\
+#define bfa_os_swap_sgaddr(_x)  ((u64)(                                 \
+	(((u64)(_x) & (u64)0x00000000000000ffull) << 32)        |       \
+	(((u64)(_x) & (u64)0x000000000000ff00ull) << 32)        |       \
+	(((u64)(_x) & (u64)0x0000000000ff0000ull) << 32)        |       \
+	(((u64)(_x) & (u64)0x00000000ff000000ull) << 32)        |       \
+	(((u64)(_x) & (u64)0x000000ff00000000ull) >> 32)        |       \
+	(((u64)(_x) & (u64)0x0000ff0000000000ull) >> 32)        |       \
+	(((u64)(_x) & (u64)0x00ff000000000000ull) >> 32)        |       \
 	(((u64)(_x) & (u64)0xff00000000000000ull) >> 32)))
 
 #ifndef __BIGENDIAN
 #define bfa_os_htons(_x) ((u16)((((_x) & 0xff00) >> 8) | \
 				 (((_x) & 0x00ff) << 8)))
-
 #define bfa_os_htonl(_x)	bfa_os_swap32(_x)
 #define bfa_os_htonll(_x)	bfa_swap_8b(_x)
 #define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
-
 #define bfa_os_wtole(_x)   (_x)
 #define bfa_os_sgaddr(_x)  (_x)
 
@@ -170,17 +138,16 @@ int bfa_os_MWB(void *);
 #define bfa_os_memcpy	memcpy
 #define bfa_os_udelay	udelay
 #define bfa_os_vsprintf vsprintf
+#define bfa_os_snprintf snprintf
 
 #define bfa_os_assign(__t, __s) __t = __s
-
-#define bfa_os_addr_t char __iomem *
-#define bfa_os_panic()
+#define bfa_os_addr_t void __iomem *
 
 #define bfa_os_reg_read(_raddr) readl(_raddr)
 #define bfa_os_reg_write(_raddr, _val) writel((_val), (_raddr))
-#define bfa_os_mem_read(_raddr, _off)                                   \
+#define bfa_os_mem_read(_raddr, _off)					\
 	bfa_os_swap32(readl(((_raddr) + (_off))))
-#define bfa_os_mem_write(_raddr, _off, _val)                            \
+#define bfa_os_mem_write(_raddr, _off, _val)				\
 	writel(bfa_os_swap32((_val)), ((_raddr) + (_off)))
 
 #define BFA_TRC_TS(_trcm)						\
@@ -191,11 +158,6 @@ int bfa_os_MWB(void *);
 				(tv.tv_sec*1000000+tv.tv_usec);      \
 			 })
 
-struct bfa_log_mod_s;
-void bfa_os_printf(struct bfa_log_mod_s *log_mod, u32 msg_id,
-			const char *fmt, ...);
-#endif
-
 #define boolean_t int
 
 /**
@@ -206,7 +168,15 @@ struct bfa_timeval_s {
 	u32	tv_usec;	/*  microseconds   */
 };
 
-void bfa_os_gettimeofday(struct bfa_timeval_s *tv);
+static inline void
+bfa_os_gettimeofday(struct bfa_timeval_s *tv)
+{
+	struct timeval  tmp_tv;
+
+	do_gettimeofday(&tmp_tv);
+	tv->tv_sec = (u32) tmp_tv.tv_sec;
+	tv->tv_usec = (u32) tmp_tv.tv_usec;
+}
 
 static inline void
 wwn2str(char *wwn_str, u64 wwn)
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 465b8b8..98420bb 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -28,30 +28,27 @@
 
 #include "bfa_os_inc.h"
 
-#include <bfa.h>
-#include <bfa_svc.h>
-#include <fcs/bfa_fcs.h>
-#include <defs/bfa_defs_pci.h>
-#include <defs/bfa_defs_port.h>
-#include <defs/bfa_defs_rport.h>
-#include <fcs/bfa_fcs_rport.h>
-#include <defs/bfa_defs_vport.h>
-#include <fcs/bfa_fcs_vport.h>
-
-#include <cs/bfa_plog.h>
-#include "aen/bfa_aen.h"
-#include <log/bfa_log_linux.h>
-
-#define BFAD_DRIVER_NAME        "bfa"
+#include "bfa_modules.h"
+#include "bfa_fcs.h"
+#include "bfa_defs_fcs.h"
+
+#include "bfa_plog.h"
+#include "bfa_cs.h"
+
+#define BFAD_DRIVER_NAME	"bfa"
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "2.2.2.1"
+#define BFAD_DRIVER_VERSION    "2.3.2.0"
 #endif
 
-
+#define BFAD_PROTO_NAME FCPI_NAME
 #define BFAD_IRQ_FLAGS IRQF_SHARED
 
+#ifndef FC_PORTSPEED_8GBIT
+#define FC_PORTSPEED_8GBIT 0x10
+#endif
+
 /*
  * BFAD flags
  */
@@ -62,9 +59,9 @@
 #define BFAD_HAL_START_DONE			0x00000010
 #define BFAD_PORT_ONLINE			0x00000020
 #define BFAD_RPORT_ONLINE			0x00000040
-#define BFAD_FCS_INIT_DONE                      0x00000080
-#define BFAD_HAL_INIT_FAIL                      0x00000100
-#define BFAD_FC4_PROBE_DONE                     0x00000200
+#define BFAD_FCS_INIT_DONE			0x00000080
+#define BFAD_HAL_INIT_FAIL			0x00000100
+#define BFAD_FC4_PROBE_DONE			0x00000200
 #define BFAD_PORT_DELETE			0x00000001
 
 /*
@@ -77,8 +74,8 @@
 /*
  * BFAD configuration parameter default values
  */
-#define BFAD_LUN_QUEUE_DEPTH 		32
-#define BFAD_IO_MAX_SGE 		SG_ALL
+#define BFAD_LUN_QUEUE_DEPTH	32
+#define BFAD_IO_MAX_SGE		SG_ALL
 
 #define bfad_isr_t irq_handler_t
 
@@ -87,6 +84,16 @@
 struct bfad_msix_s {
 	struct bfad_s *bfad;
 	struct msix_entry msix;
+	char name[32];
+};
+
+/*
+ * Only append to the enums defined here to avoid any versioning
+ * needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_LDRV_BFAD		= 1,
+	BFA_TRC_LDRV_IM			= 2,
 };
 
 enum bfad_port_pvb_type {
@@ -101,17 +108,13 @@ enum bfad_port_pvb_type {
  */
 struct bfad_port_s {
 	struct list_head list_entry;
-	struct bfad_s         *bfad;
-	struct bfa_fcs_port_s *fcs_port;
-	u32        roles;
-	s32         flags;
-	u32        supported_fc4s;
-	u8		ipfc_flags;
+	struct bfad_s	*bfad;
+	struct bfa_fcs_lport_s *fcs_port;
+	u32	roles;
+	s32		flags;
+	u32	supported_fc4s;
 	enum bfad_port_pvb_type pvb_type;
 	struct bfad_im_port_s *im_port;	/* IM specific data */
-	struct bfad_tm_port_s *tm_port;	/* TM specific data */
-	struct bfad_ipfc_port_s *ipfc_port;	/* IPFC specific data */
-
 	/* port debugfs specific data */
 	struct dentry *port_debugfs_root;
 };
@@ -124,7 +127,6 @@ struct bfad_vport_s {
 	struct bfa_fcs_vport_s fcs_vport;
 	struct completion *comp_del;
 	struct list_head list_entry;
-	struct bfa_port_cfg_s port_cfg;
 };
 
 /*
@@ -137,20 +139,35 @@ struct bfad_vf_s {
 };
 
 struct bfad_cfg_param_s {
-	u32        rport_del_timeout;
-	u32        ioc_queue_depth;
-	u32        lun_queue_depth;
-	u32        io_max_sge;
-	u32        binding_method;
+	u32	rport_del_timeout;
+	u32	ioc_queue_depth;
+	u32	lun_queue_depth;
+	u32	io_max_sge;
+	u32	binding_method;
+};
+
+union bfad_tmp_buf {
+	/* From struct bfa_adapter_attr_s */
+	char		manufacturer[BFA_ADAPTER_MFG_NAME_LEN];
+	char		serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
+	char		model[BFA_ADAPTER_MODEL_NAME_LEN];
+	char		fw_ver[BFA_VERSION_LEN];
+	char		optrom_ver[BFA_VERSION_LEN];
+
+	/* From struct bfa_ioc_pci_attr_s */
+	u8		chip_rev[BFA_IOC_CHIP_REV_LEN];  /*  chip revision */
+
+	wwn_t		wwn[BFA_FCS_MAX_LPORTS];
 };
 
 /*
  * BFAD (PCI function) data structure
  */
 struct bfad_s {
+	bfa_sm_t	sm;	/* state machine */
 	struct list_head list_entry;
-	struct bfa_s       bfa;
-	struct bfa_fcs_s       bfa_fcs;
+	struct bfa_s	bfa;
+	struct bfa_fcs_s bfa_fcs;
 	struct pci_dev *pcidev;
 	const char *pci_name;
 	struct bfa_pcidev_s hal_pcidev;
@@ -163,41 +180,41 @@ struct bfad_s {
 	struct bfad_port_s     pport;	/* physical port of the BFAD */
 	struct bfa_meminfo_s meminfo;
 	struct bfa_iocfc_cfg_s   ioc_cfg;
-	u32        inst_no;	/* BFAD instance number */
-	u32        bfad_flags;
+	u32	inst_no;	/* BFAD instance number */
+	u32	bfad_flags;
 	spinlock_t      bfad_lock;
 	struct task_struct *bfad_tsk;
 	struct bfad_cfg_param_s cfg_data;
 	struct bfad_msix_s msix_tab[MAX_MSIX_ENTRY];
-	int             nvec;
-	char            adapter_name[BFA_ADAPTER_SYM_NAME_LEN];
-	char            port_name[BFA_ADAPTER_SYM_NAME_LEN];
+	int		nvec;
+	char	adapter_name[BFA_ADAPTER_SYM_NAME_LEN];
+	char	port_name[BFA_ADAPTER_SYM_NAME_LEN];
 	struct timer_list hal_tmo;
 	unsigned long   hs_start;
 	struct bfad_im_s *im;		/* IM specific data */
-	struct bfad_tm_s *tm;		/* TM specific data */
-	struct bfad_ipfc_s *ipfc;	/* IPFC specific data */
-	struct bfa_log_mod_s   log_data;
 	struct bfa_trc_mod_s  *trcmod;
-	struct bfa_log_mod_s  *logmod;
-	struct bfa_aen_s      *aen;
-	struct bfa_aen_s       aen_buf;
-	void		*file_map[BFA_AEN_MAX_APP];
 	struct bfa_plog_s      plog_buf;
-	int             ref_count;
-	bfa_boolean_t	ipfc_enabled;
+	int		ref_count;
+	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
-	struct list_head pbc_pcfg_list;
-	atomic_t wq_reqcnt;
+	struct list_head pbc_vport_list;
 	/* debugfs specific data */
 	char *regdata;
 	u32 reglen;
 	struct dentry *bfad_dentry_files[5];
 };
 
-struct bfad_pcfg_s {
-	struct list_head list_entry;
-	struct bfa_port_cfg_s port_cfg;
+/* BFAD state machine events */
+enum bfad_sm_event {
+	BFAD_E_CREATE			= 1,
+	BFAD_E_KTHREAD_CREATE_FAILED	= 2,
+	BFAD_E_INIT			= 3,
+	BFAD_E_INIT_SUCCESS		= 4,
+	BFAD_E_INIT_FAILED		= 5,
+	BFAD_E_INTR_INIT_FAILED		= 6,
+	BFAD_E_FCS_EXIT_COMP		= 7,
+	BFAD_E_EXIT_COMP		= 8,
+	BFAD_E_STOP			= 9
 };
 
 /*
@@ -208,30 +225,30 @@ struct bfad_rport_s {
 };
 
 struct bfad_buf_info {
-	void           *virt;
+	void		*virt;
 	dma_addr_t      phys;
-	u32        size;
+	u32	size;
 };
 
 struct bfad_fcxp {
 	struct bfad_port_s    *port;
 	struct bfa_rport_s *bfa_rport;
 	bfa_status_t    req_status;
-	u16        tag;
-	u16        rsp_len;
-	u16        rsp_maxlen;
-	u8         use_ireqbuf;
-	u8         use_irspbuf;
-	u32        num_req_sgles;
-	u32        num_rsp_sgles;
-	struct fchs_s          fchs;
-	void           *reqbuf_info;
-	void           *rspbuf_info;
+	u16	tag;
+	u16	rsp_len;
+	u16	rsp_maxlen;
+	u8		use_ireqbuf;
+	u8		use_irspbuf;
+	u32	num_req_sgles;
+	u32	num_rsp_sgles;
+	struct fchs_s	fchs;
+	void		*reqbuf_info;
+	void		*rspbuf_info;
 	struct bfa_sge_s  *req_sge;
 	struct bfa_sge_s  *rsp_sge;
 	fcxp_send_cb_t  send_cbfn;
-	void           *send_cbarg;
-	void           *bfa_fcxp;
+	void		*send_cbarg;
+	void		*bfa_fcxp;
 	struct completion comp;
 };
 
@@ -244,34 +261,48 @@ struct bfad_hal_comp {
  * Macro to obtain the immediate lower power
  * of two for the integer.
  */
-#define nextLowerInt(x)                         	\
-do {                                            	\
-	int j;                                  	\
-	(*x)--;    		                	\
-	for (j = 1; j < (sizeof(int) * 8); j <<= 1)     \
-		(*x) = (*x) | (*x) >> j;        	\
-	(*x)++;                  	        	\
-	(*x) = (*x) >> 1;                       	\
+#define nextLowerInt(x)                         \
+do {                                            \
+	int i;                                  \
+	(*x)--;					\
+	for (i = 1; i < (sizeof(int)*8); i <<= 1) \
+		(*x) = (*x) | (*x) >> i;	\
+	(*x)++;					\
+	(*x) = (*x) >> 1;			\
 } while (0)
 
 
-bfa_status_t    bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
-			  struct bfa_port_cfg_s *port_cfg, struct device *dev);
-bfa_status_t    bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
-			       struct bfa_port_cfg_s *port_cfg);
-bfa_status_t    bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role);
-bfa_status_t    bfad_drv_init(struct bfad_s *bfad);
-bfa_status_t	bfad_start_ops(struct bfad_s *bfad);
-void            bfad_drv_start(struct bfad_s *bfad);
-void            bfad_uncfg_pport(struct bfad_s *bfad);
-void            bfad_drv_stop(struct bfad_s *bfad);
-void            bfad_remove_intr(struct bfad_s *bfad);
-void            bfad_hal_mem_release(struct bfad_s *bfad);
-void            bfad_hcb_comp(void *arg, bfa_status_t status);
-
-int             bfad_setup_intr(struct bfad_s *bfad);
-void            bfad_remove_intr(struct bfad_s *bfad);
+#define list_remove_head(list, entry, type, member)		\
+do {								\
+	entry = NULL;                                           \
+	if (!list_empty(list)) {                                \
+		entry = list_entry((list)->next, type, member);	\
+		list_del_init(&entry->member);			\
+	}							\
+} while (0)
 
+#define list_get_first(list, type, member)				\
+((list_empty(list)) ? NULL :						\
+	list_entry((list)->next, type, member))
+
+bfa_status_t	bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
+				  struct bfa_lport_cfg_s *port_cfg,
+				  struct device *dev);
+bfa_status_t	bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
+			       struct bfa_lport_cfg_s *port_cfg);
+bfa_status_t	bfad_cfg_pport(struct bfad_s *bfad, enum bfa_lport_role role);
+bfa_status_t	bfad_drv_init(struct bfad_s *bfad);
+bfa_status_t	bfad_start_ops(struct bfad_s *bfad);
+void		bfad_drv_start(struct bfad_s *bfad);
+void		bfad_uncfg_pport(struct bfad_s *bfad);
+void		bfad_stop(struct bfad_s *bfad);
+void		bfad_fcs_stop(struct bfad_s *bfad);
+void		bfad_remove_intr(struct bfad_s *bfad);
+void		bfad_hal_mem_release(struct bfad_s *bfad);
+void		bfad_hcb_comp(void *arg, bfa_status_t status);
+
+int		bfad_setup_intr(struct bfad_s *bfad);
+void		bfad_remove_intr(struct bfad_s *bfad);
 void		bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg);
 bfa_status_t	bfad_hal_mem_alloc(struct bfad_s *bfad);
 void		bfad_bfa_tmo(unsigned long data);
@@ -280,9 +311,6 @@ int		bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad);
 void		bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad);
 void		bfad_fcs_port_cfg(struct bfad_s *bfad);
 void		bfad_drv_uninit(struct bfad_s *bfad);
-void		bfad_drv_log_level_set(struct bfad_s *bfad);
-bfa_status_t	bfad_fc4_module_init(void);
-void		bfad_fc4_module_exit(void);
 int		bfad_worker(void *ptr);
 void		bfad_debugfs_init(struct bfad_port_s *port);
 void		bfad_debugfs_exit(struct bfad_port_s *port);
@@ -294,10 +322,30 @@ int bfad_os_get_linkup_delay(struct bfad_s *bfad);
 int bfad_install_msix_handler(struct bfad_s *bfad);
 
 extern struct idr bfad_im_port_index;
+extern struct pci_device_id bfad_id_table[];
 extern struct list_head bfad_list;
-extern int bfa_lun_queue_depth;
-extern int bfad_supported_fc4s;
-extern int bfa_linkup_delay;
+extern char	*os_name;
+extern char	*os_patch;
+extern char	*host_name;
+extern int	num_rports;
+extern int	num_ios;
+extern int	num_tms;
+extern int	num_fcxps;
+extern int	num_ufbufs;
+extern int	reqq_size;
+extern int	rspq_size;
+extern int	num_sgpgs;
+extern int      rport_del_timeout;
+extern int      bfa_lun_queue_depth;
+extern int      bfa_io_max_sge;
+extern int      log_level;
+extern int      ioc_auto_recover;
+extern int      bfa_linkup_delay;
+extern int      msix_disable_cb;
+extern int      msix_disable_ct;
+extern int      fdmi_enable;
+extern int      supported_fc4s;
+extern int	pcie_max_read_reqsz;
 extern int bfa_debugfs_enable;
 extern struct mutex bfad_mutex;
 
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 973cab4..b038c0e 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -18,20 +18,20 @@
 #ifndef __BFAD_IM_H__
 #define __BFAD_IM_H__
 
-#include "fcs/bfa_fcs_fcpim.h"
-#include "bfad_im_compat.h"
+#include "bfa_fcs.h"
 
 #define FCPI_NAME " fcpim"
 
+#ifndef KOBJ_NAME_LEN
+#define KOBJ_NAME_LEN           20
+#endif
+
 bfa_status_t bfad_im_module_init(void);
 void bfad_im_module_exit(void);
 bfa_status_t bfad_im_probe(struct bfad_s *bfad);
 void bfad_im_probe_undo(struct bfad_s *bfad);
-void bfad_im_probe_post(struct bfad_im_s *im);
 bfa_status_t bfad_im_port_new(struct bfad_s *bfad, struct bfad_port_s *port);
 void bfad_im_port_delete(struct bfad_s *bfad, struct bfad_port_s *port);
-void bfad_im_port_online(struct bfad_s *bfad, struct bfad_port_s *port);
-void bfad_im_port_offline(struct bfad_s *bfad, struct bfad_port_s *port);
 void bfad_im_port_clean(struct bfad_im_port_s *im_port);
 int  bfad_im_scsi_host_alloc(struct bfad_s *bfad,
 		struct bfad_im_port_s *im_port, struct device *dev);
@@ -44,14 +44,10 @@ void bfad_im_scsi_host_free(struct bfad_s *bfad,
 #define BFAD_LUN_RESET_TMO 60
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define BFA_QUEUE_FULL_RAMP_UP_TIME 120
-#define BFAD_KOBJ_NAME_LEN 20
 
 /*
  * itnim flags
  */
-#define ITNIM_MAPPED		0x00000001
-
-#define SCSI_TASK_MGMT		0x00000001
 #define IO_DONE_BIT			0
 
 struct bfad_itnim_data_s {
@@ -64,7 +60,7 @@ struct bfad_im_port_s {
 	struct work_struct port_delete_work;
 	int             idr_id;
 	u16        cur_scsi_id;
-	u16	   flags;
+	u16	flags;
 	struct list_head binding_list;
 	struct Scsi_Host *shost;
 	struct list_head itnim_mapped_list;
@@ -118,14 +114,13 @@ struct bfad_fcp_binding {
 struct bfad_im_s {
 	struct bfad_s         *bfad;
 	struct workqueue_struct *drv_workq;
-	char   drv_workq_name[BFAD_KOBJ_NAME_LEN];
+	char            drv_workq_name[KOBJ_NAME_LEN];
 };
 
 struct Scsi_Host *bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port,
 				struct bfad_s *);
 bfa_status_t bfad_os_thread_workq(struct bfad_s *bfad);
 void bfad_os_destroy_workq(struct bfad_im_s *im);
-void bfad_os_itnim_process(struct bfad_itnim_s *itnim_drv);
 void bfad_os_fc_host_init(struct bfad_im_port_s *im_port);
 void bfad_os_scsi_host_free(struct bfad_s *bfad,
 				 struct bfad_im_port_s *im_port);
@@ -133,11 +128,6 @@ void bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim,
 				 struct scsi_device *sdev);
 void bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev);
 struct bfad_itnim_s *bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id);
-int bfad_os_scsi_add_host(struct Scsi_Host *shost,
-		struct bfad_im_port_s *im_port, struct bfad_s *bfad);
-
-void bfad_im_itnim_unmap(struct bfad_im_port_s  *im_port,
-			 struct bfad_itnim_s *itnim);
 
 extern struct scsi_host_template bfad_im_scsi_host_template;
 extern struct scsi_host_template bfad_im_vport_template;
@@ -146,4 +136,34 @@ extern struct fc_function_template bfad_im_vport_fc_function_template;
 extern struct scsi_transport_template *bfad_im_scsi_transport_template;
 extern struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 
+extern struct device_attribute *bfad_im_host_attrs[];
+extern struct device_attribute *bfad_im_vport_attrs[];
+
+irqreturn_t bfad_intx(int irq, void *dev_id);
+
+/* Firmware releated */
+#define BFAD_FW_FILE_CT_FC      "ctfw_fc.bin"
+#define BFAD_FW_FILE_CT_CNA     "ctfw_cna.bin"
+#define BFAD_FW_FILE_CB_FC      "cbfw_fc.bin"
+
+u32 *bfad_get_firmware_buf(struct pci_dev *pdev);
+u32 *bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
+		u32 *bfi_image_size, char *fw_name);
+
+static inline u32 *
+bfad_load_fwimg(struct pci_dev *pdev)
+{
+	return bfad_get_firmware_buf(pdev);
+}
+
+static inline void
+bfad_free_fwimg(void)
+{
+	if (bfi_image_ct_fc_size && bfi_image_ct_fc)
+		vfree(bfi_image_ct_fc);
+	if (bfi_image_ct_cna_size && bfi_image_ct_cna)
+		vfree(bfi_image_ct_cna);
+	if (bfi_image_cb_fc_size && bfi_image_cb_fc)
+		vfree(bfi_image_cb_fc);
+}
 #endif
-- 
1.7.3.rc1

