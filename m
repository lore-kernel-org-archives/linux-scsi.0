From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Wed, 16 Feb 2005 09:54:33 -0800
Message-ID: <20050216175433.GC7203@plap.san.rr.com>
References: <7526e305050215152950f5a69e@mail.gmail.com> <1108513997.5539.76.camel@mulgrave> <20050216005325.GC6859@plap.qlogic.org> <1108518411.5539.83.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:17530 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262001AbVBPRyI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2005 12:54:08 -0500
Content-Disposition: inline
In-Reply-To: <1108518411.5539.83.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joe Scsi <joe.scsi@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 15 Feb 2005, James Bottomley wrote:

> On Tue, 2005-02-15 at 16:53 -0800, Andrew Vasquez wrote:
> > Yes, but the parent needs to know if the starget is actually created.
> > With the fc_rports snapshot I've been working with, I've coded up the
> > following:
> 
> Why do you need to know if the scan actually found any LUNs?
> 

originally, just to handle the starget-specific interfaces originally
defined.

> > +	if (unlikely(!rport->starget))
> > 		dev_printk(KERN_ERR, &rport->dev, TGT_ALLOC_FAILURE_MSG,
> > 				__FUNCTION__, shost->host_no);
> > 
> > so when the rport gets dropped (i.e. fc_remote_port_delete()), a
> > scsi_remove_target() call can be issued.  I'm not entirely thrilled
> > with the structure-member poking (any other suggestions on how to get
> > the child, welcomed), but it does work.
> 
> Well, how about a different format for this, so there's a
> scsi_remove_target that takes a generic device (analogous to the
> scsi_scan_target) except that this time if the device isn't a target, we
> remove all the children of the device that are targets?
> 

along the same vein, we'll also need generic-device accessors to block
and unblock all scsi_device children of an scsi_target.  currently,
scsi_internal_devive_[block|unblock]() is issued across all sdevs for
a given starget:

	void scsi_block_target(struct device *)
	void scsi_unblock_target(struct device *)

one caveat with these parent-accessors is that we also lose
'per-starget' (un)blocking/removal granualarity -- not sure if that's
going to be a problem for other interfaces in the future.

--
Andrew
