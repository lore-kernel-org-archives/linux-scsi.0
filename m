From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Tue, 13 May 2003 11:51:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513185107.GD1626@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <20030512151553.GA22417@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:65227 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262454AbTEMSgE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 14:36:04 -0400
Content-Disposition: inline
In-Reply-To: <20030512151553.GA22417@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@san.rr.com>, linux-scsi@vger.kernel.org

Andrew Vasquez [praka@san.rr.com] wrote:
> On Thu, 08 May 2003, Mike Anderson wrote:
> 
> > This series of patches is an update to the scsi_host sysfs / ref
> > counting patches previously merged into the scsi-misc-2.5 tree. 
> > 
> > insmod / rmmod Testing:
> > 	Legacy registration:
> > 		aic7xxx_old, qlogicisp
> > 		qla2xxx v8.00.00b1 - Driver oops system with garbled
> > 		messages on rmmod. Does not seem related to this patch.
> > 
> 
> Is the driver still oops'ng during your testing?  Could you provide
> some specifics on attached storage as well as environment (fabric,
> loop, hba type)?  I'll resync my working tree with scsi-misc and
> perform some additional investigation.

The driver is still oops'ng on current scsi-misc-2.5, but I tried
linux-2.5 bk 2.5.69+ (change set 1.1095) and it did not oops after
multiple insmod/rmmod cycles.

I do not get consistent oops, but the one below occurs frequently on
rmmod. I will track it down more on my system and see if there are
changes between linux-2.5 and scsi-misc that would address what I am
seeing.

My configuration is 2 qla2300, IBM 2109 switch, IBM FASTt 200, 10 FC
JBOD disks.

-andmike
--
Michael Anderson
andmike@us.ibm.com

Unable to handle kernel paging request at virtual address d08a9110
 printing eip:
d08a9110
*pde = 00000000
Oops: 0000 [#1]
CPU:    1
EIP:    0060:[<d08a9110>]    Not tainted
EFLAGS: 00010246
EIP is at 0xd08a9110
eax: 00000000   ebx: c12ba000   ecx: cb967948   edx: c12bbf24
esi: cb9641c0   edi: c1287f80   ebp: c1287f80   esp: c12bbf10
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c12ba000 task=c12bc6a<10>)Un
abSlet atcko: h acn0dl1e2 d1kce0r ncebl 9p6a4g1cin0g  rce12bqbuefs24t
a<t4> vci12rbtbuaf2l4  add0dr8eas9s11 d00 8ca9c128510f
8  p<4r>icnct2i8n5gf e48 ip:0
000d0080a19 11<40>           0

* pd  e    =  bf<4ff>fcf03699
0U8n abflffe ftfof fdha nd0l0e00 k00er46n elc 0pa12gi8cn6gb
recq03u9es2ta0 8 at <v4i>0r0tu00a0l0 a0d4 dr0e0ssed 70aff8f0 f2ca412
b f7prci n<ti4>ng   b
e i p :           
 c0<14>1cd0012078
a0* p<d4e>c 0=1 1a5953ba50a 5a0
00fff cdc22084 c0391f00 ce560080 c01089a0 c01089a0 
Call Trace:
 [<c012d1c0>] run_timer_softirq+0x1c0/0x270
 [<c0128c6b>] do_softirq+0x6b/0xd0
 [<c01089a0>] default_idle+0x0/0x40
 [<c01193b0>] smp_apic_timer_interrupt+0x140/0x160
 [<c01089a0>] default_idle+0x0/0x40
 [<c01089a0>] default_idle+0x0/0x40
 [<c010b8ce>] apic_timer_interrupt+0x1a/0x20
 [<c01089a0>] default_idle+0x0/0x40
 [<c01089a0>] default_idle+0x0/0x40
 [<c01089ca>] default_idle+0x2a/0x40
 [<c0108a72>] cpu_idle+0x52/0x70
 [<c0125533>] release_console_sem+0xd3/0x190


