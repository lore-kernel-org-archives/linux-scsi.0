From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] sg_cmd_done - another oops
Date: Sat, 5 Jun 2004 14:57:48 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406051448470.1429-100000@poirot.grange>
References: <40C0968E.4090309@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:7579 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261234AbUFEM6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jun 2004 08:58:36 -0400
In-Reply-To: <40C0968E.4090309@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: dougg@torque.net, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, 4 Jun 2004, Brian King wrote:

> static int
>+sg_srp_done(Sg_request *srp, Sg_fd *sfp)
>+{
>+       unsigned long iflags;
>+       int done;
>+
>+       read_lock_irqsave(&sfp->rq_list_lock, iflags);
>+       done = srp->done;
>+       read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>+       return done;
>+}

Hm, maybe I don't understand something - why do you have to close local
interrupts here

>@@ -772,7 +784,9 @@ sg_ioctl(struct inode *inode, struct fil
>                                srp->orphan = 1;
>                                return result;  /* -ERESTARTSYS because signal
>hit process */
>                        }
>+                       write_lock_irqsave(&sfp->rq_list_lock, iflags);
>                        srp->done = 2;
>+                       write_unlock_irqrestore(&sfp->rq_list_lock, iflags);

and here? Wouldn't a read/write_lock() suffice?

Guennadi
---
Guennadi Liakhovetski





