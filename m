From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 17:46:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040823154648.GB2301@suse.de>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patlinux.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:17027 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265722AbUHWPsQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 11:48:16 -0400
Content-Disposition: inline
In-Reply-To: <1092678938.4235.37.camel@patlinux.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 16 2004, Pat LaVarre wrote:
> Jens A:
> 
> > in short, please try again :-)
> 
> I much appreciate your patient encouragement.  I now know I can ask:
> 
> Is there an ide-cd option to allow more bytes/CDB?
> 
> That is, an option analogous to the /sys/block/sr*/device/max_sectors
> setting of usb-storage, allowing up to the xFF:FF LBA's/CDB standard at
> t10.org?  Else can I help create such an option?
> 
> I see ioctl SG_IO chokes via EIO if bytes/CDB goes much above zero.
> 
> I ask for a workaround because a friend of mine cares.
> 
> I see EIO at 130 KiB/CDB, though happy at 128 KiB/CDB, when I try
> ide-cd.  I see usb-storage defaults to choke thruput off at 120 KiB/CDB,
> but thru /sys lets us reach a little farther above zero i.e. 512
> KiB/CDB.
> 
> How coordinated is our 2.6 effort to choke off thruput near zero across
> PATAPI, USB, FireWire, SPI, SATAPI, etc.?
> 
> Is there an ide-cd option to allow more bytes/CDB?

Ok, makes more sense to me now. The reason why I get confused is that I
don't consider the cdb more than the actual 10-16 bytes of command data
bytes, not the full structure of it.

But yes, different devices will have different max transfer values. As
I'm sure you know, ATAPI cannot do more than 128KiB per command. And
that is what q->max_sectors is set to, if you try and submit more than
this through SG_IO, bio_add_user() will complain and command will be
failed as you experienced.

max_sectors should be fully exposed so you don't have to guess.

-- 
Jens Axboe

