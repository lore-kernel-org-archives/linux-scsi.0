From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: FlashPoint: Remove unnecessary parentheses
Date: Thu, 20 Sep 2018 14:10:32 -0700
Message-ID: <20180920211032.21840-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid@gonehiking.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clang warns when multiple pairs of parentheses are used for a single
conditional statement.

In file included from drivers/scsi/BusLogic.c:57:
drivers/scsi/FlashPoint.c:2947:34: warning: equality comparison with extraneous parentheses [-Wparentheses-equality]
                                if ((currSCCB->Sccb_scsistat == SELECT_SN_ST)) {
                                     ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~
drivers/scsi/FlashPoint.c:2947:34: note: remove extraneous parentheses around the comparison to silence this warning
                                if ((currSCCB->Sccb_scsistat == SELECT_SN_ST)) {
                                    ~                        ^              ~
drivers/scsi/FlashPoint.c:2947:34: note: use '=' to turn this equality comparison into an assignment
                                if ((currSCCB->Sccb_scsistat == SELECT_SN_ST)) {
                                                             ^~
                                                             =
drivers/scsi/FlashPoint.c:2956:39: warning: equality comparison with extraneous parentheses [-Wparentheses-equality]
                                else if ((currSCCB->Sccb_scsistat ==
                                          ~~~~~~~~~~~~~~~~~~~~~~~~^~
drivers/scsi/FlashPoint.c:2956:39: note: remove extraneous parentheses around the comparison to silence this warning
                                else if ((currSCCB->Sccb_scsistat ==
                                         ~                        ^
drivers/scsi/FlashPoint.c:2956:39: note: use '=' to turn this equality comparison into an assignment
                                else if ((currSCCB->Sccb_scsistat ==
                                                                  ^~
                                                                  =
2 warnings generated.

Link: https://github.com/ClangBuiltLinux/linux/issues/156
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/FlashPoint.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 867b864f5047..0f17bd51088a 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -2944,7 +2944,7 @@ static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 			}
 
 			if (currSCCB->Lun == 0x00) {
-				if ((currSCCB->Sccb_scsistat == SELECT_SN_ST)) {
+				if (currSCCB->Sccb_scsistat == SELECT_SN_ST) {
 
 					currTar_Info->TarStatus |=
 					    (unsigned char)SYNC_SUPPORTED;
@@ -2953,8 +2953,8 @@ static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 					    ~EE_SYNC_MASK;
 				}
 
-				else if ((currSCCB->Sccb_scsistat ==
-					  SELECT_WN_ST)) {
+				else if (currSCCB->Sccb_scsistat ==
+					  SELECT_WN_ST) {
 
 					currTar_Info->TarStatus =
 					    (currTar_Info->
-- 
2.19.0
