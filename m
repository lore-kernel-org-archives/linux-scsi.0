From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: WARNING: at drivers/ata/libata-core.c:5162 ata_qc_issue
Date: Sat, 23 Jan 2010 18:13:44 -0600
Message-ID: <51f3faa71001231613i5911e9d9pdb864abdc9470fc@mail.gmail.com>
References: <87d699441001202038m906038dgd7a849adabe8509@mail.gmail.com>
	 <4B5B60EB.8070302@gmail.com>
	 <87d699441001231448n7fe318a6q8e0964cc3817ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87d699441001231448n7fe318a6q8e0964cc3817ce@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 23, 2010 at 4:48 PM, Ilia Mirkin <imirkin@alum.mit.edu> wro=
te:
> On Sat, Jan 23, 2010 at 3:49 PM, Robert Hancock <hancockrwd@gmail.com=
> wrote:
>> On 01/20/2010 10:38 PM, Ilia Mirkin wrote:
>>>
>>> Hi,
>>>
>>> I recently set up a box with (basically) 2.6.32.2 (specifically
>>> gentoo-2.6.32-r1), and got the warning below when I started up smar=
td,
>>> which is set to scan all the devices. This machine has an Areca
>>> 1300ix-16 controller (mvsas driver, no raid), and a number of WDC
>>> WD20EADS-00S2B0 drives attached (2TB, SATA).
>>
>> That would appear to be this:
>>
>> =A0 =A0 =A0 =A0if (ata_is_ncq(prot)) {
>>
>> ..
>>
>> =A0 =A0 =A0 =A0} else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON_ONCE(link->sactive);
>>
>> which means that something (presumably smartd) was issuing a non-NCQ=
 command
>> while NCQ commands were active, which shouldn't be allowed. Some iss=
ue with
>> the NCQ defer behavior with mvsas?
>
> I'm not too familiar with how all of this works (libata, libsas,
> sata-over-sas, etc), but I'm happy to do any debugging necessary here
> -- the machine is not yet in production. Based on what you said, this
> sounds like a mvsas/libsas/not-libata issue, right? The reason I sent
> the report here was that libata-core.c was involved. I guess
> linux-scsi would be the better recipient of this then?

