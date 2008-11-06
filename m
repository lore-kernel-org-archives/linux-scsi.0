From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb =
 ffff88006a338480
Date: Thu, 6 Nov 2008 09:57:57 -0800
Message-ID: <20081106095757.2c2fcdc3.akpm@linux-foundation.org>
References: <20081105174905.27194494.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0811061030370.2568-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbYKFR6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 12:58:12 -0500
In-Reply-To: <Pine.LNX.4.44L0.0811061030370.2568-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Brian Kysela <bkysela@gmail.com>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 6 Nov 2008 10:36:50 -0500 (EST) Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 5 Nov 2008, Andrew Morton wrote:
> 
> > On Thu, 30 Oct 2008 17:35:57 -0400
> > Brian Kysela <bkysela@gmail.com> wrote:
> > 
> > > On kernels ranging from 2.6.26 - 2.6.28-rc2
> > 
> > So 2.6.25 was OK?
> > 
> > > on an Intel P4 3.2GHz HT x86-64
> > > cpu, I am seeing a bug that occurs about half the time when copying ~300MB
> > > data from a usb flash drive (FAT) to hard drive (XFS). There are three
> > > possible outcomes, so far, when I hit the bug:
> > > 
> > >     (1) The copy process hangs, cpu wait hits 100% and load avg climbs until
> > >         reboot;
> > >     (2) The copy process hangs and then recovers and then one of:
> > >         (a) the cpu wait & load avg both decline to normal; or
> > >         (b) cpu wait hovers at 100% and the load avg slowly climbs until reboot;
> > >     (3) Kernel bug reported and machine locks up.
> > > 
> > > Result (1) is the most frequent. Result (3) happened only twice out of about 40
> > > tests. I lose the full traces, but here are two relevant lines that I see on
> > > screen before the machine locks up:
> > > 
> > > kernel BUG at /home/brian/linux-2.6/block/elevator.c:841!
> > > invalid opcode: 0000 [#1] PREMPT SMP
> > 
> > It is unclear what kernel version produced that message, and that is
> > important information.  In 2.6.28-rc2, block/elevator.c:841 is
> > 
> >     void elv_dequeue_request(struct request_queue *q, struct request *rq)
> >     {
> > -->>	BUG_ON(list_empty(&rq->queuelist));
> > 	BUG_ON(ELV_ON_HASH(rq));
> > 
> > please confirm that I have the correct line there.
> > 
> > 
> > I assume that you're hitting a bug in the USB storage code and this is
> > triggering consistency-checking code in the block layer.
> > 
> > > When (1) or (2b) occurs I pull the usb drive to see what happens. In two cases
> > > (3) occurred, but more often I get this in /var/log/syslog:
> > 
> > The other things you saw were most likely a consequence of the
> > BUG_ON().
> 
> In theory, this sort of thing could have been caused by changes to the 
> block-layer timeout handling in 2.6.28-rc.  But those changes are not 
> present in 2.6.26 or 2.6.27.
> 
> Note that the syslog shows a lockdep violation occurring _before_ the 
> error message from usb-storage.  This suggests the problem originates 
> somewhere else.
> 
> The error message:
> 
> > [  152.701070] usb-storage: Error in queuecommand: us->srb = ffff88007dfd0680
> 
> means that the SCSI layer has told usb-storage to start a new command 
> before the old one completed.  This could happen, for example, if the 
> SCSI layer had gotten confused and tried to cancel a command that 
> wasn't running -- then it would think usb-storage was idle when in fact 
> it was still busy.  (This was the failure mechanism resulting from the 
> timeout changes.)
> 

OK, thanks.  I'll cc linux-scsi, but I have this-wont-be-getting-fixed
feelings on this one :(

I wonder what's special about Brian's setup.
