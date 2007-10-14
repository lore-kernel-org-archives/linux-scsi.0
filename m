From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: [git patches] libata update
Date: Sun, 14 Oct 2007 12:35:08 +0200
Message-ID: <64bb37e0710140335g648a86ebmebdf32a6068abcf8@mail.gmail.com>
References: <20071012194002.GA1545@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:3392 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbXJNKfK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 06:35:10 -0400
Received: by py-out-1112.google.com with SMTP id u77so2422472pyb
        for <linux-scsi@vger.kernel.org>; Sun, 14 Oct 2007 03:35:09 -0700 (PDT)
In-Reply-To: <20071012194002.GA1545@havoc.gtf.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 10/12/07, Jeff Garzik <jeff@garzik.org> wrote:
> [ I just sent this upstream to Andrew and Linus ]
> * Turn on ACPI by default (watch for bug reports!).  This should make
>   suspend/resume work a lot better.

Bug report for 2.6.23-mm1:
scsi8 : pata_amd
scsi9 : pata_amd
ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index
(0FFFFFFFF) is beyond end of object [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.GTM_] (Node ffff810100318a20), AE_AML_PACKAGE_LIMIT
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.CHN0._GTM] (Node ffff8101003187c0),
AE_AML_PACKAGE_LIMIT
ata9: ACPI get timing mode failed (AE 0x300d)
ata9.01: ATA-7: Maxtor 6L250R0, BAH41G10, max UDMA/133
ata9.01: 490234752 sectors, multi 16: LBA48
ata9.01: limited to UDMA/33 due to 40-wire cable
ata9.01: configured for UDMA/33
ata10: port disabled. ignoring.

libata-Bug, ACPI-Bug or just bad code in the BIOS?
The detection of the 40-wire cable is correct, also that there is only
one drive at this IDE port.

pata_amd is build as module and is driving the IDE part of a nVidia MCP55.

Torsten
