From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: AIC7902 lockups
Date: Wed, 13 Aug 2003 14:25:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3287852704.1060806327@aslan.btc.adaptec.com>
References: <20030811143610.A19365@laokoon.bug.net> <2429712704.1060622870@aslan.btc.adaptec.com> <20030811204139.A26663@laokoon.bug.net> <3244592704.1060799839@aslan.btc.adaptec.com> <20030813213915.A20993@laokoon.bug.net>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:58780 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S275489AbTHMUXr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 16:23:47 -0400
In-Reply-To: <20030813213915.A20993@laokoon.bug.net>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>, linux-scsi@vger.kernel.org

>> The logs are still not complete.  As best I can tell, the controller
>> is seeing CRC errors when talking to the Fujitsu drives, but these
>> drives are hanging up the bus instead of responding to our ATN condition.
>> I believe that these drives have newer firmware available that might
>> aid in CRC error recovery, but you should also double check your
>> cable, termination, etc.
>
> I've put another syslog file on the web. IMHO it shows all the errors
> with the scsi system.

This confirms that it is a CRC error that causes the wedge.  You should
contact Fujitsu for a firmware update.

> I cannot imagine a cabling problem, because the drives are in a hot
> swap backplane and i changed the places of the drives (but having
> the IBM drive every time as the first drive).

Not all backplanes are rated for U320 operation.  Does the chassis
claim to be U320 capable?

> Or is it possible to have a bad cable from the board to the backplane,
> beeing ok for the U160 IBM drive but not for a U360 drive?

Yes.

> Do You think, it could help to set the controller maximum to U160 on
> the expected SCSI-IDs for the fujitsu drives?

You may have to run without packetized protocol in order for them
to function correctly.  This is different than just running at U160
speeds since U320 drives can operate in packetized mode at speeds
lower than U320.

--
Justin

