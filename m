From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] sg_cmd_done - another oops
Date: Sun, 6 Jun 2004 10:49:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606084925.GA2733@suse.de>
References: <40C0968E.4090309@us.ibm.com> <Pine.LNX.4.44.0406051448470.1429-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:26014 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263126AbUFFItl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 04:49:41 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0406051448470.1429-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Brian King <brking@us.ibm.com>, dougg@torque.net, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Jun 05 2004, Guennadi Liakhovetski wrote:
> On Fri, 4 Jun 2004, Brian King wrote:
> 
> > static int
> >+sg_srp_done(Sg_request *srp, Sg_fd *sfp)
> >+{
> >+       unsigned long iflags;
> >+       int done;
> >+
> >+       read_lock_irqsave(&sfp->rq_list_lock, iflags);
> >+       done = srp->done;
> >+       read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> >+       return done;
> >+}
> 
> Hm, maybe I don't understand something - why do you have to close local
> interrupts here
> 
> >@@ -772,7 +784,9 @@ sg_ioctl(struct inode *inode, struct fil
> >                                srp->orphan = 1;
> >                                return result;  /* -ERESTARTSYS because signal
> >hit process */
> >                        }
> >+                       write_lock_irqsave(&sfp->rq_list_lock, iflags);
> >                        srp->done = 2;
> >+                       write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> 
> and here? Wouldn't a read/write_lock() suffice?

interrupt -> sg_cmd_done -> sg_finish_rem_req -> write_lock on
rq_list_lock.

-- 
Jens Axboe

