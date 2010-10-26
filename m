From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [dm-devel] [RESUBMIT][Patch] scsi_dh_rdac: retry IO for
 06/3f/03 in rdac_check_sense fn
Date: Tue, 26 Oct 2010 14:58:59 -0500
Message-ID: <1288123139.8283.509.camel@mulgrave.site>
References: <B2FD678A64EAAD45B089B123FDFC3ED704BFE578@inbmail01.lsi.com>
	 <4CC7299E.2030508@cs.wisc.edu> <1288120911.8283.441.camel@mulgrave.site>
	 <DBFB1B45AF80394ABD1C807E9F28D1570262E39FAA@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760338Ab0JZT7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 15:59:05 -0400
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D1570262E39FAA@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, Vijay.Chauhan@lsi.com, jejb@kernel.org, linux-scsi@vger.kernel.org

On Wed, 2010-10-27 at 01:02 +0530, Shyam_Iyer@Dell.com wrote:
> -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James
> > Bottomley
> > Sent: Tuesday, October 26, 2010 3:22 PM
> > To: Mike Christie
> > Cc: device-mapper development; Chauhan, Vijay; James Bottomley; linux-scsi@vger.kernel.org
> > Subject: Re: [dm-devel] [RESUBMIT][Patch] scsi_dh_rdac: retry IO for 06/3f/03 in rdac_check_sense fn
> > 
> > On Tue, 2010-10-26 at 14:18 -0500, Mike Christie wrote:
> > > On 10/26/2010 08:53 AM, Chauhan, Vijay wrote:
> > > > Resubmitting this patch to get the attention.
> > > >
> > > > This patch adds retry for the IO returned with 06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in
> > rdac_check_sense(). IO returned with 06/3f/03 from controller are currently failed by scsi mid layer,
> > as a reason momentarily path failure is noticed by DM multipath.
> > > >
> > >
> > > Is it getting failed by accident? In scsi_io_completion we check for UAs
> > > and will retry if the removable bit is not set. That check is after
> > > scsi_end_request though (is the scsi_end_request call failing the IO).
> > >
> > > Did you guys also want REPORTED_LUNS_DATA_HAS_CHANGED to be retried too.
> > > I think scsi_dh_alua's REPORTED_LUNS_DATA_HAS_CHANGED maybe should be
> > > genericly retried, because it seems for both errors we will want to
> > > retry for all devices.
> > 
> > So my primary worry about patches like this is that it eats AENs ...
> > this is fine because, as Mike says, we should just ignore them.
> > 
> > However, the moment we start processing AENs (as another set of dm
> > people promise they have in process) we'll lose them from rdac arrays
> > and people will get unhappy.
> > 
> > If the generic UA retry isn't working, let's fix it there rather than
> > these hacks that would be hard to spot and pull out when (if) we ever
> > get a generic AEN infrastructure.
> > 
> > James
> 
> Sometimes the default way to handle a UA may be not the correct one.
> One arrays implementation to respond to the UA could be different from
> another array.

I don't quite understand this observation in the context of this patch.
What the patch does is retry the command (i.e. ignore the UA) which
should pretty much be our default response.

> Example: A thin provisioning threshold exceed check condition. The
> device handler infrastructure can be a savior with such hacks.. 

I'm going to regret asking this (especially given all the noise there's
been on thin provisioning thresholds):  Which arrays don't actually
issue them correctly?

James


