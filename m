From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: aic7xxx or disk weirdness
Date: Thu, 09 Dec 2004 14:23:32 +0300
Message-ID: <41B835B4.8030202@tls.msk.ru>
References: <20041209030609.GA762@cm.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:29537 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S261509AbULILXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 06:23:34 -0500
In-Reply-To: <20041209030609.GA762@cm.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: linux-scsi@vger.kernel.org

Shane wrote:
> Hello list,
> 
> A server I administer crashed today with some nasty logs
> being left behind from the SCSI subsystem.  I restarted the
> system and it came up fine with all disks checking out ok
> as far as smart extended tests and read tests are
> concerned.  However, I am not sure how to be certain the
> disk is actually ok before re-adding it to the raid array
> so any pointers would be appreciated.
> 
> System info
> 
> Dual p4 Xeon 2.6ghz
> 2gb ECC RDRAM installed
> 4x Seagate 15k rpm hard drives in a software raid5
> configuration
> Small swap partitions are located on each drive.  (I think
> that was a mistake in this case)
> Kernel 2.4.27-debian smp
> 
> 14:54:35 continuum kernel: SCSI disk error : host 0 channel 0 id 1 lun 0 return code = 10000
> 14:54:35 continuum kernel: I/O error: dev 08:11, sector 4895576
> 14:54:35 continuum kernel: SCSI disk error : host 0 channel 0 id 1 lun 0 return code = 10000
> 14:54:35 continuum kernel: I/O error: dev 08:11, sector 4895912
> 14:54:36 continuum kernel: SCSI disk error : host 0 channel 0 id 1 lun 0 return code = 10000
> 14:54:36 continuum kernel: I/O error: dev 08:11, sector 22635296
> 14:54:36 continuum kernel: SCSI disk error : host 0 channel 0 id 1 lun 0 return code = 10000
> 14:54:36 continuum kernel: I/O error: dev 08:11, sector 22635304
[]
> 14:55:23 continuum kernel: scsi0:0:1:0: Attempting to queue an ABORT message
> 14:55:23 continuum kernel: CDB: 0x2a 0x0 0x0 0x67 0x8e 0x1 0x0 0x0 0x28 0x0
[]
> 14:55:23 continuum kernel: (scsi0:A:1:0): Device is disconnected, re-queuing SCB
[]
> 14:55:23 continuum kernel: scsi0:0:1:0: Attempting to queue a TARGET RESET message
> 14:55:23 continuum kernel: CDB: 0x2a 0x0 0x0 0x67 0x8e 0x1 0x0 0x0 0x28 0x0
> 14:55:23 continuum kernel: scsi0:0:1:0: Is not an active device
> 14:55:23 continuum kernel: aic7xxx_dev_reset returns 0x2002
> 14:55:23 continuum kernel: (scsi0:A:1): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)

Shane, the situation you're seeing is very similar to the one we're
seeing here, also with seagate drives -- ST336607LW rev. 00007 in
our case.

The symptoms are: occasionally, the drive stops responding, just as there
was no drive here.  After several attempts to reset it and the bus, SCSI
subsystem gaves up (like "scsi0:0:1:0: Is not an active device"), and
switches to 160 MB/s transfers (from 320 MB/s) for the rest of devices
on the bus.  After a reboot (sometimes soft reboot is enouth, sometimes
only hard reboot - ie power off/on), the "missing" drive is here again.

When SCSI bus is in 160 or lower mode, the problem does not happen.

I was able to find how to trigger the condition here: just run
sformat -verify, and voila, the drive is "missing".

To me, the whole problem looks like a bug in disk firmware, but all
my attempts to contact seagate failed: "typical mishandling" they're
answering, which means that the disk has been dropped to the floor,
static elictricity, whatever...  I'm certain there was NO such cases
here, and again, when you can reproduce a problem on 100+ different
drives (of the same model), that's.. something...

For now, I don't have any solution for this problem, except of replacing
the drives to ones from different vendor...

/mjt
