From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] ppa: no highmem pages
Date: Fri, 19 May 2006 09:08:13 -0700
Message-ID: <20060519090813.0c1f7c83.rdunlap@xenotime.net>
References: <20060518220744.cb986f3f.rdunlap@xenotime.net>
	<1148050838.3410.32.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:46013 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932424AbWESQFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 12:05:47 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 09:05:43 -0700
In-Reply-To: <1148050838.3410.32.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

On Fri, 19 May 2006 10:00:38 -0500 James Bottomley wrote:

> This is the wrong thing to do.  You'll force all allocations for this
> device to go through ZONE_DMA, which is a horrifically constrained
> resource at 16MB.  If it can take anything in lowmem because the driver
> is unconverted, then you want it to specify BLK_BOUNCE_HIGH as the queue
> limit.

OK, I think I have ppa like imm now.


From: Randy Dunlap <rdunlap@xenotime.net>

ppa cannot handle highmem pages, and like imm, which already has
this patch, the device is slow, so performance is not a big issue,
so just force pages to be in low memory (hence mapped).

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/ppa.c |   11 +++++++++++
 1 files changed, 11 insertions(+)

--- linux-2.6.17-rc4.orig/drivers/scsi/ppa.c
+++ linux-2.6.17-rc4/drivers/scsi/ppa.c
@@ -982,6 +982,12 @@ static int device_check(ppa_struct *dev)
 	return -ENODEV;
 }
 
+static int ppa_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
+	return 0;
+}
+
 static struct scsi_host_template ppa_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "ppa",
@@ -997,6 +1003,11 @@ static struct scsi_host_template ppa_tem
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
+	.slave_alloc		= ppa_adjust_queue,
+	.unchecked_isa_dma	= 1, /* ppa cannot deal with highmem, so
+				      * this is an easy trick to ensure
+				      * all io pages for this host reside
+				      * in low memory */
 };
 
 /***************************************************************************



---
