From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Tue, 26 Feb 2008 06:56:37 -0700
Message-ID: <20080226135637.GA10837@parisc-linux.org>
References: <200802251235.889863872@firstfloor.org> <20080224233516.0657F1B4183@basil.firstfloor.org> <20080225214746.GA11382@parisc-linux.org> <20080225224035.GB21577@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40457 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYBZN47 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Feb 2008 08:56:59 -0500
Content-Disposition: inline
In-Reply-To: <20080225224035.GB21577@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, Feb 25, 2008 at 11:40:35PM +0100, Andi Kleen wrote:
> On Mon, Feb 25, 2008 at 02:47:46PM -0700, Matthew Wilcox wrote:
> > I have to say I really don't like this patch.  I'll look up my current
> 
> Why do you not like it? What would you do better?
> 
> > patch queue for this driver next week -- I think I fixed this differently.
> > (I must have fixed it somehow because it works on parisc, which is most
> > unforgiving of drivers which do DMA without the DMA API).

This patch is unnecessary.  The driver does not access the cmnd field
using DMA.  See AscPutReadyQueue where it calls:

        AscMemWordCopyPtrToLram(iop_base,
                                q_addr + ASC_SCSIQ_CDB_BEG,
                                (uchar *)scsiq->cdbptr, scsiq->q2.cdb_len >> 1);

Despite the name, it doesn't actually copy a pointer to Lram.  It copies
the thing pointed at to Lram.  (ie it's memcpy_toio with a minor twist).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
