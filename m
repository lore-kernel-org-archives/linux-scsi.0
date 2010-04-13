From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 2/4/4/5] iSCSI-SCST's header files
Date: Tue, 13 Apr 2010 17:10:18 +0400
Message-ID: <4BC46D3A.1040103@vlnb.net>
References: <4BC44A49.7070307@vlnb.net> <4BC45E87.6000901@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab0DMNLB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 09:11:01 -0400
In-Reply-To: <4BC45E87.6000901@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>

This patch contains iSCSI-SCST's header files.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 drivers/scst/iscsi-scst/digest.h    |   31 +
 drivers/scst/iscsi-scst/iscsi.h     |  709 ++++++++++++++++++++++++++++++++++++
 drivers/scst/iscsi-scst/iscsi_dbg.h |   60 +++
 drivers/scst/iscsi-scst/iscsi_hdr.h |  519 ++++++++++++++++++++++++++
 include/scst/iscsi_scst.h           |  207 ++++++++++
 include/scst/iscsi_scst_itf_ver.h   |    2 
 include/scst/iscsi_scst_ver.h       |   18 
 
diff -uprN orig/linux-2.6.33/include/scst/iscsi_scst.h linux-2.6.33/include/scst/iscsi_scst.h
--- orig/linux-2.6.33/include/scst/iscsi_scst.h
+++ linux-2.6.33/include/scst/iscsi_scst.h
@@ -0,0 +1,207 @@
+/*
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef _ISCSI_SCST_U_H
+#define _ISCSI_SCST_U_H
+
+#ifndef __KERNEL__
+#include <sys/uio.h>
+#endif
+
+#include "iscsi_scst_ver.h"
+#include "iscsi_scst_itf_ver.h"
+
+/* The maximum length of 223 bytes in the RFC. */
+#define ISCSI_NAME_LEN		256
+
+#define ISCSI_LISTEN_PORT	3260
+
+#define SCSI_ID_LEN		24
+
+#ifndef aligned_u64
+#define aligned_u64 uint64_t __attribute__((aligned(8)))
+#endif
+
+#define ISCSI_MAX_ATTR_NAME_LEN		50
+#define ISCSI_MAX_ATTR_VALUE_LEN	512
+
+enum {
+	key_initial_r2t,
+	key_immediate_data,
+	key_max_connections,
+	key_max_recv_data_length,
+	key_max_xmit_data_length,
+	key_max_burst_length,
+	key_first_burst_length,
+	key_default_wait_time,
+	key_default_retain_time,
+	key_max_outstanding_r2t,
+	key_data_pdu_inorder,
+	key_data_sequence_inorder,
+	key_error_recovery_level,
+	key_header_digest,
+	key_data_digest,
+	key_ofmarker,
+	key_ifmarker,
+	key_ofmarkint,
+	key_ifmarkint,
+	session_key_last,
+};
+
+enum {
+	key_queued_cmnds,
+	key_rsp_timeout,
+	key_nop_in_interval,
+	key_max_sessions,
+	target_key_last,
+};
+
+enum {
+	key_session,
+	key_target,
+};
+
+struct iscsi_kern_target_info {
+	u32 tid;
+	u32 cookie;
+	char name[ISCSI_NAME_LEN];
+	u32 attrs_num;
+	aligned_u64 attrs_ptr;
+};
+
+struct iscsi_kern_session_info {
+	u32 tid;
+	aligned_u64 sid;
+	char initiator_name[ISCSI_NAME_LEN];
+	u32 exp_cmd_sn;
+	s32 session_params[session_key_last];
+	s32 target_params[target_key_last];
+};
+
+#define DIGEST_ALL		(DIGEST_NONE | DIGEST_CRC32C)
+#define DIGEST_NONE		(1 << 0)
+#define DIGEST_CRC32C           (1 << 1)
+
+struct iscsi_kern_conn_info {
+	u32 tid;
+	aligned_u64 sid;
+
+	u32 cid;
+	u32 stat_sn;
+	u32 exp_stat_sn;
+	int fd;
+};
+
+struct iscsi_kern_attr {
+	u32 mode;
+	char name[ISCSI_MAX_ATTR_NAME_LEN];
+};
+
+struct iscsi_kern_mgmt_cmd_res_info {
+	u32 tid;
+	u32 cookie;
+	u32 req_cmd;
+	u32 result;
+	char value[ISCSI_MAX_ATTR_VALUE_LEN];
+};
+
+struct iscsi_kern_params_info {
+	u32 tid;
+	aligned_u64 sid;
+
+	u32 params_type;
+	u32 partial;
+
+	s32 session_params[session_key_last];
+	s32 target_params[target_key_last];
+};
+
+enum iscsi_kern_event_code {
+	E_ADD_TARGET,
+	E_DEL_TARGET,
+	E_MGMT_CMD,
+	E_ENABLE_TARGET,
+	E_DISABLE_TARGET,
+	E_GET_ATTR_VALUE,
+	E_SET_ATTR_VALUE,
+	E_CONN_CLOSE,
+};
+
+struct iscsi_kern_event {
+	u32 tid;
+	aligned_u64 sid;
+	u32 cid;
+	u32 code;
+	u32 cookie;
+	char target_name[ISCSI_NAME_LEN];
+	u32 param1_size;
+	u32 param2_size;
+};
+
+struct iscsi_kern_register_info {
+	union {
+		aligned_u64 version;
+		struct {
+			int max_data_seg_len;
+			int max_queued_cmds;
+		};
+	};
+};
+
+struct iscsi_kern_attr_info {
+	u32 tid;
+	u32 cookie;
+	struct iscsi_kern_attr attr;
+};
+
+#define	DEFAULT_NR_QUEUED_CMNDS	32
+#define	MIN_NR_QUEUED_CMNDS	1
+#define	MAX_NR_QUEUED_CMNDS	256
+
+#define DEFAULT_RSP_TIMEOUT	30
+#define MIN_RSP_TIMEOUT		10
+#define MAX_RSP_TIMEOUT		65535
+
+#define DEFAULT_NOP_IN_INTERVAL 30
+#define MIN_NOP_IN_INTERVAL	0
+#define MAX_NOP_IN_INTERVAL	65535
+
+#define NETLINK_ISCSI_SCST	25
+
+#define REGISTER_USERD		_IOWR('s', 0, struct iscsi_kern_register_info)
+#define ADD_TARGET		_IOW('s', 1, struct iscsi_kern_target_info)
+#define DEL_TARGET		_IOW('s', 2, struct iscsi_kern_target_info)
+#define ADD_SESSION		_IOW('s', 3, struct iscsi_kern_session_info)
+#define DEL_SESSION		_IOW('s', 4, struct iscsi_kern_session_info)
+#define ADD_CONN		_IOW('s', 5, struct iscsi_kern_conn_info)
+#define DEL_CONN		_IOW('s', 6, struct iscsi_kern_conn_info)
+#define ISCSI_PARAM_SET		_IOW('s', 7, struct iscsi_kern_params_info)
+#define ISCSI_PARAM_GET		_IOWR('s', 8, struct iscsi_kern_params_info)
+
+#define ISCSI_ATTR_ADD		_IOW('s', 9, struct iscsi_kern_attr_info)
+#define ISCSI_ATTR_DEL		_IOW('s', 10, struct iscsi_kern_attr_info)
+#define MGMT_CMD_CALLBACK	_IOW('s', 11, struct iscsi_kern_mgmt_cmd_res_info)
+
+static inline int iscsi_is_key_internal(int key)
+{
+	switch (key) {
+	case key_max_xmit_data_length:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+#endif
diff -uprN orig/linux-2.6.33/include/scst/iscsi_scst_ver.h linux-2.6.33/include/scst/iscsi_scst_ver.h
--- orig/linux-2.6.33/include/scst/iscsi_scst_ver.h
+++ linux-2.6.33/include/scst/iscsi_scst_ver.h
@@ -0,0 +1,18 @@
+/*
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#define ISCSI_VERSION_STRING_SUFFIX
+
+#define ISCSI_VERSION_STRING	"2.0.0/0.4.17r214" ISCSI_VERSION_STRING_SUFFIX
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/digest.h linux-2.6.33/drivers/scst/iscsi-scst/digest.h
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/digest.h
+++ linux-2.6.33/drivers/scst/iscsi-scst/digest.h
@@ -0,0 +1,31 @@
+/*
+ *  iSCSI digest handling.
+ *
+ *  Copyright (C) 2004 Xiranet Communications GmbH <arne.redlich@xiranet.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef __ISCSI_DIGEST_H__
+#define __ISCSI_DIGEST_H__
+
+extern void digest_alg_available(int *val);
+
+extern int digest_init(struct iscsi_conn *conn);
+
+extern int digest_rx_header(struct iscsi_cmnd *cmnd);
+extern int digest_rx_data(struct iscsi_cmnd *cmnd);
+
+extern void digest_tx_header(struct iscsi_cmnd *cmnd);
+extern void digest_tx_data(struct iscsi_cmnd *cmnd);
+
+#endif /* __ISCSI_DIGEST_H__ */
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi_dbg.h linux-2.6.33/drivers/scst/iscsi-scst/iscsi_dbg.h
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi_dbg.h
+++ linux-2.6.33/drivers/scst/iscsi-scst/iscsi_dbg.h
@@ -0,0 +1,60 @@
+/*
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef ISCSI_DBG_H
+#define ISCSI_DBG_H
+
+#define LOG_PREFIX "iscsi-scst"
+
+#include <scst_debug.h>
+
+#define TRACE_D_WRITE		0x80000000
+#define TRACE_CONN_OC		0x40000000
+#define TRACE_D_IOV		0x20000000
+#define TRACE_D_DUMP_PDU	0x10000000
+#define TRACE_NET_PG		0x08000000
+#define TRACE_CONN_OC_DBG	0x04000000
+
+#ifdef CONFIG_SCST_DEBUG
+#define ISCSI_DEFAULT_LOG_FLAGS (TRACE_FUNCTION | TRACE_LINE | TRACE_PID | \
+	TRACE_OUT_OF_MEM | TRACE_MGMT | TRACE_MGMT_DEBUG | \
+	TRACE_MINOR | TRACE_SPECIAL | TRACE_CONN_OC)
+#else
+#define ISCSI_DEFAULT_LOG_FLAGS (TRACE_OUT_OF_MEM | TRACE_MGMT | \
+	TRACE_SPECIAL)
+#endif
+
+#ifdef CONFIG_SCST_DEBUG
+struct iscsi_pdu;
+struct iscsi_cmnd;
+extern void iscsi_dump_pdu(struct iscsi_pdu *pdu);
+extern unsigned long iscsi_get_flow_ctrl_or_mgmt_dbg_log_flag(
+	struct iscsi_cmnd *cmnd);
+#else
+#define iscsi_dump_pdu(x) do {} while (0)
+#define iscsi_get_flow_ctrl_or_mgmt_dbg_log_flag(x) do {} while (0)
+#endif
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+extern unsigned long iscsi_trace_flag;
+#define trace_flag iscsi_trace_flag
+#endif
+
+#define TRACE_CONN_CLOSE(args...)	TRACE_DBG_FLAG(TRACE_DEBUG|TRACE_CONN_OC, args)
+#define TRACE_CONN_CLOSE_DBG(args...)	TRACE(TRACE_CONN_OC_DBG, args)
+#define TRACE_NET_PAGE(args...)		TRACE_DBG_FLAG(TRACE_NET_PG, args)
+#define TRACE_WRITE(args...)		TRACE_DBG_FLAG(TRACE_DEBUG|TRACE_D_WRITE, args)
+
+#endif
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi.h linux-2.6.33/drivers/scst/iscsi-scst/iscsi.h
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi.h
+++ linux-2.6.33/drivers/scst/iscsi-scst/iscsi.h
@@ -0,0 +1,709 @@
+/*
+ *  Copyright (C) 2002 - 2003 Ardis Technolgies <roman@ardistech.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef __ISCSI_H__
+#define __ISCSI_H__
+
+#include <linux/pagemap.h>
+#include <linux/mm.h>
+#include <linux/net.h>
+#include <net/sock.h>
+
+#include <scst.h>
+
+#include "iscsi_hdr.h"
+#include "iscsi_scst.h"
+
+#include "iscsi_dbg.h"
+
+#define iscsi_sense_crc_error			ABORTED_COMMAND, 0x47, 0x05
+#define iscsi_sense_unexpected_unsolicited_data	ABORTED_COMMAND, 0x0C, 0x0C
+#define iscsi_sense_incorrect_amount_of_data	ABORTED_COMMAND, 0x0C, 0x0D
+
+struct iscsi_sess_params {
+	int initial_r2t;
+	int immediate_data;
+	int max_connections;
+	unsigned int max_recv_data_length;
+	unsigned int max_xmit_data_length;
+	unsigned int max_burst_length;
+	unsigned int first_burst_length;
+	int default_wait_time;
+	int default_retain_time;
+	unsigned int max_outstanding_r2t;
+	int data_pdu_inorder;
+	int data_sequence_inorder;
+	int error_recovery_level;
+	int header_digest;
+	int data_digest;
+	int ofmarker;
+	int ifmarker;
+	int ofmarkint;
+	int ifmarkint;
+};
+
+struct iscsi_tgt_params {
+	int queued_cmnds;
+	unsigned int rsp_timeout;
+	unsigned int nop_in_interval;
+};
+
+struct network_thread_info {
+	struct task_struct *task;
+	unsigned int ready;
+};
+
+struct iscsi_target;
+struct iscsi_cmnd;
+
+struct iscsi_attr {
+	struct list_head attrs_list_entry;
+	struct kobj_attribute attr;
+	struct iscsi_target *target;
+	const char *name;
+};
+
+struct iscsi_target {
+	struct scst_tgt *scst_tgt;
+
+	struct mutex target_mutex;
+
+	struct list_head session_list; /* protected by target_mutex */
+
+	struct list_head target_list_entry;
+	u32 tid;
+
+	/* Protected by iscsi_sysfs_mutex */
+	unsigned int tgt_enabled:1;
+
+	/* Protected by target_mutex */
+	struct list_head attrs_list;
+
+	char name[ISCSI_NAME_LEN];
+};
+
+#define ISCSI_HASH_ORDER	8
+#define	cmnd_hashfn(itt)	hash_long((itt), ISCSI_HASH_ORDER)
+
+struct iscsi_session {
+	struct iscsi_target *target;
+	struct scst_session *scst_sess;
+
+	struct list_head pending_list; /* protected by sn_lock */
+
+	/* Unprotected, since accessed only from a single read thread */
+	u32 next_ttt;
+
+	/* Read only, if there are connection(s) */
+	struct iscsi_tgt_params tgt_params;
+	atomic_t active_cmds;
+
+	spinlock_t sn_lock;
+	u32 exp_cmd_sn; /* protected by sn_lock */
+
+	/* All 3 protected by sn_lock */
+	int tm_active;
+	u32 tm_sn;
+	struct iscsi_cmnd *tm_rsp;
+
+	/* Read only, if there are connection(s) */
+	struct iscsi_sess_params sess_params;
+
+	/*
+	 * In some corner cases commands can be deleted from the hash
+	 * not from the corresponding read thread. So, let's simplify
+	 * errors recovery and have this lock.
+	 */
+	spinlock_t cmnd_data_wait_hash_lock;
+	struct list_head cmnd_data_wait_hash[1 << ISCSI_HASH_ORDER];
+
+	struct list_head conn_list; /* protected by target_mutex */
+
+	struct list_head session_list_entry;
+
+	/* All protected by target_mutex, where necessary */
+	struct iscsi_session *sess_reinst_successor;
+	unsigned int sess_reinstating:1;
+	unsigned int sess_shutting_down:1;
+
+	/* All don't need any protection */
+	char *initiator_name;
+	u64 sid;
+};
+
+#define ISCSI_CONN_IOV_MAX			(PAGE_SIZE/sizeof(struct iovec))
+
+#define ISCSI_CONN_RD_STATE_IDLE		0
+#define ISCSI_CONN_RD_STATE_IN_LIST		1
+#define ISCSI_CONN_RD_STATE_PROCESSING		2
+
+#define ISCSI_CONN_WR_STATE_IDLE		0
+#define ISCSI_CONN_WR_STATE_IN_LIST		1
+#define ISCSI_CONN_WR_STATE_SPACE_WAIT		2
+#define ISCSI_CONN_WR_STATE_PROCESSING		3
+
+struct iscsi_conn {
+	struct iscsi_session *session; /* owning session */
+
+	/* Both protected by session->sn_lock */
+	u32 stat_sn;
+	u32 exp_stat_sn;
+
+#define ISCSI_CONN_REINSTATING	1
+#define ISCSI_CONN_SHUTTINGDOWN	2
+	unsigned long conn_aflags;
+
+	spinlock_t cmd_list_lock; /* BH lock */
+
+	/* Protected by cmd_list_lock */
+	struct list_head cmd_list; /* in/outcoming pdus */
+
+	atomic_t conn_ref_cnt;
+
+	spinlock_t write_list_lock;
+	/* List of data pdus to be sent, protected by write_list_lock */
+	struct list_head write_list;
+	/* List of data pdus being sent, protected by write_list_lock */
+	struct list_head write_timeout_list;
+
+	/* Protected by write_list_lock */
+	struct timer_list rsp_timer;
+	unsigned int rsp_timeout; /* in jiffies */
+
+	/* All 2 protected by iscsi_wr_lock */
+	unsigned short wr_state;
+	unsigned short wr_space_ready:1;
+
+	struct list_head wr_list_entry;
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	struct task_struct *wr_task;
+#endif
+
+	/*
+	 * All are unprotected, since accessed only from a single write
+	 * thread.
+	 */
+	struct iscsi_cmnd *write_cmnd;
+	struct iovec *write_iop;
+	int write_iop_used;
+	struct iovec write_iov[2];
+	u32 write_size;
+	u32 write_offset;
+	int write_state;
+
+	/* Both don't need any protection */
+	struct file *file;
+	struct socket *sock;
+
+	void (*old_state_change)(struct sock *);
+	void (*old_data_ready)(struct sock *, int);
+	void (*old_write_space)(struct sock *);
+
+	/* Both read only. Stay here for better CPU cache locality. */
+	int hdigest_type;
+	int ddigest_type;
+
+	/* All 6 protected by iscsi_rd_lock */
+	unsigned short rd_state;
+	unsigned short rd_data_ready:1;
+	/* Let's save some cache footprint by putting them here */
+	unsigned short closing:1;
+	unsigned short active_close:1;
+	unsigned short deleting:1;
+	unsigned short conn_tm_active:1;
+
+	struct list_head rd_list_entry;
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	struct task_struct *rd_task;
+#endif
+
+	unsigned long last_rcv_time;
+
+	/*
+	 * All are unprotected, since accessed only from a single read
+	 * thread.
+	 */
+	struct iscsi_cmnd *read_cmnd;
+	struct msghdr read_msg;
+	u32 read_size;
+	int read_state;
+	struct iovec *read_iov;
+	struct task_struct *rx_task;
+	uint32_t rpadding;
+
+	struct iscsi_target *target;
+
+	struct list_head conn_list_entry; /* list entry in session conn_list */
+
+	/* All protected by target_mutex, where necessary */
+	struct iscsi_conn *conn_reinst_successor;
+	struct list_head reinst_pending_cmd_list;
+
+	wait_queue_head_t read_state_waitQ;
+	struct completion ready_to_free;
+
+	/* Doesn't need any protection */
+	u16 cid;
+
+	struct delayed_work nop_in_delayed_work;
+	unsigned int nop_in_interval; /* in jiffies */
+	struct list_head nop_req_list;
+	spinlock_t nop_req_list_lock;
+	u32 nop_in_ttt;
+
+	/* Doesn't need any protection */
+	struct kobject iscsi_conn_kobj;
+};
+
+struct iscsi_pdu {
+	struct iscsi_hdr bhs;
+	void *ahs;
+	unsigned int ahssize;
+	unsigned int datasize;
+};
+
+typedef void (iscsi_show_info_t)(struct seq_file *seq,
+				 struct iscsi_target *target);
+
+/** Commands' states **/
+
+/* New command and SCST processes it */
+#define ISCSI_CMD_STATE_NEW		0
+
+/* SCST processes cmd after scst_rx_cmd() */
+#define ISCSI_CMD_STATE_RX_CMD		1
+
+/* The command returned from preprocessing_done() */
+#define ISCSI_CMD_STATE_AFTER_PREPROC	2
+
+/* The command is waiting for session or connection reinstatement finished */
+#define ISCSI_CMD_STATE_REINST_PENDING	3
+
+/* scst_restart_cmd() called and SCST processing it */
+#define ISCSI_CMD_STATE_RESTARTED	4
+
+/* SCST done processing */
+#define ISCSI_CMD_STATE_PROCESSED	5
+
+/* AEN processing */
+#define ISCSI_CMD_STATE_AEN		6
+
+/* Out of SCST core preliminary completed */
+#define ISCSI_CMD_STATE_OUT_OF_SCST_PRELIM_COMPL 7
+
+/*
+ * Most of the fields don't need any protection, since accessed from only a
+ * single thread, except where noted.
+ *
+ * ToDo: Eventually divide request and response structures in 2 separate
+ * structures and stop this IET-derived garbage.
+ */
+struct iscsi_cmnd {
+	struct iscsi_conn *conn;
+
+	/*
+	 * Some flags used under conn->write_list_lock, but all modified only
+	 * from single read thread or when there are no references to cmd.
+	 */
+	unsigned int hashed:1;
+	unsigned int should_close_conn:1;
+	unsigned int should_close_all_conn:1;
+	unsigned int pending:1;
+	unsigned int own_sg:1;
+	unsigned int on_write_list:1;
+	unsigned int write_processing_started:1;
+	unsigned int force_cleanup_done:1;
+	unsigned int dec_active_cmnds:1;
+	unsigned int ddigest_checked:1;
+#ifdef CONFIG_SCST_EXTRACHECKS
+	unsigned int on_rx_digest_list:1;
+	unsigned int release_called:1;
+#endif
+
+	/*
+	 * We suppose that preliminary commands completion is tested by
+	 * comparing prelim_compl_flags with 0. Otherwise, because of the
+	 * gap between setting different flags a race is possible,
+	 * like sending command in SCST core as PRELIM_COMPLETED, while it
+	 * wasn't aborted in it yet and have as the result a wrong success
+	 * status sent to the initiator.
+	 */
+#define ISCSI_CMD_ABORTED		0
+#define ISCSI_CMD_PRELIM_COMPLETED	1
+	unsigned long prelim_compl_flags;
+
+	struct list_head hash_list_entry;
+
+	/*
+	 * Unions are for readability and grepability and to save some
+	 * cache footprint.
+	 */
+
+	union {
+		/*
+		 * Used only to abort not yet sent responses. Usage in
+		 * cmnd_done() is only a side effect to have a lockless
+		 * accesss to this list from always only a single thread
+		 * at any time. So, all responses live in the parent
+		 * until it has the last reference put.
+		 */
+		struct list_head rsp_cmd_list;
+		struct list_head rsp_cmd_list_entry;
+	};
+
+	union {
+		struct list_head pending_list_entry;
+		struct list_head reinst_pending_cmd_list_entry;
+	};
+
+	union {
+		struct list_head write_list_entry;
+		struct list_head write_timeout_list_entry;
+	};
+
+	/* Both protected by conn->write_list_lock */
+	unsigned int on_write_timeout_list:1;
+	unsigned long write_start;
+
+	/*
+	 * All unprotected, since could be accessed from only a single
+	 * thread at time
+	 */
+	struct iscsi_cmnd *parent_req;
+	struct iscsi_cmnd *cmd_req;
+
+	/*
+	 * All unprotected, since could be accessed from only a single
+	 * thread at time
+	 */
+	union {
+		/* Request only fields */
+		struct {
+			struct list_head rx_ddigest_cmd_list;
+			struct list_head rx_ddigest_cmd_list_entry;
+
+			int scst_state;
+			union {
+				struct scst_cmd *scst_cmd;
+				struct scst_aen *scst_aen;
+			};
+			unsigned int read_size;
+
+			struct iscsi_cmnd *main_rsp;
+		};
+
+		/* Response only fields */
+		struct {
+			struct scatterlist rsp_sg[2];
+			struct iscsi_sense_data sense_hdr;
+		};
+	};
+
+	atomic_t ref_cnt;
+
+	struct iscsi_pdu pdu;
+
+	struct scatterlist *sg;
+	int sg_cnt;
+	unsigned int bufflen;
+	u32 r2t_sn;
+	unsigned int r2t_len_to_receive;
+	unsigned int r2t_len_to_send;
+	unsigned int outstanding_r2t;
+	u32 target_task_tag;
+	u32 hdigest;
+	u32 ddigest;
+
+	struct list_head cmd_list_entry;
+	struct list_head nop_req_list_entry;
+};
+
+/* Max time to wait for our response satisfied for aborted commands */
+#define ISCSI_TM_DATA_WAIT_TIMEOUT	(10 * HZ)
+
+/*
+ * Needed addition to all timeouts to complete a burst of commands at once.
+ * Otherwise, a part of the burst can be timeouted only in double timeout time.
+ */
+#define ISCSI_ADD_SCHED_TIME		HZ
+
+#define ISCSI_CTR_OPEN_STATE_CLOSED	0
+#define ISCSI_CTR_OPEN_STATE_OPEN	1
+#define ISCSI_CTR_OPEN_STATE_CLOSING	2
+
+extern struct mutex target_mgmt_mutex;
+
+extern int ctr_open_state;
+extern const struct file_operations ctr_fops;
+
+extern spinlock_t iscsi_rd_lock;
+extern struct list_head iscsi_rd_list;
+extern wait_queue_head_t iscsi_rd_waitQ;
+
+extern spinlock_t iscsi_wr_lock;
+extern struct list_head iscsi_wr_list;
+extern wait_queue_head_t iscsi_wr_waitQ;
+
+/* iscsi.c */
+extern struct iscsi_cmnd *cmnd_alloc(struct iscsi_conn *,
+	struct iscsi_cmnd *parent);
+extern int cmnd_rx_start(struct iscsi_cmnd *);
+extern int cmnd_rx_continue(struct iscsi_cmnd *req);
+extern void cmnd_rx_end(struct iscsi_cmnd *);
+extern void cmnd_tx_start(struct iscsi_cmnd *);
+extern void cmnd_tx_end(struct iscsi_cmnd *);
+extern void req_cmnd_release_force(struct iscsi_cmnd *req);
+extern void rsp_cmnd_release(struct iscsi_cmnd *);
+extern void cmnd_done(struct iscsi_cmnd *cmnd);
+extern void conn_abort(struct iscsi_conn *conn);
+extern void iscsi_restart_cmnd(struct iscsi_cmnd *cmnd);
+extern void iscsi_fail_data_waiting_cmnd(struct iscsi_cmnd *cmnd);
+extern void iscsi_send_nop_in(struct iscsi_conn *conn);
+
+/* conn.c */
+extern struct iscsi_conn *conn_lookup(struct iscsi_session *, u16);
+extern void conn_reinst_finished(struct iscsi_conn *);
+extern int __add_conn(struct iscsi_session *, struct iscsi_kern_conn_info *);
+extern int __del_conn(struct iscsi_session *, struct iscsi_kern_conn_info *);
+extern void iscsi_make_conn_rd_active(struct iscsi_conn *conn);
+#define ISCSI_CONN_ACTIVE_CLOSE		1
+#define ISCSI_CONN_DELETING		2
+extern void __mark_conn_closed(struct iscsi_conn *, int);
+extern void mark_conn_closed(struct iscsi_conn *);
+extern void iscsi_make_conn_wr_active(struct iscsi_conn *);
+extern void iscsi_check_tm_data_wait_timeouts(struct iscsi_conn *conn,
+	bool force);
+
+/* nthread.c */
+extern int iscsi_send(struct iscsi_conn *conn);
+extern int istrd(void *arg);
+extern int istwr(void *arg);
+extern void iscsi_task_mgmt_affected_cmds_done(struct scst_mgmt_cmd *scst_mcmd);
+extern void req_add_to_write_timeout_list(struct iscsi_cmnd *req);
+
+/* target.c */
+extern const struct attribute *iscsi_tgt_attrs[];
+extern int iscsi_enable_target(struct scst_tgt *scst_tgt, bool enable);
+extern bool iscsi_is_target_enabled(struct scst_tgt *scst_tgt);
+extern ssize_t iscsi_sysfs_send_event(uint32_t tid,
+	enum iscsi_kern_event_code code,
+	const char *param1, const char *param2, void **data);
+extern struct iscsi_target *target_lookup_by_id(u32);
+extern int __add_target(struct iscsi_kern_target_info *);
+extern int __del_target(u32 id);
+extern ssize_t iscsi_sysfs_add_target(const char *target_name, char *params);
+extern ssize_t iscsi_sysfs_del_target(const char *target_name);
+extern ssize_t iscsi_sysfs_mgmt_cmd(char *cmd);
+extern void target_del_session(struct iscsi_target *target,
+	struct iscsi_session *session, int flags);
+extern void target_del_all_sess(struct iscsi_target *target, int flags);
+extern void target_del_all(void);
+
+/* config.c */
+extern const struct attribute *iscsi_attrs[];
+extern int iscsi_add_attr(struct iscsi_target *target,
+	const struct iscsi_kern_attr *user_info);
+extern void __iscsi_del_attr(struct iscsi_target *target,
+	struct iscsi_attr *tgt_attr);
+
+/* session.c */
+extern const struct attribute *iscsi_sess_attrs[];
+extern const struct file_operations session_seq_fops;
+extern struct iscsi_session *session_lookup(struct iscsi_target *, u64);
+extern void sess_reinst_finished(struct iscsi_session *);
+extern int __add_session(struct iscsi_target *,
+	struct iscsi_kern_session_info *);
+extern int __del_session(struct iscsi_target *, u64);
+extern int session_free(struct iscsi_session *session, bool del);
+
+/* params.c */
+extern const char *iscsi_get_digest_name(int val, char *res);
+extern const char *iscsi_get_bool_value(int val);
+extern int iscsi_params_set(struct iscsi_target *,
+	struct iscsi_kern_params_info *, int);
+
+/* event.c */
+extern int event_send(u32, u64, u32, u32, enum iscsi_kern_event_code,
+	const char *param1, const char *param2);
+extern int event_init(void);
+extern void event_exit(void);
+
+#define get_pgcnt(size, offset)	\
+	((((size) + ((offset) & ~PAGE_MASK)) + PAGE_SIZE - 1) >> PAGE_SHIFT)
+
+static inline void iscsi_cmnd_get_length(struct iscsi_pdu *pdu)
+{
+#if defined(__BIG_ENDIAN)
+	pdu->ahssize = pdu->bhs.length.ahslength * 4;
+	pdu->datasize = pdu->bhs.length.datalength;
+#elif defined(__LITTLE_ENDIAN)
+	pdu->ahssize = (pdu->bhs.length & 0xff) * 4;
+	pdu->datasize = be32_to_cpu(pdu->bhs.length & ~0xff);
+#else
+#error
+#endif
+}
+
+static inline void iscsi_cmnd_set_length(struct iscsi_pdu *pdu)
+{
+#if defined(__BIG_ENDIAN)
+	pdu->bhs.length.ahslength = pdu->ahssize / 4;
+	pdu->bhs.length.datalength = pdu->datasize;
+#elif defined(__LITTLE_ENDIAN)
+	pdu->bhs.length = cpu_to_be32(pdu->datasize) | (pdu->ahssize / 4);
+#else
+#error
+#endif
+}
+
+extern struct scst_tgt_template iscsi_template;
+
+/*
+ * Skip this command if result is not 0. Must be called under
+ * corresponding lock.
+ */
+static inline bool cmnd_get_check(struct iscsi_cmnd *cmnd)
+{
+	int r = atomic_inc_return(&cmnd->ref_cnt);
+	int res;
+	if (unlikely(r == 1)) {
+		TRACE_DBG("cmnd %p is being destroyed", cmnd);
+		atomic_dec(&cmnd->ref_cnt);
+		res = 1;
+		/* Necessary code is serialized by locks in cmnd_done() */
+	} else {
+		TRACE_DBG("cmnd %p, new ref_cnt %d", cmnd,
+			atomic_read(&cmnd->ref_cnt));
+		res = 0;
+	}
+	return res;
+}
+
+static inline void cmnd_get(struct iscsi_cmnd *cmnd)
+{
+	atomic_inc(&cmnd->ref_cnt);
+	TRACE_DBG("cmnd %p, new cmnd->ref_cnt %d", cmnd,
+		atomic_read(&cmnd->ref_cnt));
+}
+
+static inline void cmnd_get_ordered(struct iscsi_cmnd *cmnd)
+{
+	cmnd_get(cmnd);
+	/* See comments for each cmnd_get_ordered() use */
+	smp_mb__after_atomic_inc();
+}
+
+static inline void cmnd_put(struct iscsi_cmnd *cmnd)
+{
+	TRACE_DBG("cmnd %p, new ref_cnt %d", cmnd,
+		atomic_read(&cmnd->ref_cnt)-1);
+
+	EXTRACHECKS_BUG_ON(atomic_read(&cmnd->ref_cnt) == 0);
+
+	if (atomic_dec_and_test(&cmnd->ref_cnt))
+		cmnd_done(cmnd);
+}
+
+/* conn->write_list_lock supposed to be locked and BHs off */
+static inline void cmd_add_on_write_list(struct iscsi_conn *conn,
+	struct iscsi_cmnd *cmnd)
+{
+	TRACE_DBG("cmnd %p", cmnd);
+	/* See comment in iscsi_restart_cmnd() */
+	EXTRACHECKS_BUG_ON(cmnd->parent_req->hashed &&
+		(cmnd_opcode(cmnd) != ISCSI_OP_R2T));
+	list_add_tail(&cmnd->write_list_entry, &conn->write_list);
+	cmnd->on_write_list = 1;
+}
+
+/* conn->write_list_lock supposed to be locked and BHs off */
+static inline void cmd_del_from_write_list(struct iscsi_cmnd *cmnd)
+{
+	TRACE_DBG("%p", cmnd);
+	list_del(&cmnd->write_list_entry);
+	cmnd->on_write_list = 0;
+}
+
+static inline void cmd_add_on_rx_ddigest_list(struct iscsi_cmnd *req,
+	struct iscsi_cmnd *cmnd)
+{
+	TRACE_DBG("Adding RX ddigest cmd %p to digest list "
+			"of req %p", cmnd, req);
+	list_add_tail(&cmnd->rx_ddigest_cmd_list_entry,
+			&req->rx_ddigest_cmd_list);
+#ifdef CONFIG_SCST_EXTRACHECKS
+	cmnd->on_rx_digest_list = 1;
+#endif
+}
+
+static inline void cmd_del_from_rx_ddigest_list(struct iscsi_cmnd *cmnd)
+{
+	TRACE_DBG("Deleting RX digest cmd %p from digest list", cmnd);
+	list_del(&cmnd->rx_ddigest_cmd_list_entry);
+#ifdef CONFIG_SCST_EXTRACHECKS
+	cmnd->on_rx_digest_list = 0;
+#endif
+}
+
+static inline int test_write_ready(struct iscsi_conn *conn)
+{
+	/*
+	 * No need for write_list protection, in the worst case we will be
+	 * restarted again.
+	 */
+	return !list_empty(&conn->write_list) || conn->write_cmnd;
+}
+
+static inline void conn_get(struct iscsi_conn *conn)
+{
+	atomic_inc(&conn->conn_ref_cnt);
+	TRACE_DBG("conn %p, new conn_ref_cnt %d", conn,
+		atomic_read(&conn->conn_ref_cnt));
+}
+
+static inline void conn_get_ordered(struct iscsi_conn *conn)
+{
+	conn_get(conn);
+	/* See comments for each conn_get_ordered() use */
+	smp_mb__after_atomic_inc();
+}
+
+static inline void conn_put(struct iscsi_conn *conn)
+{
+	TRACE_DBG("conn %p, new conn_ref_cnt %d", conn,
+		atomic_read(&conn->conn_ref_cnt)-1);
+	BUG_ON(atomic_read(&conn->conn_ref_cnt) == 0);
+
+	/*
+	 * Make it always ordered to protect from undesired side effects like
+	 * accessing just destroyed by close_conn() conn caused by reordering
+	 * of this atomic_dec().
+	 */
+	smp_mb__before_atomic_dec();
+	atomic_dec(&conn->conn_ref_cnt);
+}
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+extern void iscsi_extracheck_is_rd_thread(struct iscsi_conn *conn);
+extern void iscsi_extracheck_is_wr_thread(struct iscsi_conn *conn);
+#else
+static inline void iscsi_extracheck_is_rd_thread(struct iscsi_conn *conn) {}
+static inline void iscsi_extracheck_is_wr_thread(struct iscsi_conn *conn) {}
+#endif
+
+#endif	/* __ISCSI_H__ */
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi_hdr.h linux-2.6.33/drivers/scst/iscsi-scst/iscsi_hdr.h
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi_hdr.h
+++ linux-2.6.33/drivers/scst/iscsi-scst/iscsi_hdr.h
@@ -0,0 +1,519 @@
+/*
+ *  Copyright (C) 2002 - 2003 Ardis Technolgies <roman@ardistech.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef __ISCSI_HDR_H__
+#define __ISCSI_HDR_H__
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#define ISCSI_VERSION			0
+
+#ifndef __packed
+#define __packed __attribute__ ((packed))
+#endif
+
+struct iscsi_hdr {
+	u8  opcode;			/* 0 */
+	u8  flags;
+	u8  spec1[2];
+#if defined(__BIG_ENDIAN_BITFIELD)
+	struct {			/* 4 */
+		unsigned ahslength:8;
+		unsigned datalength:24;
+	} length;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u32 length;			/* 4 */
+#endif
+	u64 lun;			/* 8 */
+	u32 itt;			/* 16 */
+	u32 ttt;			/* 20 */
+	u32 sn;				/* 24 */
+	u32 exp_sn;			/* 28 */
+	u32 max_sn;			/* 32 */
+	u32 spec3[3];			/* 36 */
+} __packed;				/* 48 */
+
+/* Opcode encoding bits */
+#define ISCSI_OP_RETRY			0x80
+#define ISCSI_OP_IMMEDIATE		0x40
+#define ISCSI_OPCODE_MASK		0x3F
+
+/* Client to Server Message Opcode values */
+#define ISCSI_OP_NOP_OUT		0x00
+#define ISCSI_OP_SCSI_CMD		0x01
+#define ISCSI_OP_SCSI_TASK_MGT_MSG	0x02
+#define ISCSI_OP_LOGIN_CMD		0x03
+#define ISCSI_OP_TEXT_CMD		0x04
+#define ISCSI_OP_SCSI_DATA_OUT		0x05
+#define ISCSI_OP_LOGOUT_CMD		0x06
+#define ISCSI_OP_SNACK_CMD		0x10
+
+/* Server to Client Message Opcode values */
+#define ISCSI_OP_NOP_IN			0x20
+#define ISCSI_OP_SCSI_RSP		0x21
+#define ISCSI_OP_SCSI_TASK_MGT_RSP	0x22
+#define ISCSI_OP_LOGIN_RSP		0x23
+#define ISCSI_OP_TEXT_RSP		0x24
+#define ISCSI_OP_SCSI_DATA_IN		0x25
+#define ISCSI_OP_LOGOUT_RSP		0x26
+#define ISCSI_OP_R2T			0x31
+#define ISCSI_OP_ASYNC_MSG		0x32
+#define ISCSI_OP_REJECT			0x3f
+
+struct iscsi_ahs_hdr {
+	u16 ahslength;
+	u8 ahstype;
+} __packed;
+
+#define ISCSI_AHSTYPE_CDB		1
+#define ISCSI_AHSTYPE_RLENGTH		2
+
+union iscsi_sid {
+	struct {
+		u8 isid[6];		/* Initiator Session ID */
+		u16 tsih;		/* Target Session ID */
+	} id;
+	u64 id64;
+} __packed;
+
+struct iscsi_scsi_cmd_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u64 lun;
+	u32 itt;
+	u32 data_length;
+	u32 cmd_sn;
+	u32 exp_stat_sn;
+	u8  scb[16];
+} __packed;
+
+#define ISCSI_CMD_FINAL		0x80
+#define ISCSI_CMD_READ		0x40
+#define ISCSI_CMD_WRITE		0x20
+#define ISCSI_CMD_ATTR_MASK	0x07
+#define ISCSI_CMD_UNTAGGED	0x00
+#define ISCSI_CMD_SIMPLE	0x01
+#define ISCSI_CMD_ORDERED	0x02
+#define ISCSI_CMD_HEAD_OF_QUEUE	0x03
+#define ISCSI_CMD_ACA		0x04
+
+struct iscsi_cdb_ahdr {
+	u16 ahslength;
+	u8  ahstype;
+	u8  reserved;
+	u8  cdb[0];
+} __packed;
+
+struct iscsi_rlength_ahdr {
+	u16 ahslength;
+	u8  ahstype;
+	u8  reserved;
+	u32 read_length;
+} __packed;
+
+struct iscsi_scsi_rsp_hdr {
+	u8  opcode;
+	u8  flags;
+	u8  response;
+	u8  cmd_status;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd1[2];
+	u32 itt;
+	u32 snack;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 exp_data_sn;
+	u32 bi_residual_count;
+	u32 residual_count;
+} __packed;
+
+#define ISCSI_FLG_RESIDUAL_UNDERFLOW		0x02
+#define ISCSI_FLG_RESIDUAL_OVERFLOW		0x04
+#define ISCSI_FLG_BIRESIDUAL_UNDERFLOW		0x08
+#define ISCSI_FLG_BIRESIDUAL_OVERFLOW		0x10
+
+#define ISCSI_RESPONSE_COMMAND_COMPLETED	0x00
+#define ISCSI_RESPONSE_TARGET_FAILURE		0x01
+
+struct iscsi_sense_data {
+	u16 length;
+	u8  data[0];
+} __packed;
+
+struct iscsi_task_mgt_hdr {
+	u8  opcode;
+	u8  function;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u64 lun;
+	u32 itt;
+	u32 rtt;
+	u32 cmd_sn;
+	u32 exp_stat_sn;
+	u32 ref_cmd_sn;
+	u32 exp_data_sn;
+	u32 rsvd2[2];
+} __packed;
+
+#define ISCSI_FUNCTION_MASK			0x7f
+
+#define ISCSI_FUNCTION_ABORT_TASK		1
+#define ISCSI_FUNCTION_ABORT_TASK_SET		2
+#define ISCSI_FUNCTION_CLEAR_ACA		3
+#define ISCSI_FUNCTION_CLEAR_TASK_SET		4
+#define ISCSI_FUNCTION_LOGICAL_UNIT_RESET	5
+#define ISCSI_FUNCTION_TARGET_WARM_RESET	6
+#define ISCSI_FUNCTION_TARGET_COLD_RESET	7
+#define ISCSI_FUNCTION_TASK_REASSIGN		8
+
+struct iscsi_task_rsp_hdr {
+	u8  opcode;
+	u8  flags;
+	u8  response;
+	u8  rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 itt;
+	u32 rsvd3;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 rsvd4[3];
+} __packed;
+
+#define ISCSI_RESPONSE_FUNCTION_COMPLETE	0
+#define ISCSI_RESPONSE_UNKNOWN_TASK		1
+#define ISCSI_RESPONSE_UNKNOWN_LUN		2
+#define ISCSI_RESPONSE_TASK_ALLEGIANT		3
+#define ISCSI_RESPONSE_ALLEGIANCE_REASSIGNMENT_UNSUPPORTED	4
+#define ISCSI_RESPONSE_FUNCTION_UNSUPPORTED	5
+#define ISCSI_RESPONSE_NO_AUTHORIZATION		6
+#define ISCSI_RESPONSE_FUNCTION_REJECTED	255
+
+struct iscsi_data_out_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u64 lun;
+	u32 itt;
+	u32 ttt;
+	u32 rsvd2;
+	u32 exp_stat_sn;
+	u32 rsvd3;
+	u32 data_sn;
+	u32 buffer_offset;
+	u32 rsvd4;
+} __packed;
+
+struct iscsi_data_in_hdr {
+	u8  opcode;
+	u8  flags;
+	u8  rsvd1;
+	u8  cmd_status;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 itt;
+	u32 ttt;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 data_sn;
+	u32 buffer_offset;
+	u32 residual_count;
+} __packed;
+
+#define ISCSI_FLG_STATUS		0x01
+
+struct iscsi_r2t_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u64 lun;
+	u32 itt;
+	u32 ttt;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 r2t_sn;
+	u32 buffer_offset;
+	u32 data_length;
+} __packed;
+
+struct iscsi_async_msg_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u64 lun;
+	u32 ffffffff;
+	u32 rsvd2;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u8  async_event;
+	u8  async_vcode;
+	u16 param1;
+	u16 param2;
+	u16 param3;
+	u32 rsvd3;
+} __packed;
+
+#define ISCSI_ASYNC_SCSI		0
+#define ISCSI_ASYNC_LOGOUT		1
+#define ISCSI_ASYNC_DROP_CONNECTION	2
+#define ISCSI_ASYNC_DROP_SESSION	3
+#define ISCSI_ASYNC_PARAM_REQUEST	4
+#define ISCSI_ASYNC_VENDOR		255
+
+struct iscsi_text_req_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 itt;
+	u32 ttt;
+	u32 cmd_sn;
+	u32 exp_stat_sn;
+	u32 rsvd3[4];
+} __packed;
+
+struct iscsi_text_rsp_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 itt;
+	u32 ttt;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 rsvd3[3];
+} __packed;
+
+struct iscsi_login_req_hdr {
+	u8  opcode;
+	u8  flags;
+	u8  max_version;		/* Max. version supported */
+	u8  min_version;		/* Min. version supported */
+	u8  ahslength;
+	u8  datalength[3];
+	union iscsi_sid sid;
+	u32 itt;			/* Initiator Task Tag */
+	u16 cid;			/* Connection ID */
+	u16 rsvd1;
+	u32 cmd_sn;
+	u32 exp_stat_sn;
+	u32 rsvd2[4];
+} __packed;
+
+struct iscsi_login_rsp_hdr {
+	u8  opcode;
+	u8  flags;
+	u8  max_version;		/* Max. version supported */
+	u8  active_version;		/* Active version */
+	u8  ahslength;
+	u8  datalength[3];
+	union iscsi_sid sid;
+	u32 itt;			/* Initiator Task Tag */
+	u32 rsvd1;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u8  status_class;		/* see Login RSP Status classes below */
+	u8  status_detail;		/* see Login RSP Status details below */
+	u8  rsvd2[10];
+} __packed;
+
+#define ISCSI_FLG_FINAL			0x80
+#define ISCSI_FLG_TRANSIT		0x80
+#define ISCSI_FLG_CSG_SECURITY		0x00
+#define ISCSI_FLG_CSG_LOGIN		0x04
+#define ISCSI_FLG_CSG_FULL_FEATURE	0x0c
+#define ISCSI_FLG_CSG_MASK		0x0c
+#define ISCSI_FLG_NSG_SECURITY		0x00
+#define ISCSI_FLG_NSG_LOGIN		0x01
+#define ISCSI_FLG_NSG_FULL_FEATURE	0x03
+#define ISCSI_FLG_NSG_MASK		0x03
+
+/* Login Status response classes */
+#define ISCSI_STATUS_SUCCESS		0x00
+#define ISCSI_STATUS_REDIRECT		0x01
+#define ISCSI_STATUS_INITIATOR_ERR	0x02
+#define ISCSI_STATUS_TARGET_ERR		0x03
+
+/* Login Status response detail codes */
+/* Class-0 (Success) */
+#define ISCSI_STATUS_ACCEPT		0x00
+
+/* Class-1 (Redirection) */
+#define ISCSI_STATUS_TGT_MOVED_TEMP	0x01
+#define ISCSI_STATUS_TGT_MOVED_PERM	0x02
+
+/* Class-2 (Initiator Error) */
+#define ISCSI_STATUS_INIT_ERR		0x00
+#define ISCSI_STATUS_AUTH_FAILED	0x01
+#define ISCSI_STATUS_TGT_FORBIDDEN	0x02
+#define ISCSI_STATUS_TGT_NOT_FOUND	0x03
+#define ISCSI_STATUS_TGT_REMOVED	0x04
+#define ISCSI_STATUS_NO_VERSION		0x05
+#define ISCSI_STATUS_TOO_MANY_CONN	0x06
+#define ISCSI_STATUS_MISSING_FIELDS	0x07
+#define ISCSI_STATUS_CONN_ADD_FAILED	0x08
+#define ISCSI_STATUS_INV_SESSION_TYPE	0x09
+#define ISCSI_STATUS_SESSION_NOT_FOUND	0x0a
+#define ISCSI_STATUS_INV_REQ_TYPE	0x0b
+
+/* Class-3 (Target Error) */
+#define ISCSI_STATUS_TARGET_ERROR	0x00
+#define ISCSI_STATUS_SVC_UNAVAILABLE	0x01
+#define ISCSI_STATUS_NO_RESOURCES	0x02
+
+struct iscsi_logout_req_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 itt;
+	u16 cid;
+	u16 rsvd3;
+	u32 cmd_sn;
+	u32 exp_stat_sn;
+	u32 rsvd4[4];
+} __packed;
+
+struct iscsi_logout_rsp_hdr {
+	u8  opcode;
+	u8  flags;
+	u8  response;
+	u8  rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 itt;
+	u32 rsvd3;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 rsvd4;
+	u16 time2wait;
+	u16 time2retain;
+	u32 rsvd5;
+} __packed;
+
+struct iscsi_snack_req_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 itt;
+	u32 ttt;
+	u32 rsvd3;
+	u32 exp_stat_sn;
+	u32 rsvd4[2];
+	u32 beg_run;
+	u32 run_length;
+} __packed;
+
+struct iscsi_reject_hdr {
+	u8  opcode;
+	u8  flags;
+	u8  reason;
+	u8  rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u32 rsvd2[2];
+	u32 ffffffff;
+	u32 rsvd3;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 data_sn;
+	u32 rsvd4[2];
+} __packed;
+
+#define ISCSI_REASON_RESERVED			0x01
+#define ISCSI_REASON_DATA_DIGEST_ERROR		0x02
+#define ISCSI_REASON_DATA_SNACK_REJECT		0x03
+#define ISCSI_REASON_PROTOCOL_ERROR		0x04
+#define ISCSI_REASON_UNSUPPORTED_COMMAND	0x05
+#define ISCSI_REASON_IMMEDIATE_COMMAND_REJECT	0x06
+#define ISCSI_REASON_TASK_IN_PROGRESS		0x07
+#define ISCSI_REASON_INVALID_DATA_ACK		0x08
+#define ISCSI_REASON_INVALID_PDU_FIELD		0x09
+#define ISCSI_REASON_OUT_OF_RESOURCES		0x0a
+#define ISCSI_REASON_NEGOTIATION_RESET		0x0b
+#define ISCSI_REASON_WAITING_LOGOUT		0x0c
+
+struct iscsi_nop_out_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u64 lun;
+	u32 itt;
+	u32 ttt;
+	u32 cmd_sn;
+	u32 exp_stat_sn;
+	u32 rsvd2[4];
+} __packed;
+
+struct iscsi_nop_in_hdr {
+	u8  opcode;
+	u8  flags;
+	u16 rsvd1;
+	u8  ahslength;
+	u8  datalength[3];
+	u64 lun;
+	u32 itt;
+	u32 ttt;
+	u32 stat_sn;
+	u32 exp_cmd_sn;
+	u32 max_cmd_sn;
+	u32 rsvd2[3];
+} __packed;
+
+#define ISCSI_RESERVED_TAG	(0xffffffffU)
+
+#define cmnd_hdr(cmnd) ((struct iscsi_scsi_cmd_hdr *) (&((cmnd)->pdu.bhs)))
+#define cmnd_itt(cmnd) cpu_to_be32((cmnd)->pdu.bhs.itt)
+#define cmnd_ttt(cmnd) cpu_to_be32((cmnd)->pdu.bhs.ttt)
+#define cmnd_opcode(cmnd) ((cmnd)->pdu.bhs.opcode & ISCSI_OPCODE_MASK)
+#define cmnd_scsicode(cmnd) (cmnd_hdr((cmnd))->scb[0])
+
+#endif	/* __ISCSI_HDR_H__ */
diff -uprN orig/linux-2.6.33/include/scst/iscsi_scst_itf_ver.h linux-2.6.33/include/scst/iscsi_scst_itf_ver.h
--- orig/linux-2.6.33/include/scst/iscsi_scst_itf_ver.h
+++ linux-2.6.33/include/scst/iscsi_scst_itf_ver.h
@@ -0,0 +1,2 @@
+#define ISCSI_SCST_INTERFACE_VERSION "0b9736e7abc6440bb842a800ec0552ae5388b0ef"
+

