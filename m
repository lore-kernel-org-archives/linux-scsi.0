From: Jens Axboe <axboe@suse.de>
Subject: Re: 2 KiB/block loopback found where
Date: Mon, 29 Sep 2003 18:46:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030929164654.GS15415@suse.de>
References: <1064271322.4797.9.camel@patehci2> <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:56532 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263746AbTI2Qqx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 12:46:53 -0400
Content-Disposition: inline
In-Reply-To: <1064850600.25057.7.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 29 2003, Pat LaVarre wrote:
> 
> I want a 2 KiB/block loopback device to help debug udf.ko.
> 
> I get 0.5 KiB/block.  Did I fail to find an option or an appropriate
> kernel patch, I do I have to write my own patch?  I'm guessing I'll find
> 2 KiB/block easy to fake, since 0.5 KiB divides evenly into 2 KiB.
> 
> Specifically, I want to see 2048 where now I see 512 in response to my
> query `blockdev --getss`.  A more complete example console log follows:
> 
> Pat LaVarre
> 
> $
> $ dd of=dd.bin bs=1M count=1 if=/dev/zero
> 1+0 records in
> 1+0 records out
> $
> $ ls -l dd.bin
> -rw-rw-r--    1 pat      pat       1048576 Sep 29 09:43 dd.bin
> $
> $ sudo /sbin/losetup /dev/loop0 dd.bin
> $
> $ sudo blockdev --getss /dev/loop0
> 512
> $

Add a quick hack to loop to set 2kb block size, grep for set_blocksize.

-- 
Jens Axboe

