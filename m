From: Kenn Humborg <kenn@linux.ie>
Subject: Locking in NCR5380_select
Date: Sun, 8 Aug 2004 23:38:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040808223809.GB17161@excalibur.research.wombat.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.mail.iol.ie ([193.120.142.151]:5579 "EHLO
	mail1.mail.iol.ie") by vger.kernel.org with ESMTP id S265410AbUHHWiN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Aug 2004 18:38:13 -0400
Received: from dialup0870.ts005.bmt.esat.net ([212.2.175.102] helo=excalibur.research.wombat.ie)
	by mail1.mail.iol.ie with esmtp (Exim 3.36 #9)
	id 1BtwIt-0000Nx-00
	for linux-scsi@vger.kernel.org; Sun, 08 Aug 2004 23:38:11 +0100
Received: from excalibur.research.wombat.ie (IDENT:YmWFteTJm4gI3PtwmbsZsPHRLXCOZ21m@excalibur [127.0.0.1])
	by excalibur.research.wombat.ie (8.12.10/8.12.10) with ESMTP id i78Mc92Q019676
	for <linux-scsi@vger.kernel.org>; Sun, 8 Aug 2004 23:38:09 +0100
Received: (from kenn@localhost)
	by excalibur.research.wombat.ie (8.12.10/8.12.10/Submit) id i78Mc9X7019675
	for linux-scsi@vger.kernel.org; Sun, 8 Aug 2004 23:38:09 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I'm working on the Linux/VAX port and I'm writing a driver for a
5380 SCSI controller.  Running on UP with CONFIG_DEBUG_SPINLOCK=y
throws up some locking problems in NCR5380_main and NCR5380_select.

NCR5380_main expects NCR5380_select to always return with the host
adapter lock acquired.  However, there is inconsistent locking within
NCR5380_select (I've removed most of the code, but left in all the
spinlock calls, and return paths):

static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
{

        if (hostdata->selecting) {
                if(instance->irq != SCSI_IRQ_NONE)
                        spin_unlock_irq(instance->host_lock);
                goto part2;     /* RvC: sorry prof. Dijkstra, but it keeps the
                                   rest of the code nearly the same */
        }

...
        if(instance->irq != SCSI_IRQ_NONE)
                spin_unlock_irq(instance->host_lock);

        /* We can be relaxed here, interrupts are on, we are
           in workqueue context, the birds are singing in the trees */

        err = NCR5380_poll_politely(instance, INITIATOR_COMMAND_REG, 
		ICR_ARBITRATION_PROGRESS, ICR_ARBITRATION_PROGRESS, 5*HZ);
	if(instance->irq != SCSI_IRQ_NONE)
                spin_lock_irq(instance->host_lock);
...

part2:
        /* RvC: here we enter after a sleeping period, or immediately after
           execution of part 1
           we poll only once ech clock tick */
        value = NCR5380_read(STATUS_REG) & (SR_BSY | SR_IO);

        if (!value && (hostdata->select_time < HZ/4)) {
...
                return 0;       /* RvC: we return here with hostdata->selecting set,
                                   to go to sleep */
        }
        hostdata->selecting = 0;        /* clear this pointer, because we passed the
                                           waiting period */
        if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
                NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
                if(instance->irq != SCSI_IRQ_NONE)
                        spin_lock_irq(instance->host_lock);
...
                return -1;
        }
...

        if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
                NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
                if (hostdata->targets_present & (1 << cmd->device->id)) {
...
                        return -1;
                }
                if(instance->irq != SCSI_IRQ_NONE)
                        spin_lock_irq(instance->host_lock);
...
                return 0;
        }
...
        if(instance->irq != SCSI_IRQ_NONE)
                spin_lock_irq(instance->host_lock);
...
        return 0;

        /* Selection failed */
failed:
        if(instance->irq != SCSI_IRQ_NONE)
                spin_lock_irq(instance->host_lock);
        return -1;
}


There are two ways to get to the part2: label.  The straight-line path
arrives with lock acquired.  The jumped path when it's 'selecting' 
leaves the lock unacquired.

What's more, the exit paths after part2: are confused.  The first and
third early exits above seem to expect the lock to be held.  The second 
early exit path and the main exit path expect the lock to be not held.

I don't know the SCSI subsystem at all, so I'm not sure how to go about
fixing this.  What exactly is instance->host_lock arbitrating access to?
Would it be safe to drop the lock again just before part2: and acquire
it again in the 2 exit paths that don't already do it?

Later,
Kenn

