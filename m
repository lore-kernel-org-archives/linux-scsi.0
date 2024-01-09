Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [107.191.43.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45A13C6BF
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 21:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kevinlocke.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kevinlocke.name
Received: from kevinolos.kevinlocke.name (071-015-196-093.res.spectrum.com [71.15.196.93])
	(Authenticated sender: kevin@kevinlocke.name)
	by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 0CD5040CE447;
	Tue,  9 Jan 2024 21:45:42 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
	id 2DD8B1300489; Tue,  9 Jan 2024 14:45:40 -0700 (MST)
Date: Tue, 9 Jan 2024 14:45:40 -0700
From: Kevin Locke <kevin@kevinlocke.name>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Message-ID: <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
 <ZZxvPtrf5hLeZNY5@kevinlocke.name>
 <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>

On Tue, 2024-01-09 at 13:39 -0800, Bart Van Assche wrote:
> On 1/8/24 13:55, Kevin Locke wrote:
>> -8<------------------------------------------------------------------
>> sd 1:0:0:0: [sdb] Synchronizing SCSI cache
>> ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>> ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>> ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>> ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>> ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>> ata2.00: configured for UDMA/133
>> ata2.00: retrying FLUSH 0xea Emask 0x0
>> sysrq: Show Blocked State
>> task:ultrabay_eject  state:D stack:0     pid:2630  tgid:2630  ppid:2629   flags:0x00004002
>> Call Trace:
>>   <TASK>
>>   __schedule+0x2c1/0x8a0
>>   schedule+0x32/0xb0
>>   schedule_timeout+0x151/0x160
>>   io_schedule_timeout+0x50/0x80
>>   wait_for_completion_io+0x86/0x170
>>   blk_execute_rq+0x11e/0x1f0
>>   scsi_execute_cmd+0xf6/0x250 [scsi_mod]
>>   sd_sync_cache+0xe6/0x1f0 [sd_mod]
>>   sd_shutdown+0x68/0x100 [sd_mod]
>>   sd_remove+0x55/0x60 [sd_mod]
>>   device_release_driver_internal+0x19f/0x200
>>   bus_remove_device+0xc6/0x130
>>   device_del+0x15e/0x3f0
>>   ? mutex_lock+0x12/0x30
>>   ? __pfx_ata_tdev_match+0x10/0x10 [libata]
>>   __scsi_remove_device+0x131/0x190 [scsi_mod]
>>   sdev_store_delete+0x6a/0xd0 [scsi_mod]
>>   kernfs_fop_write_iter+0x13d/0x1d0
>>   vfs_write+0x23d/0x400
>>   ksys_write+0x6f/0xf0
>>   do_syscall_64+0x64/0x120
>>   ? exc_page_fault+0x70/0x150
>>   entry_SYSCALL_64_after_hwframe+0x6e/0x76
> 
> I think this means that the block layer is waiting for the completion of
> the SYNCHRONIZE CACHE command. Can you please also share the SCSI host and
> device states after the hang has been reproduced, e.g. by sharing the output
> of the following commands (these commands require the bash shell)?
> 
> (cd /sys/class/scsi_host && grep -aH . */state)
> (cd /sys/class/scsi_device && grep -aH . */device/{device_{blocked,busy},state})

Sure thing.  Running the above commands produced the following output:

host0/state:running
host1/state:running
host2/state:running
host3/state:running
host4/state:running
host5/state:running
0:0:0:0/device/device_blocked:0
0:0:0:0/device/device_busy:1
0:0:0:0/device/state:running

Thanks for your help,
Kevin
