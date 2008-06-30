From: "Erez Zilber" <erezzi.list@gmail.com>
Subject: Re: Should a block device enforce block atomicity?
Date: Mon, 30 Jun 2008 10:58:16 +0300
Message-ID: <ce513bcc0806300058mbe0f15eya07fafbb9ba4a56@mail.gmail.com>
References: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>
	 <20080630065525.GI20826@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:4433 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbYF3H6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 03:58:18 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1435512wfd.4
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2008 00:58:16 -0700 (PDT)
In-Reply-To: <20080630065525.GI20826@kernel.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 9:55 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Jun 30 2008, Erez Zilber wrote:
>> Hi,
>>
>> I have a question about block devices and whether they are required to
>> enforce block atomicity:
>>
>> I read the code of drivers/block/brd.c, and I didn't see any locking
>> when blocks are read/written. I also looked at the block layer code
>> that calls brd and didn't find any locking there. Does it mean that
>> there's no block atomicity (i.e. multiple threads can write a single
>> block at the same time)? Is there any hidden assumption here? Is this
>> the responsibility of the application to do that (e.g. not start a
>> WRITE request before other READ/WRITE requests to the same block were
>> completed)?
>
> The block layer doesn't give such guarentees, not for "regular" block
> devices either. If the IO goes through the page cache then that will
> serialize IO to a given page, but with eg O_DIRECT IO, you could have
> the same block in flight several times. So if you are doing raw IO, the
> application has to ensure ordering of the same block.
>

So, do you say that people that write applications need to take care
of I/O serialization, and block devices (and the block layer itself)
don't need to care about this problem? I thought that standard disks
guarantee block atomicity (i.e. they don't count on the layers above
them to do that).

Erez
