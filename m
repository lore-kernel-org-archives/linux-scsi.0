From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Sat, 28 Oct 2006 11:33:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610281125320.2757-100000@netrider.rowland.org>
References: <20061027214343.GA1701@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.rowland.org ([192.131.102.7]:57863 "HELO mx2.rowland.org")
	by vger.kernel.org with SMTP id S1750907AbWJ1PdI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Oct 2006 11:33:08 -0400
In-Reply-To: <20061027214343.GA1701@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 27 Oct 2006, Patrick Mansfield wrote:

> On Thu, Oct 26, 2006 at 05:11:27PM -0400, Alan Stern wrote:
> > This patch (as810) sets the length of the INQUIRY data to a minimum of
> > 36 bytes, even if the device claims that not all of them are valid.
> > Using the data sent by the device is better than allocating a short
> > buffer and then reading beyond the end of it, which is what we do now.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > ---
> > 
> > Index: usb-2.6/drivers/scsi/scsi_scan.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> > +++ usb-2.6/drivers/scsi/scsi_scan.c
> > @@ -575,6 +575,19 @@ static int scsi_probe_lun(struct scsi_de
> >  	 * short INQUIRY), an abort here prevents any further use of the
> >  	 * device, including spin up.
> >  	 *
> > +	 * On the whole, the best approach seems to be to assume the first
> > +	 * 36 bytes are valid no matter what the device says.  That's
> 
> The comment is confusing, as it implies the device will modify data past
> the indicated length, but well behaved devices should not do that, and
> with your patch should point to zero filled data.
> 
> Just comment on what its avoiding or such like:
> 
> 	Modify short inquiry_len values so we don't later point at random
> 	values. Devices returning an incorrect value in the INQUIRY
> 	additional length field will point at potentially valid data for
> 	Vendor, Product and Revsion, while conforming devices will point
> 	to zero filled data.
> 
> But definitely better to use possibly valid data for broken devices or
> NUL for well behaved devices rather than garbage values.

In the context of the comment already there in the code, your suggested 
text would be somewhat jarring.  I'll try to re-write it in a way that 
should satisfy everybody.

BTW, isn't it conceivable that well-behaved devices could send 36 bytes,
with only the first 8 bytes marked valid and non-NULL garbage in the last
28?  The spec isn't very clear about this; it says only that the standard
INQUIRY data contains 36 required bytes.

Alan Stern

