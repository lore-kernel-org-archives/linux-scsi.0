From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
Date: Mon, 01 Dec 2008 23:49:23 -0800
Message-ID: <1228204163.6229.26.camel@haakon2.linux-iscsi.org>
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org>
	 <1228183480.13241.163.camel@haakon2.linux-iscsi.org>
	 <1228187439.13241.176.camel@haakon2.linux-iscsi.org>
	 <4934B71C.4030907@kernel.org>
	 <1228194335.6229.17.camel@haakon2.linux-iscsi.org>
	 <20081202064036.GC14025@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:20771 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750727AbYLBHt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 02:49:26 -0500
In-Reply-To: <20081202064036.GC14025@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Mon, 2008-12-01 at 22:40 -0800, Mike Anderson wrote:
> Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > On Tue, 2008-12-02 at 13:18 +0900, Tejun Heo wrote:
> > > 
> > > >>> The other one is a BUG_ON in blk/blk-timeout.c:177 in blk_add_timeout()
> > > >>> that happens after a few hundred MB of READ_10 traffic, which also
> > > >>> appears to pass through elv_dequeue_request() at some point:
> > > >>>
> > > >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-2.png
> > > >>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-4.png
> > >
> > > Hmmm... this means blk_add_timer() is being called after the request
> > > is already completed.
> 
> or is it possible since elv_dequeue_request BUG_ON check of queuelist did
> not trigger a request is on the queuelist with a timeout_list not empty.
> 
> It would be interesting for a debug run to change the
> "BUG_ON(!list_empty(&req->timeout_list))" in blk_add_timer to print out
> the cmd_flags plus req->atomic_flags and also add a
> "BUG_ON(!list_empty(&rq->timeout_list))" to elv_insert to ensure a request
> is never added to the queuelist with a timeout_list not empty.
> 

Sounds good.   I will retest w/o the previous changes to scsi_lib.c for
elv_dequeue_request() and see what happens.

Thanks for your comments,

--nab

