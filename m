From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: 2.6.24 regression w/ QLA2300
Date: Tue, 05 Feb 2008 11:30:36 -0500
Message-ID: <47A88F2C.5050407@hp.com>
References: <47A88736.6090706@hp.com> <20080205160246.GF19882@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:1765 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYBEQaz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 11:30:55 -0500
In-Reply-To: <20080205160246.GF19882@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

Andrew Vasquez wrote:
> On Tue, 05 Feb 2008, Alan D. Brunelle wrote:
> 
>> commit 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
>> Merge: 50d9a12... 23c3e29...
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Fri Jan 25 17:19:08 2008 -0800
>>
>>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
>>
>>     * git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6: (200 commits)
>>
>> I believe a regression was introduced. I'm running on a 4-way IA64,
>> with straight 2.6.24 and 2 dual-port cards:
>>
>> 40:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>> 40:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>> c0:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>> c0:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>>
>> the adapters failed initialization. In particular, I narrowed it down
>> to failing the qla2x00_mbox_command call within qla2x00_init_firmware
>> function. I went and removed the qla2x00-related parts of this (large-ish)
>> merge, and the 4 ports initialized just fine.
> 
> Could you load the (default 2.6.24) driver with
> ql2xextended_error_logging modules parameter set:
> 
> 	# insmod qla2xxx ql2xextended_error_logging=1
> 
> and send the resultant kernel logs?

Here's the output to the console (if there are other logs you need, let me know). I'll try the patch next, and sorry, hadn't realized merges were still coming in under 2.6.24 in Linus' tree... 

QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0000:40:01.0[A] -> GSI 38 (level, low) -> IRQ 58
qla2xxx 0000:40:01.0: Found an ISP2312, irq 58, iobase 0xc0000000a0041000
qla2xxx 0000:40:01.0: Configuring PCI space...
qla2x00_get_flash_version(): Unrecognized code type ff at pcids da1c.
qla2x00_get_flash_version(): Unrecognized code type ff at pcids 1f61c.
qla2xxx 0000:40:01.0: Configure NVRAM parameters...
qla2xxx 0000:40:01.0: Verifying loaded RISC code...
scsi(14): **** Load RISC code ****
scsi(14): Verifying Checksum of loaded RISC code.
scsi(14): Checksum OK, start firmware.
qla2xxx 0000:40:01.0: Allocated (412 KB) for firmware dump...
scsi(14): Issue init firmware.
qla2x00_mailbox_command(14): **** FAILED. mbx0=4001, mbx1=0, mbx2=ba8a, cmd=48 ****
qla2x00_init_firmware(14): failed=102 mb0=4001.
scsi(14): Init firmware **** FAILED ****.
qla2xxx 0000:40:01.0: Failed to initialize adapter
scsi(14): Failed to initialize adapter - Adapter flags 10.
ACPI: PCI Interrupt 0000:40:01.1[B] -> GSI 39 (level, low) -> IRQ 59
qla2xxx 0000:40:01.1: Found an ISP2312, irq 59, iobase 0xc0000000a0040000
qla2xxx 0000:40:01.1: Configuring PCI space...
qla2x00_get_flash_version(): Unrecognized code type ff at pcids da1c.
qla2x00_get_flash_version(): Unrecognized code type ff at pcids 1f61c.
qla2xxx 0000:40:01.1: Configure NVRAM parameters...
qla2xxx 0000:40:01.1: Verifying loaded RISC code...
scsi(15): **** Load RISC code ****
scsi(15): Verifying Checksum of loaded RISC code.
scsi(15): Checksum OK, start firmware.
qla2xxx 0000:40:01.1: Allocated (412 KB) for firmware dump...
scsi(15): Issue init firmware.
qla2x00_mailbox_command(15): **** FAILED. mbx0=4001, mbx1=0, mbx2=bac6, cmd=48 ****
qla2x00_init_firmware(15): failed=102 mb0=4001.
scsi(15): Init firmware **** FAILED ****.
qla2xxx 0000:40:01.1: Failed to initialize adapter
scsi(15): Failed to initialize adapter - Adapter flags 10.
ACPI: PCI Interrupt 0000:c0:01.0[A] -> GSI 71 (level, low) -> IRQ 60
qla2xxx 0000:c0:01.0: Found an ISP2312, irq 60, iobase 0xc0000000e0041000
qla2xxx 0000:c0:01.0: Configuring PCI space...
qla2x00_get_flash_version(): Unrecognized code type ff at pcids c61c.
qla2x00_get_flash_version(): Unrecognized code type ff at pcids 1da1c.
qla2xxx 0000:c0:01.0: Configure NVRAM parameters...
qla2xxx 0000:c0:01.0: Verifying loaded RISC code...
scsi(16): **** Load RISC code ****
scsi(16): Verifying Checksum of loaded RISC code.
scsi(16): Checksum OK, start firmware.
qla2xxx 0000:c0:01.0: Allocated (412 KB) for firmware dump...
scsi(16): Issue init firmware.
qla2x00_mailbox_command(16): **** FAILED. mbx0=4001, mbx1=0, mbx2=bae3, cmd=48 ****
qla2x00_init_firmware(16): failed=102 mb0=4001.
scsi(16): Init firmware **** FAILED ****.
qla2xxx 0000:c0:01.0: Failed to initialize adapter
scsi(16): Failed to initialize adapter - Adapter flags 10.
ACPI: PCI Interrupt 0000:c0:01.1[B] -> GSI 72 (level, low) -> IRQ 61
qla2xxx 0000:c0:01.1: Found an ISP2312, irq 61, iobase 0xc0000000e0040000
qla2xxx 0000:c0:01.1: Configuring PCI space...
qla2x00_get_flash_version(): Unrecognized code type ff at pcids c61c.
qla2x00_get_flash_version(): Unrecognized code type ff at pcids 1da1c.
qla2xxx 0000:c0:01.1: Configure NVRAM parameters...
qla2xxx 0000:c0:01.1: Verifying loaded RISC code...
scsi(17): **** Load RISC code ****
scsi(17): Verifying Checksum of loaded RISC code.
scsi(17): Checksum OK, start firmware.
qla2xxx 0000:c0:01.1: Allocated (412 KB) for firmware dump...
scsi(17): Issue init firmware.
qla2x00_mailbox_command(17): **** FAILED. mbx0=4001, mbx1=0, mbx2=bb06, cmd=48 ****
qla2x00_init_firmware(17): failed=102 mb0=4001.
scsi(17): Init firmware **** FAILED ****.
qla2xxx 0000:c0:01.1: Failed to initialize adapter
scsi(17): Failed to initialize adapter - Adapter flags 10.
