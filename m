From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [5/5]  qla2xxx: remove /proc interface
Date: Wed, 13 Apr 2005 12:19:21 -0700
Message-ID: <20050413191921.GN9703@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:47982 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261226AbVDMTTW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 15:19:22 -0400
Content-Disposition: inline
In-Reply-To: <20050413191548.GI9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

  Remove /proc support.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_os.c |  254 ------------------------------------------
 1 files changed, 254 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c	2005-04-13 08:56:07.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_os.c	2005-04-13 08:58:47.000000000 -0700
@@ -119,19 +119,6 @@ module_param(ql2xloginretrycount, int, S
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
-/*
- * Proc structures and functions
- */
-struct info_str {
-	char	*buffer;
-	int	length;
-	off_t	offset;
-	int	pos;
-};
-
-static void copy_mem_info(struct info_str *, char *, int);
-static int copy_info(struct info_str *, char *, ...);
-
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -151,14 +138,9 @@ static int qla2xxx_eh_host_reset(struct 
 static int qla2x00_loop_reset(scsi_qla_host_t *ha);
 static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 
-static int qla2x00_proc_info(struct Scsi_Host *, char *, char **,
-    off_t, int, int);
-
 static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "qla2xxx",
-	.proc_name		= "qla2xxx",
-	.proc_info		= qla2x00_proc_info,
 	.queuecommand		= qla2x00_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
@@ -1020,7 +1002,6 @@ qla2xxx_slave_alloc(struct scsi_device *
 			found++;
 			break;
 		}
-		
 	}
 	if (!found)
 		return -ENXIO;
@@ -1484,241 +1465,6 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	pci_disable_device(ha->pdev);
 }
 
