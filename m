From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 8/9] mptfusion: misc fix's
Date: Tue, 11 Jul 2006 17:34:01 -0600
Message-ID: <20060711233401.GC8622@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62930 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932246AbWGKXqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:46:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

* removing obsolete 1066, 1066E from Kconfig
* initializing aen_event_read_flag after host reset
* remove oem references
* remove obsolete mpt_pq_filter command line option

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/Kconfig a/drivers/message/fusion/Kconfig
--- b/drivers/message/fusion/Kconfig	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/Kconfig	2006-07-05 16:59:47.000000000 -0600
@@ -48,10 +48,8 @@ config FUSION_SAS
 	  List of supported controllers:
 
 	  LSISAS1064
-	  LSISAS1066
 	  LSISAS1068
 	  LSISAS1064E
-	  LSISAS1066E
 	  LSISAS1068E
 
 config FUSION_MAX_SGE
diff -uarpN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2006-07-10 11:28:52.000000000 -0600
+++ a/drivers/message/fusion/Makefile	2006-07-11 12:16:47.000000000 -0600
@@ -9,7 +9,6 @@
 #EXTRA_CFLAGS += -DMPT_DEBUG_EXIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
 
-
 #
 # driver/module specifics...
 #
diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-07-11 13:03:29.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-07-11 12:21:27.000000000 -0600
@@ -1054,9 +1054,8 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pI
 
 				dinitprintk((MYIOC_s_INFO_FMT
 				    "host_page_buffer @ %p, dma @ %x, sz=%d bytes\n",
-				    ioc->name,
-				    ioc->HostPageBuffer,
-				    ioc->HostPageBuffer_dma,
+				    ioc->name, ioc->HostPageBuffer,
+				    (u32)ioc->HostPageBuffer_dma,
 				    host_page_buffer_sz));
 				ioc->alloc_total += host_page_buffer_sz;
 				ioc->HostPageBuffer_sz = host_page_buffer_sz;
@@ -1378,6 +1377,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		printk(KERN_WARNING MYNAM
 		  ": WARNING - %s did not initialize properly! (%d)\n",
 		  ioc->name, r);
+
 		list_del(&ioc->list);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
@@ -2668,6 +2668,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 	dinitprintk((MYIOC_s_INFO_FMT "INFO - Wait IOC_OPERATIONAL state (cnt=%d)\n",
 			ioc->name, count));
 
+	ioc->aen_event_read_flag=0;
 	return r;
 }
 
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-07-11 12:56:42.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-07-11 13:08:04.000000000 -0600
@@ -981,7 +981,6 @@ typedef struct _MPT_SCSI_HOST {
 	wait_queue_head_t	  scandv_waitq;
 	int			  scandv_wait_done;
 	long			  last_queue_full;
-	u8			  mpt_pq_filter;
 	u16			  tm_iocstatus;
 } MPT_SCSI_HOST;
 
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2006-07-06 14:10:45.000000000 -0600
@@ -2332,7 +2332,7 @@ done_free_mem:
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* Prototype Routine for the HP HOST INFO command.
+/* Prototype Routine for the HOST INFO command.
  *
  * Outputs:	None.
  * Return:	0 if successful
@@ -2568,7 +2568,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* Prototype Routine for the HP TARGET INFO command.
+/* Prototype Routine for the TARGET INFO command.
  *
  * Outputs:	None.
  * Return:	0 if successful
diff -uarpN b/drivers/message/fusion/mptctl.h a/drivers/message/fusion/mptctl.h
--- b/drivers/message/fusion/mptctl.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/mptctl.h	2006-07-06 14:09:34.000000000 -0600
@@ -354,9 +354,6 @@ struct mpt_ioctl_command32 {
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *	HP Specific IOCTL Defines and Structures
- */
 
 #define CPQFCTS_IOC_MAGIC 'Z'
 #define HP_IOC_MAGIC 'Z'
