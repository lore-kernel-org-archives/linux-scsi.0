From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sat, 17 Sep 2005 14:57:23 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
References: <1126845599.9276.44.camel@max>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep31-0.kolumbus.fi ([193.229.0.35]:40045 "EHLO
	fep31-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751082AbVIQLwC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 07:52:02 -0400
In-Reply-To: <1126845599.9276.44.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, 15 Sep 2005, Mike Christie wrote:

> Convert st to use scsi_execute_async.
> 
> I made scsi_execute_async take a scatterlist so there was not much todo.
> I allocate st_request with GFP_KERNEL but will send another patch to
> allocate it within the st_buffer if you want.
> 
I can think about this and change it later if necessary. Both approaches 
have pros and cons.

> The strange thing is that it looks like st could have always been
> sending down scatterlists before. This (bytes > (STp->buffer)->frp[0].length)
> test here:
> 
>        SRpnt->sr_use_sg = STp->buffer->do_dio || (bytes > (STp->buffer)->frp[0].length);
>        if (SRpnt->sr_use_sg) {
>                if (!STp->buffer->do_dio)
>                        buf_to_sg(STp->buffer, bytes);
>                SRpnt->sr_use_sg = (STp->buffer)->sg_segs;
>                bp = (char *) &((STp->buffer)->sg[0]);
>        } else
>                bp = (STp->buffer)->b_data;
> 
> looks like st was sending down use_sg=0 on purpose for the
> one segment case. Is this a leftover from old scsi code? If so
> it does not look like there was much to change, so I merged
> your patch except the max_pfn part since I reverted all my
> related changes.
> 
Yes, it is a leftover from the time when not all HBA drivers supported 
scatterlists. I should have eliminated the non-scatterlist case while 
doing other changes but I have never remembered it at the right time ;-)


I have continued testing with your new patch. No oopses but it does not 
pass all of the tests.

I think I may have found the problem: scsi_execute_async does not use the 
parameter retries (the same applies to scsi_execute btw). This leads to 
retrying the reads at filemark and this is not correct. I added the hack 
below to scsi_execute_async and after this the simple tests succeed.

--- linux-2.6.14-rc1-blk3/drivers/scsi/scsi_lib.c~	2005-09-16 21:44:05.000000000 +0300
+++ linux-2.6.14-rc1-blk3/drivers/scsi/scsi_lib.c	2005-09-17 14:21:14.000000000 +0300
@@ -428,6 +428,8 @@ int scsi_execute_async(struct scsi_devic
 	req->sense_len = 0;
 	req->timeout = timeout;
 	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
+	if (retries == 0)
+		req->flags |= REQ_FAILFAST;
 	req->end_io_data = sioc;
 
 	sioc->data = privdata;

This is not a real solution though. There should be some control over 
retries from the scsi ULDs but I did not directly see how to do it. 
Looking at the tests I did a couple of days, the number of retries seemed 
to be variable (i.e., the number of retries I saw in the same test today 
and a couple of days ago didn't match).

-- 
Kai
