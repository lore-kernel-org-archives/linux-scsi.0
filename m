From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/4] revert the commit 22a9189f (cdrom: use kmalloced
 buffers instead of buffers on stack)
Date: Wed, 21 May 2008 18:18:47 -0700 (PDT)
Message-ID: <20080521.181847.157652663.davem@davemloft.net>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080521221113.GA12695@alpha.franken.de>
	<20080522095506E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50980
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762848AbYEVBSw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 21:18:52 -0400
In-Reply-To: <20080522095506E.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: tsbogend@alpha.franken.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 22 May 2008 10:13:31 +0900

> DMA on stack is forbidden because of non coherent architecutes and
> architectures can't uses stack addresses for DMA? What architectures
> can't uses stack addresses for DMA? Would it be better to just forbid
> using stack addresses for DMA on all the architectures at all times?

Rather, the real problem is that some architectures map the kernel
stack virtually, and as a result virt_to_page() and things like that
will not work.

It really is fully not working to put DMA buffers on the stack
in these cases.
