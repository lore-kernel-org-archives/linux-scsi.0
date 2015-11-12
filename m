From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Thu, 12 Nov 2015 14:58:20 -0600
Message-ID: <5644FD6C.9070805@cs.wisc.edu>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com> <56447FF7.40600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50120 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbbKLU6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Nov 2015 15:58:35 -0500
In-Reply-To: <56447FF7.40600@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, mchristi@redhat.com, linux-scsi@vger.kernel.org
Cc: Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, shlomopongratz@gmail.com

On 11/12/2015 06:03 AM, Sagi Grimberg wrote:
> 
>> The bug is caused by this patch:
>>
>> 659743b02c411075b26601725947b21df0bb29c8
>>
>> which allowed the task lists to be manipulated under different locks
>> in the xmit and completion path.
>>
>> To fix the oops this patch just reverts that patch. It also reverts
>> these 2 patches for regressions that were also a result of that patch:
> 
> Whoa now Mike, this is a major change. Can we take a step back and think
> about this for a second?

The issue has been on the open-iscsi list for a week! You are on the
list still right? Or is even ccd on the thread.

> 
> My understanding is that the kfifo circular buffer design allows a
> writer (e.g. the producer) and a reader (e.g. the consumer) to avoid
> extra locking when accessing the kfifo buffer.
> 

For the next feature window I am working on patch that makes the api
easier to use (the cleanup_task locking is bad as can be seen from the
bnx2i regression the patch also caused) and also uses kfifos for the
fast path.


> From include/linux/kfifo.h:
> /*
>  * Note about locking : There is no locking required until only * one
> reader
>  * and one writer is using the fifo and no kfifo_reset() will be * called
>  *  kfifo_reset_out() can be safely used, until it will be only called
>  * in the reader thread.
>  *  For multiple writer and one reader there is only a need to lock the
> writer.
>  * And vice versa for only one writer and multiple reader there is only
> a need
>  * to lock the reader.
>  */
> 
> The patch by Shlomo, implements the locking policy documented above:
> - multiple readers: multiple threads entering queuecommand reading the
>   kfifo (kfifo_out) are mutually excluded by the frwd_lock.
> - multiple writers: completion contexts writing to the kfifo (kfifo_in)
>   are mutually excluded by the back_lock.
> 
> Can you provide a more detailed analysis of why is this list corruption
> triggered? What scenario was not honoring the locking policy?

Basic locking around a linked list bug. iscsi_queuecommand adds it under
the frwd lock and iscsi_complete_task was taking it off the back_lock.


> This code has been running reliably in our labs for a long time now
> (both iser and tcp).

The patch has caused multiple regressions, did not even compile when
sent to me, and was poorly reviewed and I have not heard from you guys
in a week. Given the issues the patch has had and the current time, I do
not feel comfortable with it anymore. I want to re-review it and fix it
up when there is more time.

