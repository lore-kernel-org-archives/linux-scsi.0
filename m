From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request
 V2
Date: Tue, 31 Jan 2017 01:12:46 +0000
Message-ID: <1485825148.2669.18.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485456745.2540.9.camel@sandisk.com>
         <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
         <20170126185924.GA25289@lst.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2c696943-2a44-4f36-f0f8-0bebceb95a4a@fb.com>
Content-Language: en-US
Content-ID: <D87C0F94E9440E4BB26E450E2E9649DA@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-01-27 at 09:56 -0700, Jens Axboe wrote:
> On 01/27/2017 09:52 AM, Bart Van Assche wrote:
> > [  215.724452] general protection fault: 0000 [#1] SMP
> > [  215.725060] Call Trace:
> > [  215.725086]  scsi_disk_put+0x2d/0x40
> > [  215.725110]  sd_release+0x3d/0xb0
> > [  215.725137]  __blkdev_put+0x29e/0x360
> > [  215.725163]  blkdev_put+0x49/0x170
> > [  215.725192]  dm_put_table_device+0x58/0xc0 [dm_mod]
> > [  215.725219]  dm_put_device+0x70/0xc0 [dm_mod]
> > [  215.725269]  free_priority_group+0x92/0xc0 [dm_multipath]
> > [  215.725295]  free_multipath+0x70/0xc0 [dm_multipath]
> > [  215.725320]  multipath_dtr+0x19/0x20 [dm_multipath]
> > [  215.725348]  dm_table_destroy+0x67/0x120 [dm_mod]
> > [  215.725379]  dev_suspend+0xde/0x240 [dm_mod]
> > [  215.725434]  ctl_ioctl+0x1f5/0x520 [dm_mod]
> > [  215.725489]  dm_ctl_ioctl+0xe/0x20 [dm_mod]
> > [  215.725515]  do_vfs_ioctl+0x8f/0x700
> > [  215.725589]  SyS_ioctl+0x3c/0x70
> > [  215.725614]  entry_SYSCALL_64_fastpath+0x18/0xad
> >=20
>=20
> I have no idea what this is, I haven't messed with life time or devices
> or queues at all in that branch.

Hello Jens,

Running the srp-test software against kernel 4.9.6 and kernel 4.10-rc5
went fine. With your for-4.11/block branch (commit 400f73b23f457a) however
I just ran into the following:

[ =A0214.555527] ------------[ cut here ]------------
[ =A0214.555565] WARNING: CPU: 5 PID: 13201 at kernel/locking/lockdep.c:351=
4 lock_release+0x346/0x480
[ =A0214.555588] DEBUG_LOCKS_WARN_ON(depth <=3D 0)
[ =A0214.555824] CPU: 5 PID: 13201 Comm: fio Not tainted 4.10.0-rc3-dbg+ #1
[ =A0214.555846] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2=
 11/17/2014
[ =A0214.555867] Call Trace:
[ =A0214.555889] =A0dump_stack+0x68/0x93
[ =A0214.555911] =A0__warn+0xc6/0xe0
[ =A0214.555953] =A0warn_slowpath_fmt+0x4a/0x50
[ =A0214.555973] =A0lock_release+0x346/0x480
[ =A0214.556021] =A0aio_write+0x106/0x140
[ =A0214.556067] =A0do_io_submit+0x37d/0x900
[ =A0214.556108] =A0SyS_io_submit+0xb/0x10
[ =A0214.556131] =A0entry_SYSCALL_64_fastpath+0x18/0xad

I will continue to try to figure out what is causing this behavior.

Bart.=
