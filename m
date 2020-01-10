Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E9CC33C99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 04:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1092120678
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 04:00:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fuyEzzJk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbgAJEAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 23:00:37 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39072 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731220AbgAJEAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 23:00:37 -0500
Received: by mail-ot1-f65.google.com with SMTP id 77so685210oty.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jan 2020 20:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=og2vO7Al58t5y3x54/3ysr8GS8Dd5GnP8EMJbJAEums=;
        b=fuyEzzJkc6qdKufoeYw9ckKZweveeub4jMNYpFbTUECBbN1mxqQJjEDcFew+LGtmZx
         jKzbiYIxrm80CYFGnaXxISO96kWZAMLSUhjfRrmZ6Cs33WC0z6dVwJwAXEi72+I2d9ZA
         4wTd9ifn7XRHT/ALfTBfNxw1dQ8Ts7PfQ/lqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=og2vO7Al58t5y3x54/3ysr8GS8Dd5GnP8EMJbJAEums=;
        b=kptKtIhE8HMsoq3zxupd1hSYCBzQk0fwiAfYwtRutu9csNVyDHNKK2iH08f/aw3s00
         fkwBobUYMZd3vaq55cFP9XgVF9gIy7524Jn6I810u5C5EvAkMsvRT7mAg0/NbuJesPkV
         Nz6WVbD96zxM2UqyyscElHzscHY1Td/qz/ySUoCzQsLsLg8vCQNhER12nHgXo2opq9MD
         et5ZZGV/ob8IzeZtIqwlhPfVSJ87kwGWK4R058iCtFJoG5FOjl0ky8ldEpLPJPa+yJ4l
         jQRzdQm93piGiPDt+WRjpF4T6n/1fYXggUxZlgdTkK0jugeS/xjA2EKPVifRARuhustB
         AIwA==
X-Gm-Message-State: APjAAAVmSFRHKyTEl6hd3bllhKWx23ou7oCIf+prd7Ds1xtxmXq5qcpA
        1KUgM+EdDcrOHw+s69v22BAe8EOSR5oAoR+cdpt18g==
X-Google-Smtp-Source: APXvYqx9SLnnjMKtj+OHXEE2eCgxUTWgkPb6LKbEWpXZ4TIsWiAUsp5LGNef8UVqMagaexCl3szs6x2LNi2JrUA1CwU=
X-Received: by 2002:a9d:7342:: with SMTP id l2mr973379otk.98.1578628835913;
 Thu, 09 Jan 2020 20:00:35 -0800 (PST)
MIME-Version: 1.0
References: <20191202153914.84722-1-hare@suse.de> <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com> <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de>
In-Reply-To: <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Fri, 10 Jan 2020 09:30:08 +0530
Message-ID: <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 9, 2019 at 4:32 PM Hannes Reinecke <hare@suse.de> wrote:
>
> On 12/9/19 11:10 AM, Sumit Saxena wrote:
> > On Mon, Dec 2, 2019 at 9:09 PM Hannes Reinecke <hare@suse.de> wrote:
> >>
> >> Fusion adapters can steer completions to individual queues, and
> >> we now have support for shared host-wide tags.
> >> So we can enable multiqueue support for fusion adapters and
> >> drop the hand-crafted interrupt affinity settings.
> >
> > Hi Hannes,
> >
> > Ming Lei also proposed similar changes in megaraid_sas driver some
> > time back and it had resulted in performance drop-
> > https://patchwork.kernel.org/patch/10969511/
> >
> > So, we will do some performance tests with this patch and update you.
> > Thank you.
>
> I'm aware of the results of Ming Leis work, but I do hope this patchset
> performs better.
>
> And when you do performance measurements, can you please run with both,
> 'none' I/O scheduler and 'mq-deadline' I/O scheduler?
> I've measured quite a performance improvements when using mq-deadline,
> up to the point where I've gotten on-par performance with the original,
> non-mq, implementation.
> (As a data point, on my setup I've measured about 270k IOPS and 1092
> MB/s througput, running on just 2 SSDs).
>
> But thanks for doing a performance test here.

Hi Hannes,

Sorry for the delay in replying, I observed a few issues with this patchset=
:

1. "blk_mq_unique_tag_to_hwq(tag)" does not return MSI-x vector to
which IO submitter CPU is affined with. Due to this IO submission and
completion CPUs are different which causes performance drop for low
latency workloads.

lspcu:

# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                72
On-line CPU(s) list:   0-71
Thread(s) per core:    2
Core(s) per socket:    18
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 85
Model name:            Intel(R) Xeon(R) Gold 6150 CPU @ 2.70GHz
Stepping:              4
CPU MHz:               3204.246
CPU max MHz:           3700.0000
CPU min MHz:           1200.0000
BogoMIPS:              5400.00
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              1024K
L3 cache:              25344K
NUMA node0 CPU(s):     0-17,36-53
NUMA node1 CPU(s):     18-35,54-71
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep
mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht
tm pbe s
yscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq
dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1
sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave avx f16c rdrand
lahf_lm abm
3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 invpcid_single intel_ppin
mba tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust
bmi1 hle
avx2 smep bmi2 erms invpcid rtm cqm mpx rdt_a avx512f avx512dq rdseed
adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt
xsavec
xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_lo


fio test:

#numactl -N 0 fio jbod.fio

# cat jbod.fio
[global]
allow_mounted_write=3D0
ioengine=3Dlibaio
buffered=3D0
direct=3D1
group_reporting
iodepth=3D1
bs=3D4096
readwrite=3Drandread
..

In this test, IOs are submitted on Node 0 but observed IO completions on No=
de 1.

IRQs / 1 second(s)
IRQ#  TOTAL  NODE0   NODE1  NAME
176  48387  48387       0  IR-PCI-MSI 34603073-edge megasas14-msix65
178  47966  47966       0  IR-PCI-MSI 34603075-edge megasas14-msix67
170  47706  47706       0  IR-PCI-MSI 34603067-edge megasas14-msix59
180  47291  47291       0  IR-PCI-MSI 34603077-edge megasas14-msix69
181  47155  47155       0  IR-PCI-MSI 34603078-edge megasas14-msix70
173  46806  46806       0  IR-PCI-MSI 34603070-edge megasas14-msix62
179  46773  46773       0  IR-PCI-MSI 34603076-edge megasas14-msix68
169  46600  46600       0  IR-PCI-MSI 34603066-edge megasas14-msix58
175  46447  46447       0  IR-PCI-MSI 34603072-edge megasas14-msix64
172  46184  46184       0  IR-PCI-MSI 34603069-edge megasas14-msix61
182  46117  46117       0  IR-PCI-MSI 34603079-edge megasas14-msix71
165  46070  46070       0  IR-PCI-MSI 34603062-edge megasas14-msix54
164  45892  45892       0  IR-PCI-MSI 34603061-edge megasas14-msix53
174  45864  45864       0  IR-PCI-MSI 34603071-edge megasas14-msix63
156  45348  45348       0  IR-PCI-MSI 34603053-edge megasas14-msix45
147  45302      0   45302  IR-PCI-MSI 34603044-edge megasas14-msix36
151  44922      0   44922  IR-PCI-MSI 34603048-edge megasas14-msix40
171  44876  44876       0  IR-PCI-MSI 34603068-edge megasas14-msix60
159  44755  44755       0  IR-PCI-MSI 34603056-edge megasas14-msix48
148  44695      0   44695  IR-PCI-MSI 34603045-edge megasas14-msix37
157  44304  44304       0  IR-PCI-MSI 34603054-edge megasas14-msix46
167  42552  42552       0  IR-PCI-MSI 34603064-edge megasas14-msix56
154  35937      0   35937  IR-PCI-MSI 34603051-edge megasas14-msix43
166  16004  16004       0  IR-PCI-MSI 34603063-edge megasas14-msix55


IRQ-CPU affinity:

Ran below script to get IRQ-CPU affinity:
--
#!/bin/bash
PCID=3D`lspci | grep "SAS39xx" | cut -c1-7`
PCIP=3D`find /sys/devices -name *$PCID | grep pci`
IRQS=3D`ls $PCIP/msi_irqs`

echo "kernel version: "
uname -a

for IRQ in $IRQS; do
    CPUS=3D`cat /proc/irq/$IRQ/smp_affinity_list`
    echo "irq $IRQ, cpu list $CPUS"
done

--

