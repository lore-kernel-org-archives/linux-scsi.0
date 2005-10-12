From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: scsi_eh: BUG in __schedule (was Re: Trouble installing 1394...)
Date: Wed, 12 Oct 2005 02:26:48 +0200
Message-ID: <434C5848.4010107@s5r6.in-berlin.de>
References: <20051011163832.49397.qmail@web54611.mail.yahoo.com>	 <5bdc1c8b0510110943reb9c49fu8428f6d4f67d5d75@mail.gmail.com>	 <434C2D25.3050403@s5r6.in-berlin.de> <5bdc1c8b0510111609y1309484au7893f4c154922af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:6323 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932355AbVJLA1p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2005 20:27:45 -0400
In-Reply-To: <5bdc1c8b0510111609y1309484au7893f4c154922af@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

Mark Knecht wrote to linux1394-user:
> Hi Stefan,
>    You may have spotted this on the LKML or possibly not.

I am not subscribed there.

> The messages
> showed up a few minutes later. There were not there when I sent this
> message, but a few minutes later I got a bug trace and then got the
> messages. Looked like a bug to me but I wouldn't know if it was in the
> kernel or the 1394 drivers.
> 
> Note that I have since rebuilt the kernel and didn't get this the next
> time I booted. Here's what I saw:
> 
> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[66]
> MMIO=[da014000-da0147ff]  Max Packet=[4096]
> sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0800286410000f43]
> eth0: no IPv6 routers present
> ieee1394: Error parsing configrom for node 0-00:1023
> ieee1394: Node changed: 0-00:1023 -> 0-01:1023
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0050c504e0006463]

(Remark: One FireWire node is present at this point, plus the local node.)

> scsi4 : SCSI emulation for IEEE-1394 SBP-2 Devices
> ieee1394: sbp2: Error logging into SBP-2 device - login timed-out
> prev->state: 2 != TASK_RUNNING??
> scsi_eh_4/7835[CPU#0]: BUG in __schedule at kernel/sched.c:3326
> 
> Call Trace:<ffffffff80132221>{__WARN_ON+97} <ffffffff803e79f0>{__schedule+608}
>       <ffffffff801342bf>{do_exit+1007}
> <ffffffff801467c0>{keventd_create_kthread+0}
>       <ffffffff8010e5ed>{child_rip+15}
> <ffffffff801467c0>{keventd_create_kthread+0}
>       <ffffffff801466b0>{kthread+0} <ffffffff8010e5de>{child_rip+0}
> 
> sbp2: probe of 0050c504e0006463-0 failed with error -16
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00303c020010645c]

(Remark: Now there are two external FireWire nodes, plus local node.)

> ieee1394: Node changed: 0-00:1023 -> 0-01:1023
> ieee1394: Node changed: 0-01:1023 -> 0-02:1023
> scsi5 : SCSI emulation for IEEE-1394 SBP-2 Devices
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S800] - Max payload [4096]
>  Vendor: Maxtor 6  Model: Y160P0            Rev: YAR4
>  Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
> SCSI device sdb: 320173056 512-byte hdwr sectors (163929 MB)
> sdb: asking for cache data failed
> sdb: assuming drive cache: write through
> SCSI device sdb: 320173056 512-byte hdwr sectors (163929 MB)
> sdb: asking for cache data failed
> sdb: assuming drive cache: write through
>  sdb: sdb1 sdb2
> Attached scsi disk sdb at scsi5, channel 0, id 0, lun 0
> scsi6 : SCSI emulation for IEEE-1394 SBP-2 Devices
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-01:1023: Max speed [S400] - Max payload [2048]
>  Vendor: Maxtor 6  Model: Y160P0            Rev: YAR4
>  Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
> SCSI device sdc: 320173056 512-byte hdwr sectors (163929 MB)
> sdc: asking for cache data failed
> sdc: assuming drive cache: write through
> SCSI device sdc: 320173056 512-byte hdwr sectors (163929 MB)
> sdc: asking for cache data failed
> sdc: assuming drive cache: write through
>  sdc: sdc1 sdc2 sdc3
> Attached scsi disk sdc at scsi6, channel 0, id 0, lun 0
[...]

I gather from another post of yours that you got this from 2.6.14-rc4, 
right?

The way how the scsi_eh (error handler daemon of the scsi core) is 
started and stopped was changed earlier in 2.6.14-rcX and was broken 
before 2.6.14-rc3. Either there is still a bug in there, or sbp2 uses 
the scsi core incorrectly again. I will have a closer look at how an 
sbp2 login time-out situation may affect scsi_eh RSN. (Ideally, sbp2 
should cause scsi core to start scsi_eh only after a successful login, 
but that is another story.)

I cc'd linux-scsi because that is where scsi_eh's authors are.
-- 
Stefan Richter
-=====-=-=-= =-=- -==--
http://arcgraph.de/sr/
