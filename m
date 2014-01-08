From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 1/1] aacraid: kdump fix
Date: Wed, 8 Jan 2014 06:34:52 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1A1E275A99@BBYEXM01.pmc-sierra.internal>
References: <1387793273-7284-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:35484 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbaAHGev convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jan 2014 01:34:51 -0500
In-Reply-To: <1387793273-7284-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

Hi James,

Can you please let me know the status of this patch which I submitted sometime back.

Thanks & Regards,
Mahesh

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Monday, December 23, 2013 3:38 PM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH 1/1] aacraid: kdump fix

This patch fixes kernel panic issue while booting into the kdump kernel.

We have triggered crash and kdump vmcore was successful. No issues seen while booting into the OS.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |    2 +-
 drivers/scsi/aacraid/rx.c      |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index 9323d05..eaaf870 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 30200
+# define AAC_DRIVER_BUILD 30300
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c index dada38a..9f2d88f 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -500,13 +500,14 @@ static int aac_rx_restart_adapter(struct aac_dev *dev, int bled)
 		if (bled && (bled != -ETIMEDOUT))
 			return -EINVAL;
 	}
-	if (bled || (var == 0x3803000F)) { /* USE_OTHER_METHOD */
+	if (bled && (var == 0x3803000F)) { /* USE_OTHER_METHOD */
 		rx_writel(dev, MUnit.reserved2, 3);
 		msleep(5000); /* Delay 5 seconds */
 		var = 0x00000001;
 	}
-	if (var != 0x00000001)
+	if (bled && (var != 0x00000001))
 		return -EINVAL;
+	ssleep(5);
 	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
 		return -ENODEV;
 	if (startup_timeout < 300)
--
1.7.7.3

