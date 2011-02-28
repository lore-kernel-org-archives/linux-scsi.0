From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi_host_template.queuecommand() instances
Date: Mon, 28 Feb 2011 08:14:39 -0600
Message-ID: <1298902479.2487.9.camel@mulgrave.site>
References: <20110227222102.GH13726@parisc-linux.org>
	 <439834.81106.qm@web161913.mail.bf1.yahoo.com>
	 <20110228132402.GI13726@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37673 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab1B1OOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 09:14:44 -0500
In-Reply-To: <20110228132402.GI13726@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: john smith <whalajam@yahoo.com>, linux-scsi@vger.kernel.org

On Mon, 2011-02-28 at 06:24 -0700, Matthew Wilcox wrote:
> On Sun, Feb 27, 2011 at 11:21:20PM -0800, john smith wrote:
> > How does the queuecommand get called for concurrent application threads  before 2.6.37?
> 
> Before 2.6.37, there's a per-host lock acquired in the scsi layer that
> prevents queuecommand being called twice for the same host simultaneously.
> If your driver is drivign two cards, then it can still be executing
> twice ...  but it's a rare driver that has global instead of per-host
> state to protect.

Actually, that's not quite correct.  What happened in 2.6.37 is that the
host lock was no longer taken prior to entry to ->queuecommand.  Before
that most of the threaded HBAs dropped it immediately in the
->queuecommand routines so they could be multi threaded, which meant all
we were doing a pointless lock shuffle.

What actually governs the threading is the ioscheduler entry context to
the request function, which tends to be governed by how the I/O is
called at the top.

James





