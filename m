From: Tejun Heo <tj@kernel.org>
Subject: Re: Timeout regression introduced by	242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Date: Mon, 27 Oct 2008 10:51:32 +0900
Message-ID: <49051EA4.3040403@kernel.org>
References: <49043C7C.8050207@kernel.org> <1225034105.3958.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYJ0Bvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Oct 2008 21:51:45 -0400
In-Reply-To: <1225034105.3958.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2008-10-26 at 18:46 +0900, Tejun Heo wrote:
>> Hello, Jens.
>>
>> Commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9 introduces a strange
>> regression for libata.  The second timeout gives puts different
>> pointer from the issued command onto eh_cmd_q breaking libata EH
>> command matching which triggers WARN_ON() in ata_eh_finish() and hangs
>> command processing or causes oops later depending on circumstances.
>>
>> Here are logs with induced timeouts (patch attached).  In commit
>> 242f9dcb8, the XXX messages for the second timeout shows different
>> scsi_cmd pointers for eh_cmd_q and qc->scmd which is initialized by
>> ata_scsi_qc_new() during command translation.
> 
> I can't see a way we could be getting a different command passed in from
> the actual one, since the only way to lose the command from the request
> is to go through the command completion routines which free it (and end
> the request).

I have no idea either.  It's something in the timeout logic because on
the issue path the scmd pointer is identical but on tiemout pointer
for another scmd is queued on eh_cmd_q, which doesn't make much sense.

> However, since the WARN_ON is specifically comparing the command with
> the one found by the active tag, could this actually be a problem caused
> by block tags?  I note that libata still uses its own array of
> outstanding tags (ap->qcmd[tag]) instead of finding them using
> blk_queue_find_tag() (or scsi_find_tag()).

Nope, the tested commits are before the block queue tag transition and
I tested two consecutive commits.  242f9dcb^ is okay.  242f9dcb is
not.

Thanks.

-- 
tejun
