From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [Bugme-new] [Bug 6020] New: Intel Corporation 80960RP [i960RP Microprocessor] (rev 03) not detected
Date: Mon, 6 Feb 2006 13:35:25 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265142055@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59555 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964800AbWBFUff convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 15:35:35 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org
Cc: "Kolli, Neela" <Neela.Kolli@engenio.com>

Hi,

On Monday, February 06, 2006 2:33 PM Andrew Morton wrote:
> I have an ooold HP Netserver LH3 with this raid controller:
> Intel Corporation 80960RP [i960RP Microprocessor] (rev 03)
> 0000:00:07.1 0100: 8086:1960 (rev 03)
>         Subsystem: 103c:10c7
> 
> 
> It was working well with the megaraid driver of kernel 2.4.26. 
> But now I wanted to bring the machine to a recent 2.6 kernel. 
> I have set
> 
> CONFIG_MEGARAID_NEWGEN=y
> CONFIG_MEGARAID_MM=y
> CONFIG_MEGARAID_MAILBOX=y
> CONFIG_MEGARAID_SAS=y
> 
> At boottime the megaraid driver reports its existence, but in 
> contrast to the
> 2.4 kernel, it doesn't say that it had detected disks. And 
> then the kernel stops
> with panic, claiming that it can't find its root device (/dev/sda1)
This is an issue related to PCI ID overlap in between legacy and new megaraid drivers. 
I had taken care of the issue long time back but, for some reason, 2.6.15.2 kernel still has following conditional statement in the Kconfig.megaraid.
---
if MEGARAID_NEWGEN=n
config MEGARAID_LEGACY
	...
	...
endif
---
This condition prevents 'LSI Logic Legacy MegaRAID driver' to be available as an option.
So, it has to be as follows,
---
config MEGARAID_LEGACY
	...
	...
---
If you use the kernel available on git and do 'make menuconfig', you will see this option available and you will be able to load megaraid driver v2.00.3 for the HP controllers.

Thank you,



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Andrew Morton
> Sent: Monday, February 06, 2006 2:33 PM
> To: linux-scsi@vger.kernel.org
> Cc: Kolli, Neela
> Subject: Fw: [Bugme-new] [Bug 6020] New: Intel Corporation 
> 80960RP [i960RP Microprocessor] (rev 03) not detected
> 
> 
> 
> Begin forwarded message:
> 
> Date: Mon, 6 Feb 2006 04:38:03 -0800
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 6020] New: Intel Corporation 
> 80960RP [i960RP Microprocessor] (rev 03) not detected
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=6020
> 
>            Summary: Intel Corporation 80960RP [i960RP 
> Microprocessor] (rev
>                     03) not detected
>     Kernel Version: 2.6.15.2
>             Status: NEW
>           Severity: normal
>              Owner: andmike@us.ibm.com
>          Submitter: hadmut@danisch.de
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution: Debian
> Hardware Environment: HP Netserver LH3
> Software Environment:
> Problem Description:
> 
> Hi,
> 
> I have an ooold HP Netserver LH3 with this raid controller:
> Intel Corporation 80960RP [i960RP Microprocessor] (rev 03)
> 0000:00:07.1 0100: 8086:1960 (rev 03)
>         Subsystem: 103c:10c7
> 
> 
> It was working well with the megaraid driver of kernel 2.4.26. 
> But now I wanted to bring the machine to a recent 2.6 kernel. 
> I have set
> 
> CONFIG_MEGARAID_NEWGEN=y
> CONFIG_MEGARAID_MM=y
> CONFIG_MEGARAID_MAILBOX=y
> CONFIG_MEGARAID_SAS=y
> 
> At boottime the megaraid driver reports its existence, but in 
> contrast to the
> 2.4 kernel, it doesn't say that it had detected disks. And 
> then the kernel stops
> with panic, claiming that it can't find its root device (/dev/sda1)
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
