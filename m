From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 7/9] [SCSI] aacraid: Unblock IOCTLs to controller once
 system resumed from suspend
Date: Fri, 15 May 2015 02:57:44 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F6ACFE@BBYEXM01.pmc-sierra.internal>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1431562378-8514-8-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60561 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423341AbbEOC5p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2015 22:57:45 -0400
In-Reply-To: <1431562378-8514-8-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

-----Original Message-----
From: rajinikanth.pandurangan@pmcs.com [mailto:rajinikanth.pandurangan@pmcs.com] 
Sent: Thursday, May 14, 2015 5:43 AM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [PATCH 7/9] [SCSI] aacraid: Unblock IOCTLs to controller once system resumed from suspend

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
	Driver blocks ioctls once it received shutdown/suspend request during
	suspend/hybernation. This patch unblocks ioctls on resume path.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c index 62a928f..d977cd2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1363,6 +1363,11 @@ static int aac_resume(struct pci_dev *pdev)
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

