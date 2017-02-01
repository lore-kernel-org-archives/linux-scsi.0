From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3] scsi, block: fix duplicate bdi name registration crashes
Date: Wed, 1 Feb 2017 14:40:17 -0800
Message-ID: <CAPcyv4jC5mVednFh8crsa0-GGFyPPEBKHUz5itCQ_4Tc1tX6Ew@mail.gmail.com>
References: <148598661794.11527.10024529085859239448.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e331cf91-37a2-d886-1136-4f33279e65ad@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e331cf91-37a2-d886-1136-4f33279e65ad@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 1, 2017 at 2:35 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 02/01/2017 02:05 PM, Dan Williams wrote:
>> Warnings of the following form occur because scsi reuses a devt number
>> while the block layer still has it referenced as the name of the bdi
>> [1]:
>>
>>  WARNING: CPU: 1 PID: 93 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x62/0x80
>>  sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:192'
>>  [..]
>>  Call Trace:
>>   dump_stack+0x86/0xc3
>>   __warn+0xcb/0xf0
>>   warn_slowpath_fmt+0x5f/0x80
>>   ? kernfs_path_from_node+0x4f/0x60
>>   sysfs_warn_dup+0x62/0x80
>>   sysfs_create_dir_ns+0x77/0x90
>>   kobject_add_internal+0xb2/0x350
>>   kobject_add+0x75/0xd0
>>   device_add+0x15a/0x650
>>   device_create_groups_vargs+0xe0/0xf0
>>   device_create_vargs+0x1c/0x20
>>   bdi_register+0x90/0x240
>>   ? lockdep_init_map+0x57/0x200
>>   bdi_register_owner+0x36/0x60
>>   device_add_disk+0x1bb/0x4e0
>>   ? __pm_runtime_use_autosuspend+0x5c/0x70
>>   sd_probe_async+0x10d/0x1c0
>>   async_run_entry_fn+0x39/0x170
>>
>> This is a brute-force fix to pass the devt release information from
>> sd_probe() to the locations where we register the bdi,
>> device_add_disk(), and unregister the bdi, blk_cleanup_queue().
>>
>> Thanks to Omar for the quick reproducer script [2]. This patch survives
>> where an unmodified kernel fails in a few seconds.
>
> What is the patch against? Doesn't seem to apply cleanly for me on
> master, nor the 4.11 block tree.
>

I built it on top of Jan's bdi fixes series [1]. I can rebase to
block/for-next, just let me know which patches you want to take first.

[1]: http://marc.info/?l=linux-block&m=148586843819160&w=2
