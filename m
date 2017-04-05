From: Jens Axboe <axboe@kernel.dk>
Subject: Re: ->retries fixups V2
Date: Wed, 5 Apr 2017 12:06:53 -0600
Message-ID: <20170405180653.GA5548@kernel.dk>
References: <20170405171812.19911-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:35487 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754473AbdDESG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 14:06:56 -0400
Received: by mail-it0-f54.google.com with SMTP id y18so87871609itc.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 11:06:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170405171812.19911-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Apr 05 2017, Christoph Hellwig wrote:
> This series fixes a few lose bits in terms of how nvme uses ->retries,
> including fixing it for non-PCIe transports.  While at it I noticed that
> nvme and scsi use the field in entirely different ways, and no other
> driver uses it at all.  So I decided to move it into the nvme_request and
> scsi_request structures instead.
> 
> Changes since V1:
>  - better changelog for one patch
>  - move the new retries field to the end of struct nvme_request

Applied for 4.12. If we do the below on my box, we remove the (now) 2
holes from struct request and shrink it 8 bytes.

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ce6f9a6534c9..3cf241b0814d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -215,6 +215,8 @@ struct request {
 
 	unsigned short ioprio;
 
+	unsigned int timeout;
+
 	void *special;		/* opaque pointer available for LLD use */
 
 	int errors;
@@ -223,7 +225,6 @@ struct request {
 
 	unsigned long deadline;
 	struct list_head timeout_list;
-	unsigned int timeout;
 
 	/*
 	 * completion callback.

-- 
Jens Axboe
