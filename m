From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] SATA Transport Attributes
Date: Mon, 29 Mar 2004 20:23:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4068CC1A.3000803@pobox.com>
References: <20040330004601.GE18948@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16032 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263419AbUC3BX4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 20:23:56 -0500
In-Reply-To: <20040330004601.GE18948@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@sgi.com>, jeremy@sgi.com

Martin Hicks wrote:
> Hello,
> 
> Here is a patch that introduces a Transport Attribute class for SATA
> devices.  The patch also includes an update to the Vitesse driver to use
> the transport attribute.
> 
> The only problem that I'm having right now is that sometimes I get
> a NULL pointer dereference in scsi_remove_device() when I rmmod sata_vsc.
> Although sdev->host->transportt->cleanup is NULL coming into the
> function, the call to class_device_unregister(&sdev->transport_classdev)
> somtimes makes ->cleanup non-NULL and bad things happen from there.
> 
> I could not reproduce this when calling rmmod on the qla2200 driver. 
> 
> Any comments on this patch?  Any ideas about this rmmod issue?
> 
> The patch is against 2.6.5-rc1.


hmmm...  since libata is moving out of drivers/scsi in 2.7, I would 
rather leave it as-is.  The port number is easily found from userspace, 
assuming you know the PCI device, with zero code.  This adds ~300 lines 
of code to do that which is already doable... :)

	Jeff



