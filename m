From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: queuecommand called in IRQ run level
Date: Mon, 25 Aug 2003 08:32:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF2C371F5D.96455F3A-ONC1256D8D.0022F047-C1256D8D.002454AB@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate-5.de.ibm.com ([194.196.100.238]:32695 "EHLO
	d12lmsgate.de.ibm.com") by vger.kernel.org with ESMTP
	id S261547AbTHYGeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 02:34:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@il.marvell.com>
Cc: linux-scsi@vger.kernel.org


It's better to avoid any schedule in queuecommand.
First, the io_request_lock is held (irqsave) when your queuecommand
routine is called. Second, queuecommand is called from scsi_request_fn,
which is usually executed when completed SCSI command are processed,
which is done in a bottom half.
This applies to 2.4, and I suspect 2.6 is similar in that regard.

Martin

Rabeeh Khoury <rabeeh@il.marvell.com>@vger.kernel.org on 24/08/2003
19:46:02

Sent by:    linux-scsi-owner@vger.kernel.org


To:    linux-scsi@vger.kernel.org
cc:
Subject:    queuecommand called in IRQ run level


Hi All,

Is it possible that queuecommand be called in ISR time ? (IRQ run level)
I want to do kmalloc with GFP_KERNEL priority in queuecommand (or
actually pci_pool_alloc which eventually will call kmalloc in pool
getting low in memory).

Thank you,
Rabeeh


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




