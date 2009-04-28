From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH] limit state change to SDEV_BLOCK devices in	scsi_internal_device_unblock
Date: Mon, 27 Apr 2009 20:31:33 -0600
Message-ID: <20090428023132.GI1926@parisc-linux.org>
References: <49F5E6E5.20904@redhat.com> <1240862889.3387.37.camel@mulgrave.int.hansenpartnership.com> <49F64559.5020802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54185 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbZD1Cbe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 22:31:34 -0400
Content-Disposition: inline
In-Reply-To: <49F64559.5020802@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Takahiro Yasui <tyasui@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, mchristi@redhat.com, mbarrow@redhat.com

On Mon, Apr 27, 2009 at 07:52:57PM -0400, Takahiro Yasui wrote:
> James Bottomley wrote:
> >> +	if (sdev->sdev_state != SDEV_BLOCK)
> > 
> > This isn't quite correct.  There are two blocked states in the model
> > currently:  SDEV_BLOCK and SDEV_CREATED_BLOCK ... you'd need to check
> > for both of them
> > 
> >> +		return 0;
> > 
> > Traditionally the return for an attempted invalid state transition is
> > -EINVAL.
> > 
> > I suppose for lower down, if you check the state, now we know we go 
> > 
> > SDEV_CREATED_BLOCK -> SDEV_CREATED
> > 
> > or
> > 
> > SDEV_BLOCK -> SDEV_RUNNING
> > 
> > so there's no need for the dual scsi_device_set_state.
> 
> Thank you for the comments. If I understand your comments correctly, 
> the state transition is better to be defined in scsi_device_set_state(),
> and both transitions, "SDEV_CREATED_BLOCK -> SDEV_CREATED" and
> "SDEV_BLOCK -> SDEV_RUNNING" need to be covered. I updated the patch
> so that the transition of "SDEV_OFFLINE -> SDEV_RUNNING" is prohibited.

I don't think that's what he meant.  I think he meant something more like:

scsi_internal_device_unblock(struct scsi_device *sdev)
{
	struct request_queue *q = sdev->request_queue;
-	int err;
	unsigned long flags;

	/*
	 * Try to transition the scsi device to SDEV_RUNNING
	 * and goose the device queue if successful.
	 */

+	if (sdev->sdev_state == SDEV_CREATED_BLOCK)
+		sdev->sdev_state = SDEV_CREATED;
+	else if (sdev->sdev_state == SDEV_BLOCK)
+		sdev->sdev_state = SDEV_RUNNING;
+	else
+		return -EINVAL;

-	err = scsi_device_set_state(sdev, SDEV_RUNNING);
-	if (err) {
-		err = scsi_device_set_state(sdev, SDEV_CREATED);
-
-		if (err)
-			return err;
-	}

	spin_lock_irqsave(q->queue_lock, flags);
	blk_start_queue(q);
	spin_unlock_irqrestore(q->queue_lock, flags);

	return 0;
}

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
