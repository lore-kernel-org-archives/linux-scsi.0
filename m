From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] add spi attributes to qla1280
Date: Wed, 11 Aug 2004 22:29:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040812052924.GA33167@sgi.com>
References: <20040810230552.GA26569@sgi.com> <20040811081118.A26256@infradead.org> <20040811215651.GA30821@sgi.com> <20040811230555.A984@infradead.org> <20040811221636.GA31154@sgi.com> <20040811232225.A1192@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:52647 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268403AbUHLFaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 01:30:13 -0400
Content-Disposition: inline
In-Reply-To: <20040811232225.A1192@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 11, 2004 at 11:22:25PM +0100, Christoph Hellwig wrote:
> On Wed, Aug 11, 2004 at 03:16:36PM -0700, Jeremy Higdon wrote:
> > 
> > So I'll submit a patch to 2.6.8-rc4-mm1 then, if that's okay.
> 
> Sounds good.  While you're at it can you also fix the compilation
> error when the driver is compiled for port I/O instead of normal
> mmio (e.g. SGI ViswW), you broke that with your readb_relaxed changes.

Okay.  Here is the new rendition, based on 2.6.8-rc4-mm1, with the
fix for port I/O.  For sync period and offset, it seems that the
isp1040 is the same as the isp1280.

Thanks,

jeremy


Signed-off-by: Jeremy Higdon <jeremy@sgi.com>


diff -ur -X /home/jeremy/dontdiff linux-2.6.8-rc4/drivers/scsi/Kconfig linux-2.6.8-rc4.new/drivers/scsi/Kconfig
--- linux-2.6.8-rc4/drivers/scsi/Kconfig	2004-08-11 22:22:41.000000000 -0700
+++ linux-2.6.8-rc4.new/drivers/scsi/Kconfig	2004-08-11 17:41:57.000000000 -0700
@@ -1276,6 +1276,7 @@
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1280 SCSI support"
 	depends on PCI && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
 
diff -ur -X /home/jeremy/dontdiff linux-2.6.8-rc4/drivers/scsi/qla1280.c linux-2.6.8-rc4.new/drivers/scsi/qla1280.c
--- linux-2.6.8-rc4/drivers/scsi/qla1280.c	2004-08-11 22:22:41.000000000 -0700
+++ linux-2.6.8-rc4.new/drivers/scsi/qla1280.c	2004-08-11 17:47:13.000000000 -0700
@@ -356,6 +356,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 #include "scsi.h"
 #else
 #include <linux/blk.h>
@@ -1490,6 +1492,15 @@
 		status = qla1280_set_target_parameters(ha, bus, target);
 	qla1280_get_target_parameters(ha, device);
 	spin_unlock_irqrestore(HOST_LOCK, flags);
+
+	spi_period(device) = nv->bus[bus].target[target].sync_period;
+	if (IS_ISP1x160(ha))
+		spi_offset(device) = nv->bus[bus].target[target].flags.
+			flags1x160.sync_offset;
+	else
+		spi_offset(device) = nv->bus[bus].target[target].flags.
+			flags1x80.sync_offset;
+
 	return status;
 }
 
@@ -4681,6 +4692,12 @@
 };
 #endif
 
+static struct scsi_transport_template *qla1280_transport_template;
+static struct spi_function_template qla1280_transport_functions = {
+	.show_period = 1,
+	.show_offset = 1,
+};
+
 static int __devinit
 qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -4769,6 +4786,7 @@
 	host->max_id = MAX_TARGETS;
 	host->max_sectors = 1024;
 	host->unique_id = host->host_no;
+	host->transportt = qla1280_transport_template;
 
 #if LINUX_VERSION_CODE < 0x020545
 	host->select_queue_depths = qla1280_select_queue_depth;
@@ -4910,6 +4928,10 @@
 		return -EINVAL;
 	}
 
+	qla1280_transport_template = spi_attach_transport(&qla1280_transport_functions);
+	if (!qla1280_transport_template)
+		return -ENODEV;
+
 #ifdef MODULE
 	/*
 	 * If we are called as a module, the qla1280 pointer may not be null
@@ -4934,6 +4956,7 @@
 qla1280_exit(void)
 {
 	pci_unregister_driver(&qla1280_pci_driver);
+	spi_release_transport(qla1280_transport_template);
 }
 
 module_init(qla1280_init);
diff -ur -X /home/jeremy/dontdiff linux-2.6.8-rc4/drivers/scsi/qla1280.h linux-2.6.8-rc4.new/drivers/scsi/qla1280.h
--- linux-2.6.8-rc4/drivers/scsi/qla1280.h	2004-08-11 22:22:41.000000000 -0700
+++ linux-2.6.8-rc4.new/drivers/scsi/qla1280.h	2004-08-11 17:39:31.000000000 -0700
@@ -62,6 +62,7 @@
 #define WRT_REG_WORD(addr, data)	writew(data, addr)
 #else				/* MEMORY_MAPPED_IO */
 #define RD_REG_WORD(addr)		inw((unsigned long)addr)
+#define RD_REG_WORD_dmasync(addr)	inw((unsigned long)addr)
 #define WRT_REG_WORD(addr, data)	outw(data, (unsigned long)addr)
 #endif				/* MEMORY_MAPPED_IO */
 
