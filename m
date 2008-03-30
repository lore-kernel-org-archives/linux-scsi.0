From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/9][RESEND] mvsas : interrupt handling
Date: Sun, 30 Mar 2008 10:09:57 -0500
Message-ID: <1206889797.4224.20.camel@localhost.localdomain>
References: <47EB449F.20201@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34648 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbYC3PKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 11:10:01 -0400
In-Reply-To: <47EB449F.20201@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

On Thu, 2008-03-27 at 14:54 +0800, Ke Wei wrote:
> When a slot is busy, we will not free this slot until slot reset is completed.
> When unplugged the disk, we should release all command tasks with unplugged port that have been sent.
> If MVS_USE_TASKLET is defined, we can enable tasklet. Default is off.

This tasklet usage doesn't quite look right.  What a tasklet does is
defer processing until after all interrupts have completed.  It's
commonly used for aggregation, which is why scsi_done simply queues for
the block softirq (tasklet).  However, for mvsas, I don't see any
benefit to defering the work to a tasklet.

Additionally, for the non MSI case, doesn't the interrupt, which is
level triggered, fail to deassert because we haven't cleared any
registers?

James


