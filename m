From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix up request buffer reference in various scsi drivers
Date: Thu, 08 Jun 2006 13:40:01 -0400
Message-ID: <1149788401.3436.22.camel@mulgrave.il.steeleye.com>
References: <20060603112113.GA17018@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:8896 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964921AbWFHRkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 13:40:18 -0400
In-Reply-To: <20060603112113.GA17018@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@SteelEye.com, linux-scsi@vger.kernel.org

On Sat, 2006-06-03 at 13:21 +0200, Christoph Hellwig wrote:
> Various scsi drivers use scsi_cmnd.buffer and scsi_cmnd.bufflen in their
> queuecommand functions.  Those fields are internal storage for the
> midlayer only and are used to restore the original payload after
> request_buffer and request_bufflen have been overwritten for EH.  Using
> the buffer and bufflen fields means they do very broken things in error
> handling.

We probably need this too, don't we?

James

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f47538d..56665ae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1235,7 +1235,7 @@ static void scsi_blk_pc_done(struct scsi
 	 * successfully. Since this is a REQ_BLOCK_PC command the
 	 * caller should check the request's errors value
 	 */
-	scsi_io_completion(cmd, cmd->bufflen, 0);
+	scsi_io_completion(cmd, cmd->request_bufflen, 0);
 }
 
 static void scsi_setup_blk_pc_cmnd(struct scsi_cmnd *cmd)


