From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [bisected] Latest git not seeing HD with sata_nv
Date: Tue, 22 Apr 2008 16:47:25 -0700
Message-ID: <86802c440804221647y51fba831wcd176dd37533b655@mail.gmail.com>
References: <adazlrlcw9f.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:43135 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYDVXr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 19:47:27 -0400
Received: by py-out-1112.google.com with SMTP id u52so3800809pyb.10
        for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 16:47:26 -0700 (PDT)
In-Reply-To: <adazlrlcw9f.fsf@cisco.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Apr 22, 2008 at 4:20 PM, Roland Dreier <rdreier@cisco.com> wrote:
> It seems that commit 305d2a1a ("libata: unify mechanism to request
>  follow-up SRST") causes sata_nv not to see the HD on a system I have
>  here; with current git (80750147), I get this in my bootlog:
>
>  [    2.425108] Driver 'sd' needs updating - please use bus_type methods
>  [    2.435751] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
>  [    2.441508] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
>  [    2.452929] sata_nv 0000:00:05.0: Using SWNCQ mode
>  [    2.457892] scsi0 : sata_nv
>  [    2.461813] scsi1 : sata_nv
>  [    2.465891] ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 23
>  [    2.473034] ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 23
>  [    2.565962] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>  [    3.003517] ata2: SATA link down (SStatus 0 SControl 300)
>  [    3.137171] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
>  [    3.142926] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 22 (level, low) -> IRQ 22
>  [    3.151675] sata_nv 0000:00:05.1: Using SWNCQ mode
>  [    3.156582] scsi2 : sata_nv
>  [    3.160553] scsi3 : sata_nv
>
>  ie no HD is found, even thought he ata1 link comes up, which of course
>  leads to:
>
>  [    4.763274] VFS: Cannot open root device "sda1" or unknown-block(0,0)
>  [    4.769724] Please append a correct "root=" boot option; here are the available partitions:
>
>  and the system is dead.
>
>  I did a bisection and came up with 305d2a1a as the culprit.  Then I
>  applied the revert patch below by hand (since 305d2a1a doesn't revert
>  entirely cleanly), and things worked again:
>
good. my test system had the same problem. just want to start the bisect

other things in the bisect list
1. clocktest is broken.
2. kexec RHEL 5.1 the mpt sas only can support 2 cards...


YH
