From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 07 Oct 2003 14:46:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065559619.2875.63.camel@patehci2>
References: <1064865746.4262.63.camel@patehci2>
	 <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2>
	 <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2>
	 <1065484607.2899.7.camel@patehci2>  <20031007053858.GL972@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:23739 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262860AbTJGUrJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 16:47:09 -0400
In-Reply-To: <20031007053858.GL972@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

> From: Jens Axboe ...

Thanks again for your immediate & careful review.

> so it works with ide-cd as well

I do have both usb & atapi sample drives to test, I haven't yet tried
atapi.

> Please add ...
> to cdrom.c instead ... GPCMD_GET_CONFIGURATION

Happily will do.  I'll continue to reply as I progress or not.

Before now, I did not know I could find any one place in the kernel
source to tweak CDC decisions.  To my confused newbie eye, ide-cd.c and
sr.c appeared coded independently to fetch mode page x2A Capabilities
and neglect op x46 Get Configuration in slightly different ways.  I
erroneously had planned to develop an ide-cd.c patch after the sr.c
patch.

> Also, make DVD-RAM drives set CDC_MMC_RW ...

Will do.

> ...

Already I have one reaction to share ...

I'm now vague on how we want /proc/sys/dev/cdrom/info to change?

I see:

In -test6 for dvd_ram we have:

Can write CD-R:         0
Can write CD-RW:        0
Can read DVD:           0
Can write DVD-R:        0
Can write DVD-RAM:      1

I ask:

What do we want the new CDC_MMC_RW line to look like?

Should our new line be a CDC_MMC_RW &~ CDC_DVD_RAM line?  That would
give us the same appearance as the last patch I posted i.e. commonly
different devices would provoke only the two exclusive combinations: 

Can write DVD-RAM:      1
Can write other MMC-RW: 0

Can write DVD-RAM:      0
Can write other MMC-RW: 1

Or should our new line look very different, and appear explicitly set
for any CDC_MMC_RW, perhaps:

Tolerates random write: 1

Or do we prefer some other alternative?

Pat LaVarre


