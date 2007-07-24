From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Tue, 24 Jul 2007 09:17:20 -0700
Message-ID: <20070724091720.d6dbdace.rdunlap@xenotime.net>
References: <4695F76F.5000305@panasas.com>
	<20070712135750.2a4a4a54.rdunlap@xenotime.net>
	<469B38CC.50501@panasas.com>
	<20070717171607.ffc278eb.rdunlap@xenotime.net>
	<469DDD74.2060208@panasas.com>
	<20070718103320.4b6ad7b3.rdunlap@xenotime.net>
	<20070718145818.8eebbd66.rdunlap@xenotime.net>
	<20070718194335.e21a01e5.rdunlap@xenotime.net>
	<20070718200315.3adcd194.rdunlap@xenotime.net>
	<469F616D.1000909@panasas.com>
	<20070719083719.33d8994c.rdunlap@xenotime.net>
	<469F89FE.4080900@panasas.com>
	<20070719104930.7ae87df8.rdunlap@xenotime.net>
	<46A5D083.50803@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:33356 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751055AbXGXQMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 12:12:35 -0400
Received: from midway.site ([71.245.96.223]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 09:12:26 -0700
In-Reply-To: <46A5D083.50803@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, scsi <linux-scsi@vger.kernel.org>, "=?ISO-8859-1?Q? J=FCrgen?= =?ISO-8859-1?Q?_E._Fischer ?=" <fischer@norbit.de>

On Tue, 24 Jul 2007 13:12:19 +0300 Boaz Harrosh wrote:

> Randy Dunlap wrote:
> > I prefer either of the !HIGHMEM or slave_alloc changes to adding
> > a BUG_ON().  However, the SCSI people likely won't want to use the
> > slave_alloc() change because then the driver may never get fixed.
> > (Of course, it hasn't got fixed with the BUG happening either.)
> > 
> > Anyway, I'll re-read Documentation/DMA*.txt to see if I can fix it.
> > ---
> 
> Hi Randy.
> 
> could you please send me the patch you have with the .slave_alloc
> solution for now. I would like to revise the patchset and send them
> for inclusion now. They do fix some problems and let users work.
> We can put a big fat warring and explanation about highmem in the
> commit log comments so people can watch out.


From: Randy Dunlap <randy.dunlap@oracle.com>

Cause highmem buffers to be bounced to low memory until this
driver supports highmem addresses.  Otherwise it just oopses
on NULL buffer addresses.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/aha152x.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2622.orig/drivers/scsi/aha152x.c
+++ linux-2622/drivers/scsi/aha152x.c
@@ -3476,6 +3476,12 @@ static int aha152x_proc_info(struct Scsi
 	return thislength < length ? thislength : length;
 }
 
+static int aha152x_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
+	return 0;
+}
+
 static struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
@@ -3492,6 +3498,7 @@ static struct scsi_host_template aha152x
 	.sg_tablesize			= SG_ALL,
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
+	.slave_alloc			= aha152x_adjust_queue,
 };
 
 #if !defined(PCMCIA)
