From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on
 ppc64 host
Date: Tue, 15 Dec 2015 20:06:47 +0800
Message-ID: <CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a114534f2bb2c610526ee9f16
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36845 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbbLOMGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 07:06:49 -0500
Received: by mail-wm0-f52.google.com with SMTP id n186so161626489wmn.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 04:06:48 -0800 (PST)
In-Reply-To: <20151215112057.GC19209@eguan.usersys.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

--001a114534f2bb2c610526ee9f16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2015 at 7:20 PM, Eryu Guan <guaneryu@gmail.com> wrote:
> On Fri, Dec 11, 2015 at 07:53:40PM +0800, Eryu Guan wrote:
>> Hi,
>>
>> I saw this kernel BUG_ON on 4.4-rc4 kernel, and this can be reproduced
>> easily on ppc64 host by:
>
> This is still reproducible with 4.4-rc5 kernel.

Could you capture the debug log after appyling the attached patch and
the reproduction?

Thanks,

>
> Thanks,
> Eryu
>
>>
>> modprobe scsi_debug sector_size=3D512 physblk_exp=3D3 dev_size_mb=3D256
>>
>> And I bisected to this commit
>>
>>       commit ca369d51b3e1649be4a72addd6d6a168cfb3f537
>>       Author: Martin K. Petersen <martin.petersen@oracle.com>
>>       Date:   Fri Nov 13 16:46:48 2015 -0500
>>
>>           block/sd: Fix device-imposed transfer length limits
>>
>> I confirmed by reverting this commit on top of 4.4-rc4 kernel and test
>> passed.
>>
>> Thanks,
>> Eryu
>>
>> P.S. dmesg log
>> [  817.477557] scsi_debug:sdebug_driver_probe: host protection
>> [  817.477571] scsi host1: scsi_debug, version 1.85 [20141022], dev_size=
_mb=3D256, opts=3D0x0
>> [  817.478202] scsi 1:0:0:0: Direct-Access     Linux    scsi_debug      =
 0184 PQ: 0 ANSI: 6
