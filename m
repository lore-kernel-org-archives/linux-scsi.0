From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch 3/3] libata: handle AN interrupt
Date: Thu, 29 Mar 2007 08:38:07 -0400
Message-ID: <460BB32F.8030904@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40516 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbXC2Mid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 08:38:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

fyi...

For FC, we have several async events, and allow for LLDDs to send their own
data or augment the generic transport event w/ additional LLDD-data. The
infrastructure is implemented generically within the scsi midlayer.
We are using Netlink w/ broadcasts to deliver the events rather than kobject_uevent().
We considered using a variant of kobject events, but the general consensus was
we didn't want to wrap transport events into the kobject infrastructure, and using
netlink natively allowed for transport data to be sent with the event. Additionally,
with the broadcast, we could support any number of tools concurrently listening for
change events. To date, this has worked very well. You may want to consider this,
especially if the types of events is expected to grow beyond the simple "change"
notification.

-- james s



 >List:       linux-kernel
 >Subject:    [patch 3/3] libata: handle AN interrupt
 >From:       Kristen Carlson Accardi <kristen.c.accardi () intel ! com>
 >Date:       2007-03-28 23:44:57
 >Message-ID: 20070328164457.a675a7d2.kristen.c.accardi () intel ! com
 >[Download message RAW]
 >
 >When we get an SDB FIS with the 'N' bit set, we should send
 >an event to user space to indicate that there has been a
 >media change.  The ahci host controller will send the
 >event via KOBJ_CHANGE uevent.
 >
 >Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
 >Index: 2.6-mm/drivers/ata/ahci.c
 >===================================================================
 >--- 2.6-mm.orig/drivers/ata/ahci.c
 >+++ 2.6-mm/drivers/ata/ahci.c
 >@@ -1164,6 +1164,26 @@ static void ahci_host_intr(struct ata_po
 > 		return;
 > 	}
 >
 >+	if (status & PORT_IRQ_SDB_FIS) {
 >+		/*
 >+		 * if this is an ATAPI device with AN turned on,
 >+		 * then we should interrogate the device to
 >+		 * determine the cause of the interrupt
 >+		 *
 >+		 * for AN - this we should check the SDB FIS
 >+		 * and find the I and N bits set
 >+		 */
 >+		const u32 *f = pp->rx_fis + RX_FIS_SDB;
 >+
 >+		/* check the 'N' bit in word 0 of the FIS */
 >+		if (f[0] & (1 << 15)) {
 >+			int port_addr =  ((f[0] & 0x00000f00) >> 8);
 >+			struct ata_device *adev = &ap->device[port_addr];
 >+			ata_port_printk(ap, KERN_INFO, "N bit set on SDB FIS!\n");
 >+			if (adev->flags & ATA_DFLAG_AN)
 >+				ata_async_notify(adev);
 >+		}
 >+	}
 > 	if (ap->sactive)
 > 		qc_active = readl(port_mmio + PORT_SCR_ACT);
 > 	else
 >Index: 2.6-mm/include/linux/libata.h
 >===================================================================
 >--- 2.6-mm.orig/include/linux/libata.h
 >+++ 2.6-mm/include/linux/libata.h
 >@@ -492,6 +492,7 @@ struct ata_device {
 > 	/* ACPI objects info */
 > 	acpi_handle obj_handle;
 > #endif
 >+	struct work_struct	async_notify;
 > };
 >
 > /* Offset into struct ata_device.  Fields above it are maintained
 >@@ -826,6 +827,7 @@ extern void ata_scsi_slave_destroy(struc
 > extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 > 				       int queue_depth);
 > extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 >+extern void ata_async_notify(struct ata_device *atadev);
 > extern int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev);
 > extern u8 ata_irq_on(struct ata_port *ap);
 > extern u8 ata_dummy_irq_on(struct ata_port *ap);
 >Index: 2.6-mm/drivers/ata/libata-core.c
 >===================================================================
 >--- 2.6-mm.orig/drivers/ata/libata-core.c
 >+++ 2.6-mm/drivers/ata/libata-core.c
 >@@ -1576,6 +1576,26 @@ static void ata_dev_config_ncq(struct at
 > 		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
 > }
 >
 >+static void async_notify_thread(struct work_struct *work)
 >+{
 >+	struct ata_device *atadev =
 >+		container_of(work, struct ata_device, async_notify);
 >+
 >+	/*
 >+	 * TBD - who should send this event?  I couldn't find an
 >+	 * easy way to map an ata_device to a genhd device, so
 >+	 * decided maybe the ata host should send the event and
 >+	 * allow user space to figure out what happened?
 >+	 */
 >+	kobject_uevent(&atadev->ap->host->dev->kobj, KOBJ_CHANGE);
 >+}
 >+
 >+void ata_async_notify(struct ata_device *atadev)
 >+{
 >+	schedule_work(&atadev->async_notify);
 >+}
 >+
 >+
 > /**
 >  *	ata_dev_configure - Configure the specified ATA/ATAPI device
 >  *	@dev: Target device to configure
 >@@ -1761,6 +1781,7 @@ int ata_dev_configure(struct ata_device
 > 				goto err_out_nosup;
 > 			}
 > 			dev->flags |= ATA_DFLAG_AN;
 >+			INIT_WORK(&dev->async_notify, async_notify_thread);
 > 		}
 >
 > 		if (ata_id_cdb_intr(dev->id)) {
 >@@ -6650,6 +6671,7 @@ EXPORT_SYMBOL_GPL(ata_dummy_irq_on);
 > EXPORT_SYMBOL_GPL(ata_irq_ack);
 > EXPORT_SYMBOL_GPL(ata_dummy_irq_ack);
 > EXPORT_SYMBOL_GPL(ata_dev_try_classify);
 >+EXPORT_SYMBOL_GPL(ata_async_notify);
 >
 > EXPORT_SYMBOL_GPL(ata_cable_40wire);
 > EXPORT_SYMBOL_GPL(ata_cable_80wire);
 >
-- 
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

