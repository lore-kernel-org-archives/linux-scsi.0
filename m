From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
 count
Date: Wed, 05 Mar 2008 16:46:22 +0200
Message-ID: <47CEB23E.4000809@panasas.com>
References: <47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org> <47CDDC31.4070806@gmail.com> <20080305092619Y.fujita.tomonori@lab.ntt.co.jp> <47CE72EF.7050302@panasas.com> <20080305123317.GI6704@kernel.dk> <47CE9634.6040501@panasas.com> <20080305124857.GJ6704@kernel.dk> <47CEA40F.6050903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:59917 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYCEOv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 09:51:57 -0500
In-Reply-To: <47CEA40F.6050903@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Galbraith <efault@gmx.de>, James.Bottomley@HansenPartnership.com, tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Wed, Mar 05 2008 at 15:45 +0200, Tejun Heo <htejun@gmail.com> wrote:
> Hello, Jens, Boaz.
> 
> Jens Axboe wrote:
>>>>> From: Boaz Harrosh <bharrosh@panasas.com>
>>>>> Date: Wed, 5 Mar 2008 12:07:12 +0200
>>>>> Subject: [PATCH] blk: missing add of padded bytes to io completion byte count
>>>>>
>>>>> the commit e97a294ef6938512b655b1abf17656cf2b26f709 was very wrong. This is
>>>>> because scsi-ml supports the ability to split a request into smaller chunks,
>>>>> in which case scsi_bufflen() is smaller then request length. Then at completion
>>>>> time the remainder can be issued as a new scsi command. In that case the above
>>>>> commit is a data corruption.
> 
> Thanks for catching the stupidity.  Did it actually happen?  PC commands
> are not completed in pieces and padding / draining should only happen
> for those.  qc->extra_len should be zero where commands can be splitted
> for all current cases.

So qc->extra_len == 0 and nothing is done in that case.

> 
>>>> We needed something for -rc4, so it had to be rushed a bit...
>>>>
>>>>> Also in this fix all users of block layer are taken care of, and not only
>>>>> scsi devices.
>>>>>
>>>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>>>>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
>>>>> ---
>>>>>  block/blk-core.c    |    4 ++++
>>>>>  drivers/scsi/scsi.c |    2 +-
>>>>>  2 files changed, 5 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>>> index 2a438a9..37fcccc 100644
>>>>> --- a/block/blk-core.c
>>>>> +++ b/block/blk-core.c
>>>>> @@ -1549,6 +1549,9 @@ static int __end_that_request_first(struct request *req, int error,
>>>>>  			     nr_bytes >> 9, req->sector);
>>>>>  	}
>>>>>  
>>>>> +	if (nr_bytes >= blk_rq_bytes(req))
>>>>> +		nr_bytes += req->extra_len;
>>>>> +
> 
> This is getting insanely subtle.  Let's say there's PIO driver which
> transfer certain sized chunks at a time and completes request partially
> after completing each chunk and the driver uses draining to eat up
> whatever excess data, which seems like a legit use case to me.  But it
> won't work because __end_that_request_first() will terminate when it
> reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,
> 
> Nacked-by: Tejun Heo <htejun@gmail.com>
> 

I don't understand? Drivers can still do that. Do you mean That it wants
to also complete the draining portion in smaller chunks? I thought the draining
is always done at once, at most. Is that theoretical or is it so in any of the 
drivers.

Any way Nack from my side on the scsi_finish_command(), it makes too many 
assumptions that are unchecked anywhere. And it's a terrible layering violation.
scsi is a pass-threw block device, the fix should be in block or in using device
drivers (eg libata), that know what is going on.

Any way you are always saying req->data_len == sum(sg) but that  was certainly
never true for scsi_bufflen() == sum(sg) so leave that alone please.

Any other block layer fixes are welcome. But for now this is the best fix we have
that only breaks theoretical, yet to be submitted drivers.

Boaz
