From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata driver update posted
Date: Sat, 19 Jul 2003 22:51:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F1A03C5.8010705@pobox.com>
References: <m3ispyx79n.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:65227 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270604AbTGTChF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2003 22:37:05 -0400
In-Reply-To: <m3ispyx79n.fsf@lugabout.jhcloos.org>
List-Id: linux-scsi@vger.kernel.org
To: "James H. Cloos Jr." <cloos@jhcloos.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James H. Cloos Jr. wrote:
> 00:1f.1 Class 0101: 8086:244a (rev 03)
>         Subsystem: 8086:4541
>         Flags: bus master, medium devsel, latency 0
>         I/O ports at bfa0 [size=16]
[...]
> root=/dev/sda3 failed to find the root fs.
[...]
> Is my controller among the supported PIIX/ICH PATA chipsets?


Yes, all you need to do is add another PCI id for your chipset to 
drivers/scsi/ata_piix.c:

+ { 0x8086, 0x244a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix4_pata },

Once I add cable detection (PATA is currently limited to UDMA/33), this 
PCI ID entry will change slightly, but the above should get you going.

Note again that ATAPI isn't supported yet...

	Jeff



