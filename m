From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request V2
Date: Thu, 26 Jan 2017 18:29:08 +0000
Message-ID: <1485455329.2540.7.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0058.outbound.protection.outlook.com ([104.47.33.58]:53856
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752817AbdAZSaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 13:30:03 -0500
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <B8CC5D7EE2221B4EAB5B30C4A4938669@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> Hi all,
>=20
> this series splits the support for SCSI passthrough commands from the
> main struct request used all over the block layer into a separate
> scsi_request structure that drivers that want to support SCSI passthough
> need to embedded as the first thing into their request-private data,
> similar to how we handle NVMe passthrough commands.
>=20
> To support this I've added support for that the private data after
> request structure to the legacy request path instead, so that it can
> be treated the same way as the blk-mq path.  Compare to the current
> scsi_cmnd allocator that actually is a major simplification.
>=20
> Changes since V1:
>  - fix handling of a NULL sense pointer in __scsi_execute
>  - clean up handling of the flush flags in the block layer and MD
>  - additional small cleanup in dm-rq

Hello Christoph,

Thanks for having fixed the NULL pointer issue I had reported for v1.
However, if I try to run my srp-test testsuite on top of your
hch-block/block-pc-refactor=A0branch (commit ID a07dc3521034) merged
with v4.10-rc5 the following appears on the console:

[  707.317403] BUG: scheduling while atomic: fio/9073/0x00000003
[  707.317404] 1 lock held by fio/9073:
[  707.317404]  #0:  (rcu_read_lock){......}, at: [<ffffffff8132618e>] __bl=
k_mq_run_hw_queue+0xde/0x1c0
[  707.317409] Modules linked in: dm_service_time ib_srp scsi_transport_srp=
 target_core_user uio target_core_pscsi target_core_file ib_srpt target_cor=
e_iblock target_core_mod brd netconsole xt_CHECKSUM iptable_mangle ipt_MASQ=
UERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat libcrc32c nf_c=
onntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject=
_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter =
ip6_tables iptable_filter ip_tables x_tables af_packet ib_ipoib rdma_ucm ib=
_ucm ib_uverbs ib_umad rdma_cm configfs ib_cm iw_cm msr mlx4_ib ib_core sb_=
edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_ssif kvm=
_intel kvm irqbypass crct10dif_pclmul crc32_pclmul mlx4_core crc32c_intel g=
hash_clmulni_intel hid_generic pcbc usbhid iTCO_wdt tg3 aesni_intel
[  707.317445]  ptp iTCO_vendor_support aes_x86_64 crypto_simd pps_core glu=
e_helper dcdbas ipmi_si ipmi_devintf libphy devlink lpc_ich cryptd pcspkr i=
pmi_msghandler mfd_core fjes mei_me tpm_tis button tpm_tis_core shpchp mei =
tpm wmi mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgb=
lt fb_sys_fops ttm sr_mod cdrom drm ehci_pci ehci_hcd usbcore usb_common sg=
 dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua autofs4
[  707.317469] CPU: 6 PID: 9073 Comm: fio Tainted: G        W       4.10.0-=
rc5-dbg+ #1
[  707.317470] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 1=
1/17/2014
[  707.317470] Call Trace:
[  707.317473]  dump_stack+0x68/0x93
[  707.317475]  __schedule_bug+0x5b/0x80
[  707.317477]  __schedule+0x762/0xb00
[  707.317479]  schedule+0x38/0x90
[  707.317481]  schedule_timeout+0x2fe/0x640
[  707.317491]  io_schedule_timeout+0x9f/0x110
[  707.317493]  blk_mq_get_tag+0x158/0x260
[  707.317496]  __blk_mq_alloc_request+0x16/0xe0
[  707.317498]  blk_mq_sched_get_request+0x30d/0x360
[  707.317502]  blk_mq_alloc_request+0x3b/0x90
[  707.317505]  blk_get_request+0x2f/0x110
[  707.317507]  multipath_clone_and_map+0xcd/0x140 [dm_multipath]
[  707.317512]  map_request+0x3c/0x290 [dm_mod]
[  707.317517]  dm_mq_queue_rq+0x77/0x100 [dm_mod]
[  707.317519]  blk_mq_dispatch_rq_list+0x1ff/0x320
[  707.317521]  blk_mq_sched_dispatch_requests+0xa9/0xe0
[  707.317523]  __blk_mq_run_hw_queue+0x122/0x1c0
[  707.317528]  blk_mq_run_hw_queue+0x84/0x90
[  707.317530]  blk_mq_flush_plug_list+0x39f/0x480
[  707.317531]  blk_flush_plug_list+0xee/0x270
[  707.317533]  blk_finish_plug+0x27/0x40
[  707.317534]  do_io_submit+0x475/0x900
[  707.317537]  SyS_io_submit+0xb/0x10
[  707.317539]  entry_SYSCALL_64_fastpath+0x18/0xad

Bart.=
