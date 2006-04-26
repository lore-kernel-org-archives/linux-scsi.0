From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] drivers/scsi/sd.c: fix uninitialized variable in	handling
 medium errors
Date: Wed, 26 Apr 2006 19:04:59 -0400
Message-ID: <444FFC9B.4090603@rtr.ca>
References: <200604261627.29419.lkml@rtr.ca> <1146092161.12914.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:13018 "EHLO mail.rtr.ca")
	by vger.kernel.org with ESMTP id S1750754AbWDZXFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 19:05:19 -0400
In-Reply-To: <1146092161.12914.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>

James Bottomley wrote:
> On Wed, 2006-04-26 at 16:27 -0400, Mark Lord wrote:
>> From: Mark Lord <lkml@rtr.ca>
..
>> When scsi_get_sense_info_fld() fails (returns 0), it does NOT update the
>> value of first_err_block.  But sd_rw_intr() merrily continues to use that
>> variable regardless, possibly making incorrect decisions about retries and the like.
>>
>> This patch removes the randomness there, by using the first sector of the
>> request (SCpnt->request->sector) in such cases, instead of first_err_block.
..
> Thanks for finding the bug.  Your solution is a bit, um, convoluted.

Heh, no, that's the original sd.c.  I just tried to keep the patch
as tiny as possible to show what is needed.  You are welcome to add
complexity to it, though.  The surrounding code is, uhm, rather interesting.

> What it should really be doing if we find no valid information field is
> a break so we go out with the default good_sectors of zero (rather than
> arriving at that value via a circuitous route).

Yes, but the difficulty there is that all of the convoluted logic
seems to still be wanted to set a correct "block_sectors" value,
needed as a parameter on the final call:

    scsi_io_completion(SCpnt, good_bytes, block_sectors << 9);

>How does this work?
...

Looks potentially buggy (still).

Cheers
