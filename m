From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Emulex lpfcdriver v8.0.2 available
Date: Tue, 1 Jun 2004 20:01:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601190118.GA22856@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F93F1@xbl.ma.emulex.com> <20040601185200.GB4239@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:63460 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265136AbUFATBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 15:01:21 -0400
Content-Disposition: inline
In-Reply-To: <20040601185200.GB4239@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: "Smart, James" <James.Smart@Emulex.Com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, Jun 02, 2004 at 04:52:00AM +1000, Anton Blanchard wrote:
> We gave it a spin on a ppc64 box and managed to hit the following
> backtrace when doing heavy writeout. I wonder if a number of these
> atomic allocations (in lpfc_get_scsi_buf etc) should be using a mempool,
> otherwise we could deadlock on writeout.

The ->queuecommand path has a few more problems.  The number of different
memory allocation is just too many, this needs some thinking into needing
less allocations.  Most allocations are happening under a spinlock and
with irqs disabled which is not exactly a good idea.  And the whole
I/O submission path is very badly structured and hard to follow.

