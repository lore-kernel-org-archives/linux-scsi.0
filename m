From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 98171] New: [Regression] Marvell SE91xx SATA 3
 controllers not recognized correctly
Date: Tue, 12 May 2015 15:28:49 -0700
Message-ID: <1431469729.2214.34.camel@HansenPartnership.com>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38121 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932808AbbELWaS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 18:30:18 -0400
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, nucrap@hotmail.com

On Tue, 2015-05-12 at 22:22 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=98171
> 
>             Bug ID: 98171
>            Summary: [Regression] Marvell SE91xx SATA 3 controllers not
>                     recognized correctly
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 3.15
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: nucrap@hotmail.com
>         Regression: No
> 
> Created attachment 176571
>   --> https://bugzilla.kernel.org/attachment.cgi?id=176571&action=edit
> full dmesg of my affected system
> 
> Starting with kernel 3.15 Marvell SE91xx SATA 3 controllers are not getting
> recognized correctly. At early boot process, users get messages similar to
> this:
> 
> kernel: ata16: EH complete
> kernel: ata16.00: configured for UDMA/66
> kernel: ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> kernel: ata16: hard resetting link
> kernel: ata16.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 dma 16640 in
> res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
> kernel: cdb[0]=0x12: 12 01 00 00 ff 00
> kernel: scsi 15:0:0:0: CDB:
> kernel: ata16.00: irq_stat 0x40000001
> kernel: ata16.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x6
> kernel: scsi 15:0:0:0: Processor Marvell 91xx Config 1.01 PQ: 0 ANSI: 5
> kernel: ata8: SATA link down (SStatus 0 SControl 300)

This is a regression against 3.14?  There was only one change affecting
mvsas between those kernels and that was the libsas change:

commit bc6e7c4b0d1a1f742d96556f63d68f17f4e232c3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 14 13:52:48 2014 -0700

    libata, libsas: kill pm_result and related cleanup

Does reverting that make the problem go away?

James


