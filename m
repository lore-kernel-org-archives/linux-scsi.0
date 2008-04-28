From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Mon, 28 Apr 2008 17:34:01 +0900
Message-ID: <20080428173459B.tomof@acm.org>
References: <20080428013400.GA6245@elte.hu>
	<1209351113.3801.107.camel@localhost.localdomain>
	<48157B6A.60307@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50891 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765958AbYD1Ifr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 04:35:47 -0400
In-Reply-To: <48157B6A.60307@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 10:23:22 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Mon, Apr 28 2008 at 5:51 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Mon, 2008-04-28 at 03:34 +0200, Ingo Molnar wrote:
> >> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>
> >>> This represents the tree I had waitin on other mergers.  I'm not sure 
> >>> this is it, because there are other features (like aic94xx running 
> >>> abort) we're racing to get in.
> >>>
> >>> The patch is available at:
> >>>
> >>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> >> hm, got this crash with latest -git shortly after i rebased from this 
> >> morning's git to this night's git, it looks SCSI related:
> >>
> >> [   44.513114] Calling initcall 0xc1cece47: init_this_scsi_driver+0x0/0xd0()
> >> [   47.919053] BUG: unable to handle kernel NULL pointer dereference at 00000004
> >> [   47.927035] IP: [<c09cf947>] scsi_destroy_command_freelist+0x15/0x5a
> >> [   47.931008] *pde = 00000000 
> >> [   47.935253] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> >> [   47.939004] Modules linked in:
> >> [   47.939004] 
> >> [   47.939004] Pid: 1, comm: swapper Not tainted (2.6.25-sched-devel.git-x86-latest.git #5)
> >> [   47.939004] EIP: 0060:[<c09cf947>] EFLAGS: 00010217 CPU: 0
> >> [   47.939004] EIP is at scsi_destroy_command_freelist+0x15/0x5a
> >> [   47.939004] EAX: c0042000 EBX: 00000000 ECX: c199ba14 EDX: fffffffc
> >> [   47.939004] ESI: c0042000 EDI: c0042034 EBP: f7c36ebc ESP: f7c36eb0
> >> [   47.939004]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> >> [   47.939004] Process swapper (pid: 1, ti=f7c36000 task=f7c4e000 task.ti=f7c36000)
> >> [   47.939004] Stack: c0042000 00000000 00000000 f7c36ecc c09cfa4c c004225c c1a43378 f7c36ed4 
> >> [   47.939004]        c0688535 f7c36ee8 c04e942b c0042260 c04e93e6 00000330 f7c36ef8 c04e9f20 
> >> [   47.939004]        c004225c 00000002 f7c36f04 c04e9353 c0042000 f7c36f0c c0688aee f7c36f14 
> >> [   47.939004] Call Trace:
> >> [   47.939004]  [<c09cfa4c>] ? scsi_host_dev_release+0x79/0xa9
> >> [   47.939004]  [<c0688535>] ? device_release+0x3e/0x54
> >> [   47.939004]  [<c04e942b>] ? kobject_release+0x45/0x55
> >> [   47.939004]  [<c04e93e6>] ? kobject_release+0x0/0x55
> >> [   47.939004]  [<c04e9f20>] ? kref_put+0x3e/0x49
> >> [   47.939004]  [<c04e9353>] ? kobject_put+0x41/0x46
> >> [   47.939004]  [<c0688aee>] ? put_device+0x16/0x18
> >> [   47.939004]  [<c09cf9d1>] ? scsi_host_put+0x12/0x14
> >> [   47.939004]  [<c09cfbac>] ? scsi_unregister+0x1d/0x20
> >> [   47.939004]  [<c1cece2d>] ? aha1542_detect+0x7d1/0x7eb
> >> [   47.939004]  [<c016de2e>] ? trace_hardirqs_on+0xb/0xd
> >> [   47.939004]  [<c1cece52>] ? init_this_scsi_driver+0xb/0xd0
> >> [   47.939004]  [<c01922a7>] ? ftrace_record_ip+0x1d4/0x1ed
> >> [   47.939004]  [<c1cecea5>] ? init_this_scsi_driver+0x5e/0xd0
> >> [   47.939004]  [<c1c934e5>] ? kernel_init+0x152/0x2b0
> >> [   47.939004]  [<c1c93393>] ? kernel_init+0x0/0x2b0
> >> [   47.939004]  [<c1c93393>] ? kernel_init+0x0/0x2b0
> >> [   47.939004]  [<c011c967>] ? kernel_thread_helper+0x7/0x10
> >> [   47.939004]  =======================
> >> [   47.939004] Code: ff eb 0c 89 fa 83 c0 04 e8 78 ba b2 ff 31 d2 5b 89 d0 5e 5f 5d c3 55 89 e5 57 56 53 e8 cf d0 74 ff 89 c6 8d 78 34 eb 1c 8d 53 fc <8b> 42 08 8b 4a 04 89 41 04 89 08 89 5a 08 89 5a 04 8b 46 10 e8 
> >> [   47.939004] EIP: [<c09cf947>] scsi_destroy_command_freelist+0x15/0x5a SS:ESP 0068:f7c36eb0
> >  
> > sigh, every time I fix this free list stuff in one place, it breaks in
> > another.  This one is caused by the alloc->put sequence for the host (it
> > never got to scsi_add_host() where the freelist is allocated, so we need
> > to not release it in that case).
> > 
> > Try this; the signature for an uninitialised free list is easy (both
> > list pointers NULL), so the patch detects that and doesn't try to run
> > over the uninitialised list head.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 12d69d7..dc36321 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -481,6 +481,14 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
> >   */
> >  void scsi_destroy_command_freelist(struct Scsi_Host *shost)
> >  {
> > +	if (shost->free_list.next == NULL && shost->free_list.prev == NULL)
> > +		/*
> > +		 * If the next and prev pointers are NULL, that
> > +		 * means the list was never initialised, so it
> > +		 * doesn't need freeing
> > +		 */
> > +		return;
> > +
> >  	while (!list_empty(&shost->free_list)) {
> >  		struct scsi_cmnd *cmd;
> >  
> > 
> > 
> > --
> 
> If we are already on the subject. It looks like we always have at most 1 command in the 
> free list, so why the free list at all? or am I reading the code wrong?

scsi_add_host sets up one free command. If you call scsi_host_alloc
and then scsi_host_put (some LLDs do on their failure path), you hit
the above problem.
