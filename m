From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 15:01:44 -0800
Message-ID: <41E30958.5060309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010100000206020104080303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:65243 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262748AbVAJXBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 18:01:53 -0500
Received: from [192.168.1.7] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j0AN1nXO024988
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 17:01:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010100000206020104080303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch implememts the IO functions for
the driver. They are built upon the network
subsystem's socket functions, so any ideas about
how to handle OOM situations when using that
layer would be greatly appreciated.

--------------010100000206020104080303
Content-Type: text/x-patch;
 name="06-core-io.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06-core-io.patch"

diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-network.c scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-network.c
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-network.c	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-network.c	2005-01-10 13:26:56.460931634 -0800
@@ -0,0 +1,263 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2001 Cisco Systems, Inc.
+ * Copyright (C) 2004 Mike Christie
+ * Copyright (C) 2004 IBM Corporation
+ * maintained by linux-iscsi-devel@lists.sourceforge.net
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ *
+ * Contains functions to handle socket operations
+ */
+#include <linux/tcp.h>
+#include <linux/uio.h>
+
+#include "iscsi-session.h"
+#include "iscsi-sfnet.h"
+
+/*
+ * decode common network errno values into more useful strings.
+ * strerror would be nice right about now.
+ */
+static char *
+iscsi_strerror(int errno)
+{
+	switch (errno) {
+	case EIO:
+		return "I/O error";
+	case EINTR:
+		return "Interrupted system call";
+	case ENXIO:
+		return "No such device or address";
+	case EFAULT:
+		return "Bad address";
+	case EBUSY:
+		return "Device or resource busy";
+	case EINVAL:
+		return "Invalid argument";
+	case EPIPE:
+		return "Broken pipe";
+	case ENONET:
+		return "Machine is not on the network";
+	case ECOMM:
+		return "Communication error on send";
+	case EPROTO:
+		return "Protocol error";
+	case ENOTUNIQ:
+		return "Name not unique on network";
+	case ENOTSOCK:
+		return "Socket operation on non-socket";
+	case ENETDOWN:
+		return "Network is down";
+	case ENETUNREACH:
+		return "Network is unreachable";
+	case ENETRESET:
+		return "Network dropped connection because of reset";
+	case ECONNABORTED:
+		return "Software caused connection abort";
+	case ECONNRESET:
+		return "Connection reset by peer";
+	case ESHUTDOWN:
+		return "Cannot send after shutdown";
+	case ETIMEDOUT:
+		return "Connection timed out";
+	case ECONNREFUSED:
+		return "Connection refused";
+	case EHOSTDOWN:
+		return "Host is down";
+	case EHOSTUNREACH:
+		return "No route to host";
+	default:
+		return "";
+	}
+}
+
+/* create and connect a new socket for this session */
+int
+iscsi_connect(struct iscsi_session *session)
+{
+	mm_segment_t oldfs;
+	struct socket *socket;
+	int arg = 1;
+	int rc;
+
+	if (session->socket)
+		return 0;
+
+	oldfs = get_fs();
+	set_fs(get_ds());
+
+	rc = sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &socket);
+	if (rc < 0) {
+		iscsi_host_err(session, "Failed to create socket, rc %d\n", rc);
+		set_fs(oldfs);
+		return rc;
+	}
+
+	session->socket = socket;
+	socket->sk->sk_allocation = GFP_ATOMIC;
+
+	/* no delay in sending */
+	rc = socket->ops->setsockopt(socket, IPPROTO_TCP, TCP_NODELAY,
+				     (char *)&arg, sizeof(arg));
+	if (rc) {
+		iscsi_host_err(session, "Failed to setsockopt TCP_NODELAY, rc "
+			       "%d\n", rc);
+		goto done;
+	}
+
+	if (session->tcp_window_size) {
+		/*
+		 * Should we be accessing the sk_recv/send_buf directly like
+		 * NFS (sock_setsockopt will be bounded by the sysctl limits)?
+		 */
+		sock_setsockopt(socket, SOL_SOCKET, SO_RCVBUF,
+			        (char *)&session->tcp_window_size,
+				sizeof(session->tcp_window_size));
+		sock_setsockopt(socket, SOL_SOCKET, SO_SNDBUF,
+			        (char *)&session->tcp_window_size,
+				sizeof(session->tcp_window_size));
+	}
+
+	rc = socket->ops->connect(socket, &session->addr,
+				  sizeof(struct sockaddr), 0);
+ done:
+	if (rc) {
+		if (signal_pending(current))
+			iscsi_host_err(session, "Connect failed due to "
+				       "driver timeout\n");
+		else
+			iscsi_host_err(session, "Connect failed with rc %d: "
+				       "%s\n", rc, iscsi_strerror(-rc));
+		sock_release(socket);
+		session->socket = NULL;
+	}
+
+	smp_mb();
+	set_fs(oldfs);
+	return rc;
+}
+
+void
+iscsi_disconnect(struct iscsi_session *session)
+{
+	if (session->socket) {
+		sock_release(session->socket);
+		session->socket = NULL;
+		smp_mb();
+	}
+}
+
+/**
+ * iscsi_sendpage - Transmit data using sock->ops->sendpage
+ * @session: iscsi_session to the target
+ * @flags: MSG_MORE or 0
+ * @pg: page to send
+ * @pg_offset: offset in page
+ * @len: length of the data to be transmitted.
+ **/
+int
+iscsi_sendpage(struct iscsi_session *session, int flags, struct page *pg,
+	       unsigned int pg_offset, unsigned int len)
+{
+	struct socket *sock = session->socket;
+	int rc;
+
+	rc = sock->ops->sendpage(sock, pg, pg_offset, len, flags);
+	if (signal_pending(current))
+		return ISCSI_IO_INTR;
+	else if (rc != len) {
+		if (rc == 0)
+			iscsi_host_err(session, "iscsi_sendpage() failed due "
+				       "to connection closed by target\n");
+		else if (rc < 0)
+			iscsi_host_err(session, "iscsi_sendpage() failed with "
+				       "rc %d: %s\n", rc, iscsi_strerror(-rc));
+		else
+			iscsi_host_err(session, "iscsi_sendpage() failed due "
+				       "to short write of %d of %u\n", rc,
+				       len);
+		return ISCSI_IO_ERR;
+	}
+
+	return ISCSI_IO_SUCCESS;
+}
+
+/**
+ * iscsi_send/recvmsg - recv or send a iSCSI PDU, or portion thereof
+ * @session: iscsi session
+ * @iov: contains list of buffers to receive data in
+ * @iovn: number of buffers in IO vec
+ * @size: total size of data to be received
+ *
+ * Note:
+ *    tcp_*msg() might be interrupted because we got
+ *    sent a signal, e.g. SIGHUP from iscsi_drop_session().  In
+ *    this case, we most likely did not receive all the data, and
+ *    we should just bail out.  No need to log any message since
+ *    this is expected behavior.
+ **/
+int
+iscsi_recvmsg(struct iscsi_session *session, struct kvec *iov, size_t iovn,
+	      size_t size)
+{
+	struct msghdr msg;
+	int rc;
+	
+	memset(&msg, 0, sizeof(msg));
+	rc = kernel_recvmsg(session->socket, &msg, iov, iovn, size,
+			    MSG_WAITALL);
+	if (signal_pending(current))
+		return ISCSI_IO_INTR;
+	else if (rc != size) {
+		if (rc == 0)
+			iscsi_host_err(session, "iscsi_recvmsg() failed due "
+				       "to connection closed by target\n");
+		else if (rc < 0)
+			iscsi_host_err(session, "iscsi_recvmsg() failed with "
+				       "rc %d: %s\n", rc, iscsi_strerror(-rc));
+		else
+			iscsi_host_err(session, "iscsi_recvmsg() failed due "
+				       "to short read of %d\n", rc);
+		return ISCSI_IO_ERR;
+	}
+
+	return ISCSI_IO_SUCCESS;
+}
+
+int
+iscsi_sendmsg(struct iscsi_session *session, struct kvec *iov, size_t iovn,
+	      size_t size)
+{
+	struct msghdr msg;
+	int rc;
+
+	memset(&msg, 0, sizeof(msg));
+	rc = kernel_sendmsg(session->socket, &msg, iov, iovn, size);
+	if (signal_pending(current))
+		return ISCSI_IO_INTR;
+	else if (rc != size) {
+		if (rc == 0)
+			iscsi_host_err(session, "iscsi_sendmsg() failed due "
+				       "to connection closed by target\n");
+		else if (rc < 0)
+			iscsi_host_err(session, "iscsi_sendmsg() failed with "
+				       "rc %d: %s\n", rc, iscsi_strerror(-rc));
+		else
+			iscsi_host_err(session, "iscsi_sendmsg() failed due "
+				       "to short write of %d\n", rc);
+		return ISCSI_IO_ERR;
+	}
+
+	return ISCSI_IO_SUCCESS;
+}
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-recv-pdu.c scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-recv-pdu.c
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-recv-pdu.c	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-recv-pdu.c	2005-01-10 13:26:56.516924452 -0800
@@ -0,0 +1,1000 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2001 Cisco Systems, Inc.
+ * Copyright (C) 2004 Mike Christie
+ * Copyright (C) 2004 IBM Corporation
+ * maintained by linux-iscsi-devel@lists.sourceforge.net
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ *
+ * All the incoming iSCSI PDUs are processed by functions
+ * defined here.
+ */
+#include <linux/blkdev.h>
+#include <linux/scatterlist.h>
+#include <linux/tcp.h>
+#include <linux/net.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
+
+#include "iscsi-session.h"
+#include "iscsi-task.h"
+#include "iscsi-protocol.h"
+#include "iscsi-login.h"
+#include "iscsi-sfnet.h"
+
+/* possibly update the ExpCmdSN and MaxCmdSN - may acquire task lock */
+static void
+update_sn(struct iscsi_session *session, u32 expcmdsn, u32 maxcmdsn)
+{
+	/*
+	 * standard specifies this check for when to update expected and
+	 * max sequence numbers
+	 */
+	if (iscsi_sna_lt(maxcmdsn, expcmdsn - 1))
+		return;
+
+	if (expcmdsn != session->exp_cmd_sn &&
+	    !iscsi_sna_lt(expcmdsn, session->exp_cmd_sn))
+		session->exp_cmd_sn = expcmdsn;
+
+	if (maxcmdsn != session->max_cmd_sn &&
+	    !iscsi_sna_lt(maxcmdsn, session->max_cmd_sn)) {
+		session->max_cmd_sn = maxcmdsn;
+		/* wake the tx thread to try sending more commands */
+		iscsi_wake_tx_thread(TX_SCSI_COMMAND, session);
+	}
+
+	/*
+	 * record whether or not the command window for this session
+	 * has closed, so that we can ping the target periodically to
+	 * ensure we eventually find out that the window has re-opened.
+	 */
+	if (maxcmdsn == expcmdsn - 1) {
+		/*
+		 * record how many times this happens, to see
+		 * how often we're getting throttled
+		 */
+		session->window_closed++;
+		/*
+		 * prepare to poll the target to see if
+		 * the window has reopened
+		 */
+		spin_lock_bh(&session->task_lock);
+		iscsi_mod_session_timer(session, 5);
+		set_bit(SESSION_WINDOW_CLOSED, &session->control_bits);
+		spin_unlock_bh(&session->task_lock);
+	} else if (test_bit(SESSION_WINDOW_CLOSED, &session->control_bits))
+		clear_bit(SESSION_WINDOW_CLOSED, &session->control_bits);
+}
+
+static int
+iscsi_recv_header(struct iscsi_session *session, struct iscsi_hdr *sth,
+		 int digest)
+{
+	struct scatterlist sg;
+	struct kvec iov[2];
+	int length, rc;
+	u32 recvd_crc32c, hdr_crc32c;
+	u8 iovn = 0;
+
+	iov[iovn].iov_base = sth;
+	iov[iovn].iov_len = length = sizeof(*sth);
+	iovn++;
+	if (digest == ISCSI_DIGEST_CRC32C) {
+		iov[iovn].iov_base = &recvd_crc32c;
+		iov[iovn].iov_len = sizeof(recvd_crc32c);
+		iovn++;
+		length += sizeof(recvd_crc32c);
+	}
+
+	rc = iscsi_recvmsg(session, iov, iovn, length);
+	if (rc != ISCSI_IO_SUCCESS)
+		return rc;
+
+	if (digest == ISCSI_DIGEST_CRC32C) {
+		crypto_digest_init(session->rx_tfm);
+		sg_init_one(&sg, (u8 *)sth, sizeof(*sth));
+		crypto_digest_digest(session->rx_tfm, &sg, 1,
+				     (u8*)&hdr_crc32c);
+		if (recvd_crc32c != hdr_crc32c) {
+			iscsi_host_err(session, "HeaderDigest mismatch, "
+				       "received 0x%08x, calculated 0x%08x, "
+				       "dropping session\n", recvd_crc32c,
+				       hdr_crc32c);
+			return ISCSI_IO_CRC32C_ERR;
+		}
+	}
+
+	/* connection is ok */
+	session->last_rx = jiffies;
+
+	if (sth->hlength) {
+		/*
+		 * FIXME: read any additional header segments.
+		 * For now, drop the session if one is
+		 * received, since we can't handle them.
+		 */
+		iscsi_host_err(session, "Received opcode %x, ahs length %d, itt"
+			       " %u. Dropping, additional header segments not "
+			       "supported by this driver version.\n",
+			       sth->opcode, sth->hlength, ntohl(sth->itt));
+		return ISCSI_IO_ERR;
+	}
+
+	return ISCSI_IO_SUCCESS;
+}
+
+static void
+handle_logout(struct iscsi_session *session, struct iscsi_hdr *sth)
+{
+	struct iscsi_logout_rsp_hdr *stlh = (struct iscsi_logout_rsp_hdr *)sth;
+
+	update_sn(session, ntohl(stlh->expcmdsn), ntohl(stlh->maxcmdsn));
+
+	if (test_bit(SESSION_IN_LOGOUT, &session->control_bits))
+		switch (stlh->response) {
+		case ISCSI_LOGOUT_SUCCESS:
+			/*
+			 * set session's time2wait to zero?
+			 * use DefaultTime2Wait?
+			 */
+			session->time2wait = 0;
+			iscsi_host_notice(session, "Session logged out\n");
+			break;
+		case ISCSI_LOGOUT_CID_NOT_FOUND:
+			iscsi_host_err(session, "Session logout failed, cid not"
+				       " found\n");
+			break;
+		case ISCSI_LOGOUT_RECOVERY_UNSUPPORTED:
+			iscsi_host_err(session, "Session logout failed, "
+				       "connection recovery not supported\n");
+			break;
+		case ISCSI_LOGOUT_CLEANUP_FAILED:
+			iscsi_host_err(session, "Session logout failed, cleanup"
+				       " failed\n");
+			break;
+		default:
+			iscsi_host_err(session, "Session logout failed, "
+				       "response 0x%x\n", stlh->response);
+			break;
+		}
+	else
+		iscsi_host_err(session, "Session received logout response, but "
+			       "never sent a login request\n");
+	iscsi_drop_session(session);
+}
+
+static void
+setup_nop_out(struct iscsi_session *session, struct iscsi_nop_in_hdr *stnih)
+{
+	struct iscsi_nop_info *nop_info;
+
+	/*
+	 * we preallocate space for one data-less nop reply in
+	 * session structure, to avoid having to invoke kernel
+	 * memory allocator in the common case where the target
+	 * has at most one outstanding data-less nop reply
+	 * requested at any given time.
+	 */
+	spin_lock_bh(&session->task_lock);
+	if (session->nop_reply.ttt == ISCSI_RSVD_TASK_TAG &&
+	    list_empty(&session->nop_reply_list))
+		nop_info = &session->nop_reply;
+	else {
+		nop_info = kmalloc(sizeof(*nop_info), GFP_ATOMIC);
+		if (!nop_info) {
+			spin_unlock_bh(&session->task_lock);
+			iscsi_host_warn(session, "Couldn't queue nop reply "
+					"for ttt %u ", ntohl(stnih->ttt));
+			return;
+		}
+		list_add_tail(&nop_info->reply_list, &session->nop_reply_list);
+	}
+
+	session->nop_reply.ttt = stnih->ttt;
+	memcpy(session->nop_reply.lun, stnih->lun,
+	       sizeof(session->nop_reply.lun));
+	spin_unlock_bh(&session->task_lock);
+
+	iscsi_wake_tx_thread(TX_NOP_REPLY, session);
+}
+
+static void
+handle_nop_in(struct iscsi_session *session, struct iscsi_hdr *sth)
+{
+	struct iscsi_nop_in_hdr *stnih = (struct iscsi_nop_in_hdr *)sth;
+
+	update_sn(session, ntohl(stnih->expcmdsn), ntohl(stnih->maxcmdsn));
+
+	if (stnih->itt != ISCSI_RSVD_TASK_TAG)
+		/*
+		 * we do not send data in our nop-outs, so there
+		 * is not much to do right now
+		 */
+
+		/*
+		 * FIXME: check StatSN
+		 */
+		session->exp_stat_sn = ntohl(stnih->statsn) + 1;
+
+	/*
+	 * check the ttt to decide whether to reply with a Nop-out
+	 */
+	if (stnih->ttt != ISCSI_RSVD_TASK_TAG)
+		setup_nop_out(session, stnih);
+}
+
+/**
+ * handle_scsi_rsp - Process the SCSI response PDU.
+ * @session: Session on which the cmd response is received.
+ * @stsrh: SCSI cmd Response header
+ * @sense_data: Sense data received for the cmd
+ *
+ * Description:
+ *     Get the task for the SCSI cmd, process the response received and
+ *     complete the task.
+ **/
+static void
+handle_scsi_rsp(struct iscsi_session *session, struct iscsi_hdr *sth,
+		unsigned char *sense_data)
+{
+	struct iscsi_scsi_rsp_hdr *stsrh = (struct iscsi_scsi_rsp_hdr *)sth;
+	struct iscsi_task *task;
+	unsigned int senselen = 0;
+	u32 itt = ntohl(stsrh->itt);
+
+	/* FIXME: check StatSN */
+	session->exp_stat_sn = ntohl(stsrh->statsn) + 1;
+	update_sn(session, ntohl(stsrh->expcmdsn), ntohl(stsrh->maxcmdsn));
+
+	spin_lock_bh(&session->task_lock);
+	task = iscsi_find_session_task(session, itt);
+	if (!task) {
+		iscsi_host_info(session, "recv_cmd - response for itt %u, but "
+				"no such task\n", itt);
+		spin_unlock_bh(&session->task_lock);
+		return;
+	}
+
+	/* check for sense data */
+	if (ntoh24(stsrh->dlength) > 1) {
+		/*
+		 * Sense data format per draft-08, 3.4.6.  2-byte sense length,
+		 * then sense data, then iSCSI response data
+		 */
+		senselen = (sense_data[0] << 8) | sense_data[1];
+		if (senselen > (ntoh24(stsrh->dlength) - 2))
+			senselen = (ntoh24(stsrh->dlength) - 2);
+		sense_data += 2;
+	}
+
+	iscsi_process_task_response(task, stsrh, sense_data, senselen);
+	iscsi_complete_task(task);
+	__iscsi_put_task(task);
+	spin_unlock_bh(&session->task_lock);
+}
+
+static void
+handle_r2t(struct iscsi_session *session, struct iscsi_hdr *sth)
+{
+	struct iscsi_r2t_hdr *strh = (struct iscsi_r2t_hdr *)sth;
+	struct iscsi_task *task;
+	u32 itt = ntohl(strh->itt);
+
+	update_sn(session, ntohl(strh->expcmdsn), ntohl(strh->maxcmdsn));
+
+	spin_lock_bh(&session->task_lock);
+
+	task = iscsi_find_session_task(session, itt);
+	if (!task) {
+		/* the task no longer exists */
+		iscsi_host_info(session, "ignoring R2T for itt %u, %u bytes @ "
+				"offset %u\n", ntohl(strh->itt),
+				ntohl(strh->data_length),
+				ntohl(strh->data_offset));
+		goto done;
+	}
+
+	if (!test_bit(ISCSI_TASK_WRITE, &task->flags)) {
+		/*
+		 * bug in the target.  the command isn't a write,
+		 * so we have no data to send
+		 */
+		iscsi_host_err(session, "Ignoring unexpected R2T for task itt "
+			       "%u, %u bytes @ offset %u, ttt %u, not a write "
+			       "command\n", ntohl(strh->itt),
+			       ntohl(strh->data_length),
+			       ntohl(strh->data_offset), ntohl(strh->ttt));
+		iscsi_drop_session(session);
+	} else if (task->ttt != ISCSI_RSVD_TASK_TAG)
+		/*
+		 * bug in the target.  MaxOutstandingR2T == 1 should
+		 * have prevented this from occuring
+		 */
+		iscsi_host_warn(session, "Ignoring R2T for task itt %u, %u "
+				"bytes @ offset %u, ttt %u, already have R2T "
+				"for %u @ %u, ttt %u\n", ntohl(strh->itt),
+				ntohl(strh->data_length),
+				ntohl(strh->data_offset), ntohl(strh->ttt),
+				task->data_length, task->data_offset,
+				ntohl(task->ttt));
+	else {
+		/* record the R2T */
+		task->ttt = strh->ttt;
+		task->data_length = ntohl(strh->data_length);
+		task->data_offset = ntohl(strh->data_offset);
+		/*
+		 * even if we've issued an abort task set, we need
+		 * to respond to R2Ts for this task, though we can
+		 * apparently set the F-bit and terminate the data burst
+		 * early.  Rather than hope targets handle that
+		 * correctly, we just send the data requested as usual.
+		 */
+		iscsi_queue_r2t(session, task);
+		iscsi_wake_tx_thread(TX_DATA, session);
+	}
+
+	__iscsi_put_task(task);
+
+ done:
+	spin_unlock_bh(&session->task_lock);
+}
+
+static int
+recv_extra_data(struct iscsi_session *session,  u32 data_len, u32 *recvd_crc32c)
+{
+	struct scatterlist tmpsg;
+	struct kvec iov[2];
+	char padding[PAD_WORD_LEN - 1];
+	int pad = 0, iovn = 0, len = 0, rc;
+
+	if (data_len % PAD_WORD_LEN) {
+		pad = PAD_WORD_LEN - (data_len % PAD_WORD_LEN);
+		iov[iovn].iov_base = padding;
+		iov[iovn].iov_len = pad;
+		iovn++;
+		len += pad;
+	}
+
+	if (recvd_crc32c) {
+		iov[iovn].iov_base = recvd_crc32c;
+		iov[iovn].iov_len = sizeof(*recvd_crc32c);
+		len += iov[iovn].iov_len;
+		iovn++;
+	}
+
+	if (iovn) {
+		rc = iscsi_recvmsg(session, iov, iovn, len);
+		if (rc != ISCSI_IO_SUCCESS)
+			return rc;
+
+		if (pad && recvd_crc32c) {
+			sg_init_one(&tmpsg, padding, pad);
+			crypto_digest_update(session->rx_tfm, &tmpsg, 1);
+		}
+	}
+
+	return ISCSI_IO_SUCCESS;
+}
+
+/**
+ * iscsi_recv_sg_data - read the PDU's payload
+ * @session: iscsi session
+ * @data_len: data length
+ * @sglist: data scatterlist
+ * @sglist_len: number of sg elements
+ * @sg_offset: offset in sglist
+ * @digest_opt: CRC32C or NONE
+ **/
+static int
+iscsi_recv_sg_data(struct iscsi_session *session, u32 data_len,
+		   struct scatterlist *sglist, int sglist_len,
+		   unsigned int sg_offset, int digest_opt)
+{
+	int i, len, rc = ISCSI_IO_ERR;
+	struct scatterlist *sg, tmpsg;
+	unsigned int page_offset, remaining, sg_bytes;
+	struct page *p;
+	void *page_addr;
+	struct kvec iov;
+	u32 recvd_crc32c, data_crc32c;
+
+	remaining = data_len;
+
+	if (digest_opt == ISCSI_DIGEST_CRC32C)
+		crypto_digest_init(session->rx_tfm);
+	/*
+	 * Read in the data for each sg in PDU
+	 */
+	for (i = 0; remaining > 0 && i < sglist_len; i++) {
+		/*
+		 * Find the right sg entry first
+		 */
+		if (sg_offset >= sglist[i].length) {
+			sg_offset -= sglist[i].length;
+			continue;
+		}
+		sg = &sglist[i];
+
+		/*
+		 * Find page corresponding to segment offset first
+		 */
+		page_offset = sg->offset + sg_offset;
+		p = sg->page + (page_offset >> PAGE_SHIFT);
+		page_offset -= (page_offset & PAGE_MASK);
+		/*
+		 * yuck, for each page in sg (can't pass a sg with its
+		 * pages mapped to kernel_recvmsg in one iov entry and must
+		 * use one iov entry for each PAGE when using highmem???????)
+		 */
+		sg_bytes = min(remaining, sg->length - sg_offset);
+		remaining -= sg_bytes;
+		for (; sg_bytes > 0; sg_bytes -= len) {
+			page_addr = kmap(p);
+			if (!page_addr) {
+				iscsi_host_err(session, "recv_sg_data kmap "
+					       "failed to map page in sg %p\n",
+					       sg);
+				goto error_exit;
+			}
+		
+			iov.iov_base = page_addr + page_offset;
+			iov.iov_len = min_t(unsigned int, sg_bytes,
+					    PAGE_SIZE - page_offset);
+			len = iov.iov_len;
+			/*
+			 * is it better to do one call with all the pages
+			 * setup or multiple calls?
+			 */
+			rc = iscsi_recvmsg(session, &iov, 1, len);
+			kunmap(p);
+			if (rc != ISCSI_IO_SUCCESS)
+				goto error_exit;
+
+			/* crypto_digest_update will kmap itself */
+			if (digest_opt == ISCSI_DIGEST_CRC32C) {
+				tmpsg.page = p;
+				tmpsg.offset = page_offset;
+				tmpsg.length = len;
+				crypto_digest_update(session->rx_tfm, &tmpsg,
+						     1);
+			}
+
+			p++;
+			page_offset = 0;
+		}
+
+		sg_offset = 0;
+	}
+
+	if (remaining != 0) {
+		/* Maybe this should be a BUG? */
+		iscsi_host_err(session, "recv_sg_data - invalid sglist for "
+			       "offset %u len %u, remaining data %u, sglist "
+			       "size %d, dropping session\n", sg_offset,
+			       data_len, remaining, sglist_len);
+		goto error_exit;
+	}
+
+	rc = recv_extra_data(session, data_len, digest_opt ==
+			     ISCSI_DIGEST_CRC32C ? &recvd_crc32c : NULL);
+	if (rc != ISCSI_IO_SUCCESS)  
+		goto error_exit;
+
+	if (digest_opt == ISCSI_DIGEST_CRC32C) {
+		crypto_digest_final(session->rx_tfm, (u8*)&data_crc32c);
+		if (data_crc32c != recvd_crc32c) {
+			iscsi_host_err(session, "DataDigest mismatch, received "
+				       "0x%08x, calculated 0x%08x\n",
+				       recvd_crc32c, data_crc32c);
+			return ISCSI_IO_CRC32C_ERR;
+		}
+	}
+
+	/* connection is ok */
+	session->last_rx = jiffies;
+	return rc;
+
+ error_exit:
+	/* FIXME: we could discard the data or drop the session */
+	return rc;
+}
+
+/*
+ * Only call this from recvs where the rx_buffer is not in
+ * use. We don't bother checking the CRC, since we couldn't
+ * retry the command anyway
+ */
+static void
+drop_data(struct iscsi_session *session, struct iscsi_hdr *sth)
+{
+	int pad, length, num_bytes;
+	struct kvec iov;
+
+	length = ntoh24(sth->dlength);
+
+	pad = length % PAD_WORD_LEN;
+	if (pad)
+		pad = PAD_WORD_LEN - pad;
+	length += pad;
+
+	if (session->data_digest == ISCSI_DIGEST_CRC32C) {
+		iscsi_host_info(session, "recv_data discarding %d data PDU "
+				"bytes, %d pad bytes, %Zu digest bytes\n",
+				ntoh24(sth->dlength), pad, sizeof(u32));
+		length += sizeof(u32);
+	} else
+		iscsi_host_info(session, "recv_data discarding %d data PDU "
+				"bytes, %d pad bytes\n", ntoh24(sth->dlength),
+				pad);
+
+	while (!signal_pending(current) && length > 0) {
+		num_bytes = min_t(int, length, sizeof(session->rx_buffer));
+		iov.iov_base = session->rx_buffer;
+		iov.iov_len = sizeof(session->rx_buffer);
+		/* should iov_len match num_bytes ? */
+		if (iscsi_recvmsg(session, &iov, 1, num_bytes) !=
+		    ISCSI_IO_SUCCESS) {
+			iscsi_drop_session(session);
+			break;
+		}
+		/* assume a PDU round-trip, connection is ok */
+		session->last_rx = jiffies;
+		length -= num_bytes;
+	}
+}
+
+static void
+handle_scsi_data(struct iscsi_session *session, struct iscsi_hdr *sth)
+{
+	struct iscsi_data_rsp_hdr *stdrh = (struct iscsi_data_rsp_hdr *)sth;
+	struct iscsi_task *task;
+	struct scsi_cmnd *sc;
+	struct scatterlist sg;
+	int dlength, offset, rc;
+	u32 itt = ntohl(stdrh->itt);
+
+	if (stdrh->flags & ISCSI_FLAG_DATA_STATUS)
+		/* FIXME: check StatSN */
+		session->exp_stat_sn = ntohl(stdrh->statsn) + 1;
+
+	update_sn(session, ntohl(stdrh->expcmdsn), ntohl(stdrh->maxcmdsn));
+
+	dlength = ntoh24(stdrh->dlength);
+	offset = ntohl(stdrh->offset);
+
+	spin_lock_bh(&session->task_lock);
+
+	task = iscsi_find_session_task(session, itt);
+	if (!task) {
+		iscsi_host_warn(session, "recv_data, no task for itt %u next "
+				"itt %u, discarding received data, offset %u "
+				"len %u\n", ntohl(stdrh->itt),
+				session->next_itt, offset, dlength);
+		spin_unlock_bh(&session->task_lock);
+		drop_data(session, sth);
+		return;
+	}
+	sc = task->scsi_cmnd;
+
+	/* sanity check the PDU against the command */
+	if (!test_bit(ISCSI_TASK_READ, &task->flags)) {
+		iscsi_host_err(session, "lun%u: recv_data itt %u, command "
+			       "cdb 0x%02x, dropping session due to "
+			       "unexpected Data-in from\n", task->lun, itt,
+			       sc->cmnd[0]);
+		iscsi_drop_session(session);
+		goto done;
+	} else if ((offset + dlength) > sc->request_bufflen) {
+		/* buffer overflow, often because of a corrupt PDU header */
+		iscsi_host_err(session, "recv_data for itt %u, cmnd 0x%x, "
+			       "bufflen %u, Data PDU with offset %u len %u "
+			       "overflows command buffer, dropping session\n",
+			       itt, sc->cmnd[0], sc->request_bufflen, offset,
+			       dlength);
+		iscsi_drop_session(session);
+		goto done;
+	} else if (task->rxdata != offset) {
+		/*	
+		 * if the data arrives out-of-order, it becomes much harder
+		 * for us to correctly calculate the residual if we don't get
+		 * enough data and also don't get an underflow from the
+		 * target.  This can happen if we discard Data PDUs due to
+		 * bogus offsets/lengths.  Since we always negotiate for
+		 * Data PDUs in-order, this should never happen, but check
+		 * for it anyway.
+		 */
+		iscsi_host_err(session, "recv_data for itt %u, cmnd 0x%x, "
+			       "bufflen %u, offset %u does not match expected "
+			       "offset %u, dropping session\n", itt,
+			       sc->cmnd[0], sc->request_bufflen, offset,
+			       task->rxdata);
+		iscsi_drop_session(session);
+		goto done;
+	}
+
+	/*
+	 * either we'll read it all, or we'll drop the session and requeue
+	 * the command, so it's safe to increment early
+	 */
+	task->rxdata += dlength;
+	spin_unlock_bh(&session->task_lock);
+
+	if (sc->use_sg)
+		rc = iscsi_recv_sg_data(session, dlength, sc->request_buffer,
+					sc->use_sg, offset,
+					session->data_digest);
+	else {
+		sg_init_one(&sg, sc->request_buffer, dlength);
+		rc = iscsi_recv_sg_data(session, dlength, &sg, 1, offset,
+					session->data_digest);
+	}
+
+	spin_lock_bh(&session->task_lock);
+
+	switch (rc) {
+	case ISCSI_IO_ERR:
+		iscsi_drop_session(session);
+		break;
+	case ISCSI_IO_CRC32C_ERR:
+		__set_bit(ISCSI_TASK_CRC_ERROR, &task->flags);
+		/* fall through */
+	case ISCSI_IO_SUCCESS:
+		if (stdrh->flags & ISCSI_FLAG_DATA_STATUS) {
+			iscsi_process_task_status(task, sth);
+			iscsi_complete_task(task);
+		}
+	}
+
+ done:
+	__iscsi_put_task(task);
+	spin_unlock_bh(&session->task_lock);
+}
+
+/**
+ * handle_task_mgmt_rsp - Process the task management response.
+ * @session: to retrieve the task
+ * @ststmrh: task management response header
+ *
+ * Description:
+ *     Retrieve the task for which task mgmt response is received and take
+ *     appropriate action based on the type of task management request.
+ **/
+static void
+handle_task_mgmt_rsp(struct iscsi_session *session, struct iscsi_hdr *sth)
+{
+	struct iscsi_scsi_task_mgmt_rsp_hdr *ststmrh;
+	struct iscsi_task *task;
+	u32 mgmt_itt;
+
+	ststmrh = (struct iscsi_scsi_task_mgmt_rsp_hdr *)sth;
+	mgmt_itt = ntohl(ststmrh->itt);
+
+	/* FIXME: check StatSN */
+	session->exp_stat_sn = ntohl(ststmrh->statsn) + 1;
+	update_sn(session, ntohl(ststmrh->expcmdsn), ntohl(ststmrh->maxcmdsn));
+
+	spin_lock_bh(&session->task_lock);
+	/*
+	 * This can fail if they timedout and we escalated the recovery
+	 * to a new function
+	 */
+	task = iscsi_find_session_task(session, mgmt_itt);
+	if (!task) {
+		iscsi_host_warn(session, "mgmt response 0x%x for unknown itt "
+				"%u, rtt %u\n", ststmrh->response,
+				ntohl(ststmrh->itt), ntohl(ststmrh->rtt));
+		goto done;
+	}
+
+	if (ststmrh->response == 0) {
+		iscsi_host_info(task->session, "task mgmt itt %u "
+				"successful\n", mgmt_itt);
+		iscsi_complete_tmf_task(task, ISCSI_TASK_TMF_SUCCESS);
+	} else {
+		iscsi_host_err(task->session, "task mgmt itt %u rejected"
+			       " (0x%x)\n", mgmt_itt, ststmrh->response);
+		iscsi_complete_tmf_task(task, ISCSI_TASK_TMF_FAILED);
+	}
+	__iscsi_put_task(task);	
+
+ done:
+	/*
+	 * we got the expected response, allow the eh thread to send
+	 * another task mgmt PDU whenever it wants to
+	 */
+	if (session->last_mgmt_itt == mgmt_itt)
+		session->last_mgmt_itt = ISCSI_RSVD_TASK_TAG;
+
+	spin_unlock_bh(&session->task_lock);
+}
+
+static void
+process_immed_cmd_reject(struct iscsi_session *session, unsigned char *xbuf,
+			 int dlength)
+{
+	u32 itt;
+	struct iscsi_task *task;
+	struct iscsi_hdr pdu;
+
+	if (dlength < sizeof(pdu)) {
+		iscsi_host_warn(session, "Immediate command rejected, dlength "
+				"%u\n", dlength);
+		return;
+	}
+
+	/* look at the rejected PDU */
+	memcpy(&pdu, xbuf, sizeof(pdu));
+	itt = ntohl(pdu.itt);
+
+	/*
+	 * try to find the task corresponding to this itt,
+	 * and wake up any process waiting on it
+	 */
+	spin_lock_bh(&session->task_lock);
+
+	if (session->last_mgmt_itt == itt)
+		session->last_mgmt_itt = ISCSI_RSVD_TASK_TAG;
+
+	task = iscsi_find_session_task(session, itt);
+	if (task) {
+		iscsi_host_notice(session, "task mgmt PDU rejected, mgmt %u, "
+				  "itt %u\n", itt, task->itt);
+		iscsi_complete_tmf_task(task, ISCSI_TASK_IMM_REJECT);
+		__iscsi_put_task(task);
+	} else if ((pdu.opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT_CMD)
+		/*
+		 * our Logout was rejected.  just let the
+		 * logout response timer drop the session
+		 */
+		iscsi_host_warn(session, "Logout PDU rejected, itt %u\n", itt);
+	else
+		iscsi_host_warn(session, "itt %u immediate command rejected\n",
+				itt);
+
+	spin_unlock_bh(&session->task_lock);
+}
+
+static void
+handle_reject(struct iscsi_session *session, struct iscsi_hdr *sth,
+	      unsigned char *xbuf)
+{
+	struct iscsi_reject_hdr *reject;
+	struct iscsi_hdr pdu;
+	int dlength;
+	u32 itt;
+
+	reject = (struct iscsi_reject_hdr *)sth;
+	dlength = ntoh24(reject->dlength);
+
+	/* FIXME: check StatSN */
+	session->exp_stat_sn = ntohl(reject->statsn) + 1;
+	update_sn(session, ntohl(reject->expcmdsn), ntohl(reject->maxcmdsn));
+
+	if (reject->reason == ISCSI_REJECT_DATA_DIGEST_ERROR) {
+		/*
+		 * we don't need to do anything about these,
+		 * timers or other PDUs will handle the problem.
+		 */
+		if (dlength >= sizeof(pdu)) {
+			memcpy(&pdu, xbuf, sizeof(pdu));
+			itt = ntohl(pdu.itt);
+			iscsi_host_warn(session, "itt %u (opcode 0x%x) rejected"
+					" because of a DataDigest error\n", itt,
+					pdu.opcode);
+		} else
+			iscsi_host_warn(session, "Target rejected a PDU because"
+					" of a DataDigest error\n");
+	} else if (reject->reason == ISCSI_REJECT_IMM_CMD_REJECT)
+		process_immed_cmd_reject(session, xbuf, dlength);
+	else {
+		if (dlength >= sizeof(pdu)) {
+			/* look at the rejected PDU */
+			memcpy(&pdu, xbuf, sizeof(pdu));
+			itt = ntohl(pdu.itt);
+			iscsi_host_err(session, "Dropping session because "
+				       "target rejected a PDU, reason 0x%x, "
+				       "dlength %d, rejected itt %u, opcode "
+				       "0x%x\n", reject->reason, dlength, itt,
+				       pdu.opcode);
+		} else
+			iscsi_host_err(session, "Dropping session because "
+				       "target rejected a PDU, reason 0x%x, "
+				       "dlength %u\n", reject->reason, dlength);
+		iscsi_drop_session(session);
+	}
+}
+
+static void
+handle_async_msg(struct iscsi_session *session, struct iscsi_hdr *sth,
+		 unsigned char *xbuf)
+{
+	struct iscsi_async_msg_hdr *staeh = (struct iscsi_async_msg_hdr *)sth;
+	unsigned int senselen;
+
+	/* FIXME: check StatSN */
+	session->exp_stat_sn = ntohl(staeh->statsn) + 1;
+	update_sn(session, ntohl(staeh->expcmdsn), ntohl(staeh->maxcmdsn));
+
+	switch (staeh->async_event) {
+	case ISCSI_ASYNC_MSG_SCSI_EVENT:
+		senselen = (xbuf[0] << 8) | xbuf[1];
+		xbuf += 2;
+
+		iscsi_host_info(session, "Received async SCSI event. Printing "
+				"sense\n");
+		__scsi_print_sense(ISCSI_PROC_NAME, xbuf, senselen);
+		break;
+	case ISCSI_ASYNC_MSG_REQUEST_LOGOUT:
+		/*
+		 * FIXME: this is really a request to drop a connection,
+		 * not the whole session, but we currently only have one
+		 * connection per session, so there's no difference
+		 * at the moment.
+		 */
+		iscsi_host_warn(session, "Target requests logout within %u "
+				"seconds for session\n", ntohs(staeh->param3));
+		/*
+		 * we need to get the task lock to make sure the TX thread
+		 * isn't in the middle of adding another task to the session.
+		 */
+		spin_lock_bh(&session->task_lock);
+		iscsi_request_logout(session, ntohs(staeh->param3) - (HZ / 10),
+				     session->active_timeout);
+		spin_unlock_bh(&session->task_lock);
+		break;
+	case ISCSI_ASYNC_MSG_DROPPING_CONNECTION:
+		iscsi_host_warn(session, "Target dropping connection %u, "
+				"reconnect min %u max %u\n",
+				ntohs(staeh->param1), ntohs(staeh->param2),
+				ntohs(staeh->param3));
+		session->time2wait = (long) ntohs(staeh->param2) & 0x0000FFFFFL;
+		break;
+	case ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS:
+		iscsi_host_warn(session, "Target dropping all connections, "
+				"reconnect min %u max %u\n",
+				ntohs(staeh->param2), ntohs(staeh->param3));
+		session->time2wait = (long) ntohs(staeh->param2) & 0x0000FFFFFL;
+		break;
+	case ISCSI_ASYNC_MSG_VENDOR_SPECIFIC:
+		iscsi_host_warn(session, "Ignoring vendor-specific async event,"
+				" vcode 0x%x\n", staeh->async_vcode);
+		break;
+	case ISCSI_ASYNC_MSG_PARAM_NEGOTIATION:
+		iscsi_host_warn(session, "Received async event param "
+				"negotiation, dropping session\n");
+		iscsi_drop_session(session);
+		break;
+	default:
+		iscsi_host_err(session, "Received unknown async event 0x%x\n",
+			       staeh->async_event);
+		break;
+	}
+	if (staeh->async_event == ISCSI_ASYNC_MSG_DROPPING_CONNECTION ||
+	    staeh->async_event == ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS ||
+	    staeh->async_event == ISCSI_ASYNC_MSG_REQUEST_LOGOUT) {
+		spin_lock(&session->portal_lock);
+		memcpy(&session->addr, &session->portal.addr,
+		       sizeof(struct sockaddr));
+		spin_unlock(&session->portal_lock);
+	}
+}
+
+/**
+ * iscsi_recv_pdu - Read in a iSCSI PDU
+ * @session: iscsi session structure
+ * @hdr: a iSCSI PDU header
+ * @hdr_digest: digest type for header
+ * @data: buffer for data
+ * @max_data_len: buffer size
+ * @data_digest: digest type for data
+ *
+ * Description:
+ *    Reads a iSCSI PDU into memory. Excpet for login PDUs, this function
+ *    will also process the PDU.
+ **/
+int
+iscsi_recv_pdu(struct iscsi_session *session, struct iscsi_hdr *hdr,
+	       int hdr_digest, char *data, int max_data_len, int data_digest)
+{
+	int rc;
+	int data_len;
+	struct scatterlist sg;
+
+	if (iscsi_recv_header(session, hdr, hdr_digest) != ISCSI_IO_SUCCESS)
+		goto fail;
+
+	data_len = ntoh24(hdr->dlength);
+	/*
+	 * scsi data is read in and processed by its handler for now
+	 */
+	if (data_len && hdr->opcode != ISCSI_OP_SCSI_DATA_RSP) {
+        	if (data_len > max_data_len) {
+                	iscsi_host_err(session, "iscsi_recv_pdu() cannot read "
+				       "%d bytes of PDU data, only %d bytes "
+				       "of buffer available\n", data_len,
+				       max_data_len);
+			goto fail;
+        	}
+
+		/*
+		 * must clear this, beucase the login api uses the same
+		 * buffer for recv and send
+		 */
+		memset(data, 0, max_data_len);
+		sg_init_one(&sg, data, data_len);
+		rc = iscsi_recv_sg_data(session, data_len, &sg, 1, 0,
+					data_digest);
+		if (rc == ISCSI_IO_CRC32C_ERR) {
+			switch (hdr->opcode) {
+			case ISCSI_OP_ASYNC_MSG:
+			case ISCSI_OP_REJECT:
+				/* unsolicited so ignore */
+				goto done;
+			default:
+				goto fail;
+			};
+		} else if (rc != ISCSI_IO_SUCCESS)
+			goto fail;
+	}
+
+	switch (hdr->opcode) {
+	case ISCSI_OP_NOOP_IN:
+		handle_nop_in(session, hdr);
+		break;
+	case ISCSI_OP_SCSI_RSP:
+		handle_scsi_rsp(session, hdr, data);
+		break;
+	case ISCSI_OP_SCSI_TASK_MGT_RSP:
+		handle_task_mgmt_rsp(session, hdr);
+		break;
+	case ISCSI_OP_R2T:
+		handle_r2t(session, hdr);
+		break;
+	case ISCSI_OP_SCSI_DATA_RSP:
+		handle_scsi_data(session, hdr);
+		break;
+	case ISCSI_OP_ASYNC_MSG:
+		handle_async_msg(session, hdr, data);
+		break;
+	case ISCSI_OP_REJECT:
+	        handle_reject(session, hdr, data);
+		break;
+	case ISCSI_OP_LOGOUT_RSP:
+		handle_logout(session, hdr);
+		break;
+	case ISCSI_OP_LOGIN_RSP:
+		/*
+		 * The login api needs the buffer to be cleared when no
+		 * data has been read
+		 */
+		if (!data_len)
+			memset(data, 0, max_data_len);	
+		/*
+		 * login api will process further
+		 */
+		break;
+	default:
+		iscsi_host_err(session, "Dropping session after receiving "
+			       "unexpected opcode 0x%x\n", hdr->opcode);
+		session->time2wait = 2;
+		goto fail;
+	}
+
+ done:
+	return 1;
+ fail:
+	iscsi_drop_session(session);
+	return 0;
+}
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-xmit-pdu.c scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-xmit-pdu.c
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-xmit-pdu.c	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-xmit-pdu.c	2005-01-10 13:29:35.704498642 -0800
@@ -0,0 +1,740 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2001 Cisco Systems, Inc.
+ * Copyright (C) 2004 Mike Christie
+ * Copyright (C) 2004 IBM Corporation
+ * maintained by linux-iscsi-devel@lists.sourceforge.net
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ *
+ * Contains functions to handle transmission of iSCSI PDUs
+ */
+#include <linux/tcp.h>
+#include <linux/net.h>
+#include <linux/blkdev.h>
+#include <linux/scatterlist.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
+
+#include "iscsi-session.h"
+#include "iscsi-task.h"
+#include "iscsi-protocol.h"
+#include "iscsi-login.h"
+#include "iscsi-sfnet.h"
+
+static int
+iscsi_send_header(struct iscsi_session *session, struct iscsi_hdr *hdr,
+		  int hdr_digest)
+{
+	struct scatterlist sg;
+	struct kvec iov[2];
+	u32 crc32c;
+	int len, iovn = 0;
+
+	iov[iovn].iov_base = hdr;
+	iov[iovn].iov_len = sizeof(*hdr);
+	len = iov[iovn].iov_len;
+	iovn++;
+
+	if (hdr_digest == ISCSI_DIGEST_CRC32C) {
+		crypto_digest_init(session->tx_tfm);
+		sg_init_one(&sg, (u8 *)hdr, len);
+		crypto_digest_digest(session->tx_tfm, &sg, 1, (u8*)&crc32c);
+		iov[iovn].iov_base = &crc32c;
+		iov[iovn].iov_len = sizeof(crc32c);
+		len += iov[iovn].iov_len;
+		iovn++;
+	}
+
+	return iscsi_sendmsg(session, iov, iovn, len);
+}
+
+static int
+send_extra_data(struct iscsi_session *session, u32 data_len, int digest_opt)
+{
+	struct scatterlist sg;
+	struct kvec iov[2];
+	int pad, iovn = 0, len = 0;
+	char padding[PAD_WORD_LEN - 1];
+	u32 data_crc32c;
+
+	if (data_len % PAD_WORD_LEN) {
+		pad = PAD_WORD_LEN - (data_len % PAD_WORD_LEN);
+		memset(padding, 0, pad);
+		iov[iovn].iov_base = padding;
+		iov[iovn].iov_len = pad;
+		iovn++;
+		len += pad;
+
+		if (digest_opt == ISCSI_DIGEST_CRC32C) {
+			sg_init_one(&sg, padding, pad);
+			crypto_digest_update(session->tx_tfm, &sg, 1);
+		}
+	}
+
+	if (data_len && digest_opt == ISCSI_DIGEST_CRC32C) {
+		crypto_digest_final(session->tx_tfm, (u8*)&data_crc32c);
+		iov[iovn].iov_base = &data_crc32c;
+		iov[iovn].iov_len = sizeof(data_crc32c);
+		len += iov[iovn].iov_len;
+		iovn++;
+	}
+
+	if (iov)
+		return iscsi_sendmsg(session, iov, iovn, len);
+	else
+		return ISCSI_IO_SUCCESS;
+}
+
+/**
+ * iscsi_send_sg_data - send SCSI data
+ * @session: iscsi session
+ * @sglist: scatterlist
+ * @start_sg: index into sglist to start from
+ * @sg_offset: offset in scatterlist entry to start from
+ * @sglist_len: number of entries in sglist
+ * @data_len: transfer length
+ * @digest_opt: CRC32C or NONE
+ *
+ * Note:
+ *    iscsi_send_sg_data will set start_sg and sg_offset to the
+ *    next starting values for future transfers from this scatterlist
+ *    (if one is possible), for the caller.
+ **/
+static int
+iscsi_send_sg_data(struct iscsi_session *session, struct scatterlist *sglist,
+		   int *start_sg, u32 *sg_offset, int sglist_len,
+		   u32 data_len, int digest_opt)
+{
+	unsigned int len, sg_bytes, pg_offset, remaining = data_len;
+	struct scatterlist tmpsg, *sg;
+	struct page *pg;
+	int i, rc, flags = MSG_MORE;
+
+	if (digest_opt == ISCSI_DIGEST_CRC32C)
+		crypto_digest_init(session->tx_tfm);
+	/*
+	 * loop over the scatterlist
+	 */
+	for (i = *start_sg; remaining > 0 && i < sglist_len; i++) {
+		sg = &sglist[i];
+
+		if (signal_pending(current))
+			return ISCSI_IO_INTR;
+
+		pg_offset = sg->offset + *sg_offset;
+		pg = sg->page + (pg_offset >> PAGE_SHIFT);
+		pg_offset -= (pg_offset & PAGE_MASK);
+
+		/*
+		 * set the offset and sg for the next pdu or loop
+		 * iteration
+		 */
+		sg_bytes = sg->length - *sg_offset;
+		if (sg_bytes <= remaining) {
+			(*start_sg)++;
+			*sg_offset = 0;
+		} else {
+			*sg_offset = *sg_offset + remaining;
+			sg_bytes = remaining;
+		}
+		remaining -= sg_bytes;
+
+		/*
+		 * loop over each page in sg entry 
+		 */ 
+		for (; sg_bytes > 0; sg_bytes -= len) {
+			len = min_t(unsigned int, sg_bytes,
+				    PAGE_SIZE - pg_offset);
+			if (len == sg_bytes)
+				flags = 0;
+
+			rc = iscsi_sendpage(session, flags, pg, pg_offset, len);
+			if (rc != ISCSI_IO_SUCCESS)
+				return rc;
+
+			if (digest_opt == ISCSI_DIGEST_CRC32C) {
+				tmpsg.page = pg;
+				tmpsg.offset = pg_offset;
+				tmpsg.length = len;
+				crypto_digest_update(session->tx_tfm,
+						     &tmpsg, 1);
+			}
+
+			pg++;
+			pg_offset = 0;
+		}
+	}
+
+	/*
+	 * this should only happen for driver or scsi/block layer bugs
+	 */
+	if (remaining != 0) {
+		iscsi_host_err(session, "iscsi_send_sg_data - invalid sg list "
+			       "start_sg %d, sg_offset %u, sglist_len %d "
+			       "data_len %u, remaining %u\n", *start_sg,
+			       *sg_offset, sglist_len, data_len, remaining);
+		return ISCSI_IO_INVALID_OP;
+	}
+
+	return send_extra_data(session, data_len, digest_opt);
+}
+
+int
+iscsi_send_pdu(struct iscsi_session *session, struct iscsi_hdr *hdr,
+	       int hdr_digest, char *data, int data_digest)
+{
+	struct scatterlist sg;
+	u32 data_len, offset = 0;
+	int rc, index = 0;
+
+	rc = iscsi_send_header(session, hdr, hdr_digest);
+	if (rc != ISCSI_IO_SUCCESS) {
+		iscsi_drop_session(session);
+		goto done;
+	}
+
+	data_len= ntoh24(hdr->dlength);
+	if (data && data_len) {
+		sg_init_one(&sg, data, data_len);
+		rc = iscsi_send_sg_data(session, &sg, &index, &offset, 1,
+					data_len, data_digest);
+		if (rc != ISCSI_IO_SUCCESS)
+			iscsi_drop_session(session);
+	}
+
+ done:
+	return rc == ISCSI_IO_SUCCESS ? 1 : 0;
+}
+
+static void
+set_task_mgmt_attrs(struct iscsi_scsi_task_mgmt_hdr *ststmh,
+		    struct iscsi_task *task)
+{
+	u8 tmf_code;
+
+	if (test_bit(ISCSI_TASK_ABORT, &task->flags)) {
+		/*
+		 * we reused cmdsn for refcmdsn for abort tasks.
+		 */
+		ststmh->refcmdsn = htonl(task->cmdsn);
+		ststmh->rtt = htonl(task->rtt);
+		ststmh->lun[1] = task->lun;
+		tmf_code = ISCSI_TMF_ABORT_TASK;
+	} else if (test_bit(ISCSI_TASK_ABORT_TASK_SET, &task->flags)) {
+		ststmh->lun[1] = task->lun;
+		tmf_code = ISCSI_TMF_ABORT_TASK_SET;
+	} else if (test_bit(ISCSI_TASK_LU_RESET, &task->flags)) {
+		ststmh->lun[1] = task->lun;
+		tmf_code = ISCSI_TMF_LOGICAL_UNIT_RESET;
+	} else
+		tmf_code = ISCSI_TMF_TARGET_WARM_RESET;
+
+	ststmh->flags = ISCSI_FLAG_FINAL | (tmf_code & ISCSI_FLAG_TMF_MASK);
+}
+
+void
+iscsi_send_task_mgmt(struct iscsi_session *session)
+{
+	struct iscsi_task *task;
+	struct iscsi_scsi_task_mgmt_hdr ststmh;
+	int rc;
+
+	spin_lock_bh(&session->task_lock);
+
+	task = iscsi_find_session_task(session, session->last_mgmt_itt);
+	if (!task) {
+		/*
+		 * timed out or session dropping
+		 */
+		spin_unlock_bh(&session->task_lock);
+		return;
+	}
+
+	memset(&ststmh, 0, sizeof(ststmh));
+	ststmh.opcode = ISCSI_OP_TASK_MGT_REQ | ISCSI_OP_IMMEDIATE;
+	ststmh.rtt = ISCSI_RSVD_TASK_TAG;
+	ststmh.itt = htonl(task->itt);
+	ststmh.cmdsn = htonl(session->cmd_sn);
+	/* CmdSN not incremented after imm cmd */
+	ststmh.expstatsn = htonl(session->exp_stat_sn);
+	set_task_mgmt_attrs(&ststmh, task);
+
+	__iscsi_put_task(task);
+	spin_unlock_bh(&session->task_lock);
+
+	rc = iscsi_send_header(session, (struct iscsi_hdr *)&ststmh,
+			       session->header_digest);
+	if (rc != ISCSI_IO_SUCCESS) {
+		/* TODO drop session here still? */
+		iscsi_host_err(session, "xmit_task_mgmt failed\n");
+		iscsi_drop_session(session);
+	}
+}
+
+/**
+ * iscsi_send_nop_out - transmit iscsi NOP-out
+ * @session: iscsi session
+ * @itt: Initiator Task Tag (must be in network byte order)
+ * @ttt: Target Transfer Tag (must be in network byte order)
+ * @lun: when ttt is valid, lun must be set
+ **/
+static void
+__iscsi_send_nop_out(struct iscsi_session *session, u32 itt, u32 ttt, u8 *lun)
+{
+	struct iscsi_nop_out_hdr stph;
+	int rc;
+
+	memset(&stph, 0, sizeof(stph));
+	stph.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
+	stph.flags = ISCSI_FLAG_FINAL;
+	stph.cmdsn = htonl(session->cmd_sn);
+	stph.expstatsn = htonl(session->exp_stat_sn);
+	if (lun)
+		memcpy(stph.lun, lun, sizeof(stph.lun));
+	stph.ttt = ttt;
+	stph.itt = itt;
+
+	rc = iscsi_send_header(session, (struct iscsi_hdr *)&stph, 
+			       session->header_digest);
+	if (rc != ISCSI_IO_SUCCESS) {
+		iscsi_host_err(session, "xmit_ping failed\n");
+		/* mv drop ? */
+		iscsi_drop_session(session);
+	}
+}
+
+void
+iscsi_send_nop_out(struct iscsi_session *session)
+{
+	u32 itt;
+
+	spin_lock_bh(&session->task_lock);
+	itt = iscsi_alloc_itt(session);
+	spin_unlock_bh(&session->task_lock);
+	__iscsi_send_nop_out(session, htonl(itt), ISCSI_RSVD_TASK_TAG, NULL);
+}
+
+/* send replies for NopIns that requested them */
+void
+iscsi_send_nop_replys(struct iscsi_session *session)
+{
+	struct iscsi_nop_info *nop_info;
+	/*
+	 * these aren't really tasks, but it's not worth having
+	 * a separate lock for them
+	 */
+	spin_lock_bh(&session->task_lock);
+	/*
+	 * space for one data-less reply is preallocated in
+	 * the session itself
+	 */
+	if (session->nop_reply.ttt != ISCSI_RSVD_TASK_TAG) {
+		spin_unlock_bh(&session->task_lock);
+		__iscsi_send_nop_out(session, ISCSI_RSVD_TASK_TAG,
+				     session->nop_reply.ttt,
+				     session->nop_reply.lun);
+		session->nop_reply.ttt = ISCSI_RSVD_TASK_TAG;
+		spin_lock_bh(&session->task_lock);
+	}
+	/*
+	 * if we get multiple reply requests, or they have data,
+	 * they'll get queued up
+	 */
+	while (!list_empty(&session->nop_reply_list)) {
+		nop_info = list_entry(session->nop_reply_list.next,
+				      struct iscsi_nop_info, reply_list);
+		list_del_init(&nop_info->reply_list);
+
+		spin_unlock_bh(&session->task_lock);
+		__iscsi_send_nop_out(session, ISCSI_RSVD_TASK_TAG,
+				     nop_info->ttt, nop_info->lun);
+		kfree(nop_info);
+		if (signal_pending(current))
+			return;
+		spin_lock_bh(&session->task_lock);
+	}
+	spin_unlock_bh(&session->task_lock);
+}
+
+void
+iscsi_send_logout(struct iscsi_session *session)
+{
+	struct iscsi_logout_hdr stlh;
+	u32 itt;
+	int rc;
+
+	spin_lock_bh(&session->task_lock);
+	itt = iscsi_alloc_itt(session);
+	spin_unlock_bh(&session->task_lock);
+
+	memset(&stlh, 0, sizeof(stlh));
+	stlh.opcode = ISCSI_OP_LOGOUT_CMD | ISCSI_OP_IMMEDIATE;
+	stlh.flags = ISCSI_FLAG_FINAL | (ISCSI_LOGOUT_REASON_CLOSE_SESSION &
+					 ISCSI_FLAG_LOGOUT_REASON_MASK);
+	stlh.itt = htonl(itt);
+	stlh.cmdsn = htonl(session->cmd_sn);
+	stlh.expstatsn = htonl(session->exp_stat_sn);
+
+	rc = iscsi_send_header(session, (struct iscsi_hdr *)&stlh,
+			       session->header_digest);
+	if (rc != ISCSI_IO_SUCCESS) {
+		iscsi_host_err(session, "xmit_logout failed\n");
+		/* drop here ? */
+		iscsi_drop_session(session);
+	}
+}
+
+/**
+ * iscsi_send_data_out - send a SCSI Data-out PDU
+ * @task: iscsi task
+ * @ttt: target transfer tag
+ * @data_offset: offset of transfer within the complete transfer
+ * @data_len: data trasnfer length
+ *
+ * Note:
+ *   If command PDUs are small (no immediate data), we
+ *   start new commands as soon as possible, so that we can
+ *   overlap the R2T latency with the time it takes to
+ *   send data for commands already issued.  This increases
+ *   throughput without significantly increasing the completion
+ *   time of commands already issued.
+ **/
+static int
+iscsi_send_data_out(struct iscsi_task *task, u32 ttt, u32 data_offset,
+		    u32 data_len)
+{
+	struct iscsi_session *session = task->session;
+	struct scsi_cmnd *sc = task->scsi_cmnd;
+	struct scatterlist tmpsg, *sg;
+	struct iscsi_data_hdr stdh;
+	u32 data_sn = 0, dlen, remaining, sg_offset;
+	int i, rc = ISCSI_IO_SUCCESS;
+
+	memset(&stdh, 0, sizeof(stdh));
+	stdh.opcode = ISCSI_OP_SCSI_DATA;
+	stdh.itt = htonl(task->itt);
+	stdh.ttt = ttt;
+
+	/*
+	 * Find the right sg entry and offset into it if needed.
+	 * Why do we not cache this index for DataPDUInOrder?
+	 */
+	sg_offset = data_offset;
+	sg = sc->request_buffer;
+	for (i = 0; i < sc->use_sg; i++) {
+		if (sg_offset < sg->length)
+			break;
+		else {
+			sg_offset -= sg->length;
+			sg++;
+		}
+	}
+
+	/*
+	 * check that the target did not send us some bad values. just
+	 * let the cmnd timeout if it does.
+	 */
+	if (sc->request_bufflen < data_offset + data_len ||
+	    (sc->use_sg && i >= sc->use_sg)) {
+		iscsi_host_err(session, "iscsi_send_data_out - invalid write. "
+			       "len %u, offset %u, request_bufflen %u, usg_sg "
+			       "%u, task %u\n", data_len, data_offset,
+			       sc->request_bufflen, sc->use_sg, task->itt);
+		return ISCSI_IO_INVALID_OP;
+	}
+
+	/*
+	 * PDU loop - might need to send multiple PDUs to satisfy
+	 * the transfer, or we can also send a zero length PDU
+	 */
+	remaining = data_len;
+	do {
+		if (signal_pending(current)) {
+			rc = ISCSI_IO_INTR;
+			break;
+		}
+
+		if (!session->immediate_data) 
+			iscsi_run_pending_queue(session);
+
+		stdh.datasn = htonl(data_sn++);
+		stdh.offset = htonl(data_offset);
+		stdh.expstatsn = htonl(session->exp_stat_sn);
+
+		if (session->max_xmit_data_segment_len && 
+		    remaining > session->max_xmit_data_segment_len) 
+			/* enforce the target's data segment limit */
+			dlen = session->max_xmit_data_segment_len;
+		 else {
+			/* final PDU of a data burst */
+			dlen = remaining;
+			stdh.flags = ISCSI_FLAG_FINAL;
+		}
+		hton24(stdh.dlength, dlen);
+
+		rc = iscsi_send_header(session, (struct iscsi_hdr *)&stdh,
+				       session->header_digest);
+		if (rc != ISCSI_IO_SUCCESS) {
+			iscsi_drop_session(session);
+			break;
+		}
+
+		if (sc->use_sg)
+			rc = iscsi_send_sg_data(session, sc->request_buffer,
+						&i, &sg_offset, sc->use_sg,
+						dlen, session->data_digest);
+		else {
+			sg_init_one(&tmpsg, sc->request_buffer, dlen);
+			rc = iscsi_send_sg_data(session, &tmpsg, &i,
+						&sg_offset, 1, dlen,
+						session->data_digest);
+		}
+
+		if (rc != ISCSI_IO_SUCCESS &&
+		    rc != ISCSI_IO_INVALID_OP)
+			iscsi_drop_session(session);
+
+		data_offset += dlen;
+		remaining -= dlen;
+	} while (remaining > 0 && rc == ISCSI_IO_SUCCESS);
+
+	return rc;
+}
+
+static inline unsigned
+get_immediate_data_len(struct iscsi_session *session, struct scsi_cmnd *sc)
+{
+	int len;
+
+	if (!session->immediate_data)
+		return 0;
+
+	if (session->first_burst_len)
+		len = min(session->first_burst_len,
+			  session->max_xmit_data_segment_len);
+	else
+		len = session->max_xmit_data_segment_len;
+	return min_t(unsigned, len, sc->request_bufflen);
+}
+
+/*
+ * iscsi_queue_r2t may be called so the task lock must be held
+ * why not handle this in iscsi_send_scsi_cmnd?
+ */
+void
+iscsi_queue_unsolicited_data(struct iscsi_task *task)
+{
+	unsigned imm_data_len;
+	struct iscsi_session *session = task->session;
+	struct scsi_cmnd *sc = task->scsi_cmnd;
+
+	/*
+	 * With ImmediateData, we may or may not have to send
+	 * additional Data PDUs, depending on the amount of data, and
+	 * the Max PDU Length, and the first_burst_len.
+	 */
+	if (!test_bit(ISCSI_TASK_WRITE, &task->flags) ||
+	    !sc->request_bufflen || session->initial_r2t)
+		return;
+	/*
+	 * queue up unsolicited data PDUs. the implied initial R2T
+	 * doesn't count against the MaxOutstandingR2T, so we can't use
+	 * the normal R2T * fields of the task for the implied initial
+	 * R2T. Use a special flag for the implied initial R2T, and
+	 * let the rx thread update tasks in the tx_tasks collection
+	 * if an R2T comes in before the implied initial R2T has been
+	 * processed.
+	 */
+	if (session->immediate_data) {
+		imm_data_len = get_immediate_data_len(session, sc);
+		/*
+		 * Only queue unsolicited data out PDUs if there is more
+		 * data in the request, and the FirstBurstLength hasn't
+		 * already been satisfied with the ImmediateData that
+		 * will be sent below via iscsi_send_scsi_cmnd().
+		 */
+		if (sc->request_bufflen <= imm_data_len ||
+		    imm_data_len >= session->first_burst_len)
+			return;
+	}
+
+	__set_bit(ISCSI_TASK_INITIAL_R2T, &task->flags);
+	iscsi_queue_r2t(session, task);
+	set_bit(TX_DATA, &session->control_bits);
+	set_bit(TX_WAKE, &session->control_bits);
+}
+
+/**
+ * iscsi_send_r2t_data - see if we need to send more data.
+ * @session: iscsi session
+ *
+ * Note:
+ *   This may call iscsi_run_pending_queue under some conditions.
+ **/
+void
+iscsi_send_r2t_data(struct iscsi_session *session)
+{
+	struct iscsi_task *task;
+	struct scsi_cmnd *sc;
+	u32 ttt, offset, len;
+	unsigned implied_len, imm_data_len;
+	int rc;
+
+	spin_lock_bh(&session->task_lock);
+ retry:
+	task = iscsi_dequeue_r2t(session);
+	if (!task)
+		goto done;
+
+	rc = ISCSI_IO_SUCCESS;
+	/*
+	 * save the values that get set when we receive an R2T from
+	 * the target, so that we can receive another one while
+	 * we're sending data.
+	 */
+	ttt = task->ttt;
+	offset = task->data_offset;
+	len = task->data_length;
+	task->ttt = ISCSI_RSVD_TASK_TAG;
+	spin_unlock_bh(&session->task_lock);
+
+	/*
+	 * implied initial R2T
+	 * (ISCSI_TASK_INITIAL_R2T bit is only accessed by tx
+	 * thread so we do not need atomic ops)
+	 */
+	if (__test_and_clear_bit(ISCSI_TASK_INITIAL_R2T, &task->flags)) {
+		sc = task->scsi_cmnd;
+		/*
+		 * FirstBurstLength == 0 means no limit when
+		 * ImmediateData == 0 (not documented in README?)
+		 */
+		if (!session->first_burst_len)
+			implied_len = sc->request_bufflen;
+		else
+			implied_len = min_t(unsigned, session->first_burst_len,
+					    sc->request_bufflen);
+
+		if (session->immediate_data) {
+			imm_data_len = get_immediate_data_len(session, sc);
+			implied_len -= imm_data_len;
+		} else
+			imm_data_len = 0;
+
+		rc = iscsi_send_data_out(task, ISCSI_RSVD_TASK_TAG,
+					 imm_data_len, implied_len);
+	}
+
+	/* normal R2T from the target */
+	if (ttt != ISCSI_RSVD_TASK_TAG && rc == ISCSI_IO_SUCCESS)
+		iscsi_send_data_out(task, ttt, offset, len);
+
+	spin_lock_bh(&session->task_lock);
+	__iscsi_put_task(task);
+
+	if (!signal_pending(current))
+		goto retry;
+ done:
+	spin_unlock_bh(&session->task_lock);
+}
+
+/**
+ * iscsi_send_scsi_cmnd - Transmit iSCSI Command PDU.
+ * @task: iSCSI task to be transmitted
+ *
+ * Description:
+ *     The header digest on the cmd PDU is calculated before sending the cmd.
+ *     If ImmediateData is enabled, data digest is computed and data is sent
+ *     along with cmd PDU.
+ **/
+void
+iscsi_send_scsi_cmnd(struct iscsi_task *task)
+{
+	struct iscsi_scsi_cmd_hdr stsch;
+	struct iscsi_session *session = task->session;
+	struct scsi_cmnd *sc = task->scsi_cmnd;
+	int rc, first_sg = 0;
+	struct scatterlist tmpsg;
+	u32 imm_data_len = 0,  sg_offset = 0;
+
+	memset(&stsch, 0, sizeof(stsch));
+	if (test_bit(ISCSI_TASK_READ, &task->flags)) {
+		stsch.flags |= ISCSI_FLAG_CMD_READ;
+		stsch.data_length = htonl(sc->request_bufflen);
+	} else if (test_bit(ISCSI_TASK_WRITE, &task->flags)) {
+		stsch.flags |= ISCSI_FLAG_CMD_WRITE;
+		stsch.data_length = htonl(sc->request_bufflen);
+	}
+	/* tagged command queueing */
+	stsch.flags |= (iscsi_command_attr(sc) & ISCSI_FLAG_CMD_ATTR_MASK);
+	stsch.opcode = ISCSI_OP_SCSI_CMD;
+	stsch.itt = htonl(task->itt);
+	task->cmdsn = session->cmd_sn;
+	stsch.cmdsn = htonl(session->cmd_sn);
+	stsch.expstatsn = htonl(session->exp_stat_sn);
+	/*
+	 * set the final bit when there are no unsolicited Data-out
+	 * PDUs following the command PDU
+	 */
+	if (!test_bit(ISCSI_TASK_INITIAL_R2T, &task->flags))
+		stsch.flags |= ISCSI_FLAG_FINAL;
+	/* single level LUN format puts LUN in byte 1, 0 everywhere else */
+	stsch.lun[1] = sc->device->lun;
+	memcpy(stsch.scb, sc->cmnd, min_t(size_t, sizeof(stsch.scb),
+					  sc->cmd_len));
+
+	if (session->immediate_data &&
+	    sc->sc_data_direction == DMA_TO_DEVICE) {
+		if (!sc->request_bufflen)
+			/* zero len write? just let it timeout */
+			return;
+
+		imm_data_len = get_immediate_data_len(session, sc);
+		/* put the data length in the PDU header */
+		hton24(stsch.dlength, imm_data_len);
+		stsch.data_length = htonl(sc->request_bufflen);
+	}
+
+	rc = iscsi_send_header(session, (struct iscsi_hdr *)&stsch,
+			       session->header_digest);
+	if (rc != ISCSI_IO_SUCCESS) {
+		iscsi_host_err(session, "iscsi_send_scsi_cmnd failed to send "
+			       "scsi cmnd header\n");
+		iscsi_drop_session(session);
+		return;
+	}
+
+	if (!imm_data_len)
+		goto done;
+
+	if (sc->use_sg)
+		rc = iscsi_send_sg_data(session, sc->request_buffer,
+					&first_sg, &sg_offset, sc->use_sg,
+					imm_data_len, session->data_digest);
+	else {
+		sg_init_one(&tmpsg, sc->request_buffer, imm_data_len);
+		rc = iscsi_send_sg_data(session, &tmpsg, &first_sg,
+					&sg_offset, 1, imm_data_len,
+					session->data_digest);
+	}
+
+	if (rc != ISCSI_IO_SUCCESS) {
+		iscsi_host_err(session, "iscsi_send_scsi_cmnd failed to send "
+			       "scsi cmnd data (%u bytes)\n", imm_data_len);
+		if (rc != ISCSI_IO_INVALID_OP)
+			iscsi_drop_session(session);
+	}
+ done:
+	session->cmd_sn++;
+}

--------------010100000206020104080303--
