From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 11/24] aacraid: Added support for periodic wellness sync
Date: Thu, 2 Feb 2017 15:53:25 -0800
Message-ID: <20170202235338.14724-12-RaghavaAditya.Renukunta@microsemi.com>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0058.outbound.protection.outlook.com ([104.47.37.58]:29728
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752556AbdBCGay (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:30:54 -0500
In-Reply-To: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

This patch adds a new functions that periodically sync the time of host
to the adapter. In addition also informs the adapter that the driver is
alive and kicking. Only applicable to the HBA1000 and SMARTIOC2000.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---

Changes in  V2:
None

Changes in  V3:
None

Changes in V4:
Removed unnecessary levels of indent
Placed HBA1000 hosttime push to separate function

 drivers/scsi/aacraid/aacraid.h |   3 +
 drivers/scsi/aacraid/commsup.c | 179 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 151 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index b54c1bf..05884e6 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -88,6 +88,9 @@ enum {
 #define AAC_MAX_NATIVE_SIZE		2048
 
 #define CISS_REPORT_PHYSICAL_LUNS	0xc3
+#define WRITE_HOST_WELLNESS		0xa5
+#define BMIC_IN			0x26
+#define BMIC_OUT			0x27
 
 struct aac_ciss_phys_luns_resp {
 	u8	list_length[4];		/* LUN list length (N-7, big endian) */
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 3dfb9da..a56aa2e 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -43,6 +43,7 @@
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/semaphore.h>
+#include <linux/bcd.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
@@ -2003,6 +2004,142 @@ static void aac_process_events(struct aac_dev *dev)
 	spin_unlock_irqrestore(t_lock, flags);
 }
 
+static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
+							u32 datasize)
+{
+	struct aac_srb *srbcmd;
+	struct sgmap64 *sg64;
+	dma_addr_t addr;
+	char *dma_buf;
+	struct fib *fibptr;
+	int ret = -ENOMEM;
+	u32 vbus, vid;
+
+	fibptr = aac_fib_alloc(dev);
+	if (!fibptr)
+		goto out;
+
+	dma_buf = pci_alloc_consistent(dev->pdev, datasize, &addr);
+	if (!dma_buf)
+		goto fib_free_out;
+
+	aac_fib_init(fibptr);
+
+	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.VirtDeviceBus);
+	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.VirtDeviceTarget);
+
+	srbcmd = (struct aac_srb *)fib_data(fibptr);
+
+	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
+	srbcmd->channel = cpu_to_le32(vbus);
+	srbcmd->id = cpu_to_le32(vid);
+	srbcmd->lun = 0;
+	srbcmd->flags = cpu_to_le32(SRB_DataOut);
+	srbcmd->timeout = cpu_to_le32(10);
+	srbcmd->retry_limit = 0;
+	srbcmd->cdb_size = cpu_to_le32(12);
+	srbcmd->count = cpu_to_le32(datasize);
+
+	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
+	srbcmd->cdb[0] = BMIC_OUT;
+	srbcmd->cdb[6] = WRITE_HOST_WELLNESS;
+	memcpy(dma_buf, (char *)wellness_str, datasize);
+
+	sg64 = (struct sgmap64 *)&srbcmd->sg;
+	sg64->count = cpu_to_le32(1);
+	sg64->sg[0].addr[1] = cpu_to_le32((u32)(((addr) >> 16) >> 16));
+	sg64->sg[0].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
+	sg64->sg[0].count = cpu_to_le32(datasize);
+
+	ret = aac_fib_send(ScsiPortCommand64, fibptr, sizeof(struct aac_srb),
+				FsaNormal, 1, 1, NULL, NULL);
+
+	pci_free_consistent(dev->pdev, datasize, (void *)dma_buf, addr);
+
+	/*
+	 * Do not set XferState to zero unless
+	 * receives a response from F/W
+	 */
+	if (ret >= 0)
+		aac_fib_complete(fibptr);
+
+	/*
+	 * FIB should be freed only after
+	 * getting the response from the F/W
+	 */
+	if (ret != -ERESTARTSYS)
+		goto fib_free_out;
+
+out:
+	return ret;
+fib_free_out:
+	aac_fib_free(fibptr);
+	goto out;
+}
+
+int aac_send_safw_hostttime(struct aac_dev *dev, struct timeval *now)
+{
+	struct tm cur_tm;
+	char wellness_str[] = "<HW>TD\010\0\0\0\0\0\0\0\0\0DW\0\0ZZ";
+	u32 datasize = sizeof(wellness_str);
+	unsigned long local_time;
+	int ret = -ENODEV;
+
+	if (!dev->sa_firmware)
+		goto out;
+
+	local_time = (u32)(now->tv_sec - (sys_tz.tz_minuteswest * 60));
+	time_to_tm(local_time, 0, &cur_tm);
+	cur_tm.tm_mon += 1;
+	cur_tm.tm_year += 1900;
+	wellness_str[8] = bin2bcd(cur_tm.tm_hour);
+	wellness_str[9] = bin2bcd(cur_tm.tm_min);
+	wellness_str[10] = bin2bcd(cur_tm.tm_sec);
+	wellness_str[12] = bin2bcd(cur_tm.tm_mon);
+	wellness_str[13] = bin2bcd(cur_tm.tm_mday);
+	wellness_str[14] = bin2bcd(cur_tm.tm_year / 100);
+	wellness_str[15] = bin2bcd(cur_tm.tm_year % 100);
+
+	ret = aac_send_wellness_command(dev, wellness_str, datasize);
+
+out:
+	return ret;
+}
+
+int aac_send_hosttime(struct aac_dev *dev, struct timeval *now)
+{
+	int ret = -ENOMEM;
+	struct fib *fibptr;
+	__le32 *info;
+
+	fibptr = aac_fib_alloc(dev);
+	if (!fibptr)
+		goto out;
+
+	aac_fib_init(fibptr);
+	info = (__le32 *)fib_data(fibptr);
+	*info = cpu_to_le32(now->tv_sec);
+	ret = aac_fib_send(SendHostTime, fibptr, sizeof(*info), FsaNormal,
+					1, 1, NULL, NULL);
+
+	/*
+	 * Do not set XferState to zero unless
+	 * receives a response from F/W
+	 */
+	if (ret >= 0)
+		aac_fib_complete(fibptr);
+
+	/*
+	 * FIB should be freed only after
+	 * getting the response from the F/W
+	 */
+	if (ret != -ERESTARTSYS)
+		aac_fib_free(fibptr);
+
+out:
+	return ret;
+}
+
 /**
  *	aac_command_thread	-	command processing thread
  *	@dev: Adapter to monitor
@@ -2058,7 +2195,7 @@ int aac_command_thread(void *data)
 
 			/* Don't even try to talk to adapter if its sick */
 			ret = aac_check_health(dev);
