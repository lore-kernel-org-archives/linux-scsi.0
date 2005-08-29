From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: correct deregistration from scsi_transport_fc
Date: Mon, 29 Aug 2005 14:05:10 +0200
Message-ID: <OFB636307F.9CDED06C-ONC125706C.003F7876-C125706C.00432C13@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:27627 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750815AbVH2MFO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 08:05:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Andreas Herrmann <AHERRMAN@de.ibm.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

> > There is a tool to write an access control table to
> > the adapter. This ACT specifies which virtual adapter
> > can access which ports and FCP LUNs ...
>
> That's totally broken.  most FC sans have zoning and access control,
> but this is by no way a feature of the HBA.  Your feature is totally
> broken, different from other FC setups and must go away.

We know. We fixed it with the latest machine generation and corresponding
HBA
(IBM System z9). The solution is N_Port Identifier Virtualization (NPIV,
see recent FC standard documents), i.e. a SAN identity for each virtual
HBA.

However, there will be older machines with older HBA's around for some
time. We will have to cater for those as well.

> > A REPORT LUNs scan from adapter X of port Y might report
> > thousands of LUNs that I don't like to use with adapter X
> > because they are for another virtual adapter.
>
> So what?  That's the same as for every FC SAN, and it is
> nessecary to support proper managment applications.

Correct. But there is another problem inherent in this setup.
Without NPIV, we can't share access to the same LUN, e.g. LUN 0,
through virtual HBAs hosted by the same physical HBA, in order to
avoid several issues as to SCSI compliance (sense data delivery,
reserve/release, abort task set, mode pages changes, etc.).
That is why, we require manual setup of LUNs to be accessed
through sysfs, so far.

It is desirable to go with REPORT LUNs for NPIV-capable
virtual HBAs, while keeping some compatability code in
zfcp for non-NPIV virtal HBAs.

Martin Peschke



|---------+-------------------------------->
|         |           Christoph Hellwig    |
|         |           <hch@infradead.org>  |
|         |           Sent by:             |
|         |           linux-scsi-owner@vger|
|         |           .kernel.org          |
|         |                                |
|         |                                |
|         |           29/08/2005 13:03     |
|         |                                |
|---------+-------------------------------->
  >---------------------------------------------------------------------------------------------------------------|
  |                                                                                                               |
  |       To:       Andreas Herrmann/Germany/IBM@IBMDE                                                            |
  |       cc:       Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI        |
  |        <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org                                         |
  |       Subject:  Re: correct deregistration from scsi_transport_fc                                             |
  |                                                                                                               |
  >---------------------------------------------------------------------------------------------------------------|




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

That's totally broken.  most FC sans have zoning and access control, but
this
is by no way a feature of the HBA.  Your feature is totally broken,
different
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

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



