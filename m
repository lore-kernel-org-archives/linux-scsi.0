From: Denis Cheng <crquan@gmail.com>
Subject: [PATCH] 3W RAID drivers: memset not needed in probe
Date: Sat,  8 Dec 2007 23:40:59 +0800
Message-ID: <1197128459-14014-1-git-send-email-crquan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:7523 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbXLHPld (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Dec 2007 10:41:33 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1062884rvb
        for <linux-scsi@vger.kernel.org>; Sat, 08 Dec 2007 07:41:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <linuxraid@amcc.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

the memory return from scsi_host_alloc is alloced by kzalloc,
which is already zero initilized, so memset not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/scsi/3w-9xxx.c |    2 --
 drivers/scsi/3w-xxxx.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index afb262b..cb28511 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2028,8 +2028,6 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 59716eb..a8c12d7 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2295,8 +2295,6 @@ static int __devinit tw_probe(struct pci_dev *pdev, const struct pci_device_id *
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
-- 
1.5.3.4

