From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/2] be2iscsi: null dereference on error path
Date: Thu, 10 Jun 2010 09:53:05 +0200
Message-ID: <20100610075305.GJ5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32816 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0FJHxX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2010 03:53:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

"phba" is always null here so we can't dereference it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 779e1d1..efadde9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3774,8 +3774,8 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
-		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
-			     "Failed to enable pci device \n");
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+			" Failed to enable pci device\n");
 		return ret;
 	}
 
