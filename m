From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [6/6] - use pci resource len
Date: Thu, 21 Aug 2003 20:17:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821101759.GG7570@twibble.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org> <20030821101525.GC7570@twibble.org> <20030821101619.GD7570@twibble.org> <20030821101658.GE7570@twibble.org> <20030821101729.GF7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:43410 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262571AbTHUKR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:17:59 -0400
Content-Disposition: inline
In-Reply-To: <20030821101729.GF7570@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Instead of hard coding the number of io ports (to the wrong value no
less) use the pci_resource_length to determine the number.

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-20 21:39:11.817249304 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-20 21:39:19.213124960 +1000
@@ -5843,7 +5843,7 @@
 		return -ENODEV;
 	}
 	io_port_base = pci_resource_start(dev, 0) & PCI_BASE_ADDRESS_IO_MASK;
-	io_port_len = 0x80;	/* XXX: use pci_resource_len? */
+	io_port_len = pci_resource_len(dev, 0);
 	irq = dev->irq;
 	dprintkdbg(DBG_0, "IO_PORT=%04x, IRQ=%x\n", io_port_base, dev->irq);
 

-- 
 Jamie Lenehan <lenehan@twibble.org>
