From: akpm@linux-foundation.org
Subject: [patch 14/17] ppa: coding police and printk levels
Date: Mon, 09 Jul 2007 12:00:10 -0700
Message-ID: <200707091900.l69J0ApB002550@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbXGITKw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:10:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add printk levels
Clean up some oddities of formatting
Fix goto labels

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ppa.c |   57 ++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 30 deletions(-)

diff -puN drivers/scsi/ppa.c~ppa-coding-police-and-printk-levels drivers/scsi/ppa.c
--- a/drivers/scsi/ppa.c~ppa-coding-police-and-printk-levels
+++ a/drivers/scsi/ppa.c
@@ -129,11 +129,11 @@ static inline int ppa_proc_write(ppa_str
 	if ((length > 10) && (strncmp(buffer, "recon_tmo=", 10) == 0)) {
 		x = simple_strtoul(buffer + 10, NULL, 0);
 		dev->recon_tmo = x;
-		printk("ppa: recon_tmo set to %ld\n", x);
+		printk(KERN_INFO "ppa: recon_tmo set to %ld\n", x);
 		return length;
 	}
-	printk("ppa /proc: invalid variable\n");
-	return (-EINVAL);
+	printk(KERN_WARNING "ppa /proc: invalid variable\n");
+	return -EINVAL;
 }
 
 static int ppa_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int inout)
@@ -216,7 +216,7 @@ static unsigned char ppa_wait(ppa_struct
 
 	/* Counter expired - Time out occurred */
 	ppa_fail(dev, DID_TIME_OUT);
-	printk("ppa timeout in ppa_wait\n");
+	printk(KERN_WARNING "ppa timeout in ppa_wait\n");
 	return 0;		/* command timed out */
 }
 
@@ -248,7 +248,7 @@ static inline void ecp_sync(ppa_struct *
 				return;
 			udelay(5);
 		}
-		printk("ppa: ECP sync failed as data still present in FIFO.\n");
+		printk(KERN_WARNING "ppa: ECP sync failed as data still present in FIFO.\n");
 	}
 }
 
@@ -328,7 +328,7 @@ static int ppa_out(ppa_struct *dev, char
 		break;
 
 	default:
-		printk("PPA: bug in ppa_out()\n");
+		printk(KERN_ERR "PPA: bug in ppa_out()\n");
 		r = 0;
 	}
 	return r;
@@ -381,7 +381,7 @@ static int ppa_in(ppa_struct *dev, char 
 		break;
 
 	default:
-		printk("PPA: bug in ppa_ins()\n");
+		printk(KERN_ERR "PPA: bug in ppa_ins()\n");
 		r = 0;
 		break;
 	}
