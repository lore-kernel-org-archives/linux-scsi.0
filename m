From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] improvement of fastfail operation
Date: Wed, 31 Mar 2004 23:53:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406BCA7D.40208@cs.wisc.edu>
References: <1080696593.2075.120.camel@mulgrave> <Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com> <20040331220416.GQ24370@suse.de> <1080771068.2071.48.camel@mulgrave> <20040331221241.GR24370@suse.de> <406B512F.9090004@us.ibm.com> <406BC50E.6090100@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020305070305020005030702"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36114 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262471AbUDAHxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2004 02:53:48 -0500
In-Reply-To: <406BC50E.6090100@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>

This is a multi-part message in MIME format.
--------------020305070305020005030702
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Mike Christie wrote:
> On Wed, Mar 31 2004, Mike Christie wrote:
> 
>> Jens Axboe wrote:
>> >On Wed, Mar 31 2004, James Bottomley wrote:
>> >
>> >>On Wed, 2004-03-31 at 17:04, Jens Axboe wrote:
>> >>
>> >>>So the new patch you sent with this mail is no good. Your previous one
>> >>>should be adopted ;-)
>> >>
>> >>And the:
>> >>
>> >>
>> >>        if (blk_pc_request(req))
>> >>            leftover = req->data_len - bytes;
>> >>
>> >>Since end_that_request chunk won't muck with that, is that OK?
>> >
>> >
>> >It's a bit messy right now really, but it's up to the drivers to modify
>> >that one. So for partial completions, it should be updated to be
>> >
>> >    leftover = req->data_len;
>> >
>> >as well.
>> >
>>
>> Is that a typo? If drivers are to account for it, scsi should do
>>     leftover = req->data_len - bytes;
>> ?
> 
> 
> No, scsi_io_completion() should already have done it.
> 

Oops. Thanks.


James,

The attached patch fixes the leftover calculation for both
blk pc and blk fs requests per Jens's comments. It was
built against 2.6.5-rc3.

Thanks,

Mike

--------------020305070305020005030702
Content-Type: text/plain;
 name="calc_leftovers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="calc_leftovers.patch"

--- linux-2.6.5-rc3/drivers/scsi/scsi_lib.c	2004-03-29 19:26:15.000000000 -0800
+++ linux-2.6.5-rc3-work/drivers/scsi/scsi_lib.c	2004-03-31 23:23:20.051292415 -0800
@@ -524,10 +524,10 @@ static struct scsi_cmnd *scsi_end_reques
 	 * to queue the remainder of them.
 	 */
 	if (end_that_request_chunk(req, uptodate, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9) - bytes;
+		int leftover = req->hard_nr_sectors << 9;
 
 		if (blk_pc_request(req))
-			leftover = req->data_len - bytes;
+			leftover = req->data_len;
 
 		/* kill remainder if no retrys */
 		if (!uptodate && blk_noretry_request(req))

--------------020305070305020005030702--

