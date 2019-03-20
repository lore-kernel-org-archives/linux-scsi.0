From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ibmvfc: Remove "failed" from logged errors
Date: Wed, 20 Mar 2019 14:56:51 -0500
Message-ID: <20190320195654.4364-1-tyreld@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
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

The text of messages logged with ibmvfc_log_error() always contain
the term "failed". In the case of cancelled commands during EH they
are reported back by the VIOS using error codes. This can be
confusing to somebody looking at these log messages as to whether
a command was successfully cancelled. The following real log
message for example it is unclear if the transaction was actaully
cancelled.

<6>sd 0:0:1:1: Cancelling outstanding commands.
<3>sd 0:0:1:1: [sde] Command (28) failed: transaction cancelled (2:6) flags: 0 fcp_rsp: 0, resid=0, scsi_status: 0

Remove prefixing of "failed" to all error logged messages. The
ibmvfc_log_error() function translates the returned error/status
codes to a human readable message already.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index dbaa4f131433..c3ce27039552 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1494,7 +1494,7 @@ static void ibmvfc_log_error(struct ibmvfc_event *evt)
 	if (rsp->flags & FCP_RSP_LEN_VALID)
 		rsp_code = rsp->data.info.rsp_code;
 
-	scmd_printk(KERN_ERR, cmnd, "Command (%02X) failed: %s (%x:%x) "
+	scmd_printk(KERN_ERR, cmnd, "Command (%02X) : %s (%x:%x) "
 		    "flags: %x fcp_rsp: %x, resid=%d, scsi_status: %x\n",
 		    cmnd->cmnd[0], err, vfc_cmd->status, vfc_cmd->error,
 		    rsp->flags, rsp_code, scsi_get_resid(cmnd), rsp->scsi_status);
-- 
2.12.3
