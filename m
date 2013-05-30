From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] New FC timeout handler
Date: Thu, 30 May 2013 14:01:36 +0200
Message-ID: <51A73FA0.3070605@suse.de>
References: <1369389050-118628-1-git-send-email-hare@suse.de> <51A70FD3.90908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459Ab3E3LBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 May 2013 07:01:42 -0400
In-Reply-To: <51A70FD3.90908@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@infradead.org>

On 05/30/2013 10:37 AM, Ren Mingxin wrote:
> Hi, Hannes:
>
> On 05/24/2013 05:50 PM, Hannes Reinecke wrote:
>> this is the first step towards a new FC error handler.
>> This patch implements a new FC command timeout handler
>> which will be sending command aborts inline without
>> engaging SCSI EH.
>>
>> In addition the commands will be returned directly
>> if the command abort succeeded, cutting down recovery
>> times dramatically.
>
> To the commands which can be aborted successfully, I guess your
> patchset has solved the problem "the error handler can't even be
> called until host_failed == host_busy", because it needn't to
> wait for the scheduling of EH threads(without engaging SCSI EH
> as you said) now, right?
>
Yes.

>> For any other return code from 'eh_abort_handler' the command
>> will be pushed onto the existing SCSI EH handler, or aborted
>> with an error if that fails.
>
> To the commands which can NOT be aborted successfully, there is
> not any improvements for the SCSI EH will be invoked as usual.

Correct. But I'm working on a patchset to improve that.

> But should we consider the repetitive/time-consuming issue for
> the commands will be tried to abort again in the SCSI EH handler?
>
I doubt this is an issue. With this patchset even aborted commands
will be retried, with the usual retry count.
And for an successful abort we don't need to invoke the error handler
as target itself is considered alive.
If the abort itself failed the command will be pushed onto the SCSI EH 
handler, instructing the EH handler _not_ to abort the command.

Cheers,

Hannes
