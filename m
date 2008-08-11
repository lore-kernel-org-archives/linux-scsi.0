From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Date: Mon, 11 Aug 2008 11:17:52 -0700
Message-ID: <20080811181752.GK13158@linux-os.sc.intel.com>
References: <20080809220154.GO28946@ZenIV.linux.org.uk> <E1KS2KD-0000he-00@gondolin.me.apana.org.au> <20080810133056.2fd69a20@neptune.home> <489F7C2B.30807@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <489F7C2B.30807@zytor.com>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>, Herbert Xu <herbert@gondor.apana.org.au>, Al Viro <viro@ZenIV.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>, Wolfgang Walter <wolfgang.walter@stwm.de>
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 10, 2008 at 04:39:23PM -0700, H. Peter Anvin wrote:
> Bruno Pr=E9mont wrote:
> >
> > Recompiling without viafb+squashfs patches makes the panic go away.
> >
> > So something from viafb or squashfs triggers the panic or prepare
> > for something else to trigger it...
> >
>=20
> Out of those, viafb by far seems most likely.  Could you try compilin=
g
> with only one or the other?

[    5.010629] general protection fault: 0000 [#1]=20
[    5.021782] Modules linked in:
[    5.030227]=20
[    5.030227] Pid: 3, comm: ksoftirqd/0 Not tainted (2.6.27-rc2-git4_n=
ocrypto #1)
[    5.030227] EIP: 0060:[<c01042f5>] EFLAGS: 00010046 CPU: 0
[    5.030227] EIP is at math_state_restore+0x25/0x60
[    5.030227] EAX: f781db3d EBX: f781d898 ECX: 00000000 EDX: 00000000
[    5.030227] ESI: f781d000 EDI: f782c20c EBP: f781d840 ESP: f781d838
[    5.030227]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    5.030227] Process ksoftirqd/0 (pid: 3, ti=3Df781d000 task=3Df782c6=
a0 task.ti=3Df782a000)
[    5.030227] Stack: f782c000 f782c6a0 f781d890 c01038dd f782c000 0000=
0000 f782c000 f782c6a0=20
[    5.030227]        f782c20c f781d890 f7807e00 0000007b 0000007b 0000=
0000 ffffffff c0101e8f=20
[    5.030227]        00000060 00010002 f782c8ac f782c000 c04d8180 c011=
fa50 f782afc0 c03cfa61=20
[    5.030227] Call Trace:
[    5.030227]  [<c01038dd>] ? device_not_available+0x2d/0x32
[    5.030227]  [<c0101e8f>] ? __switch_to+0x2f/0x130

It got a GP fault, because in __switch_to() we were doing unlazy_fpu() =
and
fxsave generated a DNA fault(which shouldn't happen unless we are hitti=
ng the
via padlock instruction issue or something else) and the math_state_res=
tore()
found the task's math state pointer to be 0xf781db3d (EAX in the oops) =
and while
doing fxrstor we got GP fault, as the fxrstor pointer(EAX) is not 16byt=
e
aligned.

It is interesting to see the EAX value similar to stack pointer. Task's
=46P area gets dynamically allocated and as such EAX def looks wrong he=
re.
I also see the config is using 4K stacks. Some config(viafb/squashfs?) =
causing
some thing wrong with the kernel stack?
