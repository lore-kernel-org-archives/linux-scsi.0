From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Tue, 15 Feb 2005 19:46:51 -0600
Message-ID: <1108518411.5539.83.camel@mulgrave>
References: <7526e305050215152950f5a69e@mail.gmail.com>
	 <1108513997.5539.76.camel@mulgrave> <20050216005325.GC6859@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:48359 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261869AbVBPBr2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 20:47:28 -0500
In-Reply-To: <20050216005325.GC6859@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Joe Scsi <joe.scsi@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-02-15 at 16:53 -0800, Andrew Vasquez wrote:
> Yes, but the parent needs to know if the starget is actually created.
> With the fc_rports snapshot I've been working with, I've coded up the
> following:

Why do you need to know if the scan actually found any LUNs?

> 
> +	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
> +	    SCAN_WILD_CARD, 0);
> +
> +	dev = container_of(rport->dev.children.next, struct device, node);
> +	rport->starget = to_scsi_target(dev);

can we get rid of this too ... does the rport really need to know if it
has a target?

> +	if (unlikely(!rport->starget))
> 		dev_printk(KERN_ERR, &rport->dev, TGT_ALLOC_FAILURE_MSG,
> 				__FUNCTION__, shost->host_no);
> 
> so when the rport gets dropped (i.e. fc_remote_port_delete()), a
> scsi_remove_target() call can be issued.  I'm not entirely thrilled
> with the structure-member poking (any other suggestions on how to get
> the child, welcomed), but it does work.

Well, how about a different format for this, so there's a
scsi_remove_target that takes a generic device (analogous to the
scsi_scan_target) except that this time if the device isn't a target, we
remove all the children of the device that are targets?

> Also, the patch neglected to add scsi_scan_target() to an appropriate
> header file.  Attached patch will cure -- I've added it to
> scsi_host.h, may wish to add to scsi_device.h.

Yes, it should be in scsi_device.h which is where the scsi target
functions currently are.  I'll add it.

James


