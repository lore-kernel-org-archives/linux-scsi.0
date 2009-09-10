From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Thu, 10 Sep 2009 10:54:17 -0700
Message-ID: <20090910175417.3c24eb4b@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:44880 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZIJR4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2009 13:56:40 -0400
In-Reply-To: 1252602940.11956.108.camel@mulgrave.site
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, sfr@canb.auug.org.au

Ok. Reading Mike's comment once again and looking at the lpfc code ,I think, maybe, this is what Mike had in mind, but I could have misunderstood.

During session create, I will create the pool as well as alloc. This will take 
care of the allocation at page level and scarce coherent resources problems 
mentioned by JamesB. Also, this would not have any impact on performance. I see this
done for "lpfc_mbuf_pool" in lpfc/lpfc_mem.c.

Thanks
Jay






  _____  
From: James Bottomley [mailto:James.Bottomley@suse.de]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: Mike Christie [mailto:michaelc@cs.wisc.edu], linux-scsi@vger.kernel.org, sfr@canb.auug.org.au
Sent: Thu, 10 Sep 2009 10:15:40 -0700
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile

On Wed, 2009-09-09 at 12:15 -0700, Jayamohan Kalickal wrote:
> Implementing pci_pool is not a problem. But, my experience with this chip
> (or for that matter any chip that can do huge IOPS ,say, more then 600 -700 KIOPS),
>  every line of code on the hot path would have an impact and hence I strive to
> move it out of the hot path.
> 
> The code is not yet optimized for speed yet but I definitely want to push whatever
>  I can to init time from  the IO path.

I'll fold in the patch as is because we urgently need a fix for the
virt_to_bus() problem.

pci_pool was designed to allow for good IOP throughput (that's why lpfc
is using it).  The pci_alloc_consistent() you've chosen often only
allocates at the page level, so it can be hugely wasteful of resources;
plus coherent memory is a precious resource on some platforms, so I can
see you running out on them.  Could you at least try a pci_pool
implementation ... if it really turns out to be a performance problem we
can keep the current implementation despite the potential resource
issues.

Thanks,

James


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

