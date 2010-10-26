From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [dm-devel] [RESUBMIT][Patch] scsi_dh_rdac: retry IO for
 06/3f/03 in rdac_check_sense fn
Date: Tue, 26 Oct 2010 14:21:51 -0500
Message-ID: <1288120911.8283.441.camel@mulgrave.site>
References: <B2FD678A64EAAD45B089B123FDFC3ED704BFE578@inbmail01.lsi.com>
	 <4CC7299E.2030508@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42795 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933486Ab0JZTV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 15:21:57 -0400
In-Reply-To: <4CC7299E.2030508@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, James Bottomley <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2010-10-26 at 14:18 -0500, Mike Christie wrote:
> On 10/26/2010 08:53 AM, Chauhan, Vijay wrote:
> > Resubmitting this patch to get the attention.
> >
> > This patch adds retry for the IO returned with 06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in rdac_check_sense(). IO returned with 06/3f/03 from controller are currently failed by scsi mid layer, as a reason momentarily path failure is noticed by DM multipath.
> >
> 
> Is it getting failed by accident? In scsi_io_completion we check for UAs 
> and will retry if the removable bit is not set. That check is after 
> scsi_end_request though (is the scsi_end_request call failing the IO).
> 
> Did you guys also want REPORTED_LUNS_DATA_HAS_CHANGED to be retried too. 
> I think scsi_dh_alua's REPORTED_LUNS_DATA_HAS_CHANGED maybe should be 
> genericly retried, because it seems for both errors we will want to 
> retry for all devices.

So my primary worry about patches like this is that it eats AENs ...
this is fine because, as Mike says, we should just ignore them.

However, the moment we start processing AENs (as another set of dm
people promise they have in process) we'll lose them from rdac arrays
and people will get unhappy.

If the generic UA retry isn't working, let's fix it there rather than
these hacks that would be hard to spot and pull out when (if) we ever
get a generic AEN infrastructure.

James


