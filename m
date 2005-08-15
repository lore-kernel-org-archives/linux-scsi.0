From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 10:14:10 -0500
Message-ID: <1124118850.5089.4.camel@mulgrave>
References: <20050815134210.GA19426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1484 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964804AbVHOPOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:14:19 -0400
In-Reply-To: <20050815134210.GA19426@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-15 at 15:42 +0200, Christoph Hellwig wrote:
> Add a new void *transport_data argument to scsi_scan_target so that a
> transport-class can fill in known information before actually scanning
> the target.  This is needed by the upcoming SAS transport class patch.

Given that you're testing fusion, I'm surprised you missed this.

James

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -564,7 +564,7 @@ static void mpt_work_wrapper(void *data)
 	mpt_read_ioc_pg_3(hd->ioc);
 	dev_printk(KERN_INFO, &hd->ioc->sh->shost_gendev,
 		   "Integrated RAID detects new device %d\n", disk);
-	scsi_scan_target(&hd->ioc->sh->shost_gendev, 1, disk, 0, 1);
+	scsi_scan_target(&hd->ioc->sh->shost_gendev, 1, disk, 0, 1, NULL);
 }
 
 


