From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
Date: Mon, 29 Jul 2013 15:01:54 +0200
Message-ID: <51F667C2.4020801@fastmail.fm>
References: <87r4ehfzhf.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r4ehfzhf.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Alcock <nix@esperi.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

Hi Nick,

On 07/29/2013 12:10 PM, Nick Alcock wrote:
> My server's ARC-1210 has been working fine for years, but when I
> upgraded from 3.10.1, it started failing:
>
> Instead of
>
> [    0.784044] Areca RAID Controller0: F/W V1.46 2009-01-06 & Model ARC-1210
> [    0.804028] scsi0 : Areca SATA Host Adapter RAID Controller
>   Driver Version 1.20.00.15 2010/08/05
> [...]
>
> [    4.111770] sd 7:0:0:1: [sdd] Assuming drive cache: write through
> [    4.115399] sd 7:0:0:1: [sdd] No Caching mode page present
> [    4.115401] sd 7:0:0:1: [sdd] Assuming drive cache: write through
> [    4.118081]  sdd: sdd1
> [    4.124363] sd 7:0:0:1: [sdd] No Caching mode page present
> [    4.124601] sd 7:0:0:1: [sdd] Assuming drive cache: write through
> [    4.124867] sd 7:0:0:1: [sdd] Attached SCSI removable disk
>
> I now see (timestamps and some of the right edge chopped off because not
> captured on my camera, no netconsole as this machine has all my storage
> and is my loghost, and with this bug it can't get at any of that
> storage).
>
> sd 7:0:0:1: [sdd] Assuming drive cache: write through
> sd 7:0:0:1: [sdd] No Caching mode page present
> sd 7:0:0:1: [sdd] Assuming drive cache: write through
>   sdd: sdd1
> sd 7:0:0:1: [sdd] No Caching mode page present
> sd 7:0:0:1: [sdd] Assuming drive cache: write through
> sd 7:0:0:1: [sdd] Attached SCSI removable disk
> arcmsr0: abort device command of scsi id = 0 lun = 1
> arcmsr0: abort device command of scsi id = 0 lun = 0
> arcmsr: executing bus reset eh.....num_resets=0, num_[...]
>
> arcmsr0: wait 'abort all outstanding command' timeout
> arcmsr0: executing hw bus reset ....
> arcmsr0: waiting for hw bus reset return, retry=0
> arcmsr0: waiting for hw bus reset return, retry=1
> Areca RAID Controller0: F/W V1.46 2009-01-06 & Model ARC-1210
> arcmsr: scsi  bus reset eh returns with success
> [and back to the top of the error messages again, apparently forever,
>   not that the machine would be much use without its RAID array even
>   if this loop terminated at some point, so I only gave it a couple
>   of minutes]
>
> The failure happens precisely at the moment we transition to early
> userspace, so presumably userspace I/O is failing (or something related
> to raw device access, perhaps, since the first thing it does is a
> vgscan).
>
> I haven't bisected yet (sorry, I have work to do which means this
> machine must be running right now), but nothing has changed in the
> arcmsr controller, nor in SCSI-land excepting
>
> commit 98dcc2946adbe4349ef1ef9b99873b912831edd4
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Thu Jun 6 22:15:55 2013 -0400
>
>      SCSI: sd: Update WRITE SAME heuristics
>
> so my, admittedly largely baseless, suspicions currently fall there.
>
>
> Obviously, at this point, this machine has no modules loaded (it has
> almost none loaded even when fully operational)

I tested this patch with ARC-1260 and F/W V1.49, no issues. Also, this 
patch is only in 3.10.3, but not yet in 3.10.1. And I don't think this 
commit can cause your issue at all, a failing heuristics would enable 
WRITE SAME and would cause issues with linux-md, but there shouldn't 
happen anything directly in the scsi-layer.
Which was your last working kernel version?


Thanks,
Bernd
