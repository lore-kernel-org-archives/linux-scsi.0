From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: blk_queue_hardsect_size 520-byte sector
Date: Fri, 6 Jun 2008 11:18:07 +0100
Message-ID: <20080606111807.44d0be02@core>
References: <339116.28290.qm@web32404.mail.mud.yahoo.com>
	<20080606075432.GH5757@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48162 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857AbYFFKd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 06:33:57 -0400
In-Reply-To: <20080606075432.GH5757@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Anil kumar <anils_r@yahoo.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 6 Jun 2008 09:54:33 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Jun 05 2008, Anil kumar wrote:
> > Hi,
> > 
> > Can I call blk_queue_hardsect_size in a driver and set it to 520-byte
> > as hardware sector size.  How does the kernel and block layers take
> > the request, will it be in multiples of 520-bytes aligned or 512 bytes
> > aligned?
> 
> No, Linux only supports power-of-2 hardware block sizes I'm afraid.

And only some of those - which is why we can't support CP/M disks and
also early smartmedia stuff (128/256 byte/sector)

If you are trying to deal with 520 byte blocks that are 512 bytes file
system data + 8 bytes of meta data then use 512 byte block sizes and put
the meta-data somewhere else or provide a different way to access it  -
eg ATA uses 512 byte sectors for normal ATA but the sg_io() ioctl path
allows the issuing of commands like READ_LONG for specific cases where
the additional meta data is needed.

Alan
