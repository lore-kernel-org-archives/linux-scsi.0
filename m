From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Wed, 13 May 2009 17:28:10 +0300
Message-ID: <4A0AD8FA.6030903@panasas.com>
References: <4A0307F4.50205@panasas.com> <20090512112539.GH4140@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:5558 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754398AbZEMO2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2009 10:28:22 -0400
In-Reply-To: <20090512112539.GH4140@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 05/12/2009 02:25 PM, Jens Axboe wrote:
> On Thu, May 07 2009, Boaz Harrosh wrote:
>> Osd library needs to submit pre-allocated bios, form several sources.
>> osdblk exofs and pNFS-layout driver all have prepared bios for IO submission.
>> On top of that the osd library needs to append additional segments to the
>> IO memory, for get/set attributes and more.
>>
>> All these are done today by use of a temporary hack - blk_rq_append_bio.
>> This is bad on few accounts.
>> 1. blk_rq_append_bio was not meant to be exported and is very specific to its users.
>> 2. blk_rq_append_bio does not support chained bios.
>> 3. blk_rq_append_bio does not bounce the bio and therefore current osd implementation
>>    has a bug.
>>
>> The proposed solution adds two new fixtures to the block layer, and a corresponding
>> fixing patch to osd. These are:
>>
>> [PATCH 1/4] allow blk_rq_map_kern to append to requests
>> [PATCH 2/4] libosd: Use new blk_rq_map_kern
>>
>>   This is originally a James patch and it's used, to let blk_rq_map_kern append it's buffer
>>   to existing bio, and there for is able to be called multiple times in a loop, to append
>>   multiple segments. This API can also be useful for scsi/block targets that have segment
>>   information in some other memory structure (like scatterlist) and wants to set it into
>>   a request. Until such time that they have a proper support for mapping scatterlists directly.
>>   (Since above called on long lists might not be good for performance)
>>
>>   Here in osd it makes tons of sense, and should be considered for inclusion.
>>   (The patches are based on linus-tip but should patch on block tree)
>>
>> [RFC 3/4] New blk_make_request(), takes bio, returns a request
>> [RFC 4/4] libosd: Use of new blk_make_request
>>   
>>   Here I propose a new block API, that will support proper delegation of a bio
>>   to a full request. Please read inside the patch descriptions for details.
>>   After this patch both osd and block layer will have the proper support for osdblk
>>   driver as well as future needs.
>>   These patches also eliminate the last use of blk_rq_append_bio which can be now un-exported.
>>
>>   These two patches conflic with Tejun's branch and are based on linus-tip. Upon positive review
>>   I will serialize them with Tejun and submit them properly. But first they must be agreed upon.
>>   Jens, I specially need your opinion on this?
> 
> Looks sane to me. Can you resubmit against 'for-2.6.31' of the block git
> repo?
> 

Thanks Jens.

I have done the rebase and ran some tests, however I was unable to test these patches
as is, because there are some inter tree fallouts.

Jens, James, Stephan, I please need your help

The situation is like that.
- Both block/for-next and scsi/master are based on an old osd upstream-point (v2.6.30-rc3--ce8a7424)
- Linus tip has important OSD patches that went in via scsi-rc-fixes which changed Wire format
- If I try and merge block/for-next ontop of plain linus/master I get a merge conflict
- If I try merge scsi/master block/for-next I get build errors / conflicts

So there is no sane tree point that I can test on.

It would be nice if both Jens block/for-next and scsi-misc/master could be rebased on Linus rc5++
and resolve these conflicts. (And scsi-misc conflicts with Tejun's cleanups be put in a second stage
tree)

Should I send the patches as is half tested? Or wait for things to settle after I tested them
with all changes included?

I have cut a new osd/linux-next branch which is based, not on linus, but on v2.6.30-rc3--ce8a7424
the base point for block/for-next and scsi-misc/master. So in next it should all come together
well, and I will try to clone tomorrow's next and test on top of that.

Please Advise on what I should do?

Thanks in advance
Boaz
