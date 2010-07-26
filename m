From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/03] mptfusion: Extra debug prints added relavent to Device missing delay error handling
Date: Mon, 26 Jul 2010 18:57:36 +0530
Message-ID: <20100726132724.GC23066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56395 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab0GZOFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 10:05:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Adding function name in original debug prints and few more debug prints are
added.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e319abc..8280039 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -115,6 +115,7 @@ MODULE_PARM_DESC(mpt_fwfault_debug, "Enable detection of Firmware fault"
 	" and halt Firmware on fault - (default=0)");
 
 
+static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -213,7 +214,7 @@ static int	ProcessEventNotification(MPT_ADAPTER *ioc,
 static void	mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf);
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info);
-static void	mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info);
+static void	mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info , u8 cb_idx);
 static int	mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
 static void	mpt_inactive_raid_list_free(MPT_ADAPTER *ioc);
 
@@ -490,7 +491,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 		else if (ioc->bus_type == SPI)
 			mpt_spi_log_info(ioc, log_info);
 		else if (ioc->bus_type == SAS)
-			mpt_sas_log_info(ioc, log_info);
+			mpt_sas_log_info(ioc, log_info, cb_idx);
 	}
 
 	if (ioc_stat & MPI_IOCSTATUS_MASK)
@@ -644,7 +645,7 @@ mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
  *	considered an error by the caller.
  */
 u8
-mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass)
+mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass, char *func_name)
 {
 	u8 cb_idx;
 	last_drv_idx = MPT_MAX_PROTOCOL_DRIVERS;
@@ -659,6 +660,8 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass)
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
 			last_drv_idx = cb_idx;
+			memcpy(MptCallbacksName[cb_idx], func_name,
+			    strlen(func_name) > 50 ? 50 : strlen(func_name));
 			break;
 		}
 	}
@@ -8002,7 +8005,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info)
  *	Refer to lsi/mpi_log_sas.h.
  **/
 static void
-mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info)
+mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info, u8 cb_idx)
 {
 union loginfo_type {
 	u32	loginfo;
@@ -8056,21 +8059,22 @@ union loginfo_type {
 	if (sub_code_desc != NULL)
 		printk(MYIOC_s_INFO_FMT
 			"LogInfo(0x%08x): Originator={%s}, Code={%s},"
-			" SubCode={%s}\n",
+			" SubCode={%s} cb_idx %s\n",
 			ioc->name, log_info, originator_desc, code_desc,
-			sub_code_desc);
+			sub_code_desc, MptCallbacksName[cb_idx]);
 	else if (code_desc != NULL)
 		printk(MYIOC_s_INFO_FMT
 			"LogInfo(0x%08x): Originator={%s}, Code={%s},"
-			" SubCode(0x%04x)\n",
+			" SubCode(0x%04x) cb_idx %s\n",
 			ioc->name, log_info, originator_desc, code_desc,
-			sas_loginfo.dw.subcode);
+			sas_loginfo.dw.subcode, MptCallbacksName[cb_idx]);
 	else
 		printk(MYIOC_s_INFO_FMT
 			"LogInfo(0x%08x): Originator={%s}, Code=(0x%02x),"
-			" SubCode(0x%04x)\n",
+			" SubCode(0x%04x) cb_idx %s\n",
 			ioc->name, log_info, originator_desc,
-			sas_loginfo.dw.code, sas_loginfo.dw.subcode);
+			sas_loginfo.dw.code, sas_loginfo.dw.subcode,
+			MptCallbacksName[cb_idx]);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -8435,7 +8439,8 @@ fusion_init(void)
 	/*  Register ourselves (mptbase) in order to facilitate
 	 *  EventNotification handling.
 	 */
-	mpt_base_index = mpt_register(mptbase_reply, MPTBASE_DRIVER);
+	mpt_base_index = mpt_register(mptbase_reply, MPTBASE_DRIVER,
+	    "mptbase_reply");
 
 	/* Register for hard reset handling callbacks.
 	 */
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 7f31973..0b23c42 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -926,7 +926,8 @@ extern void	 mpt_detach(struct pci_dev *pdev);
 extern int	 mpt_suspend(struct pci_dev *pdev, pm_message_t state);
 extern int	 mpt_resume(struct pci_dev *pdev);
 #endif
