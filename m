From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] Fw: [Bug 3466] New: Bug while connecting
	USB-HDD (fwd)
Date: 26 Sep 2004 18:05:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096236347.10924.97.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409261704460.32350-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5311 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264299AbUIZWFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Sep 2004 18:05:50 -0400
In-Reply-To: <Pine.LNX.4.44L0.0409261704460.32350-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Sun, 2004-09-26 at 17:06, Alan Stern wrote:
> Andrew sent this to linus-usb-devel, but it should have gone to
> linux-scsi.

There's not enough information to say why it happened.  However, all the
SCSI code checks out (it's dated ... open coded reference counting
instead of kref, but it looks sound).  The scenario described could be
seen if there's a problem in the host reference counting.

In that case, there should have been a slab error earlier on in the logs
at the point the error occurred saying something like "slab error in
kmem_cache_destory(): can't free all objects"

It's possible this could be caused by a refcounting race on the
commands.

James


