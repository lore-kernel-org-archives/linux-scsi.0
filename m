From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] sd: fix an error return in probe()
Date: Mon, 19 Jan 2015 17:41:12 +0300
Message-ID: <20150119144112.GB19086@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If device_add() fails then it should return the error code but instead
the current code returns success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ebf35cb6..75a0b55 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3019,7 +3019,8 @@ static int sd_probe(struct device *dev)
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
-	if (device_add(&sdkp->dev))
+	error = device_add(&sdkp->dev);
+	if (error)
 		goto out_free_index;
 
 	get_device(dev);
