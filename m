From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Sun, 7 Jun 2009 10:22:00 +0200
Message-ID: <64bb37e0906070122t652051d7oaa1e7ec70e4c05ea@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com> <20090607081305.GA12497@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59000 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZFGIV7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2009 04:21:59 -0400
In-Reply-To: <20090607081305.GA12497@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jun 7, 2009 at 10:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
>> But its up to Linus/Ingo to decide if it can be accepted at this
>> very late point in the cycle. Since dma-debug is new with 2.6.30
>> it will at least not introduce any regression. [...]
>
> I think it's too late for v2.6.30 to do any of the changes - and the
> DMA debug facility is off by default.
>
> Also, i think such DMA patterns, while 'allowed' can be quite
> dangerous as its such a rare usage combination really. AIO and DIO
> are crazy to begin with, mixing AIO and DIO for the same buffer is
> madness square two. (It can result in 3 agents for the same memory
> address: CPU, dma1 and dma2. How many interesting chipset erratums
> could there be related to such scenarios?)

I think in my case the cause is somewhat simpler: RAID1
My root filesystem is on a RAID1 that consists of two disks, both
connected to the sata_sil24 controller.
So it is only natural for the md driver to issue two dma read requests
for the same address: one for each drive.

Torsten
