From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Mon, 27 Jun 2005 09:52:56 +0200
Message-ID: <20050627075255.GK19550@suse.de>
References: <20050626153941.456543d6.akpm@osdl.org> <1119829031.5038.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:57730 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261911AbVF0Hvt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 03:51:49 -0400
Content-Disposition: inline
In-Reply-To: <1119829031.5038.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, aradford@amcc.com, Nick Orlov <bugfixer@list.ru>

On Sun, Jun 26 2005, James Bottomley wrote:
> On Sun, 2005-06-26 at 15:39 -0700, Andrew Morton wrote:
> > : OK ... I looked ... and it's not pretty.  The problem is that the 3ware
> > : assumes certain commands (INQUIRY, READ_CAPACITY, MODE_SENSE + a few
> > : others) are only generated internally and thus only have use_sg == 0.
> > : The scsi-block-tree breaks this assumption because we're trying to
> > : eliminate the use_sg == 0 special case.
> > : 
> > : It's important to note that this behaviour is already broken, as anyone
> > : using SG_IO to send commands to the device would have discovered.
> 
> OK, I think the attached is the fix.  It makes the 3w-xxxx routines
> handle sg data.  Can we verify it works first, and then we'll worry
> about how many other internal command processing devices are broken in
> this way.

This wont work at all, I'm afraid. You cannot atomically kmap() the
buffer for queueing, and unmap it from interrupt context. The type
probably isn't correct, and you are not guaranteed to be on the same
CPU when doing the unmap. Thus you end up with corrupted maps and
preemption counts.

-- 
Jens Axboe

