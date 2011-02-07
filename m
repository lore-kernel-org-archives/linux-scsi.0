From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 6/6] isci: sata support and phy settings via
	request_firmware()
Date: Sun, 06 Feb 2011 16:35:06 -0800
Message-ID: <20110207003505.27040.60150.stgit@localhost6.localdomain6>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab1BGARO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2011 19:17:14 -0500
In-Reply-To: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

1/ sata protocol detection
2/ "firmware" for feeding the driver sas address and phy settings until
   platform firmware provides the same.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/firmware/Makefile    |   19 ++
 drivers/scsi/isci/firmware/README      |   36 +++
 drivers/scsi/isci/firmware/create_fw.c |  177 ++++++++++++++++
 drivers/scsi/isci/sata.c               |  356 ++++++++++++++++++++++++++++++++
 drivers/scsi/isci/sata.h               |   83 +++++++
 drivers/scsi/isci/sci_environment.h    |  112 ++++++++++
 6 files changed, 783 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/firmware/Makefile
 create mode 100644 drivers/scsi/isci/firmware/README
 create mode 100644 drivers/scsi/isci/firmware/create_fw.c
 create mode 100644 drivers/scsi/isci/sata.c
 create mode 100644 drivers/scsi/isci/sata.h
 create mode 100644 drivers/scsi/isci/sci_environment.h

