From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: device_suspend() levels [was Re: [patch] ACPI work on aic7xxx]
Date: Mon, 26 Jul 2004 10:02:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41050EEA.5040107@optonline.net>
References: <40FD38A0.3000603@optonline.net> <20040720155928.GC10921@atrey.karlin.mff.cuni.cz> <40FD4CFA.6070603@optonline.net> <20040720174611.GI10921@atrey.karlin.mff.cuni.cz> <40FD6002.4070206@optonline.net> <1090347939.1993.7.camel@gaston> <40FD65C2.7060408@optonline.net> <1090350609.2003.9.camel@gaston> <40FD82B1.8030704@optonline.net> <1090356079.1993.12.camel@gaston> <40FD85A3.2060502@optonline.net> <1090357324.1993.15.camel@gaston> <410280E9.5040001@optonline.net> <1090684826.1963.6.camel@gaston> <41029215.1030406@optonline.net> <1090694118.1971.13.camel@gaston> <4102FC9D.1060100@optonline.net> <1090793440.1987.2.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegasus.allegientsystems.com ([208.251.178.236]:28179 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S265418AbUGZOBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 10:01:41 -0400
In-Reply-To: <1090793440.1987.2.camel@gaston>
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-scsi@vger.kernel.org, Pavel Machek <pavel@ucw.cz>

Benjamin Herrenschmidt wrote:
> On Sat, 2004-07-24 at 20:19, Nathan Bryant wrote:
> 
>>Benjamin Herrenschmidt wrote:
>>
>>
>>>That's different, because the disks are actually registered as
>>>"struct device" childs of the bus, and thus get proper suspend/resume
>>>callbacks.
>>
>>Ok, Seems like we rely on the BIOS a lot, here.
> 
> 
> How so ? not at all !

For suspend/resume and also initialization on bootup. We're not saving 
the chip state for PIIX so I assume we're hoping that ACPI does it for us

> We need to issue the stuff from the low level driver (like aix7xxx) or
> the disk, that is sd, but we should make sure sg etc... also properly
> call the stuff, actually, look at IDE, I defined the special power
> request to act as a state machine once down the queue so the ide layer
> acts differently for disks, cdroms, etc... by sending appropriate
> commands like standby for disks.

There's another one - synchronize cache or disable write back cache on 
the drive....

