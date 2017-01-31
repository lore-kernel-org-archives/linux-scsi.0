From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request V2
Date: Tue, 31 Jan 2017 13:58:35 -0800
Message-ID: <2085a3e6-25fc-d104-35cb-38995d154fd2@kernel.dk>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
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
 <1485898487.3113.7.camel@sandisk.com> <1485899692.3113.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35938 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdAaV6k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 16:58:40 -0500
Received: by mail-qk0-f177.google.com with SMTP id 11so179574362qkl.3
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2017 13:58:39 -0800 (PST)
In-Reply-To: <1485899692.3113.9.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On 01/31/2017 01:55 PM, Bart Van Assche wrote:
> On Tue, 2017-01-31 at 13:34 -0800, Bart Van Assche wrote:
>> On Mon, 2017-01-30 at 17:38 -0800, Jens Axboe wrote:
>>> That's a known bug in mainline. Pull it into 4.10-rc6,
>>> or use my for-next where everything is already merged. 
>>
>> Hello Jens,
>>
>> With your for-next branch (commit c2e60b3a2602) I haven't hit any block
>> layer crashes so far. The only issue I encountered that is new is a
>> memory leak triggered by the SG-IO code. These memory leak reports
>> started to appear after I started testing the mq-deadline scheduler.
>> kmemleak reported the following call stack multiple times after my tests
>> had finished:
>>
>> unreferenced object 0xffff88041119e528 (size 192):
>>   comm "multipathd", pid 2353, jiffies 4295128020 (age 1332.440s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 12 01 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffff8165e3b5>] kmemleak_alloc+0x45/0xa0
>>     [<ffffffff811cc23d>] __kmalloc+0x15d/0x2f0
>>     [<ffffffff81310e35>] bio_alloc_bioset+0x185/0x1f0
>>     [<ffffffff813117f4>] bio_map_user_iov+0x124/0x400
>>     [<ffffffff81320b7a>] blk_rq_map_user_iov+0x11a/0x210
>>     [<ffffffff81320cbd>] blk_rq_map_user+0x4d/0x60
>>     [<ffffffff81336694>] sg_io+0x3d4/0x410
>>     [<ffffffff813369d0>] scsi_cmd_ioctl+0x300/0x490
>>     [<ffffffff81336b9d>] scsi_cmd_blk_ioctl+0x3d/0x50
>>     [<ffffffff814b4360>] sd_ioctl+0x80/0x100
>>     [<ffffffff8132ddde>] blkdev_ioctl+0x51e/0x9f0
>>     [<ffffffff8122f388>] block_ioctl+0x38/0x40
>>     [<ffffffff8120097f>] do_vfs_ioctl+0x8f/0x700
>>     [<ffffffff8120102c>] SyS_ioctl+0x3c/0x70
>>     [<ffffffff8166c4aa>] entry_SYSCALL_64_fastpath+0x18/0xad
> 
> After I repeated my test the above findings were confirmed: no memory leaks
> were reported by kmemleak after a test with I/O scheduler "none" and the
> above call stack was reported 44 times by kmemleak after a test with I/O
> scheduler "mq-deadline".

Interesting, I'll check this. Doesn't make any sense why the scheduler
would be implicated in that, given how we run completions now. But if
it complains, then something must be up.

-- 
Jens Axboe
