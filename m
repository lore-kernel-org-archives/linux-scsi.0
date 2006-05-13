From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] libata support for async scanning
Date: Sat, 13 May 2006 01:16:46 -0400
Message-ID: <44656BBE.7020806@garzik.org>
References: <20060513050529.GS12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38627 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932339AbWEMFQt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 May 2006 01:16:49 -0400
In-Reply-To: <20060513050529.GS12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> I don't think SATA target scanning occupies a huge amount of boot time,
> however it will currently force all async scanners to complete before it
> scans.  The Rolls-Royce solution would be somethinkg akin to the new
> scsi_scan_host(), but I don't think that's necessaary.  This patch just
> acknowledges that async scanning exists and will permit the drive
> additions to finish some time after libata has triggered the probe.

This seems to add needless complexity.

The internal probe is complete before the loop begins.  Thus, 
ata_scan_scan_host() is simply walking data structures in memory (due to 
SCSI simulator) for ATA devices, and for ATAPI devices parallelism is 
largely inadvisable :)  Its overkill, and in some rare cases could make 
debugging more annoying.

	Jeff



