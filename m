From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination
 (v2)
Date: Fri, 4 Nov 2016 15:51:45 +0100
Message-ID: <38e3e634-6e08-58bd-bc11-8a0a470b78d9@suse.de>
References: <2179ecb8-183f-a500-4d65-10f64f0f43cc@suse.de>
 <1478045394-19536-1-git-send-email-andrey2805@gmail.com>
 <dbeededa-e2fc-53d3-997c-34ba1129a80b@suse.de>
 <CAK=zhgpYj0TcrPK8kQ-TTqGfU=JHZbXr+2-szGf1w_XcOU3p9Q@mail.gmail.com>
 <CAJphD_qrQftfCOn_uzXCfdX=Xv9BYvVQ60AZ4DR2rc3gfXQa_Q@mail.gmail.com>
 <30w645ulbhlofxrk1h4a9q3s.1478144944778@email.android.com>
 <CAK=zhgra2zDZon5fuW1OwQfJ_2ExkAzcsKGiuBJaLYX6sMoTCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgra2zDZon5fuW1OwQfJ_2ExkAzcsKGiuBJaLYX6sMoTCQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Igor Rybak <igor@media-clone.com>, Andrey Grodzovsky <andrey2805@gmail.com>
Cc: Ezra Kohavi <ezra@media-clone.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/04/2016 01:45 PM, Sreekanth Reddy wrote:
> Hi All,
>
> From last two days, I was working with my firmware team to get the
> required info over this issue. Here is my firmware team response
>
> "For ATA PASSTHROUGH commands, the IOC SATL will not check for the
> opcode and will direct it to the drive. So even though ATA PASSTHOUGH
> has ATA erase to the drive, IOC SATL FW will not know that and as a
> general logic for all ATA PASSTHOGH commands, IOC FW will pend the
> upcoming IOs untill the previous ATA PASSTHORUGH completes. This is as
> per the SAT specification for SAS controllers and we can't compare it
> with the SATA controllers in the on board that have full fledge SATA
> implementation".
>
> So this is an expected behavior from our HBA firmware. i.e. it will
> pend the subsequent commands if any ATA PASSTHROUGH command is going
> on. So their is no issue with the FW.
>
But is there a way to figure out if the firmware / SATL layer is busy 
processing requests?

With 'real' ATA HBAs these issue doesn't occur, as the ATA erase command 
is a non-queued command, and hence the next command automatically has to 
wait for the erase command to complete.
But this wait happens as the ATA HBA returns 'BUSY', and the linux I/O 
stack will then reset the timeout for all consecutive commands.

With mpt3sas _all_ commands are queued, so if there is a long-running 
I/O command all other commands already in the queue will time out.

Which is at least a very awkward behaviour.

Checking with SAT-3 (section 6.2.4: Commands the SATL queues internally) 
the implemented behaviour is standards conformant, although the standard 
also allows for returning 'TASK SET FULL' or 'BUSY' in these cases.
Doing so would nicely solve this issue.

> Today I have tried the same test case on my local setup. i.e. I have
> issued a secure erase command using hdparm utility and observed the
> same issue on 4.2.3-300.fc23.x86_64 kernel.
>
> Then after browsing over this issue, I found that some people are
> recommending to enable 'CONFIG_IDE_TASK_IOCTL' Kconfig flag. I had a
> compiled 4.4.0 kernel, so I have enabled this CONFIG_IDE_TASK_IOCTL
> and recompiled this 4.4.0 kernel and booted in to this kernel. Then I
> tried same test case and I haven't observed this issue and secure
> erase operation was completed successfully.
>
> So, can you please try once with CONFIG_IDE_TASK_IOCTL enabled.
>
Errm.
CONFIG_IDE_TASK_IOCTL is for the old IDE subsystem, which isn't in use 
here. So this option does not make a difference when using mpt3sas, as 
this is a 'real' SCSI driver which never calls out into any of these 
subsystems.

I would be _VERY_ much surprised if that would make a difference.

The reason why this behaviour did go unnoticed with older kernels was 
that a command timeout would trigger SCSI EH to engage, and that in turn 
required all outstanding commands to complete.
So by the time SCSI EH started the ERASE command was complete, and a 
retry of the timed-out commands would work.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
