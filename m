From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [2.6.0-test4] blocking access to mounted scsi devices
Date: 26 Aug 2003 09:08:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061906937.1830.11.camel@mulgrave>
References: <3F49B515.6010107@torque.net>
	<20030825130822.A4258@infradead.org>  <3F4B3482.4060304@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:42246 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263787AbTHZOKF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 10:10:05 -0400
In-Reply-To: <3F4B3482.4060304@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ballen@gravity.phys.uwm.edu

On Tue, 2003-08-26 at 05:20, Douglas Gilbert wrote:
> Christoph Hellwig wrote:
> > That's because both mount (or e.g. volume managers) claims
> > devices for exclusive use, as does drivers/block/scsi_ioctl.c
> 
> Well it is reasonable that mount should exclude other attempts
> to mount. However the device holding the root file system
> may be an ATA or SCSI disk and the ide-disk and sd drivers
> do not support SMART probing directly.

Hang on, that's not the way it's supposed to work.

Mount should be on partition devices (like /dev/sda1) whereas the tools
should be on whole disc devices (like /dev/sda).  I thought we'd agreed
that even opening a partition exclusively wouldn't affect the ability to
open the whole disc device (but opening the whole disc device
exclusively would block access to all partitions).

Therefore, the only issue we should have is with volume managers that
need to open whole disc devices exclusively, and possibly with the
device mapper.

James


