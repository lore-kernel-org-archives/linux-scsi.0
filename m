From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 10:04:35 -0600
Message-ID: <20090811160434.GD31442@parisc-linux.org>
References: <20090810145810.GA31442@parisc-linux.org> <Pine.LNX.4.44L0.0908101119460.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38823 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZHKQEe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 12:04:34 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908101119460.3208-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Aug 10, 2009 at 11:32:00AM -0400, Alan Stern wrote:
> > > Is there some reason for not accounting for the 4 header bytes in the 
> > > allocation length value stored in the CDB?  Or is this simply a bug?
> > 
> > Um, we do.
> > 
> > unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
> >         unsigned char *buf = kmalloc(259, GFP_KERNEL);
> >         result = scsi_vpd_inquiry(sdev, buf, 0, 255);
> >         for (i = 0; i < buf[3]; i++)
> >                 if (buf[i + 4] == page)
> >                         goto found;
> >         buf = kmalloc(len + 4, GFP_KERNEL);
> >         result = scsi_vpd_inquiry(sdev, buf, page, len);
> 
> I'm not referring to this routine; I'm talking about the code in 
> scsi_vpd_inquiry() where the CDB is set.

You could have been a little clearer in your bug report.

> > > Were you aware that SCSI-2 defines the allocation length to be a single 
> > > byte?  cmd[3] is specified as "Reserved" in the spec.  Hence the value 
> > > of "len" should be capped at 255 if sdev->scsi_level <= SCSI_2, right?
> > 
> > and 'Reserved' in SCSI-2 means:
> > 
> > "A reserved bit, field, or byte shall be set to zero, or in accordance
> > with a future extension to this standard." (7.1.1)
> 
> Sure.  But what reason could there possibly be for making a field
> non-zero when you know that the device won't be able to interpret the
> value correctly?  The fact that sdev->scsi_level == SCSI_2 means
> the device follows _this_ version of the standard, not a future 
> extension.  Or am I missing something?

Because with my misunderstanding of the allocation length to be the page
length, we wouldn't ever request more than 255 bytes until the device
said it supported a page which is more than 255 bytes long.  Since such
a device must be outside the SCSI-2 spec, it was assumed to understand
the meaning of the 'reserved' byte.  So that wasn't a bug.

Now that we need to pass 259 to get 255 bytes, that would be a bug,
so we need to take care of it.

> (And there's no reason to be rude.  I'm trying to hold a civil
> discussion.)

It didn't feel like it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
