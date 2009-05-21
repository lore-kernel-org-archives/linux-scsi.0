From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ipr boot failure caused by MSI (2.6.30-rc1+)
Date: Thu, 21 May 2009 12:23:03 -0500
Message-ID: <1242926583.3007.7.camel@localhost.localdomain>
References: <1242926159.3007.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40986 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbZEURXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 May 2009 13:23:02 -0400
In-Reply-To: <1242926159.3007.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: Brian King <bjking1@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2009-05-21 at 12:15 -0500, James Bottomley wrote:
> I can fix the boot hang by reverting
> 
> commit 5a9ef25b14d39b8413364df12cb8d9bb7a673a32
> Author: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> Date:   Fri Jan 23 09:17:35 2009 -0800
> 
>     [SCSI] ipr: add MSI support
> 

Just as a follow up, after reverting the above and booting successfully,
this is what /proc/interrupts now shows:

claymoor:~# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
 16:         31         24         35         19   MPIC      Level     pata_amd, serial
 17:        374        421        434        381   MPIC      Level     ipr
 20:          0          0          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
 21:        135        140        152        146  MPIC-U3MSI Edge      eth1
 68:         59         66         60         57   MPIC      Edge      serial
251:         65        124        119        108   MPIC      Edge      ipi call function
252:       1018       1383       1127        746   MPIC      Edge      ipi reschedule
253:          0          0          0          0   MPIC      Edge      ipi call function single
254:          0          0          0          0   MPIC      Edge      ipi debugger
BAD:        621

So MSI seems to be being used successfully on the ethernet controller,
pointing to an ipr specific problem.

James


