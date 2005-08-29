From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: correct deregistration from scsi_transport_fc
Date: Mon, 29 Aug 2005 12:02:15 +0200
Message-ID: <OF2D6CD10B.4BD0B2F3-ONC125706C.0036B5BA-C125706C.0036F30A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:16850 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750737AbVH2KCS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 06:02:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On 29.08.2005 10:48 Christoph Hellwig <hch@infradead.org> worte:

  > Never use scsi_add_device with the fc_transport code. 
fc_remote_port_add
  > will do a proper lun scan if the added rport is a scsi target.

Won't work for all zSeries FC host adapters because they are
virtualized and you can have several virtual adapters using the same
WWPN/WWNN.  Using LUN masking and zoning it is not possible to
configure the SAN such that one virtual adapter sees just that LUNs
that are supposed to be used by it. There is a tool to write an access
control table to the adapter. This ACT specifies which virtual adapter
can access which ports and FCP LUNs ... 

A REPORT LUNs scan from adapter X of port Y might report thousands of
LUNs that I don't like to use with adapter X because they are for
another virtual adapter. Thats the reason why I like to stick to
manual configuration (triggered from zfcp) of scsi_devices. Hence zfcp
has not enabled a proper lun scan when fc_remote_port_add is
called. slave_alloc will fail for scsi_devices not added by zfcp
itself.  (BTW, new FC cards that are already announced will provide a
feature called NPort Id Virtualization. With this feature each virtual
adapter will have its own WWPN. This will allow zfcp to use the lun
scan during fc_remote_port_add.)

Do you mean, that scsi_add_device is not supposed to work with 
fc_transport
code anymore?

Or is it mere a recommendation not to stick to scsi_add_device but to use
the automatic LUN scanning provided with fc_transport code?


  > fc_remove_host removes all rports for you.

Ok, works. But it still fails to remove the scsi target representation
of that rport.


Regards,

Andreas
