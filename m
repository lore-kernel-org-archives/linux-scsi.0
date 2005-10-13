From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH ] mptsas: support link error attributes[2 round] - and phy_reset attributes
Date: Wed, 12 Oct 2005 18:16:02 -0600
Message-ID: <200510121816.02479.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CdaTD+jOfkFYyi8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43000 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964832AbVJMAXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 20:23:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_CdaTD+jOfkFYyi8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch applies ontop of 2.6.14-rc4
and two patches previous posted by Christoph

(1) [PATCH] mptsas: support link error attributes
http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D112716006932685&w=3D2

(2)  [PATCH] scsi_transport_sas: support link error attributes
http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D112716000904268&w=3D2

This attached patch changelog as follows:

(1) fix=B4s the proper phy_identifier attribute to be set properly
so link_attributes returns correct values from firmware.

(2) Only link_attributes work for hba attached phys. Its not implemented
for expanders.

(3) Add phy link_reset and hard_reset support.  These work for
hba attached phys, not for expanders. This was a patch previously
provided by Christoph - added support in scsi_transport_sas.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>



--Boundary-00=_CdaTD+jOfkFYyi8
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="phy_reset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="phy_reset.patch"

diff -uarN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2005-10-11 10:22:10.000000000 -0600
+++ a/drivers/message/fusion/Makefile	2005-10-12 16:42:39.000000000 -0600
@@ -7,7 +7,7 @@
 #EXTRA_CFLAGS += -DMPT_DEBUG_INIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_EXIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
-
+#EXTRA_CFLAGS += -DSASDEBUG
 
 #
 # driver/module specifics...
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2005-10-11 10:22:10.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2005-10-12 17:43:45.000000000 -0600
@@ -77,8 +77,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.03"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.03"
+#define MPT_LINUX_VERSION_COMMON	"3.03.04"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.04"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
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
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2005-10-12 17:31:45.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2005-10-12 17:34:57.000000000 -0600
@@ -83,6 +83,7 @@
 static int	mptsasDoneCtx = -1;
 static int	mptsasTaskCtx = -1;
 static int	mptsasInternalCtx = -1; /* Used only for internal commands */