-			if (!ret && !dev->queues)
+			if (!dev->queues)
 				break;
 			next_check_jiffies = jiffies
 					   + ((long)(unsigned)check_interval)
@@ -2071,36 +2208,16 @@ int aac_command_thread(void *data)
 				difference = (((1000000 - now.tv_usec) * HZ)
 				  + 500000) / 1000000;
 			else if (ret == 0) {
-				struct fib *fibptr;
-
-				if ((fibptr = aac_fib_alloc(dev))) {
-					int status;
-					__le32 *info;
-
-					aac_fib_init(fibptr);
-
-					info = (__le32 *) fib_data(fibptr);
-					if (now.tv_usec > 500000)
-						++now.tv_sec;
-
-					*info = cpu_to_le32(now.tv_sec);
-
-					status = aac_fib_send(SendHostTime,
-						fibptr,
-						sizeof(*info),
-						FsaNormal,
-						1, 1,
-						NULL,
-						NULL);
-					/* Do not set XferState to zero unless
-					 * receives a response from F/W */
-					if (status >= 0)
-						aac_fib_complete(fibptr);
-					/* FIB should be freed only after
-					 * getting the response from the F/W */
-					if (status != -ERESTARTSYS)
-						aac_fib_free(fibptr);
-				}
+
+				if (now.tv_usec > 500000)
+					++now.tv_sec;
+
+				if (dev->sa_firmware)
+					ret =
+					aac_send_safw_hostttime(dev, &now);
+				else
+					ret = aac_send_hosttime(dev, &now);
+
 				difference = (long)(unsigned)update_interval*HZ;
 			} else {
 				/* retry shortly */
-- 
2.7.4
