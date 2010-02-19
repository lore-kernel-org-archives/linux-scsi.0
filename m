From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5] SCSI: fix target allocation outside of scan_mutex
Date: Fri, 19 Feb 2010 10:34:55 -0600
Message-ID: <1266597295.2822.50.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1002121212020.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46531 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab0BSQfD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 11:35:03 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002121212020.1307-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2010-02-12 at 12:14 -0500, Alan Stern wrote:
> This patch (as1337) fixes a bug in __scsi_add_device().  It calls
> scsi_alloc_target() outside the protection of the host's scan_mutex,
> meaning that it might find an incompletely-initialized target or it
> might create a duplicate target.

I don't think this is correct.  scsi_alloc_target should be completely
atomic on the host lock, if you look.  It allocates the proposed target,
takes the lock and searches the host target list ... if it finds
something it drops the lock, destroys the proposed target allocations
and returns what it found.  If it finds nothing, it adds the proposed
target to the list drops the lock and returns it.  There's some
complexity around finding dying targets, but nothing that I think needs
to be mediated by the scan mutex.

James


