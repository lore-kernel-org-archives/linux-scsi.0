From: Andrew Morton <akpm@osdl.org>
Subject: Re: SCSI aic7xxx driver: Initialization Failure over a kdump reboot
Date: Thu, 6 Jan 2005 19:50:43 -0800
Message-ID: <20050106195043.4b77c63e.akpm@osdl.org>
References: <1105014959.2688.296.camel@2fwv946.in.ibm.com>
	<1105013524.4468.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59544 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261203AbVAGDvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2005 22:51:02 -0500
In-Reply-To: <1105013524.4468.3.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: vgoyal@in.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote:
>
> On Thu, 2005-01-06 at 18:05 +0530, Vivek Goyal wrote:
>  > 
>  > In my machine Adaptec SCSI controller is not managing any devices. It
>  > is
>  > a lonely controller.
>  > 
> 
>  looks like the following is happening:
>  the controller wants to send an irq (probably from previous life)
>  then suddenly the driver gets loaded
>  * which registers an irq handler
>  * which does pci_enable_device()
>  and .. the irq goes through. 
>  the irq handler just is not yet expecting this irq, so
>  returns "uh dunno not mine"
>  the kernel then decides to disable the irq on the apic level
>  and then the driver DOES need an irq during init
>  ... which never happens.
> 

yes, that's exactly what e100 was doing on my laptop last month.  Fixed
that by arranging for the NIC to be reset before the call to
pci_set_master().

I expect the adaptec driver could be fixed by calling ahc_reset() from a
strategic place in either ahc_linux_pci_dev_probe() or in the shutdown
handler.  (Does the crashdump code call shutdown handlers?  Sounds like a
bad idea...)
