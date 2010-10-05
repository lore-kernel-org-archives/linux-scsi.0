From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH]SCSI:Do not block suspend for abandoned devices
Date: Tue, 05 Oct 2010 12:19:46 -0500
Message-ID: <1286299186.6661.20.camel@mulgrave.site>
References: <201010051721.25431.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0JERTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2010 13:19:51 -0400
In-Reply-To: <201010051721.25431.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, hare@suse.de

On Tue, 2010-10-05 at 17:21 +0200, Oliver Neukum wrote:
> From d0e0b88a5b271a45f00ab8ae9f22b992d5d090ba Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Tue, 5 Oct 2010 17:06:46 +0200
> Subject: [PATCH] SCSI:Do not block suspend for abandoned devices
> 
> If a device becomes inaccessible while a suspension
> is carried out, the device is gone anyhow. There's
> no need to block the suspension, as we'd ignore the
> devices on later attempts anyway.

So this clarifies what you're trying to do; thanks.  However, I still
think the premise is wrong: if we get a failure for any reason (whether
memory allocation or disk) we probably haven't flushed the disk cache
and our next action in suspend (whether to ram or disk) will power the
drive down and lose the cache data.  I really don't think blocking
suspend and informing the user is inappropriate here.

James


