From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] SCSI-sg: Improve a size determination in sg_alloc()
Date: Fri, 25 Aug 2017 22:25:17 +0200
Message-ID: <e2406fbf-3a35-316a-4d38-b474c13d9120@users.sourceforge.net>
References: <0fffccee-7cc1-1321-2c6b-00ac06b304b8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0fffccee-7cc1-1321-2c6b-00ac06b304b8@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 25 Aug 2017 21:55:14 +0200

Replace the specification of a data type by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8ca10a2fc1a0..4a2db7ff14cc 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1403,7 +1403,7 @@ sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	int error;
 	u32 k;
 
-	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
+	sdp = kzalloc(sizeof(*sdp), GFP_KERNEL);
 	if (!sdp)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.14.0
