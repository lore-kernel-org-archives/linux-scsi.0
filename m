From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: Unexpected IRQ trap when reloading mptspi with MSI
Date: Thu, 24 Jan 2008 14:14:08 -0500
Message-ID: <4798E380.4060004@cybernetics.com>
References: <4798C61E.1050503@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:2408 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYAXTOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 14:14:04 -0500
In-Reply-To: <4798C61E.1050503@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com
Cc: sathya.prakash@lsi.com

Tony Battersby wrote:
> I get "unexpected IRQ trap at vector dd" when reloading mptspi with MSI
> enabled.  This seems to happen only on dual-channel HBAs; single-channel
> HBAs are unaffected.  It looks like the second channel is generating a
> bogus MSI interrupt while the first channel is being brought up.
>
Update:

With the "IO resource allocation using pci_request_selected_regions API"
patch (http://marc.info/?l=linux-scsi&m=120004270121533&w=4) applied, I
get the following output instead:

Jan 24 13:38:03 kernel: Fusion MPT base driver 3.04.06
Jan 24 13:38:03 kernel: Copyright (c) 1999-2007 LSI Corporation

Jan 24 13:38:07 kernel: Fusion MPT SPI Host driver 3.04.06
Jan 24 13:38:07 kernel: ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 22
(level, low) -> IRQ 19
Jan 24 13:38:07 kernel: mptbase: ioc0: Initiating bringup
Jan 24 13:38:08 kernel: ioc0: LSI53C1030T A0:
Capabilities={Initiator,Target}
Jan 24 13:38:08 kernel: mptbase: ioc0: PCI-MSI enabled
Jan 24 13:38:08 kernel: scsi0 : ioc0: LSI53C1030T A0, FwRev=01032700h,
Ports=1, MaxQ=255, IRQ=222
Jan 24 13:38:13 kernel: ACPI: PCI Interrupt 0000:03:04.1[B] -> GSI 23
(level, low) -> IRQ 20
Jan 24 13:38:13 kernel: mptbase: ioc1: Initiating bringup
Jan 24 13:38:13 kernel: ioc1: LSI53C1030T A0:
Capabilities={Initiator,Target}
Jan 24 13:38:13 kernel: mptbase: ioc1: PCI-MSI enabled
Jan 24 13:38:14 kernel: scsi1 : ioc1: LSI53C1030T A0, FwRev=01032700h,
Ports=1, MaxQ=255, IRQ=221

Jan 24 13:38:39 kernel: ACPI: PCI interrupt for device 0000:03:04.1 disabled
Jan 24 13:38:39 kernel: ACPI: PCI interrupt for device 0000:03:04.0 disabled

Jan 24 13:38:43 kernel: Fusion MPT SPI Host driver 3.04.06
Jan 24 13:38:43 kernel: ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 22
(level, low) -> IRQ 19
Jan 24 13:38:43 kernel: mptbase: ioc2: Initiating bringup
Jan 24 13:38:43 kernel: ioc2: LSI53C1030T A0:
Capabilities={Initiator,Target}
Jan 24 13:38:43 kernel: mptbase: ioc2: PCI-MSI enabled
Jan 24 13:39:03 kernel: mptbase: ioc2: Initiating recovery
Jan 24 13:39:03 kernel: mptbase: ioc2: WARNING - IOC is in FAULT state!!!
Jan 24 13:39:03 kernel: mptbase: ioc2: WARNING - FAULT code = 8112h
Jan 24 13:39:03 kernel: mptbase: ioc2: ERROR - Doorbell ACK timeout
(count=4999), IntStatus=80000001!
Jan 24 13:39:03 kernel: mptbase: ioc2: Recovered from IOC FAULT
Jan 24 13:39:03 kernel: Clocksource tsc unstable (delta = 9373613660 ns)
Jan 24 13:39:03 kernel: scsi2 : ioc2: LSI53C1030T A0, FwRev=01032700h,
Ports=1, MaxQ=255, IRQ=222
Jan 24 13:39:07 kernel: ACPI: PCI Interrupt 0000:03:04.1[B] -> GSI 23
(level, low) -> IRQ 20
Jan 24 13:39:07 kernel: mptbase: ioc3: Initiating bringup
Jan 24 13:39:08 kernel: ioc3: LSI53C1030T A0:
Capabilities={Initiator,Target}
Jan 24 13:39:08 kernel: mptbase: ioc3: PCI-MSI enabled
Jan 24 13:39:08 kernel: scsi3 : ioc3: LSI53C1030T A0, FwRev=01032700h,
Ports=1, MaxQ=255, IRQ=221

This is much more annoying, since reloading the driver takes an extra 20
seconds for the IOC recovery.  I believe the difference may be caused by
the addition of pci_disable_device() to mpt_adapter_dispose().

Tony

