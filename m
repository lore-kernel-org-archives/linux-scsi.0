From: akpm@linux-foundation.org
Subject: [patch 03/17] 3W RAID drivers: memset not needed in probe
Date: Fri, 28 Mar 2008 14:48:33 -0700
Message-ID: <200803282148.m2SLmXH5012222@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757089AbYC1Vsp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:48:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, crquan@gmail.com, linuxraid@amcc.com

From: Denis Cheng <crquan@gmail.com>

The memory return from scsi_host_alloc is alloced by kzalloc, which is
already zero initilized, so memset not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Adam Radford <linuxraid@amcc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/3w-9xxx.c |    2 --
 drivers/scsi/3w-xxxx.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN drivers/scsi/3w-9xxx.c~3w-raid-drivers-memset-not-needed-in-probe drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~3w-raid-drivers-memset-not-needed-in-probe
+++ a/drivers/scsi/3w-9xxx.c
@@ -2026,8 +2026,6 @@ static int __devinit twa_probe(struct pc
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
diff -puN drivers/scsi/3w-xxxx.c~3w-raid-drivers-memset-not-needed-in-probe drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c~3w-raid-drivers-memset-not-needed-in-probe
+++ a/drivers/scsi/3w-xxxx.c
@@ -2287,8 +2287,6 @@ static int __devinit tw_probe(struct pci
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
_
