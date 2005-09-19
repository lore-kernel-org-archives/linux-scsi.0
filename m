From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] libata: ATA Information VPD page, lk 2.6.14-rc1+
Date: Mon, 19 Sep 2005 18:52:24 +1000
Message-ID: <432E7C48.8060205@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050400050105010106080308"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:38823 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932338AbVISIvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 04:51:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

This is a multi-part message in MIME format.
--------------050400050105010106080308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff,
This patch adds support for the ATA Information VPD page
defined in sat-r05.pdf (at www.t10.org). This VPD page
contains the response to the IDENTIFY (PACKET) DEVICE
ATA command amongst of data.

It is against lk 2.6.14-rc1 plus my "libata: scsi error
handling" patch that I just sent.

The patch can be exercised with "sg_inq -a /dev/sda"
(from sg3_utils-1.17 beta at http://www.torque.net/sg )
or "sdparm --page=ai /dev/sda" (from the sdparm-0.95
beta at http://www.torque.net/sg/sdparm.html ).
smartmontools could use this information if it was
available from linux.

As required by the sat-r05 draft, the code executes an
IDENTIFY (PACKET) DEVICE ATA command to get the most
recent values in dev->id . I know Tejun has been working
in this area and may have a better way of doing this
(e.g. the inside out spinlocks are a worry). The
"signature" part is a hack; registers need to be read
after a device reset and held.

Changelog:
  - add support for the ATA Information VPD page [0x89]
  - add function to redo IDENTIFY (PACKET) DEVICE ATA
    command to update the array dev->id, assumes
    ata_dev_identify() has been called.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------050400050105010106080308
Content-Type: text/x-patch;
 name="libata2614rc1err_ai.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2614rc1err_ai.diff"

--- linux/drivers/scsi/libata-scsi.c	2005-09-16 22:00:05.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2614rc1err_ai	2005-09-19 13:37:44.000000000 +1000
@@ -739,6 +739,84 @@
 	return 0;
 }
 
+static int ata_qc_complete_s_noop(struct ata_queued_cmd *qc, u8 drv_stat)
+{
+        return 0;
+}
+
+/**
+ *	ata_dev_redo_identify - obtain IDENTIFY x DEVICE page again
+ *	@ap: port on which device we wish to probe resides
+ *	@device: device bus address, starting at zero
+ *
+ *	Following bus reset, we issue the IDENTIFY [PACKET] DEVICE
+ *	command, and read back the 512-byte device information page.
+ *	The device information page is fed to us via the standard
+ *	PIO-IN protocol, but we hand-code it here. (TODO: investigate
+ *	using standard PIO-IN paths)
+ *
+ *	LOCKING:
+ *	Inherited from caller.  Some functions called by this function
+ *	obtain the host_set lock.
+ *
+ *	RETURNS:
+ *	Zero on success, -1 of failure
+ */
+
+static int ata_dev_redo_identify(struct ata_port *ap, unsigned int device)
+{
+	struct ata_device *dev = &ap->device[device];
+	u8 status;
+	DECLARE_COMPLETION(wait);
+	struct ata_queued_cmd *qc;
+	unsigned long flags;
+	int rc;
+
+	if (!ata_dev_present(dev)) {
+		return -1;
+	}
+
+	ata_dev_select(ap, device, 1, 1); /* select device 0/1 */
+
+	qc = ata_qc_new_init(ap, dev);
+	BUG_ON(qc == NULL);
+
+	ata_sg_init_one(qc, dev->id, sizeof(dev->id));
+	qc->dma_dir = DMA_FROM_DEVICE;
+	qc->tf.protocol = ATA_PROT_PIO;
+	qc->nsect = 1;
+
+	if (dev->class == ATA_DEV_ATA) {
+		qc->tf.command = ATA_CMD_ID_ATA;
+	} else {
+		qc->tf.command = ATA_CMD_ID_ATAPI;
+	}
+
+	qc->waiting = &wait;
+	qc->complete_fn = ata_qc_complete_s_noop;
+
+	spin_lock_irqsave(&ap->host_set->lock, flags);
+	rc = ata_qc_issue(qc);
+	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+
+	if (rc)
+		goto err_out;
+	else
+		wait_for_completion(&wait);
+
+	status = ata_chk_status(ap);
+	if (status & ATA_ERR) {
+		goto err_out;
+	}
+
+	swap_buf_le16(dev->id, ATA_ID_WORDS);
+
+	return 0;
+
+err_out:
+	return -1;
+}
+
 /**
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@ap: ATA port to which the command is addressed
@@ -1059,6 +1137,79 @@
 }
 
 /**
+ *	ata_scsiop_inq_89 - Simulate INQUIRY EVPD page 83, ATA information
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *	@buflen: Response buffer length.
+ *
+ *	Yields ATA (and SAT layer) information. Defined per sat-r05
+ *	This function should also be called for S-ATAPI devices.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ */
+
+unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
+			       unsigned int buflen)
+{
+	struct ata_port *ap;
+	struct ata_device *dev;
+	struct scsi_cmnd *cmd = args->cmd;
+	struct scsi_device *scsidev = cmd->device;
+	u8 *scsicmd = cmd->cmnd;
+	unsigned int out_len;
+	int res;
+	const int spec_page_len = 568;
+	u8 b[60];
+	int is_atapi_dev = 0;
+
+	out_len = (scsicmd[3] << 8) + scsicmd[4];
+	out_len = (buflen < out_len) ? buflen : out_len;
+	memset(b, 0, sizeof(b));
+	ap = (struct ata_port *)&scsidev->host->hostdata[0];
+	if (ap) {
+		dev = ata_scsi_find_dev(ap, scsidev);
+		if (dev && (dev->class != ATA_DEV_ATA)) {
+			is_atapi_dev = 1;
+			b[0] = 0x5;	/* assume MMC device, dubious */
+		}
+	} else
+		dev = NULL;
+	b[1] = 0x89;			/* this page code */
+	b[2] = (spec_page_len >> 8) & 0xff;
+	b[3] = spec_page_len & 0xff;
+	strncpy(b + 8, "linux   ", 8);
+	strncpy(b + 16, "libata          ", 16);
+	strncpy(b + 32, "0001", 4);
+	/* signature stuff goes here, where to fetch it from? */
+	b[36] = 0x34;		/* FIS type */
+	b[36 + 1] = 0x0;	/* interrupt + PM port */
+	b[36 + 4] = 0x1;	/* lba low */
+	b[36 + 5] = is_atapi_dev ? 0x14 : 0x0;	/* lba mid */
+	b[36 + 6] = is_atapi_dev ? 0xeb : 0x0;	/* lba high */
+	b[36 + 12] = 0x1;	/* sector count */
+
+	b[56] = is_atapi_dev ? 0xa1 : 0xec;	/* command code */
+
+	memcpy(rbuf, b, ((sizeof(b) < out_len) ? sizeof(b) : out_len));
+	if ((out_len <= sizeof(b)) || (! ap) || (! dev))
+	    return 0;
+	
+	spin_unlock_irq(&ap->host_set->lock);
+	res = ata_dev_redo_identify(ap, scsidev->id);
+	spin_lock_irq(&ap->host_set->lock);
+	if (res) {
+		/* sat-r05 says ok, leave IDENTIFY response all zeroes */
+		DPRINTK("ata_dev_redo_identify failed\n");
+		return 0;
+	}
+	out_len -= 60;
+	memcpy(rbuf + 60, dev->id,
+	       ((out_len < sizeof(dev->id)) ? out_len : sizeof(dev->id)));
+	return 0;
+}
+
+/**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
@@ -1715,6 +1866,8 @@
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_80);
 			else if (scsicmd[2] == 0x83)
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
+			else if (scsicmd[2] == 0x89)
+				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
 			else
 				ata_scsi_invalid_field(cmd, done);
 			break;

--------------050400050105010106080308--
