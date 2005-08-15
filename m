From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: hwo to adjust interrupt?
Date: Mon, 15 Aug 2005 15:06:02 -0400
Message-ID: <1124132762.5552.104.camel@localhost.localdomain>
References: <OF524C3938.82D78F5A-ON8825705E.00652E9F-8825705E.0067395D@us.ibm.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:7356 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S964887AbVHOTGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 15:06:16 -0400
In-Reply-To: <OF524C3938.82D78F5A-ON8825705E.00652E9F-8825705E.0067395D@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

ic. thanks a lot for explanation.

so these are level sensitive interrupt.

i need to find a hw book now...

Ming

On Mon, 2005-08-15 at 11:47 -0700, Bryan Henderson wrote:
> >so it is possible that both card raise intr quicker than isr run, then
> >both isr will do mmio and go ahead, but then what is
> >
> >device 1 raise intr
> >device 2 isr run and not belong to it, so quit, but before it clear intr
> >and quit
> >device 2 raise intr
> >device 1 isr run and handle device 1, then clear intr and quit.
> >
> >then device 2 intr lost?
> 
> As these are level sensitive interrupt requests, they can't be lost.  As 
> long as Device 2 is requesting service,
> the shared IRQ is raised and at some point Linux will call Device 2's 
> interrupt handler.  Either the first level IRQ handler will keep calling 
> all the interrupt handlers that service that IRQ until the IRQ subsides, 
> or it will unmask the IRQ, causing an immediate new interrupt and the 
> first level interrupt handler runs again and calls all the device drivers 
> again.
> 
> The raised IRQ says, "Device 1 or Device 2 needs service."  The device 
> drivers clear the service request of the individual device; as long as 
> either device requests service, the IRQ is raised.
> 
> --
> Bryan Henderson                     IBM Almaden Research Center
> San Jose CA                         Filesystems
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

