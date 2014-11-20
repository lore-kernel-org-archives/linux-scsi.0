From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: 3.16 commit 89fb4cd errors on drives without
 SYNC CACHE
Date: Thu, 20 Nov 2014 10:11:57 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411201008290.1061-100000@iolanthe.rowland.org>
References: <20141120064233.GA29412@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57013 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755979AbaKTPL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 10:11:58 -0500
In-Reply-To: <20141120064233.GA29412@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff DeFouw <mrj@plorb.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Wed, 19 Nov 2014, Christoph Hellwig wrote:

> On Sat, Nov 15, 2014 at 08:14:57PM -0500, Jeff DeFouw wrote:
> > Kernel 3.16 includes commit
> > 89fb4cd1f717a871ef79fa7debbe840e3225cd54
> > scsi: handle flush errors properly
> > 
> > I have an old USB backup drive that indicates a write cache but does not 
> > support Synchronize Cache(10).  The request error now gets returned, 
> > resulting in a journal abort and inability to write to the ext3 
> > filesystem.  I was able to work around the problem by adding a new USB 
> > storage quirk that completes the request without contacting the drive.  
> > Is it acceptable for a drive to respond this way, and therefore need to 
> > be handled in the SCSI layer, or is a new USB storage quirk the right 
> > way to go?
> 
> Maybe the problem is that usb-storage sets the wce_default_on flag, and
> we thus send a SYNCHRONIZE_CACHE even if the devices never claimed to
> support it?

usb-storage sets wce_default_on only for devices that are marked with 
the US_FL_WRITE_CACHE quirk flag.  Currently only two devices have that 
flag: the Seagate Portable HDD (vendor ID 0x0bc2, product ID 0x2300) 
and the Western Digital My Password HDD (vendor ID 0x1058, product ID 
0x070a).

> Adding the 

Alan Stern

