From: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Hack to fix not working spindown over Firewire
Date: Wed, 7 May 2008 20:00:42 +0200
Message-ID: <20080507180042.GA32629@dose.home.local>
References: <20080429232606.GA14261@dose.home.local> <481874BD.5010807@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:43198 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569AbYEGSAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 14:00:00 -0400
Content-Disposition: inline
In-Reply-To: <481874BD.5010807@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Apr 30, 2008 at 15:31:41 +0200, Stefan Richter wrote:

[...]

> Tino, to find the firmware marker you can for example:
> # echo 0x1000 > /sys/module/sbp2/parameters/workarounds
> Then plug in the disk and
> # dmesg | grep sbp2

I used firewire_sbp2. I hope that's ok.

firewire_sbp2: Please notify linux1394-devel@lists.sourceforge.net if
you need the workarounds parameter for fw1.0
firewire_sbp2: Workarounds for fw1.0: 0x100 (firmware_revision
0x012804, model_id 0x000001)
firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)

[...]

> uninteresting for our purposes.  According to the description of Active,
> Idle, Standby, Sleep in RBC, we do most certainly want code 1 on resume,
> and rather 3 than 2 on suspend. 5 instead of 3 or 2 might even be better

FYI, sg_start --pc=3 also spins down the drive here.

> from the POV of energy consumption but a "device reset may be required
> before access to the device is allowed" which I'd rather not deal with.
> 
> Tino, does the scsi stack log the device as "Direct-Access-RBC" after it
> was plugged in?

Yes:

scsi 7:0:0:0: Direct-Access-RBC WDC WD32 00JB-00KFA0           PQ: 0 ANSI: 4

> 
> Note to self:  Test sg_start --pc={1,3} with all the various SBP-2
> bridges I have access to...

Thanks for your effort.

Regards,
Tino
