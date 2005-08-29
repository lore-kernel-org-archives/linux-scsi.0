From: Christoph Hellwig <hch@infradead.org>
Subject: Re: correct deregistration from scsi_transport_fc
Date: Mon, 29 Aug 2005 12:03:20 +0100
Message-ID: <20050829110320.GA1343@infradead.org>
References: <OF2D6CD10B.4BD0B2F3-ONC125706C.0036B5BA-C125706C.0036F30A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61891 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750886AbVH2LDW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 07:03:22 -0400
Content-Disposition: inline
In-Reply-To: <OF2D6CD10B.4BD0B2F3-ONC125706C.0036B5BA-C125706C.0036F30A@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On Mon, Aug 29, 2005 at 12:02:15PM +0200, Andreas Herrmann wrote:
> On 29.08.2005 10:48 Christoph Hellwig <hch@infradead.org> worte:
> 
>   > Never use scsi_add_device with the fc_transport code. 
> fc_remote_port_add
>   > will do a proper lun scan if the added rport is a scsi target.
> 
> Won't work for all zSeries FC host adapters because they are
> virtualized and you can have several virtual adapters using the same
> WWPN/WWNN.  Using LUN masking and zoning it is not possible to
> configure the SAN such that one virtual adapter sees just that LUNs
> that are supposed to be used by it. There is a tool to write an access
> control table to the adapter. This ACT specifies which virtual adapter
> can access which ports and FCP LUNs ... 

That's totally broken.  most FC sans have zoning and access control, but this
is by no way a feature of the HBA.  Your feature is totally broken, different
from other FC setups and must go away.

> A REPORT LUNs scan from adapter X of port Y might report thousands of
> LUNs that I don't like to use with adapter X because they are for
> another virtual adapter.

So what?  That's the same as for every FC SAN, and it is nessecary to
support proper managment applications.

> Thats the reason why I like to stick to
> manual configuration (triggered from zfcp) of scsi_devices. Hence zfcp
> has not enabled a proper lun scan when fc_remote_port_add is
> called. slave_alloc will fail for scsi_devices not added by zfcp
> itself.  (BTW, new FC cards that are already announced will provide a
> feature called NPort Id Virtualization. With this feature each virtual
> adapter will have its own WWPN. This will allow zfcp to use the lun
> scan during fc_remote_port_add.)
> 
> Do you mean, that scsi_add_device is not supposed to work with 
> fc_transport
> code anymore?

It works by accident, but I will veto any updates you're going to send
for this broken behaviour.

>   > fc_remove_host removes all rports for you.
> 
> Ok, works. But it still fails to remove the scsi target representation
> of that rport.

That's intentional.  See the discussion during development of the FC
transport class.  I don't like that behaviour but it's a compromise
we agreed on.

