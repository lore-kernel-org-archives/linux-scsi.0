From: "goggin, edward" <egoggin@emc.com>
Subject: RE: [RFC PATCH 4/4] convert scsi to blkerr error values
Date: Sat, 17 Sep 2005 08:10:43 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ACB9@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:15987 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP
	id S1751086AbVIQMK6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 08:10:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, "goggin, edward" <egoggin@emc.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com

> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
> Sent: Friday, September 16, 2005 4:26 PM
> To: goggin, edward
> Cc: axboe@suse.de; linux-scsi@vger.kernel.org; dm-devel@redhat.com
> Subject: Re: [RFC PATCH 4/4] convert scsi to blkerr error values
> 
> goggin, edward wrote:
> > Mike,
> > 
> > I don't think it is reasonably possible to anticipate
> > all possible parsing requirements for the asc and ascq
> > portions of SCSI sense information across all device
> > models.  I'm in favor of having a "small" framework in
> > SCSI where a SCSI sense interpreter module (per
> > vendor & model possibly) could be registered
> > dynamically, by dm-emc.c for instance.
> 
> Yeah I agree, I mentioned this before in some other mails. I think a 
> module versus some table that userspace could write to were discussed.

Yes, I first heard about this idea from you on one of the multipathing
conference calls.  I wasn't sure if you were still advocating for this
approach though :))

> 
> The BLKERR values were meant to be able to tell upper layer 
> code whether 
> a transport or device or driver error occured and whether the lower 
> level thought it was retryable. But then I thought I could 
> also wedge in 
> the handling of the vendor specifcs by adding a vendor specific SCSI 
> module that would map the their specific value to a BLKERR_* 
> one. And as 
> I said offlist it is not working perfectly becuase we are losing some 
> information in the translations.
> 
> > 
> > The extended error interpreter callout would be
> > triggered indirectly by a call from
> > __end_that_request_first to a extended error parser
> > associated with the io request's queue whenever it
> > sees a non-zero sense field of the io request.
> > Perhaps the sense and sense_len fields in the
> > request structure should be changed to not be
> > SCSI specific.
> 
> So this just handles the sense type of error right? We still need 
> something seperate for the transport and device etc errors correct?

Yeah, I forgot about those.

> 
> > 
> > Also, in order to allow for more variation and detail
> > in the interpretation of device specific SCSI asc and
> > ascq values, the results of the interpretation should
> > not be required to be block layer generic, but instead
> > are saved in something like a void *bi_extended_error
> > field of the bio.  __end_that_request_first would push
> > the results of the extended_error interpretation to the
> > bi_extended_error field of each bio in the request,
> > similar to how Jens's code currently works.
> > 
> > This extended error parsing approach should extend easily
> > (without requiring a kernel revision for new BLKERR values)
> > to new SCSI devices/models and their device specific asc
> > and ascq values.  This design could also be extended to
> > support the interpretation of extended error information
> > for non-SCSI block devices like DASD.
> > 
> 
> I am fine with such a thing. You basically described what we 
> have been 
> talking about for some time but sperated the BLKERR part from 
> the vendor 
> specific part (which solves the problem I was having in trying to use 
> the BLKERR value for two things). I am not the decision maker 
> though so.
> 
