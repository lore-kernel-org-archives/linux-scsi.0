From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Thu, 08 May 2003 10:00:58 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB99E3A.9060005@torque.net>
References: <3EB11AD3.2070503@torque.net>	<3EB22F09.7060906@torque.net>	<20030502095536.76dba4dd.rddunlap@osdl.org>	<3EB385F3.6010708@torque.net>	<20030505095715.6d96e703.rddunlap@osdl.org>	<3EB7748F.2030702@torque.net>	<20030506073923.210a82ff.rddunlap@osdl.org>	<3EB90867.6050803@torque.net>	<20030507111634.2cb1fe95.rddunlap@osdl.org> <20030507142057.760f426b.rddunlap@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:3080 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264405AbTEGXpm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 19:45:42 -0400
In-Reply-To: <20030507142057.760f426b.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org

Randy.Dunlap wrote:
> | Hi Doug-
> 
> | On Wed, 07 May 2003 23:21:43 +1000 Douglas Gilbert <dougg@torque.net> wrote:
> | 
> | | Randy.Dunlap wrote:
> | | > On Tue, 06 May 2003 18:38:39 +1000 Douglas Gilbert <dougg@torque.net> wrote:
> | | > 
> | | > | > Are there any docs on SCSI logging?
> | | 
> | | Do your failures only occur in an SMP environment?
> | 
> | I'll try 2.5.69 plus your patch ver. 2.
> 
> 2.5.69 + your ide-scsi ver. 2 patch, booted with "nosmp":
> 
>   hangs/locks up during boot sequence, immediately after this:
> 
> end_request: I/O error, dev hdc, sector 0
> scsi0 : SCSI host adapter emulation for IDE ATAPI devices
> ide-scsi: hdd: que 1, cmd = [ 12 0 0 0 24 0 ]
> ide-scsi: abort called for cmd serial #1
> ide-scsi: abort ignored
> ide-scsi: reset called for 1
> ide-scsi: device reset partially ignored
> ide-scsi: hdd: que 1, cmd = [ 0 0 0 0 0 0 ]
> ide-scsi: abort called for cmd serial #1
> ide-scsi: abort ignored
> scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
> 
> 
> same kernel without "nosmp", so it's dual-proc P4:
> 
>   I ran cdrecord, got to an error, cdrecord had a segfault.
> 
> Not much help I'm sorry to say.
> 
> Complete logs are here:
>   http://www.xenotime.net/linux/capt-2569-nosmp-locked.txt

Randy,
The "nosmp" failed on the very first SCSI command sent
to the device (36 byte INQUIRY during scan). Looks
like the 'rq->flags' were cleared (corruption) and
the end_request was routed through ide_end_request().

Good to see the scsi error handling took the device
offline. Did the device lock up or the whole machine?

> and
>   http://www.xenotime.net/linux/capt-2569-isc-dual-segv.txt

Got a bit further than last time but failed on the same
command, again with corrupted fields.

Perhaps you could send me your .config file so I can
set up my IDE subsystem the same way as yours.

Doug Gilbert


