From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sr: fix multi-drive performance, remove BKL
 replacement
Date: Tue, 28 Feb 2012 10:57:37 -0600
Message-ID: <1330448257.2822.138.camel@dabdike.int.hansenpartnership.com>
References: <20120228153244.70413d34@stein> <20120228170930.132f7c1e@stein>
	 <1330445795.2822.134.camel@dabdike.int.hansenpartnership.com>
	 <201202281642.16496.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43797 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001Ab2B1Q5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2012 11:57:40 -0500
In-Reply-To: <201202281642.16496.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 16:42 +0000, Arnd Bergmann wrote:
> On Tuesday 28 February 2012, James Bottomley wrote:
> > On Tue, 2012-02-28 at 17:09 +0100, Stefan Richter wrote:
> > > On Feb 28 James Bottomley wrote:
> > > 
> > > While I do remove sr_mutex aroud scsi_cd_get/put() calls, these ones
> > > internally use another lock: sr_ref_mutex.  Always did, still do, since
> > > neither Arnd's mechanical BKL pushdown and BKL-to-mutex conversions
> > > patches nor my patch changed that.  This sr_ref_mutex also protects sr's
> > > reference counting outside of the three block_device_operations methods
> > > which I changed.
> > > 
> > > I suppose I could have mentioned right away in the changelog that the
> > > sr driver's own reference counting serialization remains in place, via that
> > > other mutex.
> > 
> > OK, agreed ... the thing that caught my eye was the get/open and the
> > release/put, but I think that's completely safe.
> 
> I took another look and I believe the cdi->use_count in
> cdrom_open/cdrom_release still requires some protection that is
> currently provided by sr_mutex.

So I think this is fine ... it's protected by the bdev->bd_mutex.

>  Some parts of cdrom_ioctl also
> access this variable and things like cdi->options or cdi->keeplocked.

This would be problematic because we no longer lock the ioctl.

> I could imagine that you can get rid of the mutex if you turn those
> into atomics and bitops, but there may be other parts of cdrom_device_info
> that need locking. A safer option to solve the performance problems
> could be to replace sr_mutex with a per-device mutex inside of
> cdrom_device_info.

I'd say the latter.

James


