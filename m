From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] xen/scsifront: use offset_in_page() macro
Date: Sat, 22 Apr 2017 09:21:13 +0800
Message-ID: <b066ac954374a00bca91fadf3f2d5aba0eb8cb0a.1492758340.git.geliangtang@gmail.com>
References: <4dbc77ccaaed98b183cf4dba58a4fa325fd65048.1492758503.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4dbc77ccaaed98b183cf4dba58a4fa325fd65048.1492758503.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geliang Tang <geliangtang@gmail.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use offset_in_page() macro instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 9aa1fe1..a6a8b60 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -434,7 +434,7 @@ static int map_data_for_request(struct vscsifrnt_info *info,
 
 	if (seg_grants) {
 		page = virt_to_page(seg);
-		off = (unsigned long)seg & ~PAGE_MASK;
+		off = offset_in_page(seg);
 		len = sizeof(struct scsiif_request_segment) * data_grants;
 		while (len > 0) {
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
-- 
2.9.3
