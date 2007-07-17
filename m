From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 17:57:46 -0500
Message-ID: <1184713066.3378.33.camel@localhost.localdomain>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	 <20070717063810.GY5195@kernel.dk>
	 <20070717121821.3212cd60.akpm@linux-foundation.org>
	 <20070717132233.ed11362c.akpm@linux-foundation.org>
	 <1184710755.3378.30.camel@localhost.localdomain>
	 <20070717155415.d454e668.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43376 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757396AbXGQW5s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 18:57:48 -0400
In-Reply-To: <20070717155415.d454e668.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2007-07-17 at 15:54 -0700, Andrew Morton wrote:
> On Tue, 17 Jul 2007 17:19:15 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > > Adding 1020116k swap on /dev/hdc3.  Priority:-1 extents:1 across:1020116k
> > > generic_ide_ioctl: cmd=21382
> > > generic_ide_ioctl: err=0
> > > generic_ide_ioctl: cmd=1
> > > program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
> > 
> > I can tell you what went wrong:
> > 
> > This cmd=1 is SCSI_IOCTL_SEND_COMMAND, but that doesn't seem to be
> > what's intended ... I'm guessing it's a legacy ide ioctl value which
> > suddenly has become interpreted as a scsi_ioctl ... and certainly a non
> > CD IDE device cannot handle a SCSI command, so all hell breaks loose.
> 
> An interrupt-off lockup is a pretty bad reaction to an unexpected ioctl
> command.   It makes one wonder if tht lockup can be triggered by other means...

I think this is pretty much par for the course for IDE drivers ... send
it a bogus taskfile (which root is allowed to do) and you'll see it
exhibit the same behaviour.  I suspect what happened is that the driver
expects to treat all REQ_BLOCK_PC requests as taskfiles, so the
wrappered SCSI command got treated as a task file ... the rest you know.

James


