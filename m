From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH RFC] scsi: ufs: Disable blk-mq for now
Date: Thu, 13 Sep 2018 14:28:48 +0300
Message-ID: <20180913112848.7807-1-adrian.hunter@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Janek Kotas <jank@cadence.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Sayali Lokhande <sayalil@codeaurora.org>, Li Wei <liwei213@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, Alex Lemberg <Alex.Lemberg@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

blk-mq does not support runtime pm, so disable blk-mq support for now.

Fixes: d5038a13eca7 ("scsi: core: switch to scsi-mq by default")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 40548bae8efa..a4d36497a047 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7975,6 +7975,13 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+
+	/*
+	 * Do not use blk-mq at this time because blk-mq does not support
+	 * runtime pm.
+	 */
+	host->use_blk_mq = false;
+
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
-- 
2.17.1
