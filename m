From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Wed, 19 Nov 2008 17:27:18 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884EACB798C4@GVW0547EXC.americas.hpqcorp.net>
References: <0F5B06BAB751E047AB5C87D1F77A77883511810894@GVW0547EXC.americas.hpqcorp.net>
 <48C013D9.7060309@oracle.com>
 <0F5B06BAB751E047AB5C87D1F77A7788413663D229@GVW0547EXC.americas.hpqcorp.net>
 <20080905092838.GS20055@kernel.dk> <48DBF583.3050307@oracle.com>
 <20080925134000.9b133f8c.randy.dunlap@oracle.com>
 <0F5B06BAB751E047AB5C87D1F77A77884BFF5D1F76@GVW0547EXC.americas.hpqcorp.net>
 <49232232.10604@oracle.com> <4923237B.9090707@xenotime.net>
 <4923347D.8000205@oracle.com> <20081119085227.GQ26308@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77884EACB7986A@GVW0547EXC.americas.hpqcorp.net>
 <49244B69.80903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26305 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbYKSR2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Nov 2008 12:28:08 -0500
In-Reply-To: <49244B69.80903@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>



> -----Original Message-----
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> Sent: Wednesday, November 19, 2008 11:23 AM
> To: Miller, Mike (OS Dev)
> Cc: Jens Axboe; scsi; James Bottomley; lkml; akpm
> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
>
> Miller, Mike (OS Dev) wrote:
> >
> >> -----Original Message-----
> >> From: Jens Axboe [mailto:jens.axboe@oracle.com]
> >> Sent: Wednesday, November 19, 2008 2:52 AM
> >> To: Randy Dunlap
> >> Cc: scsi; Miller, Mike (OS Dev); James Bottomley; lkml; akpm
> >> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
> >>
> >> On Tue, Nov 18 2008, Randy Dunlap wrote:
> >>> Randy Dunlap wrote:
> >>>> Randy Dunlap wrote:
> >>>>> Miller, Mike (OS Dev) wrote:
> >>>>>>> -----Original Message-----
> >>>>>>> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> >>>>>>> Sent: Thursday, September 25, 2008 3:40 PM
> >>>>>>> To: scsi
> >>>>>>> Cc: Jens Axboe; Miller, Mike (OS Dev); James Bottomley; lkml;
> >>>>>>> akpm
> >>>>>>> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
> >>>>>>>
> >>>>>>> On Thu, 25 Sep 2008 13:33:07 -0700 Randy Dunlap wrote:
> >>>>>>>
> >>>>>>>> Jens Axboe wrote:
> >>>>>>>>> On Thu, Sep 04 2008, Miller, Mike (OS Dev) wrote:
> >>>>>>>>>>>>>> 0x3bb2 <do_cciss_intr+1649>:    mov    0x2(%r8),%dx
> >>>>>>>>>>>>>> 0x3bb7 <do_cciss_intr+1654>:    test   %dx,%dx
> >>>>>>>>>>>>>> 0x3bba <do_cciss_intr+1657>:    je     0x3f0e
> >>>>>>> <do_cciss_intr+2509>
> >>>>>>>>>>>>>> $ addr2line -e cciss.o -f  do_cciss_intr+0x627
> >>>>>>>>>>>>>> SA5_fifo_full
> >>>>>>>>>>>>>>
> >> /home/rdunlap/linsrc/linux-2.6.27-rc3-git7/drivers/block/cciss.h:
> >>>>>>> 2
> >>>>>>>>>>> 06
> >>>>>>>>>>>>> OK ...that's confusing.  It seems to be saying that
> >>>>>>> ctrlr_info_t
> >>>>>>>>>>>>> * was NULL.  However, I can't see a way of
> >> getting into the
> >>>>>>>>>>> fifo_full
> >>>>>>>>>>>>> callback from do_cciss_intr ..
> >>>>>>>>>>>>> especially not with an NULL host.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> James
> >>>>>>>>>>>> That is weird. Even if we could get there
> >> fifo_full doesn't
> >>>>>>>>>>> do anything but wait for a bit.
> >>>>>>>>>>>
> >>>>>>>>>>> Hi,
> >>>>>>>>>>>
> >>>>>>>>>>> This just happened again.  This time it's on
> >> 2.6.27-rc5-git3.
> >>>>>>>>>>> ~Randy
> >>>>>>>>>> Thanks Randy. I think. :)
> >>>>>>>>>>
> >>>>>>>>>> I'll try to recreate in my lab.
> >>>>>>>>> This looks somewhat strange, mostly like 'c' is NULL
> >> and it's
> >>>>>>>>> oopsing in in removeQ (I don't think Randy's analysis is
> >>>>>>> correct in
> >>>>>>>>> assuming it's 'h' and it's in fifo_full). Given that 'c'
> >>>>>>> cannot be
> >>>>>>>>> NULL, it's c->prev or c->next that are NULL.
> >>>>> This BUG: has happened (now) 5 times today.  Higher
> >> frequency than
> >>>>> usual for some reason.
> >>>>>
> >>>>> I enabled CCISS_DEBUG and added one printk in
> removeQ().  On the
> >>>>> first call
> >>>> s/first/second/
> >>>>
> >>>>
> >>>>> to removeQ(), both c->next and c->prev are NULL.
> >>>>>
> >>>>> Here's the kernel log output from cciss:
> >>> I added a printk() in addQ() as well.  Here's the new output:
> >>>
> >>> HP CISS Driver (v 3.6.20)
> >>> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54 cciss
> >> 0000:42:08.0:
> >>> PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ 54
> command =
> >>> 147 irq = 36 board_id = 3211103c cciss 0000:42:08.0: irq 87 for
> >>> MSI/MSI-X address 0 = fdf80000 cfg base address = 10 cfg
> >> base address
> >>> index = 0 cfg offset = 400 Controller Configuration information
> >>> ------------------------------------
> >>>    Signature = CISS
> >>>    Spec Number = 1
> >>>    Transport methods supported = 0x6
> >>>    Transport methods active = 0x3
> >>>    Requested transport Method = 0x0
> >>>    Coalesce Interrupt Delay = 0x0
> >>>    Coalesce Interrupt Count = 0x1
> >>>    Max outstanding commands = 0x256
> >>>    Bus Types = 0x200000
> >>>    Server Name =
> >>>    Heartbeat Counter = 0x1672
> >>>
> >>>
> >>> Trying to put board into Simple mode I counter got to 1 0
> Controller
> >>> Configuration information
> >>> ------------------------------------
> >>>    Signature = CISS
> >>>    Spec Number = 1
> >>>    Transport methods supported = 0x6
> >>>    Transport methods active = 0x3
> >>>    Requested transport Method = 0x0
> >>>    Coalesce Interrupt Delay = 0x0
> >>>    Coalesce Interrupt Count = 0x1
> >>>    Max outstanding commands = 0x256
> >>>    Bus Types = 0x200000
> >>>    Server Name =
> >>>    Heartbeat Counter = 0x1672
> >>>
> >>>
> >>> cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 87 using DAC
> >>> cciss: intr_pending 8
> >>> cciss: addQ: Qptr=ffff88027e0100b8, c=ffff88007f83e000
> >>> cciss: removeQ: Qptr=ffff88027e0100b8, c=ffff88007f83e000,
> >>> next=ffff88007f83e000, prev=ffff88007f83e000 Sending
> >> 7f83e000 - down
> >>> to controller
> >>> cciss: addQ: Qptr=ffff88027e0100c0, c=ffff88007f83e000
> >>> cciss: intr_pending 8
> >>> cciss:  Read 4 back from board
> >>> cciss: removeQ: Qptr=ffff88027e0100c0, c=ffff88007f840000,
> >>> next=0000000000000000, prev=0000000000000000
> >>> BUG: unable to handle kernel NULL pointer dereference at
> >>> 0000000000000248
> >> Randy, can you post the debug patch you used? The above goes boom
> >> when it attempts to remove a command that isn't on the
> list, the Qptr
> >> in the last example should be empty, hence the oops. So I'd be
> >> interested in seeing what removeQ() calls this is, I'm
> assuming it's
> >> this bit in
> >> do_cciss_intr():
> >>
> >>       ...
> >>               while (c->busaddr != a) {
> >>                        c = c->next;
> >>                        if (c == h->cmpQ)
> >>                                break;
> >>                }
> >>        }
> >>        /*
> >>         * If we've found the command, take it off the
> >>         * completion Q and free it
> >>         */
> >>        if (c->busaddr == a) {
> >>                removeQ(&h->cmpQ, c);
> >>                if (c->cmd_type == CMD_RWREQ) {
> >>                        complete_command(h, c, 0);
> >>                         ...
> >>
> >> If so, what part of the c lookup are you hitting - the on
> that does:
> >>
> >>         c = h->cmd_pool + a2;
> >>
> >> or the c->busaddr check that his shown above?
> >>
> >> --
> > Randy,
> > I still can't reproduce this bug. I have your config file
> on a BL465c w/e200i. Just to confirm, you only see this at
> init time, correct?
>
> Yes, only at init time.
>
> > Please post your debug patch as Jens requested.
>
> Done (separately).
>
> I need to back up a bit.  Yesterday these BUGs happened
> consistenly, so I wondered why.  Then I recalled that for
> debugging another bug/problem, I had changed the test
> system's normal boot kernel from 2.6.25 to 2.6.18-8.  The
> test system is used to build and then boot the new kernel
> *via kexec*, so it's quite possible (or certain) that
> something in the kexec world has been fixed since 2.6.18.  I
> don't recall seeing this problem lately when using 2.6.25 to
> kexec/boot the new test kernel, so I'm quite willing to drop
> the bug for now and then re-open it if I see the problem again.  OK??

Ahhhh, the kexec piece was missing. Now I don't feel quite so clueless. I'm OK with dropping the bug for now. Jens, James?

-- mikem


>
> --
> ~Randy
>
