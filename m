From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v4 1/2] arcmsr: simplify ioctl data read/write
Date: Fri, 12 Sep 2014 15:29:20 +0800
Message-ID: <1410506960.5045.250.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch is to modify previous patch 13/17 and it is relative to
http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr

change in v4:
1. for readability, rename firstindex to getIndex, rename lastindex to putIndex
2. define ARCMSR_API_DATA_BUFLEN as 1032
3. simplify ioctl data read by macro CIRC_CNT_TO_END and CIRC_CNT

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c	2014-08-21 12:14:27.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2014-09-12 15:18:46.659125000 +0800
@@ -50,6 +50,7 @@
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/circ_buf.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -68,7 +69,7 @@ static ssize_t arcmsr_sysfs_iop_message_
 	struct device *dev = container_of(kobj,struct device,kobj);
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
-	uint8_t *pQbuffer,*ptmpQbuffer;
+	uint8_t *ptmpQbuffer;
 	int32_t allxfer_len = 0;
 	unsigned long flags;
 
@@ -78,57 +79,22 @@ static ssize_t arcmsr_sysfs_iop_message_
 	/* do message unit read. */
 	ptmpQbuffer = (uint8_t *)buf;
 	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
-	if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
-		pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
-		if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
-			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >= 1032) {
-				memcpy(ptmpQbuffer, pQbuffer, 1032);
-				acb->rqbuf_firstindex += 1032;
-				acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-				allxfer_len = 1032;
-			} else {
-				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex)
-					+ acb->rqbuf_lastindex) > 1032) {
-					memcpy(ptmpQbuffer, pQbuffer,
-						ARCMSR_MAX_QBUFFER
-						- acb->rqbuf_firstindex);
-					ptmpQbuffer += ARCMSR_MAX_QBUFFER
-						- acb->rqbuf_firstindex;
-					memcpy(ptmpQbuffer, acb->rqbuffer, 1032
-						- (ARCMSR_MAX_QBUFFER -
-						acb->rqbuf_firstindex));
-					acb->rqbuf_firstindex = 1032 -
-						(ARCMSR_MAX_QBUFFER -
-						acb->rqbuf_firstindex);
-					allxfer_len = 1032;
-				} else {
-					memcpy(ptmpQbuffer, pQbuffer,
-						ARCMSR_MAX_QBUFFER -
-						acb->rqbuf_firstindex);
-					ptmpQbuffer += ARCMSR_MAX_QBUFFER -
-						acb->rqbuf_firstindex;
-					memcpy(ptmpQbuffer, acb->rqbuffer,
-						acb->rqbuf_lastindex);
-					allxfer_len = ARCMSR_MAX_QBUFFER -
-						acb->rqbuf_firstindex +
-						acb->rqbuf_lastindex;
-					acb->rqbuf_firstindex =
-						acb->rqbuf_lastindex;
-				}
-			}
-		} else {
-			if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {
-				memcpy(ptmpQbuffer, pQbuffer, 1032);
-				acb->rqbuf_firstindex += 1032;
-				allxfer_len = 1032;
-			} else {
-				memcpy(ptmpQbuffer, pQbuffer, acb->rqbuf_lastindex
-					- acb->rqbuf_firstindex);
-				allxfer_len = acb->rqbuf_lastindex -
-					acb->rqbuf_firstindex;
-				acb->rqbuf_firstindex = acb->rqbuf_lastindex;
-			}
+	if (acb->rqbuf_getIndex != acb->rqbuf_putIndex) {
+		unsigned int tail = acb->rqbuf_getIndex;
+		unsigned int head = acb->rqbuf_putIndex;
+		unsigned int cnt_to_end = CIRC_CNT_TO_END(head, tail, ARCMSR_MAX_QBUFFER);
+
+		allxfer_len = CIRC_CNT(head, tail, ARCMSR_MAX_QBUFFER);
+		if (allxfer_len > ARCMSR_API_DATA_BUFLEN)
+			allxfer_len = ARCMSR_API_DATA_BUFLEN;
+
+		if (allxfer_len <= cnt_to_end)
+			memcpy(ptmpQbuffer, acb->rqbuffer + tail, allxfer_len);
+		else {
+			memcpy(ptmpQbuffer, acb->rqbuffer + tail, cnt_to_end);
+			memcpy(ptmpQbuffer + cnt_to_end, acb->rqbuffer, allxfer_len - cnt_to_end);
 		}
+		acb->rqbuf_getIndex = (acb->rqbuf_getIndex + allxfer_len) % ARCMSR_MAX_QBUFFER;
 	}
 	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 		struct QBUFFER __iomem *prbuffer;
@@ -150,33 +116,32 @@ static ssize_t arcmsr_sysfs_iop_message_
 	struct device *dev = container_of(kobj,struct device,kobj);
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
-	int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
+	int32_t my_empty_len, user_len, wqbuf_getIndex, wqbuf_putIndex;
 	uint8_t *pQbuffer, *ptmpuserbuffer;
 	unsigned long flags;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	if (count > 1032)
+	if (count > ARCMSR_API_DATA_BUFLEN)
 		return -EINVAL;
 	/* do message unit write. */
 	ptmpuserbuffer = (uint8_t *)buf;
 	user_len = (int32_t)count;
 	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
-	wqbuf_lastindex = acb->wqbuf_lastindex;
-	wqbuf_firstindex = acb->wqbuf_firstindex;
-	if (wqbuf_lastindex != wqbuf_firstindex) {
+	wqbuf_putIndex = acb->wqbuf_putIndex;
+	wqbuf_getIndex = acb->wqbuf_getIndex;
+	if (wqbuf_putIndex != wqbuf_getIndex) {
 		arcmsr_write_ioctldata2iop(acb);
 		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 		return 0;	/*need retry*/
 	} else {
-		my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
-			&(ARCMSR_MAX_QBUFFER - 1);
+		my_empty_len = ARCMSR_MAX_QBUFFER - 1;
 		if (my_empty_len >= user_len) {
 			while (user_len > 0) {
-				pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
+				pQbuffer = &acb->wqbuffer[acb->wqbuf_putIndex];
 				memcpy(pQbuffer, ptmpuserbuffer, 1);
-				acb->wqbuf_lastindex++;
-				acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+				acb->wqbuf_putIndex++;
+				acb->wqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
 				ptmpuserbuffer++;
 				user_len--;
 			}
@@ -215,12 +180,12 @@ static ssize_t arcmsr_sysfs_iop_message_
 		| ACB_F_MESSAGE_RQBUFFER_CLEARED
 		| ACB_F_MESSAGE_WQBUFFER_READED);
 	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
-	acb->rqbuf_firstindex = 0;
-	acb->rqbuf_lastindex = 0;
+	acb->rqbuf_getIndex = 0;
+	acb->rqbuf_putIndex = 0;
 	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
-	acb->wqbuf_firstindex = 0;
-	acb->wqbuf_lastindex = 0;
+	acb->wqbuf_getIndex = 0;
+	acb->wqbuf_putIndex = 0;
 	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 	pQbuffer = acb->rqbuffer;
 	memset(pQbuffer, 0, sizeof (struct QBUFFER));
@@ -234,7 +199,7 @@ static struct bin_attribute arcmsr_sysfs
 		.name = "mu_read",
 		.mode = S_IRUSR ,
 	},
-	.size = 1032,
+	.size = ARCMSR_API_DATA_BUFLEN,
 	.read = arcmsr_sysfs_iop_message_read,
 };
 
@@ -243,7 +208,7 @@ static struct bin_attribute arcmsr_sysfs
 		.name = "mu_write",
 		.mode = S_IWUSR,
 	},
