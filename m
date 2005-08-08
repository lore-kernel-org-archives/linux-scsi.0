From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] Expose the underlying physical disks of Fusion Integrated
	RAID devices
Date: Mon, 08 Aug 2005 16:15:52 -0500
Message-ID: <1123535752.5019.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:48365 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932238AbVHHVQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 17:16:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch is actually deceptively simple for what it does.

For all fusion devices with integrated raid devices, we make the card
pretend it has two channels, then all I/O on channel 1 is directed to
the underlying physical discs of the integrated raid assembly.  The net
effect is that all the physical discs show up correctly on virtual
channel 1 (we also specify no_uld_attach for anything on virtual channel
1 so that they can only be accessed using ioctls to the sg device).

The net effect is something like this:

mptbase: Initiating ioc22 bringup
ioc22: 53C1030: Capabilities={Initiator}
scsi27 : ioc22: LSI53C1030, FwRev=01032920h, Ports=1, MaxQ=222, IRQ=57
  Vendor: LSILOGIC  Model: 1030          IM  Rev: 1000
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdb: 17813504 512-byte hdwr sectors (9121 MB)
SCSI device sdb: drive cache: write through
SCSI device sdb: 17813504 512-byte hdwr sectors (9121 MB)
SCSI device sdb: drive cache: write through
 sdb: unknown partition table
Attached scsi disk sdb at scsi27, channel 0, id 0, lun 0
Attached scsi generic sg1 at scsi27, channel 0, id 0, lun 0,  type 0
  Vendor: QUANTUM   Model: ATLAS IV 9 WLS    Rev: 0B0B
  Type:   Direct-Access                      ANSI SCSI revision: 03
Attached scsi generic sg2 at scsi27, channel 1, id 0, lun 0,  type 0
  Vendor: QUANTUM   Model: ATLAS IV 9 WLS    Rev: 0B0B
  Type:   Direct-Access                      ANSI SCSI revision: 03
Attached scsi generic sg3 at scsi27, channel 1, id 1, lun 0,  type 0

where you can see that sdb is the RAID device and sg2 and sg3 the
underlying SCSI discs.

James

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -171,6 +171,7 @@ static void	mptscsih_fillbuf(char *buffe
 
 void 		mptscsih_remove(struct pci_dev *);
 void 		mptscsih_shutdown(struct pci_dev *);
+static int	mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id);
 #ifdef CONFIG_PM
 int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
 int 		mptscsih_resume(struct pci_dev *pdev);
@@ -1274,6 +1275,12 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	if (SCpnt->device->channel && !mptscsih_is_raid_volume(hd, target)) {
+		SCpnt->result = DID_NO_CONNECT << 16;
+		done(SCpnt);
+		return 0;
+	}
+
 	/*
 	 *  Put together a MPT SCSI request...
 	 */
@@ -1318,9 +1325,12 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	/* Use the above information to set up the message frame
 	 */
 	pScsiReq->TargetID = (u8) target;
-	pScsiReq->Bus = (u8) SCpnt->device->channel;
+	pScsiReq->Bus = 0;
 	pScsiReq->ChainOffset = 0;
-	pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
+	if (SCpnt->device->channel)
+		pScsiReq->Function = MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
+	else
+		pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
 	pScsiReq->CDBLength = SCpnt->cmd_len;
 	pScsiReq->SenseBufferLength = MPT_SENSE_BUFFER_SIZE;
 	pScsiReq->Reserved = 0;
@@ -2145,6 +2155,9 @@ mptscsih_slave_alloc(struct scsi_device 
 	if (hd == NULL)
 		return -ENODEV;
 
+	if (device->channel)
+		device->no_uld_attach = 1;
+
 	if ((vdev = hd->Targets[target]) != NULL)
 		goto out;
 
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -237,7 +237,10 @@ mptspi_probe(struct pci_dev *pdev, const
 	sh->max_id = MPT_MAX_SCSI_DEVICES;
 
 	sh->max_lun = MPT_LAST_LUN + 1;
-	sh->max_channel = 0;
+	if (ioc->spi_data.isRaid)
+		sh->max_channel = 1;
+	else
+		sh->max_channel = 0;
 	sh->this_id = ioc->pfacts[0].PortSCSIID;
 
 	/* Required entry.


