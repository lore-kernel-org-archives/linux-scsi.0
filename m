From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix remaining scr_read/write users and the documentation
Date: Fri, 20 Jul 2007 13:11:44 -0500
Message-ID: <1184955104.3455.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This fixes up the usage in libsas (which are easy to miss, since they're
only in the scsi-misc tree) ... and also corrects the documentation on
the point of what these two function pointers actually return.

James

diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index e2e24b4..ba99757 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -456,8 +456,9 @@ void (*irq_clear) (struct ata_port *);
 
 	<sect2><title>SATA phy read/write</title>
 	<programlisting>
-u32 (*scr_read) (struct ata_port *ap, unsigned int sc_reg);
-void (*scr_write) (struct ata_port *ap, unsigned int sc_reg,
+int (*scr_read) (struct ata_port *ap, unsigned int sc_reg,
+		 u32 *val);
+int (*scr_write) (struct ata_port *ap, unsigned int sc_reg,
                    u32 val);
 	</programlisting>
 
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 2db2589..359391f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -172,7 +172,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		qc->tf.nsect = 0;
 	}
 
-	ata_tf_to_fis(&qc->tf, (u8*)&task->ata_task.fis, 0);
+	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
 	task->uldd_task = qc;
 	if (is_atapi_taskfile(&qc->tf)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
@@ -298,7 +298,7 @@ static void sas_ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 	memcpy(tf, &dev->sata_dev.tf, sizeof (*tf));
 }
 
-static void sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
+static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 			      u32 val)
 {
 	struct domain_device *dev = ap->private_data;
@@ -317,25 +317,33 @@ static void sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 		case SCR_ACTIVE:
 			dev->sata_dev.ap->sactive = val;
 			break;
+		default:
+			return -EINVAL;
 	}
+	return 0;
 }
 
-static u32 sas_ata_scr_read(struct ata_port *ap, unsigned int sc_reg_in)
+static int sas_ata_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
+			    u32 *val)
 {
 	struct domain_device *dev = ap->private_data;
 
 	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
 	switch (sc_reg_in) {
 		case SCR_STATUS:
-			return dev->sata_dev.sstatus;
+			*val = dev->sata_dev.sstatus;
+			return 0;
 		case SCR_CONTROL:
-			return dev->sata_dev.scontrol;
+			*val = dev->sata_dev.scontrol;
+			return 0;
 		case SCR_ERROR:
-			return dev->sata_dev.serror;
+			*val = dev->sata_dev.serror;
+			return 0;
 		case SCR_ACTIVE:
-			return dev->sata_dev.ap->sactive;
+			*val = dev->sata_dev.ap->sactive;
+			return 0;
 		default:
-			return 0xffffffffU;
+			return -EINVAL;
 	}
 }
 


