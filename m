From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Blacklist devices that falsely claim an echo buffer
Date: Fri, 3 Dec 2004 20:19:37 +0000
Message-ID: <20041203201937.GJ29370@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37522 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262502AbULCUTl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2004 15:19:41 -0500
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1CaJtx-00045p-G9
	for linux-scsi@vger.kernel.org; Fri, 03 Dec 2004 20:19:37 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


It seems the HP DVD-ROM 305 drive has an interesting little defect in
its implementation of the echo buffer.  Normally, it reports no echo
buffers, we skip the write tests and everything is fine.  If there is
spinning media in the drive, it returns completely bogus data in the
buffer, then our domain validation write tests fail, and we negotiate
the drive down to async.  Apart from sucky performance, it also reports
some pretty scary messages.  And we don't want to do that.

Here's my current patch to solve this problem.  If the device is less than
SCSI_3 (the DVD-ROM claims SCSI-2 conformance), and there is garbage in
the buffer (garbage being defined as any of the reserved bits being set),
then we report that the device doesn't support echo buffers.  The output
is only slightly scary:

scsi5 : sym-2.1.18m
  Vendor: HP        Model: DVD-ROM 305       Rev: 1.01
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target5:0:2: Beginning Domain Validation
sym5:2: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 16)
 target5:0:2: Target reports bogus echo buffer
 target5:0:2: Domain Validation skipping write tests
 target5:0:2: Ending Domain Validation

Index: drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.6
diff -u -p -r1.6 scsi_transport_spi.c
--- drivers/scsi/scsi_transport_spi.c	21 Oct 2004 18:59:23 -0000	1.6
+++ drivers/scsi/scsi_transport_spi.c	3 Dec 2004 20:05:50 -0000
@@ -587,6 +587,14 @@ spi_dv_device_get_echo_buffer(struct scs
 		/* Device has no echo buffer */
 		return 0;
 
+	if ((sreq->sr_device->scsi_level < SCSI_3) &&
+		((buffer[0] & 0xfe) || buffer[1] || (buffer[2] & 0xe0))) {
+		/* Device is probably lying to us.  Skip write tests. */
+		SPI_PRINTK(sreq->sr_device->sdev_target, KERN_INFO,
+				"Target reports bogus echo buffer\n");
+		return 0;
+	}
+
 	return buffer[3] + ((buffer[2] & 0x1f) << 8);
 }
 
Comments?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
