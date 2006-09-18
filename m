From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Mon, 18 Sep 2006 14:25:08 -0500
Message-ID: <1158607508.3800.4.camel@madmax>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
	 <20060918184712.GA17670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44516 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750889AbWIRTZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 15:25:51 -0400
In-Reply-To: <20060918184712.GA17670@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ed Lin <ed.lin@promise.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, david.somayajulu@qlogic.com

On Mon, 2006-09-18 at 19:47 +0100, Christoph Hellwig wrote:
> On Fri, Sep 01, 2006 at 02:31:51PM +0800, Ed Lin wrote:
> >  static int
> > +stex_slave_alloc(struct scsi_device *sdev)
> > +{
> > +	/* Cheat: usually extracted from Inquiry data */
> > +	sdev->tagged_supported = 1;
> > +
> > +	scsi_activate_tcq(sdev, sdev->host->can_queue);
> 
> these two calls look wrong here. scsi_activate_tcq is supposed to be
> called from slave_configure.  similarly tagged_supported is probably
> going to be overwriten as part of the scanning process, but you already
> set it in slave_configure anyway.

If a lld is doing host wide tagging will they always need a tag? For
those drivers it seems like they are not doing tagging based on this in
scsi_scan

        if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
> >             !(*bflags & BLIST_NOTQ))
> >                 sdev->tagged_supported = 1;

Instead they need a tag because their FW or driver require it.

If so then should we just set this in scsi_alloc_sdev if shost->bqt is
set? For qla4xxx we are doing something like stex which is a little odd.
See patch below. It is untested and not even compile tested - just shows
what I mean and for Qlogic to test if it is ok with you guys.

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fd9e281..2efd90c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -206,6 +206,11 @@ static struct scsi_device *scsi_alloc_sd
 
 	scsi_sysfs_device_initialize(sdev);
 
+	if (shost->bqt) {
+		sdev->tagged_supported = 1;
+		scsi_activate_tcq(sdev, shost->can_queue);
+	}
+
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
 		if (ret) {


