From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 2/9] snic:Add interrupt, resource firmware interfaces
Date: Tue, 10 Feb 2015 08:43:29 -0800
Message-ID: <1423586616-18177-3-git-send-email-nmusini@cisco.com>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:58366 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbBJQyl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Feb 2015 11:54:41 -0500
In-Reply-To: <1423586616-18177-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

snic_fwint.h contains firmware interface structures.

snic_res.h contains firmware request initialization

snic_res.c contains retrieval of resource configuration, and allocation,
and initialization of HW Queues.

snic_isr.c contains interrupt request, release, and handling

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_fwint.h | 567 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/snic/snic_isr.c   | 206 +++++++++++++++
 drivers/scsi/snic/snic_res.c   | 318 +++++++++++++++++++++++
 drivers/scsi/snic/snic_res.h   |  96 +++++++
 4 files changed, 1187 insertions(+)
 create mode 100644 drivers/scsi/snic/snic_fwint.h
 create mode 100644 drivers/scsi/snic/snic_isr.c
 create mode 100644 drivers/scsi/snic/snic_res.c
 create mode 100644 drivers/scsi/snic/snic_res.h

diff --git a/drivers/scsi/snic/snic_fwint.h b/drivers/scsi/snic/snic_fwint.h
new file mode 100644
index 0000000..456de1b
--- /dev/null
+++ b/drivers/scsi/snic/snic_fwint.h
@@ -0,0 +1,567 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef __SNIC_FWINT_H
+#define __SNIC_FWINT_H
+
+#define SNIC_CDB_LEN	32	/* SCSI CDB size 32, can be used for 16 bytes */
+#define LUN_ADDR_LEN	8
+
+/*
+ * Command entry type
+ */
+enum snic_io_type {
+	/*
+	 * Initiator request types
+	 */
+	SNIC_REQ_REPORT_TGTS = 0x2,	/* Report Targets */
+	SNIC_REQ_ICMND,			/* Initiator command for SCSI IO */
+	SNIC_REQ_ITMF,			/* Initiator command for Task Mgmt */
+	SNIC_REQ_HBA_RESET,		/* SNIC Reset */
+	SNIC_REQ_EXCH_VER,		/* Exchange Version Information */
+	SNIC_REQ_TGT_INFO,		/* Backend/Target Information */
+	SNIC_REQ_BOOT_LUNS,
+
+	/*
+	 * Response type
+	 */
+	SNIC_RSP_REPORT_TGTS_CMPL = 0x12,/* Report Targets Completion */
+	SNIC_RSP_ICMND_CMPL,		/* SCSI IO Completion */
+	SNIC_RSP_ITMF_CMPL,		/* Task Management Completion */
+	SNIC_RSP_HBA_RESET_CMPL,	/* SNIC Reset Completion */
+	SNIC_RSP_EXCH_VER_CMPL,		/* Exchange Version Completion*/
+	SNIC_RSP_BOOT_LUNS_CMPL,
+
+	/*
+	 * Misc Request types
+	 */
+	SNIC_MSG_ACK = 0x80,		/* Ack: snic_notify_msg */
+	SNIC_MSG_ASYNC_EVNOTIFY,	/* Asynchronous Event Notification */
+}; /* end of enum snic_io_type */
+
+
+/*
+ * Header status codes from firmware
+ */
+enum snic_io_status {
+	SNIC_STAT_IO_SUCCESS = 0,	/* request was successful */
+
+	/*
+	 * If a request to the fw is rejected, the original request header
+	 * will be returned with the status set to one of the following:
+	 */
+	SNIC_STAT_INVALID_HDR,	/* header contains invalid data */
+	SNIC_STAT_OUT_OF_RES,	/* out of resources to complete request */
+	SNIC_STAT_INVALID_PARM,	/* some parameter in request is not valid */
+	SNIC_STAT_REQ_NOT_SUP,	/* req type is not supported */
+	SNIC_STAT_IO_NOT_FOUND,	/* requested IO was not found */
+
+	/*
+	 * Once a request is processed, the fw will usually return
+	 * a cmpl message type. In cases where errors occurred,
+	 * the header status would be filled in with one of the following:
+	 */
+	SNIC_STAT_ABORTED,		/* req was aborted */
+	SNIC_STAT_TIMEOUT,		/* req was timed out */
+	SNIC_STAT_SGL_INVALID,		/* req was aborted due to sgl error */
+	SNIC_STAT_DATA_CNT_MISMATCH,	/*recv/sent more/less data than expec */
+	SNIC_STAT_FW_ERR,		/* req was terminated due to fw error */
+	SNIC_STAT_ITMF_REJECT,		/* itmf req was rejected by target */
+	SNIC_STAT_ITMF_FAIL,		/* itmf req was failed */
+	SNIC_STAT_ITMF_INCORRECT_LUN,	/* itmf req has incorrect LUN id*/
+	SNIC_STAT_CMND_REJECT,		/* req was invalid and rejected */
+	SNIC_STAT_DEV_OFFLINE,		/* req sent to offline device */
+	SNIC_STAT_NO_BOOTLUN,
+	SNIC_STAT_SCSI_ERR,		/* SCSI error returned by Target. */
+	SNIC_STAT_NOT_READY,		/* sNIC Subsystem is not ready */
+	SNIC_STAT_FATAL_ERROR,		/* sNIC is in unrecoverable state */
+}; /* end of enum snic_io_status */
+
+/*
+ * snic_io_hdr : host <--> firmare
+ *
+ * for any other message that will be queued to firmware should
+ *  have the following request header
+ */
+struct snic_io_hdr {
+	u32	hid;
+	u32	cmnd_id;	/* tag here */
+	u64	init_ctx;	/* initiator context */
+	u8	type;		/* request/response type */
+	u8	status;		/* header status entry */
+	u8	protocol;	/* Protocol specific, may needed for RoCE*/
+	u8	flags;
+	u16	sg_cnt;
+	u16	resvd;
+};
+
+/* auxillary funciton for encoding the snic_io_hdr */
+static inline void
+snic_io_hdr_enc(struct snic_io_hdr *hdr, u8 typ, u8 status, u32 id, u32 hid,
+		u16 sg_cnt, u64 ctx)
+{
+	hdr->type = typ;
+	hdr->status = status;
+	hdr->protocol = 0;
+	hdr->hid = hid;
+	hdr->cmnd_id = id;
+	hdr->sg_cnt = sg_cnt;
+	hdr->init_ctx = ctx;
+	hdr->flags = 0;
+}
+
+/* auxillary funciton for decoding the snic_io_hdr */
+static inline void
+snic_io_hdr_dec(struct snic_io_hdr *hdr, u8 *typ, u8 *stat, u32 *cmnd_id,
+		u32 *hid, u64 *ctx)
+{
+	*typ = hdr->type;
+	*stat = hdr->status;
+	*hid = hdr->hid;
+	*cmnd_id = hdr->cmnd_id;
+	*ctx = hdr->init_ctx;
+}
+
+/*
+ * snic_host_info: host -> firmware
+ *
+ * Used for sending host information to firmware, and request fw version
+ */
+struct snic_exch_ver_req {
+	u32	drvr_ver;	/* for debugging, when fw dump captured */
+	u32	os_type;	/* for OS specific features */
+};
+
+/*
+ * os_type flags
+ * Bit 0-7 : OS information
+ * Bit 8-31: Feature/Capability Information
+ */
+#define SNIC_OS_LINUX	0x1
+#define SNIC_OS_WIN	0x2
+#define SNIC_OS_ESX	0x3
+
+/*
+ * HBA Capabilities
+ * Bit 1: Reserved.
+ * Bit 2: Dynamic Discovery of LUNs.
+ * Bit 3: Async event notifications on on tgt online/offline events.
+ * Bit 4: IO timeout support in FW.
+ * Bit 5-31: Reserved.
+ */
+#define SNIC_HBA_CAP_DDL	0x02	/* Supports Dynamic Discovery of LUNs */
+#define SNIC_HBA_CAP_AEN	0x04	/* Supports Async Event Noitifcation */
+#define SNIC_HBA_CAP_TMO	0x08	/* Supports IO timeout in FW */
+
+/*
+ * snic_exch_ver_rsp : firmware -> host
+ *
+ * Used by firmware to send response to version request
+ */
+struct snic_exch_ver_rsp {
+	u32	version;
+	u32	hid;			/* FIXME: u16 hid | u16 vnic id */
+	u32	max_concur_ios;		/* max concurrent ios */
+	u32	max_sgs_per_cmd;	/* max sgls per IO */
+	u32	max_io_sz;		/* max io size supported */
+	u32	hba_cap;		/* hba capabilities */
+	u32	max_tgts;		/* max tgts supported */
+	u16	io_timeout;		/* FW extended timeout */
+	u16	rsvd;
+};
+
+
+/*
+ * snic_report_tgts : host -> firmware request
+ *
+ * Used by the host to request list of targets
+ */
+struct snic_report_tgts {
+	u16	sg_cnt;
+	u16	flags;		/* specific flags from fw */
+	u8	_resvd[4];
+	u64	sg_addr;	/* Points to SGL */
+	u64	sense_addr;
+};
+
+enum snic_type {
+	SNIC_NONE = 0x0,
+	SNIC_DAS,
+	SNIC_SAN,
+};
+
+
+/* Report Target Response */
+enum snic_tgt_type {
+	SNIC_TGT_NONE = 0x0,
+	SNIC_TGT_DAS,	/* DAS Target */
+	SNIC_TGT_SAN,	/* SAN Target */
+};
+
+/* target id format */
+struct snic_tgt_id {
+	u32	tgt_id;		/* target id */
+	u16	tgt_type;	/* tgt type */
+	u16	vnic_id;	/* corresponding vnic id */
+};
+
+/*
+ * snic_report_tgts_cmpl : firmware -> host response
+ *
+ * Used by firmware to send response to Report Targets request
+ */
+struct snic_report_tgts_cmpl {
+	u32	tgt_cnt;	/* Number of Targets accessible */
+	u32	_resvd;
+};
+
+/*
+ * Command flags
+ *
+ * Bit 0: Read flags
+ * Bit 1: Write flag
+ * Bit 2: ESGL - sg/esg array contains extended sg
+ *	  ESGE - is a host buffer contains sg elements
+ * Bit 3-4: Task Attributes
+ *		00b - simple
+ *		01b - head of queue
+ *		10b - ordered
+ * Bit 5-7: Priority - future use
+ * Bit 8-15: Reserved
+ */
+
+#define SNIC_ICMND_WR		0x01	/* write command */
+#define SNIC_ICMND_RD		0x02	/* read command */
+#define SNIC_ICMND_ESGL		0x04	/* SGE/ESGE array contains valid data*/
+
+/*
+ * Priority/Task Attribute settings
+ */
+#define SNIC_ICMND_TSK_SHIFT		2	/* task attr starts at bit 2 */
+#define SNIC_ICMND_TSK_MASK(x)		((x>>SNIC_ICMND_TSK_SHIFT) & ~(0xffff))
+#define SNIC_ICMND_TSK_SIMPLE		0	/* simple task attr */
+#define SNIC_ICMND_TSK_HEAD_OF_QUEUE	1	/* head of qeuue task attr */
+#define SNIC_ICMND_TSK_ORDERED		2	/* ordered task attr */
+
+#define SNIC_ICMND_PRI_SHIFT		5	/* prio val starts at bit 5 */
+
+/*
+ * snic_icmnd : host-> firmware request
+ *
+ * used for sending out an initiator SCSI 16/32-byte command
+ */
+struct snic_icmnd {
+	u16	sg_cnt;		/* Number of SG Elements */
+	u16	flags;		/* flags */
+	u32	sense_len;	/* Sense buffer length */
+	u64	tgt_id;		/* Destination Target ID */
+	u64	lun_id;		/* Destination LUN ID */
+	u8	cdb_len;
+	u8	_resvd;
+	u16	time_out;	/* ms time for Res allocations fw to handle io*/
+	u32	data_len;	/* Total number of bytes to be transferred */
+	u8	cdb[SNIC_CDB_LEN];
+	u64	sg_addr;	/* Points to SG List */
+	u64	sense_addr;	/* Sense buffer address */
+};
+
+
+/* Response flags */
+/* Bit 0: Under run
+ * Bit 1: Over Run
+ * Bit 2-7: Reserved
+ */
+#define SNIC_ICMND_CMPL_UNDR_RUN	0x01	/* resid under and valid */
+#define SNIC_ICMND_CMPL_OVER_RUN	0x02	/* resid over and valid */
+
+/*
+ * snic_icmnd_cmpl: firmware -> host response
+ *
+ * Used for sending the host a response to an icmnd (initiator command)
+ */
+struct snic_icmnd_cmpl {
+	u8	scsi_status;	/* value as per SAM */
+	u8	flags;
+	u16	sense_len;	/* Sense Length */
+	u32	resid;		/* Residue : # bytes under or over run */
+};
+
+/*
+ * snic_itmf: host->firmware request
+ *
+ * used for requesting the firmware to abort a request and/or send out
+ * a task management function
+ *
+ * the req_id field is valid in case of abort task and clear task
+ */
+struct snic_itmf {
+	u8	tm_type;	/* SCSI Task Management request */
+	u8	resvd;
+	u16	flags;		/* flags */
+	u32	req_id;		/* Command id of snic req to be aborted */
+	u64	tgt_id;		/* Target ID */
+	u64	lun_id;		/* Destination LUN ID */
+	u16	timeout;	/* in sec */
+};
+
+/*
+ * Task Management Request
+ */
+enum snic_itmf_tm_type {
+	SNIC_ITMF_ABTS_TASK = 0x01,	/* Abort Task */
+	SNIC_ITMF_ABTS_TASK_SET,	/* Abort Task Set */
+	SNIC_ITMF_CLR_TASK,		/* Clear Task */
+	SNIC_ITMF_CLR_TASKSET,		/* Clear Task Set */
+	SNIC_ITMF_LUN_RESET,		/* Lun Reset */
+	SNIC_ITMF_ABTS_TASK_TERM,	/* Supported for SAN Targets */
+};
+
+/*
+ * snic_itmf_cmpl: firmware -> host resposne
+ *
+ * used for sending the host a response for a itmf request
+ */
+struct snic_itmf_cmpl {
+	u32	nterminated;	/* # IOs terminated as a result of tmf */
+	u8	flags;		/* flags */
+	u8	_resvd[3];
+};
+
+/*
+ * itmfl_cmpl flags
+ * Bit 0 : 1 - Num terminated field valid
+ * Bit 1 - 7 : Reserved
+ */
+#define SNIC_NUM_TERM_VALID	0x01	/* Number of IOs terminated */
+
+/*
+ * snic_hba_reset: host -> firmware request
+ *
+ * used for requesting firmware to reset snic
+ */
+struct snic_hba_reset {
+	u16	flags;		/* flags */
+	u8	_resvd[6];
+};
+
+/*
+ * snic_hba_reset_cmpl: firmware -> host response
+ *
+ * Used by firmware to respond to the host's hba reset request
+ */
+struct snic_hba_reset_cmpl {
+	u8	flags;		/* flags : more info needs to be added*/
+	u8	_resvd[7];
+};
+
+/* snic_echo: host -> firmware request
+ *
+ * sends a heartbeat echo request to the firmware
+ */
+struct snic_echo {
+	u64	_resvd;
+};
+
+/* snic_echo_cmpl: firmware -> host response
+ *
+ * response to the snic_echo request
+ */
+struct snic_echo_cmpl {
+	u64	_resvd;
+};
+
+/*
+ * snic_notify_msg: firmware -> host response
+ *
+ * Used by firmware to notify host of the last work queue entry received
+ */
+struct snic_notify_msg {
+	u32	wqe_num;	/* wq entry number */
+	u8	flags;		/* flags, macros */
+	u8	_resvd[4];
+};
+
+
+#define SNIC_EVDATA_LEN		24	/* in bytes */
+/* snic_async_evnotify: firmware -> host notification
+ *
+ * Used by firmware to notify the host about configuration/state changes
+ */
+struct snic_async_evnotify {
+	u8	FLS_EVENT_DESC;		/* TODO: ?? */
+	u8	vnic;			/* vnic id */
+	u8	_resvd[2];
+	u32	ev_id;			/* Event ID */
+	u8	ev_data[SNIC_EVDATA_LEN]; /* Event Data */
+	u8	_resvd2[4];
+};
+
+/* async event flags */
+enum snic_ev_type {
+	SNIC_EV_TGT_OFFLINE = 0x01, /* Target Offline, PL contains TGT ID */
+	SNIC_EV_TGT_ONLINE,	/* Target Online, PL contains TGT ID */
+	SNIC_EV_LUN_OFFLINE,	/* LUN Offline, PL contains LUN ID */
+	SNIC_EV_LUN_ONLINE,	/* LUN Online, PL contains LUN ID */
+	SNIC_EV_CONF_CHG,	/* Dev Config/Attr Change Event */
+	SNIC_EV_TGT_ADDED,	/* TODO:Target Added, PL contains ?? */
+	SNIC_EV_TGT_DELTD,	/* Target Del'd, PL contains TGT ID */
+	SNIC_EV_LUN_ADDED,	/* TODO:LUN Added, PL contains ?? */
+	SNIC_EV_LUN_DELTD,	/* LUN Del'd, PL cont. TGT & LUN ID */
+
+	SNIC_EV_DISC_CMPL = 0x10, /* Discovery Completed Event */
+};
+
+
+#define SNIC_HOST_REQ_LEN	128	/*Exp length of host req, wq desc sz*/
+/* Payload 88 bytes = 128 - 24 - 16 */
+#define SNIC_HOST_REQ_PAYLOAD	((int)(SNIC_HOST_REQ_LEN -		\
+					sizeof(struct snic_io_hdr) -	\
+					(2 * sizeof(u64))))
+
+/*
+ * snic_host_req: host -> firmware request
+ *
+ * Basic structure for all snic requests that are sent from the host to
+ * firmware. They are 128 bytes in size.
+ */
+struct snic_host_req {
+	u64	ctrl_data[2];	/*16 bytes - Control Data */
+	struct snic_io_hdr hdr;
+	union {
+		/*
+		 * Entry specific space, last byte contains color
+		 */
+		u8	buf[SNIC_HOST_REQ_PAYLOAD];
+
+		/*
+		 * Exchange firmware version
+		 */
+		struct snic_exch_ver_req	exch_ver;
+
+		/* report targets */
+		struct snic_report_tgts		rpt_tgts;
+
+		/* io request */
+		struct snic_icmnd		icmnd;
+
+		/* task management request */
+		struct snic_itmf		itmf;
+
+		/* hba reset */
+		struct snic_hba_reset		reset;
+
+		/* echo request (heartbeat) */
+		struct snic_echo		echo;
+	} u;
+}; /* end of snic_host_req structure */
+
+
+#define SNIC_FW_REQ_LEN		64 /* Expected length of fw req */
+struct snic_fw_req {
+	struct snic_io_hdr hdr;
+	union {
+		/*
+		 * Entry specific space, last byte contains color
+		 */
+		u8	buf[SNIC_FW_REQ_LEN - sizeof(struct snic_io_hdr)];
+
+		/* Exchange Version Response */
+		struct snic_exch_ver_rsp	exch_ver_cmpl;
+
+		/* Report Targets Response */
+		struct snic_report_tgts_cmpl	rpt_tgts_cmpl;
+
+		/* scsi response */
+		struct snic_icmnd_cmpl		icmnd_cmpl;
+
+		/* task management response */
+		struct snic_itmf_cmpl		itmf_cmpl;
+
+		/* hba reset response */
+		struct snic_hba_reset_cmpl	reset_cmpl;
+
+		/* echo response (heartbeat) */
+		struct snic_echo_cmpl		echo_cmpl;
+
+		/* notify message */
+		struct snic_notify_msg		ack;
+
+		/* async notification event */
+		struct snic_async_evnotify	async_ev;
+
+	} u;
+}; /* end of snic_fw_req structure */
+
+/*
+ * Auxillary macro to verify specific snic req/cmpl structures
+ * to ensure that it will be aligned to 64 bit, and not using
+ * color bit field
+ */
+#define VERIFY_REQ_SZ(x)
+#define VERIFY_CMPL_SZ(x)
+
+/*
+ * Access routines to encode and decode the color bit, which is the most
+ * significant bit of the structure.
+ */
+static inline void
+snic_color_enc(struct snic_fw_req *req, u8 color)
+{
+	u8 *c = ((u8 *) req) + sizeof(struct snic_fw_req) - 1;
+
+	if (color)
+		*c |= 0x80;
+	else
+		*c &= ~0x80;
+}
+
+static inline void
+snic_color_dec(struct snic_fw_req *req, u8 *color)
+{
+	u8 *c = ((u8 *) req) + sizeof(struct snic_fw_req) - 1;
+
+	*color = *c >> 7;
+
+	/* Make sure color bit is read from desc *before* other fields
+	 * are read from desc. Hardware guarantees color bit is last
+	 * bit (byte) written. Adding the rmb() prevents the compiler
+	 * and/or CPU from reordering the reads which would potentially
+	 * result in reading stale values.
+	 */
+	rmb();
+}
+
+/*
+ * Report Target BootLun Response
+ * snic_report_bootlun_list : fw -> host request
+ *
+ * Used by the UEFI driver to request list of target boot lun list.
+ */
+#define MAX_BOOTLUN_LIST_INFO	2
+
+struct bootlun_info {
+	u64 scsi_target;
+	u64 scsi_lun;
+};
+
+struct snic_report_tgt_bootlun {
+	u64	num_targets;
+	struct bootlun_info *bootlun_list[MAX_BOOTLUN_LIST_INFO]; /* pt to rsp*/
+	u64	sg_addr;
+};
+
+#endif /* end of __SNIC_FWINT_H */
diff --git a/drivers/scsi/snic/snic_isr.c b/drivers/scsi/snic/snic_isr.c
new file mode 100644
index 0000000..895ccc4
--- /dev/null
+++ b/drivers/scsi/snic/snic_isr.c
@@ -0,0 +1,206 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ * [Insert appropriate license here when releasing outside of Cisco]
+ *
+ */
+
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+
+#include "vnic_dev.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "snic_io.h"
+#include "snic.h"
+
+
+/*
+ * snic_isr_msix_wq : MSIx ISR for work queue.
+ */
+
+static irqreturn_t
+snic_isr_msix_wq(int irq, void *data)
+{
+	struct snic *snic = data;
+	unsigned long wq_work_done = 0;
+
+	snic->s_stats.misc.last_isr_time = jiffies;
+	atomic64_inc(&snic->s_stats.misc.isr_cnt);
+
+	wq_work_done = snic_wq_cmpl_handler(snic, -1);
+	vnic_intr_return_credits(&snic->intr[SNIC_MSIX_WQ],
+				 wq_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+
+	return IRQ_HANDLED;
+} /* end of snic_isr_msix_wq */
+
+static irqreturn_t
+snic_isr_msix_io_cmpl(int irq, void *data)
+{
+	struct snic *snic = data;
+	unsigned long iocmpl_work_done = 0;
+
+	snic->s_stats.misc.last_isr_time = jiffies;
+	atomic64_inc(&snic->s_stats.misc.isr_cnt);
+
+	iocmpl_work_done = snic_fwcq_cmpl_handler(snic, -1);
+	vnic_intr_return_credits(&snic->intr[SNIC_MSIX_IO_CMPL],
+				 iocmpl_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+
+	return IRQ_HANDLED;
+} /* end of snic_isr_msix_io_cmpl */
+
+static irqreturn_t
+snic_isr_msix_err_notify(int irq, void *data)
+{
+	struct snic *snic = data;
+
+	snic->s_stats.misc.last_isr_time = jiffies;
+	atomic64_inc(&snic->s_stats.misc.isr_cnt);
+
+	vnic_intr_return_all_credits(&snic->intr[SNIC_MSIX_ERR_NOTIFY]);
+	snic_log_q_error(snic);
+
+	/*Handling link events */
+	snic_handle_link_event(snic);
+
+	return IRQ_HANDLED;
+} /* end of snic_isr_msix_err_notify */
+
+
+void
+snic_free_intr(struct snic *snic)
+{
+	int i;
+
+	/* ONLY interrupt mode MSIX is supported */
+	for (i = 0; i < ARRAY_SIZE(snic->msix); i++) {
+		if (snic->msix[i].requested) {
+			free_irq(snic->msix_entry[i].vector,
+				 snic->msix[i].devid);
+		}
+	}
+} /* end of snic_free_intr */
+
+int
+snic_request_intr(struct snic *snic)
+{
+	int ret = 0, i;
+
+#ifdef SNIC_DEBUG
+	enum vnic_dev_intr_mode intr_mode;
+
+	intr_mode = vnic_dev_get_intr_mode(snic->vdev);
+	SNIC_BUG_ON(intr_mode != VNIC_DEV_INTR_MODE_MSIX);
+#endif
+
+	/* FIXME: Pass devid as work queue or completion queue pointers
+	 * except for err_notify
+	 */
+	sprintf(snic->msix[SNIC_MSIX_WQ].devname,
+		"%.11s-scsi-wq",
+		snic->name);
+	snic->msix[SNIC_MSIX_WQ].isr = snic_isr_msix_wq;
+	snic->msix[SNIC_MSIX_WQ].devid = snic;
+
+	/* FIXME: name can be scsi_cq or iocmpl */
+	sprintf(snic->msix[SNIC_MSIX_IO_CMPL].devname,
+		"%.11s-io-cmpl",
+		snic->name);
+	snic->msix[SNIC_MSIX_IO_CMPL].isr = snic_isr_msix_io_cmpl;
+	snic->msix[SNIC_MSIX_IO_CMPL].devid = snic;
+
+	sprintf(snic->msix[SNIC_MSIX_ERR_NOTIFY].devname,
+		"%.11s-err-notify",
+		snic->name);
+	snic->msix[SNIC_MSIX_ERR_NOTIFY].isr = snic_isr_msix_err_notify;
+	snic->msix[SNIC_MSIX_ERR_NOTIFY].devid = snic;
+
+	for (i = 0; i < ARRAY_SIZE(snic->msix); i++) {
+		ret = request_irq(snic->msix_entry[i].vector,
+				  snic->msix[i].isr,
+				  0,
+				  snic->msix[i].devname,
+				  snic->msix[i].devid);
+		if (ret) {
+			SNIC_HOST_ERR(snic->shost,
+				      "MSI-X: requrest_irq(%d) failed %d\n",
+				      i,
+				      ret);
+			snic_free_intr(snic);
+			break;
+		}
+		snic->msix[i].requested = 1;
+	}
+
+	return ret;
+} /* end of snic_requrest_intr */
+
+int
+snic_set_intr_mode(struct snic *snic)
+{
+	unsigned int n = ARRAY_SIZE(snic->wq);
+	unsigned int m = SNIC_CQ_IO_CMPL_MAX;
+	unsigned int i;
+
+	/*
+	 * We need n WQs, m CQs, and n+m+1 INTRs
+	 * (last INTR is used for WQ/CQ errors and notification area
+	 */
+
+	BUILD_BUG_ON((ARRAY_SIZE(snic->wq) + SNIC_CQ_IO_CMPL_MAX) >
+			ARRAY_SIZE(snic->intr));
+	SNIC_BUG_ON(ARRAY_SIZE(snic->msix_entry) < (n + m + 1));
+
+	for (i = 0; i < (n + m + 1); i++)
+		snic->msix_entry[i].entry = i;
+
+	if (snic->wq_count >= n && snic->cq_count >= (n + m)) {
+		if (!pci_enable_msix(snic->pdev,
+				     snic->msix_entry,
+				     (n + m + 1))) {
+			snic->wq_count = n;
+			snic->cq_count = n + m;
+			snic->intr_count = n + m + 1;
+			snic->err_intr_offset = SNIC_MSIX_ERR_NOTIFY;
+
+			SNIC_ISR_DBG(snic->shost,
+				     "Using MSI-X Interrupts\n");
+			vnic_dev_set_intr_mode(snic->vdev,
+						VNIC_DEV_INTR_MODE_MSIX);
+
+			return 0;
+		}
+	}
+
+	vnic_dev_set_intr_mode(snic->vdev, VNIC_DEV_INTR_MODE_UNKNOWN);
+
+	return -EINVAL;
+} /* end of snic_set_intr_mode */
+
+void
+snic_clear_intr_mode(struct snic *snic)
+{
+	pci_disable_msix(snic->pdev);
+
+	vnic_dev_set_intr_mode(snic->vdev, VNIC_DEV_INTR_MODE_INTX);
+}
diff --git a/drivers/scsi/snic/snic_res.c b/drivers/scsi/snic/snic_res.c
new file mode 100644
index 0000000..da27a72
--- /dev/null
+++ b/drivers/scsi/snic/snic_res.c
@@ -0,0 +1,318 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+
+#include "wq_enet_desc.h"
+#include "cq_enet_desc.h"
+#include "vnic_resource.h"
+#include "vnic_dev.h"
+#include "vnic_wq.h"
+#include "vnic_cq.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "snic.h"
+
+int
+snic_get_vnic_config(struct snic *snic)
+{
+	struct vnic_snic_config *c = &snic->config;
+	int ret;
+
+#define GET_CONFIG(m) \
+	do { \
+		ret = vnic_dev_spec(snic->vdev, \
+				    offsetof(struct vnic_snic_config, m), \
+				    sizeof(c->m), \
+				    &c->m); \
+		if (ret) { \
+			SNIC_HOST_ERR(snic->shost, \
+				      "Error getting %s, %d\n", #m, ret); \
+			return ret; \
+		} \
+	} while (0)
+
+	GET_CONFIG(wq_enet_desc_count);
+	GET_CONFIG(maxdatafieldsize);
+	GET_CONFIG(intr_timer);
+	GET_CONFIG(intr_timer_type);
+	GET_CONFIG(flags);
+	GET_CONFIG(io_throttle_count);
+	GET_CONFIG(port_down_timeout);
+	GET_CONFIG(port_down_io_retries);
+	GET_CONFIG(luns_per_tgt);
+	GET_CONFIG(xpt_type);
+	GET_CONFIG(hid);
+
+	c->wq_enet_desc_count = min_t(u32,
+				      VNIC_SNIC_WQ_DESCS_MAX,
+				      max_t(u32,
+					    VNIC_SNIC_WQ_DESCS_MIN,
+					    c->wq_enet_desc_count));
+
+	c->wq_enet_desc_count = ALIGN(c->wq_enet_desc_count, 16);
+
+	c->maxdatafieldsize = min_t(u32,
+				    VNIC_SNIC_MAXDATAFIELDSIZE_MAX,
+				    max_t(u32,
+					  VNIC_SNIC_MAXDATAFIELDSIZE_MIN,
+					  c->maxdatafieldsize));
+
+	c->io_throttle_count = min_t(u32,
+				     VNIC_SNIC_IO_THROTTLE_COUNT_MAX,
+				     max_t(u32,
+					   VNIC_SNIC_IO_THROTTLE_COUNT_MIN,
+					   c->io_throttle_count));
+
+	c->port_down_timeout = min_t(u32,
+				     VNIC_SNIC_PORT_DOWN_TIMEOUT_MAX,
+				     c->port_down_timeout);
+
+	c->port_down_io_retries = min_t(u32,
+				     VNIC_SNIC_PORT_DOWN_IO_RETRIES_MAX,
+				     c->port_down_io_retries);
+
+	c->luns_per_tgt = min_t(u32,
+				VNIC_SNIC_LUNS_PER_TARGET_MAX,
+				max_t(u32,
+				      VNIC_SNIC_LUNS_PER_TARGET_MIN,
+				      c->luns_per_tgt));
+
+	c->intr_timer = min_t(u32, VNIC_INTR_TIMER_MAX, c->intr_timer);
+
+	SNIC_INFO("vNIC resources wq %d\n", c->wq_enet_desc_count);
+	SNIC_INFO("vNIC mtu %d intr timer %d\n",
+		  c->maxdatafieldsize,
+		  c->intr_timer);
+
+	SNIC_INFO("vNIC flags 0x%x luns per tgt %d\n",
+		  c->flags,
+		  c->luns_per_tgt);
+
+	SNIC_INFO("vNIC io throttle count %d\n", c->io_throttle_count);
+	SNIC_INFO("vNIC port down timeout %d port down io retries %d\n",
+		  c->port_down_timeout,
+		  c->port_down_io_retries);
+
+	SNIC_INFO("vNIC back end type = %d\n", c->xpt_type);
+	SNIC_INFO("vNIC hid = %d\n", c->hid);
+
+	return 0;
+}
+
+void
+snic_get_res_counts(struct snic *snic)
+{
+	snic->wq_count = vnic_dev_get_res_count(snic->vdev, RES_TYPE_WQ);
+	SNIC_BUG_ON(snic->wq_count == 0);
+	snic->cq_count = vnic_dev_get_res_count(snic->vdev, RES_TYPE_CQ);
+	SNIC_BUG_ON(snic->cq_count == 0);
+	snic->intr_count = vnic_dev_get_res_count(snic->vdev,
+						  RES_TYPE_INTR_CTRL);
+	SNIC_BUG_ON(snic->intr_count == 0);
+}
+
+void
+snic_free_vnic_res(struct snic *snic)
+{
+	unsigned int i;
+
+	for (i = 0; i < snic->wq_count; i++)
+		vnic_wq_free(&snic->wq[i]);
+
+	for (i = 0; i < snic->cq_count; i++)
+		vnic_cq_free(&snic->cq[i]);
+
+	for (i = 0; i < snic->intr_count; i++)
+		vnic_intr_free(&snic->intr[i]);
+}
+
+int
+snic_alloc_vnic_res(struct snic *snic)
+{
+	enum vnic_dev_intr_mode intr_mode;
+	unsigned int mask_on_assertion;
+	unsigned int intr_offset;
+	unsigned int err_intr_enable;
+	unsigned int err_intr_offset;
+	unsigned int i;
+	int ret;
+
+	intr_mode = vnic_dev_get_intr_mode(snic->vdev);
+
+	SNIC_INFO("vNIC interrupt mode: %s\n",
+		  ((intr_mode == VNIC_DEV_INTR_MODE_INTX) ?
+		   "Legacy PCI INTx" :
+		   ((intr_mode == VNIC_DEV_INTR_MODE_MSI) ?
+		    "MSI" :
+		    ((intr_mode == VNIC_DEV_INTR_MODE_MSIX) ?
+		     "MSI-X" : "Unknown"))));
+
+	/* only MSI-X is supported */
+	SNIC_BUG_ON(intr_mode != VNIC_DEV_INTR_MODE_MSIX);
+
+	SNIC_INFO("wq %d cq %d intr %d\n", snic->wq_count,
+		  snic->cq_count,
+		  snic->intr_count);
+
+
+	/* Allocate WQs used for SCSI IOs */
+	for (i = 0; i < snic->wq_count; i++) {
+		ret = vnic_wq_alloc(snic->vdev,
+				    &snic->wq[i],
+				    i,
+				    snic->config.wq_enet_desc_count,
+				    sizeof(struct wq_enet_desc));
+		if (ret)
+			goto error_cleanup;
+	}
+
+	/* CQ for each WQ */
+	for (i = 0; i < snic->wq_count; i++) {
+		ret = vnic_cq_alloc(snic->vdev,
+				    &snic->cq[i],
+				    i,
+				    snic->config.wq_enet_desc_count,
+				    sizeof(struct cq_enet_wq_desc));
+		if (ret)
+			goto error_cleanup;
+	}
+
+#ifdef SNIC_DEBUG
+	SNIC_BUG_ON(snic->cq_count != 2 * snic->wq_count);
+#endif
+	/* CQ for FW TO host */
+	for (i = snic->wq_count; i < snic->cq_count; i++) {
+		ret = vnic_cq_alloc(snic->vdev,
+				    &snic->cq[i],
+				    i,
+				    (snic->config.wq_enet_desc_count * 3),
+				    sizeof(struct snic_fw_req));
+		if (ret)
+			goto error_cleanup;
+	}
+
+	for (i = 0; i < snic->intr_count; i++) {
+		ret = vnic_intr_alloc(snic->vdev, &snic->intr[i], i);
+		if (ret)
+			goto error_cleanup;
+	}
+
+	/*
+	 * Init WQ Resources.
+	 * WQ[0 to n] points to CQ[0 to n-1]
+	 * firmware to host comm points to CQ[n to m+1]
+	 */
+	err_intr_enable = 1;
+	err_intr_offset = snic->err_intr_offset;
+
+	for (i = 0; i < snic->wq_count; i++) {
+		vnic_wq_init(&snic->wq[i],
+			     i,
+			     err_intr_enable,
+			     err_intr_offset);
+	}
+
+	for (i = 0; i < snic->cq_count; i++) {
+		intr_offset = i;
+
+		vnic_cq_init(&snic->cq[i],
+			     0 /* flow_control_enable */,
+			     1 /* color_enable */,
+			     0 /* cq_head */,
+			     0 /* cq_tail */,
+			     1 /* cq_tail_color */,
+			     1 /* interrupt_enable */,
+			     1 /* cq_entry_enable */,
+			     0 /* cq_message_enable */,
+			     intr_offset,
+			     0 /* cq_message_addr */);
+	}
+
+	/*
+	 * Init INTR resources
+	 * Assumption : snic is always in MSI-X mode
+	 */
+	SNIC_BUG_ON(intr_mode != VNIC_DEV_INTR_MODE_MSIX);
+	mask_on_assertion = 1;
+
+	for (i = 0; i < snic->intr_count; i++) {
+		vnic_intr_init(&snic->intr[i],
+				snic->config.intr_timer,
+				snic->config.intr_timer_type,
+				mask_on_assertion);
+	}
+
+	/* init the stats memory by making the first call here */
+	ret = vnic_dev_stats_dump(snic->vdev, &snic->stats);
+	if (ret) {
+		SNIC_HOST_ERR(snic->shost,
+			      "vnic_dev_stats_dump failed - x%x\n",
+			      ret);
+		goto error_cleanup;
+	}
+
+	/* Clear LIF stats */
+	vnic_dev_stats_clear(snic->vdev);
+	ret = 0;
+
+	return ret;
+
+error_cleanup:
+	snic_free_vnic_res(snic);
+
+	return ret;
+}
+
+int snic_get_vnic_resources_size(struct snic *snic)
+{
+	unsigned int mem_size = 0;
+
+	snic_get_res_counts(snic);
+
+	/* add mem size for vnic stats structure */
+	mem_size += sizeof(struct vnic_stats);
+
+	/* add mem size for fw info */
+	mem_size += sizeof(struct vnic_devcmd_fw_info);
+
+	/* add mem size for dev cmd notify */
+	mem_size += sizeof(struct vnic_devcmd_notify);
+
+	pr_info(PFX "vNIC mem_size reqd: %d\n", mem_size);
+
+	return mem_size;
+
+}
+
+void
+snic_log_q_error(struct snic *snic)
+{
+	unsigned int i;
+	u32 err_status;
+
+	for (i = 0; i < snic->wq_count; i++) {
+		err_status = ioread32(&snic->wq[i].ctrl->error_status);
+		if (err_status)
+			SNIC_HOST_ERR(snic->shost,
+				      "WQ[%d] error status %d\n",
+				      i,
+				      err_status);
+	}
+} /* end of snic_log_q_error */
diff --git a/drivers/scsi/snic/snic_res.h b/drivers/scsi/snic/snic_res.h
new file mode 100644
index 0000000..f8f4e29
--- /dev/null
+++ b/drivers/scsi/snic/snic_res.h
@@ -0,0 +1,96 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef __SNIC_RES_H
+#define __SNIC_RES_H
+
+#include "snic_io.h"
+#include "wq_enet_desc.h"
+#include "vnic_wq.h"
+#include "snic_fwint.h"
+#include "vnic_cq_fw.h"
+
+static inline void
+snic_icmnd_init(struct snic_host_req *req, u32 cmnd_id, u32 host_id, u64 ctx,
+		u16 flags, u64 tgt_id, u8 *lun, u8 *scsi_cdb, u8 cdb_len,
+		u32 data_len, u16 sg_cnt, u64 sgl_addr, u64 sns_addr_pa,
+		u32 sense_len)
+{
+	snic_io_hdr_enc(&req->hdr, SNIC_REQ_ICMND, 0, cmnd_id, host_id, sg_cnt,
+			ctx);
+
+	req->u.icmnd.flags = flags;
+	req->u.icmnd.tgt_id = tgt_id;
+	memcpy(&req->u.icmnd.lun_id, lun, LUN_ADDR_LEN);
+	req->u.icmnd.cdb_len = cdb_len;
+	memset(req->u.icmnd.cdb, 0, SNIC_CDB_LEN);
+	memcpy(req->u.icmnd.cdb, scsi_cdb, cdb_len);
+	req->u.icmnd.data_len = data_len;
+	req->u.icmnd.sg_addr = sgl_addr;
+	req->u.icmnd.sense_len = sense_len;
+	req->u.icmnd.sense_addr = sns_addr_pa;
+}
+
+static inline void
+snic_itmf_init(struct snic_host_req *req, u32 cmnd_id, u32 host_id, u64 ctx,
+	       u16 flags, u32 req_id, u64 tgt_id, u8 *lun, u8 tm_type)
+{
+	snic_io_hdr_enc(&req->hdr, SNIC_REQ_ITMF, 0, cmnd_id, host_id, 0, ctx);
+
+	req->u.itmf.tm_type = tm_type;
+	req->u.itmf.flags = flags;
+	req->u.itmf.req_id = req_id; /* valid only in abort, clear task */
+	req->u.itmf.tgt_id = tgt_id;
+	memcpy(&req->u.itmf.lun_id, lun, LUN_ADDR_LEN);
+}
+
+static inline void
+snic_queue_wq_eth_desc(struct vnic_wq *wq,
+		       void *os_buf,
+		       dma_addr_t dma_addr,
+		       unsigned int len,
+		       int vlan_tag_insert,
+		       unsigned int vlan_tag,
+		       int cq_entry)
+{
+	struct wq_enet_desc *desc = vnic_wq_next_desc(wq);
+
+	wq_enet_desc_enc(desc,
+			(u64)dma_addr | VNIC_PADDR_TARGET,
+			(u16)len,
+			0, /* mss_or_csum_offset */
+			0, /* fc_eof */
+			0, /* offload mode */
+			1, /* eop */
+			(u8)cq_entry,
+			0, /* fcoe_encap */
+			(u8)vlan_tag_insert,
+			(u16)vlan_tag,
+			0 /* loopback */);
+
+	vnic_wq_post(wq, os_buf, dma_addr, len, 1, 1);
+}
+
+struct snic;
+
+int snic_get_vnic_config(struct snic *);
+int snic_alloc_vnic_res(struct snic *);
+void snic_free_vnic_res(struct snic *);
+void snic_get_res_counts(struct snic *);
+void snic_log_q_error(struct snic *);
+int snic_get_vnic_resources_size(struct snic *);
+#endif /* __SNIC_RES_H */
-- 
1.8.5.4

