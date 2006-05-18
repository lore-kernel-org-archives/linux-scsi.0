From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] printks in print_inquiry
Date: Thu, 18 May 2006 12:36:52 -0600
Message-ID: <20060518183652.GM1604@parisc-linux.org>
References: <20060511150015.GJ12272@parisc-linux.org> <20060512170854.GA11215@us.ibm.com> <20060513050059.GR12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:27851 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751227AbWERSgx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 14:36:53 -0400
Content-Disposition: inline
In-Reply-To: <20060513050059.GR12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 12, 2006 at 11:00:59PM -0600, Matthew Wilcox wrote:
> On Fri, May 12, 2006 at 10:08:54AM -0700, Patrick Mansfield wrote:
> > Terser one line output would be nice (even for a few devices), with "scsi"
> > and bus_id. We don't need "Type", like:
> > 
> > SCSI 2:0:0:0: Vendor: FOO      Model: BAR              Rev: 0.2 ANSI rev: 04

I went for:

scsi: 2:0:1:0: Vendor: HP 18.2G Model: ATLAS10K3_18_SCA Rev: HP05 ANSI rev: 02  

Lower case seems to have the edge over upper case by a factor of 10:1

willy@rowlf:~/kernel/pscan-2.6$ cat drivers/scsi/*.c | grep -c '".*scsi'        
1406
willy@rowlf:~/kernel/pscan-2.6$ cat drivers/scsi/*.c | grep -c '".*SCSI'
525
willy@rowlf:~/kernel/pscan-2.6$ cat drivers/scsi/*.c | grep -c '"scsi'
940
willy@rowlf:~/kernel/pscan-2.6$ cat drivers/scsi/*.c | grep -c '"SCSI'
90

Although it would match with sd.c's
SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)                      
and
SCSI device sda: drive cache: write through w/ FUA                              


Arguably we should just do away with that text though.  Look at it:

SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)                      
sda: Write Protect is off                                                       
SCSI device sda: drive cache: write through w/ FUA                              
 sda: sda1 sda2 sda3                                                            
sd 2:0:1:0: Attached scsi disk sda                                              
sd 2:0:1:0: Attached scsi generic sg0 type 0                                    


wouldn't this look better?

sda: 35566480 512-byte hdwr sectors (18210 MB)                      
sda: Write Protect is off                                                       
sda: drive cache: write through w/ FUA                              
 sda: sda1 sda2 sda3                                                            
sd 2:0:1:0: Attached scsi disk sda                                              
sd 2:0:1:0: Attached scsi generic sg0 type 0                                    

> > And maybe use printk("%-16s") formatting? But garbage might get printed
> > for non-ASCII (though the SCSI specs say it is not allowed ...).

I think you meant %.16s, not %-16s; it's already padded, we just need a
maximum byte count.

Anyway, I noticed that sdev has everything I need in it, and it's
definitely clearer than using the inquiry data directly.  The one thing
I don't do this for is scsi_level; we want what the device returned,
not what we've mangled it to.

The comment about BLIST_ISROM is a little too terse for me to know what
to do; can anyone hazard a guess?

Index: ./drivers/scsi/scsi_scan.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_scan.c,v
retrieving revision 1.38
diff -u -p -r1.38 scsi_scan.c
--- ./drivers/scsi/scsi_scan.c	19 Apr 2006 04:55:59 -0000	1.38
+++ ./drivers/scsi/scsi_scan.c	18 May 2006 18:11:50 -0000
@@ -135,59 +176,6 @@ static void scsi_unlock_floptical(struct
 }
 
 /**
- * print_inquiry - printk the inquiry information
- * @inq_result:	printk this SCSI INQUIRY
- *
- * Description:
- *     printk the vendor, model, and other information found in the
- *     INQUIRY data in @inq_result.
- *
- * Notes:
- *     Remove this, and replace with a hotplug event that logs any
- *     relevant information.
- **/
-static void print_inquiry(unsigned char *inq_result)
-{
-	int i;
-
-	printk(KERN_NOTICE "  Vendor: ");
-	for (i = 8; i < 16; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
-
-	printk("  Model: ");
-	for (i = 16; i < 32; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
-
-	printk("  Rev: ");
-	for (i = 32; i < 36; i++)
-		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
-			printk("%c", inq_result[i]);
-		else
-			printk(" ");
-
-	printk("\n");
-
-	i = inq_result[0] & 0x1f;
-
-	printk(KERN_NOTICE "  Type:   %s ",
-	       i <
-	       MAX_SCSI_DEVICE_CODE ? scsi_device_types[i] :
-	       "Unknown          ");
-	printk("                 ANSI SCSI revision: %02x",
-	       inq_result[2] & 0x07);
-	if ((inq_result[2] & 0x07) == 1 && (inq_result[3] & 0x0f) == 1)
-		printk(" CCS\n");
-	else
-		printk("\n");
-}
-
-/**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  *
  * Description:
@@ -654,9 +643,8 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_ISROM) {
 		/*
 		 * It would be better to modify sdev->type, and set
-		 * sdev->removable, but then the print_inquiry() output
-		 * would not show TYPE_ROM; if print_inquiry() is removed
-		 * the issue goes away.
+		 * sdev->removable; this can now be done since
+		 * print_inquiry has gone away.
 		 */
 		inq_result[0] = TYPE_ROM;
 		inq_result[1] |= 0x80;	/* removable */
@@ -685,7 +673,9 @@ static int scsi_add_lun(struct scsi_devi
 		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
 	}
 
-	print_inquiry(inq_result);
+	sdev_printk(KERN_NOTICE "scsi:", sdev, "Vendor: %.8s Model: %.16s "
+			"Rev: %.4s ANSI rev: %02x\n", sdev->vendor,
+			sdev->model, sdev->rev, sdev->inquiry[2] & 0x07);
 
 	/*
 	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
