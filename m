From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] scsi: set fmt to NULL scsi_extd_sense_format() by default
Date: Tue, 2 Dec 2014 14:07:30 +0300
Message-ID: <20141202110729.GA17562@mwanda>
References: <1417277275.2202.35.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46713 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaLBLHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 06:07:46 -0500
Content-Disposition: inline
In-Reply-To: <1417277275.2202.35.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

One of the two callers passes an unintialized pointer as "fmt" and
expects it to be set to NULL if there is no format string.  Let's make
this function work as expected.

Fixes: d811b848ebb7 ('scsi: use sdev as argument for sense code printing')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:  Change scsi_extd_sense_format() instead of the caller

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index aee62f6..e2068a2 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1271,6 +1271,7 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 	int i;
 	unsigned short code = ((asc << 8) | ascq);
 
+	*fmt = NULL;
 	for (i = 0; additional[i].text; i++)
 		if (additional[i].code12 == code)
 			return additional[i].text;
@@ -1282,6 +1283,8 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 			return additional2[i].str;
 		}
 	}
+#else
+	*fmt = NULL;
 #endif
 	return NULL;
 }
