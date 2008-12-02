From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
Date: Mon, 01 Dec 2008 21:05:35 -0800
Message-ID: <1228194335.6229.17.camel@haakon2.linux-iscsi.org>
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org>
	 <1228183480.13241.163.camel@haakon2.linux-iscsi.org>
	 <1228187439.13241.176.camel@haakon2.linux-iscsi.org>
	 <4934B71C.4030907@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:20725 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751256AbYLBFFm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 00:05:42 -0500
In-Reply-To: <4934B71C.4030907@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Tue, 2008-12-02 at 13:18 +0900, Tejun Heo wrote:
> Nicholas A. Bellinger wrote:
> >>> So far during my initial testing, I am running into a two different
> >>> exceptions.  One NULL pointer deference OOPS after half dozen Open/iSCSI
> >>> login/logouts in block/elevator.c:elv_dequeue_request().   Here is the
> >>> trace from SCSI softirq context:
> >>>
> >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-0.png
> >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-1.png
> 
> Can you build with debug info and find out which line is the offending
> one?

(gdb) list *(elv_dequeue_request+0x1d)
0x1320 is in elv_dequeue_request (include/linux/list.h:92).
87	 * This is only for internal list manipulation where we know
88	 * the prev/next entries already!
89	 */
90	static inline void __list_del(struct list_head * prev, struct
list_head * next)
91	{
92		next->prev = prev;
93		prev->next = next;
94	}
95	
96	/**
(gdb) list *(elv_dequeue_request+0x19)
0x131c is in elv_dequeue_request (block/elevator.c:836).
831	EXPORT_SYMBOL(elv_next_request);
832	
833	void elv_dequeue_request(struct request_queue *q, struct request
*rq)
834	{
835		BUG_ON(list_empty(&rq->queuelist));
836		BUG_ON(ELV_ON_HASH(rq));
837	
838		list_del_init(&rq->queuelist);
839	
840		/*


> 
> >>> The other one is a BUG_ON in blk/blk-timeout.c:177 in blk_add_timeout()
> >>> that happens after a few hundred MB of READ_10 traffic, which also
> >>> appears to pass through elv_dequeue_request() at some point:
> >>>
> >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-2.png
> >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-4.png
>
> Hmmm... this means blk_add_timer() is being called after the request
> is already completed.  All the problem discovered till now have to do
> with timeout going off without the low level driver knowing about the
> request.  I don't have much idea and it'll probably be best to trace
> what's going on using blktrace or printks.

<nod>, OK.

>   Maybe this is caused by
> list corruption as with the first issue or request completion races
> with requeueing?

Hrmm, yeah, perhaps the use of scsi_req_map_sg() (which obviously still
has struct bio behind it) is causing the breakage..  I will wait for
Tomo, Boaz and co to have a look at the original patch to
lio-core-2.6.git/drivers/lio-core/target_core_pscsi.c and see if I am
missing something obvious.

Also, with the previous patch to drivers/scsi/scsi_lib.c(), I am able to
move a few GB of bulk I/O and not hit the BUG_ON in
blk/blk-timeout.c:177 in blk_add_timeout() mentioned above when feeding
struct request into struct scsi_device->request_queue with
blk_execute_rq_nowait() with use_sg > 0 CDBs.  However, I am still
running into another reproducable BUG_ON in
block/cfq-iosched.c:cfq_find_next_rq() after extended bulk I/O tests.

Many thanks for your comments,

--nab

> 

