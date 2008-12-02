From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
Date: Mon, 01 Dec 2008 19:10:39 -0800
Message-ID: <1228187439.13241.176.camel@haakon2.linux-iscsi.org>
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org>
	 <1228183480.13241.163.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:38058 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751516AbYLBDLQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 22:11:16 -0500
In-Reply-To: <1228183480.13241.163.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Mon, 2008-12-01 at 18:04 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2008-12-01 at 17:52 -0800, Nicholas A. Bellinger wrote:
> > Greetings Tomo-san and Co,
> > 
> > With the ongoing work in Linux/SCSI for v2.6.28 to map target mode
> > struct scatterlist memory directly down to struct scsi_cmnd without the
> > need for a intermediate struct bio as with the existing
> > scsi_execute_async(), I have started the porting process for the
> > Linux/SCSI subsystem plugin in generic target core v3.0
> > (lio-core-2.6.git) on v2.6.28-rc6.
> > 
> > So far, using struct request for ICF_SCSI_CONTROL_NONSG_IO_CDB is up
> > using blk_rq_map_kern(), as well as ICF_SCSI_NON_DATA_CDB ops using
> > struct request.  In order to get the first READ_10s of type
> > ICF_SCSI_DATA_SG_IO_CDB to work, I had to add a temporary
> > EXPORT_SYMBOL_GPL() for drivers/scsi/scsi_lib.c:scsi_req_map_sg() in
> > lio-core-2.6.git for v2.6.28-rc6 in order to get TYPE_DISK up using an
> > software emulated MPT-Fusion HBA driver with struct request.  I have
> > been looking at drivers/scsi/scsi_tgt_lib.c() (which currently uses
> > struct request), and I figure we need something similar for the generic
> > target infrastructure, although __scsi_get_command() and
> > __scsi_put_command() are currently used in that code.
> > 
> > Below is what my patch looks like so far, I will probably just end up
> > commiting an temporary ifdef to keep scsi_execute_async() until the
> > proper pieces are in place and the other issues are resolved below.
> > >From there I will be able to drop in the proper upstream mapping bits
> > for struct scatterlist in
> > drivers/lio-core/target_core_pscsi.c:pscsi_map_task_SG() get rid of
> > scsi_req_map_sg() usage all together.
> > 
> > So far during my initial testing, I am running into a two different
> > exceptions.  One NULL pointer deference OOPS after half dozen Open/iSCSI
> > login/logouts in block/elevator.c:elv_dequeue_request().   Here is the
> > trace from SCSI softirq context:
> > 
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-0.png
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-1.png
> > 
> > The other one is a BUG_ON in blk/blk-timeout.c:177 in blk_add_timeout()
> > that happens after a few hundred MB of READ_10 traffic, which also
> > appears to pass through elv_dequeue_request() at some point:
> > 
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-2.png
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-4.png
> > 
> 
> Ok, I just saw this patch:
> 
> [PATCH 2.6.28-rc6] block: internal dequeue shouldn't start timer
> 
> at http://lkml.org/lkml/2008/11/27/394.
> 
> It sounds very similar and I will try it out and see if it resolves the
> issues above.
> 

Ok, patch applied and rerunning, this time after ~20 Open/iSCSI
--login/--logout ops.  The same BUG_ON in blk/blk-timeout.c:177 in
blk_add_timeout() again triggered again, this time coming from
blkdev_dequeue_request() -> scsi_request_fn() ->
__generic_unplugin_device().

http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-5.png

blkdev_dequeue_request() is used in a few other places in drivers/scsi:

target:/mnt/sdb/lio-core-2.6/drivers/scsi# grep blkdev_dequeue_request *
Binary file built-in.o matches
scsi_lib.c:	blkdev_dequeue_request(req);
scsi_lib.c:			blkdev_dequeue_request(req);
Binary file scsi_lib.o matches
Binary file scsi_mod.o matches
scsi_transport_sas.c:		blkdev_dequeue_request(req);

Do these need to be changed to use elv_dequeue_request() as well..?

--nab

