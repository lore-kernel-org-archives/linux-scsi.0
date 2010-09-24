From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] scsi, fcoe, libfc: drop scsi host_lock use from  fc_queuecommand
Date: Fri, 24 Sep 2010 08:41:00 +0200
Message-ID: <4C9C47FC.5080304@fusionio.com>
References: <20100903222715.6237.75737.stgit@localhost.localdomain> <AANLkTinVTSboQB=kxyOCQ-eF6hYWqsn9YYJn7bnLeTtW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41448 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab0IXGlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2010 02:41:24 -0400
In-Reply-To: <AANLkTinVTSboQB=kxyOCQ-eF6hYWqsn9YYJn7bnLeTtW@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vasu Dev <vasu.dev@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-12 18:37, Bart Van Assche wrote:
> On Sat, Sep 4, 2010 at 12:27 AM, Vasu Dev <vasu.dev@intel.com> wrote:
>>
>> Currently fc_queuecommand drops this lock very early on and then re-acquires
>> this lock just before return, this re-acquired lock gets dropped immediately
>> by its fast path caller scsi_dispatch_cmd, this re-acquire and then immediate
>> drop on each IO hits performance especially with small size IOs on multi-core
>> systems, this hit is significant about 25% with 512 bytes size IOs.
>>
>> This lock is not needed in fc_queuecommand and calling fc_queuecommand
>> without this lock held removes above described performance hit.
>>
>> So this patch adds unlocked_qcmds flag to drop host_lock before
>> calling only fc_queuecommand and removes re-acquire &  then drop
>> for  each IO. Added flag, drops this lock only if LLD wants such
>> as fcoe.ko does here for fc_queuecommand. This change won't affect
>> any existing LLD since added unlocked_qcmds flag will be zero
>> in those cases and their host lock uses would effectively remain
>> same after this patch.
> [ ... ]
> 
> Hello Vasu,
> 
> While I don't doubt that your patch improves performance, there might
> be more bottlenecks in the Linux storage stack than the SCSI host
> lock. After having converted the SRP initiator (ib_srp) to use per-LUN
> locking instead of per-host locking and after having enabled
> unlocked_qcmds, I noticed that the largest source of contention was in
> the block layer. There was ten times more contention on
> request_queue.queue_lock than on any other spinlock. As you can see
> below, the four most contended locks in the test I ran were:
> * request_queue.queue_lock, needed by __make_request() in blk-core.c.
> * srp_target_port.lock, the per-LUN lock in ib_srp.c.
> * The SCSI host lock.
> * An AIO lock.
> 
> The test I ran used libaio and the NOOP scheduler. Block merging was
> disabled via sysfs.

Bart, can you try with this patchset added:

git://git.kernel.dk/linux-2.6-block.git blk-alloc-optimize

It's a work in progress and not suitable for general consumption yet,
but it's tested working at least. There will be more built on top of
this, but at least even this simple stuff is making a big difference
for IOPS testing for me.

-- 
Jens Axboe