diff --git a/drivers/scsi/isci/firmware/Makefile b/drivers/scsi/isci/firmware/Makefile
new file mode 100644
index 0000000..5f54461
--- /dev/null
+++ b/drivers/scsi/isci/firmware/Makefile
@@ -0,0 +1,19 @@
+# Makefile for create_fw
+#
+CC=gcc
+CFLAGS=-c -Wall -O2 -g
+LDFLAGS=
+SOURCES=create_fw.c
+OBJECTS=$(SOURCES:.cpp=.o)
+EXECUTABLE=create_fw
+
+all: $(SOURCES) $(EXECUTABLE)
+
+$(EXECUTABLE): $(OBJECTS)
+	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
+
+.c.o:
+	$(CC) $(CFLAGS) $< -O $@
+
+clean:
+	rm -f *.o $(EXECUTABLE)
diff --git a/drivers/scsi/isci/firmware/README b/drivers/scsi/isci/firmware/README
new file mode 100644
index 0000000..cf7e428
--- /dev/null
+++ b/drivers/scsi/isci/firmware/README
@@ -0,0 +1,36 @@
+This defines the temporary binary blow we are to pass to the SCU
+driver to emulate the binary firmware that we will eventually be
+able to access via NVRAM on the SCU controller.
+
+The current size of the binary blob is expected to be 149 bytes or larger
+
+Header Types:
+0x1: Phy Masks
+0x2: Phy Gens
+0x3: SAS Addrs
+0xff: End of Data
+
+ID string - u8[12]: "#SCU MAGIC#\0"
+Version - u8: 1
+SubVersion - u8: 0
+
+Header Type - u8: 0x1
+Size - u8: 8
+Phy Mask - u32[8]
+
+Header Type - u8: 0x2
+Size - u8: 8
+Phy Gen - u32[8]
+
+Header Type - u8: 0x3
+Size - u8: 8
+Sas Addr - u64[8]
+
+Header Type - u8: 0xf
+
+
+==============================================================================
+
+Place isci_firmware.bin in /lib/firmware
+Be sure to recreate the initramfs image to include the firmware. 
+
diff --git a/drivers/scsi/isci/firmware/create_fw.c b/drivers/scsi/isci/firmware/create_fw.c
new file mode 100644
index 0000000..442caac
--- /dev/null
+++ b/drivers/scsi/isci/firmware/create_fw.c
@@ -0,0 +1,177 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <errno.h>
+
+char blob_name[] = "isci_firmware.bin";
+char id[] = "#SCU MAGIC#";
+unsigned char version = 1;
+unsigned char sub_version = 0;
+
+
+/*
+ * For all defined arrays:
+ * elements 0-3 are for SCU0, ports 0-3
+ * elements 4-7 are for SCU1, ports 0-3
+ *
+ * valid configurations for one SCU are:
+ *  P0  P1  P2  P3
+ * ----------------
+ * 0xF,0x0,0x0,0x0 # 1 x4 port
+ * 0x3,0x0,0x4,0x8 # Phys 0 and 1 are a x2 port, phy 2 and phy 3 are each x1
+ *                 # ports
+ * 0x1,0x2,0xC,0x0 # Phys 0 and 1 are each x1 ports, phy 2 and phy 3 are a x2
+ *                 # port
+ * 0x3,0x0,0xC,0x0 # Phys 0 and 1 are a x2 port, phy 2 and phy 3 are a x2 port
+ * 0x1,0x2,0x4,0x8 # Each phy is a x1 port (this is the default configuration)
+ *
+ * if there is a port/phy on which you do not wish to override the default
+ * values, use the value assigned to UNINIT_PARAM (255).
+ */
+unsigned int phy_mask[] = { 1, 2, 4, 8, 1, 2, 4, 8 };
+
+
+/* denotes SAS generation. i.e. 3: SAS Gen 3 6G */
+unsigned int phy_gen[] = { 3, 3, 3, 3, 3, 3, 3, 3 };
+
+/*
+ * if there is a port/phy on which you do not wish to override the default
+ * values, use the value "0000000000000000". SAS address of zero's is
+ * considered invalid and will not be used.
+ */
+unsigned long long sas_addr[] = { 0x5FCFFFFFF0000000ULL,
+				  0x5FCFFFFFF1000000ULL,
+				  0x5FCFFFFFF2000000ULL,
+				  0x5FCFFFFFF3000000ULL,
+				  0x5FCFFFFFF4000000ULL,
+				  0x5FCFFFFFF5000000ULL,
+				  0x5FCFFFFFF6000000ULL,
+				  0x5FCFFFFFF7000000ULL };
+
+int write_blob(void)
+{
+	FILE *fd;
+	int err;
+
+	fd = fopen(blob_name, "w+");
+	if (!fd) {
+		perror("Open file for write failed");
+		return -EIO;
+	}
+
+	/* write id */
+	err = fwrite((void *)id, sizeof(char), strlen(id)+1, fd);
+	if (err == 0) {
+		perror("write id failed");
+		return err;
+	}
+
+	/* write version */
+	err = fwrite((void *)&version, sizeof(version), 1, fd);
+	if (err == 0) {
+		perror("write version failed");
+		return err;
+	}
+
+	/* write sub version */
+	err = fwrite((void *)&sub_version, sizeof(sub_version), 1, fd);
+	if (err == 0) {
+		perror("write subversion failed");
+		return err;
+	}
+
+	/* write phy mask header */
+	err = fputc(0x1, fd);
+	if (err == EOF) {
+		perror("write phy mask header failed");
+		return -EIO;
+	}
+
+	/* write size */
+	err = fputc(8, fd);
+	if (err == EOF) {
+		perror("write phy mask size failed");
+		return -EIO;
+	}
+
+	/* write phy masks */
+	err = fwrite((void *)phy_mask, 1, sizeof(phy_mask), fd);
+	if (err == 0) {
+		perror("write phy_mask failed");
+		return err;
+	}
+
+	/* write phy gen header */
+	err = fputc(0x2, fd);
+	if (err == EOF) {
+		perror("write phy gen header failed");
+		return -EIO;
+	}
+
+	/* write size */
+	err = fputc(8, fd);
+	if (err == EOF) {
+		perror("write phy gen size failed");
+		return -EIO;
+	}
+
+	/* write phy_gen */
+	err = fwrite((void *)phy_gen,
+		     1,
+		     sizeof(phy_gen),
+		     fd);
+	if (err == 0) {
+		perror("write phy_gen failed");
+		return err;
+	}
+
+	/* write phy gen header */
+	err = fputc(0x3, fd);
+	if (err == EOF) {
+		perror("write sas addr header failed");
+		return -EIO;
+	}
+
+	/* write size */
+	err = fputc(8, fd);
+	if (err == EOF) {
+		perror("write sas addr size failed");
+		return -EIO;
+	}
+
+	/* write sas_addr */
+	err = fwrite((void *)sas_addr,
+		     1,
+		     sizeof(sas_addr),
+		     fd);
+	if (err == 0) {
+		perror("write sas_addr failed");
+		return err;
+	}
+
+	/* write end header */
+	err = fputc(0xff, fd);
+	if (err == EOF) {
+		perror("write end header failed");
+		return -EIO;
+	}
+
+	fclose(fd);
+
+	return 0;
+}
+
+int main(void)
+{
+	int err;
+
+	err = write_blob();
+	if (err < 0)
+		return err;
+
+	return 0;
+}
diff --git a/drivers/scsi/isci/sata.c b/drivers/scsi/isci/sata.c
new file mode 100644
index 0000000..19b0eea
--- /dev/null
+++ b/drivers/scsi/isci/sata.c
@@ -0,0 +1,356 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include "isci.h"
+#include "scic_remote_device.h"
+#include "scic_sds_remote_device.h"
+#include "scic_io_request.h"
+#include "scic_task_request.h"
+#include "task.h"
+#include "request.h"
+#include "sata.h"
+#include "intel_sat.h"
+#include "intel_ata.h"
+
+static u8 isci_sata_get_management_task_protocol(struct isci_tmf *tmf);
+
+
+/**
+ * isci_sata_task_to_fis_copy() - This function gets the host_to_dev_fis from
+ *    the core and copies the fis from the task into it.
+ * @task: This parameter is a pointer to the task struct from libsas.
+ *
+ * pointer to the host_to_dev_fis from the core request object.
+ */
+struct host_to_dev_fis *isci_sata_task_to_fis_copy(struct sas_task *task)
+{
+	struct isci_request *request = task->lldd_task;
+	struct host_to_dev_fis *register_fis =
+		scic_stp_io_request_get_h2d_reg_address(
+			request->sci_request_handle
+			);
+
+	memcpy(
+		(u8 *)register_fis,
+		(u8 *)&task->ata_task.fis,
+		sizeof(struct host_to_dev_fis)
+		);
+
+	if (!task->ata_task.device_control_reg_update)
+		register_fis->flags |= 0x80;
+
+	register_fis->flags &= 0xF0;
+
+	return register_fis;
+}
+
+/**
+ * isci_sata_is_task_ncq() - This function determines if the given stp task is
+ *    a ncq request.
+ * @task: This parameter is a pointer to the task struct from libsas.
+ *
+ * true if the task is ncq
+ */
+bool isci_sata_is_task_ncq(struct sas_task *task)
+{
+	struct ata_queued_cmd *qc = task->uldd_task;
+
+	bool ret = (qc &&
+		    (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
+		     qc->tf.command == ATA_CMD_FPDMA_READ));
+
+	return ret;
+}
+
+/**
+ * isci_sata_set_ncq_tag() - This function sets the ncq tag field in the
+ *    host_to_dev_fis equal to the tag in the queue command in the task.
+ * @task: This parameter is a pointer to the task struct from libsas.
+ * @register_fis: This parameter is a pointer to the host_to_dev_fis from the
+ *    core request object.
+ *
+ */
+void isci_sata_set_ncq_tag(
+	struct host_to_dev_fis *register_fis,
+	struct sas_task *task)
+{
+	struct ata_queued_cmd *qc = task->uldd_task;
+	struct isci_request *request = task->lldd_task;
+
+	register_fis->sector_count = qc->tag << 3;
+	scic_stp_io_request_set_ncq_tag(request->sci_request_handle, qc->tag);
+}
+
+/**
+ * isci_request_process_stp_response() - This function sets the status and
+ *    response, in the task struct, from the request object for the upper layer
+ *    driver.
+ * @sas_task: This parameter is the task struct from the upper layer driver.
+ * @response_buffer: This parameter points to the response of the completed
+ *    request.
+ *
+ * none.
+ */
+void isci_request_process_stp_response(
+	struct sas_task *task,
+	void *response_buffer)
+{
+	struct sata_fis_reg_d2h *d2h_reg_fis = (struct sata_fis_reg_d2h *)response_buffer;
+	struct task_status_struct *ts = &task->task_status;
+	struct ata_task_resp *resp = (void *)&ts->buf[0];
+
+	resp->frame_len = le16_to_cpu(*(__le16 *)(response_buffer + 6));
+	memcpy(&resp->ending_fis[0], response_buffer + 16, 24);
+	ts->buf_valid_size = sizeof(*resp);
+
+	/**
+	 * If the device fault bit is set in the status register, then
+	 * set the sense data and return.
+	 */
+	if (d2h_reg_fis->status & ATA_STATUS_REG_DEVICE_FAULT_BIT)
+		ts->stat = SAS_PROTO_RESPONSE;
+	else
+		ts->stat = SAM_STAT_GOOD;
+
+	ts->resp = SAS_TASK_COMPLETE;
+}
+
+/**
+ * isci_sata_get_sat_protocol() - retrieve the sat protocol for the request
+ * @isci_request: ata request
+ *
+ * Note: temporary implementation until expert mode removes the callback
+ *
+ */
+u8 isci_sata_get_sat_protocol(struct isci_request *isci_request)
+{
+	struct sas_task *task;
+	struct domain_device *dev;
+
+	dev_dbg(&isci_request->isci_host->pdev->dev,
+		"%s: isci_request = %p, ttype = %d\n",
+		__func__, isci_request, isci_request->ttype);
+
+	if (tmf_task == isci_request->ttype) {
+		struct isci_tmf *tmf = isci_request_access_tmf(isci_request);
+
+		return isci_sata_get_management_task_protocol(tmf);
+	}
+
+	task = isci_request_access_task(isci_request);
+	dev = task->dev;
+
+	if (!sas_protocol_ata(task->task_proto)) {
+		WARN(1, "unhandled task protocol\n");
+		return SAT_PROTOCOL_NON_DATA;
+	}
+
+	if (task->data_dir == DMA_NONE)
+		return SAT_PROTOCOL_NON_DATA;
+
+	/* the "_IN" protocol types are equivalent to their "_OUT"
+	 * analogs as far as the core is concerned
+	 */
+	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET) {
+		if (task->ata_task.dma_xfer)
+			return SAT_PROTOCOL_PACKET_DMA_DATA_IN;
+		else
+			return SAT_PROTOCOL_PACKET_PIO_DATA_IN;
+	}
+
+	if (task->ata_task.use_ncq)
+		return SAT_PROTOCOL_FPDMA;
+
+	if (task->ata_task.dma_xfer)
+		return SAT_PROTOCOL_UDMA_DATA_IN;
+	else
+		return SAT_PROTOCOL_PIO_DATA_IN;
+}
+
+static u8 isci_sata_get_management_task_protocol(
+	struct isci_tmf *tmf)
+{
+	u8 ret = 0;
+
+	pr_warn("tmf = %p, func = %d\n", tmf, tmf->tmf_code);
+
+	if ((tmf->tmf_code == isci_tmf_sata_srst_high) ||
+	    (tmf->tmf_code == isci_tmf_sata_srst_low)) {
+		pr_warn("%s: tmf->tmf_code == TMF_LU_RESET\n", __func__);
+		ret = SAT_PROTOCOL_SOFT_RESET;
+	}
+
+	return ret;
+}
+
+enum sci_status isci_sata_management_task_request_build(
+	struct isci_request *isci_request)
+{
+	struct isci_tmf *isci_tmf;
+	enum sci_status status;
+
+	if (tmf_task != isci_request->ttype)
+		return SCI_FAILURE;
+
+	isci_tmf = isci_request_access_tmf(isci_request);
+
+	switch (isci_tmf->tmf_code) {
+
+	case isci_tmf_sata_srst_high:
+	case isci_tmf_sata_srst_low:
+	{
+		struct host_to_dev_fis *register_fis =
+			scic_stp_io_request_get_h2d_reg_address(
+				isci_request->sci_request_handle
+				);
+
+		memset(register_fis, 0, sizeof(*register_fis));
+
+		register_fis->fis_type  =  0x27;
+		register_fis->flags     &= ~0x80;
+		register_fis->flags     &= 0xF0;
+		if (isci_tmf->tmf_code == isci_tmf_sata_srst_high)
+			register_fis->control |= ATA_SRST;
+		else
+			register_fis->control &= ~ATA_SRST;
+		break;
+	}
+	/* other management commnd go here... */
+	default:
+		return SCI_FAILURE;
+	}
+
+	/* core builds the protocol specific request
+	 *  based on the h2d fis.
+	 */
+	status = scic_task_request_construct_sata(
+		isci_request->sci_request_handle
+		);
+
+	return status;
+}
+
+/**
+ * isci_task_send_lu_reset_sata() - This function is called by of the SAS
+ *    Domain Template functions. This is one of the Task Management functoins
+ *    called by libsas, to reset the given SAS lun. Note the assumption that
+ *    while this call is executing, no I/O will be sent by the host to the
+ *    device.
+ * @lun: This parameter specifies the lun to be reset.
+ *
+ * status, zero indicates success.
+ */
+int isci_task_send_lu_reset_sata(
+	struct isci_host *isci_host,
+	struct isci_remote_device *isci_device,
+	u8 *lun)
+{
+	struct isci_tmf tmf;
+	int ret = TMF_RESP_FUNC_FAILED;
+	unsigned long flags;
+
+	/* Send the initial SRST to the target */
+	#define ISCI_SRST_TIMEOUT_MS 20 /* 20 ms timeout. */
+	isci_task_build_tmf(&tmf, isci_device, isci_tmf_sata_srst_high,
+			    NULL, NULL
+			    );
+
+	ret = isci_task_execute_tmf(isci_host, &tmf, ISCI_SRST_TIMEOUT_MS);
+
+	if (ret != TMF_RESP_FUNC_COMPLETE) {
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: Assert SRST failed (%p) = %x",
+			 __func__,
+			 isci_device,
+			 ret);
+
+		/* Return the failure so that the LUN reset is escalated
+		 * to a target reset.
+		 */
+		goto out;
+	}
+
+	/* Leave SRST high for a bit. */
+	#define ISCI_SRST_ASSERT_DELAY 100 /* usecs */
+	scic_cb_stall_execution(ISCI_SRST_ASSERT_DELAY);
+
+	/* Deassert SRST. */
+	isci_task_build_tmf(&tmf, isci_device, isci_tmf_sata_srst_low,
+			    NULL, NULL
+			    );
+	ret = isci_task_execute_tmf(isci_host, &tmf, ISCI_SRST_TIMEOUT_MS);
+
+	if (ret == TMF_RESP_FUNC_COMPLETE)
+		dev_dbg(&isci_host->pdev->dev,
+			"%s: SATA LUN reset passed (%p)\n",
+			__func__,
+			isci_device);
+	else
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: Deassert SRST failed (%p)=%x\n",
+			 __func__,
+			 isci_device,
+			 ret);
+
+ out:
+	spin_lock_irqsave(&isci_host->scic_lock, flags);
+
+	/* Resume the device. */
+	scic_sds_remote_device_resume(isci_device->sci_device_handle);
+
+	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+
+	return ret;
+}
diff --git a/drivers/scsi/isci/sata.h b/drivers/scsi/isci/sata.h
new file mode 100644
index 0000000..b6ba25b
--- /dev/null
+++ b/drivers/scsi/isci/sata.h
@@ -0,0 +1,83 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include "intel_sat.h"
+
+
+
+struct host_to_dev_fis *isci_sata_task_to_fis_copy(
+	struct sas_task *task);
+
+bool isci_sata_is_task_ncq(
+	struct sas_task *task);
+
+void isci_sata_set_ncq_tag(
+	struct host_to_dev_fis *register_fis,
+	struct sas_task *task);
+
+void isci_request_process_stp_response(
+	struct sas_task *task,
+	void *response_buffer);
+
+u8 isci_sata_get_sat_protocol(
+	struct isci_request *isci_request);
+
+enum sci_status isci_sata_management_task_request_build(
+	struct isci_request *isci_request);
+
+int isci_task_send_lu_reset_sata(
+	struct isci_host *isci_host,
+	struct isci_remote_device *isci_device,
+	u8 *lun);
diff --git a/drivers/scsi/isci/sci_environment.h b/drivers/scsi/isci/sci_environment.h
new file mode 100644
index 0000000..e1020ee
--- /dev/null
+++ b/drivers/scsi/isci/sci_environment.h
@@ -0,0 +1,112 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCI_ENVIRONMENT_H_
+#define _SCI_ENVIRONMENT_H_
+
+#include "isci.h"
+
+struct scic_sds_controller;
+struct scic_sds_phy;
+struct scic_sds_port;
+struct scic_sds_remote_device;
+
+static inline struct device *scic_to_dev(struct scic_sds_controller *scic)
+{
+	struct isci_host *isci_host = sci_object_get_association(scic);
+
+	return &isci_host->pdev->dev;
+}
+
+static inline struct device *sciphy_to_dev(struct scic_sds_phy *sci_phy)
+{
+	struct isci_phy *iphy = sci_object_get_association(sci_phy);
+
+	if (!iphy || !iphy->isci_port || !iphy->isci_port->isci_host)
+		return NULL;
+
+	return &iphy->isci_port->isci_host->pdev->dev;
+}
+
+static inline struct device *sciport_to_dev(struct scic_sds_port *sci_port)
+{
+	struct isci_port *iport = sci_object_get_association(sci_port);
+
+	if (!iport || !iport->isci_host)
+		return NULL;
+
+	return &iport->isci_host->pdev->dev;
+}
+
+static inline struct device *scirdev_to_dev(struct scic_sds_remote_device *sci_dev)
+{
+	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
+
+	if (!idev || !idev->isci_port || !idev->isci_port->isci_host)
+		return NULL;
+
+	return &idev->isci_port->isci_host->pdev->dev;
+}
+
+enum {
+	ISCI_SI_REVA0,
+	ISCI_SI_REVA2,
+	ISCI_SI_REVB0,
+};
+
+extern int isci_si_rev;
+
+
+#endif

