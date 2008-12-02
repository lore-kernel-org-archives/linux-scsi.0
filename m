From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
Date: Mon, 1 Dec 2008 22:40:36 -0800
Message-ID: <20081202064036.GC14025@linux.vnet.ibm.com>
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org> <1228183480.13241.163.camel@haakon2.linux-iscsi.org> <1228187439.13241.176.camel@haakon2.linux-iscsi.org> <4934B71C.4030907@kernel.org> <1228194335.6229.17.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43689 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYLBGkm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 01:40:42 -0500
Content-Disposition: inline
In-Reply-To: <1228194335.6229.17.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> On Tue, 2008-12-02 at 13:18 +0900, Tejun Heo wrote:
> > 
> > >>> The other one is a BUG_ON in blk/blk-timeout.c:177 in blk_add_timeout()
> > >>> that happens after a few hundred MB of READ_10 traffic, which also
> > >>> appears to pass through elv_dequeue_request() at some point:
> > >>>
> > >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-2.png
> > >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-4.png
> >
> > Hmmm... this means blk_add_timer() is being called after the request
> > is already completed.

or is it possible since elv_dequeue_request BUG_ON check of queuelist did
not trigger a request is on the queuelist with a timeout_list not empty.

It would be interesting for a debug run to change the
"BUG_ON(!list_empty(&req->timeout_list))" in blk_add_timer to print out
the cmd_flags plus req->atomic_flags and also add a
"BUG_ON(!list_empty(&rq->timeout_list))" to elv_insert to ensure a request
is never added to the queuelist with a timeout_list not empty.

> All the problem discovered till now have to do
> > with timeout going off without the low level driver knowing about the
> > request.  I don't have much idea and it'll probably be best to trace
> > what's going on using blktrace or printks.
> 
> <nod>, OK.
> 
> >   Maybe this is caused by
> > list corruption as with the first issue or request completion races
> > with requeueing?
> 
> Hrmm, yeah, perhaps the use of scsi_req_map_sg() (which obviously still
> has struct bio behind it) is causing the breakage..  I will wait for
> Tomo, Boaz and co to have a look at the original patch to
> lio-core-2.6.git/drivers/lio-core/target_core_pscsi.c and see if I am
> missing something obvious.
> 
> Also, with the previous patch to drivers/scsi/scsi_lib.c(), I am able to
> move a few GB of bulk I/O and not hit the BUG_ON in
> blk/blk-timeout.c:177 in blk_add_timeout() mentioned above when feeding
> struct request into struct scsi_device->request_queue with
> blk_execute_rq_nowait() with use_sg > 0 CDBs.  However, I am still
> running into another reproducable BUG_ON in
> block/cfq-iosched.c:cfq_find_next_rq() after extended bulk I/O tests.
> 

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
