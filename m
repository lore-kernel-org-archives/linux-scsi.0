From: Lukasz Kosewski <lkosewsk@nit.ca>
Subject: Re: SCSI aic7xxx driver: Initialization Failure over a kdump reboot
Date: Fri, 07 Jan 2005 09:55:36 -0500
Message-ID: <41DEA2E8.8030701@nit.ca>
References: <1105014959.2688.296.camel@2fwv946.in.ibm.com>	<1105013524.4468.3.camel@laptopd505.fenrus.org> <20050106195043.4b77c63e.akpm@osdl.org> <41DE15C7.6030102@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:741 "EHLO
	tomts22-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S261430AbVAGOfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 09:35:45 -0500
In-Reply-To: <41DE15C7.6030102@nit.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Arjan van de Ven <arjan@infradead.org>, vgoyal@in.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> Andrew Morton wrote:
> 
>>> looks like the following is happening:
>>> the controller wants to send an irq (probably from previous life)
>>> then suddenly the driver gets loaded
>>> * which registers an irq handler
>>> * which does pci_enable_device()
>>> and .. the irq goes through. the irq handler just is not yet 
>>> expecting this irq, so
>>> returns "uh dunno not mine"
>>> the kernel then decides to disable the irq on the apic level
>>> and then the driver DOES need an irq during init
>>> ... which never happens.
>>>
>>
>>
>> yes, that's exactly what e100 was doing on my laptop last month.  Fixed
>> that by arranging for the NIC to be reset before the call to
>> pci_set_master().

After reading this again when I /wasn't/ semi-comatose, I retract my 
statement insofar as it wouldn't help you (but I think it's still rather 
necessary) :)

The system did exactly what I'm talking about (which it didn't do for 
me, possibly because the board/processor didn't support APIC).  I guess 
my question to you is:  do you have other devices sharing this 
interrupt?  In other words, are you /sure/ that it's the adaptec 
controller which is setting the interrupt line high?

Luke Kosewski
Human Cannonball
Net Integration Technologies
