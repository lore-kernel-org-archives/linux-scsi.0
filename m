From: Andrew Robertson <andyrobertson101@gmail.com>
Subject: Re: Adaptec 71605H HBA randomly failing to detect any drives at init
Date: Mon, 18 May 2015 12:19:45 -0700
Message-ID: <CAKmTNed62q1qwJAvHmZyC53i7ee4T4mZJhwM_zB=XNrScy7iXg@mail.gmail.com>
References: <CAKmTNed2uSUGCDkxQSLofjgSGxLpZ154_gNpwt_NWChjR=s8iA@mail.gmail.com>
	<CAKmTNecfkgOoX6p_1MeV5vNac4N1KoGTjMRcWL2GV77piR8RUw@mail.gmail.com>
	<20140902160638.4824aff1@harpe.intellique.com>
	<CAKmTNecu+cRxGGuzLb2QJ7kcqF9rR5S271oUqnt2debZTJz0pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35309 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbbERTTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 15:19:47 -0400
Received: by wgfl8 with SMTP id l8so47691967wgf.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2015 12:19:45 -0700 (PDT)
In-Reply-To: <CAKmTNecu+cRxGGuzLb2QJ7kcqF9rR5S271oUqnt2debZTJz0pg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update for anyone who saw this and wonders what happened:

As more drives were added in, the systems got more and more unstable
at boot.  With <8 drives, it booted pretty every time. With 11 drives
(described in my original post), it failed at init ~3 out of 4 times.
Once I added the 12th drive I couldn't get it to come up any longer
even after a dozen or so reboots; there would be timeouts in the
pm80xx module, and no drives attached to that would show up.

One suggestion was to use shorter cables -- but I couldn't use any
cables shorter than 0.8m as that didn't fit in the chassis (supermicro
36-slot chassis).