>> [  817.478733] sd 1:0:0:0: Attached scsi generic sg1 type 0
>> [  817.496144] sd 1:0:0:0: [sdb] 524288 512-byte logical blocks: (268 MB=
/256 MiB)
>> [  817.496155] sd 1:0:0:0: [sdb] 4096-byte physical blocks
>> [  817.506142] sd 1:0:0:0: [sdb] Write Protect is off
>> [  817.526134] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
>> [  817.646163] ------------[ cut here ]------------
>> [  817.646168] kernel BUG at block/bio.c:1787!
>> [  817.646172] Oops: Exception in kernel mode, sig: 5 [#1]
>> [  817.646174] SMP NR_CPUS=3D2048 NUMA pSeries
>> [  817.646178] Modules linked in: scsi_debug(E) nfsv3(E) rpcsec_gss_krb5=
(E) nfsv4(E) dns_resolver(E) nfs(E) fscache(E) dm_mod(E) loop(E) sg(E) pser=
ies_rng(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) sunrpc(E) grace(E) ip=
_tables(E) xfs(E) libcrc32c(E) sd_mod(E) ibmvscsi(E) ibmveth(E) scsi_transp=
ort_srp(E)
>> [  817.646205] CPU: 6 PID: 166 Comm: kworker/u321:1 Tainted: G          =
  E   4.4.0-rc4 #1
>> [  817.646211] Workqueue: events_unbound .async_run_entry_fn
>> [  817.646215] task: c00000000a0c0000 ti: c00000000a180000 task.ti: c000=
00000a180000
>> [  817.646218] NIP: c0000000003b1d54 LR: c0000000003c4780 CTR: c00000000=
03be420
>> [  817.646222] REGS: c00000000a1826c0 TRAP: 0700   Tainted: G           =
 E    (4.4.0-rc4)
>> [  817.646225] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI>  CR: 24732728  =
XER: 00000000
>> [  817.646233] CFAR: c0000000003c477c SOFTE: 1
>> GPR00: c0000000003c4780 c00000000a182940 c000000001325e00 c00000016cebcf=
00
>> GPR04: 0000000000000000 0000000002400000 c00000013c5f4d80 00000000000000=
40
>> GPR08: f000000000436ac0 0000000000000001 0000000000000000 ffffffffffffff=
ff
>> GPR12: 0000000024732722 c00000000e743900 0000000000000000 f000000000436a=
c0
>> GPR16: c0000000f9e3eee0 c00000010dab0000 0000000000000001 00000000000000=
00
>> GPR20: 0000000000000000 0000000000000080 0000000000000000 c00000016cebcf=
00
>> GPR24: c0000000ff9b5a20 c00000000a182bb8 c00000016cebcf88 00000000000000=
00
>> GPR28: 0000000000000000 c00000016cebcf00 0000000000000000 00000000000100=
00
>> [  817.646273] NIP [c0000000003b1d54] .bio_split+0x34/0x110
>> [  817.646277] LR [c0000000003c4780] .blk_queue_split+0x3b0/0x560
>> [  817.646280] Call Trace:
>> [  817.646282] [c00000000a182940] [c00000000a1829d0] 0xc00000000a1829d0 =
(unreliable)
>> [  817.646287] [c00000000a1829d0] [c0000000003c4780] .blk_queue_split+0x=
3b0/0x560
>> [  817.646291] [c00000000a182ae0] [c0000000003be460] .blk_queue_bio+0x40=
/0x430
>> [  817.646295] [c00000000a182b80] [c0000000003bc0f0] .generic_make_reque=
st+0x150/0x210
>> [  817.646299] [c00000000a182c30] [c0000000003bc26c] .submit_bio+0xbc/0x=
1c0
>> [  817.646304] [c00000000a182cf0] [c0000000002cb64c] .submit_bh_wbc+0x19=
c/0x200
>> [  817.646308] [c00000000a182d90] [c0000000002cbb10] .block_read_full_pa=
ge+0x310/0x410
>> [  817.646312] [c00000000a183290] [c0000000002cf11c] .blkdev_readpage+0x=
1c/0x30
>> [  817.646316] [c00000000a183300] [c0000000001e51a0] .do_read_cache_page=
+0xc0/0x290
>> [  817.646321] [c00000000a1833c0] [c0000000003d59f8] .read_dev_sector+0x=
38/0xb0
>> [  817.646325] [c00000000a183440] [c0000000003d977c] .read_lba+0xcc/0x1f=
0
>> [  817.646329] [c00000000a1834f0] [c0000000003da3b8] .efi_partition+0x11=
8/0x780
>> [  817.646333] [c00000000a183670] [c0000000003d6fcc] .check_partition+0x=
14c/0x2e0
>> [  817.646337] [c00000000a183700] [c0000000003d6260] .rescan_partitions+=
0xd0/0x380
>> [  817.646341] [c00000000a1837e0] [c0000000002d0b88] .__blkdev_get+0x3d8=
/0x530
>> [  817.646345] [c00000000a1838a0] [c0000000002d0f10] .blkdev_get+0x230/0=
x4a0
>> [  817.646348] [c00000000a1839a0] [c0000000003d3288] .add_disk+0x468/0x4=
f0
>> [  817.646353] [c00000000a183a60] [d000000002026450] .sd_probe_async+0xf=
0/0x230 [sd_mod]
>> [  817.646357] [c00000000a183af0] [c0000000000d23a8] .async_run_entry_fn=
+0x98/0x200
>> [  817.646362] [c00000000a183ba0] [c0000000000c6d74] .process_one_work+0=
x1a4/0x490
>> [  817.646366] [c00000000a183c40] [c0000000000c71dc] .worker_thread+0x17=
c/0x5a0
>> [  817.646369] [c00000000a183d30] [c0000000000ce704] .kthread+0x104/0x13=
0
>> [  817.646374] [c00000000a183e30] [c000000000009534] .ret_from_kernel_th=
read+0x58/0xa4
>> [  817.646377] Instruction dump:
>> [  817.646379] 3924ffff 7d292378 fba1ffe8 55290ffe fbc1fff0 fb81ffe0 fbe=
1fff8 7c9e2378
>> [  817.646386] 7c7d1b78 f8010010 7d2907b4 f821ff71 <0b090000> 81230028 7=
89c0020 5529ba7e
>> [  817.646394] ---[ end trace 0c08ee96e8610127 ]---
>> [  817.647718]
>> [  819.647756] Kernel panic - not syncing: Fatal exception
>> [  819.656776] Rebooting in 10 seconds..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Ming Lei

--001a114534f2bb2c610526ee9f16
Content-Type: text/x-patch; charset=US-ASCII; name="bio-dbg.patch"
Content-Disposition: attachment; filename="bio-dbg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ii7c7bc90

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jpby5jIGIvYmxvY2svYmlvLmMKaW5kZXggZGJhYmQ0OC4uOGQy
M2E5OSAxMDA2NDQKLS0tIGEvYmxvY2svYmlvLmMKKysrIGIvYmxvY2svYmlvLmMKQEAgLTE3ODQs
NiArMTc4NCwxMiBAQCBzdHJ1Y3QgYmlvICpiaW9fc3BsaXQoc3RydWN0IGJpbyAqYmlvLCBpbnQg
c2VjdG9ycywKIHsKIAlzdHJ1Y3QgYmlvICpzcGxpdCA9IE5VTEw7CiAKKwlpZiAoc2VjdG9ycyA8
PSAwIHx8IChzZWN0b3JzID49IGJpb19zZWN0b3JzKGJpbykpKSB7CisJCXByaW50aygiJXM6IHNl
Y3RvcnMgJWQsIGJpb19zZWN0b3JzICV1LCBiaV9ydyAleFxuIiwKKwkJCQlfX2Z1bmNfXywgc2Vj
dG9ycywgYmlvX3NlY3RvcnMoYmlvKSwKKwkJCQliaW8tPmJpX3J3KTsKKwl9CisKIAlCVUdfT04o
c2VjdG9ycyA8PSAwKTsKIAlCVUdfT04oc2VjdG9ycyA+PSBiaW9fc2VjdG9ycyhiaW8pKTsKIAo=
--001a114534f2bb2c610526ee9f16--
