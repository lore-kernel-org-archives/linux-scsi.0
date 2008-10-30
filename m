From: Tejun Heo <tj@kernel.org>
Subject: Re: Timeout regression introduced by	242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Date: Thu, 30 Oct 2008 09:31:59 +0900
Message-ID: <4909007F.5070602@kernel.org>
References: <49043C7C.8050207@kernel.org> <1225034105.3958.4.camel@localhost.localdomain> <49051EA4.3040403@kernel.org> <20081027213006.GB17946@linux.vnet.ibm.com> <490666D6.8090603@kernel.org> <20081029132654.GE31673@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:55755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYJ3AcW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 20:32:22 -0400
In-Reply-To: <20081029132654.GE31673@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

Jens Axboe wrote:
> On Tue, Oct 28 2008, Tejun Heo wrote:
>> Mike Anderson wrote:
>>> Tejun Heo <tj@kernel.org> wrote:
>>>> James Bottomley wrote:
>>>>> On Sun, 2008-10-26 at 18:46 +0900, Tejun Heo wrote:
>>>>>> Hello, Jens.
>>>>>>
>>>>>> Commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9 introduces a strange
>>>>>> regression for libata.  The second timeout gives puts different
>>>>>> pointer from the issued command onto eh_cmd_q breaking libata EH
>>>>>> command matching which triggers WARN_ON() in ata_eh_finish() and hangs
>>>>>> command processing or causes oops later depending on circumstances.
>>>>>>
>>>>>> Here are logs with induced timeouts (patch attached).  In commit
>>>>>> 242f9dcb8, the XXX messages for the second timeout shows different
>>>>>> scsi_cmd pointers for eh_cmd_q and qc->scmd which is initialized by
>>>>>> ata_scsi_qc_new() during command translation.
>>>>> I can't see a way we could be getting a different command passed in from
>>>>> the actual one, since the only way to lose the command from the request
>>>>> is to go through the command completion routines which free it (and end
>>>>> the request).
>>>> I have no idea either.  It's something in the timeout logic because on
>>>> the issue path the scmd pointer is identical but on tiemout pointer
>>>> for another scmd is queued on eh_cmd_q, which doesn't make much sense.
>>>>
>>> I was trying to recreate this error using ata_ram wth v2.6.28-rc2.
>>> Currently I am not able to see this error on timeout recovery using this
>>> setup. Does IO load (or other factors) effect the error being seen?
>> Not at all.  That's the only write command I issued.
> 
> It's all extremely puzzling. Any chance I could talk you into stuffing
> some debug printks in there to see what the hell is going on?

I got it pinned down.  I'll post the fix after some more testing but it
looks like we'll need more extensive change to get it clean.  The
problem is when the command is passed to driver - at elv_next_request()
or blkdev_dequeue_request().  SCSI thinks it's blkdev_dequeue_request(),
block layer thinks it's elv_next_request() for some purposes while
blkdev_dequeue_request() for others.  I really think we should change
the interface to something like blk_peek_request() and
blk_fetch_request() and don't allow finishing a request which are not
fetched.

Thanks.

-- 
tejun
