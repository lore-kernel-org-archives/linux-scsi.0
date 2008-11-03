From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 3 Nov 2008 14:46:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811031444130.2194-100000@iolanthe.rowland.org>
References: <20081103155254.GA3368@bit.office.eurotux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081103155254.GA3368-oEplIgxCSygGFt9iVWuREaMaJEuR8uiQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Linux-Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 3 Nov 2008, Luciano Rocha wrote:

> On Tue, Oct 28, 2008 at 01:38:11PM -0400, Alan Stern wrote:
> > > Do you wish me to test anything else?
> > 
> > Yes.  Please post a usbmon trace for each of the last two tests.  That 
> > is, with the unusual_devs update only, and with the unusual_devs update 
> > plus the invoke_transport update and the scsi_requeue_command update.
> 
> I've updated the bugzilla entry with traces for some combinations of the
> discussed patches:
> http://bugzilla.kernel.org/show_bug.cgi?id=11843

Okay, thanks.  I see the problem.  This whole area is a mess, and it's 
going to be different in 2.6.28.  But for now...

Please rerun the A+B and A+B+C tests, but this time using the B' patch
below instead of B.

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
@@ -690,6 +695,8 @@ static struct scsi_cmnd *scsi_end_reques
 				 * leftovers in the front of the
 				 * queue, and goose the queue again.
 				 */
+				if (bytes > 0)		/* Made progress */
+					++req->retries;
 				scsi_requeue_command(q, cmd);
 				cmd = NULL;
 			}

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
