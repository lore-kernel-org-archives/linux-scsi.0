From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 4/4] libata: send event when AN received
Date: Wed, 15 Aug 2007 04:12:23 -0400
Message-ID: <46C2B567.2050602@garzik.org>
References: <20070808190613.616085010@localhost.localdomain> <20070808120838.63d2ba1f.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000800070503010105030602"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54371 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbXHOIM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 04:12:26 -0400
In-Reply-To: <20070808120838.63d2ba1f.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

This is a multi-part message in MIME format.
--------------000800070503010105030602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

applied the attached slightly modified patch.  main changes:

* SCSI stuff has not been applied yet, so libata's notify is a no-op for now

* fixed endian bug in SDB FIS handling



--------------000800070503010105030602
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 757369e..c41bd2c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1366,6 +1366,30 @@ static void ahci_port_intr(struct ata_port *ap)
 		return;
 	}
 
+	if (status & PORT_IRQ_SDB_FIS) {
+		/*
+		 * if this is an ATAPI device with AN turned on,
+		 * then we should interrogate the device to
+		 * determine the cause of the interrupt
+		 *
+		 * for AN - this we should check the SDB FIS
+		 * and find the I and N bits set
+		 */
+		const __le32 *f = pp->rx_fis + RX_FIS_SDB;
+		u32 f0 = le32_to_cpu(f[0]);
+
+		/* check the 'N' bit in word 0 of the FIS */
+		if (f0 & (1 << 15)) {
+			int port_addr = ((f0 & 0x00000f00) >> 8);
+			struct ata_device *adev;
+			if (port_addr < ATA_MAX_DEVICES) {
+				adev = &ap->link.device[port_addr];
+				if (adev->flags & ATA_DFLAG_AN)
+					ata_scsi_media_change_notify(adev);
+			}
+		}
+	}
+
 	if (ap->link.sactive)
 		qc_active = readl(port_mmio + PORT_SCR_ACT);
 	else
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7d66c98..f0f586b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3160,6 +3160,24 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
 }
 
 /**
+ *	ata_scsi_media_change_notify - send media change event
+ *	@atadev: Pointer to the disk device with media change event
+ *
+ *	Tell the block layer to send a media change notification
+ *	event.
+ *
+ * 	LOCKING:
+ * 	interrupt context, may not sleep.
+ */
+void ata_scsi_media_change_notify(struct ata_device *atadev)
+{
+#ifdef OTHER_AN_PATCHES_HAVE_BEEN_APPLIED
+	scsi_device_event_notify(atadev->sdev, SDEV_MEDIA_CHANGE);
+#endif
+}
+EXPORT_SYMBOL_GPL(ata_scsi_media_change_notify);
+
+/**
  *	ata_scsi_hotplug - SCSI part of hotplug
  *	@work: Pointer to ATA port to perform SCSI hotplug on
  *
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d1bd9f5..08d6a9a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -754,6 +754,7 @@ extern void ata_host_init(struct ata_host *, struct device *,
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
+extern void ata_scsi_media_change_notify(struct ata_device *atadev);
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);

--------------000800070503010105030602--
