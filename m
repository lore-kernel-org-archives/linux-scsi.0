From: Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: Tree for Nov 27 (scsi/aha1542)
Date: Wed, 28 Nov 2018 07:54:50 +0100
Message-ID: <20181128065450.GA20211@lst.de>
References: <20181127152539.55426063@canb.auug.org.au> <ef9090cf-e86a-7fd0-dfa9-6810eaaf7e65@infradead.org> <20181128153847.08ead1c9@canb.auug.org.au> <1543383684.3518.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1543383684.3518.2.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Randy Dunlap <rdunlap@infradead.org>, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 27, 2018 at 09:41:24PM -0800, James Bottomley wrote:
> Yes, it's because dma_addr_t can be u64 on pae systems but
> isa_virt_to_bus only ever returns unsigned long (because an ISA
> physical address can only be 24 bits).
> 
> I think this is the fix; there doesn't seem to be much point converting
> to do_div given all the limitations.

Yes, something along these lines should fix it.  I don't have the code
in front of me, but I vaguely remember there is a second division like
this, though.  It might be worth to factor the calculation into a helper
with a comment like the message above explaining it.
