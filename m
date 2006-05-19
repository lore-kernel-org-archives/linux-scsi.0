From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] ppa: no highmem pages
Date: Fri, 19 May 2006 10:11:02 -0700
Message-ID: <20060519101102.5472db16.rdunlap@xenotime.net>
References: <20060518220744.cb986f3f.rdunlap@xenotime.net>
	<1148050838.3410.32.camel@mulgrave.il.steeleye.com>
	<20060519090813.0c1f7c83.rdunlap@xenotime.net>
	<1148055327.3410.43.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:36586 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932373AbWESRIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 13:08:36 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 10:08:32 -0700
In-Reply-To: <1148055327.3410.43.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

On Fri, 19 May 2006 11:15:27 -0500 James Bottomley wrote:

> On Fri, 2006-05-19 at 09:08 -0700, Randy.Dunlap wrote:
> > +	.unchecked_isa_dma	= 1, /* ppa cannot deal with highmem, so
> > +				      * this is an easy trick to ensure
> > +				      * all io pages for this host reside
> > +				      * in low memory */
> 
> You still don't need this piece, do you?  It will cause all the kmallocs
> still to be GFP_DMA ... allocations from zone normal should be fine,
> shouldn't they?

darn.  Looks correct and stress testing didn't cause it to fail.
Thanks.
Sounds like we should kill the .unchecked_isa_dma = 1 in the imm driver
also, to prevent ISA (16 MB) pressure.

---
From: Randy Dunlap <rdunlap@xenotime.net>

ppa cannot handle highmem pages, and like imm, which already has
this patch, the device is slow, so performance is not a big issue,
so just force pages to be in low memory (hence mapped).

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/ppa.c |    7 +++++++
 1 files changed, 7 insertions(+)

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
@@ -997,6 +1003,7 @@ static struct scsi_host_template ppa_tem
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
+	.slave_alloc		= ppa_adjust_queue,
 };
 
 /***************************************************************************
