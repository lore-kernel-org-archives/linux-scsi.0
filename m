From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ibmvfc: Add failed PRLI to cmd_status lookup array
Date: Wed, 20 Mar 2019 14:56:52 -0500
Message-ID: <20190320195654.4364-2-tyreld@linux.vnet.ibm.com>
References: <20190320195654.4364-1-tyreld@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20190320195654.4364-1-tyreld@linux.vnet.ibm.com>
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
To: james.bottomley@hansenpartnership.com
Cc: brking@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The VIOS uses the SCSI_ERROR class to report PRLI failures. These
errors are indicated with the combination of a IBMVFC_FC_SCSI_ERROR
return status and 0x8000 error code. Add these codes to cmd_status[]
with appropriate human readable error message.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index c3ce27039552..18ee2a8ec3d5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -139,6 +139,7 @@ static const struct {
 	{ IBMVFC_FC_FAILURE, IBMVFC_VENDOR_SPECIFIC, DID_ERROR, 1, 1, "vendor specific" },
 
 	{ IBMVFC_FC_SCSI_ERROR, 0, DID_OK, 1, 0, "SCSI error" },
+	{ IBMVFC_FC_SCSI_ERROR, IBMVFC_COMMAND_FAILED, DID_ERROR, 0, 1, "PRLI to device failed." },
 };
 
 static void ibmvfc_npiv_login(struct ibmvfc_host *);
-- 
2.12.3
