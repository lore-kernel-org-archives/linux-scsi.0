From: Andrew Morton <akpm@digeo.com>
Subject: Re: aic7xxx woes in 2.5
Date: Mon, 16 Dec 2002 01:40:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFD9F89.4B994586@digeo.com>
References: <3DFC059A.9AA3F75F@digeo.com> <23290000.1039982976@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id BAA12662
	for <linux-scsi@vger.kernel.org>; Mon, 16 Dec 2002 01:40:27 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

"Justin T. Gibbs" wrote:
> 
> > For about six months in the 2.5 series, using aic7xxx, about every fourth
> > boot one of my disks tends to get:
> >
> > (scsi1:A:4:0): parity-error detected in Data-in phase: SEQADDR(0x1ae)
> > SCSIRATE(0x88) scsi1:0:4:0: Attempting to queue an ABORT message
> >
> > This is invariably fatal.
> 
> ...
> 
> > This never happens in 2.4 kernels.
> >
> > It seems to happen a little more frequently on uniprocessor builds.
> >
> > So relevant questions would be:
> >
> > 1) Why does only 2.5 get the parity error?
> 
> Most likely different loads on your SCSI bus.  The driver can't "make up"
> SCSI bus parity errors.

It's very consistent.  Never seen on 2.4.

> > 2) Why does the recovery lock up?
> 
> I would actually have to know the sequencer instruction that we
> are blocked on in the clear_critical_sections code to be able to
> say.  Several recovery bugs have been fixed in later driver versions.

OK, let's move on then.
 
> > 3) Does anyone have a diff for Justin's new driver?
> 
> Just populate the scsi/aic7xxx directory with the files found
> here:
> 
> http://people.FreeBSD.org/~gibbs/linux/SRC/
> 
> You will need to merge in the Kconfig and Makefile for the scsi
> directory, but if you are running a fairly recent kernel, you
> can just overwrite those files with those supplied in the linux-2.5
> archive supplied at the above URL.

That's very awkward and will hamper efforts to get testing done.

I grafted it into the 2.5.52 tree.  The Kconfig entries for
aix7xxx_old seem to be lost.


The driver still has a serious bug in ahc_linux_queue_recovery_cmd().
It does

	ahc_unlock(ahc, &s);

where local variable `s' is uninitialised.  But that gets copied
into the CPU's interrupt flag.


The driver got through recognising the disks and then locked up
strangely:

Program received signal SIGEMT, Emulation trap.
cache_alloc_refill (cachep=0xd00675a0, flags=0) at include/linux/list.h:127
127             prev->next = next;
(gdb) bt
#0  cache_alloc_refill (cachep=0xd00675a0, flags=0) at include/linux/list.h:127
#1  0x00000246 in ?? ()
#2  0xc0135947 in kmalloc (size=256, flags=0) at mm/slab.c:1652
#3  0xc0239835 in ahc_linux_dv_inq (ahc=0xc175e400, cmd=0xc3dd0c00, devinfo=0xc3d77fb0, targ=0xc3dcee00, request_length=96)
    at drivers/scsi/aic7xxx/aic7xxx_osm.c:3303
#4  0xc0237f5d in ahc_linux_dv_target (ahc=0xc175e400, target_offset=4) at drivers/scsi/aic7xxx/aic7xxx_osm.c:2060
#5  0xc0237d47 in ahc_linux_dv_thread (data=0xc175e400) at drivers/scsi/aic7xxx/aic7xxx_osm.c:1955

This is an NMI watchdog interrupt.  In here:

1571                    while (slabp->inuse < cachep->num && batchcount--)
1572                            ac_entry(ac)[ac->avail++] =
1573                                    cache_alloc_one_tail(cachep, slabp);

Presumably due to errors in use of slab-allocated memory.


So I enabled slab debugging and:


Program received signal SIGTRAP, Trace/breakpoint trap.
0xc013606f in kfree (objp=0xc3da5ed4) at mm/slab.c:1452
1452                            BUG();
(gdb) bt
#0  0xc013606f in kfree (objp=0xc3da5ed4) at mm/slab.c:1452
#1  0xc023bca1 in ahc_linux_free_target (ahc=0xc175c000, targ=0xc3dcf800) at drivers/scsi/aic7xxx/aic7xxx_osm.c:4588
#2  0xc023bdbd in ahc_linux_free_device (ahc=0xc175c000, dev=0xc3da4ba4) at drivers/scsi/aic7xxx/aic7xxx_osm.c:4642
#3  0xc023c36d in ahc_done (ahc=0xc175c000, scb=0xc3d78070) at drivers/scsi/aic7xxx/aic7xxx_osm.c:4858
#4  0xc02296bd in ahc_run_qoutfifo (ahc=0xc175c000) at drivers/scsi/aic7xxx/aic7xxx_core.c:344
#5  0xc023b93a in ahc_linux_isr (irq=35, dev_id=0xc175c000, regs=0xd0003f74) at drivers/scsi/aic7xxx/aic7xxx_inline.h:600
#6  0xc010c710 in handle_IRQ_event (irq=35, regs=0xd0003f74, action=0xc3d9c974) at arch/i386/kernel/irq.c:210
#7  0xc010c8f2 in do_IRQ (regs=
      {ebx = -805298176, ecx = 384, edx = -805298176, esi = -1072657832, edi = 0, ebp = -805290072, eax = 17, xds = 104, xes = -1072693144, orig_eax = -221, eip = -1072657788, xcs = 96, eflags = 582, esp = -805290056, xss = -1072657690}) at arch/i386/kernel/irq.c:391
#8  0xc010b114 in common_interrupt () at include/linux/kallsyms.h:39
#9  0xc0108ae6 in cpu_idle () at arch/i386/kernel/process.c:144
#10 0xc039553a in start_secondary (unused=0xc038692d) at arch/i386/kernel/smpboot.c:467

That's in here:

        if (cachep->flags & SLAB_RED_ZONE) {
                objp -= BYTES_PER_WORD;
                if (xchg((unsigned long *)objp, RED_MAGIC1) != RED_MAGIC2)
                        /* Either write before start, or a double free. */
                        BUG();

Presumably a double free in ahc_linux_free_target()

I can debug further if you like, but would really appreciate unified
diffs, thanks.
