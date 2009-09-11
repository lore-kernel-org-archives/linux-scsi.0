From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Fri, 11 Sep 2009 08:15:42 -0400
Message-ID: <4AAA3F6E.5030405@emulex.com>
References: <20090910175417.3c24eb4b@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44380 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZIKMQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 08:16:03 -0400
In-Reply-To: <20090910175417.3c24eb4b@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>



Jayamohan Kalickal wrote:
> Ok. Reading Mike's comment once again and looking at the lpfc code ,I think, maybe, this is what Mike had in mind, but I could have misunderstood.
> 
> During session create, I will create the pool as well as alloc. This will take 
> care of the allocation at page level and scarce coherent resources problems 
> mentioned by JamesB. Also, this would not have any impact on performance. I see this
> done for "lpfc_mbuf_pool" in lpfc/lpfc_mem.c.
> 
> Thanks
> Jay

As most things - it depends on what's being allocated.  I recommended against 
a pci pool when I was looking at the allocations for queue memory, SGLs, etc 
as that is largely static (allocate/assign once, rarely dealloc/deassign) and 
very much likes to be 4k pages, page aligned, and as contiguous as possible.

However, the DMA buffers for the Command and Response buffers is a different 
story. They are in the fast path, re-alloc per command, are smaller than a 
page, etc and fit the pci pool profile very well.

-- james s

