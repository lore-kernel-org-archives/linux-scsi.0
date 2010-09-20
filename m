From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Tue, 21 Sep 2010 00:38:10 +0300
Message-ID: <4C97D442.2070202@gmail.com>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com> <20100903221303.GA9527@localhost.localdomain> <4C876B47.50805@gmail.com> <4C88BBB2.8080309@gmail.com> <4C88EBA0.3000100@redhat.com> <4C8BA6F8.7040807@gmail.com> <4C90CED0.6010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33744 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab0ITVob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2010 17:44:31 -0400
Received: by wyf22 with SMTP id 22so4798996wyf.19
        for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2010 14:44:29 -0700 (PDT)
In-Reply-To: <4C90CED0.6010109@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, Wouter Naaktgeboren <wouter_naaktgeboren@xs4all.nl>

  On 15/9/2010 4:49 =CE=BC=CE=BC, David Milburn wrote:
> Konstantinos Skarlatos wrote:
>>  Unfortunately after some heavy io and use of hddtemp/smartmontools,=
=20
>> i got this:
>>
>>
>> ------------[ cut here ]------------
>> WARNING: at drivers/ata/libata-core.c:5124 ata_qc_issue+0x30b/0x320=20
>> [libata]()
>
After all it turns out that I did not have the patched module loaded=20
during that test. After making sure that the correct module is loaded,=20
and tons of testing, I can now say that this patch solves this issue an=
d=20
mvsas is from now on a very usable and stable driver.

Thanks David :)


> This does look like the same warning from ata_qc_issue(), it is=20
> complaining
> that a non-NCQ command is sent down but there is already an active
> NCQ command on the link.
>
> With the patch ata_scsi_translate would check ata_std_qc_defer (qc_de=
fer)
> which should have deferred the command since it was a non-NCQ and
> there was already an active NCQ command (link->sactive). I thought th=
is
> would definitely prevent this case.
>
> Thanks,
> David
>
>
>> Hardware name:
>> Modules linked in: aufs exportfs ipv6 hwmon_vid jfs cpufreq_powersav=
e=20
>> evdev fan usbhid firewire_ohci psmouse serio_raw pcspkr hid=20
>> firewire_core button crc_itu_t cpufreq_ondemand thermal skge sg=20
>> k8temp powernow_k8 freq_table i2c_nforce2 i2c_core processor mperf=20
>> edac_core edac_mce_amd fuse forcedeth rtc_cmos rtc_core rtc_lib ext2=
=20
>> mbcache dm_crypt dm_mod ses enclosure sd_mod usb_storage mvsas=20
>> ohci_hcd libsas sata_sil ehci_hcd scsi_transport_sas sata_nv usbcore=
=20
>> pata_amd sata_via ata_generic pata_via pata_acpi libata scsi_mod
>> Pid: 2592, comm: hddtemp Not tainted 2.6.35-ARCH #1
>> Call Trace:
>>  [<ffffffff8105284a>] warn_slowpath_common+0x7a/0xb0
>>  [<ffffffff81052895>] warn_slowpath_null+0x15/0x20
>>  [<ffffffffa00334fb>] ata_qc_issue+0x30b/0x320 [libata]
>>  [<ffffffffa000828d>] ? scsi_init_sgtable+0x4d/0x90 [scsi_mod]
>>  [<ffffffffa003ae10>] ? ata_scsi_pass_thru+0x0/0x2e0 [libata]
>>  [<ffffffffa0039126>] ata_scsi_translate+0xa6/0x180 [libata]
>>  [<ffffffffa00020f0>] ? scsi_done+0x0/0x90 [scsi_mod]
>>  [<ffffffffa00020f0>] ? scsi_done+0x0/0x90 [scsi_mod]
>>  [<ffffffffa003c390>] ata_sas_queuecmd+0x100/0x270 [libata]
>>  [<ffffffffa013c6f8>] sas_queuecommand+0x98/0x300 [libsas]
>>  [<ffffffffa000296d>] scsi_dispatch_cmd+0xfd/0x320 [scsi_mod]
>>  [<ffffffffa00096d2>] scsi_request_fn+0x322/0x410 [scsi_mod]
>>  [<ffffffff81062a66>] ? lock_timer_base.clone.26+0x36/0x70
>>  [<ffffffff811b8b2e>] __blk_run_queue+0x5e/0x160
>>  [<ffffffff811b2aba>] elv_insert+0x18a/0x270
>>  [<ffffffff811b2c02>] __elv_add_request+0x62/0xc0
>>  [<ffffffff811bd3f0>] blk_execute_rq_nowait+0x60/0xb0
>>  [<ffffffff811bd4c1>] blk_execute_rq+0x81/0xf0
>>  [<ffffffff811bd274>] ? blk_rq_map_user+0x194/0x270
>>  [<ffffffff811c1a9a>] sg_io+0x28a/0x3d0
>>  [<ffffffff811c2245>] scsi_cmd_ioctl+0x255/0x4a0
>>  [<ffffffff811a243a>] ? security_inode_permission+0x1a/0x20
>>  [<ffffffffa0003bdc>] ? scsi_ioctl+0x27c/0x3a0 [scsi_mod]
>>  [<ffffffffa017ee80>] sd_ioctl+0x90/0xe0 [sd_mod]
>>  [<ffffffff811bf0df>] __blkdev_driver_ioctl+0x8f/0xb0
>>  [<ffffffff811bf5c6>] blkdev_ioctl+0x236/0x7f0
>>  [<ffffffff81151fcc>] block_ioctl+0x3c/0x40
>>  [<ffffffff8113351c>] vfs_ioctl+0x3c/0xd0
>>  [<ffffffff81133b1c>] do_vfs_ioctl+0x7c/0x520
>>  [<ffffffff81134041>] sys_ioctl+0x81/0xa0
>>  [<ffffffff81009e82>] system_call_fastpath+0x16/0x1b
>> ---[ end trace fc0747b97329c42f ]---
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
