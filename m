From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 19:08:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040823170827.GC24089@suse.de>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patlinux.iomegacorp.com> <20040823154648.GB2301@suse.de> <4D36722F-F51E-11D8-BFA2-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:17825 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266081AbUHWRIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 13:08:34 -0400
Content-Disposition: inline
In-Reply-To: <4D36722F-F51E-11D8-BFA2-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 23 2004, Pat LaVarre wrote:
> Jens A:
> 
> >>Is there an ide-cd option to allow more bytes/CDB?
> >...
> >ATAPI cannot do more than 128KiB per command. And
> >that is what q->max_sectors is set to, if you try and submit more than
> >this through SG_IO, bio_add_user() will complain and command will be
> >failed as you experienced.
> 
> Wow.
> 
> Please reply to confirm - you are saying 128 KiB data bytes per command  
> is a Linux PATAPI design limit?
> 
> I know even twelve-byte-packet PATAPI itself as defined at t13.org and  
> t10.org can do xFFFF = (64 Ki - 1) LBA's via such ten-byte per CDB ops  
> as x28 "READ (10)" and x2A "WRITE (10)".  At 2 KiB/LBA, that's 128 MiB  
> minus 2 KiB.  That's the kind of limit I expected, when instead in  
> Linux I saw limits like 120 KiB in SCSI over USB.  Also I hear  
> sixteen-byte-packet PATAPI can itself pass xFFFF:FFFF data blocks per  
> command.

What you can shove into the cdb is of lesser interest than the fact that
ATAPI itself cannot do more than 128KiB _per command_.

> In parallel, I'll click thru to bio_add_user to read the limits there.

There are no extra limits there, it's just in the queue itself
(max_sectors, segments, etc).

> >As I'm sure you know,
> 
> I didn't know, thank you, sorry I have no clue, I'm not trying to  
> pretend I do, I got into this at the request of a friend who needs 256  
> KiB data per command.

??? You must have some clue on the actual hardware, if you have been
working on the hardware side for many years :-)

> I specifically have Not yet tried patching the Linux kernel to persuade  
> PATAPI to allow more data bytes per command.  I did try USB.  So far  
> I've failed.  At:
> 
> Subject: [usb-storage] faq max_sectors
> https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-August/ 
> 000680.html
> 
> I have reported that raising SCSI_DEFAULT_MAX_SECTORS alone does not  
> actually allow more data bytes per command in USB.

Ok, let me try to explain. There are several factors that limit how big
a command you can send to a device - some of these are hardware, some of
these are just imposed by the driver. If you look inside the
request_queue structure in blkdev.h, you'll find such things as:

        unsigned short          max_sectors;
        unsigned short          max_phys_segments;
        unsigned short          max_hw_segments;
        unsigned int            max_segment_size;

which are set by the driver and limit how big a request you can submit
through SG_IO.

-- 
Jens Axboe

