From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 18:49:49 +0300
Message-ID: <464C799D.7080405@panasas.com>
References: <464C1721.8030009@panasas.com>	<1179408422.3785.5.camel@mulgrave.il.steeleye.com>	<464C5FF5.6000705@panasas.com> <20070517231127T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:46122 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754994AbXEQPzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 11:55:00 -0400
In-Reply-To: <20070517231127T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu, Jeff Garzik <jeff@garzik.org>

FUJITA Tomonori wrote:
> From: Boaz Harrosh <bharrosh@panasas.com>
> Subject: Re: [PATCH v2] add bidi support for block pc requests
> Date: Thu, 17 May 2007 17:00:21 +0300
> 
>> Yes Tomo found it at ata_scsi_slave_config(). Attached below the way I
>> fixed it. Now it works with 127.
> 
> I think that we can just remove blk_queue_max_phys_segments since the
> ata drivers seem to set sg_tablesize to LIBATA_MAX_PRD.
> 

Who should send a patch upstream? (I cc'ed Jeff Garzik)

Boaz

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index dd81fa7..3660f3e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -800,8 +800,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)

 	ata_scsi_sdev_config(sdev);

-	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
-
 	sdev->manage_start_stop = 1;

 	if (dev)

