From: Dan Carpenter <error27@gmail.com>
Subject: [patch] wd7000: typo spin_unlock_irq() => spin_lock_irq()
Date: Thu, 1 Apr 2010 18:55:16 +0300
Message-ID: <20100401155516.GF5265@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Miroslav Zagorac <zaga@fly.cc.fer.hr>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Adam Buchbinder <adam.buchbinder@gmail.com>, Jiri Kosina <jkosina@suse.cz>, jgarzik@pobox.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This was introduced back in 2005 at the very start of the git era by:
	df0ae2497ddefd72a87f3a3b34ff32455d7d4ae0
	[SCSI] allow sleeping in ->eh_host_reset_handler()

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Also this driver was written before some of our youngest kernel hackers
were born.  Neat.  :)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 2f6e9d8..bdfe59d 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1588,7 +1588,7 @@ static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	if (wd7000_adapter_reset(host) < 0) {
 		spin_unlock_irq(SCpnt->device->host->host_lock);
