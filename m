From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 11:32:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101119460.3208-100000@iolanthe.rowland.org>
References: <20090810145810.GA31442@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48822 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755421AbZHJPcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 11:32:01 -0400
In-Reply-To: <20090810145810.GA31442@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Aug 2009, Matthew Wilcox wrote:

> On Mon, Aug 10, 2009 at 10:41:42AM -0400, Alan Stern wrote:
> > Martin and Matthew:
> > 
> > Since you guys added scsi_vpd_inquiry() and scsi_get_vpd_page() plus
> > sd_read_block_limits() and sd_read_block_characteristics(), I'm
> > directing these questions to you.
> > 
> > Is there some reason for not accounting for the 4 header bytes in the 
> > allocation length value stored in the CDB?  Or is this simply a bug?
> 
> Um, we do.
> 
> unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
>         unsigned char *buf = kmalloc(259, GFP_KERNEL);
>         result = scsi_vpd_inquiry(sdev, buf, 0, 255);
>         for (i = 0; i < buf[3]; i++)
>                 if (buf[i + 4] == page)
>                         goto found;
>         buf = kmalloc(len + 4, GFP_KERNEL);
>         result = scsi_vpd_inquiry(sdev, buf, page, len);

I'm not referring to this routine; I'm talking about the code in 
scsi_vpd_inquiry() where the CDB is set.

> Now ... we do seem to be passing the len instead of len + 4 to the
> device as the buffer size,

Yes, that's what I mean.

> so there does appear to be a minor bug here,
> but it's not as horrific as you make it out to be.

I didn't make it out to be horrific; I said that it's "simply a bug".  
And you just agreed with me.  (Well, you called it a "minor" bug; I'll 
go along with that.)


> > Were you aware that SCSI-2 defines the allocation length to be a single 
> > byte?  cmd[3] is specified as "Reserved" in the spec.  Hence the value 
> > of "len" should be capped at 255 if sdev->scsi_level <= SCSI_2, right?
> 
> and 'Reserved' in SCSI-2 means:
> 
> "A reserved bit, field, or byte shall be set to zero, or in accordance
> with a future extension to this standard." (7.1.1)

Sure.  But what reason could there possibly be for making a field
non-zero when you know that the device won't be able to interpret the
value correctly?  The fact that sdev->scsi_level == SCSI_2 means
the device follows _this_ version of the standard, not a future 
extension.  Or am I missing something?


> > Have you considered that plenty of low-budget USB mass-storage devices
> > don't implement VPD properly?  I've got a flash drive right here which
> 
> I've noticed you whining about it, yes.

Have I mentioned it before?  I don't recall doing so...  Maybe my 
memory is going.

(And there's no reason to be rude.  I'm trying to hold a civil
discussion.)

> > totally ignores the "page" byte in the INQUIRY command; it always
> > responds with the normal INQUIRY data.  Thus expecting the response
> 
> I don't think you mean the 'page' byte.  I think you mean the 'EVPD'
> bit.

That's right.  Sorry about the mental slip-up.

> > data always to be accurate may not be a good idea.  I'm considering
> > adding a "restrict_to_MS_usb" flag to the host template, to indicate
> > that commands shouldn't be sent unless some version of Windows uses
> > them when talking to USB devices -- do you think that could work?
> 
> Not really my area of expertise.

Okay.  Maybe Martin has some thoughts on it.

You didn't comment on the proposed patch.  Any objections to it?

Alan Stern

