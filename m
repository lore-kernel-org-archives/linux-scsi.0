From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: SCSI aic7xxx driver: Initialization Failure over a kdump reboot
Date: Thu, 06 Jan 2005 13:12:03 +0100
Message-ID: <1105013524.4468.3.camel@laptopd505.fenrus.org>
References: <1105014959.2688.296.camel@2fwv946.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:37126 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S262750AbVAFMMK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 07:12:10 -0500
In-Reply-To: <1105014959.2688.296.camel@2fwv946.in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux scsi <linux-scsi@vger.kernel.org>

On Thu, 2005-01-06 at 18:05 +0530, Vivek Goyal wrote:
> 
> In my machine Adaptec SCSI controller is not managing any devices. It
> is
> a lonely controller.
> 

looks like the following is happening:
the controller wants to send an irq (probably from previous life)
then suddenly the driver gets loaded
* which registers an irq handler
* which does pci_enable_device()
and .. the irq goes through. 
the irq handler just is not yet expecting this irq, so
returns "uh dunno not mine"
the kernel then decides to disable the irq on the apic level
and then the driver DOES need an irq during init
... which never happens.




