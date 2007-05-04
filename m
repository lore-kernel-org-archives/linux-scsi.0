From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 1/7] libata: check for AN support - resend
Date: Fri, 4 May 2007 11:14:39 -0700
Message-ID: <20070504111439.388baa4f.kristen.c.accardi@intel.com>
References: <20070424074856.005152262@intel.com>
	<20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
	<20070424090713.65657495@the-village.bc.nu>
	<20070424102304.GA58841@dspnet.fr.eu.org>
	<20070424084904.61932994.kristen.c.accardi@intel.com>
	<20070424180552.GA17319@dspnet.fr.eu.org>
	<20070424135327.8fe0b0ba.kristen.c.accardi@intel.com>
	<20070425004946.GA63747@dspnet.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070425004946.GA63747@dspnet.fr.eu.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Check to see if an ATAPI device supports Asynchronous Notification.
If so, enable it.

Changes from last version:
* use parens around id in ata.h

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/ata/libata-core.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-core.c
+++ 2.6-git/drivers/ata/libata-core.c
@@ -70,6 +70,7 @@ const unsigned long sata_deb_timing_long
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
+static unsigned int ata_dev_set_AN(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 
 static unsigned int ata_print_id = 1;
@@ -1744,6 +1745,22 @@ int ata_dev_configure(struct ata_device 
 		}
 		dev->cdb_len = (unsigned int) rc;
 
+		/*
+		 * check to see if this ATAPI device supports
+		 * Asynchronous Notification
+		 */
+		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id)) {
+			int err;
+			/* issue SET feature command to turn this on */
+			err = ata_dev_set_AN(dev);
+			if (err)
+				ata_dev_printk(dev, KERN_ERR,
+						"unable to set AN, err %x\n",
+						err);
+			else
+				dev->flags |= ATA_DFLAG_AN;
+		}
+
 		if (ata_id_cdb_intr(dev->id)) {
 			dev->flags |= ATA_DFLAG_CDB_INTR;
 			cdb_intr_string = ", CDB intr";
@@ -3525,6 +3542,42 @@ static unsigned int ata_dev_set_xfermode
 }
 
 /**
+ *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
+ *                       with sector count set to indicate
+ *                       Asynchronous Notification feature
+ *	@dev: Device to which command will be sent
+ *
+ *	Issue SET FEATURES - SATA FEATURES command to device @dev
+ *	on port @ap.
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask otherwise.
+ */
+static unsigned int ata_dev_set_AN(struct ata_device *dev)
+{
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	/* set up set-features taskfile */
+	DPRINTK("set features - SATA features\n");
+
+	ata_tf_init(dev, &tf);
+	tf.command = ATA_CMD_SET_FEATURES;
+	tf.feature = SETFEATURES_SATA_ENABLE;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.protocol = ATA_PROT_NODATA;
+	tf.nsect = SATA_AN;
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+
+	DPRINTK("EXIT, err_mask=%x\n", err_mask);
+	return err_mask;
+}
+
+/**
  *	ata_dev_init_params - Issue INIT DEV PARAMS command
  *	@dev: Device to which command will be sent
  *	@heads: Number of heads (taskfile parameter)
Index: 2.6-git/include/linux/ata.h
===================================================================
--- 2.6-git.orig/include/linux/ata.h
+++ 2.6-git/include/linux/ata.h
@@ -194,6 +194,12 @@ enum {
 	SETFEATURES_WC_ON	= 0x02, /* Enable write cache */
 	SETFEATURES_WC_OFF	= 0x82, /* Disable write cache */
 
+	SETFEATURES_SATA_ENABLE = 0x10, /* Enable use of SATA feature */
+	SETFEATURES_SATA_DISABLE = 0x90, /* Disable use of SATA feature */
+
+	/* SETFEATURE Sector counts for SATA features */
+	SATA_AN			= 0x05,  /* Asynchronous Notification */
+
 	/* ATAPI stuff */
 	ATAPI_PKT_DMA		= (1 << 0),
 	ATAPI_DMADIR		= (1 << 2),	/* ATAPI data dir:
@@ -299,6 +305,9 @@ struct ata_taskfile {
 #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
 #define ata_id_removeable(id)	((id)[0] & (1 << 7))
 #define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
+#define ata_id_has_AN(id)	\
+	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
+	  ((id)[78] & (1 << 5)) )
 #define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[49] & (1 << 9))
 #define ata_id_u32(id,n)	\
Index: 2.6-git/include/linux/libata.h
===================================================================
--- 2.6-git.orig/include/linux/libata.h
+++ 2.6-git/include/linux/libata.h
@@ -136,6 +136,7 @@ enum {
 	ATA_DFLAG_CDB_INTR	= (1 << 2), /* device asserts INTRQ when ready for CDB */
 	ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
 	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
+	ATA_DFLAG_AN		= (1 << 5), /* device supports Async notification */
 	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
@@ -174,6 +175,7 @@ enum {
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
+	ATA_FLAG_AN		= (1 << 17), /* controller supports AN */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
