From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: LUN resizing
Date: 25 Nov 2003 10:11:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069776713.1787.36.camel@mulgrave>
References: <1069708054.26088.127.camel@lt-sv>
	<1069774983.2061.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:50951 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261681AbTKYQMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 11:12:00 -0500
In-Reply-To: <1069774983.2061.28.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Voelkel <Stefan.Voelkel@millenux.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-11-25 at 09:43, James Bottomley wrote:
> You simply do
> 
> echo 1 > /sys/bus/scsi/<device>/rescan
> 
> It will re-read the capacity and partition table (as long as the device
> is unmounted and none of the partitions open).

OK, I actually tried this, you need two steps.  The one above will
reread the capacity.  After that you send a BLKRRPART ioctl to the
device to re-read the partition table. (but, obviously, something else
will have to update the partition table to see the new device size)

James


