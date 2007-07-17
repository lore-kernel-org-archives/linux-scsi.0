From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 15:54:15 -0700
Message-ID: <20070717155415.d454e668.akpm@linux-foundation.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<20070717063810.GY5195@kernel.dk>
	<20070717121821.3212cd60.akpm@linux-foundation.org>
	<20070717132233.ed11362c.akpm@linux-foundation.org>
	<1184710755.3378.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757991AbXGQWyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 18:54:35 -0400
In-Reply-To: <1184710755.3378.30.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 17 Jul 2007 17:19:15 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> > Adding 1020116k swap on /dev/hdc3.  Priority:-1 extents:1 across:1020116k
> > generic_ide_ioctl: cmd=21382
> > generic_ide_ioctl: err=0
> > generic_ide_ioctl: cmd=1
> > program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
> 
> I can tell you what went wrong:
> 
> This cmd=1 is SCSI_IOCTL_SEND_COMMAND, but that doesn't seem to be
> what's intended ... I'm guessing it's a legacy ide ioctl value which
> suddenly has become interpreted as a scsi_ioctl ... and certainly a non
> CD IDE device cannot handle a SCSI command, so all hell breaks loose.

An interrupt-off lockup is a pretty bad reaction to an unexpected ioctl
command.   It makes one wonder if tht lockup can be triggered by other means...
