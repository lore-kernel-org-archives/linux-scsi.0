From: Lukasz Kosewski <lkosewsk@nit.ca>
Subject: Re: SCSI aic7xxx driver: Initialization Failure over a kdump reboot
Date: Thu, 06 Jan 2005 23:53:27 -0500
Message-ID: <41DE15C7.6030102@nit.ca>
References: <1105014959.2688.296.camel@2fwv946.in.ibm.com>	<1105013524.4468.3.camel@laptopd505.fenrus.org> <20050106195043.4b77c63e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts20.bellnexxia.net ([209.226.175.74]:58525 "EHLO
	tomts20-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S261233AbVAGEdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 23:33:36 -0500
In-Reply-To: <20050106195043.4b77c63e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Arjan van de Ven <arjan@infradead.org>, vgoyal@in.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton wrote:
>> looks like the following is happening:
>> the controller wants to send an irq (probably from previous life)
>> then suddenly the driver gets loaded
>> * which registers an irq handler
>> * which does pci_enable_device()
>> and .. the irq goes through. 
>> the irq handler just is not yet expecting this irq, so
>> returns "uh dunno not mine"
>> the kernel then decides to disable the irq on the apic level
>> and then the driver DOES need an irq during init
>> ... which never happens.
>>
> 
> 
> yes, that's exactly what e100 was doing on my laptop last month.  Fixed
> that by arranging for the NIC to be reset before the call to
> pci_set_master().

I noticed the exact same thing with a usb-uhci hub on a VIA MicroATX
board a month back.  I rewrote the init sequence of the driver so that
it resets all of the hubs in the system first, and THEN registers their
interrupts.

This seems like a problem that CAN happen with level-triggered
interrupts.  Us fixing it in individual drivers is not the solution; we
need a general solution.

I have an idea of something I might do for 2.6.11, but I doubt anyone
will actually agree with it.  Say we keep a counter of how many times
interrupt x has been fired off since the last timer interrupt
(obviously, a timer interrupt resets the counter).  Then we can pick an
arbitrary threshold for masking out this interrupt until another device
actually pines for it.

Or something.  The point is, we need a general solution to the problem,
not poking about in every single driver trying to tie it down.

Luke Kosewski
Human Cannonball
Net Integration Technologies
