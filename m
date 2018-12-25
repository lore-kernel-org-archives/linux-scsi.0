From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: avoiding fetching signature from user space again after check
Date: Tue, 25 Dec 2018 14:55:09 -0600
Message-ID: <20181225205509.69618-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The signature is checked so that it must be "MEGANIT". After the check,
if we fetch the signature again from user space, it may have been
modified by malicious user programs through race conditions. The fix
avoids fetching the signature again.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/megaraid.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 8c7154143a4e..a2255fbd0ab6 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -3396,7 +3396,6 @@ static int
 mega_m_to_n(void __user *arg, nitioctl_t *uioc)
 {
 	struct uioctl_t	uioc_mimd;
-	char	signature[8] = {0};
 	u8	opcode;
 	u8	subopcode;
 
@@ -3408,10 +3407,10 @@ mega_m_to_n(void __user *arg, nitioctl_t *uioc)
 	 * beginning of the structure.
 	 */
 
-	if( copy_from_user(signature, arg, 7) )
+	if (copy_from_user(&uioc_mimd, arg, 7))
 		return (-EFAULT);
 
-	if( memcmp(signature, "MEGANIT", 7) == 0 ) {
+	if (memcmp(&uioc_mimd, "MEGANIT", 7) == 0) {
 
 		/*
 		 * NOTE NOTE: The nit ioctl is still under flux because of
@@ -3421,7 +3420,7 @@ mega_m_to_n(void __user *arg, nitioctl_t *uioc)
 		 */
 		return -EINVAL;
 #if 0
-		if( copy_from_user(uioc, arg, sizeof(nitioctl_t)) )
+		if (copy_from_user(uioc, arg, sizeof(nitioctl_t)))
 			return (-EFAULT);
 		return 0;
 #endif
@@ -3432,7 +3431,10 @@ mega_m_to_n(void __user *arg, nitioctl_t *uioc)
 	 *
 	 * Get the user ioctl structure
 	 */
-	if( copy_from_user(&uioc_mimd, arg, sizeof(struct uioctl_t)) )
+	if (copy_from_user((char *)&uioc_mimd + sizeof(uioc->signature),
+				arg + sizeof(uioc->signature),
+				sizeof(struct uioctl_t) -
+				sizeof(uioc->signature)))
 		return (-EFAULT);
 
 
-- 
2.17.2 (Apple Git-113)
