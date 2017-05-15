From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aacraid: fix leak of data from stack back to userspace
Date: Mon, 15 May 2017 15:56:05 +0100
Message-ID: <20170515145605.21461-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The fields sense_data_size and sense_data are unitialized garbage from
the stack and are being copied back to userspace.  Fix this leak of
stack information by ensuring they are zero'd.

Detected by CoverityScan, CID#1435473 ("Uninitialized scalar variable")

Fixes: 423400e64d377 ("scsi: aacraid: Include HBA direct interface")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/commctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 106b9332f718..6bb6ed48e31d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -955,6 +955,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			reply.srb_status = SRB_STATUS_SUCCESS;
 			reply.scsi_status = 0;
 			reply.data_xfer_length = byte_count;
+			reply.sense_data_size = 0;
+			memset(reply.sense_data, 0, AAC_SENSE_BUFFERSIZE);
 		} else {
 			reply.srb_status = err->service_response;
 			reply.scsi_status = err->status;
-- 
2.11.0
