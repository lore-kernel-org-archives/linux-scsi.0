Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [107.191.43.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA45645B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jan 2024 21:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kevinlocke.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kevinlocke.name
Received: from kevinolos.kevinlocke.name (2600-6c67-5000-0a52-7f13-aa6f-584c-2934.res6.spectrum.com [IPv6:2600:6c67:5000:a52:7f13:aa6f:584c:2934])
	(Authenticated sender: kevin@kevinlocke.name)
	by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 1F2D640C6CE3;
	Mon,  8 Jan 2024 21:55:15 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
	id 0182B1300689; Mon,  8 Jan 2024 14:55:10 -0700 (MST)
Date: Mon, 8 Jan 2024 14:55:10 -0700
From: Kevin Locke <kevin@kevinlocke.name>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Message-ID: <ZZxvPtrf5hLeZNY5@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>

On Mon, 2024-01-08 at 13:33 -0800, Bart Van Assche wrote:
> On 1/8/24 09:56, Kevin Locke wrote:
>> On a ThinkPad T430 running Linux 6.7, when I attempt to delete the ATA
>> device for a hard drive in the Ultrabay slot (to hotswap/undock it[1])
>> the process freezes in an unterruptible sleep.
> 
> [...]
> 
> The "Synchronizing SCSI cache" message probably comes from sd_shutdown().
> sd_shutdown() is called by sd_remove(). sd_remove() is called by
> __scsi_remove_device(). __scsi_remove_device() is called by
> sdev_store_delete(). It's not clear to me how commit 8b566edbdbfb
> ("scsi: core: Only kick the requeue list if necessary") can affect that
> call path.
> 
> It would help if more information about the hang could be provided by
> running the following command after having reproduced the hang and by
> sharing the dmesg output triggered by this command:
> 
>     echo w > /proc/sysrq-trigger

Hi Bart,

Thanks for helping me investigate this issue!

Relevant dmesg section after `echo w > /proc/sysrq-trigger`:

-8<------------------------------------------------------------------
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
ata2.00: configured for UDMA/133
ata2.00: retrying FLUSH 0xea Emask 0x0
sysrq: Show Blocked State
task:ultrabay_eject  state:D stack:0     pid:2630  tgid:2630  ppid:2629   flags:0x00004002
Call Trace:
 <TASK>
 __schedule+0x2c1/0x8a0
 schedule+0x32/0xb0
 schedule_timeout+0x151/0x160
 io_schedule_timeout+0x50/0x80
 wait_for_completion_io+0x86/0x170
 blk_execute_rq+0x11e/0x1f0
 scsi_execute_cmd+0xf6/0x250 [scsi_mod]
 sd_sync_cache+0xe6/0x1f0 [sd_mod]
 sd_shutdown+0x68/0x100 [sd_mod]
 sd_remove+0x55/0x60 [sd_mod]
 device_release_driver_internal+0x19f/0x200
 bus_remove_device+0xc6/0x130
 device_del+0x15e/0x3f0
 ? mutex_lock+0x12/0x30
 ? __pfx_ata_tdev_match+0x10/0x10 [libata]
 __scsi_remove_device+0x131/0x190 [scsi_mod]
 sdev_store_delete+0x6a/0xd0 [scsi_mod]
 kernfs_fop_write_iter+0x13d/0x1d0
 vfs_write+0x23d/0x400
 ksys_write+0x6f/0xf0
 do_syscall_64+0x64/0x120
 ? exc_page_fault+0x70/0x150
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
RIP: 0033:0x7fa0f8949b00
RSP: 002b:00007ffc779b8418 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fa0f8949b00
RDX: 0000000000000002 RSI: 000056549cd8fe30 RDI: 0000000000000001
RBP: 000056549cd8fe30 R08: 0000000000002000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
R13: 0000000000000002 R14: 0000000000000000 R15: 000056549cd8f7e8
 </TASK>
-8<------------------------------------------------------------------

Thanks again,
Kevin
