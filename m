From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [Emulex] queuecommands and GFP_ATOMIC
Date: Tue, 8 Jun 2004 19:23:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608182356.GA7523@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F946C@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:38630 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265277AbUFHSX7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 14:23:59 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F946C@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Anton Blanchard <anton@samba.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Jun 08, 2004 at 02:21:05PM -0400, Smart, James wrote:
> So we've done some testing with the locks moved and the GFP_xxx flag
> changed...
> 
> On a RedHat 3.90 2.6.5 kernel, we hit the following:
> 
> Debug: sleeping function called from invalid context at mm/slab.c:1980
> in_atomic():1, irqs_disabled():0
> Call Trace:

Looks like you used spin_unlock instead of spin_unlock_irq for the host
lock.
