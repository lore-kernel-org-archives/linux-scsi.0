From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 05:15:34 -0700
Message-ID: <20051223121534.GM2361@parisc-linux.org>
References: <200512212359.jBLNxluV016971@hera.kernel.org> <20051222221329.5f317b8d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52127 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1030511AbVLWMPf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 07:15:35 -0500
Content-Disposition: inline
In-Reply-To: <20051222221329.5f317b8d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Dec 22, 2005 at 10:13:29PM -0800, Andrew Morton wrote:
> > +	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
> > +	struct scsi_target *starget = wqw->starget;
> > +	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> > +	unsigned long flags;
> > +
> > +	kfree(wqw);
> > +
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +
> > +	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
> > +		list_del_init(&starget->siblings);
> > +		spin_unlock_irqrestore(shost->host_lock, flags);
> > +		device_del(&starget->dev);
> > +		transport_unregister_device(&starget->dev);
> > +		put_device(&starget->dev);
> > +		return;
> > +
> > +	}
> > +	spin_unlock_irqrestore(shost->host_lock, flags);
> > +
> > +	return;
> > +}
> 
> Given that this can run an arbitrary amount of time later on, how do we
> know that *shost is still live?

If there's still an starget, its parent shost must still be around, no?

