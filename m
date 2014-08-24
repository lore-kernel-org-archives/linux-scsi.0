From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Sun, 24 Aug 2014 10:46:57 +0200
Message-ID: <53F9A681.7080209@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <1408827920.2181.8.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaHXIrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Aug 2014 04:47:02 -0400
In-Reply-To: <1408827920.2181.8.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Hi,

On 08/23/2014 11:05 PM, James Bottomley wrote:
> On Sat, 2014-08-23 at 16:52 +0200, Hans de Goede wrote:
>> Hi All,
>>
>> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
>> I'm getting quite a few bug reports about issues with UAS drives.
>>
>> One if the issues is that there might be a number of bugs in the
>> abort handling path, as I don't think that was ever tested properly.
> 
> Can you report the actual bugs and we'll try to take a look at them?

To be clear I believe there may be a bug or 2 in the uas.c abort code
paths, not in the scsi core or sd drivers.

But getting more eyes on these definitely makes sense. Should I CC
linux-scsi@vger on issues like this, or should I get the users
to file a bug at bugzilla.kernel.org (my own preference would be to
do the latter, as that keeps all info in a single place).

> 
>> So I'm wondering is there a way to test the abort path with a real
>> drive? E.G. submit some command which is known to take a significant
>> amount of time, and then abort it right after submitting ?
> 
> This scenario can't really happen under the current eh, if by abort
> path, you mean the path where we abort the command by sending an abort
> TMF in error handling.

Yes that is the one I mean, some users of uas are seeing the 30 second
timeout kick in, and then most of the times the uas abort code does not
seem to actually abort, and a device reset is needed to resolve things.

This could mean 1 of 2 things:

1) the abort code in uas.c is no good
2) the device has actually locked up / crashed

Sometimes though the uas abort code does not just timeout on the abort,
and instead seems to go down in flames (kernel page fault), which seems
to indicate that even if 2 is the case here, that we still have an issue
in the uas abort code.

> The reason is that the command must timeout
> before we abort.  If you mean the path where the driver says it aborted
> the command and we have to retry, you can test that by returning
> DID_ABORT immediately in the queuecommand routine ... I use this to test
> some of the EH properties.  What you want to do is to modify the
> queuecommand to return abort on a small number of commands (say around
> 5%) and then try normal operation.  This is what I used to test our
> submission and resubmission routines, but I haven't run it for a year or
> so.
> 
> The final suggestion is that you need to make sure this patch is in
> their environment:
> 
> commit c69e6f812bab0d5442b40e2f1bfbca48d40bc50b
> Author: James Bottomley <JBottomley@Parallels.com>
> Date:   Thu Apr 10 13:36:11 2014 -0700
> 
>     [SCSI] More USB deadlock fixes
> 
> The reason this may make a difference is that USB appears fragile to
> issuing commands before you complete a reset.

uas is only enabled in 3.15 and newer so that patch should be present.

Regards,

Hans

