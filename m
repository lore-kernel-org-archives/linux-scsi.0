From: akpm@linux-foundation.org
Subject: [patch 6/7] initio: fix conflict when loading driver
Date: Tue, 16 Oct 2007 14:28:23 -0700
Message-ID: <200710162128.l9GLSNhf018184@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760124AbXJPV3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 17:29:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com, simps05192@yahoo.com

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

> I have a scanner connected to a Initio INI-950 SCSI card and I recently
> upgraded from SuSE 10.2 to 10.3.  The new kernel doesn't see any of my
> devices.  I get the following in /var/log/messages:
>
> ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level, low) -> IRQ 16
> initio: I/O port range 0x0 is busy.
> ACPI: PCI interrupt for device 0000:00:0a.0 disabled

Humm not a collision - thats a bug in the driver updating.  Looks like the
changes I made and combined with Christoph's lost a line somewhere when I
was merging it all.  Try the following

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Scott Simpson <simps05192@yahoo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/initio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/initio.c~initio-fix-conflict-when-loading-driver drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~initio-fix-conflict-when-loading-driver
+++ a/drivers/scsi/initio.c
@@ -2867,6 +2867,7 @@ static int initio_probe_one(struct pci_d
 	}
 	host = (struct initio_host *)shost->hostdata;
 	memset(host, 0, sizeof(struct initio_host));
+	host->addr = pci_resource_start(pdev, 0);
 
 	if (!request_region(host->addr, 256, "i91u")) {
 		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);
_