+static int	mptsasMgmtCtx = -1;
 
 
 /*
@@ -166,12 +167,12 @@
 static void mptsas_print_phy_pg1(SasPhyPage1_t *pg1)
 {
 	printk("---- SAS PHY PAGE 1 ------------\n");
-        printk("Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount);
-        printk("Running Disparity Error Count=0x%x\n",
+	printk("Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount);
+	printk("Running Disparity Error Count=0x%x\n",
 			pg1->RunningDisparityErrorCount);
-        printk("Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount);
-        printk("PHY Reset Problem Count=0x%x\n", pg1->PhyResetProblemCount);
-        printk("\n");
+	printk("Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount);
+	printk("PHY Reset Problem Count=0x%x\n", pg1->PhyResetProblemCount);
+	printk("\n");
 }
 
 static void mptsas_print_device_pg0(SasDevicePage0_t *pg0)
@@ -187,8 +188,11 @@
 	printk("SAS Address=0x%llX\n", le64_to_cpu(sas_address));
 	printk("Target ID=0x%X\n", pg0->TargetID);
 	printk("Bus=0x%X\n", pg0->Bus);
-	printk("PhyNum=0x%X\n", pg0->PhyNum);
-	printk("AccessStatus=0x%X\n", le16_to_cpu(pg0->AccessStatus));
+	/* The PhyNum field specifies the PHY number of the parent
+	 * device this device is linked to
+	 */
+	printk("Parent Phy Num=0x%X\n", pg0->PhyNum);
+	printk("Access Status=0x%X\n", le16_to_cpu(pg0->AccessStatus));
 	printk("Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo));
 	printk("Flags=0x%X\n", le16_to_cpu(pg0->Flags));
 	printk("Physical Port=0x%X\n", pg0->PhysicalPort);
@@ -200,7 +204,7 @@
 	printk("---- SAS EXPANDER PAGE 1 ------------\n");
 
 	printk("Physical Port=0x%X\n", pg1->PhysicalPort);
-	printk("PHY Identifier=0x%X\n", pg1->Phy);
+	printk("PHY Identifier=0x%X\n", pg1->PhyIdentifier);
 	printk("Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate);
 	printk("Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate);
 	printk("Hardware Link Rate=0x%X\n", pg1->HwLinkRate);
@@ -310,6 +314,10 @@
 	dma_addr_t dma_handle;
 	int error;
 
+	/* not implemented for expanders */
+	if (phy->identify.target_port_protocols & SAS_PROTOCOL_SMP)
+		return -ENXIO;
+
 	hdr.PageVersion = MPI_SASPHY1_PAGEVERSION;
 	hdr.ExtPageLength = 0;
 	hdr.PageNumber = 1 /* page number 1*/;
@@ -342,7 +350,6 @@
 	error = mpt_config(ioc, &cfg);
 	if (error)
 		goto out_free_consistent;
-
 	mptsas_print_phy_pg1(buffer);
 
 	phy->invalid_dword_count = le32_to_cpu(buffer->InvalidDwordCount);
@@ -359,9 +366,92 @@
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
@@ -684,7 +774,7 @@
 	mptsas_print_expander_pg1(buffer);
 
 	/* save config data */
-	phy_info->phy_id = buffer->Phy;
+	phy_info->phy_id = buffer->PhyIdentifier;
 	phy_info->port_id = buffer->PhysicalPort;
 	phy_info->negotiated_link_rate = buffer->NegotiatedLinkRate;
 	phy_info->programmed_link_rate = buffer->ProgrammedLinkRate;
@@ -905,6 +995,8 @@
 		mptsas_sas_device_pg0(ioc, &port_info->phy_info[i].identify,
 			(MPI_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE <<
 			 MPI_SAS_DEVICE_PGAD_FORM_SHIFT), handle);
+		port_info->phy_info[i].identify.phy_id =
+		    port_info->phy_info[i].phy_id;
 		handle = port_info->phy_info[i].identify.handle;
 
 		if (port_info->phy_info[i].attached.handle) {
@@ -961,6 +1053,8 @@
 				(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
 				 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
 				port_info->phy_info[i].identify.handle);
+			port_info->phy_info[i].identify.phy_id =
+			    port_info->phy_info[i].phy_id;
 		}
 
 		if (port_info->phy_info[i].attached.handle) {
@@ -1097,6 +1191,8 @@
 	sh->unique_id = ioc->id;
 
 	INIT_LIST_HEAD(&ioc->sas_topology);
+	init_MUTEX(&ioc->sas_mgmt.mutex);
+	init_completion(&ioc->sas_mgmt.done);
 
 	/* Verify that we won't exceed the maximum
 	 * number of chain buffers
@@ -1283,6 +1379,7 @@
 	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER);
 	mptsasInternalCtx =
 		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
+	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER);
 
 	if (mpt_event_register(mptsasDoneCtx, mptscsih_event_process) == 0) {
 		devtprintk((KERN_INFO MYNAM
@@ -1306,6 +1403,7 @@
 	mpt_reset_deregister(mptsasDoneCtx);
 	mpt_event_deregister(mptsasDoneCtx);
 
+	mpt_deregister(mptsasMgmtCtx);
 	mpt_deregister(mptsasInternalCtx);
 	mpt_deregister(mptsasTaskCtx);
 	mpt_deregister(mptsasDoneCtx);
diff -uarN b/drivers/scsi/scsi_transport_sas.c a/drivers/scsi/scsi_transport_sas.c
--- b/drivers/scsi/scsi_transport_sas.c	2005-10-12 17:53:37.000000000 -0600
+++ a/drivers/scsi/scsi_transport_sas.c	2005-10-12 13:51:29.000000000 -0600
@@ -34,7 +34,7 @@
 
 
 #define SAS_HOST_ATTRS		0
-#define SAS_PORT_ATTRS		15
+#define SAS_PORT_ATTRS		17
 #define SAS_RPORT_ATTRS		5
 
 struct sas_internal {
@@ -286,9 +286,36 @@
 		return snprintf(buf, 20, "none\n");
 	return get_sas_device_type_names(phy->identify.device_type, buf);
 }
-
 static CLASS_DEVICE_ATTR(device_type, S_IRUGO, show_sas_device_type, NULL);
 
+static ssize_t do_sas_phy_reset(struct class_device *cdev,
+		size_t count, int hard_reset)
+{
+	struct sas_phy *phy = transport_class_to_phy(cdev);
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+	int error;
+
+	error = i->f->phy_reset(phy, hard_reset);
+	if (error)
+		return error;
+	return count;
+};
+
+static ssize_t store_sas_link_reset(struct class_device *cdev,
+		const char *buf, size_t count)
+{
+	return do_sas_phy_reset(cdev, count, 0);
+}
+static CLASS_DEVICE_ATTR(link_reset, S_IWUSR, NULL, store_sas_link_reset);
+
+static ssize_t store_sas_hard_reset(struct class_device *cdev,
+		const char *buf, size_t count)
+{
+	return do_sas_phy_reset(cdev, count, 1);
+}
+static CLASS_DEVICE_ATTR(hard_reset, S_IWUSR, NULL, store_sas_hard_reset);
+
 sas_phy_protocol_attr(identify.initiator_port_protocols,
 		initiator_port_protocols);
 sas_phy_protocol_attr(identify.target_port_protocols,
@@ -722,6 +749,13 @@
         i->phy_attrs[count] = &i->private_phy_attrs[count];		\
 	count++
 
+#define SETUP_PORT_ATTRIBUTE_WRONLY(field)				\
+	i->private_phy_attrs[count] = class_device_attr_##field;	\
+	i->private_phy_attrs[count].attr.mode = S_IWUGO;		\
+	i->private_phy_attrs[count].show = NULL;			\
+	i->phy_attrs[count] = &i->private_phy_attrs[count];		\
+	count++
+
 
 /**
  * sas_attach_transport  --  instantiate SAS transport template
@@ -778,6 +812,8 @@
 	SETUP_PORT_ATTRIBUTE(running_disparity_error_count);
 	SETUP_PORT_ATTRIBUTE(loss_of_dword_sync_count);
 	SETUP_PORT_ATTRIBUTE(phy_reset_problem_count);
+	SETUP_PORT_ATTRIBUTE_WRONLY(link_reset);
+	SETUP_PORT_ATTRIBUTE_WRONLY(hard_reset);
 	i->phy_attrs[count] = NULL;
 
 	count = 0;
diff -uarN b/include/scsi/scsi_transport_sas.h a/include/scsi/scsi_transport_sas.h
--- b/include/scsi/scsi_transport_sas.h	2005-10-12 17:53:37.000000000 -0600
+++ a/include/scsi/scsi_transport_sas.h	2005-10-12 18:04:44.000000000 -0600
@@ -57,10 +57,10 @@
 	u8			port_identifier;
 
 	/* link error statistics */
-	u32			invalid_dword_count;
-	u32			running_disparity_error_count;
-	u32			loss_of_dword_sync_count;
-	u32			phy_reset_problem_count;
+	u32                     invalid_dword_count;
+	u32                     running_disparity_error_count;
+	u32                     loss_of_dword_sync_count;
+	u32                     phy_reset_problem_count;
 
 	/* the other end of the link */
 	struct sas_rphy		*rphy;
@@ -87,10 +87,10 @@
 #define rphy_to_shost(rphy) \
 	dev_to_shost((rphy)->dev.parent)
 
-
 /* The functions by which the transport class and the driver communicate */
 struct sas_function_template {
 	int (*get_linkerrors)(struct sas_phy *);
+	int (*phy_reset)(struct sas_phy *, int);
 };
 
 

--Boundary-00=_CdaTD+jOfkFYyi8--
