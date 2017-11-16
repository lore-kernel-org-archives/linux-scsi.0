From: Niklas Cassel <niklas.cassel@axis.com>
Subject: [PATCH] scsi: pmcraid: use correct size unit when calling find_first_zero_bit()
Date: Thu, 16 Nov 2017 18:38:06 +0100
Message-ID: <20171116173806.18378-1-niklas.cassel@axis.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:55507 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934432AbdKPRiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2017 12:38:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <niklass@axis.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

find_first_zero_bit()'s parameter 'size' is defined in bits,
not in bytes.

Signed-off-by: Niklas Cassel <niklas.cassel@axis.com>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4f9f115fb6a0..04ce838546f4 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5216,7 +5216,7 @@ static unsigned short pmcraid_get_minor(void)
 {
 	int minor;
 
-	minor = find_first_zero_bit(pmcraid_minor, sizeof(pmcraid_minor));
+	minor = find_first_zero_bit(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
 	__set_bit(minor, pmcraid_minor);
 	return minor;
 }
-- 
2.14.2
