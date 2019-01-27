From: Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 3/3] scsi: ufs-bsg: Allow reading descriptors
Date: Sun, 27 Jan 2019 09:07:48 +0200
Message-ID: <1548572868-12589-4-git-send-email-avri.altman@wdc.com>
References: <1548572868-12589-1-git-send-email-avri.altman@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548572868-12589-1-git-send-email-avri.altman@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Avri Altman <avri.altman@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Add this functionality, placing the descriptor being read in the actual
data buffer in the bio.

That is, for both read and write descriptors query upiu, we are using
the job's request_payload.  This in turn, is mapped back in user land to
the applicable sg_io_v4 xferp: dout_xferp for write descriptor,
and din_xferp for read descriptor.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 Documentation/scsi/ufs.txt |  7 ++++++-
 drivers/scsi/ufs/ufs_bsg.c | 20 ++++++++++++--------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/Documentation/scsi/ufs.txt b/Documentation/scsi/ufs.txt
index 78fe7cb..1769f71 100644
--- a/Documentation/scsi/ufs.txt
+++ b/Documentation/scsi/ufs.txt
@@ -150,9 +150,14 @@ send SG_IO with the applicable sg_io_v4:
 	if (dir == SG_DXFER_TO_DEV) {
 		io_hdr_v4.dout_xfer_len = (uint32_t)byte_cnt;
 		io_hdr_v4.dout_xferp = (uintptr_t)(__u64)buff;
+	} else {
+		io_hdr_v4.din_xfer_len = (uint32_t)byte_cnt;
+		io_hdr_v4.din_xferp = (uintptr_t)(__u64)buff;
 	}
 
-If you wish to write a descriptor, use the dout_xferp sg_io_v4.
+If you wish to read or write a descriptor, use the appropriate xferp of
+sg_io_v4.
+
 
 UFS Specifications can be found at,
 UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 2fd0769..869e71f 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -48,12 +48,8 @@ static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job *job,
 	struct utp_upiu_query *qr;
 	u8 *descp;
 
-	if (desc_op == UPIU_QUERY_OPCODE_READ_DESC) {
-		dev_err(hba->dev, "unsupported opcode %d\n", desc_op);
-		return -ENOTSUPP;
-	}
-
-	if (desc_op != UPIU_QUERY_OPCODE_WRITE_DESC)
+	if (desc_op != UPIU_QUERY_OPCODE_WRITE_DESC &&
+	    desc_op != UPIU_QUERY_OPCODE_READ_DESC)
 		goto out;
 
 	qr = &bsg_request->upiu_req.qr;
@@ -71,8 +67,10 @@ static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job *job,
 	if (!descp)
 		return -ENOMEM;
 
-	sg_copy_to_buffer(job->request_payload.sg_list,
-			  job->request_payload.sg_cnt, descp, *desc_len);
+	if (desc_op == UPIU_QUERY_OPCODE_WRITE_DESC)
+		sg_copy_to_buffer(job->request_payload.sg_list,
+				  job->request_payload.sg_cnt, descp,
+				  *desc_len);
 
 	*desc_buff = descp;
 
@@ -140,6 +138,12 @@ static int ufs_bsg_request(struct bsg_job *job)
 	if (!desc_buff)
 		goto out;
 
+	if (desc_op == UPIU_QUERY_OPCODE_READ_DESC && desc_len)
+		bsg_reply->reply_payload_rcv_len =
+			sg_copy_from_buffer(job->request_payload.sg_list,
+					    job->request_payload.sg_cnt,
+					    desc_buff, desc_len);
+
 	kfree(desc_buff);
 
 out:
-- 
1.9.1