I also tried the latest kernels to no avail, and also tried adjusting
the module init timeouts in the code to see if that made a difference
(no difference). The adaptec card was at the latest firmware (and
still is, there haven't been any updates), with the stock linux
drivers for the pm80xx card.

There was a comment that it's best to match the expander chip vendor
(LSI SAS2X28 & SAS2X36) with the hba vendor - so I ended up replacing
the adaptec 71605H with an LSI 9207=C2=AD-8i HBA (using a 1m cable to e=
ach
expander).  After the HBA swap, both (all) systems are working
perfectly.


On Fri, Sep 5, 2014 at 3:13 PM, Andrew Robertson
<andyrobertson101@gmail.com> wrote:
> More info, as requested:
>
> There are 2 sas expander chips in the system (LSI SAS2X28 & SAS2X36),
> and there's a connection to each of them from the 71605H via a
> separate 0.8m Adaptec cable. (Adaptec 2280200-R).  This is a
> Supermicro chassis.
>
> Firmware version:
> # cat /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.0/host0/scsi_ho=
st/host0/fw_version
> 02.08.60.01
>
> I don't have immediate physical access to the box, so I'm not able to
> do the hotplug logging test.  However, I did "reset" the PCI device
> via /sys, as shown below, and captured the logs from that (attached,
> "dmesg.out.txt").
>
> With the latest kernel, v3.17-rc3, I got a kernel "null pointer
> dereference" in the pm80xx module (dmesg output pasted in below).
>
> I will also try replacing the cables with 0.5m adaptec cables as
> suggested to see if that helps.
>
> ---
>
> Reset test:
>
> # find /sys -iname logging_level
> /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.0/host0/scsi_host/hos=
t0/logging_level
> # echo 0xfff > /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.0/host=
0/scsi_host/host0/logging_level
> # echo 1 > /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.0/rescan
> # echo 1 > /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.0/reset
> # sync
> (at which point the process hung; in the dmesg you can see a "sync
> blocked for more than 120 seconds")
>
>
> The disk/expander layout looks like:
> [0:0:0:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdb   /dev/=
sg1
> [0:0:1:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdc   /dev/=
sg2
> [0:0:2:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdd   /dev/=
sg3
> [0:0:3:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sde   /dev/=
sg4
> [0:0:4:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdf   /dev/=
sg5
> [0:0:5:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdg   /dev/=
sg6
> [0:0:6:0]    enclosu LSI      SAS2X36          0e12  -          /dev/=
sg7
> [0:0:7:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdh   /dev/=
sg8
> [0:0:8:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdi   /dev/=
sg9
> [0:0:9:0]    disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdj   /dev/=
sg10
> [0:0:10:0]   disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdk   /dev/=
sg11
> [0:0:11:0]   disk    ATA      WDC WD60EFRX-68M 82.0  /dev/sdl   /dev/=
sg12
> [0:0:12:0]   enclosu LSI      SAS2X28          0e12  -          /dev/=
sg13
>
>
> dmesg from latest kernel v3.17-rc3 showing (what appears to possibly
> be) a kernel bug:
>
> This happened right after I ran "lsscsi" (though can't say if it was
> actually caused by that).
>
> [  309.327805] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000290
> [  309.335829] IP: [<ffffffffc0080d4f>]
> pm8001_dev_gone_notify+0x2f/0x220 [pm80xx]
> [  309.343258] PGD 0
> [  309.345381] Oops: 0000 [#1] SMP
> [  309.348797] Modules linked in: ipmi_devintf autofs4 arc4 nfsd
> auth_rpcgss intel_rapl nfs_acl x86_pkg_temp_thermal nfs
> intel_powerclamp coretemp lockd kvm_intel sunrpc kvm fscache
> crct10dif_pclmul ttm crc32_pclmul drm_kms_helper rt2800usb
> ghash_clmulni_intel rt2x00usb rt2800lib rt2x00lib mac80211 aesni_inte=
l
> drm aes_x86_64 lrw gf128mul glue_helper ablk_helper cfg80211 cryptd
> crc_ccitt syscopyarea joydev sysfillrect sysimgblt shpchp lpc_ich
> ipmi_si ipmi_msghandler mac_hid video ie31200_edac edac_core lp
> parport ses enclosure hid_generic usbhid hid raid10 raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor igb
> raid6_pq i2c_algo_bit raid1 e1000e pm80xx dca raid0 libsas ahci ptp
> multipath scsi_transport_sas libahci pps_core linear
> [  309.420132] CPU: 5 PID: 1998 Comm: kworker/5:2 Not tainted
> 3.17.0-031700rc3-generic #201409031132
> [  309.429051] Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 2.0 =
04/24/2014
> [  309.436148] Workqueue: pm80xx pm8001_work_fn [pm80xx]
> [  309.441317] task: ffff880403690000 ti: ffff880404fa4000 task.ti:
> ffff880404fa4000
> [  309.448867] RIP: 0010:[<ffffffffc0080d4f>]  [<ffffffffc0080d4f>]
> pm8001_dev_gone_notify+0x2f/0x220 [pm80xx]
> [  309.458765] RSP: 0018:ffff880404fa7cd8  EFLAGS: 00010286
> [  309.464145] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000=
00000006e02
> [  309.471342] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff8=
80403e98000
> [  309.478546] RBP: ffff880404fa7d18 R08: ffff880404fa4000 R09: 00000=
00000000000
> [  309.485749] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
804022b8000
> [  309.492954] R13: ffff880403e98000 R14: ffff880401b80180 R15: 00000=
00000000000
> [  309.500163] FS:  0000000000000000(0000) GS:ffff88041fd40000(0000)
> knlGS:0000000000000000
> [  309.508337] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  309.514147] CR2: 0000000000000290 CR3: 0000000001c16000 CR4: 00000=
000001407e0
> [  309.521348] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [  309.528551] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> [  309.535752] Stack:
> [  309.537837]  ffff8804022b8000 ffff880401bbe000 ffff880401b80180
> ffff880403e98000
> [  309.545599]  ffff8804022b8000 ffff880401bbe000 ffff880401b80180
> 0000000000000000
> [  309.553349]  ffff880404fa7d78 ffffffffc00826e8 ffff880404fa7d78
> ffffffff810ababc
> [  309.561091] Call Trace:
> [  309.563611]  [<ffffffffc00826e8>]
> pm8001_I_T_nexus_event_handler+0xb8/0x1f0 [pm80xx]
> [  309.571449]  [<ffffffff810ababc>] ? put_prev_entity+0x3c/0x320
> [  309.577355]  [<ffffffffc0084559>] pm8001_work_fn+0x299/0x480 [pm80=
xx]
> [  309.583869]  [<ffffffff8108ce6f>] process_one_work+0x17f/0x490
> [  309.589773]  [<ffffffff8108d7eb>] worker_thread+0x11b/0x3f0
> [  309.595413]  [<ffffffff8108d6d0>] ? create_worker+0x1e0/0x1e0
> [  309.601225]  [<ffffffff81093349>] kthread+0xc9/0xe0
> [  309.606176]  [<ffffffff81093280>] ? flush_kthread_worker+0x90/0x90
> [  309.612421]  [<ffffffff817a3f3c>] ret_from_fork+0x7c/0xb0
> [  309.617890]  [<ffffffff81093280>] ? flush_kthread_worker+0x90/0x90
> [  309.624135] Code: 00 55 48 89 e5 48 83 ec 40 4c 89 6d e8 4c 89 75
> f0 49 89 fd 4c 89 7d f8 48 89 5d d8 4c 89 65 e0 48 8b 47 30 48
> 8b 9f 78 01 00 00 <48> 8b 80 90 02 00 00 4c 8b a0 90 01 00 00 4d 8d 7=
4
> 24 38 4c 89
> [  309.647551] RIP  [<ffffffffc0080d4f>]
> pm8001_dev_gone_notify+0x2f/0x220 [pm80xx]
> [  309.655100]  RSP <ffff880404fa7cd8>
> [  309.658657] CR2: 0000000000000290
> [  309.662045] ---[ end trace 084eaa8941942e9a ]---
> [  309.770413] BUG: unable to handle kernel paging request at fffffff=
fffffffd8
> [  309.777578] IP: [<ffffffff810936e0>] kthread_data+0x10/0x20
> [  309.783287] PGD 1c19067 PUD 1c1b067 PMD 0
> [  309.787652] Oops: 0000 [#2] SMP
> [  309.791080] Modules linked in: ipmi_devintf autofs4 arc4 nfsd
> auth_rpcgss intel_rapl nfs_acl x86_pkg_temp_thermal nfs
> intel_powerclamp coretemp lockd kvm_intel sunrpc kvm fscache
> crct10dif_pclmul ttm crc32_pclmul drm_kms_helper rt2800usb
> ghash_clmulni_intel rt2x00usb rt2800lib rt2x00lib mac80211 aesni_inte=
l
> drm aes_x86_64 lrw gf128mul glue_helper ablk_helper cfg80211 cryptd
> crc_ccitt syscopyarea joydev sysfillrect sysimgblt shpchp lpc_ich
> ipmi_si ipmi_msghandler mac_hid video ie31200_edac edac_core lp
> parport ses enclosure hid_generic usbhid hid raid10 raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor igb
> raid6_pq i2c_algo_bit raid1 e1000e pm80xx dca raid0 libsas ahci ptp
> multipath scsi_transport_sas libahci pps_core linear
> [  309.862627] CPU: 5 PID: 1998 Comm: kworker/5:2 Tainted: G      D
>     3.17.0-031700rc3-generic #201409031132
> [  309.872709] Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 2.0 =
04/24/2014
> [  309.879834] task: ffff880403690000 ti: ffff880404fa4000 task.ti:
> ffff880404fa4000
> [  309.887407] RIP: 0010:[<ffffffff810936e0>]  [<ffffffff810936e0>]
> kthread_data+0x10/0x20
> [  309.895562] RSP: 0018:ffff880404fa78e8  EFLAGS: 00010092
> [  309.900939] RAX: 0000000000000000 RBX: 0000000000000005 RCX: fffff=
fff81ec2e80
> [  309.908139] RDX: 0000000000000000 RSI: 0000000000000005 RDI: ffff8=
80403690000
> [  309.915343] RBP: ffff880404fa78e8 R08: 0000000000000000 R09: 00000=
00000000246
> [  309.922549] R10: 000000000000001a R11: 0000000000000013 R12: 00000=
00000000005
> [  309.929749] R13: ffff880403690538 R14: 0000000000000001 R15: 00000=
00000000046
> [  309.936953] FS:  0000000000000000(0000) GS:ffff88041fd40000(0000)
> knlGS:0000000000000000
> [  309.945130] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  309.950942] CR2: 0000000000000028 CR3: 0000000001c16000 CR4: 00000=
000001407e0
> [  309.958140] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [  309.965345] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> [  309.972548] Stack:
> [  309.974632]  ffff880404fa7908 ffffffff8108e725 ffff880404fa7908
> ffff88041fd545c0
> [  309.982368]  ffff880404fa7988 ffffffff8179f8b3 ffff880404fa7948
> ffff880403690000
> [  309.990110]  ffff880404fa7fd8 00000000000145c0 ffff880404fa7948
> 00000000000145c0
> [  309.997858] Call Trace:
> [  310.000377]  [<ffffffff8108e725>] wq_worker_sleeping+0x15/0xb0
> [  310.006281]  [<ffffffff8179f8b3>] __schedule+0x5e3/0x770
> [  310.011666]  [<ffffffff8179fb19>] schedule+0x29/0x70
> [  310.016704]  [<ffffffff81077795>] do_exit+0x2a5/0x470
> [  310.021830]  [<ffffffff810c9fbc>] ? kmsg_dump+0x9c/0xc0
> [  310.027128]  [<ffffffff81018d08>] oops_end+0xb8/0x160
> [  310.032253]  [<ffffffff81788489>] no_context+0x1be/0x1cd
> [  310.037631]  [<ffffffff8178866b>] __bad_area_nosemaphore+0x1d3/0x1=
f2
> [  310.044059]  [<ffffffff810ababc>] ? put_prev_entity+0x3c/0x320
> [  310.049962]  [<ffffffff8178869d>] bad_area_nosemaphore+0x13/0x15
> [  310.056043]  [<ffffffff81062312>] __do_page_fault+0x3b2/0x550
> [  310.061856]  [<ffffffff810ae3aa>] ? idle_balance+0x7a/0x2c0
> [  310.067493]  [<ffffffff810ababc>] ? put_prev_entity+0x3c/0x320
> [  310.073399]  [<ffffffff810135c6>] ? __switch_to+0xf6/0x5b0
> [  310.078960]  [<ffffffff8106263e>] do_page_fault+0x3e/0x80
> [  310.084431]  [<ffffffff817a6088>] page_fault+0x28/0x30
> [  310.089643]  [<ffffffffc0080d4f>] ?
> pm8001_dev_gone_notify+0x2f/0x220 [pm80xx]
> [  310.096957]  [<ffffffffc00826e8>]
> pm8001_I_T_nexus_event_handler+0xb8/0x1f0 [pm80xx]
> [  310.104791]  [<ffffffff810ababc>] ? put_prev_entity+0x3c/0x320
> [  310.110691]  [<ffffffffc0084559>] pm8001_work_fn+0x299/0x480 [pm80=
xx]
> [  310.117205]  [<ffffffff8108ce6f>] process_one_work+0x17f/0x490
> [  310.123106]  [<ffffffff8108d7eb>] worker_thread+0x11b/0x3f0
> [  310.128752]  [<ffffffff8108d6d0>] ? create_worker+0x1e0/0x1e0
> [  310.134572]  [<ffffffff81093349>] kthread+0xc9/0xe0
> [  310.139519]  [<ffffffff81093280>] ? flush_kthread_worker+0x90/0x90
> [  310.145763]  [<ffffffff817a3f3c>] ret_from_fork+0x7c/0xb0
> [  310.151227]  [<ffffffff81093280>] ? flush_kthread_worker+0x90/0x90
> [  310.157473] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
> c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 c8 04 00 00
> 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 4=
4
> 00 00
> [  310.180886] RIP  [<ffffffff810936e0>] kthread_data+0x10/0x20
> [  310.186679]  RSP <ffff880404fa78e8>
> [  310.190239] CR2: ffffffffffffffd8
> [  310.193623] ---[ end trace 084eaa8941942e9b ]---
> [  310.306147] Fixing recursive fault but reboot is needed!
>
>
> On Wed, Sep 3, 2014 at 12:06 AM, Emmanuel Florac <eflorac@intellique.=
com> wrote:
>> Le Mon, 1 Sep 2014 09:06:46 -0700
>> Andrew Robertson <andyrobertson101@gmail.com> =C3=A9crivait:
>>
>>> I'm happy to test patches/etc on this system if necessary -- and/or=
 if
>>> someone can help point me in the right direction, I'd appreciate it=
=2E
>>
>> In my experience the 7xxx5 are very sensitive to cable length and
>> backplane type: basically work fine with 50 cm cables, and fails wit=
h 80
>> cm cables with some backplanes (works with Supermicro, not with AIC,
>> etc).
>>
>> So what is the backplane and cables you're using?
>>
>> --
>> --------------------------------------------------------------------=
----
>> Emmanuel Florac     |   Direction technique
>>                     |   Intellique
>>                     |   <eflorac@intellique.com>
>>                     |   +33 1 78 94 84 02
>> --------------------------------------------------------------------=
----
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
