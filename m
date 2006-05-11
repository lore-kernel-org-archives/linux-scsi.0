From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC] printks in print_inquiry
Date: Thu, 11 May 2006 09:00:15 -0600
Message-ID: <20060511150015.GJ12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52706 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751804AbWEKPAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 11:00:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


One of the side-effects of my previous patch to parallelise scsi
scanning is that it causes print_inquiry to run when there's already a
lot of other printk traffic.  Due to the way it works, it's very easy
for print_inquiry to be in the middle of printing something when
something else chooses to emit a printk.  This could of course happen
without the async scsi scanning patch, it's just a lot more frequent
with it.

This is one way of solving the problem -- accumulate each line into a
buffer, then display each line in one shot.  However, the comment above
the function says we should be packaging all this up into a hotplug
event.  Is that still true?  If so, I can do that, and we can forget
about this patch.

Index: ./drivers/scsi/scsi_scan.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_scan.c,v
retrieving revision 1.38
diff -u -p -r1.38 scsi_scan.c
--- ./drivers/scsi/scsi_scan.c	19 Apr 2006 04:55:59 -0000	1.38
+++ ./drivers/scsi/scsi_scan.c	11 May 2006 13:18:42 -0000
@@ -148,43 +166,43 @@ static void scsi_unlock_floptical(struct
  **/
 static void print_inquiry(unsigned char *inq_result)
 {
-	int i;
+	int i, len;
+	static char buf[80];
 
-	printk(KERN_NOTICE "  Vendor: ");
+	len = sprintf(buf, "  Vendor: ");
 	for (i = 8; i < 16; i++)
 		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
+			buf[len++] = inq_result[i];
 		else
-			printk(" ");
+			buf[len++] = ' ';
 
-	printk("  Model: ");
+	len += sprintf(buf + len, "  Model: ");
 	for (i = 16; i < 32; i++)
 		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
+			buf[len++] = inq_result[i];
 		else
-			printk(" ");
+			buf[len++] = ' ';
 
-	printk("  Rev: ");
+	len += sprintf(buf + len, "  Rev: ");
 	for (i = 32; i < 36; i++)
 		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
+			buf[len++] = inq_result[i];
 		else
-			printk(" ");
+			buf[len++] = ' ';
 
-	printk("\n");
+	buf[len] = '\0';
+	printk(KERN_NOTICE "%s\n", buf);
 
 	i = inq_result[0] & 0x1f;
 
-	printk(KERN_NOTICE "  Type:   %s ",
-	       i <
-	       MAX_SCSI_DEVICE_CODE ? scsi_device_types[i] :
-	       "Unknown          ");
-	printk("                 ANSI SCSI revision: %02x",
-	       inq_result[2] & 0x07);
+	len = sprintf(buf, "  Type:   %s ", i < MAX_SCSI_DEVICE_CODE ?
+			scsi_device_types[i] : "Unknown          ");
+	len += sprintf(buf + len, "                 ANSI SCSI revision: %02x",
+			inq_result[2] & 0x07);
 	if ((inq_result[2] & 0x07) == 1 && (inq_result[3] & 0x0f) == 1)
-		printk(" CCS\n");
-	else
-		printk("\n");
+		len += sprintf(buf + len, " CCS\n");
+
+	printk(KERN_NOTICE "%s\n", buf);
 }
 
 /**
