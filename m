From: Yang Bin <yang.bin18@zte.com.cn>
Subject: [PATCH] Check sk before sendpage
Date: Wed, 10 Jul 2019 15:30:09 +0800
Message-ID: <1562743809-31133-1-git-send-email-yang.bin18@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com
Cc: cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,  Yang Bin  <yang.bin18@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

From: " Yang Bin "<yang.bin18@zte.com.cn>

Before xmit,iscsi may disconnect just now.
So must check connection sock NULL or not,or kernel will crash for
accessing NULL pointer.

Signed-off-by: Yang Bin <yang.bin18@zte.com.cn>
---
 drivers/scsi/iscsi_tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7bedbe8..a59c49f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -264,6 +264,9 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 	unsigned int copied = 0;
 	int r = 0;
 
+	if (!sk)
+		return -ENOTCONN;
+
 	while (!iscsi_tcp_segment_done(tcp_conn, segment, 0, r)) {
 		struct scatterlist *sg;
 		unsigned int offset, copy;
-- 
1.8.3.1
