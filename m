From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Tue, 15 Jun 2004 00:41:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615074137.GA179379@sgi.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:37363 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S262503AbUFOHnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 03:43:50 -0400
Content-Disposition: inline
In-Reply-To: <40CE9B6F.8000301@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Tue, Jun 15, 2004 at 04:47:11PM +1000, Douglas Gilbert wrote:
> 
> So I guess this patch only applies to sg_header usage since the
> users of sg_io_hdr (including SG_IO ioctl users) must explicitly
> give the data direction.

Correct.  Several apps declare a response length greater than the
absolute minimum, not realizing that this confuses sg, causing
direction to get set incorrectly, and requiring the host drivers
to have their own tables.

> >+static int
> >+sg_direction(char *cmnd)
> >+{
> >+	switch (cmnd[0]) {
> >+	/*  _DATA_OUT commands	*/
> >+	case WRITE_6:		case WRITE_10:		case WRITE_12:
> >+	case WRITE_16:
> >+	case WRITE_LONG:	case WRITE_SAME:	case WRITE_BUFFER:
> >+	case WRITE_VERIFY:	case WRITE_VERIFY_12:
> >+	case COMPARE:		case COPY:		case COPY_VERIFY:
> >+	case SEARCH_EQUAL:	case SEARCH_HIGH:	case SEARCH_LOW:
> >+	case SEARCH_EQUAL_12:	case SEARCH_HIGH_12:	case SEARCH_LOW_12:
> >+	case MODE_SELECT:	case MODE_SELECT_10:	case LOG_SELECT:
> >+	case SEND_DIAGNOSTIC:	case CHANGE_DEFINITION: case UPDATE_BLOCK:
> >+	case SET_WINDOW:	case MEDIUM_SCAN:	case SEND_VOLUME_TAG:
> >+	case REASSIGN_BLOCKS:
> >+	case PERSISTENT_RESERVE_OUT:
> >+	case 0xea:
> 
> Perhaps you might like to tell us what the 0xea vendor
> specific command is (for the record)?

I would like to, but I don't know any more than you do.

> >+	case 0xa3:
> 
> and 0xa3 is MAINTENANCE IN which would be ..._FROM_DEV .
> Did you mean 0xa4 (MAINTENANCE OUT)?

The table is mostly copied from drivers/message/fusion/mptscsih.c.
It was presumably developed through experience, though I have no
firsthand (or secondhand) knowledge of that.

jeremy
