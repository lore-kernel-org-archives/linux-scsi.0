From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: advansys: Remove unnecessary parentheses
Date: Thu, 20 Sep 2018 13:58:58 -0700
Message-ID: <20180920205858.6035-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clang warns when multiple pairs of parentheses are used for a single
conditional statement.

drivers/scsi/advansys.c:6451:20: warning: equality comparison with
extraneous parentheses [-Wparentheses-equality]
                                if ((sdtr_data == 0xFF)) {
                                     ~~~~~~~~~~^~~~~~~
drivers/scsi/advansys.c:6451:20: note: remove extraneous parentheses
around the comparison to silence this warning
                                if ((sdtr_data == 0xFF)) {
                                    ~          ^      ~
drivers/scsi/advansys.c:6451:20: note: use '=' to turn this equality
comparison into an assignment
                                if ((sdtr_data == 0xFF)) {
                                               ^~
                                               =
1 warning generated.

Link: https://github.com/ClangBuiltLinux/linux/issues/155
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 713f69033f20..44c96199e00a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6448,7 +6448,7 @@ static void AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 				sdtr_data =
 				    AscCalSDTRData(asc_dvc, ext_msg.xfer_period,
 						   ext_msg.req_ack_offset);
-				if ((sdtr_data == 0xFF)) {
+				if (sdtr_data == 0xFF) {
 
 					q_cntl |= QC_MSG_OUT;
 					asc_dvc->init_sdtr &= ~target_id;
-- 
2.19.0
