From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] qla1280: remove qla1280_proc_info
Date: Thu, 10 Feb 2005 16:59:52 +0100
Message-ID: <20050210155952.GA8743@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:2777 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262151AbVBJP77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 10:59:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org

reading the /proc/scsi/qla1280/* files can easily corrupt kernel memory.

As the feature is deprecated, and the qla1280 implementation doesn't
return very usefull implementation but is so buggy that any serious
user would have noticed we just remove it.


--- 1.72/drivers/scsi/qla1280.c	2004-10-22 06:20:31 +02:00
+++ edited/drivers/scsi/qla1280.c	2005-02-10 13:42:44 +01:00
@@ -670,8 +673,6 @@ static struct qla_boards ql1280_board_tb
 };
 
 static int qla1280_verbose = 1;
-static int qla1280_buffer_size;
-static char *qla1280_buffer;
 
 #if DEBUG_QLA1280
 static int ql_debug_level = 1;
@@ -694,97 +695,6 @@ static int ql_debug_level = 1;
 #define LEAVE_INTR(x)		dprintk(4, "qla1280 : Leaving %s()\n", x);
 
 
-/*************************************************************************
- * qla1280_proc_info
- *
- * Description:
- *   Return information to handle /proc support for the driver.
- *
- * buffer - ptrs to a page buffer
- *
- * Returns:
- *************************************************************************/
-#define	PROC_BUF	&qla1280_buffer[len]
-
-static int qla1280_proc_info(struct Scsi_Host *host, char *buffer,
-			     char **start, off_t offset, int length, int inout)
-{
-	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
-	struct qla_boards *bdp = &ql1280_board_tbl[ha->devnum];
-	int size = 0;
-	int len = 0;
-
-	if (inout)
-		return -ENOSYS;
-
-	/*
-	 * if our old buffer is the right size use it otherwise
-	 * allocate a new one.
-	 */
-	if (qla1280_buffer_size != PAGE_SIZE) {
-		/* deallocate this buffer and get a new one */
-		if (qla1280_buffer != NULL) {
-			free_page((unsigned long)qla1280_buffer);
-			qla1280_buffer_size = 0;
-		}
-		qla1280_buffer = (char *)get_zeroed_page(GFP_KERNEL);
-	}
-	if (qla1280_buffer == NULL) {
-		size = sprintf(buffer, "qla1280 - kmalloc error at line %d\n",
-			       __LINE__);
-		return size;
-	}
-	/* save the size of our buffer */
-	qla1280_buffer_size = PAGE_SIZE;
-
-	/* 3.20 clear the buffer we use for proc display */
-	memset(qla1280_buffer, 0, PAGE_SIZE);
-
-	/* start building the print buffer */
-	size = sprintf(PROC_BUF,
-		       "QLogic PCI to SCSI Adapter for ISP 1280/12160:\n"
-		       "        Firmware version: %2d.%02d.%02d, Driver version %s\n",
-		       bdp->fwver[0], bdp->fwver[1], bdp->fwver[2],
-		       QLA1280_VERSION);
-
-	len += size;
-
-	size = sprintf(PROC_BUF, "SCSI Host Adapter Information: %s\n",
-		       bdp->name);
-	len += size;
-	size = sprintf(PROC_BUF, "Request Queue count= 0x%x, Response "
-		       "Queue count= 0x%x\n",
-		       REQUEST_ENTRY_CNT, RESPONSE_ENTRY_CNT);
-	len += size;
-	size = sprintf(PROC_BUF, "Number of pending commands = 0x%lx\n",
-		       ha->actthreads);
-	len += size;
-	size = sprintf(PROC_BUF, "Number of free request entries = %d\n",
-		       ha->req_q_cnt);
-	len += size;
-	size = sprintf(PROC_BUF, "\n");	/* 1       */
-	len += size;
-
-	if (len >= qla1280_buffer_size) {
-		printk(KERN_WARNING
-		       "qla1280: Overflow buffer in qla1280_proc.c\n");
-	}
-
-	if (offset > len - 1) {
-		free_page((unsigned long) qla1280_buffer);
-		qla1280_buffer = NULL;
-		qla1280_buffer_size = length = 0;
-		*start = NULL;
-	} else {
-		*start = &qla1280_buffer[offset];	/* Start of wanted data */
-		if (len - offset < length) {
-			length = len - offset;
-		}
-	}
-	return length;
-}
-
-
 static int qla1280_read_nvram(struct scsi_qla_host *ha)
 {
 	uint16_t *wptr;
@@ -1334,22 +1244,6 @@ qla1280_biosparam_old(Disk * disk, kdev_
 {
 	return qla1280_biosparam(disk->device, NULL, disk->capacity, geom);
 }
-
-static int
-qla1280_proc_info_old(char *buffer, char **start, off_t offset, int length,
-		      int hostno, int inout)
-{
-	struct Scsi_Host *host;
-
-	for (host = scsi_hostlist; host; host = host->next) {
-		if (host->host_no == hostno) {
-			return qla1280_proc_info(host, buffer, start,
-						 offset, length, inout);
-		}
-	}
-
-	return -ESRCH;
-}
 #endif
 
 /**************************************************************************
@@ -4668,7 +4554,6 @@ static struct scsi_host_template qla1280
 	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
 	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
 	.bios_param		= qla1280_biosparam,
-	.proc_info		= qla1280_proc_info,
 	.can_queue		= 0xfffff,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
@@ -4688,7 +4573,6 @@ static Scsi_Host_Template qla1280_driver
 	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
 	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
 	.bios_param		= qla1280_biosparam_old,
-	.proc_info		= qla1280_proc_info_old,
 	.can_queue		= 0xfffff,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
