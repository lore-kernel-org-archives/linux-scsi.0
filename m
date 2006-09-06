From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: MPT Fusion Crash
Date: Wed, 6 Sep 2006 15:54:39 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D702E363A@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:21437 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932212AbWIFVym convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 17:54:42 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Justin" <justin.chen@hp.com>, linux-scsi@vger.kernel.org
Cc: "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, "Helgaas, Bjorn" <bjorn.helgaas@hp.com>

On Wednesday, September 06, 2006 3:05 PM, Chen, Justin wrote:

> 
> I got a kernel crash after offlined a scsi host when the 
> kernel boots on
> an ia64 box.  The crash is seen on the current upstream kernel
> (2.6.18-rc6) and several versions of old kernels back. 
> 
> Any idea what the problem is?
> 

yes

> bsp=e0000700835190a8
>  [<a0000001001e77e0>] swiotlb_unmap_sg+0xa0/0x1e0
>                                 sp=e00007008351fd90 
> bsp=e000070083519048
>  [<a00000010047b970>] mptscsih_search_running_cmds+0x210/0x340
>                                 sp=e00007008351fd90 

Looks like it panic'd when pci_unmap_sg() is called.   In older kernels
we had a similar panic, and we added a scsi_device_online call because
midlayer was nulling some of the pointers in the scsi_cmd after itself
offlined a device before the lld slave_destroy was called..  
This panic occured because there were still outstanding io in fusion.
Since I thought that was fix'd, it was recommended by hch and company
that we kill the scsi_device_online call.

Eric