-	.size = 1032,
+	.size = ARCMSR_API_DATA_BUFLEN,
 	.write = arcmsr_sysfs_iop_message_write,
 };
 
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2014-08-21 12:14:27.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2014-08-25 17:25:20.000000000 +0800
@@ -107,10 +107,11 @@ struct CMD_MESSAGE
 **        IOP Message Transfer Data for user space
 *******************************************************************************
 */
+#define	ARCMSR_API_DATA_BUFLEN	1032
 struct CMD_MESSAGE_FIELD
 {
     struct CMD_MESSAGE			cmdmessage;
-    uint8_t				messagedatabuffer[1032];
+    uint8_t				messagedatabuffer[ARCMSR_API_DATA_BUFLEN];
 };
 /* IOP message transfer */
 #define ARCMSR_MESSAGE_FAIL			0x0001
@@ -678,15 +679,15 @@ struct AdapterControlBlock
 	unsigned int				uncache_size;
 	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for read from 80331 */
-	int32_t				rqbuf_firstindex;
+	int32_t				rqbuf_getIndex;
 	/* first of read buffer  */
-	int32_t				rqbuf_lastindex;
+	int32_t				rqbuf_putIndex;
 	/* last of read buffer   */
 	uint8_t				wqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for write to 80331  */
-	int32_t				wqbuf_firstindex;
+	int32_t				wqbuf_getIndex;
 	/* first of write buffer */
