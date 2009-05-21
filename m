From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: ipr boot failure caused by MSI (2.6.30-rc1+)
Date: Thu, 21 May 2009 13:47:14 -0500
Message-ID: <4A15A1B2.8060609@linux.vnet.ibm.com>
References: <1242926159.3007.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39535 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbZEUSrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 May 2009 14:47:14 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4LInd5g028919
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2009 14:49:39 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4LIlG89243862
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2009 14:47:16 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4LIlF7O008518
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2009 14:47:15 -0400
In-Reply-To: <1242926159.3007.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Wayne Boyer <wayneb@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>

cc'ing linuxppc-dev...

-Brian


James Bottomley wrote:
> Kernels after 2.6.30-rc1 stopped booting on my powerstation.  The ipr
> just times out and refuses to probe devices.  If I let it drop into the
> initramfs system, this is what the interrupts shows:
> 
> (initramfs) cat /proc/interrupts 
>            CPU0       CPU1       CPU2       CPU3       
>  16:         20         10         13         11   MPIC      Level     pata_amd
>  20:          0          0          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
>  21:          0          0          0          0  MPIC-U3MSI Edge      ipr
>  68:         37         37         48         37   MPIC      Edge      serial
> 251:         10         71         69         72   MPIC      Edge      ipi call function
> 252:       1555       1779       1372       1155   MPIC      Edge      ipi reschedule
> 253:          0          0          0          0   MPIC      Edge      ipi call function single
> 254:          0          0          0          0   MPIC      Edge      ipi debugger
> BAD:        416
> 
> So you see the IPR is the only device not receiving them.
> 
> I can fix the boot hang by reverting
> 
> commit 5a9ef25b14d39b8413364df12cb8d9bb7a673a32
> Author: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> Date:   Fri Jan 23 09:17:35 2009 -0800
> 
>     [SCSI] ipr: add MSI support
> 
> The system in question is:
> 
> SYSTEM INFORMATION
>  Processor  = PowerPC,970MP @ 2500 MHz
>  I/O Bridge = U4 (4.4)
>  SMP Size   = 4 (#0 #1 #2 #3)
>  Boot-Date  = 2009-04-21 17:13:36
>  Memory     = 2 GB of RAM @ 666 MHz
>  Board Type = Bimini (7047191/0000000/1)
>  MFG Date   = 1608
>  Part No.   = 10N8748     
>  FRU No.    = 10N7182     
>  FRU Serial = YL30W8106038
>  UUID       = 00000000000000000000000000000000
>  Flashside  = 1 (temporary)
>  Version    = HEAD
>  Build Date = 12-04-2008 16:13
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


