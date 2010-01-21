From: Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: qlogic lockdep warning
Date: Thu, 21 Jan 2010 16:46:56 +0800
Message-ID: <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
	 <1264062159.4283.1125.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754332Ab0AUIq7@vger.kernel.org>
In-Reply-To: <1264062159.4283.1125.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@hansenpartnership.com>, James.Bottomley@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

qla24xx_msix_default is using spin_lock_irq and spin_unlock_irq within
the irq handler...
I think convert to spin_lock_irqsave/spin_unlock_irqrestore can solve
this warning.

On Thu, Jan 21, 2010 at 4:22 PM, Peter Zijlstra <peterz@infradead.org> =
wrote:
> On Wed, 2010-01-20 at 17:10 -0800, Yinghai Lu wrote:
>
>> [ =C2=A0 77.962879] ------------[ cut here ]------------
>> [ =C2=A0 77.965784] WARNING: at kernel/lockdep.c:2332
>> trace_hardirqs_on_caller+0xc6/0x14b()
>> [ =C2=A0 77.977492] Hardware name: Sun
>> [ =C2=A0 77.979485] Modules linked in:
>> [ =C2=A0 77.994337] Pid: 0, comm: swapper Not tainted
>> 2.6.33-rc4-tip-yh-03949-g3a8e3f5-dirty #64
>> [ =C2=A0 78.000120] Call Trace:
>> [ =C2=A0 78.013298] =C2=A0<IRQ> =C2=A0[<ffffffff81076b54>] warn_slow=
path_common+0x7c/0x94
>> [ =C2=A0 78.017746] =C2=A0[<ffffffff81cd712c>] ? _raw_spin_unlock_ir=
q+0x30/0x36
>> [ =C2=A0 78.035171] =C2=A0[<ffffffff81076b80>] warn_slowpath_null+0x=
14/0x16
>> [ =C2=A0 78.040152] =C2=A0[<ffffffff810a2ae8>] trace_hardirqs_on_cal=
ler+0xc6/0x14b
>> [ =C2=A0 78.055400] =C2=A0[<ffffffff810a2b7a>] trace_hardirqs_on+0xd=
/0xf
>> [ =C2=A0 78.058951] =C2=A0[<ffffffff81cd712c>] _raw_spin_unlock_irq+=
0x30/0x36
>> [ =C2=A0 78.074889] =C2=A0[<ffffffff816461ef>] qla24xx_msix_default+=
0x243/0x281
>> [ =C2=A0 78.091598] =C2=A0[<ffffffff810a5752>] ? __lock_release+0xa5=
/0xae
>> [ =C2=A0 78.096799] =C2=A0[<ffffffff810c02ae>] handle_IRQ_event+0x53=
/0x113
>> [ =C2=A0 78.111568] =C2=A0[<ffffffff810c2061>] handle_edge_irq+0xf3/=
0x13b
>> [ =C2=A0 78.116255] =C2=A0[<ffffffff81035109>] handle_irq+0x24/0x2f
>> [ =C2=A0 78.132063] =C2=A0[<ffffffff81cdc4b4>] do_IRQ+0x5c/0xc3
>> [ =C2=A0 78.134684] =C2=A0[<ffffffff81cd7393>] ret_from_intr+0x0/0xf
>> [ =C2=A0 78.137903] =C2=A0<EOI> =C2=A0[<ffffffff81039a56>] ? mwait_i=
dle+0xaf/0xbb
>> [ =C2=A0 78.155674] =C2=A0[<ffffffff81039a4d>] ? mwait_idle+0xa6/0xb=
b
>> [ =C2=A0 78.158600] =C2=A0[<ffffffff81031c7c>] cpu_idle+0x61/0xa1
>> [ =C2=A0 78.174333] =C2=A0[<ffffffff81c85d7a>] rest_init+0x7e/0x80
>> [ =C2=A0 78.178122] =C2=A0[<ffffffff82832d1f>] start_kernel+0x316/0x=
31d
>> [ =C2=A0 78.193623] =C2=A0[<ffffffff82832297>] x86_64_start_reservat=
ions+0xa7/0xab
>> [ =C2=A0 78.198924] =C2=A0[<ffffffff8283237f>] x86_64_start_kernel+0=
xe4/0xeb
>> [ =C2=A0 78.214540] ---[ end trace be4529f30a2e4ef5 ]---
>
> It appears the thing tries to enable IRQs from within an IRQ handler,
> naughty.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
