From: Hannes Reinecke <hare@suse.de>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Fri, 04 Nov 2011 14:37:30 +0100
Message-ID: <4EB3EA9A.9050603@suse.de>
References: <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com> <4E9D7FA8.9000000@ce.jp.nec.com> <20111018154542.GB3869@osiris.boeblingen.de.ibm.com> <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com> <20111031100557.GA2621@osiris.boeblingen.de.ibm.com> <1320057746.2964.1.camel@dabdike> <4EAE8A7E.8000504@ce.jp.nec.com> <20111031130004.GB4768@osiris.boeblingen.de.ibm.com> <20111103182548.GA12131@redhat.com> <20111104091936.GB2397@osiris.boeblingen.de.ibm.com> <20111104133052.GA17643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111104133052.GA17643@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 11/04/2011 02:30 PM, Mike Snitzer wrote:
> On Fri, Nov 04 2011 at  5:19am -0400,
> Heiko Carstens<heiko.carstens@de.ibm.com>  wrote:
>
>> On Thu, Nov 03, 2011 at 02:25:48PM -0400, Mike Snitzer wrote:
>>> On Mon, Oct 31 2011 at  9:00am -0400,
>>> Heiko Carstens<heiko.carstens@de.ibm.com>  wrote:
>>>
>>>> On Mon, Oct 31, 2011 at 08:46:06PM +0900, Jun'ichi Nomura wrote:
>>>>> Hm, dm_softirq_done is generic completion code of original
>>>>> request in dm-multipath.
>>>>> So oops here might be another manifestation of use-after-free.
>>>>>
>>>>> Do you always hit the oops at the same address?
>>>>
>>>> I think we saw this bug the first time. But before that the scsi
>>>> logging level was higher. Gonzalo is trying to recreate it with
>>>> the same (old) scsi logging level.
>>>> Afterwards we will try with barrier=3D0.
>>>>
>>>> Both on v3.0.7 btw.
>>>>
>>>>> Could you find corresponding source code line for
>>>>> the crashed address, dm_softirq_done+0x72/0x140,
>>>>> and which pointer was invalid?
>>>>
>>>> It crashes in the inlined function dm_done() when trying to
>>>> dereference tio (aka clone->end_io_data):
>>>>
>>>> static void dm_done(struct request *clone, int error, bool mapped)
>>>> {
>>>>          int r =3D error;
>>>>          struct dm_rq_target_io *tio =3D clone->end_io_data;
>>>>          dm_request_endio_fn rq_end_io =3D tio->ti->type->rq_end_i=
o;
>>>
>>> Hi,
>>>
>>> Which underlying storage driver is being used by this multipath dev=
ice?
>>
>> It's the s390 only zfcp device driver.
>>
>> FWIW, yet another use-after-free crash, this time however in multipa=
th_end_io:
>>
>> [96875.870593] Unable to handle kernel pointer dereference at virtua=
l kernel address 6b6b6b6b6b6b6000
>> [96875.870602] Oops: 0038 [#1]
>> [96875.870674] PREEMPT SMP DEBUG_PAGEALLOC
>> [96875.870683] Modules linked in: dm_round_robin sunrpc ipv6 qeth_l2=
 binfmt_misc dm_multipath scsi_dh dm_mod qeth ccwgroup [la\
>> st unloaded: scsi_wait_scan]
>> [96875.870722] CPU: 2 Tainted: G        W   3.0.7-50.x.20111024-s390=
xdefault #1
>> [96875.870728] Process udevd (pid: 36697, task: 0000000072c8a3a8, ks=
p: 0000000057c43868)
>> [96875.870732] Krnl PSW : 0704200180000000 000003e001347138 (multipa=
th_end_io+0x50/0x140 [dm_multipath])
>> [96875.870746]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 C=
C:2 PM:0 EA:3
>> [96875.870751] Krnl GPRS: 0000000000000000 000003e000000000 6b6b6b6b=
6b6b6b6b 00000000717ab940
>> [96875.870755]            0000000000000000 00000000717abab0 00000000=
00000002 0700000000000008
>> [96875.870759]            0000000000000002 0000000000000000 00000000=
58dd37a8 000000006f845478
>> [96875.870764]            000003e0012e1000 000000005613d1f0 00000000=
7a737bf0 000000007a737ba0
>> [96875.870768] Krnl Code: 000003e00134712a: b90200dd            ltgr=
 %r13,%r13
>> [96875.870793]            000003e00134712e: a7840017            brc =
8,3e00134715c
>> [96875.870800]            000003e001347132: e320d0100004        lg %=
r2,16(%r13)
>> [96875.870809]>000003e001347138: e31020180004        lg %r1,24(%r2)
>> [96875.870818]            000003e00134713e: e31010580004        lg %=
r1,88(%r1)
>> [96875.870827]            000003e001347144: b9020011            ltgr=
 %r1,%r1
>> [96875.870835]            000003e001347148: a784000a            brc =
8,3e00134715c
>> [96875.870841]            000003e00134714c: 41202018            la %=
r2,24(%r2)
>> [96875.870889] Call Trace:
>> [96875.870892] ([<0700000000000008>] 0x700000000000008)
>> [96875.870897]  [<000003e0012e3662>] dm_softirq_done+0x9a/0x140 [dm_=
mod]
>> [96875.870915]  [<000000000040d29c>] blk_done_softirq+0xd4/0xf0
>> [96875.870925]  [<00000000001587c2>] __do_softirq+0xda/0x398
>> [96875.870932]  [<000000000010f47e>] do_softirq+0xe2/0xe8
>> [96875.870940]  [<0000000000158e2c>] irq_exit+0xc8/0xcc
>> [96875.870945]  [<00000000004ceb48>] do_IRQ+0x910/0x1bfc
>> [96875.870953]  [<000000000061a164>] io_return+0x0/0x16
>> [96875.870961]  [<000000000019c84e>] lock_acquire+0xd2/0x204
>> [96875.870969] ([<000000000019c836>] lock_acquire+0xba/0x204)
>> [96875.870974]  [<0000000000615f8e>] mutex_lock_killable_nested+0x92=
/0x520
>> [96875.870983]  [<0000000000292796>] vfs_readdir+0x8a/0xe4
>> [96875.870992]  [<00000000002928e0>] SyS_getdents+0x60/0xe8
>> [96875.870999]  [<0000000000619af2>] sysc_noemu+0x16/0x1c
>> [96875.871024]  [<000003fffd1ec83e>] 0x3fffd1ec83e
>> [96875.871028] INFO: lockdep is turned off.
>> [96875.871031] Last Breaking-Event-Address:
>> [96875.871037]  [<000003e0012e3660>] dm_softirq_done+0x98/0x140 [dm_=
mod]
>>
>> static int multipath_end_io(struct dm_target *ti, struct request *cl=
one,
>> 			    int error, union map_info *map_context)
>> {
>> 	struct multipath *m =3D ti->private;
>> 	struct dm_mpath_io *mpio =3D map_context->ptr;
>> 	struct pgpath *pgpath =3D mpio->pgpath;
>> 	struct path_selector *ps;
>> 	int r;
>>
>> 	r  =3D do_end_io(m, clone, error, mpio);
>> 	if (pgpath) {
>> 		ps =3D&pgpath->pg->ps;<--- crashes here
>> 		if (ps->type->end_io)
>> 			ps->type->end_io(ps,&pgpath->path, mpio->nr_bytes);
>> 	}
>> 	mempool_free(mpio, m->mpio_pool);
>>
>> 	return r;
>> }
>>
>> It crashes when trying to derefence pgpath, which was freed. Since w=
e have
>> SLUB debugging turned on the freed object tells us that it was alloc=
ated
>> via a call to multipath_ctr() and freed via a call to free_priority_=
group().
>>
>> FWIW, this reproduction was done with barriers off.
>>
>> Btw, since I cc'ed you rather late I'm not sure if you are aware of =
the
>> test scenario: it's I/O stress with multipathing were paths come and=
 go
>> all the time. It usually takes quite a few hours before the crashes =
are
>> observed.
>
> OK, thanks for the backstory.
>
> That is the same type of testing we've been doing with some partners
> for RHEL6.2 with the qla2xxx driver.  They have seen the same crash t=
hat
> you originally reported here: https://lkml.org/lkml/2011/10/31/64
>
> The really interesting observation that was made is that the qla2xxx
> driver was made lockless in RHEL6.2.  We've found that reverting the
> qla2xxx lockless changes eliminates the problems seen with it and I/O
> stress testing with multipath path failures.
>
> The zfcp driver was also made lockless upstream, via this commit:
> e55f875 [SCSI] zfcp: Issue FCP command without holding SCSI host_lock
>
> It would be great if you could try reverting e55f875 and see how your
> testing goes.
>
> If doing so resolves the crashes for you then the post mortem on why
> these lockless SCSI driver changes are causing such odd multipath
> completion failures is going to be "fun" ;)
>
And before anyone asks:

We will _not_ be reverting the lockless changes.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
