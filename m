From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Fri, 01 Sep 2006 09:28:48 -0400
Message-ID: <1157117328.3675.6.camel@mulgrave.il.steeleye.com>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45188 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751113AbWIAN2w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Sep 2006 09:28:52 -0400
In-Reply-To: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Fri, 2006-09-01 at 14:31 +0800, Ed Lin wrote:
> ======= On 2006-09-01 06:21:45, James Bottomley wrote:
> 
> >On Thu, 2006-08-31 at 16:55 +0800, Ed Lin wrote:
> >> EXPORT_SYMBOL(blk_free_tags) ?
> >> Also, add new function definitions in blkdev.h?
> >
> >Yes .. fixed that up when I tried to use it in a module.
> >
> >So, given these two plus another patch that should fix all of the sync
> >cache issues, how about this as the final patch for stex (to replace the
> >[PATCH 3/3] stex: use block layer tagging)?
> >
> 
> Thanks. It's good. But here are a few issues.
> 
> 1.Maybe we need to check the result of scsi_init_shared_tag_map.
> It's unlikely to fail. In case it really fails, we can simply exit
> since we need tagging. Just checking.

Yes, we should.  I generalised your error checking below.

> 2.During shutdown/unload, we need to notify firmware to stop some
> background activities, that we are going to shutdown. If we don't do this,
> and the power is switched off when firmware is not ready, there may be
> error. It's possible the firmware is doing something that need to be
> stopped before shutdown. So it's different from a simple cache issue.
> 
> So it's better to keep the stex_hba_stop function and the .shutdown
> entry. In normal cases, there is no outside command at the stage when
> shutdown functions are called. So we can safely assume the tag is 0,
> and issue the notifying command, and then exit. It's only one and it
> will be issued only once. This way we can guarantee data integrity,
> and remove internal tag handling functions at the same time.
> 
> I agree with the other parts of the patch. So maybe we can consider
> something like the following?

Yes, I think we have a winner.

James

Index: scsi-misc-2.6/drivers/scsi/stex.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/stex.c
+++ scsi-misc-2.6/drivers/scsi/stex.c
@@ -1108,9 +1108,8 @@ stex_probe(struct pci_dev *pdev, const s
 	if (err)
 		goto out_free_irq;
 
-	scsi_init_shared_tag_map(host, ST_CAN_QUEUE);
-	if (host->bqt == NULL) {
-		err = -ENOMEM;
+	err = scsi_init_shared_tag_map(host, ST_CAN_QUEUE);
+	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): init shared queue failed\n",
 			pci_name(pdev));
 		goto out_free_irq;
Index: scsi-misc-2.6/include/scsi/scsi_tcq.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_tcq.h
+++ scsi-misc-2.6/include/scsi/scsi_tcq.h
@@ -138,9 +138,10 @@ static inline struct scsi_cmnd *scsi_fin
  * @shost:	the host to share the tag map among all devices
  * @depth:	the total depth of the map
  */
-static inline void scsi_init_shared_tag_map(struct Scsi_Host *shost, int depth)
+static inline int scsi_init_shared_tag_map(struct Scsi_Host *shost, int depth)
 {
 	shost->bqt = blk_init_tags(depth);
+	return shost->bqt ? 0 : -ENOMEM;
 }
 
 #endif /* _SCSI_SCSI_TCQ_H */


