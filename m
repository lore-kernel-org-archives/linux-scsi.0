From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi/mptsas: add RAID devices in ascending ID order
Date: Mon, 25 Sep 2006 10:14:23 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032D7EB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46756 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751095AbWIYQO0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 12:14:26 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: linux-scsi@vger.kernel.org, mpt_linux_developer <mpt_linux_developer@lsil.com>

On Monday, September 25, 2006 3:59 AM, Martin Wilck wrote: 
> > Ascending ID ordering does not address all cases. 
> > There is no guarantee which target ids are 
> > assigned by firmware to volumes when
> > volumes are created.  
> 
> That's what my patch was supposed to handle: No matter what 
> the ordering 
> of IDs by firmware is, the devices are registered in 
> ascending ID order.

You patch will call scsi_add_device, from low to hi target 
ids, right?  Well if someone creates a volume that
is issued target id=8, installs the operating system.
Then tommorrow they create a new volume that is issued
target id=7, then what your patch will do is reverse
the order, right?  If so, a panic would occur
unless they assigned device names/lables.

> 
> > I've made similar 
> > ordering proposals before to this mailing list. 
> > All been rejected.
> 
> Do you have a thread reference for me? I'd like to understand the 
> arguments better. I find this strange because scanning in ascending 
> order has always been the common case in drivers as well as 
> in the mid 
> layer, AFAIK.

I was working with Christoph Hellwig and James Bottomley last
year implementing raid support in mptsas, and they rejected it
code that ordered raid ids.

BTW, the scsi mid layer is not scanning devices that use
transport layers, beside spi.  Meaning that lld's that are
fibre channel, iscsi, and sas hba will report the know devices
to transports, and the transport assign its own unique mapping.
For example, mptsas and mptfc are using transport, and we
don't call scsi_scan_host.  

 
