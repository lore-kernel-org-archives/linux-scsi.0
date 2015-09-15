From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [Bugfix 0/3] Convert eata driver to a normal PCI device driver
Date: Tue, 15 Sep 2015 10:31:34 +0800
Message-ID: <55F78306.3000802@linux.intel.com>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
 <55F6EF40.50403@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55F6EF40.50403@internode.on.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2015/9/15 0:01, Arthur Marsh wrote:
> 
> 
> Jiang Liu wrote on 14/09/15 12:38:
>> Hi Authur,
>>     As suggested by Bjorn, patch 1-2 set implement a PCI device
>> driver to manage eata PCI devices. And patch 3 tries to support PCI
>> device hot-removal for eata, but I have no change to test due to
>> limited knowledge about scsi subsystem and lacking of hardware for
>> tests.
>>     So you could please help to test patch 1-2? Patch 3 is just
>> for comments.
>> Thanks!
>> Gerry
>>
>> Jiang Liu (3):
>>    eata: Use IDA to manage eata board IDs
>>    eata: Implement PCI driver to manage eata PCI devices
>>    eata: Enhance eata driver to support PCI device hot-removal
>>
>>   drivers/scsi/eata.c |  232
>> +++++++++++++++++++++++++++------------------------
>>   1 file changed, 125 insertions(+), 107 deletions(-)
>>
> 
> With patches 1 and 2 applied, I get a successful boot with IRQ mapping:
> 
> [    1.147056] EATA0: IRQ 10 mapped to IO-APIC IRQ 17.
> [    1.160404] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
> [    1.160469] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n,
> ip:n, ep:n, pp:y.
> [    1.160541] EATA0: 2.0C, PCI 0xd890, IRQ 17, BMST, SG 122, MB 64.
> [    1.160600] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
> [    1.160658] EATA0: SCSI channel 0 enabled, host target ID 7.
> [    1.161207] scsi host0: EATA/DMA 2.0x rev. 8.10.00
> 
> 
> but I still get errors when trying to do a kexec reboot, see
> http://www.users.on.net/~arthur.marsh/20150915547.jpg
> 
> roughly it reads (after the synchronising SCSI cache reboot messages)
> and a long period of a dark screen:
> 
> sd 0:0:6:0: abort, mbox 63.
> EATA0: abort, mbox 63 is in use.
> sd 0:0:6:0: reset, enter.
> EATA0: reset, mbox 63 in reset.
> EATA0: reset, board reset done, enabling interrupts.
> EATA0: reset, interrupts disabled, loops 100469.
> EATA0: reset, mbox 63 locked, DID_RESET, done.
> EATA0: reset, exit, done.
> sd 0:0:6:0: qcomm, mbox 0, adapter busy, will start
> sd 0:0:6:0: abort, mbox 0.
> EATA0: abort, timeout error.
> sd 0:0:6:0: reset, enter.
> EATA0: reset, exit, timeout error.
> sd 0:0:6:0 Device offlinled - not ready after error recovery
> sd 0:0:6:0 rejecting I/O to offline device
> sd 0:0:6:0 rejecting I/O to offline device
> sd 0:0:6:0 [sda] Synchronize Cache(10) failed: Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> starting new kernel
> 
> It would be great if this problem could be fixed.
HI Arthur,
	Really appreciate your help to test the patches. That's
a good sign we have moved forward a bit:)
	For kexec, it's always challenging to me. So could you
please help to provide full dmesg logs with working kernels
so I could try to figure out the order among scsi and PCI devices.
It may be shutdown order related.
Thanks!
Gerry

> 
> Arthur.
> 
