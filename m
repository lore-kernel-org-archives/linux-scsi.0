From: "Cameron, Steve" <steve.cameron@hp.com>
Subject: SCSI_IOCTL_DOORLOCK in scsi_request_fn()
Date: Wed, 30 Mar 2005 14:57:23 -0600
Message-ID: <45B36A38D959B44CB032DA427A6E10640A7A5266@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:34986 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S261567AbVC3U50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2005 15:57:26 -0500
Received: from cceexg12.americas.cpqcorp.net (cceexg12.americas.cpqcorp.net [16.81.1.38])
	by ccerelbas04.cce.hp.com (Postfix) with ESMTP id CBAAA2000350
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2005 14:57:23 -0600 (CST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have a question about what's going on in scsi_request_fn()
wrt locking the doors on devices.

In /usr/src/linux/drivers/scsi/scsi_lib.c in function scsi_request_fn()
from a redhat 2.4.21-15.EL kernel on ia64 I find this:

    931                 /*
    932                  * FIXME(eric)
    933                  * I am not sure where the best place to do this is.  We
need
    934                  * to hook in a place where we are likely to come if in user
    935                  * space.   Technically the error handling thread should be
    936                  * doing this crap, but the error handler isn't used by
    937                  * most hosts.
    938                  */
    939                 if (SDpnt->was_reset) {
    940                         /*
    941                          * We need to relock the door, but we might
    942                          * be in an interrupt handler.  Only do this
    943                          * from user space, since we do not want to
    944                          * sleep from an interrupt.
    945                          *
    946                          * FIXME(eric) - have the error handler thread do
    947                          * this work.
    948                          */
    949                         SDpnt->was_reset = 0;
    950                         if (SDpnt->removable && !in_interrupt()) {
    951                                 atomic_dec(&SHpnt->host_busy);
    952                                 spin_unlock_irq(q->queue_lock);
    953                                 scsi_ioctl(SDpnt, SCSI_IOCTL_DOORLOCK, 0);
    954                                 spin_lock_irq(q->queue_lock);
    955                                 continue;
    956                         }
    957                 }

Am I right in thinking that if a command is retried due to a scsi bus reset for example if a cable is pulled and reattached, then the door on the device will be locked?

I'm seeing this sort of behavior while running some storage SNMP agents and my tape library is getting the doors locked, (sort of unexpectedly.)

Thanks,

-- steve
