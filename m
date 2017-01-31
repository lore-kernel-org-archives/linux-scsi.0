From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Mon, 30 Jan 2017 20:13:08 -0800
Message-ID: <fad65be8-fc13-446d-470d-9a4a8db547df@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
	<1485467235.2540.14.camel@sandisk.com>
	<e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
	<1485472465.2540.19.camel@sandisk.com>
	<e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
	<1485474426.2540.25.camel@sandisk.com>
	<b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
	<1485477510.2540.27.camel@sandisk.com>
	<2d971693-b79d-c1b9-fb2a-f5dd04128c68@fb.com>
	<1485479738.2540.30.camel@sandisk.com>
	<ecca734c-7a9c-f060-9335-c2de089849c2@fb.com>
	<37ab009a-bc2d-d2ae-a875-269ab563a430@fb.com>
	<9cbf0ce5-ed79-0252-fd2d-34bebaafffa3@fb.com>
	<1485535925.4267.1.camel@sandisk.com>
	<2c696943-2a44-4f36-f0f8-0bebceb95a4a@fb.com>
	<1485825148.2669.18.camel@sandisk.com>
	<4D024E85-CDE7-4FB0-B8CA-F2B8C86CCFCB@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D024E85-CDE7-4FB0-B8CA-F2B8C86CCFCB@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 01/30/2017 05:38 PM, Jens Axboe wrote:
> 
> 
>> On Jan 30, 2017, at 5:12 PM, Bart Van Assche <Bart.VanAssche@sandisk.com> wrote:
>>
>>> On Fri, 2017-01-27 at 09:56 -0700, Jens Axboe wrote:
>>>> On 01/27/2017 09:52 AM, Bart Van Assche wrote:
>>>> [  215.724452] general protection fault: 0000 [#1] SMP
>>>> [  215.725060] Call Trace:
>>>> [  215.725086]  scsi_disk_put+0x2d/0x40
>>>> [  215.725110]  sd_release+0x3d/0xb0
>>>> [  215.725137]  __blkdev_put+0x29e/0x360
>>>> [  215.725163]  blkdev_put+0x49/0x170
>>>> [  215.725192]  dm_put_table_device+0x58/0xc0 [dm_mod]
>>>> [  215.725219]  dm_put_device+0x70/0xc0 [dm_mod]
>>>> [  215.725269]  free_priority_group+0x92/0xc0 [dm_multipath]
>>>> [  215.725295]  free_multipath+0x70/0xc0 [dm_multipath]
>>>> [  215.725320]  multipath_dtr+0x19/0x20 [dm_multipath]
>>>> [  215.725348]  dm_table_destroy+0x67/0x120 [dm_mod]
>>>> [  215.725379]  dev_suspend+0xde/0x240 [dm_mod]
>>>> [  215.725434]  ctl_ioctl+0x1f5/0x520 [dm_mod]
>>>> [  215.725489]  dm_ctl_ioctl+0xe/0x20 [dm_mod]
>>>> [  215.725515]  do_vfs_ioctl+0x8f/0x700
>>>> [  215.725589]  SyS_ioctl+0x3c/0x70
>>>> [  215.725614]  entry_SYSCALL_64_fastpath+0x18/0xad
>>>>
>>>
>>> I have no idea what this is, I haven't messed with life time or devices
>>> or queues at all in that branch.
>>
>> Hello Jens,
>>
>> Running the srp-test software against kernel 4.9.6 and kernel 4.10-rc5
>> went fine. With your for-4.11/block branch (commit 400f73b23f457a) however
>> I just ran into the following:
>>
>> [  214.555527] ------------[ cut here ]------------
>> [  214.555565] WARNING: CPU: 5 PID: 13201 at kernel/locking/lockdep.c:3514 lock_release+0x346/0x480
>> [  214.555588] DEBUG_LOCKS_WARN_ON(depth <= 0)
>> [  214.555824] CPU: 5 PID: 13201 Comm: fio Not tainted 4.10.0-rc3-dbg+ #1
>> [  214.555846] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
>> [  214.555867] Call Trace:
>> [  214.555889]  dump_stack+0x68/0x93
>> [  214.555911]  __warn+0xc6/0xe0
>> [  214.555953]  warn_slowpath_fmt+0x4a/0x50
>> [  214.555973]  lock_release+0x346/0x480
>> [  214.556021]  aio_write+0x106/0x140
>> [  214.556067]  do_io_submit+0x37d/0x900
>> [  214.556108]  SyS_io_submit+0xb/0x10
>> [  214.556131]  entry_SYSCALL_64_fastpath+0x18/0xad
>>
>> I will continue to try to figure out what is causing this behavior.
> 
> That's a known bug in mainline. Pull it into 4.10-rc6,
> or use my for-next where everything is already merged.

Since I'm not on the phone anymore, this is the commit that was
merged after my for-4.11/block was forked, which fixes this issue:

commit a12f1ae61c489076a9aeb90bddca7722bf330df3
Author: Shaohua Li <shli@fb.com>
Date:   Tue Dec 13 12:09:56 2016 -0800

    aio: fix lock dep warning

So you can just pull that in, if you want, or do what I suggested above.

-- 
Jens Axboe
