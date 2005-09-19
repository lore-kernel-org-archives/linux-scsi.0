From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [PATCH 6/6] zfcp: provide support for NPIV
Date: Mon, 19 Sep 2005 16:53:13 +0200
Message-ID: <OFD2F66C80.E6AB000B-ONC1257081.00515783-C1257081.005185B0@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52127 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S932429AbVISOxQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 10:53:16 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j8JErFO0155266
	for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2005 14:53:15 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8JErFlo176496
	for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2005 16:53:15 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j8JErF5a027475
	for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2005 16:53:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

On 15.09.2005 14:26 Christoph Hellwig <hch@infradead.org> wrote:

> I have a hard time understanding much of the driver and thus this
> patch aswell, but it looks like you're adding the luns using 
scsi_add_device
> instead of using the proper midlayer lun scan.

Yes, you are right. The patch just adds kind of basic support for
NPIV, e.g. handling error situations, giving information for problem
determination.

Next step is to allow lun scanning for ports operating in NPIV mode.
I am working on that ...

However for ports not operating in NPIV mode zfcp relies on
scsi_add_device ;-(


> > @@ -68,6 +68,8 @@ ZFCP_DEFINE_ADAPTER_ATTR(s_id, "0x%06x\n
> >  ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", 
adapter->peer_wwnn);
> >  ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", 
adapter->peer_wwpn);
> >  ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
> > +ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, "0x%016llx\n", 
adapter->physical_wwpn);

> this information belongs into the transport class, not the driver.
> What's the peer information above?  is that for point-to-point FC
> connections?

Hope it is acceptable to keep this attributes in zfcp sysfs subtree
until I will send a patch to add physical port_name and physical
port_id information to the transport class. 

Both attributes just make sense for ports operating in NPIV-mode and
are helpful for problem determination.

Yes, the peer information is for point-to-point connections. I plan to
remove these attributes and to automatically configure the P2P-port in
zfcp. But that is currently not the most important thing to do.


> >  ZFCP_DEFINE_ADAPTER_ATTR(fc_link_speed, "%d Gb/s\n", 
adapter->fc_link_speed);

> dito this one belongs only in the transport class.

I am just about to send a patch to move this and some other zfcp
adapter attributes to the corresponding fc_host.


Regards,

Andreas
