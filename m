From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 04/22] libata-sff: clear IRQ from ata_sff_error_handler()
 only when necessary
Date: Tue, 28 Oct 2008 13:28:56 +0900
Message-ID: <49069508.9010504@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <1224580680-13698-5-git-send-email-tj@kernel.org> <490690CC.50500@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYJ1E3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2008 00:29:08 -0400
In-Reply-To: <490690CC.50500@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Clearing IRQ from ata_sff_error_handler() is necessary only when the
>> port is gonna be thawed before performing EH actions and some
>> controllers don't like being accessed after certain fail modes until
>> they're reset.  Clear IRQ iff the port is being thawed.  Also, remove
>> unnecessary ata_sff_sync() while at it.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>
> I'll allow it, but, this description is not strictly true.  This
> clearing was done in the error handler unconditionally in an attempt to
> catch outstanding conditions.  The logic being that it is safer (FSVO
> safe) to clear on error just in case interrupts were screaming.

The avoid-IRQ-stream-by-clearing-IRQ doesn't work at all.

1. If the port is already frozen && IRQ is screaming && EH is not gonna
thaw until reset is complete, it doesn't matter.

2. If IRQ is screaming && the port is not frozen or freezing doesn't
work, the IRQ will get killed way before it reaches EH.

So, clearing IRQ there doesn't make any difference w.r.t. screaming IRQ,
about which we really need to do something.  It's one of the most common
bug reports I get these days.

But, yeah, it's probably better to include the above in the commit
message.  I'll update the patch.

Thanks.

-- 
tejun