Most likely (I've added them to cc). I'm not too familiar with how the
libsas/libata interaction works, but at a higher level, the non-NCQ
command should have been deferred until the outstanding NCQ commands
had completed.

>
>>
>>>
>>> Please let me know if you need any other information.
>>>
>>> [706120.572560] ------------[ cut here ]------------
>>> [706120.572566] WARNING: at drivers/ata/libata-core.c:5162
>>> ata_qc_issue+0x11c/0x365()
>>> [706120.572568] Hardware name: X8DT6
>>> [706120.572569] Modules linked in: w83627hf hwmon_vid iTCO_wdt
>>> iTCO_vendor_support
>>> [706120.572575] Pid: 29946, comm: smartd Not tainted 2.6.32-gentoo-=
r1 #2
>>> [706120.572576] Call Trace:
>>> [706120.572582] =A0[<ffffffff812ed8db>] ? scsi_host_alloc_command+0=
x1b/0x62
>>> [706120.572584] =A0[<ffffffff81317e4f>] ? ata_qc_issue+0x11c/0x365
>>> [706120.572588] =A0[<ffffffff81068bec>] warn_slowpath_common+0x77/0=
xa4
>>> [706120.572591] =A0[<ffffffff8131c345>] ? ata_scsi_pass_thru+0x0/0x=
242
>>> [706120.572593] =A0[<ffffffff81068c28>] warn_slowpath_null+0xf/0x11
>>> [706120.572595] =A0[<ffffffff81317e4f>] ata_qc_issue+0x11c/0x365
>>> [706120.572598] =A0[<ffffffff8131c345>] ? ata_scsi_pass_thru+0x0/0x=
242
>>> [706120.572600] =A0[<ffffffff812ed1f1>] ? scsi_done+0x0/0x12
>>> [706120.572602] =A0[<ffffffff8131d5f1>] __ata_scsi_queuecmd+0x19e/0=
x1f8
>>> [706120.572605] =A0[<ffffffff812ed1f1>] ? scsi_done+0x0/0x12
>>> [706120.572607] =A0[<ffffffff8131d675>] ata_sas_queuecmd+0x2a/0x3c
>>> [706120.572611] =A0[<ffffffff813033f9>] sas_queuecommand+0x82/0x269
>>> [706120.572614] =A0[<ffffffff812ed4c7>] scsi_dispatch_cmd+0x1c3/0x2=
3e
>>> [706120.572617] =A0[<ffffffff812f2e2e>] scsi_request_fn+0x39f/0x4e9
>>> [706120.572622] =A0[<ffffffff8124a3ce>] __blk_run_queue+0x3d/0x71
>>> [706120.572625] =A0[<ffffffff81241e7d>] elv_insert+0xa5/0x248
>>> [706120.572627] =A0[<ffffffff812420ba>] __elv_add_request+0x9a/0xa2
>>> [706120.572630] =A0[<ffffffff8124d954>] blk_execute_rq_nowait+0x62/=
0x8c
>>> [706120.572632] =A0[<ffffffff8124da08>] blk_execute_rq+0x8a/0xae
>>> [706120.572636] =A0[<ffffffff8105cf95>] ? check_preempt_wakeup+0xf7=
/0x16b
>>> [706120.572639] =A0[<ffffffff8122f4db>] ? security_capable+0x27/0x2=
9
>>> [706120.572642] =A0[<ffffffff81250bfc>] sg_io+0x273/0x386
>>> [706120.572645] =A0[<ffffffff81065055>] ? default_wake_function+0xd=
/0xf
>>> [706120.572648] =A0[<ffffffff8125123b>] scsi_cmd_ioctl+0x20f/0x3e8
>>> [706120.572651] =A0[<ffffffff813a31a1>] ? sock_def_readable+0x3f/0x=
6c
>>> [706120.572654] =A0[<ffffffff8105e85e>] ? select_task_rq_fair+0x4b6=
/0x87e
>>> [706120.572656] =A0[<ffffffff8105def3>] ? enqueue_entity+0x25f/0x26=
b
>>> [706120.572660] =A0[<ffffffff8130b7af>] sd_ioctl+0xa2/0xc7
>>> [706120.572663] =A0[<ffffffff8124eb9e>] __blkdev_driver_ioctl+0x62/=
0x77
>>> [706120.572665] =A0[<ffffffff8124f398>] blkdev_ioctl+0x7e5/0x81d
>>> [706120.572668] =A0[<ffffffff81062cfd>] ? finish_task_switch+0x43/0=
xad
>>> [706120.572672] =A0[<ffffffff8112bc99>] ?
>>> fsnotify_clear_marks_by_inode+0x28/0xdd
>>> [706120.572675] =A0[<ffffffff810fb38c>] ? virt_to_head_page+0x9/0x2=
a
>>> [706120.572678] =A0[<ffffffff8139f7b8>] ? sock_destroy_inode+0x14/0=
x16
>>> [706120.572680] =A0[<ffffffff810fb38c>] ? virt_to_head_page+0x9/0x2=
a
>>> [706120.572683] =A0[<ffffffff81126f74>] block_ioctl+0x38/0x3c
>>> [706120.572686] =A0[<ffffffff8110f43c>] vfs_ioctl+0x2a/0x78
>>> [706120.572688] =A0[<ffffffff8110f971>] do_vfs_ioctl+0x46c/0x4ad
>>> [706120.572691] =A0[<ffffffff81104200>] ? __fput+0x1a9/0x1b8
>>> [706120.572694] =A0[<ffffffff8110fa07>] sys_ioctl+0x55/0x77
>>> [706120.572697] =A0[<ffffffff81031b2b>] system_call_fastpath+0x16/0=
x1b
>>> [706120.572699] ---[ end trace 77cd22c8c073dd64 ]---
>>>
>>> Thanks,
>>>
>>> --
>>> Ilia Mirkin
>>> imirkin@alum.mit.edu
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ide=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>
>
>
> --
> Ilia Mirkin
> imirkin@alum.mit.edu
>
