From: Sancho Dauskardt <sancho@dauskardt.de>
Subject: Re: Multiple CDRW's on one bus blocking each other
Date: Thu, 02 May 2002 23:17:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.0.2.1.2.20020502221132.03224090@pop.puretec.de>
References: <5.0.2.1.2.20020502145414.0354c230@pop.puretec.de>
 <5.0.2.1.2.20020502145414.0354c230@pop.puretec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020502092726.A14365@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

At 09:27 02.05.02 -0700, Patrick Mansfield wrote:
>Have you tried using scsi logging? That might give a better idea of what
>is happening in linux scsi layers.

Great idea, thanks. Luckly my disks were on a ide bus, so no logging problems.


In the mean time I've tried following different scenarios:
a) 3 CDRW on a NCR53c800 --> exactly the same as the adaptec (tray opens 
are independant, tray closes are 'serialized')
b) 2 CDROM's on ONE IDE bus via ide-scsi --> tray opens AND closes are 
serialized !

I'll stick with the IDE setup for now.

Following different software approaches tried:
- 'eject & eject -t'
- ioctl CDROMEJECT & ioctl CDROMCLOSETRAY on /dev/srX
- ioctl CDROM_SEND_PACKET with GPCMD_START_STOP_UNIT, as sr_ioctl.c / 
sr_tray_move does.
   As one would guess, all behave the same.



Now if i'm reading the logs correctly, it not the START STOP UNIT (0x1b) 
command that's causing the problems, but more the PREVENT ALLOW MEDIUM 
REMOVAL command...

Where's this delay coming from / did the timer fire / were are we sleeping ???
         May  2 21:23:00 ice kernel: Leaving scsi_do_req()
                  -- here --
         May  2 21:23:06 ice kernel: Clearing timer for command cff33400 1


Just a nother silly idea: could it be possible, that the problem is 
triggered somwhere down in the VFS - i.e. that the VFA locks the bus while 
trying to detect the new media ??


btw. he '--sda-- blabla' crap was just an idea in 
scsi_block_when_processing_errors()..

- sda

the logs: (2x tray loading on one ide bus)
--------
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: Trying ioctl with scsi command 0
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 1000, retries = 5)
May  2 21:22:59 ice kernel: command : 00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 0 (1)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: Trying ioctl with scsi command 0
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 1000, retries = 5)
May  2 21:22:59 ice kernel: command : 00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: Ioctl returned  0x28000000
May  2 21:22:59 ice kernel: IOCTL Releasing command
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =c0356000, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  40
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: Ioctl returned  0x28000000
May  2 21:22:59 ice kernel: IOCTL Releasing command
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =c0356200, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  40
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =cbf79e14, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = cbf79e14,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =cbfd5e14, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  00
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = cbfd5e14,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = cbf79e14,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: VFS: Disk change detected on device sr(11,1)
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =c0356000, bufflen = 8, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 25  00  00  00  00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = cbfd5e14,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: VFS: Disk change detected on device sr(11,0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =c0356200, bufflen = 8, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 25  00  00  00  00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =c0356000, bufflen = 8, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 25  00  00  00  00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =c0356200, bufflen = 8, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 25  00  00  00  00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =c0356000, bufflen = 8, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 25  00  00  00  00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =c0356200, bufflen = 8, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 25  00  00  00  00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: Trying ioctl with scsi command 0
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 1000, retries = 5)
May  2 21:22:59 ice kernel: command : 00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 8, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: Trying ioctl with scsi command 0
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 1000, retries = 5)
May  2 21:22:59 ice kernel: command : 00  00  00  00  00  00
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: Ioctl returned  0x28000000
May  2 21:22:59 ice kernel: IOCTL Releasing command
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =c0356000, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  40
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 1000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: Ioctl returned  0x28000000
May  2 21:22:59 ice kernel: IOCTL Releasing command
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =c0356200, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  40
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = c0356000,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =cbf79e24, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = cbf79e24,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = c0356200,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =cbfd5e24, bufflen = 12, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 43  00  00  00  00  00  00  00  0c  00
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = cbfd5e24,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = cbf79e24,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:22:59 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: VFS: Disk change detected on device sr(11,1)
May  2 21:22:59 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 1b  00  00  00  03  00
May  2 21:22:59 ice kernel: Activating command for device 1 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff2ba00 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 50 (c01e22e0)
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = cbfd5e24,
May  2 21:22:59 ice kernel: bufflen = 12, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Clearing timer for command cff33400 1
May  2 21:22:59 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:22:59 ice kernel: VFS: Disk change detected on device sr(11,0)
May  2 21:22:59 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:22:59 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:22:59 ice kernel: Open returning 1
May  2 21:22:59 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 3000, retries = 3)
May  2 21:22:59 ice kernel: command : 1b  00  00  00  03  00
May  2 21:22:59 ice kernel: Activating command for device 0 (2)
May  2 21:22:59 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:22:59 ice kernel: Adding timer for command cff33400 at 3000 
(c01e22e0)
May  2 21:22:59 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = 00000000,
May  2 21:22:59 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:22:59 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:22:59 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:22:59 ice kernel: Leaving scsi_do_req()
May  2 21:23:00 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:23:00 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:23:00 ice kernel:  --sda-- about to block target 1/0/0 --sda--
May  2 21:23:00 ice kernel:  --sda-- blocking target 1/0/0 done --sda--
May  2 21:23:00 ice kernel: Open returning 1
May  2 21:23:00 ice kernel: Trying ioctl with scsi command 30
May  2 21:23:00 ice kernel: scsi_do_req (host = 0, channel = 0 target = 1, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 1000, retries = 5)
May  2 21:23:00 ice kernel: command : 1e  00  00  00  00  00
May  2 21:23:00 ice kernel: Activating command for device 1 (2)
May  2 21:23:00 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:23:00 ice kernel: Adding timer for command cff2ba00 at 1000 
(c01e22e0)
May  2 21:23:00 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = 00000000,
May  2 21:23:00 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:23:00 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:23:00 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:23:00 ice kernel: Leaving scsi_do_req()

