From: "Mukker, Atul" <atulm@lsil.com>
Subject: RE: unique entry points for all driver hosts
Date: Tue, 13 May 2003 09:43:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570185F196@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56827 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261212AbTEMNbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 09:31:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Anderson' <andmike@us.ibm.com>, 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> > Why doesn't mid-layer allow LLDs to specify separate entry 
> > points to various
> > hosts attached to the same driver. Like some other entries 
> > in the Scsi Host
> > Template, entry points should also  allowed to be overridden.
> 
> Is there a issue you are hitting of common host template functions and
> selecting unique host instance functions using hostdata?

No, We simply want to have unique hot-path entry point (queuecommand) and
error handling hooks for each class of supported hosts. This is required
because these classes of controllers have disparate queue and error handling
mechanisms.

The work around we have today is to have common queue routine for example.
This queue routine then routes the scsi packet to appropriate host's
queuecommand hook using hostdata information.

looks like it is limiting to have a 'driver' specific structure(SHT) instead
of a self sufficient host-centric view (struct Scsi_Host).

IMHO, declaring multiple SHTs as suggested by Christoph Hellwig may not be a
good idea since it might appear like a hack, would lose the "template"
ideology and is not object-oriented :-)

Host structure would be best place to have pointers to these hooks as well.

-Atul Mukker


> -----Original Message-----
> From: Mike Anderson [mailto:andmike@us.ibm.com]
> Sent: Monday, May 12, 2003 7:38 PM
> To: Mukker, Atul
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: unique entry points for all driver hosts
> 
> 
> Mukker, Atul [atulm@lsil.com] wrote:
> > Why doesn't mid-layer allow LLDs to specify separate entry 
> points to various
> > hosts attached to the same driver. Like some other entries 
> in the Scsi Host
> > Template, entry points should also  allowed to be overridden.
> > 
> > 
> > Thanks
> 
> Is there a issue you are hitting of common host template functions and
> selecting unique host instance functions using hostdata?
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
