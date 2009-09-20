From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/scsi/qla2xxx: harmonize the use of constants
Date: Sun, 20 Sep 2009 11:44:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0909201143440.14236@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754384AbZITJoS@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.orgkerne
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The fields out_mb and in_mb are elsewhere combined with the constant MBX_0
rather than BIT_0.  These have the same value so there is no change in the
behavior of the code.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/qla2xxx/qla_mbx.c      |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b6202fe..6a621e6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -91,7 +91,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		if (IS_QLA2200(ha) && cnt == 8)
 			optr =
 			    (uint16_t __iomem *)MAILBOX_REG(ha, &reg->isp, 8);
-		if (mboxes & BIT_0)
+		if (mboxes & MBX_0)
 			WRT_REG_WORD(optr, *iptr);
 
 		mboxes >>= 1;
@@ -179,7 +179,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		iptr = (uint16_t *)&ha->mailbox_out[0];
 		mboxes = mcp->in_mb;
 		for (cnt = 0; cnt < ha->mbx_count; cnt++) {
-			if (mboxes & BIT_0)
+			if (mboxes & MBX_0)
 				*iptr2 = *iptr;
 
 			mboxes >>= 1;