May  2 21:23:06 ice kernel: Clearing timer for command cff33400 1
May  2 21:23:06 ice kernel: Deactivating command for device 0 (active=1, 
failed=0)
May  2 21:23:06 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:23:06 ice kernel: Adding timer for command cff2ba00 at 50 (c01e22e0)
May  2 21:23:06 ice kernel: Adding timer for command cff2ba00 at 1000 
(c01e22e0)
May  2 21:23:06 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 1, command = cff2ba58, buffer = 00000000,
May  2 21:23:06 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:23:06 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:23:06 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:23:06 ice kernel:  --sda-- about to block target 0/0/0 --sda--
May  2 21:23:06 ice kernel:  --sda-- blocking target 0/0/0 done --sda--
May  2 21:23:06 ice kernel: Open returning 1
May  2 21:23:06 ice kernel: Trying ioctl with scsi command 30
May  2 21:23:06 ice kernel: scsi_do_req (host = 0, channel = 0 target = 0, 
buffer =00000000, bufflen = 0, done = c01dc0c8, timeout = 1000, retries = 5)
May  2 21:23:06 ice kernel: command : 1e  00  00  00  00  00
May  2 21:23:06 ice kernel: Activating command for device 0 (2)
May  2 21:23:06 ice kernel: Leaving scsi_init_cmd_from_req()
May  2 21:23:06 ice kernel: Adding timer for command cff33400 at 1000 
(c01e22e0)
May  2 21:23:06 ice kernel: scsi_dispatch_cmnd (host = 0, channel = 0, 
target = 0, command = cff33458, buffer = 00000000,
May  2 21:23:06 ice kernel: bufflen = 0, done = c01dc0c8)
May  2 21:23:06 ice kernel: queuecommand : routine at c01e7bfc
May  2 21:23:06 ice kernel: leaving scsi_dispatch_cmnd()
May  2 21:23:06 ice kernel: Leaving scsi_do_req()
May  2 21:23:06 ice kernel: Clearing timer for command cff2ba00 1
May  2 21:23:06 ice kernel: Deactivating command for device 1 (active=1, 
failed=0)
May  2 21:23:06 ice kernel: Ioctl returned  0x28000000
May  2 21:23:06 ice kernel: IOCTL Releasing command
May  2 21:23:06 ice kernel: Clearing timer for command cff33400 1
May  2 21:23:06 ice kernel: Deactivating command for device 0 (active=0, 
failed=0)
May  2 21:23:06 ice kernel: Ioctl returned  0x0
May  2 21:23:06 ice kernel: IOCTL Releasing command

