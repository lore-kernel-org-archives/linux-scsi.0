From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 34/38] cxlflash: Update synchronous interrupt status bits
Date: Mon, 26 Feb 2018 16:24:35 -0600
Message-ID: <1519683875-17980-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The SISLite specification has been updated to define new synchronous
interrupt status bits. These bits are set by the AFU when a given PASID or
EA is bad and a synchronous interrupt is triggered.

The SISLite header file is updated to support these new bits. Note that
there are also some formatting updates to some of the existing bits to
allow all of the definitions to line up uniformly.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/sislite.h | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index c08b9d3..874abce 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -258,23 +258,30 @@ struct sisl_host_map {
 				 * exit since there is no way to tell which
 				 * command caused the error.
 				 */
-#define SISL_ISTATUS_PERM_ERR_CMDROOM    0x0010ULL	/* b59, user error */
-#define SISL_ISTATUS_PERM_ERR_RCB_READ   0x0008ULL	/* b60, user error */
-#define SISL_ISTATUS_PERM_ERR_SA_WRITE   0x0004ULL	/* b61, user error */
-#define SISL_ISTATUS_PERM_ERR_RRQ_WRITE  0x0002ULL	/* b62, user error */
+#define SISL_ISTATUS_PERM_ERR_LISN_3_EA		0x0400ULL /* b53, user error */
+#define SISL_ISTATUS_PERM_ERR_LISN_2_EA		0x0200ULL /* b54, user error */
+#define SISL_ISTATUS_PERM_ERR_LISN_1_EA		0x0100ULL /* b55, user error */
+#define SISL_ISTATUS_PERM_ERR_LISN_3_PASID	0x0080ULL /* b56, user error */
+#define SISL_ISTATUS_PERM_ERR_LISN_2_PASID	0x0040ULL /* b57, user error */
+#define SISL_ISTATUS_PERM_ERR_LISN_1_PASID	0x0020ULL /* b58, user error */
+#define SISL_ISTATUS_PERM_ERR_CMDROOM		0x0010ULL /* b59, user error */
+#define SISL_ISTATUS_PERM_ERR_RCB_READ		0x0008ULL /* b60, user error */
+#define SISL_ISTATUS_PERM_ERR_SA_WRITE		0x0004ULL /* b61, user error */
+#define SISL_ISTATUS_PERM_ERR_RRQ_WRITE		0x0002ULL /* b62, user error */
 	/* Page in wait accessing RCB/IOASA/RRQ is reported in b63.
 	 * Same error in data/LXT/RHT access is reported via IOASA.
 	 */
-#define SISL_ISTATUS_TEMP_ERR_PAGEIN     0x0001ULL	/* b63, can be generated
-							 * only when AFU auto
-							 * retry is disabled.
-							 * If user can determine
-							 * the command that
-							 * caused the error, it
-							 * can be retried.
-							 */
-#define SISL_ISTATUS_UNMASK  (0x001FULL)	/* 1 means unmasked */
-#define SISL_ISTATUS_MASK    ~(SISL_ISTATUS_UNMASK)	/* 1 means masked */
+#define SISL_ISTATUS_TEMP_ERR_PAGEIN		0x0001ULL /* b63, can only be
+							   * generated when AFU
+							   * auto retry is
+							   * disabled. If user
+							   * can determine the
+							   * command that caused
+							   * the error, it can
+							   * be retried.
+							   */
+#define SISL_ISTATUS_UNMASK	(0x07FFULL)		/* 1 means unmasked */
+#define SISL_ISTATUS_MASK	~(SISL_ISTATUS_UNMASK)	/* 1 means masked */
 
 	__be64 intr_clear;
 	__be64 intr_mask;
-- 
2.1.0
