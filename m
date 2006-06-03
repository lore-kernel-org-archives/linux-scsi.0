From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] sbp2: remove broken inquiry mangling
Date: Sat, 03 Jun 2006 20:00:31 +0200
Message-ID: <4481CE3F.3000109@s5r6.in-berlin.de>
References: <20060603113549.GA17297@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:22957 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751113AbWFCSCB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jun 2006 14:02:01 -0400
In-Reply-To: <20060603113549.GA17297@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> scsi_cmnd.request_buffer is always a scatterlist these days.  Checking
> random bites into it and then mangling the data in
> sbp2_check_sbp2_response will cause really bad memory corruption when
> you're not lucky enough to have the check not trigger by luck.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: scsi-misc-2.6/drivers/ieee1394/sbp2.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/ieee1394/sbp2.c	2006-06-02 18:20:18.000000000 +0200
> +++ scsi-misc-2.6/drivers/ieee1394/sbp2.c	2006-06-03 13:28:23.000000000 +0200
> @@ -2038,33 +2038,6 @@
>  }
>  
>  /*
> - * This function is called after a command is completed, in order to do any necessary SBP-2
> - * response data translations for the SCSI stack
> - */
> -static void sbp2_check_sbp2_response(struct scsi_id_instance_data *scsi_id,
> -				     struct scsi_cmnd *SCpnt)
> -{
[...]

Thanks, but this change plus minor whitespace edits made it "already" 
into -mm:
sbp2: remove manipulation of inquiry response
http://marc.theaimsgroup.com/?l=linux-mm-commits&m=114928458408313
-- 
Stefan Richter
-=====-=-==- -==- ---==
http://arcgraph.de/sr/
