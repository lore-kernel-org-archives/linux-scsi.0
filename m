From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 13:51:28 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <41472FA0.2090108@rtr.ca>
References: <41471163.10709@rtr.ca> <414723B0.1090600@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <414723B0.1090600@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

 >In particular, releasing the lock and sleeping would be very wrong
 >in the ->queuecommand and error handling paths
 >(alas...  I would love to sleep in the fine-grained eh hooks)

Mmm.. definitely no sleeps in queuecommand(), but sleeping seems
necessary in host_reset_handler() -- the alternative is to just
busywait inline.. which would really not be good.

Isn't the protocol for the eh host_reset_handler() basically
just "do the reset, and return whether it worked or not?".
If so, the driver really has to hang around until the reset
completes so that correct status can be returned.  This generally
takes a couple of milliseconds in practice (measured it).

Is there a better way to do that?

I really would prefer never to have to reset the drives,
but when they have a queuing error, many of them simply
won't talk to us again without a reset.  The driver avoids
the reset as much as it can for other situations, though.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
