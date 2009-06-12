From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 12 Jun 2009 16:51:01 +0200
Message-ID: <64bb37e0906120751u14cac347hfa2356372e1e0a6a@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
	 <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
	 <20090611081032.GN5139@amd.com>
	 <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
	 <20090612141346.GY5139@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33004 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZFLOvA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 10:51:00 -0400
In-Reply-To: <20090612141346.GY5139@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 12, 2009 at 4:13 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
>> DMA-API: device driver tries to free DM
>> A memory it has not allocated [device address=0x000000011e4c3000]
>> [size=4096 bytes]
>
> Hmm, looking again over the code I've seen that the ref
> dma_debug_entries are not alway filled with all necessary information
> for best-fit. Can you please try if you still get false warnings when
> you apply the two patches attached instead of the one I sent yesterday?

Hmm... There isn't a get_nr_mapped_entries() in 2.6.30.
Are these patches again the current linus tree?

For unfilled information I wanted to complain that for non-sg mapping
sg_call_ents never gets filled. But as dma_entry_alloc() does a
memset() to clean the entrys it should not matter.
And what about dma_debug_entry.paddr? Should this also be compared?

Torsten
