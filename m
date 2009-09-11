From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Fri, 11 Sep 2009 15:54:08 -0700
Message-ID: <20090911225408.3c550c7b@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:23148 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZIKW4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 18:56:33 -0400
In-Reply-To: 4AAA3F6E.5030405@emulex.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, sfr@canb.auug.org.au

Thanks for your comments. It looks like we are in agreement.

I have implemented with pci_pool (using the approach of "lpfc_mbuf_pool"
 in lpfc/lpfc_mem.c).
That should take care of the two issues raised earlier. I will send 
the patch shortly


Thanks
Jay

  _____  
From: James Smart [mailto:James.Smart@Emulex.Com]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: James Bottomley [mailto:James.Bottomley@suse.de], Mike Christie [mailto:michaelc@cs.wisc.edu], linux-scsi@vger.kernel.org [mailto:linux-scsi@vger.kernel.org], sfr@canb.auug.org.au [mailto:sfr@canb.auug.org.au]
Sent: Fri, 11 Sep 2009 05:15:42 -0700
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile



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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

