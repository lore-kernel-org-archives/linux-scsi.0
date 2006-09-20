From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptspi: Bug fix to prevent infinite nested domainvalidation
Date: Tue, 19 Sep 2006 18:35:51 -0600
Message-ID: <20060920003550.GA1154@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38029 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750726AbWITAiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 20:38:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, markh@osdl.org

>From host_reset, this patch will complete domain validation
in the same context as the eh threads.  I've added passing
the sleepFlag, which is CAN_SLEEP in the context of eh threads.

Mark pls try this with the patch that James posted earlier that
prevents re entry to pending dv.


diff -uarpN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2006-09-13 14:04:04.000000000 -0600
+++ a/drivers/message/fusion/Makefile	2006-09-19 18:30:55.000000000 -0600
@@ -8,6 +8,7 @@
 #EXTRA_CFLAGS += -DMPT_DEBUG_INIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_EXIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
+#EXTRA_CFLAGS += -DMPT_DEBUG_TM
 
 #
 # driver/module specifics...
@@ -22,7 +23,6 @@
 #  For mptscsih:
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_DV
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_NEGO
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_TM
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_SCSI
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_REPLY
 #
diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-09-13 14:04:05.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-09-19 18:18:51.000000000 -0600
@@ -1552,7 +1552,7 @@ mpt_resume(struct pci_dev *pdev)
 #endif
 
 static int
-mpt_signal_reset(int index, MPT_ADAPTER *ioc, int reset_phase)
+mpt_signal_reset(int index, MPT_ADAPTER *ioc, int reset_phase, int sleepFlag)
 {
 	if ((MptDriverClass[index] == MPTSPI_DRIVER &&
 	     ioc->bus_type != SPI) ||
@@ -1563,7 +1563,7 @@ mpt_signal_reset(int index, MPT_ADAPTER 
 		/* make sure we only call the relevant reset handler
 		 * for the bus */
 		return 0;
-	return (MptResetHandlers[index])(ioc, reset_phase);
+	return (MptResetHandlers[index])(ioc, reset_phase, sleepFlag);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1869,14 +1869,14 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 			if ((ret == 0) && MptResetHandlers[ii]) {
 				dprintk((MYIOC_s_INFO_FMT "Calling IOC post_reset handler #%d\n",
 						ioc->name, ii));
-				rc += mpt_signal_reset(ii, ioc, MPT_IOC_POST_RESET);
+				rc += mpt_signal_reset(ii, ioc, MPT_IOC_POST_RESET, sleepFlag);
 				handlers++;
 			}
 
 			if (alt_ioc_ready && MptResetHandlers[ii]) {
 				drsprintk((MYIOC_s_INFO_FMT "Calling alt-%s post_reset handler #%d\n",
 						ioc->name, ioc->alt_ioc->name, ii));
-				rc += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_POST_RESET);
+				rc += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_POST_RESET, sleepFlag);
 				handlers++;
 			}
 		}
@@ -3292,11 +3292,12 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 				if (MptResetHandlers[ii]) {
 					dprintk((MYIOC_s_INFO_FMT "Calling IOC pre_reset handler #%d\n",
 							ioc->name, ii));
-					r += mpt_signal_reset(ii, ioc, MPT_IOC_PRE_RESET);
+					r += mpt_signal_reset(ii, ioc, MPT_IOC_PRE_RESET, sleepFlag);
 					if (ioc->alt_ioc) {
 						dprintk((MYIOC_s_INFO_FMT "Calling alt-%s pre_reset handler #%d\n",
 								ioc->name, ioc->alt_ioc->name, ii));
-						r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_PRE_RESET);
+						r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_PRE_RESET,
+						    sleepFlag);
 					}
 				}
 			}
@@ -5219,11 +5220,12 @@ mpt_timer_expired(unsigned long data)
  *	mpt_ioc_reset - Base cleanup for hard reset
  *	@ioc: Pointer to the adapter structure
  *	@reset_phase: Indicates pre- or post-reset functionality
+ *	@sleepFlag: Indicates if sleep or schedule must be called.
  *
  *	Remark: Free's resources with internally generated commands.
  */
 static int
