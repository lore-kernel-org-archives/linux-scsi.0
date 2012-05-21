From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Mon, 21 May 2012 15:18:17 -0700
Message-ID: <1337638697.32217.744.camel@haakon2.linux-iscsi.org>
References: <20120511143341.GA18753@logfs.org>
	 <20120517162600.GA18067@logfs.org>
	 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
	 <20120517192830.GC18067@logfs.org> <20120517210521.GE18067@logfs.org>
	 <1337306556.32217.365.camel@haakon2.linux-iscsi.org>
	 <20120518011528.GG18067@logfs.org>
	 <1337321367.32217.412.camel@haakon2.linux-iscsi.org>
	 <20120518224948.GB21634@logfs.org>
	 <1337390768.32217.508.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1337390768.32217.508.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-05-18 at 18:26 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2012-05-18 at 18:49 -0400, J=C3=B6rn Engel wrote:
> > On Thu, 17 May 2012 23:09:27 -0700, Nicholas A. Bellinger wrote:
> > >=20
> > > So that means your testing with it now, right..?
> >=20
> > Our kernel has diverged too much from yours to easily move patches
> > back and forth, so no.
> >=20
> > But more importantly, we still don't have a complete patchset.
> >=20
>=20
> Ok, I've pushed into lio-core the following WIP patches based on your
> original patch + s_id + loop_id clearing patch from today:
>=20
> 6fc162d3 tcm_qla2xxx: Clear session s_id + loop_id earlier during shu=
tdown
> dfebe3b5 tcm_qla2xxx: Convert to TFO->put_session() usage
> ec7cf009 target: Add TFO->put_session() caller for HW fabric session =
shutdown
>=20
> Today I've been testing these changes against typical active I/O duri=
ng
> tcm_qla2xxx endpoint shutdown, and against explict NodeACL + MappedLU=
Ns
> removal case.  So far with active FCP of the order of ~100K IOPs with
> random mixed mode 4K blocks, these patches are performing session
> shutdown and unloading tcm_qla2xxx references as expected.
>=20
> Certainly these need more testing wrt to a number of special cases fo=
r
> active I/O shutdown, but I think they look reasonable enough to put i=
nto
> lio-core for now..
>=20
> Please have a look and let me know if you have any problems getting i=
t
> applied for testing into your .39 tree.
>=20

Quick update here folks,

So these three patches have been running over the weekend with active
I/O shutdown using the same ~100K IOPs fio randrw mixed load with
explicit NodeACL + MappedLUN=3D0 removal + re-add using qla2xxx rtslib
scripts.

During 5K test iterations with FC clients pushing fio randrw traffic,
thus far there have been no OOPsen or outstanding I/O shutdown hangs
during the explicit NodeACL + MappedLUN=3D0 removal ops..

After the test completed and tcm_qla2xxx was released, while unloading
the qla2xxx LLD the following qla_tgt_cmd_cachep leakage warnings
appear:

[244560.843319] qla2xxx [0000:07:00.1]-4801:15: DPC handler waking up.
[244560.850509] qla2xxx [0000:07:00.1]-4802:15: dpc_flags=3D0x201250.
[244560.858036] qla2xxx [0000:07:00.1]-0121:15: Failed to enable receiv=
ing of RSCN requests: 0x2.
[244560.867640] qla2xxx [0000:07:00.1]-480f:15: Loop resync scheduled.
[244560.875896] qla2xxx [0000:07:00.1]-8837:15: F/W Ready - OK.
[244560.882222] qla2xxx [0000:07:00.1]-883a:15: fw_state=3D3 (3, 63eb, =
2, 0) curr time=3D103a47b53.
[244560.894437] qla2xxx [0000:07:00.1]-4810:15: Loop resync end.
[244560.900844] qla2xxx [0000:07:00.1]-4800:15: DPC handler sleeping.
[244561.031733] qla2xxx [0000:07:00.1]-e802:15: tgt ffff8802646bc800, e=
mpty(sess_list)=3D1 sess_count=3D0
[244561.063875] qla2xxx [0000:07:00.1]-f80b:15: Waiting for 0 IRQ comma=
nds to complete (tgt ffff8802646bc800)
[244561.074469] qla2xxx [0000:07:00.1]-f80c:15: Stop of tgt ffff8802646=
bc800 finished
[244561.099207] sd 45:0:1:0: alua: Detached
[244561.110278] sd 44:0:1:0: alua: Detached
[244576.123716] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[244576.132936] BUG qla_tgt_cmd_cachep (Tainted: G           O): Object=
s remaining on kmem_cache_close()
[244576.143214] -------------------------------------------------------=
----------------------
[244576.143215]
[244576.154181] INFO: Slab 0xffffea000420ee00 objects=3D25 used=3D1 fp=3D=
0xffff8801083bf740 flags=3D0x8000000000004080
[244576.165042] Pid: 22707, comm: rmmod Tainted: G           O 3.4.0-rc=
2+ #65
[244576.172706] Call Trace:
[244576.175525]  [<ffffffff810c1e07>] slab_err+0x90/0x9e
[244576.181159]  [<ffffffff8105d901>] ? trace_hardirqs_on+0xd/0xf
[244576.187667]  [<ffffffff810abc10>] ? free_percpu+0x2c/0x112
[244576.193879]  [<ffffffff810c6403>] kmem_cache_destroy+0x152/0x309
[244576.200674]  [<ffffffff81099ae1>] ? mempool_destroy+0x43/0x47
[244576.207185]  [<ffffffffa03a3782>] qlt_exit+0x3d/0x3f [qla2xxx]
[244576.213790]  [<ffffffffa03aa8d5>] qla2x00_module_exit+0x79/0xa6 [ql=
a2xxx]
[244576.221456]  [<ffffffff8106a4bb>] sys_delete_module+0x1fb/0x25f
[244576.228154]  [<ffffffff811a1404>] ? lockdep_sys_exit_thunk+0x35/0x6=
7
[244576.235337]  [<ffffffff81377279>] system_call_fastpath+0x16/0x1b
[244576.242134] INFO: Object 0xffff8801083ba2c8 @offset=3D8904
[244576.248150] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

So I think we might (finally) have the target_wait_for_sess_cmds() hang
addressed for tcm_qla2xxx with explicit NodeACL shutdown, but are still
leaking descriptor memory in some qla_target.c exception path..

I'm now trying to isolate down the load to reproduce this leakage, and
figure out why these descriptors are not being included in the
->sess_wait_list used by wait_for_sess_cmds...

--nab