irq 103, cpu list 0-17,36-53
irq 112, cpu list 0-17,36-53
irq 113, cpu list 0-17,36-53
irq 114, cpu list 0-17,36-53
irq 115, cpu list 0-17,36-53
irq 116, cpu list 0-17,36-53
irq 117, cpu list 0-17,36-53
irq 118, cpu list 0-17,36-53
irq 119, cpu list 18
irq 120, cpu list 19
irq 121, cpu list 20
irq 122, cpu list 21
irq 123, cpu list 22
irq 124, cpu list 23
irq 125, cpu list 24
irq 126, cpu list 25
irq 127, cpu list 26
irq 128, cpu list 27
irq 129, cpu list 28
irq 130, cpu list 29
irq 131, cpu list 30
irq 132, cpu list 31
irq 133, cpu list 32
irq 134, cpu list 33
irq 135, cpu list 34
irq 136, cpu list 35
irq 137, cpu list 54
irq 138, cpu list 55
irq 139, cpu list 56
irq 140, cpu list 57
irq 141, cpu list 58
irq 142, cpu list 59
irq 143, cpu list 60
irq 144, cpu list 61
irq 145, cpu list 62
irq 146, cpu list 63
irq 147, cpu list 64
irq 148, cpu list 65
irq 149, cpu list 66
irq 150, cpu list 67
irq 151, cpu list 68
irq 152, cpu list 69
irq 153, cpu list 70
irq 154, cpu list 71
irq 155, cpu list 0
irq 156, cpu list 1
irq 157, cpu list 2
irq 158, cpu list 3
irq 159, cpu list 4
irq 160, cpu list 5
irq 161, cpu list 6
irq 162, cpu list 7
irq 163, cpu list 8
irq 164, cpu list 9
irq 165, cpu list 10
irq 166, cpu list 11
irq 167, cpu list 12
irq 168, cpu list 13
irq 169, cpu list 14
irq 170, cpu list 15
irq 171, cpu list 16
irq 172, cpu list 17
irq 173, cpu list 36
irq 174, cpu list 37
irq 175, cpu list 38
irq 176, cpu list 39
irq 177, cpu list 40
irq 178, cpu list 41
irq 179, cpu list 42
irq 180, cpu list 43
irq 181, cpu list 44
irq 182, cpu list 45
irq 183, cpu list 46
irq 184, cpu list 47
irq 185, cpu list 48
irq 186, cpu list 49
irq 187, cpu list 50
irq 188, cpu list 51
irq 189, cpu list 52
irq 190, cpu list 53


I added prints in megaraid_sas driver's IO path to catch when MSI-x
affined to IO submitter CPU does not match with what is returned by
API "blk_mq_unique_tag_to_hwq(tag)".
I have copied below few prints from dmesg logs- in these prints CPU is
submitter CPU, calculated MSX-x is what is returned by
"blk_mq_unique_tag_to_hwq(tag)" and affined MSI-x is actual MSI-x to
which submitting
CPU is affined to:

[2536843.629877] BRCM DBG: CPU:6 calculated MSI-x: 153 affined MSIx: 161
[2536843.641674] BRCM DBG: CPU:39 calculated MSI-x: 168 affined MSIx: 176
[2536843.641674] BRCM DBG: CPU:13 calculated MSI-x: 160 affined MSIx: 168


2. Seeing below stack traces/messages in dmesg during driver unload =E2=80=
=93

