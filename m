From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Tue, 13 Jun 2006 21:40:34 -0500
Message-ID: <1150252834.22961.0.camel@mulgrave.il.steeleye.com>
References: <20060603112610.GB17018@lst.de> <20060610160815.GA12034@lst.de>
	 <20060612191948.GA8926@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5282 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964950AbWFNCkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 22:40:47 -0400
In-Reply-To: <20060612191948.GA8926@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@SteelEye.com, fischer@norbit.de, linux-scsi@vger.kernel.org

On Mon, 2006-06-12 at 21:19 +0200, Christoph Hellwig wrote:
> looks like no one but James looked at it as I attached a completely
> different patch that has been merged long ago.  Here's the real one:

Here's a piece that was missed from the recently added highpoint driver

James

Index: BUILD-2.6/drivers/scsi/hptiop.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/hptiop.c	2006-06-13 15:53:53.000000000 -0500
+++ BUILD-2.6/drivers/scsi/hptiop.c	2006-06-13 15:53:57.000000000 -0500
@@ -554,7 +554,7 @@
 	req->header.context = cpu_to_le32(IOPMU_QUEUE_ADDR_HOST_BIT |
 							(u32)_req->index);
 	req->header.context_hi32 = 0;
-	req->dataxfer_length = cpu_to_le32(scp->bufflen);
+	req->dataxfer_length = cpu_to_le32(scp->request_bufflen);
 	req->channel = scp->device->channel;
 	req->target = scp->device->id;
 	req->lun = scp->device->lun;


