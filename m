From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for
 potential bio leak"
Date: Wed, 10 Jun 2009 18:36:27 +0900
Message-ID: <20090610183618T.fujita.tomonori@lab.ntt.co.jp>
References: <4A2F729A.1060101@panasas.com>
	<20090610175238P.fujita.tomonori@lab.ntt.co.jp>
	<4A2F7B0F.1030205@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50425 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbZFJJgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 05:36:35 -0400
In-Reply-To: <4A2F7B0F.1030205@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, 10 Jun 2009 12:21:19 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 06/10/2009 11:52 AM, FUJITA Tomonori wrote:
> > On Wed, 10 Jun 2009 11:45:14 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >>>
> >> The fact that ALL block drivers call it for proper service of ALL ULDS,
> >> does it not make it a rule?
> > 
> > BSG SMP code is not ULD.
> > 
> 
> BSG is certainly a ULD, Upper-Layer-Driver that can issue block commands
> through block layer and block-queue.
> 
> SMP is a block device class that has it's own LLDs.
> 
> The way I understand
> 
> |---------|      |--------------|      |-----------|
> | ULD     |----->|  block layer |----->| block LLD |
> |---------|      |--------------|      |-----------|
> 
> So I meant block ULD or block layer user code. That is what I meant
> by ULD, what do you mean?

To me, ULD means SCSI upper layer driver, which is documented.

Where can I find a document about your definition of Block ULD, block
LLD, etc?


> <snip>
> > 
> > FYI, you live in a land where very few live.
> > 
> 
> I thought I was working on the Linux-Kernel. Is there another
> place I should be?

To me, looks like there is a different place for you.

BTW, if you try to find a bio leak in the BSG SMP path, I guess that
it's worth looking at the bounce path. There might be a leak.