[2565601.054366] Call Trace:
[2565601.054368]  blk_mq_free_map_and_requests+0x28/0x50
[2565601.054369]  blk_mq_free_tag_set+0x1d/0x90
[2565601.054370]  scsi_host_dev_release+0x8a/0xf0
[2565601.054370]  device_release+0x27/0x80
[2565601.054371]  kobject_cleanup+0x61/0x190
[2565601.054373]  megasas_detach_one+0x4c1/0x650 [megaraid_sas]
[2565601.054374]  pci_device_remove+0x3b/0xc0
[2565601.054375]  device_release_driver_internal+0xec/0x1b0
[2565601.054376]  driver_detach+0x46/0x90
[2565601.054377]  bus_remove_driver+0x58/0xd0
[2565601.054378]  pci_unregister_driver+0x26/0xa0
[2565601.054379]  megasas_exit+0x91/0x882 [megaraid_sas]
[2565601.054381]  __x64_sys_delete_module+0x16c/0x250
[2565601.054382]  do_syscall_64+0x5b/0x1b0
[2565601.054383]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[2565601.054383] RIP: 0033:0x7f7212a82837
[2565601.054384] RSP: 002b:00007ffdfa2dcea8 EFLAGS: 00000202 ORIG_RAX:
00000000000000b0
[2565601.054385] RAX: ffffffffffffffda RBX: 0000000000b6e2e0 RCX:
00007f7212a82837
[2565601.054385] RDX: 00007f7212af3ac0 RSI: 0000000000000800 RDI:
0000000000b6e348
[2565601.054386] RBP: 0000000000000000 R08: 00007f7212d47060 R09:
00007f7212af3ac0
[2565601.054386] R10: 00007ffdfa2dcbc0 R11: 0000000000000202 R12:
00007ffdfa2dd71c
[2565601.054387] R13: 0000000000000000 R14: 0000000000b6e2e0 R15:
0000000000b6e010
[2565601.054387] ---[ end trace 38899303bd85e838 ]---
[2565601.054390] ------------[ cut here ]------------
[2565601.054391] WARNING: CPU: 31 PID: 50996 at block/blk-mq.c:2056
blk_mq_free_rqs+0x10b/0x120
[2565601.054391] Modules linked in: megaraid_sas(-) ses enclosure
scsi_transport_sas xt_CHECKSUM xt_MASQUERADE tun bridge stp llc
ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat
ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle
iptable_security iptable_raw ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter intel_rapl_msr intel_rapl_common skx_edac
nfit libnvdimm ftdi_sio x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_generic
ledtrig_audio snd_hda_intel snd_intel_nhlt snd_hda_codec snd_hda_core
irqbypass snd_hwdep crct10dif_pclmul snd_seq crc32_pclmul
ghash_clmulni_intel snd_seq_device snd_pcm iTCO_wdt mei_me
iTCO_vendor_support cryptd snd_timer joydev snd mei soundcore ioatdma
sg pcspkr ipmi_si ipmi_devintf ipmi_msghandler dca i2c_i801 lpc_ich
acpi_power_meter wmi
[2565601.054400]  acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc
ip_tables xfs libcrc32c sd_mod ast i2c_algo_bit drm_vram_helper ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm
e1000e ahci libahci crc32c_intel nvme libata nvme_core i2c_core
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: megaraid_sas]
[2565601.054404] CPU: 31 PID: 50996 Comm: rmmod Kdump: loaded Tainted:
G        W  OE     5.4.0-rc1+ #2
[2565601.054405] Hardware name: Supermicro Super Server/X11DPG-QT,
BIOS 1.0 06/22/2017
[2565601.054406] RIP: 0010:blk_mq_free_rqs+0x10b/0x120
[2565601.054407] Code: 89 10 48 8b 73 20 48 89 1b 4c 89 e7 48 89 5b 08
e8 2a 54 e7 ff 48 8b 85 b0 00 00 00 49 39 c5 75 bc 5b 5d 41 5c 41 5d
41 5e c3 <0f> 0b 48 c7 02 00 00 00 00 e9 2b ff ff ff 0f 1f 80 00 00 00
00 0f
[2565601.054407] RSP: 0018:ffffb37446a6bd58 EFLAGS: 00010286
[2565601.054408] RAX: 0000000000000747 RBX: ffff92219cb280a8 RCX:
0000000000000747
[2565601.054408] RDX: ffff92219b153a38 RSI: ffff9221692bb5c0 RDI:
ffff92219cb280a8
[2565601.054408] RBP: ffff9221692bb5c0 R08: 0000000000000001 R09:
0000000000000000
[2565601.054409] R10: ffff9221692bb680 R11: ffff9221bffd5f60 R12:
ffff9221970dd678
[2565601.054409] R13: 0000000000000030 R14: ffff92219cb280a8 R15:
ffff922199ada010
[2565601.054410] FS:  00007f72135a1740(0000) GS:ffff92299f540000(0000)
knlGS:0000000000000000
[2565601.054410] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2565601.054410] CR2: 0000000000b77c78 CR3: 0000000f27db0006 CR4:
00000000007606e0
[2565601.054412] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[2565601.054412] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[2565601.054413] PKRU: 55555554


3. For High IOs(outstanding IOs per physical disk > 8) oriented
workloads, performance numbers are good(no performance drop) as in
that case driver uses non-managed affinity high IOPs reply queues and
this patchset does not touch driver's high IOPs IO path.

4. This patch removes below code from driver so what this piece of
code does is broken-


-                               if (instance->adapter_type >=3D INVADER_SER=
IES &&
-                                   !instance->msix_combined) {
-                                       instance->msix_load_balance =3D tru=
e;
-                                       instance->smp_affinity_enable =3D f=
alse;
-                               }

Thanks,
Sumit
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke            Teamlead Storage & Networking
> hare@suse.de                               +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
