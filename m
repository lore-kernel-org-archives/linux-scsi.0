From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] mount -w of dvd+rw etc. in vanilla 2.6
Date: Wed, 10 Sep 2003 15:49:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030910154929.B3367@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org> <1063217791.3669.43.camel@patehci2> <1063219776.3669.72.camel@patehci2> <1063224520.3669.115.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:53153 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265932AbTIJWuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 18:50:06 -0400
Content-Disposition: inline
In-Reply-To: <1063224520.3669.115.camel@patehci2>; from p.lavarre@ieee.org on Wed, Sep 10, 2003 at 02:08:40PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>, axboe@suse.de
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 10, 2003 at 02:08:40PM -0600, Pat LaVarre wrote:

> # /sbin/blockdev --setro /dev/scd1
> # /sbin/blockdev --getro /dev/scd1
> 1
> # dd of=/dev/scd1 if=/dev/zero bs=2K count=1
> dd: opening `/dev/scd1': Read-only file system
> #
> 
> So far so good, but then:
> 
> # /sbin/blockdev --setrw /dev/scd1
> # /sbin/blockdev --getro /dev/scd1
> 0
> # dd of=/dev/scd1 if=/dev/zero bs=2K count=1
> dd: opening `/dev/scd1': Read-only file system
> #
> 
> That is, no matter if --getro is 0 or 1, still we do not write.  The
> default I see here is 0, but still I cannot write.

Should sd.c and sr.c be calling set_device_ro (after adding a read only
block device, or changing back to read/write)?

-- Patrick Mansfield

