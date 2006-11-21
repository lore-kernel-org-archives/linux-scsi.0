From: Douglas Gilbert <dougg@torque.net>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Tue, 21 Nov 2006 17:06:46 -0500
Message-ID: <45637876.2050206@torque.net>
References: <454FAD72.6040103@torque.net> <20061108094705M.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:17131 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1031233AbWKUWGw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 17:06:52 -0500
In-Reply-To: <20061108094705M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: Douglas Gilbert <dougg@torque.net>
> Subject: RFC: SCSI Generic version 4 interface
> Date: Mon, 06 Nov 2006 16:47:30 -0500
> 
>>                 SCSI Generic version 4 interface structure
>>                 ==========================================
>>                                              Version 1.1
>>
>> Goals:
> 
> (snip)
> 
>>   - same structure can be used for a synchronous (e.g. interruptible
>>     ioctl) or asynchronous (e.g. ioctl()/read() ) pass through.
> 
> Can you provide details on "asynchronous" part?

I was trying to keep away from the implementation details
but various people have pushed for more details ...


Well as you are aware, the sg driver uses a write(),
poll_or_signal,read() sequence to do asynchronous IO
in version 3 (and roughly the same model in version 2).

That write() has always made me uneasy and it is accident
prone. It could easily be replaced by and SG_IO ioctl
with a 'flag | async_request'. The question is how far
that gets "down the stack" before it returns to the
user. Some "tag" is required to be sent back to the
caller of an async request to:
  - enable the caller to identify the response
  - enable the caller to issue task management
    functions: abort task or query task

That is the purpose of the 'generated_tag' [o] field. I
commented that field as transport layer generated (i.e.
by the LLD) but it doesn't have to be, as long as it is
mappable to one.

The asynchronous notification that the command is completed
can be the current flavour of the month. The sg driver
uses file descriptor based techniques. They seem to work
in practice but the kernel folks don't seem to like them
and they could be dropped or mishandled by the user space
application.

Having a binary flag associated with the asynchronous notification
for worked/didn't could be useful. Still a driver (e.g. sg)
can't clear down its state information for the command in question
until it receives some active acknowledgment from the user
space program. The sg driver uses read() for this but this
could just as easily be the SG_IO ioctl with a
'flag | async_complete'. The version 3 sg driver can filter
those completions with its pack_id field (blocking or
non-blocking) or take the first available. The sg v4 interface
could filter via its request_tag (and a flag setting).

The sg driver has to cope with various non-completion
situations:
  - associated user space file descriptor closed by
    the time the async notification received: easy, throw
    away response and associated state
  - rmmod sg
  - app dies after receiving async notification: driver gets
    release() on that fd and throws away pending completion
    state
  - app falls silent: that leads to a stuck command in the
    sg driver or sg could be told to run its own auto
    completion timer

The async completion phase (i.e. the read() in sg v3) has
very little data to move as the xfer data pointers and sense
data pointer have been set up in the async request. That
only leaves: scsi_status, transport errors, resid and some
accounting (e.g. command duration). Its most important
function is being an active acknowledgment that the app
received the async command complete notification.


As for data buffer control, I would like to look at tgt's ring buffers.

> The scsi target code needs sg for:
> 
> - SAN gateway (like iSCSI to FC)

on the initiator side, I assume.

> - SCSI device support in Xen (corresponds to raw device mapping in
> VMware); enables domU to use SCSI devices. domU sends SCSI commands
> via the virtual HBA driver to dom0 and then dom0 uses sg to perform
> them.
> 
> The scsi target code uses the single user-space daemon so needs an
> asynchronous interface, i.e. sends requests and receives the
> completions asynchronously.


Doug Gilbert

