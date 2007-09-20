From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] eata_pio: Clean up proc handling, bracketing and use
 cpu_relax()
Date: Thu, 20 Sep 2007 15:15:27 +0100
Message-ID: <20070920151527.786c7e5f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54248 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754882AbXITOIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 10:08:12 -0400
Received: from the-village.bc.nu (localhost.localdomain [127.0.0.1])
	by the-village.bc.nu (8.14.1/8.13.8) with ESMTP id l8KEFRvg014222
	for <linux-scsi@vger.kernel.org>; Thu, 20 Sep 2007 15:15:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

So its ancient, its crap, but it kept showing up in my scans for stuff
that wanted fixing...

- Redo the proc code to be far cleaner
- Clean various return (0) type constructs
- Use cpu_relax()

The various waits ought to time out but thats another issue and probably
not worth solving.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/drivers/scsi/eata_pio.c linux-2.6.23rc6-mm1/drivers/scsi/eata_pio.c
--- linux.vanilla-2.6.23rc6-mm1/drivers/scsi/eata_pio.c	2007-09-18 15:14:00.000000000 +0100
+++ linux-2.6.23rc6-mm1/drivers/scsi/eata_pio.c	2007-09-18 16:27:03.000000000 +0100
@@ -107,59 +107,44 @@
 static int eata_pio_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset,
 			      int length, int rw)
 {
-    static u8 buff[512];
-    int size, len = 0;
-    off_t begin = 0, pos = 0;
-
-    if (rw)
-    	return -ENOSYS;
-    if (offset == 0)
-	memset(buff, 0, sizeof(buff));
+	int len = 0;
+	off_t begin = 0, pos = 0;
+
+	if (rw)
+	   	return -ENOSYS;
 
-    size = sprintf(buffer+len, "EATA (Extended Attachment) PIO driver version: "
+	len += sprintf(buffer+len, "EATA (Extended Attachment) PIO driver version: "
 		   "%d.%d%s\n",VER_MAJOR, VER_MINOR, VER_SUB);
-    len += size; pos = begin + len;
-    size = sprintf(buffer + len, "queued commands:     %10ld\n"
+	len += sprintf(buffer + len, "queued commands:     %10ld\n"
 		   "processed interrupts:%10ld\n", queue_counter, int_counter);
-    len += size; pos = begin + len;
-    
-    size = sprintf(buffer + len, "\nscsi%-2d: HBA %.10s\n",
+	len += sprintf(buffer + len, "\nscsi%-2d: HBA %.10s\n",
 		   shost->host_no, SD(shost)->name);
-    len += size; 
-    pos = begin + len;
-    size = sprintf(buffer + len, "Firmware revision: v%s\n", 
+	len += sprintf(buffer + len, "Firmware revision: v%s\n", 
 		   SD(shost)->revision);
-    len += size;
-    pos = begin + len;
-    size = sprintf(buffer + len, "IO: PIO\n");
-    len += size; 
-    pos = begin + len;
-    size = sprintf(buffer + len, "Base IO : %#.4x\n", (u32) shost->base);
-    len += size; 
-    pos = begin + len;
-    size = sprintf(buffer + len, "Host Bus: %s\n", 
+	len += sprintf(buffer + len, "IO: PIO\n");
+	len += sprintf(buffer + len, "Base IO : %#.4x\n", (u32) shost->base);
+	len += sprintf(buffer + len, "Host Bus: %s\n", 
 		   (SD(shost)->bustype == 'P')?"PCI ":
 		   (SD(shost)->bustype == 'E')?"EISA":"ISA ");
     
-    len += size; 
-    pos = begin + len;
+	pos = begin + len;
     
-    if (pos < offset) {
-	len = 0;
-	begin = pos;
-    }
-    if (pos > offset + length)
-	goto stop_output;
+	if (pos < offset) {
+		len = 0;
+		begin = pos;
+	}
+	if (pos > offset + length)
+		goto stop_output;
     
- stop_output:
-    DBG(DBG_PROC, printk("2pos: %ld offset: %ld len: %d\n", pos, offset, len));
-    *start=buffer+(offset-begin);   /* Start of wanted data */
-    len-=(offset-begin);            /* Start slop */
-    if(len>length)
-	len = length;               /* Ending slop */
-    DBG(DBG_PROC, printk("3pos: %ld offset: %ld len: %d\n", pos, offset, len));
+stop_output:
+	DBG(DBG_PROC, printk("2pos: %ld offset: %ld len: %d\n", pos, offset, len));
+	*start = buffer + (offset - begin);   /* Start of wanted data */
+	len -= (offset - begin);            /* Start slop */
+	if (len > length)
+		len = length;               /* Ending slop */
+	DBG(DBG_PROC, printk("3pos: %ld offset: %ld len: %d\n", pos, offset, len));
     
-    return (len);     
+	return len;
 }
 
 static int eata_pio_release(struct Scsi_Host *sh)
@@ -438,7 +423,7 @@
 			"returning DID_BUS_BUSY, done.\n", cmd->pid);
 		done(cmd);
 		cp->status = FREE;
-		return (0);
+		return 0;
 	}
 	/* FIXME: timeout */
 	while (!(inb(base + HA_RSTATUS) & HA_SDRQ))
@@ -452,7 +437,7 @@
 		"Queued base %#.4lx pid: %ld "
 		"slot %d irq %d\n", sh->base, cmd->pid, y, sh->irq));
 
-	return (0);
+	return 0;
 }
 
 static int eata_pio_abort(struct scsi_cmnd *cmd)
@@ -589,23 +574,28 @@
 	cp.cp_cdb[5] = 0;
 
 	if (eata_pio_send_command(base, EATA_CMD_PIO_SEND_CP))
-		return (NULL);
-	while (!(inb(base + HA_RSTATUS) & HA_SDRQ));
+		return NULL;
+
+	while (!(inb(base + HA_RSTATUS) & HA_SDRQ))
+		cpu_relax();
+
 	outsw(base + HA_RDATA, &cp, cplen);
 	outb(EATA_CMD_PIO_TRUNC, base + HA_WCOMMAND);
 	for (z = 0; z < cppadlen; z++)
 		outw(0, base + HA_RDATA);
 
-	while (inb(base + HA_RSTATUS) & HA_SBUSY);
+	while (inb(base + HA_RSTATUS) & HA_SBUSY)
+		cpu_relax();
+
 	if (inb(base + HA_RSTATUS) & HA_SERROR)
-		return (NULL);
+		return NULL;
 	else if (!(inb(base + HA_RSTATUS) & HA_SDRQ))
-		return (NULL);
+		return NULL;
 	else {
 		insw(base + HA_RDATA, &buff, 127);
 		while (inb(base + HA_RSTATUS) & HA_SDRQ)
 			inw(base + HA_RDATA);
-		return (buff);
+		return buff;
 	}
 }
 
