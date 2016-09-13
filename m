From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v6 2/9] rpmb: enable emmc specific read data fixup
Date: Tue, 13 Sep 2016 16:22:57 +0300
Message-ID: <1473772984-17562-3-git-send-email-tomas.winkler@intel.com>
References: <1473772984-17562-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1473772984-17562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: Avri Altman <avri.altman@gmail.com>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

For eMMC the block count of the RPMB read operation is not indicated in
the original RPMB Data Read Request packet.
This might be different then the implementation of other protocol
standards.
This patch implements a fixup for this behavior.


Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V6: new in the series

 drivers/char/rpmb/core.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c
index ff10cbb7b644..8cfbbb721538 100644
--- a/drivers/char/rpmb/core.c
+++ b/drivers/char/rpmb/core.c
@@ -117,6 +117,35 @@ static int rpmb_request_verify(struct rpmb_dev *rdev, struct rpmb_data *rpmbd)
 }
 
 /**
+ * rpmb_cmd_fixup - fixup rpmb command
+ *
+ * @rdev: rpmb device
+ * @cmds: rpmb command list
+ * @ncmds: number of commands
+ *
+ */
+static void rpmb_cmd_fixup(struct rpmb_dev *rdev,
+			   struct rpmb_cmd *cmds, u32 ncmds)
+{
+	int i;
+
+	if (rdev->ops->type != RPMB_TYPE_EMMC)
+		return;
+
+	/* Fixup RPMB_READ_DATA specific to eMMC
+	 * The block count of the RPMB read operation is not indicated
+	 * in the original RPMB Data Read Request packet.
+	 * This is different then implementation for other protocol
+	 * standards.
+	 */
+	for (i = 0; i < ncmds; i++)
+		if (cmds->frames->req_resp == cpu_to_be16(RPMB_READ_DATA)) {
+			dev_dbg(&rdev->dev, "Fixing up READ_DATA frame to block_count=0\n");
+			cmds->frames->block_count = 0;
+		}
+}
+
+/**
  * rpmb_cmd_seq - send RPMB command sequence
  *
  * @rdev: rpmb device
@@ -136,10 +165,11 @@ int rpmb_cmd_seq(struct rpmb_dev *rdev, struct rpmb_cmd *cmds, u32 ncmds)
 		return -EINVAL;
 
 	mutex_lock(&rdev->lock);
-	if (rdev->ops && rdev->ops->cmd_seq)
+	err = -EOPNOTSUPP;
+	if (rdev->ops && rdev->ops->cmd_seq) {
+		rpmb_cmd_fixup(rdev, cmds, ncmds);
 		err = rdev->ops->cmd_seq(rdev->dev.parent, cmds, ncmds);
-	else
-		err = -EOPNOTSUPP;
+	}
 	mutex_unlock(&rdev->lock);
 	return err;
 }
-- 
2.7.4

