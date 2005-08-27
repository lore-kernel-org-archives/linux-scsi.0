From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sat, 27 Aug 2005 09:11:19 +0200
Message-ID: <43101217.5020307@s5r6.in-berlin.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>	 <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com>	 <430E1CB1.1050108@s5r6.in-berlin.de> <430E24AB.2060002@pobox.com>	 <430F46AA.2050305@adaptec.com> <1125076960.5079.61.camel@mulgrave> <430F5C8F.3030708@adaptec.com> <430F63EA.7020400@pobox.com> <430F6F89.8040503@adaptec.com> <430FC452.70604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:8374 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030325AbVH0HLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Aug 2005 03:11:43 -0400
In-Reply-To: <430FC452.70604@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <jejb@steeleye.com>

Jeff Garzik wrote:
> Luben Tuikov wrote:
>> I never contended that userspace should be moved away from HCIL.
> 
> Then, by implication, SAS and FC must continue to maintain HCIL<->device 
> maps.

Yes, but not in the SAS/ FC/ iSCSI/ USB/ SBP-2/... low-level. HCIL does 
not exist there. HCIL is only a bonus for the interface to userspace. 
Therefore HCIL should be sticked to those devices by the core, somewhere 
close to the surface to userspace. The low-level should never care that 
arbitrary HCIL tuples should be added for some applications in 
userspace. Moreover...

>> What I contend is that _internally_ SCSI Core start moving
>> away from HCIL and towards SAM.

...the whole notion that low level provides "hosts", "channels" etc. is 
often wrong. usb_storage and sbp2 always had to resort to a one target = 
one "host" implementation for several reasons. But there is no "host", 
there is only a bunch of targets.

[...]
> You will never be able to eliminate transport-specific code.  That's the 
> whole point of transport classes:  encapsulate common transport code. 
> Call it a transport library, rather than a class, if "class" gives 
> people the shivers.
> 
> Example:  I have access to SAS+SATA host controllers from Adaptec and 
> Company X.  Both are largely software-based, directly controlling the 
> PHY ports and manually performing all SAS+SATA discovery.

Yes. And there would be transport classes which do not control hardware 
at all but rather push a high-level protocol (iSCSI, USB mass storage, 
SBP-2...) over another whole infrastructure which they share with many 
unrelated protocols. These SCSI transports are separated from hardware 
by several more layers of abstraction, at least two of those layers 
being in-kernel programming interfaces.
-- 
Stefan Richter
-=====-=-=-= =--- ==-==
http://arcgraph.de/sr/
