From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Tue, 12 Oct 2004 13:14:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416C10D9.9090306@rtr.ca>
References: <4165A85D.7080704@rtr.ca> <4165AB1B.8000204@pobox.com> <4165ACF8.8060208@rtr.ca> <20041007221537.A17712@infradead.org> <1097241583.2412.15.camel@mulgrave> <4166AF2F.6070904@rtr.ca> <1097249266.1678.40.camel@mulgrave> <4166B48E.3020006@rtr.ca> <1097250465.2412.49.camel@mulgrave> <416C0D55.1020603@rtr.ca> <20041012170333.GA9274@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:30403 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S266357AbUJLRPv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 13:15:51 -0400
In-Reply-To: <20041012170333.GA9274@havoc.gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
>
>>Yes.  The workqueue thread will invoke the mid-layer function,
>>which will do a queuecommand, which will return to the mid-layer,
>>which will then SLEEP waiting for the command to complete,
>>which will sleep that workqueue thread.
>>
>>As part of the interrupt processing to complete the command in the LLD,
>>it is possible that schedule_work may be necessary, requiring that
>>a workqueue thread be run.  If this means the same thread that is
>>already sleeping courtesy of the mid-layer, then we could have a problem.
>
> The only schedule_work() call in the SCSI common code is for domain
> validation.

This particulare schedule_work() would be invoked from
the interrupt handler in the LLD -- part of the qstor driver.

Is there a single thread (per CPU) for doing work from schedule_work(),
or are there multiple such threads created on demand?

If there's just a single thread, then this scenario (described above)
could indeed deadlock, in which case qstor cannot use schedule_work()
to perform notification of drive hot insert/removal events.

What do you think, Jeff?
--
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
