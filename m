From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Thu, 14 Jun 2007 21:30:41 +0900
Message-ID: <467134F1.1010009@gmail.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com> <20070614115600.GF6149@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:31765 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbXFNMar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 08:30:47 -0400
Received: by wa-out-1112.google.com with SMTP id v27so651044wah
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 05:30:46 -0700 (PDT)
In-Reply-To: <20070614115600.GF6149@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>

Jens Axboe wrote:
>> 1. It didn't have proper interface with userland.  This was mainly
>> because of missing ATA sysfs nodes.  I'm not sure whether adding this to
>> scsi node is a good idea.
>>
>> 2. It was focused on SATA link PS and couldn't cover the Lenovo case.
>>
>> I think we need something at the block layer.
> 
> I think the hardware method is preferable, actually. Doing this in the
> block layer would mean keeping track of idle time, and that quickly
> turns into a lot of timer management. Not exactly free, in terms of CPU
> usage.

Yeah, software implementation certainly has complexity overhead.

> I've yet to do some power measurements with this ahci patch, I just
> noticed that with min_power performance drops from ~55mb/sec to
> ~15mb/sec sequential on my drive. That's pretty drastic :-)

That's another thing I don't like about ALPE/ASP.  According to the
spec, there is no idle timer whatsoever.  The controller is supposed to
drive the link into PS mode whenever FIS is not in flight, so the link
goes in and out of PS state repeatedly when commands are issued
back-to-back.  Getting out of PS state takes a bit of time and slows
down things.

-- 
tejun
