From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] mptsas: add support for PHY resets
Date: Wed, 19 Oct 2005 20:01:42 +0200
Message-ID: <20051019180142.GD21488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:29576 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751208AbVJSSBp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 14:01:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org

Support PHY resets in mptsas.  Thanks to Eric for various bug fixes
and improvements.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.h	2005-10-19 19:49:34.000000000 +0200
+++ linux-2.6/drivers/message/fusion/mptbase.h	2005-10-19 19:52:04.000000000 +0200
@@ -421,6 +421,17 @@
 	struct semaphore	 sem_ioc;
 } MPT_IOCTL;
 
+#define MPT_SAS_MGMT_STATUS_RF_VALID	0x02	/* The Reply Frame is VALID */
+#define MPT_SAS_MGMT_STATUS_COMMAND_GOOD	0x10	/* Command Status GOOD */
+#define MPT_SAS_MGMT_STATUS_TM_FAILED	0x40	/* User TM request failed */
+
+typedef struct _MPT_SAS_MGMT {
+	struct semaphore	 mutex;
+	struct completion	 done;
+	u8			 reply[MPT_DEFAULT_FRAME_SIZE]; /* reply frame data */
+	u8			 status;	/* current command status */
+}MPT_SAS_MGMT;
+
 /*
  *  Event Structure and define
  */
@@ -604,6 +615,7 @@
 	struct list_head	 list;
 	struct net_device	*netdev;
 	struct list_head	 sas_topology;
+	MPT_SAS_MGMT		 sas_mgmt;
 } MPT_ADAPTER;
 
 /*
Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c	2005-10-19 19:49:35.000000000 +0200
+++ linux-2.6/drivers/message/fusion/mptsas.c	2005-10-19 19:52:04.000000000 +0200
@@ -83,6 +83,7 @@
 static int	mptsasDoneCtx = -1;
 static int	mptsasTaskCtx = -1;
 static int	mptsasInternalCtx = -1; /* Used only for internal commands */
+static int	mptsasMgmtCtx = -1;
 
 
 /*
@@ -359,9 +360,92 @@
 	return error;
 }
 
+static int mptsas_mgmt_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
+		MPT_FRAME_HDR *reply)
+{
+	ioc->sas_mgmt.status |= MPT_SAS_MGMT_STATUS_COMMAND_GOOD;
+	if (reply != NULL) {
+		ioc->sas_mgmt.status |= MPT_SAS_MGMT_STATUS_RF_VALID;
+		memcpy(ioc->sas_mgmt.reply, reply,
+		    min(ioc->reply_sz, 4 * reply->u.reply.MsgLength));
+	}
+	complete(&ioc->sas_mgmt.done);
+	return 1;
+}
+
+static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
+{
+	MPT_ADAPTER *ioc = phy_to_ioc(phy);
+	SasIoUnitControlRequest_t *req;
+	SasIoUnitControlReply_t *reply;
+	MPT_FRAME_HDR *mf;
+	MPIHeader_t *hdr;
+	unsigned long timeleft;
+	int error = -ERESTARTSYS;
+
+	/* not implemented for expanders */
+	if (phy->identify.target_port_protocols & SAS_PROTOCOL_SMP)
+		return -ENXIO;
+
+	if (down_interruptible(&ioc->sas_mgmt.mutex))
+		goto out;
+
+	mf = mpt_get_msg_frame(mptsasMgmtCtx, ioc);
+	if (!mf) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	hdr = (MPIHeader_t *) mf;
+	req = (SasIoUnitControlRequest_t *)mf;
+	memset(req, 0, sizeof(SasIoUnitControlRequest_t));
+	req->Function = MPI_FUNCTION_SAS_IO_UNIT_CONTROL;
+	req->MsgContext = hdr->MsgContext;
+	req->Operation = hard_reset ?
+		MPI_SAS_OP_PHY_HARD_RESET : MPI_SAS_OP_PHY_LINK_RESET;
+	req->PhyNum = phy->identify.phy_identifier;
+
+	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
+
+	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done,
+			10 * HZ);
+	if (!timeleft) {
+		/* On timeout reset the board */
+		mpt_free_msg_frame(ioc, mf);
+		mpt_HardResetHandler(ioc, CAN_SLEEP);
+		error = -ETIMEDOUT;
+		goto out_unlock;
+	}
+
+	/* a reply frame is expected */
+	if ((ioc->sas_mgmt.status &
+	    MPT_IOCTL_STATUS_RF_VALID) == 0) {
+		error = -ENXIO;
+		goto out_unlock;
+	}
+
+	/* process the completed Reply Message Frame */
+	reply = (SasIoUnitControlReply_t *)ioc->sas_mgmt.reply;
+	if (reply->IOCStatus != MPI_IOCSTATUS_SUCCESS) {
+		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
+		    __FUNCTION__,
+		    reply->IOCStatus,
+		    reply->IOCLogInfo);
+		error = -ENXIO;
+		goto out_unlock;
+	}
+
+	error = 0;
+
+ out_unlock:
+	up(&ioc->sas_mgmt.mutex);
+ out:
+	return error;
+}
 
 static struct sas_function_template mptsas_transport_functions = {
 	.get_linkerrors		= mptsas_get_linkerrors,
+	.phy_reset		= mptsas_phy_reset,
 };
 
 static struct scsi_transport_template *mptsas_transport_template;
@@ -1105,6 +1189,8 @@
 	sh->unique_id = ioc->id;
 
 	INIT_LIST_HEAD(&ioc->sas_topology);
+	init_MUTEX(&ioc->sas_mgmt.mutex);
+	init_completion(&ioc->sas_mgmt.done);
 
 	/* Verify that we won't exceed the maximum
 	 * number of chain buffers
@@ -1291,6 +1377,7 @@
 	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER);
 	mptsasInternalCtx =
 		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
+	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER);
 
 	if (mpt_event_register(mptsasDoneCtx, mptscsih_event_process) == 0) {
 		devtprintk((KERN_INFO MYNAM
@@ -1314,6 +1401,7 @@
 	mpt_reset_deregister(mptsasDoneCtx);
 	mpt_event_deregister(mptsasDoneCtx);
 
+	mpt_deregister(mptsasMgmtCtx);
 	mpt_deregister(mptsasInternalCtx);
 	mpt_deregister(mptsasTaskCtx);
 	mpt_deregister(mptsasDoneCtx);
