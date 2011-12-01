From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
Subject: RE: [PATCH] SCSI: aacraid: potential integer overflow in aac_get_containers()
Date: Thu, 1 Dec 2011 02:07:33 -0800
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D061FCB70@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37277 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454Ab1LAKHj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 05:07:39 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Haogang Chen <haogangchen@gmail.com>, aacraid@adaptec.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Acked-by: Achim Leubner <Achim_Leubner@pmc-sierra.com>


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Haogang Chen
Sent: Donnerstag, 1. Dezember 2011 03:30
To: aacraid@adaptec.com
Cc: JBottomley@parallels.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; haogangchen@gmail.com
Subject: [PATCH] SCSI: aacraid: potential integer overflow in
aac_get_containers()

There is a potential integer overflow in aac_get_containers(). When
maximum_num_containers is large, the subsequent call to kzalloc() will
allocate a buffer smaller than expected, which leads to memory
corruption in the for loop.

The patch replaces kzalloc with kcalloc.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 drivers/scsi/aacraid/aachba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c
b/drivers/scsi/aacraid/aachba.c
index 409f580..440b84d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -381,7 +381,7 @@ int aac_get_containers(struct aac_dev *dev)
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) *
maximum_num_containers,
+	fsa_dev_ptr = kcalloc(maximum_num_containers,
sizeof(*fsa_dev_ptr), 
 			GFP_KERNEL);
 	if (!fsa_dev_ptr)
 		return -ENOMEM;
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
