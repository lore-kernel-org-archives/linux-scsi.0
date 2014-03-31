From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/4] scsi: reintroduce scsi_driver.init_command
Date: Mon, 31 Mar 2014 01:56:13 -0500
Message-ID: <5339118D.4060406@cs.wisc.edu>
References: <1395936862-6938-1-git-send-email-hch@lst.de> <1395936862-6938-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56369 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaCaG4X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 02:56:23 -0400
In-Reply-To: <1395936862-6938-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On 03/27/2014 11:14 AM, Christoph Hellwig wrote:
> @@ -1663,6 +1652,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  	unsigned char op = SCpnt->cmnd[0];
>  	unsigned char unmap = SCpnt->cmnd[1] & 8;
>  
> +	sd_uninit_command(SCpnt);
> +

The above call would free the cmnd->cmnd and set it to null. If then
scsi_io_completion was going to do some error processing it looks like
it could try to access the scsi_cmnd->cmnd field.

With the current code that would not be a problem because the blk unprep
callback is not called until the block layer does its request cleanup in
blk_finish_request which as you know is after
scsi_io_completion/scsi_end_request is done with the cmnd.