-extern u8	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass);
+extern u8	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass,
+		char *func_name);
 extern void	 mpt_deregister(u8 cb_idx);
 extern int	 mpt_event_register(u8 cb_idx, MPT_EVHANDLER ev_cbfunc);
 extern void	 mpt_event_deregister(u8 cb_idx);
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 40046f5..d8ddfdf 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -3018,7 +3018,8 @@ static int __init mptctl_init(void)
 	 *  Install our handler
 	 */
 	++where;
-	mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER);
+	mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER,
+	    "mptctl_reply");
 	if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
 		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
 		misc_deregister(&mptctl_miscdev);
@@ -3026,7 +3027,8 @@ static int __init mptctl_init(void)
 		goto out_fail;
 	}
 
-	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER);
+	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER,
+	    "mptctl_taskmgmt_reply");
 	if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >= MPT_MAX_PROTOCOL_DRIVERS) {
 		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
 		mpt_deregister(mptctl_id);
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index b5f03ad..e15220f 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1472,9 +1472,12 @@ mptfc_init(void)
 	if (!mptfc_transport_template)
 		return -ENODEV;
 
-	mptfcDoneCtx = mpt_register(mptscsih_io_done, MPTFC_DRIVER);
-	mptfcTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTFC_DRIVER);
-	mptfcInternalCtx = mpt_register(mptscsih_scandv_complete, MPTFC_DRIVER);
+	mptfcDoneCtx = mpt_register(mptscsih_io_done, MPTFC_DRIVER,
+	    "mptscsih_scandv_complete");
+	mptfcTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTFC_DRIVER,
+	    "mptscsih_scandv_complete");
+	mptfcInternalCtx = mpt_register(mptscsih_scandv_complete, MPTFC_DRIVER,
+	    "mptscsih_scandv_complete");
 
 	mpt_event_register(mptfcDoneCtx, mptfc_event_process);
 	mpt_reset_register(mptfcDoneCtx, mptfc_ioc_reset);
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 4fa9665..cbe9607 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1452,7 +1452,9 @@ static int __init mpt_lan_init (void)
 {
 	show_mptmod_ver(LANAME, LANVER);
 
-	if ((LanCtx = mpt_register(lan_reply, MPTLAN_DRIVER)) <= 0) {
+	LanCtx = mpt_register(lan_reply, MPTLAN_DRIVER,
+				"lan_reply");
+	if (LanCtx <= 0) {
 		printk (KERN_ERR MYNAM ": Failed to register with MPT base driver\n");
 		return -EBUSY;
 	}
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 235113a..83a5115 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5368,13 +5368,18 @@ mptsas_init(void)
 		return -ENODEV;
 	mptsas_transport_template->eh_timed_out = mptsas_eh_timed_out;
 
-	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER);
-	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER);
+	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER,
+	    "mptscsih_io_done");
+	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER,
+	    "mptscsih_taskmgmt_complete");
 	mptsasInternalCtx =
-		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
-	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER);
+		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER,
+		    "mptscsih_scandv_complete");
+	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER,
+	    "mptsas_mgmt_done");
 	mptsasDeviceResetCtx =
-		mpt_register(mptsas_taskmgmt_complete, MPTSAS_DRIVER);
+		mpt_register(mptsas_taskmgmt_complete, MPTSAS_DRIVER,
+		    "mptsas_taskmgmt_complete");
 
 	mpt_event_register(mptsasDoneCtx, mptsas_event_process);
 	mpt_reset_register(mptsasDoneCtx, mptsas_ioc_reset);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 1abaa5d..0e28031 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1551,9 +1551,12 @@ mptspi_init(void)
 	if (!mptspi_transport_template)
 		return -ENODEV;
 
-	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER);
-	mptspiTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER);
-	mptspiInternalCtx = mpt_register(mptscsih_scandv_complete, MPTSPI_DRIVER);
+	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER,
+	    "mptscsih_io_done");
+	mptspiTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER,
+	    "mptscsih_taskmgmt_complete");
+	mptspiInternalCtx = mpt_register(mptscsih_scandv_complete,
+	    MPTSPI_DRIVER, "mptscsih_scandv_complete");
 
 	mpt_event_register(mptspiDoneCtx, mptspi_event_process);
 	mpt_reset_register(mptspiDoneCtx, mptspi_ioc_reset);
