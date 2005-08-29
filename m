From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: correct deregistration from scsi_transport_fc
Date: Mon, 29 Aug 2005 17:27:47 +0200
Message-ID: <OFAAE017F2.A67F0DDA-ONC125706C.00546128-C125706C.0054C0AC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:40645 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750934AbVH2P1x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 11:27:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On 29.08.2005 13:03 Christoph Hellwig <hch@infradead.org> wrote:

  > > Won't work for all zSeries FC host adapters because they are
  > > virtualized and you can have several virtual adapters using the same
  > > WWPN/WWNN.  Using LUN masking and zoning it is not possible to
  > > configure the SAN such that one virtual adapter sees just that LUNs
  > > that are supposed to be used by it. There is a tool to write an 
access
  > > control table to the adapter. This ACT specifies which virtual 
adapter
  > > can access which ports and FCP LUNs ... 

  > That's totally broken.  most FC sans have zoning and access control,
  > but this is by no way a feature of the HBA.  Your feature is totally
  > broken, different from other FC setups and must go away.

Of course, also in my opinion this is not the optimal way to virtualize
adapters. But that is how the hardware works. I cannot change this.
zfcp just can exploit the hardware "as is". And therefor zfcp needs for
compatibility reasons the scsi_add_device interface. 

  > > A REPORT LUNs scan from adapter X of port Y might report thousands 
of
  > > LUNs that I don't like to use with adapter X because they are for
  > > another virtual adapter.

  > So what?  That's the same as for every FC SAN, and it is nessecary to
  > support proper managment applications.

The main point is that we do not want that all LUNs that are reported
by REPORT LUNS are configured for the virtual adapter.
I think Martin Peschke gave you further information about this.
BTW, are there any proper management applications for Linux (all
architectures, based on which interface)?

  > > Thats the reason why I like to stick to
  > > manual configuration (triggered from zfcp) of scsi_devices. Hence 
zfcp
  > > has not enabled a proper lun scan when fc_remote_port_add is
  > > called. slave_alloc will fail for scsi_devices not added by zfcp
  > > itself.  (BTW, new FC cards that are already announced will provide 
a
  > > feature called NPort Id Virtualization. With this feature each 
virtual
  > > adapter will have its own WWPN. This will allow zfcp to use the lun
  > > scan during fc_remote_port_add.)
  > > 
  > > Do you mean, that scsi_add_device is not supposed to work with 
  > > fc_transport
  > > code anymore?

  > It works by accident, but I will veto any updates you're going to send
  > for this broken behaviour.

So scsi_add_device will soon be mentioned in
Documentation/feature-removal-schedule.txt?

What is the rationale of proscribing usage of scsi_add_device() when
scsi_transport_fc is used?

  > >   > fc_remove_host removes all rports for you.
  > > 
  > > Ok, works. But it still fails to remove the scsi target 
representation
  > > of that rport.

  > That's intentional.  See the discussion during development of the FC
  > transport class.  I don't like that behaviour but it's a compromise we
  > agreed on.

Where is the function to remove the scsi target representation of
an rport? You did not agree on having memory leaks in the kernel, did
you?


Regards,

Andreas