-mpt_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+mpt_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag)
 {
 	CONFIGPARMS *pCfg;
 	unsigned long flags;
@@ -5632,11 +5634,11 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 			if (MptResetHandlers[ii]) {
 				dtmprintk((MYIOC_s_INFO_FMT "Calling IOC reset_setup handler #%d\n",
 						ioc->name, ii));
-				r += mpt_signal_reset(ii, ioc, MPT_IOC_SETUP_RESET);
+				r += mpt_signal_reset(ii, ioc, MPT_IOC_SETUP_RESET, sleepFlag);
 				if (ioc->alt_ioc) {
 					dtmprintk((MYIOC_s_INFO_FMT "Calling alt-%s setup reset handler #%d\n",
 							ioc->name, ioc->alt_ioc->name, ii));
-					r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
+					r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_SETUP_RESET, sleepFlag);
 				}
 			}
 		}
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-09-13 14:04:05.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-09-19 18:04:23.000000000 -0600
@@ -652,7 +652,7 @@ typedef struct _MPT_ADAPTER
  */
 typedef int (*MPT_CALLBACK)(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
 typedef int (*MPT_EVHANDLER)(MPT_ADAPTER *ioc, EventNotificationReply_t *evReply);
-typedef int (*MPT_RESETHANDLER)(MPT_ADAPTER *ioc, int reset_phase);
+typedef int (*MPT_RESETHANDLER)(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag);
 /* reset_phase defs */
 #define MPT_IOC_PRE_RESET		0
 #define MPT_IOC_POST_RESET		1
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2006-09-13 14:04:05.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2006-09-19 18:16:46.000000000 -0600
@@ -134,7 +134,7 @@ static void mptctl_free_tm_flags(MPT_ADA
 /*
  * Reset Handler cleanup function
  */
-static int  mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase);
+static int  mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag);
 
 /*
  * Event Handler function
@@ -452,7 +452,7 @@ mptctl_free_tm_flags(MPT_ADAPTER *ioc)
  *
  */
 static int
-mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag)
 {
 	MPT_IOCTL *ioctl = ioc->ioctl;
 	dctlprintk((KERN_INFO MYNAM ": IOC %s_reset routed to IOCTL driver!\n",
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2006-09-13 14:04:05.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2006-09-19 18:01:03.000000000 -0600
@@ -1271,12 +1271,12 @@ mptfc_event_process(MPT_ADAPTER *ioc, Ev
 }
 
 static int
-mptfc_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+mptfc_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag)
 {
 	int		rc;
 	unsigned long	flags;
 
-	rc = mptscsih_ioc_reset(ioc,reset_phase);
+	rc = mptscsih_ioc_reset(ioc, reset_phase, sleepFlag);
 	if (rc == 0)
 		return rc;
 
diff -uarpN b/drivers/message/fusion/mptlan.c a/drivers/message/fusion/mptlan.c
--- b/drivers/message/fusion/mptlan.c	2006-09-13 14:04:05.000000000 -0600
+++ a/drivers/message/fusion/mptlan.c	2006-09-19 18:09:24.000000000 -0600
@@ -141,7 +141,7 @@ static int  mpt_lan_receive_post_reply(s
 static int  mpt_lan_send_turbo(struct net_device *dev, u32 tmsg);
 static int  mpt_lan_send_reply(struct net_device *dev,
 			       LANSendReply_t *pSendRep);
-static int  mpt_lan_ioc_reset(MPT_ADAPTER *ioc, int reset_phase);
+static int  mpt_lan_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag);
 static int  mpt_lan_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 static unsigned short mpt_lan_type_trans(struct sk_buff *skb,
 					 struct net_device *dev);
@@ -309,7 +309,7 @@ lan_reply (MPT_ADAPTER *ioc, MPT_FRAME_H
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-mpt_lan_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+mpt_lan_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag)
 {
 	struct net_device *dev = ioc->netdev;
 	struct mpt_lan_priv *priv;
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-09-13 14:04:04.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-09-19 17:59:59.000000000 -0600
@@ -132,7 +132,7 @@ static int	SCPNT_TO_LOOKUP_IDX(struct sc
 
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
 
-int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
+int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset, int sleepFlag);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
 static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
@@ -2514,7 +2514,7 @@ SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 int
-mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag)
 {
 	MPT_SCSI_HOST	*hd;
 	unsigned long	 flags;
diff -uarpN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2006-09-13 14:04:04.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.h	2006-09-19 18:07:39.000000000 -0600
@@ -95,7 +95,7 @@ extern int mptscsih_io_done(MPT_ADAPTER 
 extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
-extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
+extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset, int sleepFlag);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-09-13 14:04:05.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-09-19 18:35:51.000000000 -0600
@@ -814,15 +814,21 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_H
  * spi module reset handler
  */
 static int
-mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase, int sleepFlag)
 {
 	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	struct scsi_device *sdev;
 	int rc;
 
-	rc = mptscsih_ioc_reset(ioc, reset_phase);
+	rc = mptscsih_ioc_reset(ioc, reset_phase, sleepFlag);
 
-	if (reset_phase == MPT_IOC_POST_RESET)
-		mptspi_dv_renegotiate(hd);
+	if (reset_phase == MPT_IOC_POST_RESET) {
+		if (sleepFlag == CAN_SLEEP) {
+			shost_for_each_device(sdev, hd->ioc->sh)
+				mptspi_dv_device(hd, sdev);
+		} else
+			mptspi_dv_renegotiate(hd);
+	}
 
 	return rc;
 }

