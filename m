From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Blacklist devices that falsely claim an echo buffer
Date: Mon, 6 Dec 2004 20:54:26 +0000
Message-ID: <20041206205426.GC10881@parcelfarce.linux.theplanet.co.uk>
References: <20041203201937.GJ29370@parcelfarce.linux.theplanet.co.uk> <1102345160.2018.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47532 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261641AbULFUy1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2004 15:54:27 -0500
Content-Disposition: inline
In-Reply-To: <1102345160.2018.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Dec 06, 2004 at 08:59:13AM -0600, James Bottomley wrote:
> Well ... I'm not very keen on this.  Does the device support LVD?  i.e.
> could we use the sreq->sr_device->ppr flag as a discriminator?  Write
> echo buffer tests are really most useful for validating high LVD
> transfer speeds, so it wouldn't be unreasonable simply to skip them if
> the device isn't ppr capable.

James explained to me offline that echo buffers were introduced at the
same time as the LVD extensions, so it's quite reasonly to assume ppr
will be set if the device supports echo buffers.  Here's the patch I'm
currently using which works:

Index: linux-2.6/drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.6
diff -u -p -r1.6 scsi_transport_spi.c
--- linux-2.6/drivers/scsi/scsi_transport_spi.c	21 Oct 2004 18:59:23 -0000	1.6
+++ linux-2.6/drivers/scsi/scsi_transport_spi.c	6 Dec 2004 20:51:40 -0000
@@ -635,7 +635,11 @@ spi_dv_device_internal(struct scsi_reque
 	/* OK, now we have our initial speed set by the read only inquiry
 	 * test, now try an echo buffer test (if the device allows it) */
 
-	if ((len = spi_dv_device_get_echo_buffer(sreq, buffer)) == 0) {
+	len = 0;
+	if (sdev->ppr)
+		len = spi_dv_device_get_echo_buffer(sreq, buffer);
+
+	if (len == 0) {
 		SPI_PRINTK(sdev->sdev_target, KERN_INFO, "Domain Validation skipping write tests\n");
 		return;
 	}

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
