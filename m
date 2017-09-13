From: Hannes Reinecke <hare@suse.de>
Subject: Re: system hung up when offlining CPUs
Date: Wed, 13 Sep 2017 13:13:57 +0200
Message-ID: <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com>
 <20170809124213.0d9518bb@why.wild-wind.fr.eu.org>
 <cd524af7-1f20-1956-1e44-92a451053387@gmail.com>
 <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com>
 <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com>
 <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com>
 <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54591 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751878AbdIMLOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 07:14:09 -0400
In-Reply-To: <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>
Cc: tglx@linutronix.de, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com

On 09/12/2017 08:15 PM, YASUAKI ISHIMATSU wrote:
> + linux-scsi and maintainers of megasas
> 
> When offlining CPU, I/O stops. Do you have any ideas?
> 
> On 09/07/2017 04:23 PM, YASUAKI ISHIMATSU wrote:
>> Hi Mark and Christoph,
>>
>> Sorry for the late reply. I appreciated that you fixed the issue on kvm environment.
>> But the issue still occurs on physical server.
>>
>> Here ares irq information that I summarized megasas irqs from /proc/interrupts
>> and /proc/irq/*/smp_affinity_list on my server:
>>
>> ---
>> IRQ affinity_list IRQ_TYPE
>>  42        0-5    IR-PCI-MSI 1048576-edge megasas
>>  43        0-5    IR-PCI-MSI 1048577-edge megasas
>>  44        0-5    IR-PCI-MSI 1048578-edge megasas
>>  45        0-5    IR-PCI-MSI 1048579-edge megasas
>>  46        0-5    IR-PCI-MSI 1048580-edge megasas
>>  47        0-5    IR-PCI-MSI 1048581-edge megasas
>>  48        0-5    IR-PCI-MSI 1048582-edge megasas
>>  49        0-5    IR-PCI-MSI 1048583-edge megasas
>>  50        0-5    IR-PCI-MSI 1048584-edge megasas
>>  51        0-5    IR-PCI-MSI 1048585-edge megasas
>>  52        0-5    IR-PCI-MSI 1048586-edge megasas
>>  53        0-5    IR-PCI-MSI 1048587-edge megasas
>>  54        0-5    IR-PCI-MSI 1048588-edge megasas
>>  55        0-5    IR-PCI-MSI 1048589-edge megasas
>>  56        0-5    IR-PCI-MSI 1048590-edge megasas
>>  57        0-5    IR-PCI-MSI 1048591-edge megasas
>>  58        0-5    IR-PCI-MSI 1048592-edge megasas
>>  59        0-5    IR-PCI-MSI 1048593-edge megasas
>>  60        0-5    IR-PCI-MSI 1048594-edge megasas
>>  61        0-5    IR-PCI-MSI 1048595-edge megasas
>>  62        0-5    IR-PCI-MSI 1048596-edge megasas
>>  63        0-5    IR-PCI-MSI 1048597-edge megasas
>>  64        0-5    IR-PCI-MSI 1048598-edge megasas
>>  65        0-5    IR-PCI-MSI 1048599-edge megasas
>>  66      24-29    IR-PCI-MSI 1048600-edge megasas
>>  67      24-29    IR-PCI-MSI 1048601-edge megasas
>>  68      24-29    IR-PCI-MSI 1048602-edge megasas
>>  69      24-29    IR-PCI-MSI 1048603-edge megasas
>>  70      24-29    IR-PCI-MSI 1048604-edge megasas
>>  71      24-29    IR-PCI-MSI 1048605-edge megasas
>>  72      24-29    IR-PCI-MSI 1048606-edge megasas
>>  73      24-29    IR-PCI-MSI 1048607-edge megasas
>>  74      24-29    IR-PCI-MSI 1048608-edge megasas
>>  75      24-29    IR-PCI-MSI 1048609-edge megasas
>>  76      24-29    IR-PCI-MSI 1048610-edge megasas
>>  77      24-29    IR-PCI-MSI 1048611-edge megasas
>>  78      24-29    IR-PCI-MSI 1048612-edge megasas
>>  79      24-29    IR-PCI-MSI 1048613-edge megasas
>>  80      24-29    IR-PCI-MSI 1048614-edge megasas
>>  81      24-29    IR-PCI-MSI 1048615-edge megasas
>>  82      24-29    IR-PCI-MSI 1048616-edge megasas
>>  83      24-29    IR-PCI-MSI 1048617-edge megasas
>>  84      24-29    IR-PCI-MSI 1048618-edge megasas
>>  85      24-29    IR-PCI-MSI 1048619-edge megasas
>>  86      24-29    IR-PCI-MSI 1048620-edge megasas
>>  87      24-29    IR-PCI-MSI 1048621-edge megasas
>>  88      24-29    IR-PCI-MSI 1048622-edge megasas
>>  89      24-29    IR-PCI-MSI 1048623-edge megasas
>> ---
>>
>> In my server, IRQ#66-89 are sent to CPU#24-29. And if I offline CPU#24-29,
>> I/O does not work, showing the following messages.
>>
>> ---
>> [...] sd 0:2:0:0: [sda] tag#1 task abort called for scmd(ffff8820574d7560)
>> [...] sd 0:2:0:0: [sda] tag#1 CDB: Read(10) 28 00 0d e8 cf 78 00 00 08 00
>> [...] sd 0:2:0:0: task abort: FAILED scmd(ffff8820574d7560)
>> [...] sd 0:2:0:0: [sda] tag#0 task abort called for scmd(ffff882057426560)
>> [...] sd 0:2:0:0: [sda] tag#0 CDB: Write(10) 2a 00 0d 58 37 00 00 00 08 00
>> [...] sd 0:2:0:0: task abort: FAILED scmd(ffff882057426560)
>> [...] sd 0:2:0:0: target reset called for scmd(ffff8820574d7560)
>> [...] sd 0:2:0:0: [sda] tag#1 megasas: target reset FAILED!!
>> [...] sd 0:2:0:0: [sda] tag#0 Controller reset is requested due to IO timeout
>> [...] SCSI command pointer: (ffff882057426560)   SCSI host state: 5      SCSI
>> [...] IO request frame:
>> [...]
>> <snip>
>> [...]
>> [...] megaraid_sas 0000:02:00.0: [ 0]waiting for 2 commands to complete for scsi0
>> [...] INFO: task auditd:1200 blocked for more than 120 seconds.
>> [...]       Not tainted 4.13.0+ #15
>> [...] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [...] auditd          D    0  1200      1 0x00000000
>> [...] Call Trace:
>> [...]  __schedule+0x28d/0x890
>> [...]  schedule+0x36/0x80
>> [...]  io_schedule+0x16/0x40
>> [...]  wait_on_page_bit_common+0x109/0x1c0
>> [...]  ? page_cache_tree_insert+0xf0/0xf0
>> [...]  __filemap_fdatawait_range+0x127/0x190
>> [...]  ? __filemap_fdatawrite_range+0xd1/0x100
>> [...]  file_write_and_wait_range+0x60/0xb0
>> [...]  xfs_file_fsync+0x67/0x1d0 [xfs]
>> [...]  vfs_fsync_range+0x3d/0xb0
>> [...]  do_fsync+0x3d/0x70
>> [...]  SyS_fsync+0x10/0x20
>> [...]  entry_SYSCALL_64_fastpath+0x1a/0xa5
>> [...] RIP: 0033:0x7f0bd9633d2d
>> [...] RSP: 002b:00007f0bd751ed30 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
>> [...] RAX: ffffffffffffffda RBX: 00005590566d0080 RCX: 00007f0bd9633d2d
>> [...] RDX: 00005590566d1260 RSI: 0000000000000000 RDI: 0000000000000005
>> [...] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000017
>> [...] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
>> [...] R13: 00007f0bd751f9c0 R14: 00007f0bd751f700 R15: 0000000000000000
>> ---
>>
>> Thanks,
>> Yasuaki Ishimatsu
>>

This indeed looks like a problem.
We're going to great lengths to submit and complete I/O on the same CPU,
so if the CPU is offlined while I/O is in flight we won't be getting a
completion for this particular I/O.
However, the megasas driver should be able to cope with this situation;
after all, the firmware maintains completions queues, so it would be
dead easy to look at _other_ completions queues, too, if a timeout occurs.
Also the IRQ affinity looks bogus (we should spread IRQs to _all_ CPUs,
not just a subset), and the driver should make sure to receive
completions even if the respective CPUs are offlined.
Alternatively it should not try to submit a command abort via an
offlined CPUs; that's guaranteed to run into the same problems.

So it looks more like a driver issue to me...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