-
-/*
- * The following support functions are adopted to handle
- * the re-entrant qla2x00_proc_info correctly.
- */
-static void
-copy_mem_info(struct info_str *info, char *data, int len)
-{
-	if (info->pos + len > info->offset + info->length)
-		len = info->offset + info->length - info->pos;
-
-	if (info->pos + len < info->offset) {
-		info->pos += len;
-		return;
-	}
- 
-	if (info->pos < info->offset) {
-		off_t partial;
- 
-		partial = info->offset - info->pos;
-		data += partial;
-		info->pos += partial;
-		len  -= partial;
-	}
- 
-	if (len > 0) {
-		memcpy(info->buffer, data, len);
-		info->pos += len;
-		info->buffer += len;
-	}
-}
-
-static int
-copy_info(struct info_str *info, char *fmt, ...)
-{
-	va_list args;
-	char buf[256];
-	int len;
- 
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
- 
-	copy_mem_info(info, buf, len);
-
-	return (len);
-}
-
-/*************************************************************************
-* qla2x00_proc_info
-*
-* Description:
-*   Return information to handle /proc support for the driver.
-*
-* inout : decides the direction of the dataflow and the meaning of the
-*         variables
-* buffer: If inout==0 data is being written to it else read from it
-*         (ptr to a page buffer)
-* *start: If inout==0 start of the valid data in the buffer
-* offset: If inout==0 starting offset from the beginning of all
-*         possible data to return.
-* length: If inout==0 max number of bytes to be written into the buffer
-*         else number of bytes in "buffer"
-* Returns:
-*         < 0:  error. errno value.
-*         >= 0: sizeof data returned.
-*************************************************************************/
-int
-qla2x00_proc_info(struct Scsi_Host *shost, char *buffer,
-    char **start, off_t offset, int length, int inout)
-{
-	struct info_str	info;
-	int             retval = -EINVAL;
-	uint32_t        tmp_sn;
-	uint32_t	*flags;
-	uint8_t		*loop_state;
-	scsi_qla_host_t *ha;
-	char fw_info[30];
- 
-	DEBUG3(printk(KERN_INFO
-	    "Entering proc_info buff_in=%p, offset=0x%lx, length=0x%x\n",
-	    buffer, offset, length);)
-
-	ha = (scsi_qla_host_t *) shost->hostdata;
-
-	if (inout) {
-		/* Has data been written to the file? */
-		DEBUG3(printk(
-		    "%s: has data been written to the file. \n",
-		    __func__);)
-
-		return -ENOSYS;
-	}
-
-	if (start) {
-		*start = buffer;
-	}
-
-	info.buffer = buffer;
-	info.length = length;
-	info.offset = offset;
-	info.pos    = 0;
-
-	/* start building the print buffer */
-	copy_info(&info,
-	    "QLogic PCI to Fibre Channel Host Adapter for %s:\n"
-	    "        Firmware version %s, ",
-	    ha->model_number, qla2x00_get_fw_version_str(ha, fw_info));
-
-	copy_info(&info, "Driver version %s\n", qla2x00_version_str);
-
-	tmp_sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | 
-	    ha->serial1;
-	copy_info(&info, "ISP: %s, Serial# %c%05d\n",
-	    ha->brd_info->isp_name, ('A' + tmp_sn/100000), (tmp_sn%100000));
-
-	copy_info(&info,
-	    "Request Queue = 0x%llx, Response Queue = 0x%llx\n",
-		(unsigned long long)ha->request_dma,
-		(unsigned long long)ha->response_dma);
-
-	copy_info(&info,
-	    "Request Queue count = %d, Response Queue count = %d\n",
-	    ha->request_q_length, ha->response_q_length);
-
-	copy_info(&info,
-	    "Total number of active commands = %ld\n",
-	    ha->actthreads);
-
-	copy_info(&info,
-	    "Total number of interrupts = %ld\n",
-	    (long)ha->total_isr_cnt);
-
-	copy_info(&info,
-	    "    Device queue depth = 0x%x\n",
-	    (ql2xmaxqdepth == 0) ? 16 : ql2xmaxqdepth);
-
-	copy_info(&info,
-	    "Number of free request entries = %d\n", ha->req_q_cnt);
-
-	copy_info(&info,
-	    "Number of mailbox timeouts = %ld\n", ha->total_mbx_timeout);
-
-	copy_info(&info,
-	    "Number of ISP aborts = %ld\n", ha->total_isp_aborts);
-
-	copy_info(&info,
-	    "Number of loop resyncs = %ld\n", ha->total_loop_resync);
-
-	copy_info(&info,
-	    "Number of retries for empty slots = %ld\n",
-	    qla2x00_stats.outarray_full);
-
-	flags = (uint32_t *) &ha->flags;
-
-	if (atomic_read(&ha->loop_state) == LOOP_DOWN) {
-		loop_state = "DOWN";
-	} else if (atomic_read(&ha->loop_state) == LOOP_UP) {
-		loop_state = "UP";
-	} else if (atomic_read(&ha->loop_state) == LOOP_READY) {
-		loop_state = "READY";
-	} else if (atomic_read(&ha->loop_state) == LOOP_TIMEOUT) {
-		loop_state = "TIMEOUT";
-	} else if (atomic_read(&ha->loop_state) == LOOP_UPDATE) {
-		loop_state = "UPDATE";
-	} else {
-		loop_state = "UNKNOWN";
-	}
-
-	copy_info(&info, 
-	    "Host adapter:loop state = <%s>, flags = 0x%lx\n",
-	    loop_state , *flags);
-
-	copy_info(&info, "Dpc flags = 0x%lx\n", ha->dpc_flags);
-
-	copy_info(&info, "MBX flags = 0x%x\n", ha->mbx_flags);
-
-	copy_info(&info, "Link down Timeout = %3.3d\n",
-	    ha->link_down_timeout);
-
-	copy_info(&info, "Port down retry = %3.3d\n",
-	    ha->port_down_retry_count);
-
-	copy_info(&info, "Login retry count = %3.3d\n",
-	    ha->login_retry_count);
-
-	copy_info(&info,
-	    "Commands retried with dropped frame(s) = %d\n",
-	    ha->dropped_frame_error_cnt);
-
-	copy_info(&info,
-	    "Product ID = %04x %04x %04x %04x\n", ha->product_id[0],
-	    ha->product_id[1], ha->product_id[2], ha->product_id[3]);
-
-	copy_info(&info, "\n");
-
-	/* 2.25 node/port display to proc */
-	/* Display the node name for adapter */
-	copy_info(&info, "\nSCSI Device Information:\n");
-	copy_info(&info,
-	    "scsi-qla%d-adapter-node="
-	    "%02x%02x%02x%02x%02x%02x%02x%02x;\n",
-	    (int)ha->instance,
-	    ha->init_cb->node_name[0],
-	    ha->init_cb->node_name[1],
-	    ha->init_cb->node_name[2],
-	    ha->init_cb->node_name[3],
-	    ha->init_cb->node_name[4],
-	    ha->init_cb->node_name[5],
-	    ha->init_cb->node_name[6],
-	    ha->init_cb->node_name[7]);
-
-	/* display the port name for adapter */
-	copy_info(&info,
-	    "scsi-qla%d-adapter-port="
-	    "%02x%02x%02x%02x%02x%02x%02x%02x;\n",
-	    (int)ha->instance,
-	    ha->init_cb->port_name[0],
-	    ha->init_cb->port_name[1],
-	    ha->init_cb->port_name[2],
-	    ha->init_cb->port_name[3],
-	    ha->init_cb->port_name[4],
-	    ha->init_cb->port_name[5],
-	    ha->init_cb->port_name[6],
-	    ha->init_cb->port_name[7]);
-
-	retval = info.pos > info.offset ? info.pos - info.offset : 0;
-
-	DEBUG3(printk(KERN_INFO 
-	    "Exiting proc_info: info.pos=%d, offset=0x%lx, "
-	    "length=0x%x\n", info.pos, offset, length);)
-
-	return (retval);
-}
-
 /*
  * qla2x00_mark_device_lost Updates fcport state when device goes offline.
  *

-- 
Andrew Vasquez
