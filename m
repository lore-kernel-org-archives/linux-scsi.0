From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: updates for -bk
Date: Mon, 24 Jan 2005 15:48:54 +0100
Message-ID: <OF78A719F0.8702D449-ONC1256F93.004FD89C-C1256F93.00516DAD@de.ibm.com>
References: <20050124142245.GJ31455@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:48119 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261322AbVAXOs6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2005 09:48:58 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0OEmvbP122920
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 14:48:57 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0OEmuCB132784
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 15:48:56 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0OEmuX8027223
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 15:48:56 +0100
In-Reply-To: <20050124142245.GJ31455@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, willy@www.linux.org.uk

> >  void
> > -zfcp_dummy_release(struct device *dev)
> > +zfcp_generic_services_release(struct device *dev)
> >  {
> > -   return;
> > +   kfree(dev);
> >  }
> > 
> >  /*
> 
> I thought that having release methods that just called kfree() were
> also verboten?

We do a kmalloc(sizeof(struce device),...) somewhere and this 
is how we get rid of it again.
How are we supposed to free this object otherwise? The release
function gets called when there is no more reference to this
object and that's the earliest point we may free it.

Thanks,
Heiko