@@ -364,8 +361,6 @@ struct mpt_ioctl_command32 {
 #define HP_GETHOSTINFO1		_IOR(HP_IOC_MAGIC, 20, hp_host_info_rev0_t)
 #define HP_GETTARGETINFO	_IOR(HP_IOC_MAGIC, 21, hp_target_info_t)
 
-/* All HP IOCTLs must include this header
- */
 typedef struct _hp_header {
 	unsigned int iocnum;
 	unsigned int host;
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2006-07-10 11:28:52.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2006-07-11 13:07:56.000000000 -0600
@@ -77,10 +77,6 @@ MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
 
 /* Command line args */
-static int mpt_pq_filter = 0;
-module_param(mpt_pq_filter, int, 0);
-MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
-
 #define MPTFC_DEV_LOSS_TMO (60)
 static int mptfc_dev_loss_tmo = MPTFC_DEV_LOSS_TMO;	/* reasonable default */
 module_param(mptfc_dev_loss_tmo, int, 0);
@@ -513,8 +509,7 @@ mptfc_slave_alloc(struct scsi_device *sd
 
 	if (vtarget->num_luns == 0) {
 		vtarget->ioc_id = hd->ioc->id;
-		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES |
-		    		  MPT_TARGET_FLAGS_VALID_INQUIRY;
+		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
 		hd->Targets[sdev->id] = vtarget;
 	}
 
@@ -1129,13 +1124,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	hd->timer.data = (unsigned long) hd;
 	hd->timer.function = mptscsih_timer_expired;
 
-	hd->mpt_pq_filter = mpt_pq_filter;
-
-	ddvprintk((MYIOC_s_INFO_FMT
-		"mpt_pq_filter %x\n",
-		ioc->name, 
-		mpt_pq_filter));
-
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-07-11 16:46:06.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-07-11 16:46:32.000000000 -0600
@@ -76,16 +76,10 @@ MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
 
-static int mpt_pq_filter;
-module_param(mpt_pq_filter, int, 0);
-MODULE_PARM_DESC(mpt_pq_filter,
-		"Enable peripheral qualifier filter: enable=1  "
-		"(default=0)");
-
 static int mpt_pt_clear;
 module_param(mpt_pt_clear, int, 0);
 MODULE_PARM_DESC(mpt_pt_clear,
-		"Clear persistency table: enable=1  "
+		" Clear persistency table: enable=1  "
 		"(default=MPTSCSIH_PT_CLEAR=0)");
 
 static int	mptsasDoneCtx = -1;
@@ -2755,7 +2749,6 @@ mptsas_probe(struct pci_dev *pdev, const
 	hd->timer.data = (unsigned long) hd;
 	hd->timer.function = mptscsih_timer_expired;
 
-	hd->mpt_pq_filter = mpt_pq_filter;
 	ioc->sas_data.ptClear = mpt_pt_clear;
 
 	if (ioc->sas_data.ptClear==1) {
@@ -2763,12 +2756,6 @@ mptsas_probe(struct pci_dev *pdev, const
 		    ioc, MPI_SAS_OP_CLEAR_ALL_PERSISTENT);
 	}
 
-	ddvprintk((MYIOC_s_INFO_FMT
-		"mpt_pq_filter %x mpt_pq_filter %x\n",
-		ioc->name,
-		mpt_pq_filter,
-		mpt_pq_filter));
-
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-07-10 11:28:52.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-07-11 13:07:11.000000000 -0600
@@ -83,10 +83,6 @@ static int mpt_saf_te = MPTSCSIH_SAF_TE;
 module_param(mpt_saf_te, int, 0);
 MODULE_PARM_DESC(mpt_saf_te, " Force enabling SEP Processor: enable=1  (default=MPTSCSIH_SAF_TE=0)");
 
-static int mpt_pq_filter = 0;
-module_param(mpt_pq_filter, int, 0);
-MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
-
 static void mptspi_write_offset(struct scsi_target *, int);
 static void mptspi_write_width(struct scsi_target *, int);
 static int mptspi_write_spi_device_pg1(struct scsi_target *,
@@ -1047,14 +1043,12 @@ mptspi_probe(struct pci_dev *pdev, const
 	hd->timer.function = mptscsih_timer_expired;
 
 	ioc->spi_data.Saf_Te = mpt_saf_te;
-	hd->mpt_pq_filter = mpt_pq_filter;
 
 	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 	ddvprintk((MYIOC_s_INFO_FMT
-		"saf_te %x mpt_pq_filter %x\n",
+		"saf_te %x\n",
 		ioc->name,
-		mpt_saf_te,
-		mpt_pq_filter));
+		mpt_saf_te));
 	ioc->spi_data.noQas = 0;
 
 	init_waitqueue_head(&hd->scandv_waitq);
