From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: Initialize rx/rkt function pointers before calling them
Date: Fri, 27 Apr 2007 14:47:37 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF018FD9D2@otce2k301.adaptec.com>
References: <46323CB8.6060903@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51597 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012AbXD0Srj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 14:47:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46323CB8.6060903@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Vivek Goyal <vgoyal@in.ibm.com>, Judith Lebzelter <judith@linux-foundation.org>

Maybe we should consider something like:

         dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
         dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
-        dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
-        if ((((status & 0xff) != 0xff) || reset_devices) &&
+        if (reset_devices &&
          !aac_rx_restart_adapter(dev, 0))
                ++restart;
        /*
         *      Check to see if the board panic'd while booting.

As an option for a patch (later), what was the actual value of the
Munit.OIMR register (on the x3550 and the x3650 please, just in case)?
The BIOS should not be enabling any interrupts, I will be checking if
they have needed to in some variants(IBM?) for customization or
chip(Aurora interface?) reasons...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Darrick J. Wong [mailto:djwong@us.ibm.com] 
> Sent: Friday, April 27, 2007 2:11 PM
> To: Salyzyn, Mark
> Cc: linux-scsi@vger.kernel.org; Alexis Bruemmer; Vivek Goyal; 
> Judith Lebzelter
> Subject: Re: [PATCH] aacraid: Initialize rx/rkt function 
> pointers before calling them
> 
> 
> Salyzyn, Mark wrote:
> 
> > In my unit tests of aacraid_kexec_5.patch, restart was not 
> called for
> > normal operations. If you are just doing a normal boot, 
> what conditions
> > are causing restart to be called in your case? Is it a warm restart?
> > Some kind of operation that leaves the Adapter in an 
> initialized state,
> > or a bug in the driver making sure that interrupts are disabled when
> > shut down. Inquiring minds want to know!
> 
> This is a normal boot of a "Serveraid 8k-l" on an IBM x3550.  One
> wrinkle in the configuration is that the system is booted off the
> network, though I don't see how that would affect the aacraid's state.
> It looks like the MUnit.OIMR test just after the "Failure to 
> reset here
> is an option..." comment is succeeding.  The crash seems to happen
> regardless of whether we had just done a warm or cold boot.  
> The option
> ROM had run during POST, if that makes any difference.  No kexec/kdump
> have been configured.  For that matter, neither kexec nor kdump have
> ever been run in the lifetime of the machine.
> 
> Also observed on an IBM x3650.
> 
> --D
> 
