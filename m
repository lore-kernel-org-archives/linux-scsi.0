From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] bfa: fix strncpy() limiter in bfad_start_ops()
Date: Thu, 10 Jan 2013 12:06:20 +0300
Message-ID: <20130110090620.GE23063@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39264 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3AJJG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2013 04:06:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

The closing parenthesis is in the wrong place so it takes the sizeof a
pointer instead of the sizeof the buffer minus one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e6bf126..a5f7690 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1034,7 +1034,7 @@ bfad_start_ops(struct bfad_s *bfad) {
 			sizeof(driver_info.host_os_patch) - 1);
 
 	strncpy(driver_info.os_device_name, bfad->pci_name,
-		sizeof(driver_info.os_device_name - 1));
+		sizeof(driver_info.os_device_name) - 1);
 
 	/* FCS driver info init */
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
