From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [linux-next][qla2xxx][85caa95]kernel BUG at lib/list_debug.c:31!
Date: Fri, 12 Jan 2018 00:21:44 +0000
Message-ID: <B22CAB4D-3649-4E45-A49C-57116652A5EF@cavium.com>
References: <1515489264.3648.18.camel@abdul.in.ibm.com>
 <1515513297.2721.2.camel@wdc.com>
 <E71C9519-AF83-49D4-A016-2E1E29C699FC@cavium.com>
 <1515649111.3516.4.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0071.outbound.protection.outlook.com ([104.47.37.71]:19834
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753186AbeALAVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jan 2018 19:21:47 -0500
In-Reply-To: <1515649111.3516.4.camel@abdul.in.ibm.com>
Content-Language: en-US
Content-ID: <6B40D7F9E622004F94BF2E96593B15FA@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "sim@linux.vnet.ibm.com" <sim@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>


> On Jan 10, 2018, at 9:38 PM, Abdul Haleem <abdhalee@linux.vnet.ibm.com> w=
rote:
>=20
> On Tue, 2018-01-09 at 18:09 +0000, Madhani, Himanshu wrote:
>> Hello Abdul,=20
>>=20
>>> On Jan 9, 2018, at 7:54 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>>>=20
>>> On Tue, 2018-01-09 at 14:44 +0530, Abdul Haleem wrote:
>>>> Greeting's,=20
>>>>=20
>>>> Linux next kernel panics on powerpc when module qla2xxx is load/unload=
.
>>>>=20
>>>> Machine Type: Power 8 PowerVM LPAR
>>>> Kernel : 4.15.0-rc2-next-20171211
>>>> gcc : version 4.8.5
>>>> Test type: module load/unload few times
>>>>=20
>>>> Trace messages:
>>>> ---------------
>>>> qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 10.00.=
00.03-k.
>>>> qla2xxx [0106:a0:00.0]-001a: : MSI-X vector count: 32.
>>>> qla2xxx [0106:a0:00.0]-001d: : Found an ISP2532 irq 505 iobase 0x00000=
000aeb324e6.
>>>> qla2xxx [0106:a0:00.0]-00c6:1: MSI-X: Failed to enable support with 32=
 vectors, using 16 vectors.
>>>> qla2xxx [0106:a0:00.0]-00fb:1: QLogic QLE2562 - PCIe 2-port 8Gb FC Ada=
pter.
>>>> qla2xxx [0106:a0:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0106:a0:00=
.0 hdma- host#=3D1 fw=3D8.06.00 (90d5).
>>>> qla2xxx [0106:a0:00.1]-001a: : MSI-X vector count: 32.
>>>> qla2xxx [0106:a0:00.1]-001d: : Found an ISP2532 irq 506 iobase 0x00000=
000a46f1774.
>>>> qla2xxx [0106:a0:00.1]-00c6:2: MSI-X: Failed to enable support with 32=
 vectors, using 16 vectors.
>>>> 2xxx
>>>> qla2xxx [0106:a0:00.1]-00fb:2: QLogic QLE2562 - PCIe 2-port 8Gb FC Ada=
pter.
>>>> qla2xxx [0106:a0:00.1]-00fc:2: ISP2532: PCIe (5.0GT/s x8) @ 0106:a0:00=
.1 hdma- host#=3D2 fw=3D8.06.00 (90d5).
>>>> 0:00.0]-500a:1: LOOP UP detected (8 Gbps).=20
>>>> qla2xxx [0106:a0:00.1]-500a:2: LOOP UP detected (8 Gbps).
>>>> list_add double add: new=3D000000008d33e594, prev=3D000000008d33e594, =
next=3D00000000adef1df4.
>>>> ------------[ cut here ]------------
>>>> kernel BUG at lib/list_debug.c:31!=20
>>>> Oops: Exception in kernel mode, sig: 5 [#1]
>>>> LE SMP NR_CPUS=3D2048 NUMA pSeries=20
>>>> Dumping ftrace buffer:=20
>>>>  (ftrace buffer empty)
>>>> Modules linked in: qla2xxx(E) tg3(E) ibmveth(E) xt_CHECKSUM(E)
>>>> iptable_mangle(E) ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E)
>>>> iptable_nat(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack_ipv4(E)
>>>> nf_defrag_ipv4(E) xt_conntrack(E) nf_conntrack(E) ipt_REJECT(E)
>>>> nf_reject_ipv4(E) tun(E) bridge(E) stp(E) llc(E) kvm_pr(E) kvm(E)
>>>> sctp_diag(E) sctp(E) libcrc32c(E) tcp_diag(E) udp_diag(E)
>>>> ebtable_filter(E) ebtables(E) dccp_diag(E) ip6table_filter(E) dccp(E)
>>>> ip6_tables(E) iptable_filter(E) inet_diag(E) unix_diag(E)
>>>> af_packet_diag(E) netlink_diag(E) xts(E) sg(E) vmx_crypto(E)
>>>> pseries_rng(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E)
>>>> sunrpc(E) binfmt_misc(E) ip_tables(E) ext4(E) mbcache(E) jbd2(E)
>>>> fscrypto(E) sd_mod(E) ibmvscsi(E) scsi_transport_srp(E) nvme_fc(E)
>>>> nvme_fabrics(E) nvme_core(E) scsi_transport_fc(E)
>>>> ptp(E) pps_core(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
>>>> [last unloaded: qla2xxx]
>>>> CPU: 7 PID: 22230 Comm: qla2xxx_1_dpc Tainted: G            E    4.15.=
0-rc2-next-20171211-autotest-autotest #1
>>>> NIP:  c000000000511040 LR: c00000000051103c CTR: 0000000000655170     =
  =20
>>>> REGS: 000000009b7356fa TRAP: 0700   Tainted: G            E     (4.15.=
0-rc2-next-20171211-autotest-autotest)
>>>> MSR:  800000010282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 22=
000022  XER: 00000009 =20
>>>> CFAR: c000000000170594 SOFTE: 0=20
>>>> GPR00: c00000000051103c c0000000fc293ac0 c0000000010f1d00 000000000000=
0058=20
>>>> GPR04: c00000028fcccdd0 c00000028fce3798 80000000374060b8 ffffffffffff=
ffff=20
>>>> GPR08: 0000000000000000 c000000000d435ec 000000028ef90000 000000000000=
2717=20
>>>> GPR12: 0000000000000000 c00000000e734980 c0000000001215d8 c00000028869=
96c0=20
>>>> GPR16: 0000000000000000 0000000000000020 c0000002813d83f8 000000000000=
0001=20
>>>> GPR20: 0000000020000000 0000000000002000 0000000000000002 c0000002813d=
c808=20
>>>> GPR24: 0000000000000003 0000000000000001 c00000027f5a5c20 c0000002813d=
ced0=20
>>>> GPR28: c00000027f5a5d90 c00000027f5a5d90 c00000027f5a5c00 c0000002813d=
c7f8=20
>>>> NIP [c000000000511040] __list_add_valid+0x70/0xb0
>>>> LR [c00000000051103c] __list_add_valid+0x6c/0xb0
>>>> Call Trace:
>>>> [c0000000fc293ac0] [c00000000051103c] __list_add_valid+0x6c/0xb0 (unre=
liable)
>>>> [c0000000fc293b20] [d0000000051f1a08] qla24xx_async_gnl+0x108/0x420 [q=
la2xxx]
>>>> [c0000000fc293bc0] [d0000000051e762c] qla2x00_do_work+0x18c/0x8c0 [qla=
2xxx]
>>>> [c0000000fc293ce0] [d0000000051e8180] qla2x00_relogin+0x420/0xff0 [qla=
2xxx]
>>>> [c0000000fc293dc0] [c00000000012172c] kthread+0x15c/0x1a0
>>>> [c0000000fc293e30] [c00000000000b4e8] ret_from_kernel_thread+0x5c/0x74
>>>> Instruction dump:
>>>> 41de0018 38210060 38600001 e8010010 7c0803a6 4e800020 3c62ffae 7d44537=
8=20
>>>> 38631748 7d254b78 4bc5f51d 60000000 <0fe00000> 3c62ffae 7cc43378 38631=
6f8=20
>>>> ---[ end trace a41bc8bd434657f1 ]---
>>>>=20
>>>> Kernel panic - not syncing: Fatal exception
>>>> Dumping ftrace buffer:=20
>>>>  (ftrace buffer empty)
>>>> Rebooting in 10 seconds..
>>>>=20
>>>> This trace back to the below code path:
>>>>=20
>>>> # gdb -batch vmlinux -ex 'list *(0xc000000000511040)'
>>>> 0xc000000000511040 is in __list_add_valid (lib/list_debug.c:29).
>>>> 24				"list_add corruption. next->prev should be prev (%p), but was %p=
. (next=3D%p).\n",
>>>> 25				prev, next->prev, next) ||
>>>> 26		    CHECK_DATA_CORRUPTION(prev->next !=3D next,
>>>> 27				"list_add corruption. prev->next should be next (%p), but was %p=
. (prev=3D%p).\n",
>>>> 28				next, prev->next, prev) ||
>>>> 29		    CHECK_DATA_CORRUPTION(new =3D=3D prev || new =3D=3D next,
>>>> 30				"list_add double add: new=3D%p, prev=3D%p, next=3D%p.\n",
>>>> 31				new, prev, next))
>>>> 32			return false;
>>>> 33=09
>>>=20
>>> (+linux-scsi)
>>>=20
>>> Hello Abdul,
>>>=20
>>> Please report SCSI LLD issues on the linux-scsi mailing list.
>>>=20
>>> Bart.
>>=20
>> We have fixed this issue with following patch
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=
=3D4.16/scsi-queue&id=3D5d3300a9b8b122b4743aed5a178bf12c87e2b8c9
>>=20
>> Can you apply this on your setup and retry your test.=20
>=20
> I see the patch already applied to next-20171211 and the problem is also
> seen with the patch.
>=20
> I am attaching the kernel configuration file.
>=20
> Regard's
> Abdul
>=20
> <ZZ-VM-config.txt>

Looks like these 3 patches should help with the issue. Can you check if you=
r Tree has these applied

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=3D4.=
16/scsi-queue&id=3D6d67492764b39ad6efb6822816ad73dc141752f4
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=3D4.=
16/scsi-queue&id=3D3dbec59bdf63f3c82323bd6ab8a4bd2946abaaec
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=3D4.=
16/scsi-queue&id=3D3dbec59bdf63f3c82323bd6ab8a4bd2946abaaec

if not then please pull them on your tree and retest.=20

Thanks,
- Himanshu
