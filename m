From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
Date: Tue, 2 Dec 2008 01:13:35 -0800
Message-ID: <20081202091335.GA16081@linux.vnet.ibm.com>
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org> <1228183480.13241.163.camel@haakon2.linux-iscsi.org> <1228187439.13241.176.camel@haakon2.linux-iscsi.org> <4934B71C.4030907@kernel.org> <1228194335.6229.17.camel@haakon2.linux-iscsi.org> <20081202064036.GC14025@linux.vnet.ibm.com> <1228206646.6229.46.camel@haakon2.linux-iscsi.org> <1228206924.6229.50.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35272 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYLBJNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 04:13:40 -0500
Content-Disposition: inline
In-Reply-To: <1228206924.6229.50.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> On Tue, 2008-12-02 at 00:30 -0800, Nicholas A. Bellinger wrote:
> > On Mon, 2008-12-01 at 22:40 -0800, Mike Anderson wrote:
> > > Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > > > On Tue, 2008-12-02 at 13:18 +0900, Tejun Heo wrote:
> > > > > 
> > > > > >>> The other one is a BUG_ON in blk/blk-timeout.c:177 in blk_add_timeout()
> > > > > >>> that happens after a few hundred MB of READ_10 traffic, which also
> > > > > >>> appears to pass through elv_dequeue_request() at some point:
> > > > > >>>
> > > > > >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-2.png
> > > > > >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-4.png
> > > > >
> > > > > Hmmm... this means blk_add_timer() is being called after the request
> > > > > is already completed.
> > > 
> > > or is it possible since elv_dequeue_request BUG_ON check of queuelist did
> > > not trigger a request is on the queuelist with a timeout_list not empty.
> > > 
> > > It would be interesting for a debug run to change the
> > > "BUG_ON(!list_empty(&req->timeout_list))" in blk_add_timer to print out
> > > the cmd_flags plus req->atomic_flags and also add a
> > > "BUG_ON(!list_empty(&rq->timeout_list))" to elv_insert to ensure a request
> > > is never added to the queuelist with a timeout_list not empty.
> > > 
> > 
> > Ok, so blk_dump_rq_flags() is now being called in
> > block/blk-timeout.c:blk_add_timer() for the case
> > BUG_ON(list_empty(&req->timeout_list)) case:
> > 
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-6.png
> > 
> > Hmm, the outputted "sector " range is definately is bogus, as the only
> > READ_10 that have been sent are at LBA offset 0 for 8 * 512 byte sectors
> > for the partition table during Open/iSCSI LUN scanning.
> > 
> 
> Also, the following code from block/blk-core.c:blk_dump_rq_flags():
> 
>         if (blk_pc_request(rq)) {
>                 printk(KERN_INFO "  cdb: ");
>                 for (bit = 0; bit < BLK_MAX_CDB; bit++)
>                         printk("%02x ", rq->cmd[bit]);
>                 printk("\n");
>         }
> 
> is not printing out the copied CDB in struct request->cmd[], which makes
> me think the struct request->cmd_flags (that blk_pc_request() is
> checking) are also bogus when blk_add_timer() is being called..
> 
Based on the output from 2.6.28-rc6-oops-6.png the flags value of 82c21
looks like
(__REQ_ALLOCED,__REQ_ELVPRIV,__REQ_DONTPREP,__REQ_STARTED,__REQ_SORTED,__REQ_RW),
but it is late so someone maybe should check my shift counts.

The type is also REQ_TYPE_FS so the blk_pc cdb: info will not be printed.

I will talk to you more in the morning.

> --nab
> 
> > --nab
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
