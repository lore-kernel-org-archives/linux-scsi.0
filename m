From: support <support@degrp.de>
Subject: Megaraid Driver does not load with smp enabled Kernel 2.6.1
Date: Fri, 9 Jan 2004 14:56:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <689781653.20040109145649@degrp.de>
Reply-To: support <support@degrp.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.degrp.org ([62.225.179.11]:12555 "EHLO mail.degrp.de")
	by vger.kernel.org with ESMTP id S261812AbUAIN4z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2004 08:56:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We uses HP Netraid Server with Integrated Netraid Controllers, the megaraid
driver hangs with following error message:

megaraid: couldn't register IRQ 25

it breaks at the following position in the megaraid.c driver

/* Request our IRQ */
                if( adapter->flag & BOARD_MEMMAP ) {
                        if(request_irq(irq, megaraid_isr_memmapped, SA_SHIRQ,
                                                "megaraid", adapter)) {
                                printk(KERN_WARNING
                                        "megaraid: Couldn't register IRQ %d!\n",
                                        irq);
                                goto fail_attach;
                        }
                }
                else {
                        if(request_irq(irq, megaraid_isr_iomapped, SA_SHIRQ,
                                                "megaraid", adapter)) {
                                printk(KERN_WARNING
                                        "megaraid: Couldn't register IRQ %d!\n",
                                        irq);
                                goto fail_attach;
                        }
                }

when i turn off smp and disable the local apic option in the kernel
the driver works fine.

Has anyone a solution for this problem ?? We need smp support on our servers. 

-- 
Best regards,
 Thoams Schend                                   mailto:support@degrp.de

