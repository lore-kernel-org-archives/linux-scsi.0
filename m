From: Otto Meta <otto.kernel.02e4af24@sister-shadow.de>
Subject: Re: [PATCH] [SCSI] sr: Fix multi-drive performance by using per-device
 mutexes
Date: Sat, 05 Jan 2013 00:05:13 +0100
Message-ID: <50E76029.3020204@sister-shadow.de>
References: <50E2F09A.6030606@sister-shadow.de>	<50E61021.20709@sister-shadow.de> <20130104205027.062c808a@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.planet-school.de ([194.116.187.5]:48619 "EHLO
	turboconrad.planet-school.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201Ab3ADXFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2013 18:05:19 -0500
In-Reply-To: <20130104205027.062c808a@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Wakko Warner <wakko@animx.eu.org>

On 2013-01-04 Stefan Richter wrote:
> As yo may have seen in the mailinglist archive, when Wakko and I tested
> with sr_mutex removed without any replacement, we were not able to trigger
> any race condition.  However, we certainly did not attempt this very
> particular test (two drives on the same PATA cable, one locked and one
> unlocked, and "eject" called on both of them at the same time).  I wonder
> if this is a PATA idiosyncrasy.

Reading from two devices connected to different PATA cables or controllers
via ioctl is working quite fine with the patch, so that seems to be in line
with your and Wakko's findings.

Running the eject test on the same device combination seems to be mostly
fine. I'm saying "mostly" because sometimes drives stay locked when I expect
them to be unlocked, but I haven't been able to reproduce that reliably.
A few times drives even stayed locked with the tray ejected(!), i.e. I
couldn't close the drive via its eject button and had to run  eject -t.
As dev.cdrom.lock=0 seems to be ignored even without the patch, I'm not sure
whether the locking issue is caused or just amplified by the patch.

Another note regarding the eject test with two devices connected to the same
PATA cable: If both drives are unlocked, they eject fine, but sequentially.
Something seems to be trying to prevent interference between the two drives,
but it's not working properly once unlocking is involved.

-- 
Otto Meta
