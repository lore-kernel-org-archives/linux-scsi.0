From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional	legacy	scsi_execute_async()
 usage for Linux/SCSI passthrough
Date: Wed, 22 Apr 2009 15:34:12 +0300
Message-ID: <49EF0EC4.7090400@panasas.com>
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org>	 <49EB036B.8090607@panasas.com> <1240259765.4176.764.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:8334 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZDVMe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 08:34:26 -0400
In-Reply-To: <1240259765.4176.764.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Paul Mundt <lethal@linux-sh.org>

On 04/20/2009 11:36 PM, Nicholas A. Bellinger wrote:
> On Sun, 2009-04-19 at 13:56 +0300, Boaz Harrosh wrote:
>> Are you aware that scsi_execute_async() has gone in 2.6.30-rc1?
>>
>> I'm not sure what would be the best alternative for you. I would say
>> a bio, but it is still being debated. Your current options are:
>>
>> 1. bio_alloc then loop () bio_add_pc_page, and finally blk_rq_append_bio
>>    (Which block people don't like)
>> 2. sglist => page-pointers-array translation and blk_rq_map_user with 
>>    struct rq_map_data mode. (not possible with all kind of sglists)
>> 2. sglist => iovec translation and blk_rq_map_user_iov()
>>    (Very very ugly mapping of pages to virtual pointers)
>>
>> I have a similar situation with my OSD code.
>>
> 
> Hey,
> 
> Thanks for the pointers on this..  Yeah, I knew it was going away soon,
> but needed it for some legacy drivers..:-)
> 
> Anyways, I will drop this patch for scsi_execute_async() when I branch
> for v2.6.30-rcX and look and updating target_core_mod/pSCSI to one of
> the listed methods to get up and running.  From the looks of it however
> we might want something slightly better than blk_rq_map_user() for the
> kernel space pages attached to struct scatterlist and page_links..
> 
> Just FYI, the target_core_mod struct scatterlist memory will be in
> struct list_head with struct page for allocated se_cmd_t (received CDB),
> so it will be pretty easy from the target_core_mod+subsystem plugin side
> side to put something that along the lines of list =>
> page-pointers-array translation and blk_rq_map_user() into a new
> function..

Be ware that page-pointers-array mean that only first/last page can be
incomplete and all middle pages must be full PAGE_SIZE. As I recall this
might not be the case for network sglists.

> 
> lio-core-2.6.git/drivers/target/target_core_transport.c is using
> include/linux/scatterlist.h macros when interacting with struct
> scatterlist allocated for each subsystem plugin (from the linked list
> struct page memory)  I will have a look and see what would need to be
> down to allow all kinds of sglists with something new..
> 

right, in the general sglist model, only linked-bios will fit one-to-one.

You should look into something like Tejun's RFCed blk_rq_map_kern_sgl()
(Which was not yet accepted)

> Thanks for your comments!
> 
> --nab
> 
> 

We'll see what comes up
Boaz
