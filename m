From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Emulex lpfcdriver v8.0.2 available
Date: Tue, 8 Jun 2004 18:03:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608170315.GA6751@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F9465@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:53477 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265264AbUFHRDS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 13:03:18 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9465@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Anton Blanchard <anton@samba.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Jun 08, 2004 at 10:54:27AM -0400, Smart, James wrote:
> FYI - and status update.
> 
> A malloc or two was condense on the fast path. However, the reorg so alloc
> was not under lock is not done yet. Should be in the next drop. In
> queuecommand, we will: unload the host lock, perform all allocations and do
> prep data, then take the driver lock, complete state checks and submit to
> hardware. Should allow all the ATOMIC allocations to go back to normal for
> the queuecommand sequence.

Not quite normal, it still needs to be GFP_NOIO to avoid deadlocks.

