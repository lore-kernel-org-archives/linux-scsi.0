From: Jens Axboe <axboe@suse.de>
Subject: Re: kernel BUG using multipath on 2.6.0-test5
Date: Fri, 26 Sep 2003 14:26:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926122646.GA15415@suse.de>
References: <1064541435.4763.51.camel@persist.az.mvista.com> <20030926121703.GG24824@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:15004 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262128AbTIZM0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 08:26:52 -0400
Content-Disposition: inline
In-Reply-To: <20030926121703.GG24824@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 26 2003, Matthew Wilcox wrote:
> On Thu, Sep 25, 2003 at 06:57:15PM -0700, Steven Dake wrote:
> > kernel BUG at drivers/scsi/scsi_lib.c:544!
> 
>         BUG_ON(!cmd->use_sg);
> 
> >  [<c01f631d>] scsi_init_io+0x7a/0x13d
> 
> static int scsi_init_io(struct scsi_cmnd *cmd)
>         struct request     *req = cmd->request;
>         cmd->use_sg = req->nr_phys_segments;
>         sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
> 
> >  [<c01f6455>] scsi_prep_fn+0x75/0x171
> 
> static int scsi_prep_fn(struct request_queue *q, struct request *req)
>         struct scsi_cmnd *cmd;
>         cmd->request = req;
>         ret = scsi_init_io(cmd);
> 
> .. this is getting outside my area of confidence.  Ask axboe why we might
> get a zero nr_phys_segments request passed in.

Looks like an mp bug. I'd suggest adding something ala

	if (!rq->nr_phys_segments || !rq->nr_hw_segments) {
		blk_dump_rq_flags(req, "scsi_init_io");
		return BLKPREP_KILL;
	}

inside the first

	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {

drivers/scsi/scsi_lib.c:scsi_prep_fn(). That will show the state of such
a buggy request. I'm pretty sure this is an mp bug though.

-- 
Jens Axboe

