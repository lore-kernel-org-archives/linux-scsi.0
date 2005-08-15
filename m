From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: hwo to adjust interrupt?
Date: Mon, 15 Aug 2005 11:47:23 -0700
Message-ID: <OF524C3938.82D78F5A-ON8825705E.00652E9F-8825705E.0067395D@us.ibm.com>
References: <1123869997.5546.98.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:16591 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964898AbVHOSrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 14:47:25 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7FIlOmV024105
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:47:24 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7FIlLPJ244608
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:47:24 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7FIlK3a021440
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:47:20 -0400
In-Reply-To: <1123869997.5546.98.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

>so it is possible that both card raise intr quicker than isr run, then
>both isr will do mmio and go ahead, but then what is
>
>device 1 raise intr
>device 2 isr run and not belong to it, so quit, but before it clear intr
>and quit
>device 2 raise intr
>device 1 isr run and handle device 1, then clear intr and quit.
>
>then device 2 intr lost?

As these are level sensitive interrupt requests, they can't be lost.  As 
long as Device 2 is requesting service,
the shared IRQ is raised and at some point Linux will call Device 2's 
interrupt handler.  Either the first level IRQ handler will keep calling 
all the interrupt handlers that service that IRQ until the IRQ subsides, 
or it will unmask the IRQ, causing an immediate new interrupt and the 
first level interrupt handler runs again and calls all the device drivers 
again.

The raised IRQ says, "Device 1 or Device 2 needs service."  The device 
drivers clear the service request of the individual device; as long as 
either device requests service, the IRQ is raised.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

