From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical
	address >16Mb used for aha1542" at boot time
Date: 20 Feb 2004 08:49:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077295765.1937.0.camel@mulgrave>
References: <20040218171212.0eb6618a.akpm@osdl.org>
	<1077243517.2164.61.camel@mulgrave>  <1077265837.1297.9.camel@felicia>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:56211 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261325AbUBTQta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 11:49:30 -0500
In-Reply-To: <1077265837.1297.9.camel@felicia>
List-Id: linux-scsi@vger.kernel.org
To: "Dr. Ernst Molitor" <molitor@uni-bonn.de>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-02-20 at 00:30, Dr. Ernst Molitor wrote:
> Please don't hesitate to contact me if I can be of any further help in
> this matter.

The problem seems to be a non-GFP_DMA allocation in sr.c.  Could you try
this patch?

Thanks,

James

===== drivers/scsi/sr.c 1.98 vs edited =====
--- 1.98/drivers/scsi/sr.c	Mon Feb  9 12:59:10 2004
+++ edited/drivers/scsi/sr.c	Fri Feb 20 08:47:55 2004
@@ -716,7 +716,7 @@
 	set_disk_ro(cd->disk, 1);
 
 	/* allocate a request for the TEST_UNIT_READY */
-	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
+	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL | GFP_DMA);
 	if (!SRpnt) {
 		printk(KERN_WARNING "(get_capabilities:) Request allocation "
 		       "failure.\n");

