From: Arvind Kumar <arvindkumar@vmware.com>
Subject: [PATCH] VMW_PVSCSI: Try setting host->max_id as suggested by the
 device.
Date: Wed, 07 Mar 2012 16:39:47 +0530
Message-ID: <1331118587.3170.39.camel@arvind-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:57875 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120Ab2CGLJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 06:09:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, pv-drivers@vmware.com, akataria@vmware.com

Try setting host->max_id as suggested by the device.

Fetch the config page from the device to learn max target id to set host->max_id.

Also, fix some indentation issues and update the 'Maintained by' field.

From: Arvind Kumar <arvindkumar@vmware.com>

Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
Cc: Alok N Kataria <akataria@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c |   65 +++++++++++++++++++++++++++-
 drivers/scsi/vmw_pvscsi.h |  107 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 148 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 7264116..92c941f 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -17,7 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Alok N Kataria <akataria@vmware.com>
+ * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
  *
  */
 
@@ -1178,6 +1178,63 @@ static int __devinit pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
 	return 0;
 }
 
+/*
+ * Query the device, fetch the config info and return the
+ * maximum number of targets on the adapter. In case of
+ * failure due to any reason return default i.e. 16.
+ */
+static u32 pvscsi_get_max_targets(struct pvscsi_adapter *adapter)
+{
+	struct PVSCSICmdDescConfigCmd cmd;
+	struct PVSCSIConfigPageHeader *header;
+	dma_addr_t configPagePA;
+	void *config_page;
+	u32 numPhys;
+
+	numPhys = 16;
+	config_page = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
+					   &configPagePA);
+	if (!config_page) {
+		printk(KERN_INFO "vmw_pvscsi: failed to allocate memory for"
+		       " config page\n");
+		goto exit;
+	}
+	BUG_ON(configPagePA & ~PAGE_MASK);
+
+	/* Fetch config info from the device. */
+	cmd.configPageAddress = (((u64)(PVSCSI_CONFIG_CONTROLLER_ADDRESS))
+				 << 32);
+	cmd.configPageNum = PVSCSI_CONFIG_PAGE_CONTROLLER;
+	cmd.cmpAddr = configPagePA;
+	cmd._pad = 0;
+
+	/*
+	 * Mark the completion page header with error values. If the device
+	 * completes the command successfully, it sets the status values to
+	 * indicate success.
+	 */
+	header = config_page;
+	memset(header, 0, sizeof *header);
+	header->hostStatus = BTSTAT_INVPARAM;
+	header->scsiStatus = SDSTAT_CHECK;
+
+	pvscsi_write_cmd_desc(adapter, PVSCSI_CMD_CONFIG, &cmd, sizeof cmd);
+
+	if (header->hostStatus == BTSTAT_SUCCESS &&
+	    header->scsiStatus == SDSTAT_GOOD) {
+		struct PVSCSIConfigPageController *config;
+
+		config = config_page;
+		numPhys = config->numPhys;
+	} else
+		printk(KERN_INFO "vmw_pvscsi: PVSCSI_CMD_CONFIG failed."
+		       " hostStatus = 0x%x, scsiStatus = 0x%x\n",
+		       header->hostStatus, header->scsiStatus);
+	pci_free_consistent(adapter->dev, PAGE_SIZE, config_page, configPagePA);
+exit:
+	return numPhys;
+}
+
 static int __devinit pvscsi_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *id)
 {
@@ -1272,6 +1329,12 @@ static int __devinit pvscsi_probe(struct pci_dev *pdev,
 	}
 
 	/*
+	 * Ask the device for max number of targets.
+	 */
+	host->max_id = pvscsi_get_max_targets(adapter);
+	printk(KERN_INFO "vmw_pvscsi: host->max_id: %u\n", host->max_id);
+
+	/*
 	 * From this point on we should reset the adapter if anything goes
 	 * wrong.
 	 */
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 62e36e7..3a5d7e8 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -17,7 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Alok N Kataria <akataria@vmware.com>
+ * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
  *
  */
 
@@ -39,28 +39,45 @@
  * host adapter status/error codes
  */
 enum HostBusAdapterStatus {
-   BTSTAT_SUCCESS       = 0x00,  /* CCB complete normally with no errors */
-   BTSTAT_LINKED_COMMAND_COMPLETED           = 0x0a,
-   BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG = 0x0b,
-   BTSTAT_DATA_UNDERRUN = 0x0c,
-   BTSTAT_SELTIMEO      = 0x11,  /* SCSI selection timeout */
-   BTSTAT_DATARUN       = 0x12,  /* data overrun/underrun */
-   BTSTAT_BUSFREE       = 0x13,  /* unexpected bus free */
-   BTSTAT_INVPHASE      = 0x14,  /* invalid bus phase or sequence requested by target */
-   BTSTAT_LUNMISMATCH   = 0x17,  /* linked CCB has different LUN from first CCB */
-   BTSTAT_SENSFAILED    = 0x1b,  /* auto request sense failed */
-   BTSTAT_TAGREJECT     = 0x1c,  /* SCSI II tagged queueing message rejected by target */
-   BTSTAT_BADMSG        = 0x1d,  /* unsupported message received by the host adapter */
-   BTSTAT_HAHARDWARE    = 0x20,  /* host adapter hardware failed */
-   BTSTAT_NORESPONSE    = 0x21,  /* target did not respond to SCSI ATN, sent a SCSI RST */
-   BTSTAT_SENTRST       = 0x22,  /* host adapter asserted a SCSI RST */
-   BTSTAT_RECVRST       = 0x23,  /* other SCSI devices asserted a SCSI RST */
-   BTSTAT_DISCONNECT    = 0x24,  /* target device reconnected improperly (w/o tag) */
-   BTSTAT_BUSRESET      = 0x25,  /* host adapter issued BUS device reset */
-   BTSTAT_ABORTQUEUE    = 0x26,  /* abort queue generated */
-   BTSTAT_HASOFTWARE    = 0x27,  /* host adapter software error */
-   BTSTAT_HATIMEOUT     = 0x30,  /* host adapter hardware timeout error */
-   BTSTAT_SCSIPARITY    = 0x34,  /* SCSI parity error detected */
+	BTSTAT_SUCCESS       = 0x00,  /* CCB complete normally with no errors */
+	BTSTAT_LINKED_COMMAND_COMPLETED           = 0x0a,
+	BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG = 0x0b,
+	BTSTAT_DATA_UNDERRUN = 0x0c,
+	BTSTAT_SELTIMEO      = 0x11,  /* SCSI selection timeout */
+	BTSTAT_DATARUN       = 0x12,  /* data overrun/underrun */
+	BTSTAT_BUSFREE       = 0x13,  /* unexpected bus free */
+	BTSTAT_INVPHASE      = 0x14,  /* invalid bus phase or sequence
+				       * requested by target */
+	BTSTAT_LUNMISMATCH   = 0x17,  /* linked CCB has different LUN from
+				       * first CCB */
+	BTSTAT_INVPARAM      = 0x1a,  /* invalid parameter in CCB or segment
+				       * list */
+	BTSTAT_SENSFAILED    = 0x1b,  /* auto request sense failed */
+	BTSTAT_TAGREJECT     = 0x1c,  /* SCSI II tagged queueing message
+				       * rejected by target */
+	BTSTAT_BADMSG        = 0x1d,  /* unsupported message received by the
+				       * host adapter */
+	BTSTAT_HAHARDWARE    = 0x20,  /* host adapter hardware failed */
+	BTSTAT_NORESPONSE    = 0x21,  /* target did not respond to SCSI ATN,
+				       * sent a SCSI RST */
+	BTSTAT_SENTRST       = 0x22,  /* host adapter asserted a SCSI RST */
+	BTSTAT_RECVRST       = 0x23,  /* other SCSI devices asserted a SCSI
+				       * RST */
+	BTSTAT_DISCONNECT    = 0x24,  /* target device reconnected improperly
+				       * (w/o tag) */
+	BTSTAT_BUSRESET      = 0x25,  /* host adapter issued BUS device reset */
+	BTSTAT_ABORTQUEUE    = 0x26,  /* abort queue generated */
+	BTSTAT_HASOFTWARE    = 0x27,  /* host adapter software error */
+	BTSTAT_HATIMEOUT     = 0x30,  /* host adapter hardware timeout error */
+	BTSTAT_SCSIPARITY    = 0x34,  /* SCSI parity error detected */
+};
+
+/*
+ * SCSI device status values.
+ */
+enum ScsiDeviceStatus {
+	SDSTAT_GOOD  = 0x00, /* No errors. */
+	SDSTAT_CHECK = 0x02, /* Check condition. */
 };
 
 /*
@@ -114,6 +131,29 @@ struct PVSCSICmdDescResetDevice {
 } __packed;
 
 /*
+ * Command descriptor for PVSCSI_CMD_CONFIG --
+ */
+
+struct PVSCSICmdDescConfigCmd {
+	u64 cmpAddr;
+	u64 configPageAddress;
+	u32 configPageNum;
+	u32 _pad;
+} __packed;
+
+enum PVSCSIConfigPageType {
+	PVSCSI_CONFIG_PAGE_CONTROLLER = 0x1958,
+	PVSCSI_CONFIG_PAGE_PHY        = 0x1959,
+	PVSCSI_CONFIG_PAGE_DEVICE     = 0x195a,
+};
+
+enum PVSCSIConfigPageAddressType {
+	PVSCSI_CONFIG_CONTROLLER_ADDRESS = 0x2120,
+	PVSCSI_CONFIG_BUSTARGET_ADDRESS  = 0x2121,
+	PVSCSI_CONFIG_PHY_ADDRESS        = 0x2122,
+};
+
+/*
  * Command descriptor for PVSCSI_CMD_ABORT_CMD --
  *
  * - currently does not support specifying the LUN.
@@ -332,6 +372,27 @@ struct PVSCSIRingCmpDesc {
 	u32	_pad[2];
 } __packed;
 
+struct PVSCSIConfigPageHeader {
+	u32 pageNum;
+	u16 numDwords;
+	u16 hostStatus;
+	u16 scsiStatus;
+	u16 reserved[3];
+} __packed;
+
+struct PVSCSIConfigPageController {
+	struct PVSCSIConfigPageHeader header;
+	u64 nodeWWN; /* Device name as defined in the SAS spec. */
+	u16 manufacturer[64];
+	u16 serialNumber[64];
+	u16 opromVersion[32];
+	u16 hwVersion[32];
+	u16 firmwareVersion[32];
+	u32 numPhys;
+	u8  useConsecutivePhyWWNs;
+	u8  reserved[3];
+} __packed;
+
 /*
  * Interrupt status / IRQ bits.
  */
-- 
1.7.1



