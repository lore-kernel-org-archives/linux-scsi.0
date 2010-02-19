From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/5] SCSI: fix bad method call in scsi_target_destroy
Date: Fri, 19 Feb 2010 10:29:43 -0600
Message-ID: <1266596983.2822.40.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1002121211190.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46363 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab0BSQ3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 11:29:51 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002121211190.1307-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2010-02-12 at 12:14 -0500, Alan Stern wrote:
> This patch (as1336) fixes a bug in scsi_target_destroy().  It calls
> the host template's target_destroy method even if the target_alloc
> method failed.  (Also, the target_destroy method is called inside the
> scope of the host lock, which is unnecessary and probably a mistake.)

OK, so this isn't a mistake.  The act of create/destroy on the target
and removing it from the lists has to be atomic for devices which use
fixed slots (most SPI cards).  If the target is still in the list after
destroy, it could end up getting spuriously reused.  Conversely, if you
remove it from the list and then destroy, we could end up getting target
alloc for a new target called *before* the target_destroy of the old
one.

> A new flag is added to struct scsi_target to remember whether or not
> the target_alloc has succeeded.  There also are a couple of minor
> whitespace formatting improvements.

I don't really see the need for this.  None of the users assumes the
target was created ... if they do allocations, they all check before
unwinding.  If there is a case for needing this, it should be part of
the target state flags.

James


