From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dec_esp: Use physical addresses
Date: Mon, 17 Oct 2005 11:42:07 +0100
Message-ID: <20051017104207.GA22710@infradead.org>
References: <20051015012630.GA20981@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7857 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932262AbVJQKmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:42:08 -0400
Content-Disposition: inline
In-Reply-To: <20051015012630.GA20981@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Sat, Oct 15, 2005 at 02:26:31AM +0100, Ralf Baechle wrote:
> FYI.  This is part of a larger MIPS patch which I'd like to submit
> to akpm as a single patch.

Please don't do that _ever_.  (dito for the other bits sent out)
scsi patches should be submitted to linux-scsi as individual patcvhes.

> Use physical addresses at the interface level, letting drivers remap
> them as appropriate.

> -		esp->eregs = (struct ESP_regs *) (system_base + IOASIC_SCSI);
> +		esp->eregs = (void *)CKSEG1ADDR(dec_kn_slot_base +
> +						IOASIC_SCSI);

Both the old and new code look very odd.  This looks like iomaped-ish
memory and should be using some iomap variant.  The patch is probably
okay for now, but I'd prefer if this used the proper APIs.