-	int32_t				wqbuf_lastindex;
+	int32_t				wqbuf_putIndex;
 	/* last of write buffer  */
 	uint8_t				devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
 	/* id0 ..... id15, lun0...lun7 */
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-21 12:14:27.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-09-12 12:43:16.956653000 +0800
@@ -58,6 +58,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/circ_buf.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -1724,16 +1725,15 @@ arcmsr_Read_iop_rqbuffer_in_DWORD(struct
 		buf2 = (uint32_t *)buf1;
 	}
 	while (iop_len > 0) {
-		pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
+		pQbuffer = &acb->rqbuffer[acb->rqbuf_putIndex];
 		*pQbuffer = *buf1;
-		acb->rqbuf_lastindex++;
+		acb->rqbuf_putIndex++;
 		/* if last, index number set it to 0 */
-		acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+		acb->rqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
 		buf1++;
 		iop_len--;
 	}
-	if (buf2)
-		kfree(buf2);
+	kfree(buf2);
 	/* let IOP know data has been read */
 	arcmsr_iop_message_read(acb);
 	return 1;
@@ -1752,10 +1752,10 @@ arcmsr_Read_iop_rqbuffer_data(struct Ada
 	iop_data = (uint8_t __iomem *)prbuffer->data;
 	iop_len = readl(&prbuffer->data_len);
 	while (iop_len > 0) {
-		pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
+		pQbuffer = &acb->rqbuffer[acb->rqbuf_putIndex];
 		*pQbuffer = readb(iop_data);
-		acb->rqbuf_lastindex++;
-		acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+		acb->rqbuf_putIndex++;
+		acb->rqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
 		iop_data++;
 		iop_len--;
 	}
@@ -1771,7 +1771,7 @@ static void arcmsr_iop2drv_data_wrote_ha
 
 	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 	prbuffer = arcmsr_get_iop_rqbuffer(acb);
-	buf_empty_len = (acb->rqbuf_lastindex - acb->rqbuf_firstindex - 1) &
+	buf_empty_len = (acb->rqbuf_putIndex - acb->rqbuf_getIndex - 1) &
 		(ARCMSR_MAX_QBUFFER - 1);
 	if (buf_empty_len >= readl(&prbuffer->data_len)) {
 		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
@@ -1798,12 +1798,12 @@ static void arcmsr_write_ioctldata2iop_i
 		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
 		pwbuffer = arcmsr_get_iop_wqbuffer(acb);
 		iop_data = (uint32_t __iomem *)pwbuffer->data;
-		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+		while ((acb->wqbuf_getIndex != acb->wqbuf_putIndex)
 			&& (allxfer_len < 124)) {
-			pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
+			pQbuffer = &acb->wqbuffer[acb->wqbuf_getIndex];
 			*buf1 = *pQbuffer;
-			acb->wqbuf_firstindex++;
-			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+			acb->wqbuf_getIndex++;
+			acb->wqbuf_getIndex %= ARCMSR_MAX_QBUFFER;
 			buf1++;
 			allxfer_len++;
 		}
@@ -1841,12 +1841,12 @@ arcmsr_write_ioctldata2iop(struct Adapte
 		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
 		pwbuffer = arcmsr_get_iop_wqbuffer(acb);
 		iop_data = (uint8_t __iomem *)pwbuffer->data;
-		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+		while ((acb->wqbuf_getIndex != acb->wqbuf_putIndex)
 			&& (allxfer_len < 124)) {
-			pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
+			pQbuffer = &acb->wqbuffer[acb->wqbuf_getIndex];
 			writeb(*pQbuffer, iop_data);
-			acb->wqbuf_firstindex++;
-			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+			acb->wqbuf_getIndex++;
+			acb->wqbuf_getIndex %= ARCMSR_MAX_QBUFFER;
 			iop_data++;
 			allxfer_len++;
 		}
@@ -1861,9 +1861,9 @@ static void arcmsr_iop2drv_data_read_han
 
 	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
 	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
-	if (acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+	if (acb->wqbuf_getIndex != acb->wqbuf_putIndex)
 		arcmsr_write_ioctldata2iop(acb);
-	if (acb->wqbuf_firstindex == acb->wqbuf_lastindex)
+	if (acb->wqbuf_getIndex == acb->wqbuf_putIndex)
 		acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
 	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 }
@@ -2243,14 +2243,14 @@ void arcmsr_clear_iop2drv_rqueue_buffer(
 		for (i = 0; i < 15; i++) {
 			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 				acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-				acb->rqbuf_firstindex = 0;
-				acb->rqbuf_lastindex = 0;
+				acb->rqbuf_getIndex = 0;
+				acb->rqbuf_putIndex = 0;
 				arcmsr_iop_message_read(acb);
 				mdelay(30);
-			} else if (acb->rqbuf_firstindex !=
-				   acb->rqbuf_lastindex) {
-				acb->rqbuf_firstindex = 0;
-				acb->rqbuf_lastindex = 0;
+			} else if (acb->rqbuf_getIndex !=
+				   acb->rqbuf_putIndex) {
+				acb->rqbuf_getIndex = 0;
+				acb->rqbuf_putIndex = 0;
 				mdelay(30);
 			} else
 				break;
@@ -2289,9 +2289,9 @@ static int arcmsr_iop_message_xfer(struc
 	switch (controlcode) {
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {
 		unsigned char *ver_addr;
-		uint8_t *pQbuffer, *ptmpQbuffer;
+		uint8_t *ptmpQbuffer;
 		uint32_t allxfer_len = 0;
-		ver_addr = kmalloc(1032, GFP_ATOMIC);
+		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
 		if (!ver_addr) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			pr_info("%s: memory not enough!\n", __func__);
@@ -2299,66 +2299,22 @@ static int arcmsr_iop_message_xfer(struc
 		}
 		ptmpQbuffer = ver_addr;
 		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
-		if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
-			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
-			if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
-				if ((ARCMSR_MAX_QBUFFER -
-					acb->rqbuf_firstindex) >= 1032) {
-					memcpy(ptmpQbuffer, pQbuffer, 1032);
-					acb->rqbuf_firstindex += 1032;
-					acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-					allxfer_len = 1032;
-				} else {
-					if (((ARCMSR_MAX_QBUFFER -
-						acb->rqbuf_firstindex) +
-						acb->rqbuf_lastindex) > 1032) {
-						memcpy(ptmpQbuffer,
-							pQbuffer, ARCMSR_MAX_QBUFFER
-							- acb->rqbuf_firstindex);
-						ptmpQbuffer +=
-							ARCMSR_MAX_QBUFFER -
-							acb->rqbuf_firstindex;
-						memcpy(ptmpQbuffer,
-							acb->rqbuffer, 1032 -
-							(ARCMSR_MAX_QBUFFER
-							- acb->rqbuf_firstindex));
-						acb->rqbuf_firstindex =
-							1032 - (ARCMSR_MAX_QBUFFER
-							- acb->rqbuf_firstindex);
-						allxfer_len = 1032;
-					} else {
-						memcpy(ptmpQbuffer,
-							pQbuffer, ARCMSR_MAX_QBUFFER
-							- acb->rqbuf_firstindex);
-						ptmpQbuffer +=
-							ARCMSR_MAX_QBUFFER -
-							acb->rqbuf_firstindex;
-						memcpy(ptmpQbuffer,
-							acb->rqbuffer,
-							acb->rqbuf_lastindex);
-						allxfer_len = ARCMSR_MAX_QBUFFER
-							- acb->rqbuf_firstindex +
-							acb->rqbuf_lastindex;
-						acb->rqbuf_firstindex =
-							acb->rqbuf_lastindex;
-					}
-				}
-			} else {
-				if ((acb->rqbuf_lastindex -
-					acb->rqbuf_firstindex) > 1032) {
-					memcpy(ptmpQbuffer, pQbuffer, 1032);
-					acb->rqbuf_firstindex += 1032;
-					allxfer_len = 1032;
-				} else {
-					memcpy(ptmpQbuffer, pQbuffer,
-						acb->rqbuf_lastindex -
-						acb->rqbuf_firstindex);
-					allxfer_len = acb->rqbuf_lastindex
-						- acb->rqbuf_firstindex;
-					acb->rqbuf_firstindex =
-						acb->rqbuf_lastindex;
-				}
+		if (acb->rqbuf_getIndex != acb->rqbuf_putIndex) {
+			unsigned int tail = acb->rqbuf_getIndex;
+			unsigned int head = acb->rqbuf_putIndex;
+			unsigned int cnt_to_end = CIRC_CNT_TO_END(head, tail, ARCMSR_MAX_QBUFFER);
+
+			allxfer_len = CIRC_CNT(head, tail, ARCMSR_MAX_QBUFFER);
+			if (allxfer_len > ARCMSR_API_DATA_BUFLEN)
+				allxfer_len = ARCMSR_API_DATA_BUFLEN;
+
+			if (allxfer_len <= cnt_to_end)
+				memcpy(ptmpQbuffer, acb->rqbuffer + tail, allxfer_len);
+			else {
+				memcpy(ptmpQbuffer, acb->rqbuffer + tail, cnt_to_end);
+				memcpy(ptmpQbuffer + cnt_to_end, acb->rqbuffer, allxfer_len - cnt_to_end);
 			}
+			acb->rqbuf_getIndex = (acb->rqbuf_getIndex + allxfer_len) % ARCMSR_MAX_QBUFFER;
 		}
 		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
 			allxfer_len);
@@ -2382,9 +2338,9 @@ static int arcmsr_iop_message_xfer(struc
 	}
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
 		unsigned char *ver_addr;
-		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
+		int32_t my_empty_len, user_len, wqbuf_getIndex, wqbuf_putIndex, cnt2end;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
-		ver_addr = kmalloc(1032, GFP_ATOMIC);
+		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
 		if (!ver_addr) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
@@ -2394,9 +2350,9 @@ static int arcmsr_iop_message_xfer(struc
 		memcpy(ptmpuserbuffer,
 			pcmdmessagefld->messagedatabuffer, user_len);
 		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
-		wqbuf_lastindex = acb->wqbuf_lastindex;
-		wqbuf_firstindex = acb->wqbuf_firstindex;
-		if (wqbuf_lastindex != wqbuf_firstindex) {
+		wqbuf_putIndex = acb->wqbuf_putIndex;
+		wqbuf_getIndex = acb->wqbuf_getIndex;
+		if (wqbuf_putIndex != wqbuf_getIndex) {
 			struct SENSE_DATA *sensebuffer =
 				(struct SENSE_DATA *)cmd->sense_buffer;
 			arcmsr_write_ioctldata2iop(acb);
@@ -2408,27 +2364,24 @@ static int arcmsr_iop_message_xfer(struc
 			sensebuffer->Valid = 1;
 			retvalue = ARCMSR_MESSAGE_FAIL;
 		} else {
-			my_empty_len = (wqbuf_firstindex - wqbuf_lastindex - 1)
-				& (ARCMSR_MAX_QBUFFER - 1);
+			my_empty_len = ARCMSR_MAX_QBUFFER - 1;
 			if (my_empty_len >= user_len) {
 				while (user_len > 0) {
-					pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
-					if ((acb->wqbuf_lastindex + user_len)
+					pQbuffer = &acb->wqbuffer[acb->wqbuf_putIndex];
+					if ((acb->wqbuf_putIndex + user_len)
 						> ARCMSR_MAX_QBUFFER) {
+						cnt2end = ARCMSR_MAX_QBUFFER -
+							acb->wqbuf_putIndex;
 						memcpy(pQbuffer, ptmpuserbuffer,
-							ARCMSR_MAX_QBUFFER -
-							acb->wqbuf_lastindex);
-						ptmpuserbuffer +=
-							(ARCMSR_MAX_QBUFFER
-							- acb->wqbuf_lastindex);
-						user_len -= (ARCMSR_MAX_QBUFFER
-							- acb->wqbuf_lastindex);
-						acb->wqbuf_lastindex = 0;
+							cnt2end);
+						ptmpuserbuffer += cnt2end;
+						user_len -= cnt2end;
+						acb->wqbuf_putIndex = 0;
 					} else {
 						memcpy(pQbuffer, ptmpuserbuffer,
 							user_len);
-						acb->wqbuf_lastindex += user_len;
-						acb->wqbuf_lastindex %=
+						acb->wqbuf_putIndex += user_len;
+						acb->wqbuf_putIndex %=
 							ARCMSR_MAX_QBUFFER;
 						user_len = 0;
 					}
@@ -2468,8 +2421,8 @@ static int arcmsr_iop_message_xfer(struc
 		arcmsr_clear_iop2drv_rqueue_buffer(acb);
 		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 		acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
-		acb->rqbuf_firstindex = 0;
-		acb->rqbuf_lastindex = 0;
+		acb->rqbuf_getIndex = 0;
+		acb->rqbuf_putIndex = 0;
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
 		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 		if (acb->fw_flag == FW_DEADLOCK)
@@ -2485,8 +2438,8 @@ static int arcmsr_iop_message_xfer(struc
 		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
 		acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			ACB_F_MESSAGE_WQBUFFER_READED);
-		acb->wqbuf_firstindex = 0;
-		acb->wqbuf_lastindex = 0;
+		acb->wqbuf_getIndex = 0;
+		acb->wqbuf_putIndex = 0;
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
 		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 		if (acb->fw_flag == FW_DEADLOCK)
@@ -2502,16 +2455,16 @@ static int arcmsr_iop_message_xfer(struc
 		arcmsr_clear_iop2drv_rqueue_buffer(acb);
 		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 		acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
-		acb->rqbuf_firstindex = 0;
-		acb->rqbuf_lastindex = 0;
+		acb->rqbuf_getIndex = 0;
+		acb->rqbuf_putIndex = 0;
 		pQbuffer = acb->rqbuffer;
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));
 		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
 		acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			ACB_F_MESSAGE_WQBUFFER_READED);
-		acb->wqbuf_firstindex = 0;
-		acb->wqbuf_lastindex = 0;
+		acb->wqbuf_getIndex = 0;
+		acb->wqbuf_putIndex = 0;
 		pQbuffer = acb->wqbuffer;
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));
 		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
