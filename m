From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Thu, 10 Sep 2009 17:15:40 +0000
Message-ID: <1252602940.11956.108.camel@mulgrave.site>
References: <20090909191520.fb9e5110@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZIJRPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2009 13:15:45 -0400
In-Reply-To: <20090909191520.fb9e5110@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, sfr@canb.auug.org.au

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


