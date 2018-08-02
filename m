From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: linux-next: Tree for Aug 1
Date: Thu, 2 Aug 2018 05:46:19 -0700
Message-ID: <93cbb876-3a25-482a-a5b4-6e13d42ee535@roeck-us.net>
References: <20180801175852.36549130@canb.auug.org.au>
 <20180801224813.GA13074@roeck-us.net>
 <1533163965.3158.1.camel@HansenPartnership.com>
 <20180801234727.GA3762@roeck-us.net>
 <CACVXFVMrzLRP5Q=cwZGnqeUeyODL3Pq9jMkT7czZouK9510fUA@mail.gmail.com>
 <1533168205.3158.12.camel@HansenPartnership.com>
 <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
 <e3e32fd801cb1270cddec6fc1ea3dabad4473b64.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e3e32fd801cb1270cddec6fc1ea3dabad4473b64.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/01/2018 10:04 PM, Bart Van Assche wrote:
> On Wed, 2018-08-01 at 21:58 -0700, Guenter Roeck wrote:
>> I am running out of ideas. Any thoughts on how to track this down further ?
> 
> Is a shell available when the hang occurs? If so, it would be helpful if you
> could provide a dump of the information in /sys/kernel/debug/block. There is
> namely detailed information in that directory about pending commands.
> 

No, it hangs hard early in the boot process. See various logs at
http://kerneltests.org/builders/, in the 'next' column.

Here is some interesting information from the x86_64 boot tests.

Building x86_64:q35:Broadwell-noTSX:defconfig:smp:sata:rootfs ... running .................................. failed (timeout)
Building x86_64:q35:IvyBridge:defconfig:smp:nvme:rootfs ... running .................................. failed (timeout)
Building x86_64:q35:SandyBridge:defconfig:smp:usb:rootfs ... running .................................. failed (timeout)
Building x86_64:q35:Haswell:defconfig:smp:usb-uas:rootfs ... running ...... passed
Building x86_64:q35:Skylake-Client:defconfig:smp:mmc:rootfs ... running .................................. failed (timeout)
Building x86_64:q35:Conroe:defconfig:smp:scsi[DC395]:rootfs ... running ........ passed
Building x86_64:q35:Nehalem:defconfig:smp:scsi[AM53C974]:rootfs ... running ...... passed
Building x86_64:q35:Westmere-IBRS:defconfig:smp:scsi[53C810]:rootfs ... running ....... passed
Building x86_64:q35:Skylake-Server:defconfig:smp:scsi[53C895A]:rootfs ... running ....... passed
Building x86_64:pc:EPYC:defconfig:smp:scsi[MEGASAS]:rootfs ... running ...... passed
Building x86_64:q35:EPYC-IBPB:defconfig:smp:scsi[MEGASAS2]:rootfs ... running ....... passed
Building x86_64:q35:Opteron_G5:defconfig:smp:scsi[FUSION]:rootfs ... running ....... passed
Building x86_64:pc:phenom:defconfig:smp:initrd ... running .................................. failed (timeout)
Building x86_64:q35:Opteron_G1:defconfig:smp:initrd ... running .................................. failed (timeout)
Building x86_64:pc:Opteron_G2:defconfig:smp:sata:rootfs ... running .................................. failed (timeout)
Building x86_64:q35:core2duo:defconfig:smp:usb:rootfs ... running .................................. failed (timeout)
Building x86_64:pc:Opteron_G3:defconfig:nosmp:usb:rootfs ... running .................................. failed (timeout)
Building x86_64:q35:Opteron_G4:defconfig:nosmp:sata:rootfs ... running .................................. failed (timeout)

This is consistent across multiple test runs. In summary,

- Boot from initrd fails
- Boot from SATA drive fails (this is with CONFIG_ATA)
- Boot from NVME fails
- Boot from USB drive fails
- Boot from MMC (SD) fails
- Boot from USB UAS drive passes
- Boot from various real SCSI drives passes

Platform (pc,q35), CPU type, or SMP/NOSMP does not seem to make a difference.

Guenter
