From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: pmcraid build problem on ppc64
Date: Thu, 24 Sep 2009 14:40:37 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0909241439240.15221@rslab159.pmc-sierra.bc.ca>
References: <1253819433.5183.121.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:44084 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbZIXWi1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 18:38:27 -0400
In-Reply-To: <1253819433.5183.121.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

I guess we don't need conversions cpu_to_le32 for these ones. I will make 
this change and send an update patch.

With regards,
  Anil

On Thu, 24 Sep 2009, James Bottomley wrote:

> I'm getting this in testing:
> 
> drivers/scsi/pmcraid.c: In function 'pmcraid_request_sense':
> drivers/scsi/pmcraid.c:2254: warning: large integer implicitly truncated
> to unsigned type
> drivers/scsi/pmcraid.c: In function 'pmcraid_build_ioadl':
> drivers/scsi/pmcraid.c:3020: warning: large integer implicitly truncated
> to unsigned type
> drivers/scsi/pmcraid.c: In function 'pmcraid_build_passthrough_ioadls':
> drivers/scsi/pmcraid.c:3390: warning: large integer implicitly truncated
> to unsigned type
> drivers/scsi/pmcraid.c: In function 'pmcraid_querycfg':
> drivers/scsi/pmcraid.c:5317: warning: large integer implicitly truncated
> to unsigned type
> 
> It's code like this:
> 
> 	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
> 
> But ->flags is only u8, so that cpu_to_le32() will cause the flag to be
> too big to fit on a BE architecture.
> 
> James
> 
> 
> 
