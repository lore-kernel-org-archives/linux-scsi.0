From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 10/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 15:04:08 -0800
Message-ID: <41E309E8.80105@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060900090500060104060407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2268 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262613AbVAJXEO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 18:04:14 -0500
Received: from [192.168.1.7] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j0AN4DoB025004
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 17:04:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060900090500060104060407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

functions to copy iscsi portal info and
a misc iscsi-protocol.h file which holds
defintitions using iscsi.h or will some
day be moved to iscsi.h.

--------------060900090500060104060407
Content-Type: text/x-patch;
 name="10-portal-helpers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10-portal-helpers.patch"

diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-portal.c scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-portal.c
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-portal.c	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-portal.c	2005-01-10 12:35:57.790300833 -0800
@@ -0,0 +1,104 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2001 Cisco Systems, Inc.
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
+ * Portal setup functions
+ */
+#include <linux/kernel.h>
+#include <linux/inet.h>
+#include <linux/in.h>
+
+#include "iscsi-session.h"
+#include "iscsi-ioctl.h"
+#include "iscsi-sfnet.h"
+
+/* caller must hold the session's portal_lock */
+void
+iscsi_set_portal_info(struct iscsi_session *session)
+{
+	/*
+	 * Set the session timeouts and iSCSI op params based on the portal's
+	 * settings. Don't change the address, since a termporary redirect may
+	 * have already changed the address, and we want to use the redirected
+	 * address rather than the portal's address.
+	 */
+	session->login_timeout = session->portal.login_timeout;
+	session->active_timeout = session->portal.active_timeout;
+	session->idle_timeout = session->portal.idle_timeout;
+	session->ping_timeout = session->portal.ping_timeout;
+	session->abort_timeout = session->portal.abort_timeout;
+	session->reset_timeout = session->portal.reset_timeout;
+	session->replacement_timeout = session->portal.replacement_timeout;
+
+	session->initial_r2t = session->portal.initial_r2t;
+	session->immediate_data = session->portal.immediate_data;
+	session->max_recv_data_segment_len =
+		session->portal.max_recv_data_segment_len;
+	session->first_burst_len = session->portal.first_burst_len;
+	session->max_burst_len = session->portal.max_burst_len;
+	session->def_time2wait = session->portal.def_time2wait;
+	session->def_time2retain = session->portal.def_time2retain;
+
+	session->header_digest = session->portal.header_digest;
+	session->data_digest = session->portal.data_digest;
+
+	session->portal_group_tag = session->portal.tag;
+
+	/* TCP options */
+	session->tcp_window_size = session->portal.tcp_window_size;
+	/* FIXME: type_of_service */
+}
+
+/* caller must hold the session's portal_lock */
+void
+iscsi_set_portal(struct iscsi_session *session)
+{
+	/* address */
+	memcpy(&session->addr, &session->portal.addr, sizeof(struct sockaddr));
+	/* timeouts, operational params, other settings */
+	iscsi_set_portal_info(session);
+}
+
+/*
+ * returns 1 if a relogin is required.
+ * caller must hold the session's portal_lock
+ */
+int
+iscsi_update_portal_info(struct iscsi_portal_info *old,
+			 struct iscsi_portal_info *new)
+{
+	int ret = 0;
+
+	/*
+	 * ping_timeout change requires a relogin because we ask the target to
+	 * use it as well with com.cisco.PingTimeout
+	 */
+	if (new->ping_timeout != old->ping_timeout ||
+	    new->initial_r2t != old->initial_r2t ||
+	    new->immediate_data != old->immediate_data ||
+	    new->max_recv_data_segment_len != old->max_recv_data_segment_len ||
+	    new->first_burst_len != old->first_burst_len ||
+	    new->max_burst_len != old->max_burst_len ||
+	    new->def_time2wait != old->def_time2wait ||
+	    new->def_time2retain != old->def_time2retain ||
+	    new->header_digest != old->header_digest ||
+	    new->data_digest != old->data_digest ||
+	    new->tcp_window_size != old->tcp_window_size)
+                ret = 1;
+
+	memcpy(old, new, sizeof(*old));
+	return ret;
+}
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-portal.h scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-portal.h
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-portal.h	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-portal.h	2005-01-10 12:35:57.791300704 -0800
@@ -0,0 +1,62 @@
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
+ * portal info structure used in ioctls and the kernel module
+ */
+#ifndef ISCSI_PORTAL_H_
+#define ISCSI_PORTAL_H_
+
+#include <linux/socket.h>
+
+struct iscsi_session;
+
+/*
+ * iscsi_portal_info - contains the values userspace had
+ * requested. This differs from the session duplicates
+ * as those are the values we negotiated with the target
+ */
+struct iscsi_portal_info {
+	int	login_timeout;
+	int	active_timeout;
+	int	idle_timeout;
+	int	ping_timeout;
+	int	abort_timeout;
+	int	reset_timeout;
+	int	replacement_timeout;
+	int	initial_r2t;
+	int	immediate_data;
+	int	max_recv_data_segment_len;
+	int	first_burst_len;
+	int	max_burst_len;
+	int	def_time2wait;
+	int	def_time2retain;
+	int	header_digest;
+	int	data_digest;
+	int	tag;
+	int	tcp_window_size;
+	int	type_of_service;
+	/* support ipv4 when we finish the interface */
+	struct sockaddr addr;
+};
+
+extern void iscsi_set_portal_info(struct iscsi_session *session);
+extern void iscsi_set_portal(struct iscsi_session *session);
+extern int iscsi_update_portal_info(struct iscsi_portal_info *old,
+				    struct iscsi_portal_info *new);
+#endif

--------------060900090500060104060407--
