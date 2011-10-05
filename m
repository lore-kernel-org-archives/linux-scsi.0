From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] aacraid: use lower snprintf() limit
Date: Wed, 5 Oct 2011 08:50:46 +0300
Message-ID: <20111005055046.GD32077@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is just a cleanup, to silence static checker warnings.  It
doesn't change how the code works.

buf[] can either be BUF_SIZE if this is called from sysfs, or it can
be 16 if it's called from aac_get_adapter_info() via
aac_get_serial_number().  We use the smaller limit here.

sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo) is 12 so there
is actually no chance of hitting either limit.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3382475..ea8d96e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -894,15 +894,20 @@ static ssize_t aac_show_serial_number(struct device *device,
 	int len = 0;
 
 	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
-		len = snprintf(buf, PAGE_SIZE, "%06X\n",
+		len = snprintf(buf, 16, "%06X\n",
 		  le32_to_cpu(dev->adapter_info.serial[0]));
 	if (len &&
 	  !memcmp(&dev->supplement_adapter_info.MfgPcbaSerialNo[
 	    sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)-len],
 	  buf, len-1))
-		len = snprintf(buf, PAGE_SIZE, "%.*s\n",
+		len = snprintf(buf, 16, "%.*s\n",
 		  (int)sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo),
 		  dev->supplement_adapter_info.MfgPcbaSerialNo);
+
+
+	if (len > 16)
+		len = 16;
+
 	return len;
 }
 
