From: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Sat, 19 Jul 2003 03:05:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F189955.6040308@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dbl.q-ag.de ([80.146.160.66]:41603 "EHLO dbl.q-ag.de")
	by vger.kernel.org with ESMTP id S271823AbTGSA5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 20:57:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Arjan van de Ven <arjanv@redhat.com>

Andrew wrote:

>>  - qla2x00_intr_handler should use spin_lock, not spin_lock_irqsave
>
>Are you sure about that?  I'll need to refresh my interrupt handling
>know-how...
>  
>
It's an optimization that is used by many drivers:
Interrupt handlers are never reentered - if you are within 
qla2x00_intr_handler handling irq x, then it's guaranteed that the 
function won't be reentered by another occurance of the same interrupt.
If your driver registers only one interrupt handler, then you can skip 
disabling the local interrupts - a deadlock is not possible.

You need _irqsave if the spinlock is shared between multiple instances 
of the hba, with different interrupts (i.e. it's possible that 
qla2x00_intr_handler is called for irq y while handling irq x).

--
    Manfred




