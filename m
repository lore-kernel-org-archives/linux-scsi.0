From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: writev to scsi disks
Date: Wed, 20 Apr 2005 17:15:31 -0400
Message-ID: <1114031732.5933.7.camel@mulgrave>
References: <363f92a8050420080112dec5db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:19622 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261816AbVDTVPe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 17:15:34 -0400
In-Reply-To: <363f92a8050420080112dec5db@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dheeraj Pandey <dheeraj@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-04-20 at 08:01 -0700, Dheeraj Pandey wrote:
> I was wondering if I did a simple writev to a SCSI disk, does it take
> the sg path to the device? I am guessing sg (REQ_SPECIAL) is only
> true for character devices (and ioctl's) and not block devices.

?  I think you misunderstand how writev works.  It's design is to take a
list of scattered buffers in a user program and consolidate them into a
single write.  This (in the current implementation) is a separate entity
from the block level Scatter Gather.

If by sg write path, if you mean scatter-gather write path, then yes,
that single write would be split up again into a sg list based on the
device parameters if you mean does the writev sg list control where on
the disk the data ends up, then no, if you use a disk device as a simple
file, writev consolidates all writes to the current file position.

James




