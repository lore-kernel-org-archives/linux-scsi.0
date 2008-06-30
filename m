From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Should a block device enforce block atomicity?
Date: Mon, 30 Jun 2008 11:24:55 +0300
Message-ID: <48689857.1050908@panasas.com>
References: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>	 <20080630065525.GI20826@kernel.dk> <ce513bcc0806300058mbe0f15eya07fafbb9ba4a56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:28672 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbYF3I0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 04:26:23 -0400
In-Reply-To: <ce513bcc0806300058mbe0f15eya07fafbb9ba4a56@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezzi.list@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Erez Zilber wrote:
> On Mon, Jun 30, 2008 at 9:55 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Mon, Jun 30 2008, Erez Zilber wrote:
>>> Hi,
>>>
>>> I have a question about block devices and whether they are required to
>>> enforce block atomicity:
>>>
>>> I read the code of drivers/block/brd.c, and I didn't see any locking
>>> when blocks are read/written. I also looked at the block layer code
>>> that calls brd and didn't find any locking there. Does it mean that
>>> there's no block atomicity (i.e. multiple threads can write a single
>>> block at the same time)? Is there any hidden assumption here? Is this
>>> the responsibility of the application to do that (e.g. not start a
>>> WRITE request before other READ/WRITE requests to the same block were
>>> completed)?
>> The block layer doesn't give such guarentees, not for "regular" block
>> devices either. If the IO goes through the page cache then that will
>> serialize IO to a given page, but with eg O_DIRECT IO, you could have
>> the same block in flight several times. So if you are doing raw IO, the
>> application has to ensure ordering of the same block.
>>
> 
> So, do you say that people that write applications need to take care
> of I/O serialization, and block devices (and the block layer itself)
> don't need to care about this problem? I thought that standard disks
> guarantee block atomicity (i.e. they don't count on the layers above
> them to do that).
> 
> Erez

Don't forget that all IO requests are queued on the device. With a
modern HW and disk you usually have NCQ and most drives will throw
away write request to the same sector if they see a later write to
the same sector in the queue.

That said. There is nothing wrong with writing again and again to 
the same sector on disk. File/record locking is done at the FileSystem
level. An application that wants exclusive write need to open the file
that way. Other wise it could even be written from another machine not
even another thread.

What is it you are concerned with?

Boaz
