From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: fix lpfc_wwn_set return code check
Date: Tue, 17 Jan 2017 12:31:56 -0800
Message-ID: <587e7f3c.EKLGPnLKIhbcA+IJ%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33864 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdAQUcv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 15:32:51 -0500
Received: by mail-qt0-f194.google.com with SMTP id a29so24168481qtb.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 12:31:59 -0800 (PST)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id d15sm19700010qkb.10.2017.01.17.12.31.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2017 12:31:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


When I reversed the patch to re-add the lpfc_soft_wwn parameter feature,
it re-added code that had a long-standing bug. (that's what I
get I guess :)

As Dan Carpenter pointed out - error checks looked at wrong polarity.
0 is success, -errno is failure. Updated checks.

-- james

Signed-off-by: James Smart <james.smart@broadcom.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 6c104d7..50cf402 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2150,7 +2150,7 @@ lpfc_soft_wwpn_store(struct device *dev, struct device_attribute *attr,
 	phba->soft_wwn_enable = 0;
 
 	rc = lpfc_wwn_set(buf, cnt, wwpn);
-	if (!rc) {
+	if (rc) {
 		/* not able to set wwpn, unlock it */
 		phba->soft_wwn_enable = 1;
 		return rc;
@@ -2231,7 +2231,7 @@ lpfc_soft_wwnn_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	rc = lpfc_wwn_set(buf, cnt, wwnn);
-	if (!rc) {
+	if (rc) {
 		/* Allow wwnn to be set many times, as long as the enable
 		 * is set. However, once the wwpn is set, everything locks.
 		 */
-- 
2.5.0

