From: Christoph Hellwig <hch@infradead.org>
Subject: Re: correct deregistration from scsi_transport_fc
Date: Mon, 29 Aug 2005 09:48:25 +0100
Message-ID: <20050829084825.GA1290@infradead.org>
References: <20050829083817.GA7013@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42149 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750779AbVH2Is0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 04:48:26 -0400
Content-Disposition: inline
In-Reply-To: <20050829083817.GA7013@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On Mon, Aug 29, 2005 at 10:38:17AM +0200, Andreas Herrmann wrote:
> Hi,
> 
> What is the correct sequence to register and deregister host/rport/scsi_devices
> at the scsi stack?
> 
> ZFCP's sequence is like follows:
> 
> scsi_add_host
> fc_remote_port_add (if port succesfully configured/opened in/by zfcp)
> scsi_add_device (if unit successfully configured/opened in/by zfcp)

Never use scsi_add_device with the fc_transport code.  fc_remote_port_add
will do a proper lun scan if the added rport is a scsi target.

> If a zfcp-adapter is set offline I do the following to get rid of the
> entries within /sys/class/fc_*:
> 
> fc_remote_port_delete (for each rport registered for this adapter)
> fc_remove_host
> scsi_remove_host

fc_remove_host removes all rports for you.

