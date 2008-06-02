From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 2 Jun 2008 20:53:29 +0100
Message-ID: <20080602205329.3b824d0b@core>
References: <12124164141515-patch-mail.ibm.com>
	<48441AEE.6050605@garzik.org>
	<48441F82.6060706@linux.vnet.ibm.com>
	<1212425124.3369.20.camel@localhost.localdomain>
	<4844312C.7010403@garzik.org>
	<1212429428.3369.45.camel@localhost.localdomain>
	<484437C3.8020306@garzik.org>
	<1212435308.3369.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35706 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbYFBUR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 16:17:56 -0400
In-Reply-To: <1212435308.3369.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com, Tejun Heo <htejun@gmail.com>

> I think it's possible to do the shift while still making it look to
> single port hosts that nothing has changed

There are very few of those. Your generic PC controller is single host,
dual channel two devices per channel.

> Well, we can be elastic on this.  The common case is a two port
> master/slave, isn't it.  This particular one could just be treated as
> two separate interfaces and hence two hosts (it's reasonably analagous
> to the 53c896---which is a single chip that presents two SCSI channels
> as two PCI functions).

Not as trivial as you might hope. In some cases the two are closely
linked, they often share timing rules. In other cases they have shared or
single assignable DMA fifos.

In practical terms that means you must reconfigure *both* channels when
you do an EH.

Alan
