From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 16:10:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271605190.2190-100000@iolanthe.rowland.org>
References: <20081027165306.GA3875@bit.office.eurotux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081027165306.GA3875-oEplIgxCSygGFt9iVWuREaMaJEuR8uiQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Linux-Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 27 Oct 2008, Luciano Rocha wrote:

> > The patches are here:
> > 
> > 	http://marc.info/?l=linux-scsi&m=122443015406309&w=2
> > 
> > They are based on 2.6.27, not 2.6.28-rc.
> 
> I've tested them (on 2.6.27.4), but I still get the bug. That email mentions:
> "Neither patch addresses the infinite-retry problem; I wanted
> to keep the issues separate."
> 
> So am I missing some other patch?
> 
> 2.6.28-rc2 is also buggy.

Okay, I tried the same sort of experiment in 2.6.27.4 and got the same
result as you did.  I was able to fix it by applying the 8bfa24727
commit mentioned earlier together with the patch below.

Now, I'm pretty sure this is not the ideal solution.  Fixing the block 
core would be better.  Still, it does indicate for sure that there's a 
real problem.

It's worth noting that the test added to scsi_requeue_command() 
succeeds every time, that is, req->retries is always 0.  Clearly more 
work is needed.

Alan Stern



Index: 2.6.27.4/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.27.4.orig/drivers/scsi/scsi_lib.c
+++ 2.6.27.4/drivers/scsi/scsi_lib.c
@@ -611,6 +611,11 @@ static void scsi_requeue_command(struct 
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	if (--req->retries <= 0) {
+		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		scsi_next_command(cmd);
+		return;
+	}
 	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, req);

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
