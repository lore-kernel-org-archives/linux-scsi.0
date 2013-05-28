From: Baruch Even <baruch@ev-en.org>
Subject: Re: SCSI error handling -- one error blocks the whole SCSI host
Date: Tue, 28 May 2013 04:32:11 +0300
Message-ID: <CAC9+an+6iLGfJ9htCnW0xoD=0M1JCObwwMPgYGtTZELEwkYC2w@mail.gmail.com>
References: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com>
 <1369608242.1904.7.camel@dabdike> <51A37019.3050604@suse.de> <1369687319.1950.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48652 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3E1Bce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 May 2013 21:32:34 -0400
Received: by mail-ea0-f170.google.com with SMTP id f15so4214536eak.15
        for <linux-scsi@vger.kernel.org>; Mon, 27 May 2013 18:32:31 -0700 (PDT)
In-Reply-To: <1369687319.1950.11.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, May 27, 2013 at 11:41 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2013-05-27 at 16:39 +0200, Hannes Reinecke wrote:
>
>> - LLDDs typically won't return a command status even for a
>>   command which has been aborted via ABORT TASK TMF.
>>   So the midlayer probably will never get notified if
>>   the command got aborted via ABORT TASK.
>
> Well, that's true, but irrelevant.  If the HBA can't inform you of the
> status of the abort, then abort is useless as a first step in the
> traditional eh as well as in this method, so you just don't do that and
> proceed to resets.
>
> There's actually a school of thought that says even if the HBA *can*
> give you all the status you need, aborts are still pointless because
> it's sending in yet another state transition to an already failed state
> machine (because the device is timing out).  Therefore, since the chance
> of recovering the state machine with an abort is so tiny, you should
> start with the lowest reset anyway because that takes the state machine
> to a known state.

Most devices I know do not really abort the command in any normal sense
anyhow. Not even when doing a reset. The disks (HDD & SSD) and also SAN
systems normally just treat an abort or a reset as a signal that no
real reply is
necessary but the command itself if it is already actively handled continues
in its path. The abort only cancels those commands that are in the queue
and if there really was a problem and the disk is engaging in error recovery
of its own you'll just have no response from it and it will seem dead (abort
may timeout).

The one thing aborts/reset help with is to clear your HBA from any pending
so that your DMA buffers will no longer be affected and you can forget the
command and do your application level recovery (RAID or lose data and panic).

It is also an important part of handling bad links but at least in SAS that is
done internally in the HBA anyway.

This view of aborts also means that reducing timeouts for commands and
TMFs is mostly useless and sometimes even a really bad idea. I prefer
to just let the device go on with its error recovery and just forget about the
command. I want to forget about the DMA so I issue an abort but anything
higher than that means a link is dead to me.

Baruch