@@ -633,7 +633,7 @@ static void ppa_interrupt(struct work_st
 	struct scsi_cmnd *cmd = dev->cur_cmd;
 
 	if (!cmd) {
-		printk("PPA: bug in ppa_interrupt\n");
+		printk(KERN_ERR "PPA: bug in ppa_interrupt\n");
 		return;
 	}
 	if (ppa_engine(dev, cmd)) {
@@ -646,31 +646,31 @@ static void ppa_interrupt(struct work_st
 	case DID_OK:
 		break;
 	case DID_NO_CONNECT:
-		printk("ppa: no device at SCSI ID %i\n", cmd->device->target);
+		printk(KERN_DEBUG "ppa: no device at SCSI ID %i\n", cmd->device->target);
 		break;
 	case DID_BUS_BUSY:
-		printk("ppa: BUS BUSY - EPP timeout detected\n");
+		printk(KERN_DEBUG "ppa: BUS BUSY - EPP timeout detected\n");
 		break;
 	case DID_TIME_OUT:
-		printk("ppa: unknown timeout\n");
+		printk(KERN_DEBUG "ppa: unknown timeout\n");
 		break;
 	case DID_ABORT:
-		printk("ppa: told to abort\n");
+		printk(KERN_DEBUG "ppa: told to abort\n");
 		break;
 	case DID_PARITY:
-		printk("ppa: parity error (???)\n");
+		printk(KERN_DEBUG "ppa: parity error (???)\n");
 		break;
 	case DID_ERROR:
-		printk("ppa: internal driver error\n");
+		printk(KERN_DEBUG "ppa: internal driver error\n");
 		break;
 	case DID_RESET:
-		printk("ppa: told to reset device\n");
+		printk(KERN_DEBUG "ppa: told to reset device\n");
 		break;
 	case DID_BAD_INTR:
-		printk("ppa: bad interrupt (???)\n");
+		printk(KERN_WARNING "ppa: bad interrupt (???)\n");
 		break;
 	default:
-		printk("ppa: bad return code (%02x)\n",
+		printk(KERN_WARNING "ppa: bad return code (%02x)\n",
 		       (cmd->result >> 16) & 0xff);
 	}
 #endif
@@ -724,8 +724,7 @@ static int ppa_engine(ppa_struct *dev, s
 
 			if (retv) {
 				if (time_after(jiffies, dev->jstart + (1 * HZ))) {
-					printk
-					    ("ppa: Parallel port cable is unplugged!!\n");
+					printk(KERN_ERR "ppa: Parallel port cable is unplugged.\n");
 					ppa_fail(dev, DID_BUS_BUSY);
 					return 0;
 				} else {
@@ -755,11 +754,9 @@ static int ppa_engine(ppa_struct *dev, s
 	case 4:		/* Phase 4 - Setup scatter/gather buffers */
 		if (cmd->use_sg) {
 			/* if many buffers are available, start filling the first */
-			cmd->SCp.buffer =
-			    (struct scatterlist *) cmd->request_buffer;
+			cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
-			cmd->SCp.ptr =
-			    page_address(cmd->SCp.buffer->page) +
+			cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) +
 			    cmd->SCp.buffer->offset;
 		} else {
 			/* else fill the only available buffer */
@@ -800,7 +797,7 @@ static int ppa_engine(ppa_struct *dev, s
 		break;
 
 	default:
-		printk("ppa: Invalid scsi phase\n");
+		printk(KERN_ERR "ppa: Invalid scsi phase\n");
 	}
 	return 0;
 }
@@ -811,7 +808,7 @@ static int ppa_queuecommand(struct scsi_
 	ppa_struct *dev = ppa_dev(cmd->device->host);
 
 	if (dev->cur_cmd) {
-		printk("PPA: bug in ppa_queuecommand\n");
+		printk(KERN_ERR "PPA: bug in ppa_queuecommand\n");
 		return 0;
 	}
 	dev->failed = 0;
@@ -899,7 +896,7 @@ static int device_check(ppa_struct *dev)
 	/* This routine looks for a device and then attempts to use EPP
 	   to send a command. If all goes as planned then EPP is available. */
 
-	static char cmd[6] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+	static u8 cmd[6] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	int loop, old_mode, status, k, ppb = dev->base;
 	unsigned char l;
 
@@ -909,14 +906,14 @@ static int device_check(ppa_struct *dev)
 		if ((ppb & 0x0007) == 0x0000)
 			dev->mode = PPA_EPP_32;
 
-	      second_pass:
+second_pass:
 		ppa_connect(dev, CONNECT_EPP_MAYBE);
 		/* Select SCSI device */
 		if (!ppa_select(dev, loop)) {
 			ppa_disconnect(dev);
 			continue;
 		}
-		printk("ppa: Found device at ID %i, Attempting to use %s\n",
+		printk(KERN_INFO "ppa: Found device at ID %i, Attempting to use %s\n",
 		       loop, PPA_MODE_STRING[dev->mode]);
 
 		/* Send SCSI command */
@@ -965,7 +962,7 @@ static int device_check(ppa_struct *dev)
 			return -EIO;
 		}
 		ppa_disconnect(dev);
-		printk("ppa: Communication established with ID %i using %s\n",
+		printk(KERN_INFO "ppa: Communication established with ID %i using %s\n",
 		       loop, PPA_MODE_STRING[dev->mode]);
 		ppa_connect(dev, CONNECT_EPP_MAYBE);
 		ppa_reset_pulse(ppb);
@@ -1140,7 +1137,7 @@ static struct parport_driver ppa_driver 
 
 static int __init ppa_driver_init(void)
 {
-	printk("ppa: Version %s\n", PPA_VERSION);
+	printk(KERN_INFO "ppa: Version %s\n", PPA_VERSION);
 	return parport_register_driver(&ppa_driver);
 }
 
_
