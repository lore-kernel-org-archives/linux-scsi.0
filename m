From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx deadlock in 2.6.0-test10
Date: 24 Nov 2003 09:08:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069686529.1836.6.camel@mulgrave>
References: <20031123230853.0bc8defb.akpm@osdl.org>
	<20031124081319.A29562@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:6148 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263769AbTKXPJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 10:09:37 -0500
In-Reply-To: <20031124081319.A29562@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-11-24 at 02:13, Christoph Hellwig wrote:
> jejb just posted another fix for it on linux-scsi, but in fact your fix
> looks better to me, ahc_initialize doesn't need the host_lock because
> ahc can't be reached from an other thread yet.

I don't think so.  This only fixes the boot case for aic7xxx (the boot
problem is also present in aic79xx). This routine was designed to be
called also when a driver detects a reset it didn't initiate
(aic7xxx_old is probably the only driver that actually seems to do
this).  In that case, the detection is called from the ISR, so you don't
want to drop the lock

The fix, I think, is to require the lock be held for the bus/device
reset reporting callbacks and use the unlocked iterator.

James


