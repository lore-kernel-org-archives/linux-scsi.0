From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Tue, 22 Jul 2008 09:40:31 -0500
Message-ID: <1216737631.3364.17.camel@localhost.localdomain>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45645 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbYGVOkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jul 2008 10:40:36 -0400
In-Reply-To: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mike.miller@hp.com, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 2008-07-19 at 19:52 +0900, FUJITA Tomonori wrote:
> This is a SCSI driver for HP (Compaq) Smart Array 5xxx controllers.
> 
> SCSI people can skip the following two paragraphs.
> 
> Currently, a driver for HP (Compaq) Smart Array 5xxx controllers is
> implemented as a block device driver, block/cciss.c (aka, cciss). But
> the controller interface is SCSI-3 compatible. The specification says,
> "A controller that supports CISS is considered to be a SCSI storage
> array controller". A scsi driver for the controllers was discussed
> several times.
> 
> I think that a SCSI cciss driver can be much simpler (and
> maintainable) than the block cciss driver (the majority of the code
> forging SCSI command can go away, we have the proper sysfs entries for
> free, we can handle scsi tape drives easily etc). It would be helpful
> for distributions too since they don't need stuff specific to cciss
> (such as udev rules).
> 
> 
> There isn't any easy migration path for users. So I think that we need
> to keep the block and scsi drivers for cciss for some time (say two
> years).

Actually, I think we can make one (which is really required ... it's a
lot of pain to move device nodes, just look at libata).  It should be
child's play to come up with a udev rule that simply does extra symbolic
links from /dev/cciss<n>c<n>p<n> to whatever the sd device is.  That
should hide a lot of the problem.

The other issue is plugging the management ioctl in, but that can be
done via scsi_host->ioctl.

James


