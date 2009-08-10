From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 08:58:11 -0600
Message-ID: <20090810145810.GA31442@parisc-linux.org>
References: <Pine.LNX.4.44L0.0908101027160.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42879 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZHJO6K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 10:58:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908101027160.3208-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Aug 10, 2009 at 10:41:42AM -0400, Alan Stern wrote:
> Martin and Matthew:
> 
> Since you guys added scsi_vpd_inquiry() and scsi_get_vpd_page() plus
> sd_read_block_limits() and sd_read_block_characteristics(), I'm
> directing these questions to you.
> 
> Is there some reason for not accounting for the 4 header bytes in the 
> allocation length value stored in the CDB?  Or is this simply a bug?

Um, we do.

unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
        unsigned char *buf = kmalloc(259, GFP_KERNEL);
        result = scsi_vpd_inquiry(sdev, buf, 0, 255);
        for (i = 0; i < buf[3]; i++)
                if (buf[i + 4] == page)
                        goto found;
        buf = kmalloc(len + 4, GFP_KERNEL);
        result = scsi_vpd_inquiry(sdev, buf, page, len);

Now ... we do seem to be passing the len instead of len + 4 to the
device as the buffer size, so there does appear to be a minor bug here,
but it's not as horrific as you make it out to be.

> Were you aware that SCSI-2 defines the allocation length to be a single 
> byte?  cmd[3] is specified as "Reserved" in the spec.  Hence the value 
> of "len" should be capped at 255 if sdev->scsi_level <= SCSI_2, right?

and 'Reserved' in SCSI-2 means:

"A reserved bit, field, or byte shall be set to zero, or in accordance
with a future extension to this standard." (7.1.1)

> Why does scsi_get_vpd_page() retrieve page 0 first, rather than 
> directly asking for the page in question?  Is this some sort of 
> play-it-safe approach, to avoid sending devices commands they may not 
> support?

I think we had an example of a device which crashed when asked for pages
that it didn't support.

> Have you considered that plenty of low-budget USB mass-storage devices
> don't implement VPD properly?  I've got a flash drive right here which

I've noticed you whining about it, yes.

> totally ignores the "page" byte in the INQUIRY command; it always
> responds with the normal INQUIRY data.  Thus expecting the response

I don't think you mean the 'page' byte.  I think you mean the 'EVPD'
bit.

> data always to be accurate may not be a good idea.  I'm considering
> adding a "restrict_to_MS_usb" flag to the host template, to indicate
> that commands shouldn't be sent unless some version of Windows uses
> them when talking to USB devices -- do you think that could work?

Not really my area of expertise.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
