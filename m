From: Andy Grover <agrover@redhat.com>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Mon, 25 Jul 2011 18:09:18 -0700
Message-ID: <4E2E13BE.7000909@redhat.com>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>	 <20110725163739.5c19b04d.akpm@linux-foundation.org> <1311640376.17766.221.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1GZBJf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 21:09:35 -0400
In-Reply-To: <1311640376.17766.221.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

On 07/25/2011 05:32 PM, Nicholas A. Bellinger wrote:
> On Mon, 2011-07-25 at 16:37 -0700, Andrew Morton wrote:
>> On Sat, 23 Jul 2011 16:16:15 -0700
>> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
>>
>>> Please go ahead and pull from:
>>>
>>>   master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-merge
>>
>> i386 allyesconfig:
>>
>> ERROR: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!
>>
>> somewhere in drivers/target/target_core_transport.c:transport_allocate_data_tasks().
> 
> Mmmm, I was under the assumption that DIV_ROUND_UP() did unsigned long
> long division correctly for sector_t on 32-bit , but apparently not with
> the new v4.1 transport_allocate_data_tasks() code..   Andy..?  

sectors = DIV_ROUND_UP(cmd->data_length, sector_size);
task_count = DIV_ROUND_UP(sectors, dev_max_sectors);

sectors is a sector_t but the value will never be >32bits, since
data_length is u32.

We could just cast sectors to a u32 and be ok for this particular
usage... DIV_ROUND_UP handling 64bit would of course also resolve the
issue nicely.

Regards -- Andy
