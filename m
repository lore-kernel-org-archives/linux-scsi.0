From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: SMP pass through interface via bsg
Date: Sun, 15 Apr 2007 20:14:43 +0300
Message-ID: <46225D83.2020204@panasas.com>
References: <20070403012747O.fujita.tomonori@lab.ntt.co.jp> <20070403014349E.fujita.tomonori@lab.ntt.co.jp> <1175533302.3680.31.camel@mulgrave.il.steeleye.com> <20070402221349L.fujita.tomonori@lab.ntt.co.jp> <20070402181238.GB15273@kernel.dk> <46114C24.1030003@cs.wisc.edu> <20070402183002.GF15273@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:60254 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753156AbXDORPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Apr 2007 13:15:24 -0400
In-Reply-To: <20070402183002.GF15273@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@SteelEye.com, hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Mon, Apr 02 2007, Mike Christie wrote:
>> Jens Axboe wrote:
>>> On Tue, Apr 03 2007, FUJITA Tomonori wrote:
>>>> From: James Bottomley <James.Bottomley@SteelEye.com>
>>>> Subject: Re: SMP pass through interface via bsg
>>>> Date: Mon, 02 Apr 2007 12:01:41 -0500
>>>>
>>>>> On Tue, 2007-04-03 at 01:43 +0900, FUJITA Tomonori wrote:
>>>>>> OK. I found another bug in smp_test tool (sends bogus response buffer
>>>>>> len to kernel). I've uploaded a new patch:
>>>>>>
>>>>>> http://zaal.org/bsg/smp-test2.diff
>>>>> That sort of works; you have a final bug in that the manufacturer info
>>>>> response frame is 64 bytes, not 128 bytes, but with that corrected
>>>>> everything goes through and I get the result back:
>>>>>
>>>>> hobholes:~# /home/jejb/git/sgv4-tools/smp_test /sys/class/bsg/expander-2\:0
>>>>>   SAS-1.1 format: 0
>>>>>   vendor identification: LSILOGIC
>>>>>   product identification: SASx12 A.0      
>>>>>   product revision level: 
>>>>>
>>>>> So we can class this one as a success ... 
>>>>>
>>>>> Thanks!
>>>> Great! Thanks. I'll try to finish the mpt driver's hook
>>>> sometime. Finally, We have a bsg user (though it also needs proper
>>>> bidi support).
>>>>
>>>> Jens, what remains to be done before bsg is merged into mainline?
>>> Well the bi-dir stuff and sg v4 design were the two bits that needed to
>>> get done before pushing bsg made sense, so we are getting there...
>>> Probably a 2.6.23 target, leaving the bidi bits a revision cycle to get
>>> sorted out.
>>>
>> Could we get the bidi parts in without having to do the other sg clean
>> ups (my patches to merge the blk_rq_map* with the scsi ULD (sg, etc,
>> etc) equivalents or do the clean ups have to be done first?
> 
> IMO the sg cleanups are an orthogonal effort.
> 

Following this e-mail is a patchset for bidi-support at the block layer.


Mike's sg patches will not apply trivially over the bidi patchset,
mainly at ll_rw_blk.c and scsi_lib.c. There were other people doing
cleanups in the direction of removing scsi_execute_async(). If these patches
add to ll_rw_blk.c/blkdev.h and eventually touch scsi_lib.c they might have
issues also. My suggestion is that Mike (and others) send me their latest patches
against Jens's block tree. (or point me to a git tree) so I can then help.

Boaz Harrosh




