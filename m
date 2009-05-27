From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/22] mpt fusion: RESEND [2.6.30-rc6] Optimized SendEvent notification Using Doorbell instead of FIFO
Date: Wed, 27 May 2009 17:51:11 +0530
Message-ID: <20090527122105.GD20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:59898 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760223AbZE0MmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 08:42:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


SendEventNotification was handled through FIFO, now it is using doorbell 
to communicate with hardware. Added Sleep Flag as an extra argument to support Can-Sleep 
feature.
Resending patch including compilation error fix reviewed by Grant Grundler.

Signed-off-by: Kashyap Desai <kadesai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 54326e0..0d2fb0e 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -192,7 +192,8 @@ static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
 static void 	mpt_read_ioc_pg_4(MPT_ADAPTER *ioc);
 static void	mpt_timer_expired(unsigned long data);
 static void	mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc);
-static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
+static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch,
+	int sleepFlag);
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
 static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag);
 static int	mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init);
@@ -208,7 +209,8 @@ static int	procmpt_iocinfo_read(char *buf, char **start, off_t offset,
 static void	mpt_get_fw_exp_ver(char *buf, MPT_ADAPTER *ioc);
 
 //int		mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
-static int	ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *evReply, int *evHandlers);
+static int	ProcessEventNotification(MPT_ADAPTER *ioc,
+		EventNotificationReply_t *evReply, int *evHandlers);
 static void	mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf);
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info);
@@ -2472,28 +2474,36 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		}
 	}
 
+	/*  Enable MPT base driver management of EventNotification
+	 *  and EventAck handling.
+	 */
+	if ((ret == 0) && (!ioc->facts.EventState)) {
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+			"SendEventNotification\n",
+		    ioc->name));
+		ret = SendEventNotification(ioc, 1, sleepFlag);	/* 1=Enable */
+	}
+
+	if (ioc->alt_ioc && alt_ioc_ready && !ioc->alt_ioc->facts.EventState)
+		rc = SendEventNotification(ioc->alt_ioc, 1, sleepFlag);
+
 	if (ret == 0) {
 		/* Enable! (reply interrupt) */
 		CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
 		ioc->active = 1;
 	}
-
-	if (reset_alt_ioc_active && ioc->alt_ioc) {
-		/* (re)Enable alt-IOC! (reply interrupt) */
-		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "alt_ioc reply irq re-enabled\n",
-		    ioc->alt_ioc->name));
-		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
-		ioc->alt_ioc->active = 1;
+	if (rc == 0) {	/* alt ioc */
+		if (reset_alt_ioc_active && ioc->alt_ioc) {
+			/* (re)Enable alt-IOC! (reply interrupt) */
+			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "alt-ioc"
+				"reply irq re-enabled\n",
+				ioc->alt_ioc->name));
+			CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask,
+				MPI_HIM_DIM);
+			ioc->alt_ioc->active = 1;
+		}
 	}
 
-	/*  Enable MPT base driver management of EventNotification
-	 *  and EventAck handling.
-	 */
-	if ((ret == 0) && (!ioc->facts.EventState))
-		(void) SendEventNotification(ioc, 1);	/* 1=Enable EventNotification */
-
-	if (ioc->alt_ioc && alt_ioc_ready && !ioc->alt_ioc->facts.EventState)
-		(void) SendEventNotification(ioc->alt_ioc, 1);	/* 1=Enable EventNotification */
 
 	/*	Add additional "reason" check before call to GetLanConfigPages
 	 *	(combined with GetIoUnitPage2 call).  This prevents a somewhat
@@ -6019,30 +6029,28 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
  *	SendEventNotification - Send EventNotification (on or off) request to adapter
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@EvSwitch: Event switch flags
+ *	@sleepFlag: Specifies whether the process can sleep
  */
 static int
-SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch)
+SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch, int sleepFlag)
 {
-	EventNotification_t	*evnp;
+	EventNotification_t	evn;
+	MPIDefaultReply_t	reply_buf;
 
-	evnp = (EventNotification_t *) mpt_get_msg_frame(mpt_base_index, ioc);
-	if (evnp == NULL) {
-		devtverboseprintk(ioc, printk(MYIOC_s_WARN_FMT "Unable to allocate event request frame!\n",
-				ioc->name));
-		return 0;
-	}
-	memset(evnp, 0, sizeof(*evnp));
-
-	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending EventNotification (%d) request %p\n", ioc->name, EvSwitch, evnp));
+	memset(&evn, 0, sizeof(EventNotification_t));
+	memset(&reply_buf, 0, sizeof(MPIDefaultReply_t));
 
-	evnp->Function = MPI_FUNCTION_EVENT_NOTIFICATION;
-	evnp->ChainOffset = 0;
-	evnp->MsgFlags = 0;
-	evnp->Switch = EvSwitch;
+	evn.Function = MPI_FUNCTION_EVENT_NOTIFICATION;
+	evn.Switch = EvSwitch;
+	evn.MsgContext = cpu_to_le32(mpt_base_index << 16);
 
-	mpt_put_msg_frame(mpt_base_index, ioc, (MPT_FRAME_HDR *)evnp);
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Sending EventNotification (%d) request %p\n",
+	    ioc->name, EvSwitch, &evn));
 
-	return 0;
+	return mpt_handshake_req_reply_wait(ioc, sizeof(EventNotification_t),
+	    (u32 *)&evn, sizeof(MPIDefaultReply_t), (u16 *)&reply_buf, 30,
+	    sleepFlag);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
