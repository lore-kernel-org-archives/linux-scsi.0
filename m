From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH]SCSI:Do not block suspend for abandoned devices
Date: Wed, 6 Oct 2010 09:22:45 +0200
Message-ID: <201010060922.45191.oneukum@suse.de>
References: <201010051721.25431.oneukum@suse.de> <1286299186.6661.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab0JFHVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2010 03:21:46 -0400
In-Reply-To: <1286299186.6661.20.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, hare@suse.de

Am Dienstag, 5. Oktober 2010, 19:19:46 schrieb James Bottomley:
> On Tue, 2010-10-05 at 17:21 +0200, Oliver Neukum wrote:
> > From d0e0b88a5b271a45f00ab8ae9f22b992d5d090ba Mon Sep 17 00:00:00 2001
> > From: Oliver Neukum <oliver@neukum.org>
> > Date: Tue, 5 Oct 2010 17:06:46 +0200
> > Subject: [PATCH] SCSI:Do not block suspend for abandoned devices
> > 
> > If a device becomes inaccessible while a suspension
> > is carried out, the device is gone anyhow. There's
> > no need to block the suspension, as we'd ignore the
> > devices on later attempts anyway.
> 
> So this clarifies what you're trying to do; thanks.  However, I still
> think the premise is wrong: if we get a failure for any reason (whether
> memory allocation or disk) we probably haven't flushed the disk cache
> and our next action in suspend (whether to ram or disk) will power the
> drive down and lose the cache data.  I really don't think blocking
> suspend and informing the user is inappropriate here.

I see. It seems to me that this is true for SDEV_OFFLINE only.

	Regards
		Oliver
