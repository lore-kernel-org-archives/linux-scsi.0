From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Sat, 28 Oct 2006 11:30:21 -0700
Message-ID: <20061028183021.GA26419@us.ibm.com>
References: <20061027214343.GA1701@us.ibm.com> <Pine.LNX.4.44L0.0610281125320.2757-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35002 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751337AbWJ1Saa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Oct 2006 14:30:30 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9SIUJNU027310
	for <linux-scsi@vger.kernel.org>; Sat, 28 Oct 2006 14:30:19 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9SIUJaB147416
	for <linux-scsi@vger.kernel.org>; Sat, 28 Oct 2006 14:30:19 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9SIUJje025041
	for <linux-scsi@vger.kernel.org>; Sat, 28 Oct 2006 14:30:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0610281125320.2757-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Douglas Gilbert <dougg@torque.net>

On Sat, Oct 28, 2006 at 11:33:06AM -0400, Alan Stern wrote:
> On Fri, 27 Oct 2006, Patrick Mansfield wrote:
> 
> > On Thu, Oct 26, 2006 at 05:11:27PM -0400, Alan Stern wrote:
> > > This patch (as810) sets the length of the INQUIRY data to a minimum of
> > > 36 bytes, even if the device claims that not all of them are valid.
> > > Using the data sent by the device is better than allocating a short
> > > buffer and then reading beyond the end of it, which is what we do now.
> > > 
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > > 
> > > ---
> > > 
> > > Index: usb-2.6/drivers/scsi/scsi_scan.c
> > > ===================================================================
> > > --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> > > +++ usb-2.6/drivers/scsi/scsi_scan.c
> > > @@ -575,6 +575,19 @@ static int scsi_probe_lun(struct scsi_de
> > >  	 * short INQUIRY), an abort here prevents any further use of the
> > >  	 * device, including spin up.
> > >  	 *
> > > +	 * On the whole, the best approach seems to be to assume the first
> > > +	 * 36 bytes are valid no matter what the device says.  That's
> > 
> > The comment is confusing, as it implies the device will modify data past
> > the indicated length, but well behaved devices should not do that, and
> > with your patch should point to zero filled data.
> > 
> > Just comment on what its avoiding or such like:
> > 
> > 	Modify short inquiry_len values so we don't later point at random
> > 	values. Devices returning an incorrect value in the INQUIRY
> > 	additional length field will point at potentially valid data for
> > 	Vendor, Product and Revsion, while conforming devices will point
> > 	to zero filled data.
> > 
> > But definitely better to use possibly valid data for broken devices or
> > NUL for well behaved devices rather than garbage values.
> 
> In the context of the comment already there in the code, your suggested 
> text would be somewhat jarring.  I'll try to re-write it in a way that 
> should satisfy everybody.

OK, though not sure what you mean, we could still point at garbage data
and lookup in the devinfo list based on that garbage. And the issue with
INQUIRY potentially changing after the device is spun up still exists.

[There were even disk drives available in the past that modified the
vendor and product id after spin up, this would be confusing but not a big
problem as long as they are not needed in black/white lists, you could
still issue an INQUIRY from user space and see current values.]

> BTW, isn't it conceivable that well-behaved devices could send 36 bytes,
> with only the first 8 bytes marked valid and non-NULL garbage in the last
> 28?  The spec isn't very clear about this; it says only that the standard
> INQUIRY data contains 36 required bytes.

So the additional length would be 3, but 36 bytes are transferred
including some garbage ...

I don't know and could not find anything in the specs. Maybe Doug or
others can answer. AFAICT if the device doesn't have the data available it
should return space filled values.

I thought there was some mention in some SCSI spec of an INQUIRY of less
than 36 bytes and then mention of the handling of it, but can't find
anything (searched in SPC spc3r32.pdf, SPC 2 spc2r20.pdf, SAM sam4r04.pdf
and even MMC mmc5r01b.pdf). So I'm wrong to say conforming devices would
point to zero filled data if the INQUIRY should return at least 36 bytes.

-- Patrick Mansfield
