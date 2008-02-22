From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
Date: Fri, 22 Feb 2008 16:25:20 -0600
Message-ID: <47BF4BD0.7080008@cs.wisc.edu>
References: <47BD9588.9080803@compro.net> <47BEFD4B.9060803@cs.wisc.edu> <47BEFF5F.9020002@cs.wisc.edu> <47BF0CE2.306@compro.net> <47BF40D7.5050301@compro.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030405060806000504040204"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60628 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935751AbYBVWZd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 17:25:33 -0500
In-Reply-To: <47BF40D7.5050301@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@compro.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tony Battersby <tonyb@cybernetics.com>

This is a multi-part message in MIME format.
--------------030405060806000504040204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mark Hounschell wrote:
> Mark Hounschell wrote:
>> Mike Christie wrote:
>>> Mike Christie wrote:
>>>> Mark Hounschell wrote:
>>>>> I seem to have run into some sort of regression in the SG_IO
>>>>> interface of 2.6.24.2. I have an application that up until 2.6.24
>>>>> worked fine. The 2.6.23.16 kernel works fine.
>>>>>
>>>>> During reads I get these kernel messages. Writes and other functions
>>>>> _seem_ OK. Actually basic
>>>>> reads  are working. Its with large BC reads using an io_vec list that
>>>>> the problem shows up.
>>>>>
>>>> Are you doing SG_IO to the sg device (/dev/sg*) or to the block device
>>>> (/dev/sdX)?
>>> If you are doing SG_IO to the sg device, then I know of one regression
>>> (well not regression exactly, but I fixed a bug but the patch got
>>> partially overwritten by another patch and that caused a new bug). Both
>>> bugs are fixed in 2.6.25-rc2. Could you try that out if you are doing
>>> SG_IO to the sg device.
>>>
>> Yes, I'm using /dev/sg*. And yes again I'll checkout 2.6.25-rc2 ASIC.
>>
>> Thanks
>> Mark
>> -
>  
> 2.6.25-rc2 does fix the problem I'm having. I don't suppose there is a patch
> lying around for 2.6.24.2??
> 

I attached a backport of the patch from Tony (added as cc) that is in 
2.6.25-rc2. Could you try it out against 2.6.24.2 just to make sure it 
was this patch, then we can send it to stable.

--------------030405060806000504040204
Content-Type: text/x-patch;
 name="fix-passthrough-bufflen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-passthrough-bufflen.patch"

Backport
76d78300a6eb8b7f08e47703b7e68a659ffc2053
to 2.6.24

>From Tony Battersby:

When sending a SCSI command to a tape drive via the SCSI Generic (sg)
driver, if the command has a data transfer length more than
scatter_elem_sz (32 KB default) and not a multiple of 512, then I either
hit BUG_ON(!valid_dma_direction(direction)) in dma_unmap_sg() or else
the command never completes (depending on the LLDD).

When constructing scatterlists, the sg driver rounds up the scatterlist
element sizes to be a multiple of 512.  This can result in
sum(scatterlist lengths) > bufflen.  In this case, scsi_req_map_sg()
incorrectly sets bio->bi_size to sum(scatterlist lengths) rather than to
bufflen.  When the command completes, req_bio_endio() detects that
bio->bi_size != 0, and so it doesn't call bio_endio().  This causes the
command to be resubmitted, resulting in BUG_ON or the command never
completing.

This patch makes scsi_req_map_sg() set bio->bi_size to bufflen rather
than to sum(scatterlist lengths), which fixes the problem.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

--- linux-2.6.24.2/drivers/scsi/scsi_lib.c	2008-02-10 23:51:11.000000000 -0600
+++ linux-2.6.24.2.work/drivers/scsi/scsi_lib.c	2008-02-22 16:20:09.000000000 -0600
@@ -298,7 +298,6 @@ static int scsi_req_map_sg(struct reques
 		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
- 		data_len += len;
 
 		while (len > 0 && data_len > 0) {
 			/*

--------------030405060806000504040204--
