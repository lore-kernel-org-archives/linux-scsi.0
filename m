From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: sym2 probs in bk-scsi tree
Date: 08 Apr 2004 11:59:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081443560.2165.329.camel@mulgrave>
References: <20040407231820.66dd76cd.akpm@osdl.org>
	<20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:24266 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262005AbUDHQ7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 12:59:23 -0400
In-Reply-To: <20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-08 at 09:57, Matthew Wilcox wrote:
> They certainly are scary.  What is device 15 on this scsi bus?  This
> looks like domain validation being applied to a device that can't do it
> to me.  Did I get that right, James?

OK, try the attached, it should predicate DV on what we already know
from the inquiry data.

James

===== drivers/scsi/scsi_transport_spi.c 1.9 vs edited =====
--- 1.9/drivers/scsi/scsi_transport_spi.c	Thu Apr  8 08:39:09 2004
+++ edited/drivers/scsi/scsi_transport_spi.c	Thu Apr  8 12:35:07 2004
@@ -490,7 +490,7 @@
 	}
 
 	/* test width */
-	if (i->f->set_width) {
+	if (i->f->set_width && sdev->wdtr) {
 		i->f->set_width(sdev, 1);
 
 		if (!spi_dv_device_compare_inquiry(sreq, buffer,
@@ -502,6 +502,10 @@
 	}
 
 	if (!i->f->set_period)
+		return;
+
+	/* device can't handle synchronous */
+	if(!sdev->ppr && !sdev->sdtr)
 		return;
 
 	/* now set up to the maximum */

