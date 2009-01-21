From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH ver2 printk_ratelimit] bsg: Error print if device is not bidi capable when refusing a bidi command
Date: Wed, 21 Jan 2009 08:53:11 +0100
Message-ID: <20090121075310.GV30821@kernel.dk>
References: <4975DC00.2090005@panasas.com> <20090120141517.GM30821@kernel.dk> <4975E1EE.5070101@panasas.com> <20090120144608.GQ30821@kernel.dk> <4975E748.6040705@panasas.com> <4975EE69.1020404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:11350 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZAUHyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 02:54:44 -0500
Content-Disposition: inline
In-Reply-To: <4975EE69.1020404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

On Tue, Jan 20 2009, Boaz Harrosh wrote:
> Boaz Harrosh wrote:
> > Jens Axboe wrote:
> >> Thanks, that works. But why isn't the -EOPNOTSUPP error return (which the
> >> app can see and print info about) enough? Do we really need to put this
> >> in the kernel log?
> >>
> > 
> > 
> > But let me check I had problems with the return value.
> 
> OK I found my problem, blush:
> 
> -		ret = ioctl(fd, SG_IO, &sg);
> +		ret = ioctl(fd, SG_IO, &sg) ? -errno : 0;
> 
> So if I do a print to stderr in the lowest-most library will
> that be visible enough to an Admin. I have utils like
> osd_format, mkfs.exofs, a FUSE filesystem ...
> OK I can always redirect stderr to the dmsg log

Goodie, that saves us that printk() :-)

-- 
Jens Axboe

