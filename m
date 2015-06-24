From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [Patch V2 7/9] [SCSI] aacraid: Unblock IOCTLs to controller
 once system resumed from suspend
Date: Wed, 24 Jun 2015 05:41:59 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F788A8@BBYEXM01.pmc-sierra.internal>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-9-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:59845 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbbFXFmA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2015 01:42:00 -0400
In-Reply-To: <1433986951-9033-9-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>


-----Original Message-----
From: Rajinikanth Pandurangan 
Sent: Thursday, June 11, 2015 7:12 AM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Mahesh Rajashekhara; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [Patch V2 7/9] [SCSI] aacraid: Unblock IOCTLs to controller once system resumed from suspend

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
	Driver blocks ioctls once it received shutdown/suspend request during
	suspend/hybernation. This patch unblocks ioctls on resume path.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c index 8020348..1142c28 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1448,6 +1448,11 @@ static int aac_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	if (aac_acquire_resources(aac))
 		goto fail_device;
+	/*
+	* reset this flag to unblock ioctl() as it was set at
+	* aac_send_shutdown() to block ioctls from upperlayer
+	*/
+	aac->adapter_shutdown = 0;
 	scsi_unblock_requests(shost);
 
 	return 0;
--
1.9.3

