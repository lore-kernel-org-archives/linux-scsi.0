From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/3] sd: fix return value of sd_sync_cache()
Date: Wed, 21 Mar 2007 00:07:18 +0900
Message-ID: <20070320150718.GF6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

sd_sync_cache() should return -errno on error, fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/scsi/sd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: work/drivers/scsi/sd.c
===================================================================
--- work.orig/drivers/scsi/sd.c
+++ work/drivers/scsi/sd.c
@@ -817,7 +817,9 @@ static int sd_sync_cache(struct scsi_dev
 				scsi_print_sense_hdr("sd", &sshdr);
 	}
 
-	return res;
+	if (res)
+		return -EIO;
+	return 0;
 }
 
 static int sd_issue_flush(struct device *dev, sector_t *error_sector)
