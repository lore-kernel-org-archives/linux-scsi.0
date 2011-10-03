From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling?=
 =?windows-1252?Q?_of_USB_HDD=92s_in_scsiglue=28slave=5Fconfigu?=
 =?windows-1252?Q?re=29_and_scsi/sd=28sd=5Fread=5Fcache=5Ftype=29?=
Date: Mon, 3 Oct 2011 14:10:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1110031408420.1882-100000@iolanthe.rowland.org>
References: <4E89DD79.6020306@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43717 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932317Ab1JCSKy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 14:10:54 -0400
In-Reply-To: <4E89DD79.6020306@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, 3 Oct 2011, Douglas Gilbert wrote:

> The RBC device parameters mode page followed by a Power
> Condition mode page. The RBC device parameters mode page
> is the only SCSI page I have seen (mode, log, VPD, etc)
> with a 5 byte field!
> 
> Decoded response to a probable MODE SENSE(6) "fetch all
> pages" command:
>    RBC device parameters mpage:
>      WCD=0 [double negative: write cache enabled]
>      Logical block size: 512 bytes
>      Number of logical blocks: 0x12A19EB0 *** [160 GB]
>      Power/performance: 0x3c
>      READD: 0 [READ enabled]
>      WRITED: 0 [WRITE enabled]
>      FORMATD: 0 [FORMAT UNIT enabled]
>      LOCKD: 1 [media cannot be locked]
>    Power Condition mpage:
>      IDLE=0
>      STANDBY=1
>      IDLE_CONDITION_TIMER=0
>      STANDBY_CONDITION_TIMER=0xbb8 [300 seconds]
> 
> References: rbc-r10a.pdf [1999] + spc3r26 [2005]
> 
> Hopefully Seagate will switch to UAS(P) in the near future.
> 
> 
> *** That is _not_ the address of the last valid LB as in
>      the SCSI READ CAPACITY command!

Thanks for the explanation.

> > Would it make sense to assume write caching is present and enabled if
> > the drive does not provide a Caching page?
> 
> No. You need to also take into account the RBC
> device parameters mode page if present. See above.

All right, suppose neither page is present.  Does it then make sense to 
assume by default that write caching is enabled?

Alan Stern

