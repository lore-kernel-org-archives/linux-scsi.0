From: Ari <ari@goron.de>
Subject: Re: [2.4.25], [aic79xx-2.0.8] problems with aic79xx on 2.4 (fwd)
Date: Tue, 6 Apr 2004 21:21:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406212126.A30706@www.goron.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cne137-040.cne.de ([217.78.137.40]:62103 "EHLO www.goron.de")
	by vger.kernel.org with ESMTP id S263972AbUDFTV0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 15:21:26 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abba@cs.sunysb.edu

On Thu, Apr 01, 2004 at 06:41:47PM -0500, Abhishek Rai wrote:
> I have an Adaptec 29320A Ultra320 SCSI host bus adapter with which I
> connect to a SCSI array of 9 disks, each of which is capable of 320MBps.
> Initially, in the BIOS settings, I configure each disk to operate at
> 160MBps. aic79xx-2.0.8 driver for 2.4 works just fine on 2.4.25 with this
> setting. I am able to create a raid device on top of this 9-disk array,
> and everything works fine.
> 
> Now, I configure each disk in the BIOS settings to operate at 320MBps. I
> now start having trouble beginning with aic79xx module insertion itself.

Hi,
I've ran into similar problems with the same controller and same disks
(Maxtor Atlas 10K4 73G WLS, mine are revision DFV0 however).
After a lot of frustration including changing all related hardware,
especially the cabling, resultless googling, etc, I found the solution:
Speeding down the disks does not really help. It works better, but under
stress load (3 bonnie++ at the same time) they quickly produce lost
SCB commands, even at 80Mhz.
What fixed it for me was limiting the Tagged Queuing depth to 16 (in
kernel config). After my raid5 array worked flawlessly under a 24h
3 simultaneous bonnie++ test.
I've found some hints googling that there might be a firmware problem
related to this (which should be fixed with the DFV0 version on my
drives, but obviously is not).
Anyhow, try to reduce tagged queuing to 16, if that fixes it, it will
also confirm my findings.

Best Regards
Andy


