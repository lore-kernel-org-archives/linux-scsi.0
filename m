From: Jamie Lenehan <lenehan@twibble.org>
Subject: [2.6 patch] SCSI dc395x.c: store pci device pointer
Date: Tue, 16 Nov 2004 07:26:33 +1100
Message-ID: <20041115202633.GA26928@twibble.org>
References: <20041115015609.GG2249@stusta.de> <20041115202231.GA26873@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nynaeve.twibble.org ([202.173.155.194]:2457 "EHLO
	nynaeve.twibble.org") by vger.kernel.org with ESMTP id S261682AbUKOU0h
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 15:26:37 -0500
Content-Disposition: inline
In-Reply-To: <20041115202231.GA26873@twibble.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-scsi@vger.kernel.org

Store the PCI device pointer into the adapter control block. This is
used in the pci_map_*/pci_unmap_* calls and previously it would have
been set to NULL. This appears to be no problem for x86 but is a
problem for sparc64.

Signed-off-by: Jamie Lenehan <lenehan@twibble.org>

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2004-06-30 20:10:13.939701006 +1000
+++ b/drivers/scsi/dc395x.c	2004-06-30 20:10:38.683969224 +1000
@@ -4820,6 +4820,7 @@
 	}
  	acb = (struct AdapterCtlBlk*)scsi_host->hostdata;
  	acb->scsi_host = scsi_host;
+ 	acb->dev = dev;
 
 	/* initialise the adapter and everything we need */
  	if (adapter_init(acb, io_port_base, io_port_len, irq)) {

-- 
 Jamie Lenehan <lenehan@twibble.org>
