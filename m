From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's
 missing?
Date: Thu, 19 Jan 2012 09:16:51 +0100
Message-ID: <5905c624d943d1f90239deec28357cd2.squirrel@webmail.sf-mail.de>
References: <4EF2026F.2090506@redhat.com>
    <CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com>
    <4F1706AD.3080405@redhat.com>
    <CAL1RGDXDaeNG_YVC38f4nxvBA+btbypcW=1KyEzm90UQOw3HiQ@mail.gmail.com>
    <CAO+b5-qHGLXr7HtzV9R81sk8=h_L2i9-pR+uZ7yrGiKktsGZUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:39835 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab2ASIRI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 03:17:08 -0500
Received: from a124.reverse.yawsp.de ([::ffff:62.27.20.124] HELO mail.sf-mail.de)
	by mail.sf-mail.de (Qsmtpd 0.21svn) with (DHE-RSA-AES256-SHA encrypted) ESMTPS
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2012 08:17:06 +0000
In-Reply-To: <CAO+b5-qHGLXr7HtzV9R81sk8=h_L2i9-pR+uZ7yrGiKktsGZUQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>, Ric Wheeler <rwheeler@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> On Wed, Jan 18, 2012 at 6:46 PM, Roland Dreier <roland@purestorage.com>
> wrote:
>> > Why would you crash is you have device mapper multipath configured to
>> handle
>> > path fail over? We have tons of enterprise customers that use that...
>>
>> cf http://www.spinics.net/lists/linux-scsi/msg56254.html
>>
>> Basically hot unplug of an sdX can oops on any recent kernel, no
>> matter what dm stuff you have on top.
>>
>> > On the broader topic of error handling and so on, I do agree that is
>> always
>> > an area of concern (how many times to retry, how long time outs need
>> to be,
>> > when to panic/reboot or propagate up an error code)
>>
>> Yes, especially the scsi eh stuff escalating to a host reset when
>> a single drive has gone bad -- even if the HBA is happily doing IO
>> to other drives, we'll kill access to the whole SAS fabric.
>
> With which SCSI low-level diver does that occur and how does the call
> stack look like ? I haven't encountered any such issues while testing
> the srp-ha patch set. However, I have to admit that the issues
> mentioned in the description of commit 3308511 were discovered while
> testing the srp-ha patch set.

Likely unrelated to the stuff above, but this has happened for me. I was
changing the USB devices while sending the machine to s2disk and this was
what it came up with on resume:

[91794.875373] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[91794.875385] IP: [<ffffffff813c46c1>] sd_revalidate_disk+0x31/0x320
[91794.875396] PGD 3fe33f067 PUD 3fff84067 PMD 0
[91794.875403] Oops: 0000 [#1] PREEMPT SMP
[91794.875410] CPU 7
[91794.875412] Modules linked in: autofs4 fuse ip6t_LOG xt_tcpudp
xt_pkttype ipt_LOG xt_limit af_packet edd ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw xt_NO
TRACK ipt_REJECT iptable_raw iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_connt
rack ip6table_filter ip6_tables x_tables snd_pcm_oss snd_mixer_oss snd_seq
snd_seq_device cpufreq_conservative cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf snd_h
da_codec_hdmi snd_hda_codec_realtek pl2303 usbserial kvm_intel kvm
snd_hda_intel e1000e snd_hda_codec iTCO_wdt shpchp mei(C) xhci_hcd
i2c_i801 pci_hotplug iTCO_vendor_supp
ort snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc sr_mod cdrom
sg serio_raw pcspkr linear raid456 async_raid6_recov async_pq raid6_pq
async_xor xor async_memcpy
 async_tx raid10 raid1 raid0 i915 drm_kms_helper drm i2c_algo_bit button
video dm_snapshot dm_mod fan processor thermal thermal_sys pata_amd
ata_generic sata_nv [last unlo
aded: preloadtrace]
[91794.875522]
[91794.875525] Pid: 5242, comm: udisks-daemon Tainted: G         C 
3.1.0-46-desktop #1                  /DH67CL
[91794.875534] RIP: 0010:[<ffffffff813c46c1>]  [<ffffffff813c46c1>]
sd_revalidate_disk+0x31/0x320
[91794.875543] RSP: 0018:ffff88040399dbb8  EFLAGS: 00010293
[91794.875547] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000001
[91794.875552] RDX: ffff8803fa9ba740 RSI: ffff8803fa9ba760 RDI:
ffff8800d3975c00
[91794.875557] RBP: ffff8800d3975c00 R08: ffff88040399db84 R09:
ffff8803fb546400
[91794.875561] R10: 0000000000000001 R11: 0000000000000001 R12:
00000000ffffff85
[91794.875565] R13: ffff88041efcb818 R14: ffff8800d3975c00 R15:
ffff88040399dc08
[91794.875718] FS:  00007fb7921067a0(0000) GS:ffff88041fbc0000(0000)
knlGS:0000000000000000
[91794.875863] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[91794.876016] CR2: 0000000000000008 CR3: 00000003fe33e000 CR4:
00000000000406e0
[91794.876172] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[91794.876321] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[91794.876473] Process udisks-daemon (pid: 5242, threadinfo
ffff88040399c000, task ffff8804035fa500)
[91794.876596] done.
[91794.876772] Stack:
[91794.876774]  ffff88040399dc08 ffff88041efcb800 0000000000000000
00000000ffffff85
[91794.876777]  ffff88041efcb818 ffffffff811c7a98 ffff88041efcb800
000000001efcb800
[91794.876779]  ffff8800d3975c78 ffff8800d3975c0c ffff8800d3975c00
0000000000000000
[91794.876782] Call Trace:
[91794.876791]  [<ffffffff811c7a98>] rescan_partitions+0xa8/0x320
[91794.876797]  [<ffffffff811928ee>] __blkdev_get+0x2be/0x420
[91794.876802]  [<ffffffff81192ab2>] blkdev_get+0x62/0x2d0
[91794.876807]  [<ffffffff81159ffa>] __dentry_open+0x23a/0x3f0
[91794.876812]  [<ffffffff8116b668>] do_last+0x3f8/0x7b0
[91794.876816]  [<ffffffff8116bb4b>] path_openat+0xdb/0x400
[91794.876819]  [<ffffffff8116bedd>] do_filp_open+0x4d/0xc0
[91794.876823]  [<ffffffff8115b511>] do_sys_open+0x101/0x1e0
[91794.876827]  [<ffffffff815ae692>] system_call_fastpath+0x16/0x1b
[91794.876840]  [<00007fb79189fb20>] 0x7fb79189fb1f
[91794.876841] Code: 86 b0 9e 00 48 89 6c 24 10 48 89 5c 24 08 48 89 fd 4c
89 64 24 18 4c 89 6c 24 20 c1 e8 15 48 8b 9f 28 03 00 00 83 e0 07 83 f8 03
<4c> 8b 63 08 0f 87 8e 02 00 00 41 8b 84 24 50 06 00 00 31 d2 83
[91794.876857] RIP  [<ffffffff813c46c1>] sd_revalidate_disk+0x31/0x320
[91794.876860]  RSP <ffff88040399dbb8>
[91794.876861] CR2: 0000000000000008

Kernel is from openSuSE 12.1:

Linux devpool02 3.1.0-46-desktop #1 SMP PREEMPT Mon Oct 24 20:49:37 UTC
2011 (1cba112) x86_64 x86_64 x86_64 GNU/Linux

Greetings,

Eike
