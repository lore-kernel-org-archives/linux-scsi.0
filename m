From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH] csiostor: switch to pci_alloc_irq_vectors
Date: Tue, 4 Apr 2017 13:49:44 +0530
Message-ID: <20170404081943.GA1665@chelsio.com>
References: <1484325046-31032-1-git-send-email-hch@lst.de>
 <yq1h94tgsvd.fsf@oracle.com>
 <20170331065527.GA3024@lst.de>
 <20170403145124.GA1743@chelsio.com>
 <20170404064614.GA9275@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:42466 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdDDIT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 04:19:56 -0400
Content-Disposition: inline
In-Reply-To: <20170404064614.GA9275@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Apr 04, 2017 at 08:46:14AM +0200, Christoph Hellwig wrote:
> Does this one work better?
>

csiostor driver is triggering following warning during module unload.

WARNING: CPU: 8 PID: 20636 at kernel/irq/manage.c:1480 __free_irq+0xa6/0x2b0
Trying to free already-free IRQ 53
CPU: 8 PID: 20636 Comm: rmmod Tainted: G    B   W  OE   4.11.0-rc5+ #2
Call Trace:
dump_stack+0x63/0x84
__warn+0xd1/0xf0
warn_slowpath_fmt+0x5f/0x80
__free_irq+0xa6/0x2b0
free_irq+0x39/0x90
csio_free_irqs+0x34/0x90 [csiostor]
csio_hw_free+0x12/0xb0 [csiostor]
csio_remove_one+0x6e/0x90 [csiostor]
pci_device_remove+0x39/0xc0
device_release_driver_internal+0x141/0x1f0
driver_detach+0x3f/0x80
bus_remove_driver+0x55/0xd0
driver_unregister+0x2c/0x50
pci_unregister_driver+0x2a/0xa0
csio_exit+0x10/0xf70 [csiostor]
SyS_delete_module+0x1ba/0x220
do_syscall_64+0x67/0x180
entry_SYSCALL64_slow_path+0x25/0x25

kernel/irq/manage.c:1480
1457 static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
1458 {
1459         struct irq_desc *desc = irq_to_desc(irq);
1460         struct irqaction *action, **action_ptr;
1461         unsigned long flags;
1462
	     ...
1475         action_ptr = &desc->action;
1476         for (;;) {
1477                 action = *action_ptr;
1478
1479                 if (!action) {
1480                         WARN(1, "Trying to free already-free IRQ %d\n", irq);
1481                         raw_spin_unlock_irqrestore(&desc->lock, flags);
1482                         chip_bus_sync_unlock(desc);
1483                         return NULL;
1484                 }
1485
1486                 if (action->dev_id == dev_id)
1487                         break;
1488                 action_ptr = &action->next;
1489         }
	     ...
1546 }
