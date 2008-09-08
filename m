From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Mon, 8 Sep 2008 14:13:31 -0700
Message-ID: <20080908211331.GC22598@plap4-2.qlogic.org>
References: <20080904093929.GA29006@orion.carnet.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:35045 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYIHVNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2008 17:13:32 -0400
Content-Disposition: inline
In-Reply-To: <20080904093929.GA29006@orion.carnet.hr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josip Rodin <joy@entuzijast.net>
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 04 Sep 2008, Josip Rodin wrote:

> Here we go again :/ This is the failing boot log, attached is the config of
> the kernel that doesn't work.
> 
> boot: linux
> Allocated 8 Megs of memory at 0x40000000 for kernel
<snip>
> qla2xxx 0001:00:04.0: LIP reset occured (f8ef).[34;48H
> scsi1 : qla2xxx[34;16H
> qla2xxx 0001:00:04.0: LIP occured (f8ef).[34;42H
> qla2xxx 0001:00:04.0: LOOP UP detected (1 Gbps).[34;49H
> Unable to handle kernel NULL pointer dereference[34;49H
> tsk->{mm,active_mm}->context = 00000000000000e0[34;48H
> tsk->{mm,active_mm}->pgd = fffff8007c90e000[34;44H
>               \|/ ____ \|/[34;27H
>               "@'/ .. \`@"[34;27H
>               /_| \__/ |_\[34;27H
>                  \__U_/[34;24H
> qla2xxx_1_dpc(771): Oops [#1][34;30H
> TSTATE: 0000004480009604 TPC: 000000000058ecf4 TNPC: 000000000058ecf8 Y: 000003
>     Not tainted[34;17H
> TPC: <fc_flush_work+0x1c/0x40>[34;31H
> g0: fffff8007cf770a1 g1: 0000000000000000 g2: fffff8007c014000 g3: 000000040020
> g4: fffff8007e0d0580 g5: fffff8007f6a0000 g6: fffff8007cf74000 g7: 20000004cf2b
> o0: 0000000000692588 o1: 0000000000000003 o2: 0000000000000001 o3: 000000000000
> o4: 0000000000000000 o5: 00007fffffffe000 sp: fffff8007cf770c1 ret_pc: 00000000044e90c[34;8H
> RPC: <complete+0x44/0x48>[34;26H
> l0: fffff8007c016940 l1: 000000000000000f l2: fffff8007e4000b0 l3: 000000000000000[34;4H
> l4: fffff8007e054870 l5: 0000000000000008 l6: fffff8007c89c000 l7: 00000000004fc40[34;4H
> i0: fffff8007c014000 i1: 0000000000000000 i2: 0000000000000000 i3: fffff8007c984a0[34;4H
> i4: 0000000000000000 i5: 0000000000000000 i6: fffff8007cf77181 i7: 0000000000512ac[34;4H
> I7: <fc_remote_port_add+0x18/0x664>[34;36H
> Caller[00000000005912ac]: fc_remote_port_add+0x18/0x664[34;56H
> Caller[000000001003c0e4]: qla2x00_update_fcport+0x2b0/0x368 [qla2xxx][34;70H
> Caller[000000001003ca98]: qla2x00_configure_loop+0x85c/0x1a18 [qla2xxx][34;72H
> Caller[000000001003dcd0]: qla2x00_loop_resync+0x7c/0x10c [qla2xxx][34;67H
> Caller[0000000010039f50]: qla2x00_do_dpc+0x60c/0x6e8 [qla2xxx][34;63H
> Caller[000000000046aec4]: kthread+0x4c/0x78[34;44H
> Caller[0000000000426df8]: kernel_thread+0x38/0x48[34;50H
> Caller[000000000046acec]: kthreadd+0xc4/0x1a0[34;46H

That's odd, as fc_flush_work() is quite minimal:

	static void
	fc_flush_work(struct Scsi_Host *shost)
	{
		if (!fc_host_work_q(shost)) {
			printk(KERN_ERR
				"ERROR: FC host '%s' attempted to flush work, "
				"when no workqueue created.\n", shost->hostt->name);
			dump_stack();
			return;
		}

		flush_workqueue(fc_host_work_q(shost));
	}

there's not much chance here for a NULL-dereference.  Since we have
know good and bad points, could you possibly git-bisect this to help
troubleshoot?  Also, are you seeing similar problems with Linus'
latest tree?

--
AV
