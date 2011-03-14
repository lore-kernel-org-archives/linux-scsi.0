From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 06/12] iscsi-target: Add iSCSI Login Negotiation and Parameter logic
Date: Mon, 14 Mar 2011 04:57:03 -0700
Message-ID: <1300103829-10337-7-git-send-email-nab@linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.194]:35662 "HELO
	nm8-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754927Ab1CNL6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 07:58:00 -0400
In-Reply-To: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the princple RFC-3720 compatiable iSCSI Login
phase negotiation for iscsi_target_mod.  This also includes
the iscsi_thread_queue.[c,h] code call directly from iSCSI
login associated code.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_parameters.c   | 2054 +++++++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_parameters.h   |  271 ++++
 drivers/target/iscsi/iscsi_target_login.c | 1381 +++++++++++++++++++
 drivers/target/iscsi/iscsi_target_login.h |   14 +
 drivers/target/iscsi/iscsi_target_nego.c  | 1113 ++++++++++++++++
 drivers/target/iscsi/iscsi_target_nego.h  |   19 +
 drivers/target/iscsi/iscsi_thread_queue.c |  635 +++++++++
 drivers/target/iscsi/iscsi_thread_queue.h |  102 ++
 8 files changed, 5589 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_parameters.c
 create mode 100644 drivers/target/iscsi/iscsi_parameters.h
 create mode 100644 drivers/target/iscsi/iscsi_target_login.c
 create mode 100644 drivers/target/iscsi/iscsi_target_login.h
 create mode 100644 drivers/target/iscsi/iscsi_target_nego.c
 create mode 100644 drivers/target/iscsi/iscsi_target_nego.h
 create mode 100644 drivers/target/iscsi/iscsi_thread_queue.c
 create mode 100644 drivers/target/iscsi/iscsi_thread_queue.h

diff --git a/drivers/target/iscsi/iscsi_parameters.c b/drivers/target/i=
scsi/iscsi_parameters.c
new file mode 100644
index 0000000..9d7f088
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_parameters.c
@@ -0,0 +1,2054 @@
+/*********************************************************************=
**********
+ * This file contains main functions related to iSCSI Parameter negoti=
ation.
+ *
+ * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <linux/slab.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_util.h"
+#include "iscsi_parameters.h"
+
+/*	iscsi_login_rx_data():
+ *
+ *
+ */
+int iscsi_login_rx_data(
+	struct iscsi_conn *conn,
+	char *buf,
+	int length)
+{
+	int rx_got;
+	struct iovec iov;
+
+	memset(&iov, 0, sizeof(struct iovec));
+	iov.iov_len	=3D length;
+	iov.iov_base	=3D buf;
+
+	/*
+	 * Initial Marker-less Interval.
+	 * Add the values regardless of IFMarker/OFMarker, considering
+	 * it may not be negoitated yet.
+	 */
+	conn->of_marker +=3D length;
+
+	rx_got =3D rx_data(conn, &iov, 1, length);
+	if (rx_got !=3D length) {
+		printk(KERN_ERR "rx_data returned %d, expecting %d.\n",
+				rx_got, length);
+		return -1;
+	}
+
+	return 0 ;
+}
+
+/*	iscsi_login_tx_data():
+ *
+ *
+ */
+int iscsi_login_tx_data(
+	struct iscsi_conn *conn,
+	char *pdu_buf,
+	char *text_buf,
+	int text_length)
+{
+	int length, tx_sent;
+	struct iovec iov[2];
+
+	length =3D (ISCSI_HDR_LEN + text_length);
+
+	memset(&iov[0], 0, 2 * sizeof(struct iovec));
+	iov[0].iov_len		=3D ISCSI_HDR_LEN;
+	iov[0].iov_base		=3D pdu_buf;
+	iov[1].iov_len		=3D text_length;
+	iov[1].iov_base		=3D text_buf;
+
+	/*
+	 * Initial Marker-less Interval.
+	 * Add the values regardless of IFMarker/OFMarker, considering
+	 * it may not be negoitated yet.
+	 */
+	conn->if_marker +=3D length;
+
+	tx_sent =3D tx_data(conn, &iov[0], 2, length);
+	if (tx_sent !=3D length) {
+		printk(KERN_ERR "tx_data returned %d, expecting %d.\n",
+				tx_sent, length);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_dump_connection_ops():
+ *
+ *
+ */
+void iscsi_dump_conn_ops(struct iscsi_conn_ops *conn_ops)
+{
+	printk(KERN_INFO "HeaderDigest: %s\n", (conn_ops->HeaderDigest) ?
+				"CRC32C" : "None");
+	printk(KERN_INFO "DataDigest: %s\n", (conn_ops->DataDigest) ?
+				"CRC32C" : "None");
+	printk(KERN_INFO "MaxRecvDataSegmentLength: %u\n",
+				conn_ops->MaxRecvDataSegmentLength);
+	printk(KERN_INFO "OFMarker: %s\n", (conn_ops->OFMarker) ? "Yes" : "No=
");
+	printk(KERN_INFO "IFMarker: %s\n", (conn_ops->IFMarker) ? "Yes" : "No=
");
+	if (conn_ops->OFMarker)
+		printk(KERN_INFO "OFMarkInt: %u\n", conn_ops->OFMarkInt);
+	if (conn_ops->IFMarker)
+		printk(KERN_INFO "IFMarkInt: %u\n", conn_ops->IFMarkInt);
+}
+
+/*	iscsi_dump_session_ops():
+ *
+ *
+ */
+void iscsi_dump_sess_ops(struct iscsi_sess_ops *sess_ops)
+{
+	printk(KERN_INFO "InitiatorName: %s\n", sess_ops->InitiatorName);
+	printk(KERN_INFO "InitiatorAlias: %s\n", sess_ops->InitiatorAlias);
+	printk(KERN_INFO "TargetName: %s\n", sess_ops->TargetName);
+	printk(KERN_INFO "TargetAlias: %s\n", sess_ops->TargetAlias);
+	printk(KERN_INFO "TargetPortalGroupTag: %hu\n",
+			sess_ops->TargetPortalGroupTag);
+	printk(KERN_INFO "MaxConnections: %hu\n", sess_ops->MaxConnections);
+	printk(KERN_INFO "InitialR2T: %s\n",
+			(sess_ops->InitialR2T) ? "Yes" : "No");
+	printk(KERN_INFO "ImmediateData: %s\n", (sess_ops->ImmediateData) ?
+			"Yes" : "No");
+	printk(KERN_INFO "MaxBurstLength: %u\n", sess_ops->MaxBurstLength);
+	printk(KERN_INFO "FirstBurstLength: %u\n", sess_ops->FirstBurstLength=
);
+	printk(KERN_INFO "DefaultTime2Wait: %hu\n", sess_ops->DefaultTime2Wai=
t);
+	printk(KERN_INFO "DefaultTime2Retain: %hu\n",
+			sess_ops->DefaultTime2Retain);
+	printk(KERN_INFO "MaxOutstandingR2T: %hu\n",
+			sess_ops->MaxOutstandingR2T);
+	printk(KERN_INFO "DataPDUInOrder: %s\n",
+			(sess_ops->DataPDUInOrder) ? "Yes" : "No");
+	printk(KERN_INFO "DataSequenceInOrder: %s\n",
+			(sess_ops->DataSequenceInOrder) ? "Yes" : "No");
+	printk(KERN_INFO "ErrorRecoveryLevel: %hu\n",
+			sess_ops->ErrorRecoveryLevel);
+	printk(KERN_INFO "SessionType: %s\n", (sess_ops->SessionType) ?
+			"Discovery" : "Normal");
+}
+
+/*	iscsi_print_params():
+ *
+ *
+ */
+void iscsi_print_params(struct iscsi_param_list *param_list)
+{
+	struct iscsi_param *param;
+
+	list_for_each_entry(param, &param_list->param_list, p_list)
+		printk(KERN_INFO "%s: %s\n", param->name, param->value);
+}
+
+/*	iscsi_set_default_param():
+ *
+ *
+ */
+static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_=
list *param_list,
+		char *name, char *value, u8 phase, u8 scope, u8 sender,
+		u16 type_range, u8 use)
+{
+	struct iscsi_param *param =3D NULL;
+
+	param =3D kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
+	if (!(param)) {
+		printk(KERN_ERR "Unable to allocate memory for parameter.\n");
+		goto out;
+	}
+	INIT_LIST_HEAD(&param->p_list);
+
+	param->name =3D kzalloc(strlen(name) + 1, GFP_KERNEL);
+	if (!(param->name)) {
+		printk(KERN_ERR "Unable to allocate memory for parameter name.\n");
+		goto out;
+	}
+
+	param->value =3D kzalloc(strlen(value) + 1, GFP_KERNEL);
+	if (!(param->value)) {
+		printk(KERN_ERR "Unable to allocate memory for parameter value.\n");
+		goto out;
+	}
+
+	memcpy(param->name, name, strlen(name));
+	param->name[strlen(name)] =3D '\0';
+	memcpy(param->value, value, strlen(value));
+	param->value[strlen(value)] =3D '\0';
+	param->phase		=3D phase;
+	param->scope		=3D scope;
+	param->sender		=3D sender;
+	param->use		=3D use;
+	param->type_range	=3D type_range;
+
+	switch (param->type_range) {
+	case TYPERANGE_BOOL_AND:
+		param->type =3D TYPE_BOOL_AND;
+		break;
+	case TYPERANGE_BOOL_OR:
+		param->type =3D TYPE_BOOL_OR;
+		break;
+	case TYPERANGE_0_TO_2:
+	case TYPERANGE_0_TO_3600:
+	case TYPERANGE_0_TO_32767:
+	case TYPERANGE_0_TO_65535:
+	case TYPERANGE_1_TO_65535:
+	case TYPERANGE_2_TO_3600:
+	case TYPERANGE_512_TO_16777215:
+		param->type =3D TYPE_NUMBER;
+		break;
+	case TYPERANGE_AUTH:
+	case TYPERANGE_DIGEST:
+		param->type =3D TYPE_VALUE_LIST | TYPE_STRING;
+		break;
+	case TYPERANGE_MARKINT:
+		param->type =3D TYPE_NUMBER_RANGE;
+		param->type_range |=3D TYPERANGE_1_TO_65535;
+		break;
+	case TYPERANGE_ISCSINAME:
+	case TYPERANGE_SESSIONTYPE:
+	case TYPERANGE_TARGETADDRESS:
+	case TYPERANGE_UTF8:
+		param->type =3D TYPE_STRING;
+		break;
+	default:
+		printk(KERN_ERR "Unknown type_range 0x%02x\n",
+				param->type_range);
+		goto out;
+	}
+	list_add_tail(&param->p_list, &param_list->param_list);
+
+	return param;
+out:
+	if (param) {
+		kfree(param->value);
+		kfree(param->name);
+		kfree(param);
+	}
+
+	return NULL;
+}
+
+/*	iscsi_set_default_params():
+ *
+ *
+ */
+/* #warning Add extension keys */
+int iscsi_create_default_params(struct iscsi_param_list **param_list_p=
tr)
+{
+	struct iscsi_param *param =3D NULL;
+	struct iscsi_param_list *pl;
+
+	pl =3D kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
+	if (!(pl)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_param_list.\n");
+		return -1 ;
+	}
+	INIT_LIST_HEAD(&pl->param_list);
+	INIT_LIST_HEAD(&pl->extra_response_list);
+
+	/*
+	 * The format for setting the initial parameter definitions are:
+	 *
+	 * Parameter name:
+	 * Initial value:
+	 * Allowable phase:
+	 * Scope:
+	 * Allowable senders:
+	 * Typerange:
+	 * Use:
+	 */
+	param =3D iscsi_set_default_param(pl, AUTHMETHOD, INITIAL_AUTHMETHOD,
+			PHASE_SECURITY, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_AUTH, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, HEADERDIGEST, INITIAL_HEADERDIG=
EST,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_DIGEST, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, DATADIGEST, INITIAL_DATADIGEST,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_DIGEST, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, MAXCONNECTIONS,
+			INITIAL_MAXCONNECTIONS, PHASE_OPERATIONAL,
+			SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_1_TO_65535, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, SENDTARGETS, INITIAL_SENDTARGET=
S,
+			PHASE_FFP0, SCOPE_SESSION_WIDE, SENDER_INITIATOR,
+			TYPERANGE_UTF8, 0);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, TARGETNAME, INITIAL_TARGETNAME,
+			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_ISCSINAME, USE_ALL);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, INITIATORNAME,
+			INITIAL_INITIATORNAME, PHASE_DECLARATIVE,
+			SCOPE_SESSION_WIDE, SENDER_INITIATOR,
+			TYPERANGE_ISCSINAME, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, TARGETALIAS, INITIAL_TARGETALIA=
S,
+			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_TARGET,
+			TYPERANGE_UTF8, USE_ALL);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, INITIATORALIAS,
+			INITIAL_INITIATORALIAS, PHASE_DECLARATIVE,
+			SCOPE_SESSION_WIDE, SENDER_INITIATOR, TYPERANGE_UTF8,
+			USE_ALL);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, TARGETADDRESS,
+			INITIAL_TARGETADDRESS, PHASE_DECLARATIVE,
+			SCOPE_SESSION_WIDE, SENDER_TARGET,
+			TYPERANGE_TARGETADDRESS, USE_ALL);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, TARGETPORTALGROUPTAG,
+			INITIAL_TARGETPORTALGROUPTAG,
+			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_TARGET,
+			TYPERANGE_0_TO_65535, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, INITIALR2T, INITIAL_INITIALR2T,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_BOOL_OR, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, IMMEDIATEDATA,
+			INITIAL_IMMEDIATEDATA, PHASE_OPERATIONAL,
+			SCOPE_SESSION_WIDE, SENDER_BOTH, TYPERANGE_BOOL_AND,
+			USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, MAXRECVDATASEGMENTLENGTH,
+			INITIAL_MAXRECVDATASEGMENTLENGTH,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_512_TO_16777215, USE_ALL);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, MAXBURSTLENGTH,
+			INITIAL_MAXBURSTLENGTH, PHASE_OPERATIONAL,
+			SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_512_TO_16777215, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, FIRSTBURSTLENGTH,
+			INITIAL_FIRSTBURSTLENGTH,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_512_TO_16777215, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, DEFAULTTIME2WAIT,
+			INITIAL_DEFAULTTIME2WAIT,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_0_TO_3600, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, DEFAULTTIME2RETAIN,
+			INITIAL_DEFAULTTIME2RETAIN,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_0_TO_3600, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, MAXOUTSTANDINGR2T,
+			INITIAL_MAXOUTSTANDINGR2T,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_1_TO_65535, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, DATAPDUINORDER,
+			INITIAL_DATAPDUINORDER, PHASE_OPERATIONAL,
+			SCOPE_SESSION_WIDE, SENDER_BOTH, TYPERANGE_BOOL_OR,
+			USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, DATASEQUENCEINORDER,
+			INITIAL_DATASEQUENCEINORDER,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_BOOL_OR, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, ERRORRECOVERYLEVEL,
+			INITIAL_ERRORRECOVERYLEVEL,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_0_TO_2, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, SESSIONTYPE, INITIAL_SESSIONTYP=
E,
+			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_INITIATOR,
+			TYPERANGE_SESSIONTYPE, USE_LEADING_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, IFMARKER, INITIAL_IFMARKER,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_BOOL_AND, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, OFMARKER, INITIAL_OFMARKER,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_BOOL_AND, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, IFMARKINT, INITIAL_IFMARKINT,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_MARKINT, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	param =3D iscsi_set_default_param(pl, OFMARKINT, INITIAL_OFMARKINT,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_MARKINT, USE_INITIAL_ONLY);
+	if (!(param))
+		goto out;
+
+	*param_list_ptr =3D pl;
+	return 0;
+out:
+	iscsi_release_param_list(pl);
+	return -1;
+}
+
+/*	iscsi_set_keys_to_negotiate():
+ *
+ *
+ */
+int iscsi_set_keys_to_negotiate(
+	int sessiontype,
+	struct iscsi_param_list *param_list)
+{
+	struct iscsi_param *param;
+
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		param->state =3D 0;
+		if (!strcmp(param->name, AUTHMETHOD)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, HEADERDIGEST)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, DATADIGEST)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, MAXCONNECTIONS)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, TARGETNAME)) {
+			continue;
+		} else if (!strcmp(param->name, INITIATORNAME)) {
+			continue;
+		} else if (!strcmp(param->name, TARGETALIAS)) {
+			if (param->value)
+				SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, INITIATORALIAS)) {
+			continue;
+		} else if (!strcmp(param->name, TARGETPORTALGROUPTAG)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, INITIALR2T)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, IMMEDIATEDATA)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, MAXBURSTLENGTH)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, FIRSTBURSTLENGTH)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, DEFAULTTIME2WAIT)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, DEFAULTTIME2RETAIN)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, MAXOUTSTANDINGR2T)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, DATAPDUINORDER)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, DATASEQUENCEINORDER)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, ERRORRECOVERYLEVEL)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, SESSIONTYPE)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, IFMARKER)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, OFMARKER)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, IFMARKINT)) {
+			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, OFMARKINT)) {
+			SET_PSTATE_NEGOTIATE(param);
+		}
+	}
+
+	return 0;
+}
+
+/*	iscsi_set_keys_irrelevant_for_discovery():
+ *
+ *
+ */
+int iscsi_set_keys_irrelevant_for_discovery(
+	struct iscsi_param_list *param_list)
+{
+	struct iscsi_param *param;
+
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (!strcmp(param->name, MAXCONNECTIONS))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, INITIALR2T))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, IMMEDIATEDATA))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, MAXBURSTLENGTH))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, FIRSTBURSTLENGTH))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, MAXOUTSTANDINGR2T))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, DATAPDUINORDER))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, DATASEQUENCEINORDER))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, ERRORRECOVERYLEVEL))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, DEFAULTTIME2WAIT))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, DEFAULTTIME2RETAIN))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, IFMARKER))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, OFMARKER))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, IFMARKINT))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, OFMARKINT))
+			param->state &=3D ~PSTATE_NEGOTIATE;
+	}
+
+	return 0;
+}
+
+/*	iscsi_copy_param_list():
+ *
+ *
+ */
+int iscsi_copy_param_list(
+	struct iscsi_param_list **dst_param_list,
+	struct iscsi_param_list *src_param_list,
+	int leading)
+{
+	struct iscsi_param *new_param =3D NULL, *param =3D NULL;
+	struct iscsi_param_list *param_list =3D NULL;
+
+	param_list =3D kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
+	if (!(param_list)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_param_list.\n");
+		goto err_out;
+	}
+	INIT_LIST_HEAD(&param_list->param_list);
+	INIT_LIST_HEAD(&param_list->extra_response_list);
+
+	list_for_each_entry(param, &src_param_list->param_list, p_list) {
+		if (!leading && (param->scope & SCOPE_SESSION_WIDE)) {
+			if ((strcmp(param->name, "TargetName") !=3D 0) &&
+			    (strcmp(param->name, "InitiatorName") !=3D 0) &&
+			    (strcmp(param->name, "TargetPortalGroupTag") !=3D 0))
+				continue;
+		}
+
+		new_param =3D kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
+		if (!(new_param)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_param.\n");
+			goto err_out;
+		}
+
+		new_param->set_param =3D param->set_param;
+		new_param->phase =3D param->phase;
+		new_param->scope =3D param->scope;
+		new_param->sender =3D param->sender;
+		new_param->type =3D param->type;
+		new_param->use =3D param->use;
+		new_param->type_range =3D param->type_range;
+
+		new_param->name =3D kzalloc(strlen(param->name) + 1, GFP_KERNEL);
+		if (!(new_param->name)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" parameter name.\n");
+			goto err_out;
+		}
+
+		new_param->value =3D kzalloc(strlen(param->value) + 1,
+				GFP_KERNEL);
+		if (!(new_param->value)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" parameter value.\n");
+			goto err_out;
+		}
+
+		memcpy(new_param->name, param->name, strlen(param->name));
+		new_param->name[strlen(param->name)] =3D '\0';
+		memcpy(new_param->value, param->value, strlen(param->value));
+		new_param->value[strlen(param->value)] =3D '\0';
+
+		list_add_tail(&new_param->p_list, &param_list->param_list);
+	}
+
+	if (!(list_empty(&param_list->param_list)))
+		*dst_param_list =3D param_list;
+	else {
+		printk(KERN_ERR "No parameters allocated.\n");
+		goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	iscsi_release_param_list(param_list);
+	return -1;
+}
+
+/*	iscsi_release_extra_responses():
+ *
+ *
+ */
+static void iscsi_release_extra_responses(struct iscsi_param_list *par=
am_list)
+{
+	struct iscsi_extra_response *er, *er_tmp;
+
+	list_for_each_entry_safe(er, er_tmp, &param_list->extra_response_list=
,
+			er_list) {
+		list_del(&er->er_list);
+		kfree(er);
+	}
+}
+
+/*	iscsi_release_param_list():
+ *
+ *
+ */
+void iscsi_release_param_list(struct iscsi_param_list *param_list)
+{
+	struct iscsi_param *param, *param_tmp;
+
+	list_for_each_entry_safe(param, param_tmp, &param_list->param_list,
+			p_list) {
+		list_del(&param->p_list);
+
+		kfree(param->name);
+		param->name =3D NULL;
+		kfree(param->value);
+		param->value =3D NULL;
+		kfree(param);
+		param =3D NULL;
+	}
+
+	iscsi_release_extra_responses(param_list);
+
+	kfree(param_list);
+}
+
+/*	iscsi_find_param_from_key():
+ *
+ *
+ */
+struct iscsi_param *iscsi_find_param_from_key(
+	char *key,
+	struct iscsi_param_list *param_list)
+{
+	struct iscsi_param *param;
+
+	if (!key || !param_list) {
+		printk(KERN_ERR "Key or parameter list pointer is NULL.\n");
+		return NULL;
+	}
+
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (!strcmp(key, param->name))
+			break;
+	}
+
+	if (!param) {
+		printk(KERN_ERR "Unable to locate key \"%s\".\n", key);
+		return NULL;
+	}
+
+	return param;
+}
+
+/*	iscsi_extract_key_value():
+ *
+ *
+ */
+int iscsi_extract_key_value(char *textbuf, char **key, char **value)
+{
+	*value =3D strchr(textbuf, '=3D');
+	if (!(*value)) {
+		printk(KERN_ERR "Unable to locate \"=3D\" seperator for key,"
+				" ignoring request.\n");
+		return -1;
+	}
+
+	*key =3D textbuf;
+	**value =3D '\0';
+	*value =3D *value + 1;
+
+	return 0;
+}
+
+/*	iscsi_update_param_value():
+ *
+ *
+ */
+int iscsi_update_param_value(struct iscsi_param *param, char *value)
+{
+	kfree(param->value);
+
+	param->value =3D kzalloc(strlen(value) + 1, GFP_KERNEL);
+	if (!(param->value)) {
+		printk(KERN_ERR "Unable to allocate memory for value.\n");
+		return -1;
+	}
+
+	memcpy(param->value, value, strlen(value));
+	param->value[strlen(value)] =3D '\0';
+
+	TRACE(TRACE_PARAM, "iSCSI Parameter updated to %s=3D%s\n",
+			param->name, param->value);
+	return 0;
+}
+
+/*	iscsi_add_notunderstood_response():
+ *
+ *
+ */
+static int iscsi_add_notunderstood_response(
+	char *key,
+	char *value,
+	struct iscsi_param_list *param_list)
+{
+	struct iscsi_extra_response *extra_response;
+
+	if (strlen(value) > MAX_KEY_VALUE_LENGTH) {
+		printk(KERN_ERR "Value for notunderstood key \"%s\" exceeds %d,"
+			" protocol error.\n", key, MAX_KEY_VALUE_LENGTH);
+		return -1;
+	}
+
+	extra_response =3D kzalloc(sizeof(struct iscsi_extra_response), GFP_K=
ERNEL);
+	if (!(extra_response)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+			" struct iscsi_extra_response.\n");
+		return -1;
+	}
+	INIT_LIST_HEAD(&extra_response->er_list);
+
+	strncpy(extra_response->key, key, strlen(key) + 1);
+	strncpy(extra_response->value, NOTUNDERSTOOD,
+			strlen(NOTUNDERSTOOD) + 1);
+
+	list_add_tail(&extra_response->er_list,
+			&param_list->extra_response_list);
+	return 0;
+}
+
+/*	iscsi_check_for_auth_key():
+ *
+ *
+ */
+static int iscsi_check_for_auth_key(char *key)
+{
+	/*
+	 * RFC 1994
+	 */
+	if (!strcmp(key, "CHAP_A") || !strcmp(key, "CHAP_I") ||
+	    !strcmp(key, "CHAP_C") || !strcmp(key, "CHAP_N") ||
+	    !strcmp(key, "CHAP_R"))
+		return 1;
+
+	/*
+	 * RFC 2945
+	 */
+	if (!strcmp(key, "SRP_U") || !strcmp(key, "SRP_N") ||
+	    !strcmp(key, "SRP_g") || !strcmp(key, "SRP_s") ||
+	    !strcmp(key, "SRP_A") || !strcmp(key, "SRP_B") ||
+	    !strcmp(key, "SRP_M") || !strcmp(key, "SRP_HM"))
+		return 1;
+
+	return 0;
+}
+
+/*	iscsi_check_proposer_for_optional_reply():
+ *
+ *
+ */
+static void iscsi_check_proposer_for_optional_reply(struct iscsi_param=
 *param)
+{
+	if (IS_TYPE_BOOL_AND(param)) {
+		if (!strcmp(param->value, NO))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+	} else if (IS_TYPE_BOOL_OR(param)) {
+		if (!strcmp(param->value, YES))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+		 /*
+		  * Required for gPXE iSCSI boot client
+		  */
+		if (!strcmp(param->name, IMMEDIATEDATA))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+	} else if (IS_TYPE_NUMBER(param)) {
+		if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+		/*
+		 * The GlobalSAN iSCSI Initiator for MacOSX does
+		 * not respond to MaxBurstLength, FirstBurstLength,
+		 * DefaultTime2Wait or DefaultTime2Retain parameter keys.
+		 * So, we set them to 'reply optional' here, and assume the
+		 * the defaults from iscsi_parameters.h if the initiator
+		 * is not RFC compliant and the keys are not negotiated.
+		 */
+		if (!strcmp(param->name, MAXBURSTLENGTH))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+		if (!strcmp(param->name, FIRSTBURSTLENGTH))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+		if (!strcmp(param->name, DEFAULTTIME2WAIT))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+		if (!strcmp(param->name, DEFAULTTIME2RETAIN))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+		/*
+		 * Required for gPXE iSCSI boot client
+		 */
+		if (!strcmp(param->name, MAXCONNECTIONS))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+	} else if (IS_PHASE_DECLARATIVE(param))
+		SET_PSTATE_REPLY_OPTIONAL(param);
+}
+
+/*	iscsi_check_boolean_value():
+ *
+ *
+ */
+static int iscsi_check_boolean_value(struct iscsi_param *param, char *=
value)
+{
+	if (strcmp(value, YES) && strcmp(value, NO)) {
+		printk(KERN_ERR "Illegal value for \"%s\", must be either"
+			" \"%s\" or \"%s\".\n", param->name, YES, NO);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_check_numerical_value():
+ *
+ *
+ */
+static int iscsi_check_numerical_value(struct iscsi_param *param, char=
 *value_ptr)
+{
+	char *tmpptr;
+	int value =3D 0;
+
+	value =3D simple_strtoul(value_ptr, &tmpptr, 0);
+
+/* #warning FIXME: Fix this */
+#if 0
+	if (strspn(endptr, WHITE_SPACE) !=3D strlen(endptr)) {
+		printk(KERN_ERR "Illegal value \"%s\" for \"%s\".\n",
+			value, param->name);
+		return -1;
+	}
+#endif
+	if (IS_TYPERANGE_0_TO_2(param)) {
+		if ((value < 0) || (value > 2)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" between 0 and 2.\n", param->name);
+			return -1;
+		}
+		return 0;
+	}
+	if (IS_TYPERANGE_0_TO_3600(param)) {
+		if ((value < 0) || (value > 3600)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" between 0 and 3600.\n", param->name);
+			return -1;
+		}
+		return 0;
+	}
+	if (IS_TYPERANGE_0_TO_32767(param)) {
+		if ((value < 0) || (value > 32767)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" between 0 and 32767.\n", param->name);
+			return -1;
+		}
+		return 0;
+	}
+	if (IS_TYPERANGE_0_TO_65535(param)) {
+		if ((value < 0) || (value > 65535)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" between 0 and 65535.\n", param->name);
+			return -1;
+		}
+		return 0;
+	}
+	if (IS_TYPERANGE_1_TO_65535(param)) {
+		if ((value < 1) || (value > 65535)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" between 1 and 65535.\n", param->name);
+			return -1;
+		}
+		return 0;
+	}
+	if (IS_TYPERANGE_2_TO_3600(param)) {
+		if ((value < 2) || (value > 3600)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" between 2 and 3600.\n", param->name);
+			return -1;
+		}
+		return 0;
+	}
+	if (IS_TYPERANGE_512_TO_16777215(param)) {
+		if ((value < 512) || (value > 16777215)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" between 512 and 16777215.\n", param->name);
+			return -1;
+		}
+		return 0;
+	}
+
+	return 0;
+}
+
+/*	iscsi_check_numerical_range_value():
+ *
+ *
+ */
+static int iscsi_check_numerical_range_value(struct iscsi_param *param=
, char *value)
+{
+	char *left_val_ptr =3D NULL, *right_val_ptr =3D NULL;
+	char *tilde_ptr =3D NULL, *tmp_ptr =3D NULL;
+	u32 left_val, right_val, local_left_val, local_right_val;
+
+	if ((strcmp(param->name, IFMARKINT)) &&
+			(strcmp(param->name, OFMARKINT))) {
+		printk(KERN_ERR "Only parameters \"%s\" or \"%s\" may contain a"
+			" numerical range value.\n", IFMARKINT, OFMARKINT);
+		return -1;
+	}
+
+	if (IS_PSTATE_PROPOSER(param))
+		return 0;
+
+	tilde_ptr =3D strchr(value, '~');
+	if (!(tilde_ptr)) {
+		printk(KERN_ERR "Unable to locate numerical range indicator"
+			" \"~\" for \"%s\".\n", param->name);
+		return -1;
+	}
+	*tilde_ptr =3D '\0';
+
+	left_val_ptr =3D value;
+	right_val_ptr =3D value + strlen(left_val_ptr) + 1;
+
+	if (iscsi_check_numerical_value(param, left_val_ptr) < 0)
+		return -1;
+	if (iscsi_check_numerical_value(param, right_val_ptr) < 0)
+		return -1;
+
+	left_val =3D simple_strtoul(left_val_ptr, &tmp_ptr, 0);
+	right_val =3D simple_strtoul(right_val_ptr, &tmp_ptr, 0);
+	*tilde_ptr =3D '~';
+
+	if (right_val < left_val) {
+		printk(KERN_ERR "Numerical range for parameter \"%s\" contains"
+			" a right value which is less than the left.\n",
+				param->name);
+		return -1;
+	}
+
+	/*
+	 * For now,  enforce reasonable defaults for [I,O]FMarkInt.
+	 */
+	tilde_ptr =3D strchr(param->value, '~');
+	if (!(tilde_ptr)) {
+		printk(KERN_ERR "Unable to locate numerical range indicator"
+			" \"~\" for \"%s\".\n", param->name);
+		return -1;
+	}
+	*tilde_ptr =3D '\0';
+
+	left_val_ptr =3D param->value;
+	right_val_ptr =3D param->value + strlen(left_val_ptr) + 1;
+
+	local_left_val =3D simple_strtoul(left_val_ptr, &tmp_ptr, 0);
+	local_right_val =3D simple_strtoul(right_val_ptr, &tmp_ptr, 0);
+	*tilde_ptr =3D '~';
+
+	if (param->set_param) {
+		if ((left_val < local_left_val) ||
+		    (right_val < local_left_val)) {
+			printk(KERN_ERR "Passed value range \"%u~%u\" is below"
+				" minimum left value \"%u\" for key \"%s\","
+				" rejecting.\n", left_val, right_val,
+				local_left_val, param->name);
+			return -1;
+		}
+	} else {
+		if ((left_val < local_left_val) &&
+		    (right_val < local_left_val)) {
+			printk(KERN_ERR "Received value range \"%u~%u\" is"
+				" below minimum left value \"%u\" for key"
+				" \"%s\", rejecting.\n", left_val, right_val,
+				local_left_val, param->name);
+			SET_PSTATE_REJECT(param);
+			if (iscsi_update_param_value(param, REJECT) < 0)
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*	iscsi_check_string_or_list_value():
+ *
+ *
+ */
+static int iscsi_check_string_or_list_value(struct iscsi_param *param,=
 char *value)
+{
+	if (IS_PSTATE_PROPOSER(param))
+		return 0;
+
+	if (IS_TYPERANGE_AUTH_PARAM(param)) {
+		if (strcmp(value, KRB5) && strcmp(value, SPKM1) &&
+		    strcmp(value, SPKM2) && strcmp(value, SRP) &&
+		    strcmp(value, CHAP) && strcmp(value, NONE)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" \"%s\", \"%s\", \"%s\", \"%s\", \"%s\""
+				" or \"%s\".\n", param->name, KRB5,
+					SPKM1, SPKM2, SRP, CHAP, NONE);
+			return -1;
+		}
+	}
+	if (IS_TYPERANGE_DIGEST_PARAM(param)) {
+		if (strcmp(value, CRC32C) && strcmp(value, NONE)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" \"%s\" or \"%s\".\n", param->name,
+					CRC32C, NONE);
+			return -1;
+		}
+	}
+	if (IS_TYPERANGE_SESSIONTYPE(param)) {
+		if (strcmp(value, DISCOVERY) && strcmp(value, NORMAL)) {
+			printk(KERN_ERR "Illegal value for \"%s\", must be"
+				" \"%s\" or \"%s\".\n", param->name,
+					DISCOVERY, NORMAL);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*	iscsi_get_value_from_number_range():
+ *
+ *	This function is used to pick a value range number,  currently just
+ *	returns the lesser of both right values.
+ */
+static char *iscsi_get_value_from_number_range(
+	struct iscsi_param *param,
+	char *value)
+{
+	char *end_ptr, *tilde_ptr1 =3D NULL, *tilde_ptr2 =3D NULL;
+	u32 acceptor_right_value, proposer_right_value;
+
+	tilde_ptr1 =3D strchr(value, '~');
+	if (!(tilde_ptr1))
+		return NULL;
+	*tilde_ptr1++ =3D '\0';
+	proposer_right_value =3D simple_strtoul(tilde_ptr1, &end_ptr, 0);
+
+	tilde_ptr2 =3D strchr(param->value, '~');
+	if (!(tilde_ptr2))
+		return NULL;
+	*tilde_ptr2++ =3D '\0';
+	acceptor_right_value =3D simple_strtoul(tilde_ptr2, &end_ptr, 0);
+
+	return (acceptor_right_value >=3D proposer_right_value) ?
+		tilde_ptr1 : tilde_ptr2;
+}
+
+/*	iscsi_check_valuelist_for_support():
+ *
+ *
+ */
+static char *iscsi_check_valuelist_for_support(
+	struct iscsi_param *param,
+	char *value)
+{
+	char *tmp1 =3D NULL, *tmp2 =3D NULL;
+	char *acceptor_values =3D NULL, *proposer_values =3D NULL;
+
+	acceptor_values =3D param->value;
+	proposer_values =3D value;
+
+	do {
+		if (!proposer_values)
+			return NULL;
+		tmp1 =3D strchr(proposer_values, ',');
+		if ((tmp1))
+			*tmp1 =3D '\0';
+		acceptor_values =3D param->value;
+		do {
+			if (!acceptor_values) {
+				if (tmp1)
+					*tmp1 =3D ',';
+				return NULL;
+			}
+			tmp2 =3D strchr(acceptor_values, ',');
+			if ((tmp2))
+				*tmp2 =3D '\0';
+			if (!acceptor_values || !proposer_values) {
+				if (tmp1)
+					*tmp1 =3D ',';
+				if (tmp2)
+					*tmp2 =3D ',';
+				return NULL;
+			}
+			if (!strcmp(acceptor_values, proposer_values)) {
+				if (tmp2)
+					*tmp2 =3D ',';
+				goto out;
+			}
+			if (tmp2)
+				*tmp2++ =3D ',';
+
+			acceptor_values =3D tmp2;
+			if (!acceptor_values)
+				break;
+		} while (acceptor_values);
+		if (tmp1)
+			*tmp1++ =3D ',';
+		proposer_values =3D tmp1;
+	} while (proposer_values);
+
+out:
+	return proposer_values;
+}
+
+/*	iscsi_check_acceptor_state():
+ *
+ *
+ */
+static int iscsi_check_acceptor_state(struct iscsi_param *param, char =
*value)
+{
+	u8 acceptor_boolean_value =3D 0, proposer_boolean_value =3D 0;
+	char *negoitated_value =3D NULL;
+
+	if (IS_PSTATE_ACCEPTOR(param)) {
+		printk(KERN_ERR "Received key \"%s\" twice, protocol error.\n",
+				param->name);
+		return -1;
+	}
+
+	if (IS_PSTATE_REJECT(param))
+		return 0;
+
+	if (IS_TYPE_BOOL_AND(param)) {
+		if (!strcmp(value, YES))
+			proposer_boolean_value =3D 1;
+		if (!strcmp(param->value, YES))
+			acceptor_boolean_value =3D 1;
+		if (acceptor_boolean_value && proposer_boolean_value)
+			do {} while (0);
+		else {
+			if (iscsi_update_param_value(param, NO) < 0)
+				return -1;
+			if (!proposer_boolean_value)
+				SET_PSTATE_REPLY_OPTIONAL(param);
+		}
+	} else if (IS_TYPE_BOOL_OR(param)) {
+		if (!strcmp(value, YES))
+			proposer_boolean_value =3D 1;
+		if (!strcmp(param->value, YES))
+			acceptor_boolean_value =3D 1;
+		if (acceptor_boolean_value || proposer_boolean_value) {
+			if (iscsi_update_param_value(param, YES) < 0)
+				return -1;
+			if (proposer_boolean_value)
+				SET_PSTATE_REPLY_OPTIONAL(param);
+		}
+	} else if (IS_TYPE_NUMBER(param)) {
+		char *tmpptr, buf[10];
+		u32 acceptor_value =3D simple_strtoul(param->value, &tmpptr, 0);
+		u32 proposer_value =3D simple_strtoul(value, &tmpptr, 0);
+
+		memset(buf, 0, 10);
+
+		if (!strcmp(param->name, MAXCONNECTIONS) ||
+		    !strcmp(param->name, MAXBURSTLENGTH) ||
+		    !strcmp(param->name, FIRSTBURSTLENGTH) ||
+		    !strcmp(param->name, MAXOUTSTANDINGR2T) ||
+		    !strcmp(param->name, DEFAULTTIME2RETAIN) ||
+		    !strcmp(param->name, ERRORRECOVERYLEVEL)) {
+			if (proposer_value > acceptor_value) {
+				sprintf(buf, "%u", acceptor_value);
+				if (iscsi_update_param_value(param,
+						&buf[0]) < 0)
+					return -1;
+			} else {
+				if (iscsi_update_param_value(param, value) < 0)
+					return -1;
+			}
+		} else if (!strcmp(param->name, DEFAULTTIME2WAIT)) {
+			if (acceptor_value > proposer_value) {
+				sprintf(buf, "%u", acceptor_value);
+				if (iscsi_update_param_value(param,
+						&buf[0]) < 0)
+					return -1;
+			} else {
+				if (iscsi_update_param_value(param, value) < 0)
+					return -1;
+			}
+		} else {
+			if (iscsi_update_param_value(param, value) < 0)
+				return -1;
+		}
+
+		if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH))
+			SET_PSTATE_REPLY_OPTIONAL(param);
+	} else if (IS_TYPE_NUMBER_RANGE(param)) {
+		negoitated_value =3D iscsi_get_value_from_number_range(
+					param, value);
+		if (!(negoitated_value))
+			return -1;
+		if (iscsi_update_param_value(param, negoitated_value) < 0)
+			return -1;
+	} else if (IS_TYPE_VALUE_LIST(param)) {
+		negoitated_value =3D iscsi_check_valuelist_for_support(
+					param, value);
+		if (!(negoitated_value)) {
+			printk(KERN_ERR "Proposer's value list \"%s\" contains"
+				" no valid values from Acceptor's value list"
+				" \"%s\".\n", value, param->value);
+			return -1;
+		}
+		if (iscsi_update_param_value(param, negoitated_value) < 0)
+			return -1;
+	} else if (IS_PHASE_DECLARATIVE(param)) {
+		if (iscsi_update_param_value(param, value) < 0)
+			return -1;
+		SET_PSTATE_REPLY_OPTIONAL(param);
+	}
+
+	return 0;
+}
+
+/*	iscsi_check_proposer_state():
+ *
+ *
+ */
+static int iscsi_check_proposer_state(struct iscsi_param *param, char =
*value)
+{
+	if (IS_PSTATE_RESPONSE_GOT(param)) {
+		printk(KERN_ERR "Received key \"%s\" twice, protocol error.\n",
+				param->name);
+		return -1;
+	}
+
+	if (IS_TYPE_NUMBER_RANGE(param)) {
+		u32 left_val =3D 0, right_val =3D 0, recieved_value =3D 0;
+		char *left_val_ptr =3D NULL, *right_val_ptr =3D NULL;
+		char *tilde_ptr =3D NULL, *tmp_ptr =3D NULL;
+
+		if (!strcmp(value, IRRELEVANT) || !strcmp(value, REJECT)) {
+			if (iscsi_update_param_value(param, value) < 0)
+				return -1;
+			return 0;
+		}
+
+		tilde_ptr =3D strchr(value, '~');
+		if ((tilde_ptr)) {
+			printk(KERN_ERR "Illegal \"~\" in response for \"%s\".\n",
+					param->name);
+			return -1;
+		}
+		tilde_ptr =3D strchr(param->value, '~');
+		if (!(tilde_ptr)) {
+			printk(KERN_ERR "Unable to locate numerical range"
+				" indicator \"~\" for \"%s\".\n", param->name);
+			return -1;
+		}
+		*tilde_ptr =3D '\0';
+
+		left_val_ptr =3D param->value;
+		right_val_ptr =3D param->value + strlen(left_val_ptr) + 1;
+		left_val =3D simple_strtoul(left_val_ptr, &tmp_ptr, 0);
+		right_val =3D simple_strtoul(right_val_ptr, &tmp_ptr, 0);
+		recieved_value =3D simple_strtoul(value, &tmp_ptr, 0);
+
+		*tilde_ptr =3D '~';
+
+		if ((recieved_value < left_val) ||
+		    (recieved_value > right_val)) {
+			printk(KERN_ERR "Illegal response \"%s=3D%u\", value must"
+				" be between %u and %u.\n", param->name,
+				recieved_value, left_val, right_val);
+			return -1;
+		}
+	} else if (IS_TYPE_VALUE_LIST(param)) {
+		char *comma_ptr =3D NULL, *tmp_ptr =3D NULL;
+
+		comma_ptr =3D strchr(value, ',');
+		if ((comma_ptr)) {
+			printk(KERN_ERR "Illegal \",\" in response for \"%s\".\n",
+					param->name);
+			return -1;
+		}
+
+		tmp_ptr =3D iscsi_check_valuelist_for_support(param, value);
+		if (!(tmp_ptr))
+			return -1;
+	}
+
+	if (iscsi_update_param_value(param, value) < 0)
+		return -1;
+
+	return 0;
+}
+
+/*	iscsi_check_value():
+ *
+ *
+ */
+static int iscsi_check_value(struct iscsi_param *param, char *value)
+{
+	char *comma_ptr =3D NULL;
+
+	if (!strcmp(value, REJECT)) {
+		if (!strcmp(param->name, IFMARKINT) ||
+		    !strcmp(param->name, OFMARKINT)) {
+			/*
+			 * Reject is not fatal for [I,O]FMarkInt,  and causes
+			 * [I,O]FMarker to be reset to No. (See iSCSI v20 A.3.2)
+			 */
+			SET_PSTATE_REJECT(param);
+			return 0;
+		}
+		printk(KERN_ERR "Received %s=3D%s\n", param->name, value);
+		return -1;
+	}
+	if (!strcmp(value, IRRELEVANT)) {
+		TRACE(TRACE_LOGIN, "Received %s=3D%s\n", param->name, value);
+		SET_PSTATE_IRRELEVANT(param);
+		return 0;
+	}
+	if (!strcmp(value, NOTUNDERSTOOD)) {
+		if (!IS_PSTATE_PROPOSER(param)) {
+			printk(KERN_ERR "Received illegal offer %s=3D%s\n",
+				param->name, value);
+			return -1;
+		}
+
+/* #warning FIXME: Add check for X-ExtensionKey here */
+		printk(KERN_ERR "Standard iSCSI key \"%s\" cannot be answered"
+			" with \"%s\", protocol error.\n", param->name, value);
+		return -1;
+	}
+
+	do {
+		comma_ptr =3D NULL;
+		comma_ptr =3D strchr(value, ',');
+
+		if (comma_ptr && !IS_TYPE_VALUE_LIST(param)) {
+			printk(KERN_ERR "Detected value seperator \",\", but"
+				" key \"%s\" does not allow a value list,"
+				" protocol error.\n", param->name);
+			return -1;
+		}
+		if (comma_ptr)
+			*comma_ptr =3D '\0';
+
+		if (strlen(value) > MAX_KEY_VALUE_LENGTH) {
+			printk(KERN_ERR "Value for key \"%s\" exceeds %d,"
+				" protocol error.\n", param->name,
+				MAX_KEY_VALUE_LENGTH);
+			return -1;
+		}
+
+		if (IS_TYPE_BOOL_AND(param) || IS_TYPE_BOOL_OR(param)) {
+			if (iscsi_check_boolean_value(param, value) < 0)
+				return -1;
+		} else if (IS_TYPE_NUMBER(param)) {
+			if (iscsi_check_numerical_value(param, value) < 0)
+				return -1;
+		} else if (IS_TYPE_NUMBER_RANGE(param)) {
+			if (iscsi_check_numerical_range_value(param, value) < 0)
+				return -1;
+		} else if (IS_TYPE_STRING(param) || IS_TYPE_VALUE_LIST(param)) {
+			if (iscsi_check_string_or_list_value(param, value) < 0)
+				return -1;
+		} else {
+			printk(KERN_ERR "Huh? 0x%02x\n", param->type);
+			return -1;
+		}
+
+		if (comma_ptr)
+			*comma_ptr++ =3D ',';
+
+		value =3D comma_ptr;
+	} while (value);
+
+	return 0;
+}
+
+/*	__iscsi_check_key()
+ *
+ *
+ */
+static struct iscsi_param *__iscsi_check_key(
+	char *key,
+	int sender,
+	struct iscsi_param_list *param_list)
+{
+	struct iscsi_param *param;
+
+	if (strlen(key) > MAX_KEY_NAME_LENGTH) {
+		printk(KERN_ERR "Length of key name \"%s\" exceeds %d.\n",
+			key, MAX_KEY_NAME_LENGTH);
+		return NULL;
+	}
+
+	param =3D iscsi_find_param_from_key(key, param_list);
+	if (!(param))
+		return NULL;
+
+	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
+		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+			" protocol error.\n", param->name,
+			(sender & SENDER_RECEIVER) ? "target" : "initiator");
+		return NULL;
+	}
+
+	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
+		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+			" protocol error.\n", param->name,
+			(sender & SENDER_RECEIVER) ? "initiator" : "target");
+		return NULL;
+	}
+
+	return param;
+}
+
+/*	iscsi_check_key():
+ *
+ *
+ */
+static struct iscsi_param *iscsi_check_key(
+	char *key,
+	int phase,
+	int sender,
+	struct iscsi_param_list *param_list)
+{
+	struct iscsi_param *param;
+
+	/*
+	 * Key name length must not exceed 63 bytes. (See iSCSI v20 5.1)
+	 */
+	if (strlen(key) > MAX_KEY_NAME_LENGTH) {
+		printk(KERN_ERR "Length of key name \"%s\" exceeds %d.\n",
+			key, MAX_KEY_NAME_LENGTH);
+		return NULL;
+	}
+
+	param =3D iscsi_find_param_from_key(key, param_list);
+	if (!(param))
+		return NULL;
+
+	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
+		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+			" protocol error.\n", param->name,
+			(sender & SENDER_RECEIVER) ? "target" : "initiator");
+		return NULL;
+	}
+	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
+		printk(KERN_ERR "Key \"%s\" may not be sent to %s,"
+				" protocol error.\n", param->name,
+			(sender & SENDER_RECEIVER) ? "initiator" : "target");
+		return NULL;
+	}
+
+	if (IS_PSTATE_ACCEPTOR(param)) {
+		printk(KERN_ERR "Key \"%s\" received twice, protocol error.\n",
+				key);
+		return NULL;
+	}
+
+	if (!phase)
+		return param;
+
+	if (!(param->phase & phase)) {
+		printk(KERN_ERR "Key \"%s\" may not be negotiated during ",
+				param->name);
+		switch (phase) {
+		case PHASE_SECURITY:
+			printk(KERN_INFO "Security phase.\n");
+			break;
+		case PHASE_OPERATIONAL:
+			printk(KERN_INFO "Operational phase.\n");
+		default:
+			printk(KERN_INFO "Unknown phase.\n");
+		}
+		return NULL;
+	}
+
+	return param;
+}
+
+/*	iscsi_enforce_integrity_rules():
+ *
+ *
+ */
+static int iscsi_enforce_integrity_rules(
+	u8 phase,
+	struct iscsi_param_list *param_list)
+{
+	char *tmpptr;
+	u8 DataSequenceInOrder =3D 0;
+	u8 ErrorRecoveryLevel =3D 0, SessionType =3D 0;
+	u8 IFMarker =3D 0, OFMarker =3D 0;
+	u8 IFMarkInt_Reject =3D 0, OFMarkInt_Reject =3D 0;
+	u32 FirstBurstLength =3D 0, MaxBurstLength =3D 0;
+	struct iscsi_param *param =3D NULL;
+
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (!(param->phase & phase))
+			continue;
+		if (!strcmp(param->name, SESSIONTYPE))
+			if (!strcmp(param->value, NORMAL))
+				SessionType =3D 1;
+		if (!strcmp(param->name, ERRORRECOVERYLEVEL))
+			ErrorRecoveryLevel =3D simple_strtoul(param->value,
+					&tmpptr, 0);
+		if (!strcmp(param->name, DATASEQUENCEINORDER))
+			if (!strcmp(param->value, YES))
+				DataSequenceInOrder =3D 1;
+		if (!strcmp(param->name, MAXBURSTLENGTH))
+			MaxBurstLength =3D simple_strtoul(param->value,
+					&tmpptr, 0);
+		if (!strcmp(param->name, IFMARKER))
+			if (!strcmp(param->value, YES))
+				IFMarker =3D 1;
+		if (!strcmp(param->name, OFMARKER))
+			if (!strcmp(param->value, YES))
+				OFMarker =3D 1;
+		if (!strcmp(param->name, IFMARKINT))
+			if (!strcmp(param->value, REJECT))
+				IFMarkInt_Reject =3D 1;
+		if (!strcmp(param->name, OFMARKINT))
+			if (!strcmp(param->value, REJECT))
+				OFMarkInt_Reject =3D 1;
+	}
+
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (!(param->phase & phase))
+			continue;
+		if (!SessionType && (!IS_PSTATE_ACCEPTOR(param) &&
+		     (strcmp(param->name, IFMARKER) &&
+		      strcmp(param->name, OFMARKER) &&
+		      strcmp(param->name, IFMARKINT) &&
+		      strcmp(param->name, OFMARKINT))))
+			continue;
+		if (!strcmp(param->name, MAXOUTSTANDINGR2T) &&
+		    DataSequenceInOrder && (ErrorRecoveryLevel > 0)) {
+			if (strcmp(param->value, "1")) {
+				if (iscsi_update_param_value(param, "1") < 0)
+					return -1;
+				TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+					param->name, param->value);
+			}
+		}
+		if (!strcmp(param->name, MAXCONNECTIONS) && !SessionType) {
+			if (strcmp(param->value, "1")) {
+				if (iscsi_update_param_value(param, "1") < 0)
+					return -1;
+				TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+					param->name, param->value);
+			}
+		}
+		if (!strcmp(param->name, FIRSTBURSTLENGTH)) {
+			FirstBurstLength =3D simple_strtoul(param->value,
+					&tmpptr, 0);
+			if (FirstBurstLength > MaxBurstLength) {
+				char tmpbuf[10];
+				memset(tmpbuf, 0, 10);
+				sprintf(tmpbuf, "%u", MaxBurstLength);
+				if (iscsi_update_param_value(param, tmpbuf))
+					return -1;
+				TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+					param->name, param->value);
+			}
+		}
+		if (!strcmp(param->name, IFMARKER) && IFMarkInt_Reject) {
+			if (iscsi_update_param_value(param, NO) < 0)
+				return -1;
+			IFMarker =3D 0;
+			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+					param->name, param->value);
+		}
+		if (!strcmp(param->name, OFMARKER) && OFMarkInt_Reject) {
+			if (iscsi_update_param_value(param, NO) < 0)
+				return -1;
+			OFMarker =3D 0;
+			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+					 param->name, param->value);
+		}
+		if (!strcmp(param->name, IFMARKINT) && !IFMarker) {
+			if (!strcmp(param->value, REJECT))
+				continue;
+			param->state &=3D ~PSTATE_NEGOTIATE;
+			if (iscsi_update_param_value(param, IRRELEVANT) < 0)
+				return -1;
+			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+					param->name, param->value);
+		}
+		if (!strcmp(param->name, OFMARKINT) && !OFMarker) {
+			if (!strcmp(param->value, REJECT))
+				continue;
+			param->state &=3D ~PSTATE_NEGOTIATE;
+			if (iscsi_update_param_value(param, IRRELEVANT) < 0)
+				return -1;
+			TRACE(TRACE_PARAM, "Reset \"%s\" to \"%s\".\n",
+					param->name, param->value);
+		}
+	}
+
+	return 0;
+}
+
+/*	iscsi_decode_text_input():
+ *
+ *
+ */
+int iscsi_decode_text_input(
+	u8 phase,
+	u8 sender,
+	char *textbuf,
+	u32 length,
+	struct iscsi_param_list *param_list)
+{
+	char *tmpbuf, *start =3D NULL, *end =3D NULL;
+
+	tmpbuf =3D kzalloc(length + 1, GFP_KERNEL);
+	if (!(tmpbuf)) {
+		printk(KERN_ERR "Unable to allocate memory for tmpbuf.\n");
+		return -1;
+	}
+
+	memcpy(tmpbuf, textbuf, length);
+	tmpbuf[length] =3D '\0';
+	start =3D tmpbuf;
+	end =3D (start + length);
+
+	while (start < end) {
+		char *key, *value;
+		struct iscsi_param *param;
+
+		if (iscsi_extract_key_value(start, &key, &value) < 0) {
+			kfree(tmpbuf);
+			return -1;
+		}
+
+		TRACE(TRACE_PARAM, "Got key: %s=3D%s\n", key, value);
+
+		if (phase & PHASE_SECURITY) {
+			if (iscsi_check_for_auth_key(key) > 0) {
+				char *tmpptr =3D key + strlen(key);
+				*tmpptr =3D '=3D';
+				kfree(tmpbuf);
+				return 1;
+			}
+		}
+
+		param =3D iscsi_check_key(key, phase, sender, param_list);
+		if (!(param)) {
+			if (iscsi_add_notunderstood_response(key,
+					value, param_list) < 0) {
+				kfree(tmpbuf);
+				return -1;
+			}
+			start +=3D strlen(key) + strlen(value) + 2;
+			continue;
+		}
+		if (iscsi_check_value(param, value) < 0) {
+			kfree(tmpbuf);
+			return -1;
+		}
+
+		start +=3D strlen(key) + strlen(value) + 2;
+
+		if (IS_PSTATE_PROPOSER(param)) {
+			if (iscsi_check_proposer_state(param, value) < 0) {
+				kfree(tmpbuf);
+				return -1;
+			}
+			SET_PSTATE_RESPONSE_GOT(param);
+		} else {
+			if (iscsi_check_acceptor_state(param, value) < 0) {
+				kfree(tmpbuf);
+				return -1;
+			}
+			SET_PSTATE_ACCEPTOR(param);
+		}
+	}
+
+	kfree(tmpbuf);
+	return 0;
+}
+
+/*	iscsi_encode_text_output():
+ *
+ *
+ */
+int iscsi_encode_text_output(
+	u8 phase,
+	u8 sender,
+	char *textbuf,
+	u32 *length,
+	struct iscsi_param_list *param_list)
+{
+	char *output_buf =3D NULL;
+	struct iscsi_extra_response *er;
+	struct iscsi_param *param;
+
+	output_buf =3D textbuf + *length;
+
+	if (iscsi_enforce_integrity_rules(phase, param_list) < 0)
+		return -1;
+
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (!(param->sender & sender))
+			continue;
+		if (IS_PSTATE_ACCEPTOR(param) &&
+		    !IS_PSTATE_RESPONSE_SENT(param) &&
+		    !IS_PSTATE_REPLY_OPTIONAL(param) &&
+		    (param->phase & phase)) {
+			*length +=3D sprintf(output_buf, "%s=3D%s",
+				param->name, param->value);
+			*length +=3D 1;
+			output_buf =3D textbuf + *length;
+			SET_PSTATE_RESPONSE_SENT(param);
+			TRACE(TRACE_PARAM, "Sending key: %s=3D%s\n",
+				param->name, param->value);
+			continue;
+		}
+		if (IS_PSTATE_NEGOTIATE(param) &&
+		    !IS_PSTATE_ACCEPTOR(param) &&
+		    !IS_PSTATE_PROPOSER(param) &&
+		    (param->phase & phase)) {
+			*length +=3D sprintf(output_buf, "%s=3D%s",
+				param->name, param->value);
+			*length +=3D 1;
+			output_buf =3D textbuf + *length;
+			SET_PSTATE_PROPOSER(param);
+			iscsi_check_proposer_for_optional_reply(param);
+			TRACE(TRACE_PARAM, "Sending key: %s=3D%s\n",
+				param->name, param->value);
+		}
+	}
+
+	list_for_each_entry(er, &param_list->extra_response_list, er_list) {
+		*length +=3D sprintf(output_buf, "%s=3D%s", er->key, er->value);
+		*length +=3D 1;
+		output_buf =3D textbuf + *length;
+		TRACE(TRACE_PARAM, "Sending key: %s=3D%s\n", er->key, er->value);
+	}
+	iscsi_release_extra_responses(param_list);
+
+	return 0;
+}
+
+/*	iscsi_check_negotiated_keys():
+ *
+ *
+ */
+int iscsi_check_negotiated_keys(struct iscsi_param_list *param_list)
+{
+	int ret =3D 0;
+	struct iscsi_param *param;
+
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (IS_PSTATE_NEGOTIATE(param) &&
+		    IS_PSTATE_PROPOSER(param) &&
+		    !IS_PSTATE_RESPONSE_GOT(param) &&
+		    !IS_PSTATE_REPLY_OPTIONAL(param) &&
+		    !IS_PHASE_DECLARATIVE(param)) {
+			printk(KERN_ERR "No response for proposed key \"%s\".\n",
+					param->name);
+			ret =3D -1;
+		}
+	}
+
+	return ret;
+}
+
+/*	iscsi_set_param_value():
+ *
+ *
+ */
+int iscsi_change_param_value(
+	char *keyvalue,
+	struct iscsi_param_list *param_list,
+	int check_key)
+{
+	char *key =3D NULL, *value =3D NULL;
+	struct iscsi_param *param;
+	int sender =3D 0;
+
+	if (iscsi_extract_key_value(keyvalue, &key, &value) < 0)
+		return -1;
+
+	if (!check_key) {
+		param =3D __iscsi_check_key(keyvalue, sender, param_list);
+		if (!(param))
+			return -1;
+	} else {
+		param =3D iscsi_check_key(keyvalue, 0, sender, param_list);
+		if (!(param))
+			return -1;
+
+		param->set_param =3D 1;
+		if (iscsi_check_value(param, value) < 0) {
+			param->set_param =3D 0;
+			return -1;
+		}
+		param->set_param =3D 0;
+	}
+
+	if (iscsi_update_param_value(param, value) < 0)
+		return -1;
+
+	return 0;
+}
+
+/*	iscsi_set_connection_parameters():
+ *
+ *
+ */
+void iscsi_set_connection_parameters(
+	struct iscsi_conn_ops *ops,
+	struct iscsi_param_list *param_list)
+{
+	char *tmpptr;
+	struct iscsi_param *param;
+
+	printk(KERN_INFO "---------------------------------------------------=
"
+			"---------------\n");
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (!IS_PSTATE_ACCEPTOR(param) && !IS_PSTATE_PROPOSER(param))
+			continue;
+		if (!strcmp(param->name, AUTHMETHOD)) {
+			printk(KERN_INFO "AuthMethod:                   %s\n",
+				param->value);
+		} else if (!strcmp(param->name, HEADERDIGEST)) {
+			ops->HeaderDigest =3D !strcmp(param->value, CRC32C);
+			printk(KERN_INFO "HeaderDigest:                 %s\n",
+				param->value);
+		} else if (!strcmp(param->name, DATADIGEST)) {
+			ops->DataDigest =3D !strcmp(param->value, CRC32C);
+			printk(KERN_INFO "DataDigest:                   %s\n",
+				param->value);
+		} else if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH)) {
+			ops->MaxRecvDataSegmentLength =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "MaxRecvDataSegmentLength:     %s\n",
+				param->value);
+		} else if (!strcmp(param->name, OFMARKER)) {
+			ops->OFMarker =3D !strcmp(param->value, YES);
+			printk(KERN_INFO "OFMarker:                     %s\n",
+				param->value);
+		} else if (!strcmp(param->name, IFMARKER)) {
+			ops->IFMarker =3D !strcmp(param->value, YES);
+			printk(KERN_INFO "IFMarker:                     %s\n",
+				param->value);
+		} else if (!strcmp(param->name, OFMARKINT)) {
+			ops->OFMarkInt =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "OFMarkInt:                    %s\n",
+				param->value);
+		} else if (!strcmp(param->name, IFMARKINT)) {
+			ops->IFMarkInt =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "IFMarkInt:                    %s\n",
+				param->value);
+		}
+	}
+	printk(KERN_INFO "---------------------------------------------------=
-"
+			"--------------\n");
+}
+
+/*	iscsi_set_session_parameters():
+ *
+ *
+ */
+void iscsi_set_session_parameters(
+	struct iscsi_sess_ops *ops,
+	struct iscsi_param_list *param_list,
+	int leading)
+{
+	char *tmpptr;
+	struct iscsi_param *param;
+
+	printk(KERN_INFO "---------------------------------------------------=
-"
+			"--------------\n");
+	list_for_each_entry(param, &param_list->param_list, p_list) {
+		if (!IS_PSTATE_ACCEPTOR(param) && !IS_PSTATE_PROPOSER(param))
+			continue;
+		if (!strcmp(param->name, INITIATORNAME)) {
+			if (!param->value)
+				continue;
+			if (leading)
+				snprintf(ops->InitiatorName,
+						sizeof(ops->InitiatorName),
+						"%s", param->value);
+			printk(KERN_INFO "InitiatorName:                %s\n",
+				param->value);
+		} else if (!strcmp(param->name, INITIATORALIAS)) {
+			if (!param->value)
+				continue;
+			snprintf(ops->InitiatorAlias,
+						sizeof(ops->InitiatorAlias),
+						"%s", param->value);
+			printk(KERN_INFO "InitiatorAlias:               %s\n",
+				param->value);
+		} else if (!strcmp(param->name, TARGETNAME)) {
+			if (!param->value)
+				continue;
+			if (leading)
+				snprintf(ops->TargetName,
+						sizeof(ops->TargetName),
+						"%s", param->value);
+			printk(KERN_INFO "TargetName:                   %s\n",
+				param->value);
+		} else if (!strcmp(param->name, TARGETALIAS)) {
+			if (!param->value)
+				continue;
+			snprintf(ops->TargetAlias, sizeof(ops->TargetAlias),
+					"%s", param->value);
+			printk(KERN_INFO "TargetAlias:                  %s\n",
+				param->value);
+		} else if (!strcmp(param->name, TARGETPORTALGROUPTAG)) {
+			ops->TargetPortalGroupTag =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "TargetPortalGroupTag:         %s\n",
+				param->value);
+		} else if (!strcmp(param->name, MAXCONNECTIONS)) {
+			ops->MaxConnections =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "MaxConnections:               %s\n",
+				param->value);
+		} else if (!strcmp(param->name, INITIALR2T)) {
+			ops->InitialR2T =3D !strcmp(param->value, YES);
+			 printk(KERN_INFO "InitialR2T:                   %s\n",
+				param->value);
+		} else if (!strcmp(param->name, IMMEDIATEDATA)) {
+			ops->ImmediateData =3D !strcmp(param->value, YES);
+			printk(KERN_INFO "ImmediateData:                %s\n",
+				param->value);
+		} else if (!strcmp(param->name, MAXBURSTLENGTH)) {
+			ops->MaxBurstLength =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "MaxBurstLength:               %s\n",
+				param->value);
+		} else if (!strcmp(param->name, FIRSTBURSTLENGTH)) {
+			ops->FirstBurstLength =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "FirstBurstLength:             %s\n",
+				param->value);
+		} else if (!strcmp(param->name, DEFAULTTIME2WAIT)) {
+			ops->DefaultTime2Wait =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "DefaultTime2Wait:             %s\n",
+				param->value);
+		} else if (!strcmp(param->name, DEFAULTTIME2RETAIN)) {
+			ops->DefaultTime2Retain =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "DefaultTime2Retain:           %s\n",
+				param->value);
+		} else if (!strcmp(param->name, MAXOUTSTANDINGR2T)) {
+			ops->MaxOutstandingR2T =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "MaxOutstandingR2T:            %s\n",
+				param->value);
+		} else if (!strcmp(param->name, DATAPDUINORDER)) {
+			ops->DataPDUInOrder =3D !strcmp(param->value, YES);
+			printk(KERN_INFO "DataPDUInOrder:               %s\n",
+				param->value);
+		} else if (!strcmp(param->name, DATASEQUENCEINORDER)) {
+			ops->DataSequenceInOrder =3D !strcmp(param->value, YES);
+			printk(KERN_INFO "DataSequenceInOrder:          %s\n",
+				param->value);
+		} else if (!strcmp(param->name, ERRORRECOVERYLEVEL)) {
+			ops->ErrorRecoveryLevel =3D
+				simple_strtoul(param->value, &tmpptr, 0);
+			printk(KERN_INFO "ErrorRecoveryLevel:           %s\n",
+				param->value);
+		} else if (!strcmp(param->name, SESSIONTYPE)) {
+			ops->SessionType =3D !strcmp(param->value, DISCOVERY);
+			printk(KERN_INFO "SessionType:                  %s\n",
+				param->value);
+		}
+	}
+	printk(KERN_INFO "---------------------------------------------------=
-"
+			"--------------\n");
+
+}
diff --git a/drivers/target/iscsi/iscsi_parameters.h b/drivers/target/i=
scsi/iscsi_parameters.h
new file mode 100644
index 0000000..e6bde0c
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_parameters.h
@@ -0,0 +1,271 @@
+#ifndef ISCSI_PARAMETERS_H
+#define ISCSI_PARAMETERS_H
+
+struct iscsi_extra_response {
+	char key[64];
+	char value[32];
+	struct list_head er_list;
+} ____cacheline_aligned;
+
+struct iscsi_param {
+	char *name;
+	char *value;
+	u8 set_param;
+	u8 phase;
+	u8 scope;
+	u8 sender;
+	u8 type;
+	u8 use;
+	u16 type_range;
+	u32 state;
+	struct list_head p_list;
+} ____cacheline_aligned;
+
+extern struct iscsi_global *iscsi_global;
+
+extern int iscsi_login_rx_data(struct iscsi_conn *, char *, int);
+extern int iscsi_login_tx_data(struct iscsi_conn *, char *, char *, in=
t);
+extern void iscsi_dump_conn_ops(struct iscsi_conn_ops *);
+extern void iscsi_dump_sess_ops(struct iscsi_sess_ops *);
+extern void iscsi_print_params(struct iscsi_param_list *);
+extern int iscsi_create_default_params(struct iscsi_param_list **);
+extern int iscsi_set_keys_to_negotiate(int, struct iscsi_param_list *)=
;
+extern int iscsi_set_keys_irrelevant_for_discovery(struct iscsi_param_=
list *);
+extern int iscsi_copy_param_list(struct iscsi_param_list **,
+			struct iscsi_param_list *, int);
+extern int iscsi_change_param_value(char *, struct iscsi_param_list *,=
 int);
+extern void iscsi_release_param_list(struct iscsi_param_list *);
+extern struct iscsi_param *iscsi_find_param_from_key(char *, struct is=
csi_param_list *);
+extern int iscsi_extract_key_value(char *, char **, char **);
+extern int iscsi_update_param_value(struct iscsi_param *, char *);
+extern int iscsi_decode_text_input(u8, u8, char *, u32, struct iscsi_p=
aram_list *);
+extern int iscsi_encode_text_output(u8, u8, char *, u32 *,
+			struct iscsi_param_list *);
+extern int iscsi_check_negotiated_keys(struct iscsi_param_list *);
+extern void iscsi_set_connection_parameters(struct iscsi_conn_ops *,
+			struct iscsi_param_list *);
+extern void iscsi_set_session_parameters(struct iscsi_sess_ops *,
+			struct iscsi_param_list *, int);
+
+#define YES				"Yes"
+#define NO				"No"
+#define ALL				"All"
+#define IRRELEVANT			"Irrelevant"
+#define NONE				"None"
+#define NOTUNDERSTOOD			"NotUnderstood"
+#define REJECT				"Reject"
+
+/*
+ * The Parameter Names.
+ */
+#define AUTHMETHOD			"AuthMethod"
+#define HEADERDIGEST			"HeaderDigest"
+#define DATADIGEST			"DataDigest"
+#define MAXCONNECTIONS			"MaxConnections"
+#define SENDTARGETS			"SendTargets"
+#define TARGETNAME			"TargetName"
+#define INITIATORNAME			"InitiatorName"
+#define TARGETALIAS			"TargetAlias"
+#define INITIATORALIAS			"InitiatorAlias"
+#define TARGETADDRESS			"TargetAddress"
+#define TARGETPORTALGROUPTAG		"TargetPortalGroupTag"
+#define INITIALR2T			"InitialR2T"
+#define IMMEDIATEDATA			"ImmediateData"
+#define MAXRECVDATASEGMENTLENGTH	"MaxRecvDataSegmentLength"
+#define MAXBURSTLENGTH			"MaxBurstLength"
+#define FIRSTBURSTLENGTH		"FirstBurstLength"
+#define DEFAULTTIME2WAIT		"DefaultTime2Wait"
+#define DEFAULTTIME2RETAIN		"DefaultTime2Retain"
+#define MAXOUTSTANDINGR2T		"MaxOutstandingR2T"
+#define DATAPDUINORDER			"DataPDUInOrder"
+#define DATASEQUENCEINORDER		"DataSequenceInOrder"
+#define ERRORRECOVERYLEVEL		"ErrorRecoveryLevel"
+#define SESSIONTYPE			"SessionType"
+#define IFMARKER			"IFMarker"
+#define OFMARKER			"OFMarker"
+#define IFMARKINT			"IFMarkInt"
+#define OFMARKINT			"OFMarkInt"
+#define X_EXTENSIONKEY			"X-com.sbei.version"
+#define X_EXTENSIONKEY_CISCO_NEW	"X-com.cisco.protocol"
+#define X_EXTENSIONKEY_CISCO_OLD	"X-com.cisco.iscsi.draft"
+
+/*
+ * For AuthMethod.
+ */
+#define KRB5				"KRB5"
+#define SPKM1				"SPKM1"
+#define SPKM2				"SPKM2"
+#define SRP				"SRP"
+#define CHAP				"CHAP"
+
+/*
+ * Initial values for Parameter Negotiation.
+ */
+#define INITIAL_AUTHMETHOD			CHAP
+#define INITIAL_HEADERDIGEST			"CRC32C,None"
+#define INITIAL_DATADIGEST			"CRC32C,None"
+#define INITIAL_MAXCONNECTIONS			"1"
+#define INITIAL_SENDTARGETS			ALL
+#define INITIAL_TARGETNAME			"LIO.Target"
+#define INITIAL_INITIATORNAME			"LIO.Initiator"
+#define INITIAL_TARGETALIAS			"LIO Target"
+#define INITIAL_INITIATORALIAS			"LIO Initiator"
+#define INITIAL_TARGETADDRESS			"0.0.0.0:0000,0"
+#define INITIAL_TARGETPORTALGROUPTAG		"1"
+#define INITIAL_INITIALR2T			YES
+#define INITIAL_IMMEDIATEDATA			YES
+#define INITIAL_MAXRECVDATASEGMENTLENGTH	"8192"
+#define INITIAL_MAXBURSTLENGTH			"262144"
+#define INITIAL_FIRSTBURSTLENGTH		"65536"
+#define INITIAL_DEFAULTTIME2WAIT		"2"
+#define INITIAL_DEFAULTTIME2RETAIN		"20"
+#define INITIAL_MAXOUTSTANDINGR2T		"1"
+#define INITIAL_DATAPDUINORDER			YES
+#define INITIAL_DATASEQUENCEINORDER		YES
+#define INITIAL_ERRORRECOVERYLEVEL		"0"
+#define INITIAL_SESSIONTYPE			NORMAL
+#define INITIAL_IFMARKER			NO
+#define INITIAL_OFMARKER			NO
+#define INITIAL_IFMARKINT			"2048~65535"
+#define INITIAL_OFMARKINT			"2048~65535"
+
+/*
+ * For [Header,Data]Digests.
+ */
+#define CRC32C				"CRC32C"
+
+/*
+ * For SessionType.
+ */
+#define DISCOVERY			"Discovery"
+#define NORMAL				"Normal"
+
+/*
+ * struct iscsi_param->use
+ */
+#define USE_LEADING_ONLY		0x01
+#define USE_INITIAL_ONLY		0x02
+#define USE_ALL				0x04
+
+#define IS_USE_LEADING_ONLY(p)		((p)->use & USE_LEADING_ONLY)
+#define IS_USE_INITIAL_ONLY(p)		((p)->use & USE_INITIAL_ONLY)
+#define IS_USE_ALL(p)			((p)->use & USE_ALL)
+
+#define SET_USE_INITIAL_ONLY(p)		((p)->use |=3D USE_INITIAL_ONLY)
+
+/*
+ * struct iscsi_param->sender
+ */
+#define	SENDER_INITIATOR		0x01
+#define SENDER_TARGET			0x02
+#define SENDER_BOTH			0x03
+/* Used in iscsi_check_key() */
+#define SENDER_RECEIVER			0x04
+
+#define IS_SENDER_INITIATOR(p)		((p)->sender & SENDER_INITIATOR)
+#define IS_SENDER_TARGET(p)		((p)->sender & SENDER_TARGET)
+#define IS_SENDER_BOTH(p)		((p)->sender & SENDER_BOTH)
+
+/*
+ * struct iscsi_param->scope
+ */
+#define SCOPE_CONNECTION_ONLY		0x01
+#define SCOPE_SESSION_WIDE		0x02
+
+#define IS_SCOPE_CONNECTION_ONLY(p)	((p)->scope & SCOPE_CONNECTION_ONL=
Y)
+#define IS_SCOPE_SESSION_WIDE(p)	((p)->scope & SCOPE_SESSION_WIDE)
+
+/*
+ * struct iscsi_param->phase
+ */
+#define PHASE_SECURITY			0x01
+#define PHASE_OPERATIONAL		0x02
+#define PHASE_DECLARATIVE		0x04
+#define PHASE_FFP0			0x08
+
+#define IS_PHASE_SECURITY(p)		((p)->phase & PHASE_SECURITY)
+#define IS_PHASE_OPERATIONAL(p)		((p)->phase & PHASE_OPERATIONAL)
+#define IS_PHASE_DECLARATIVE(p)		((p)->phase & PHASE_DECLARATIVE)
+#define IS_PHASE_FFP0(p)		((p)->phase & PHASE_FFP0)
+
+/*
+ * struct iscsi_param->type
+ */
+#define TYPE_BOOL_AND			0x01
+#define TYPE_BOOL_OR			0x02
+#define TYPE_NUMBER			0x04
+#define TYPE_NUMBER_RANGE		0x08
+#define TYPE_STRING			0x10
+#define TYPE_VALUE_LIST			0x20
+
+#define IS_TYPE_BOOL_AND(p)		((p)->type & TYPE_BOOL_AND)
+#define IS_TYPE_BOOL_OR(p)		((p)->type & TYPE_BOOL_OR)
+#define IS_TYPE_NUMBER(p)		((p)->type & TYPE_NUMBER)
+#define IS_TYPE_NUMBER_RANGE(p)		((p)->type & TYPE_NUMBER_RANGE)
+#define IS_TYPE_STRING(p)		((p)->type & TYPE_STRING)
+#define IS_TYPE_VALUE_LIST(p)		((p)->type & TYPE_VALUE_LIST)
+
+/*
+ * struct iscsi_param->type_range
+ */
+#define TYPERANGE_BOOL_AND		0x0001
+#define TYPERANGE_BOOL_OR		0x0002
+#define TYPERANGE_0_TO_2		0x0004
+#define TYPERANGE_0_TO_3600		0x0008
+#define TYPERANGE_0_TO_32767		0x0010
+#define TYPERANGE_0_TO_65535		0x0020
+#define TYPERANGE_1_TO_65535		0x0040
+#define TYPERANGE_2_TO_3600		0x0080
+#define TYPERANGE_512_TO_16777215	0x0100
+#define TYPERANGE_AUTH			0x0200
+#define TYPERANGE_DIGEST		0x0400
+#define TYPERANGE_ISCSINAME		0x0800
+#define TYPERANGE_MARKINT		0x1000
+#define TYPERANGE_SESSIONTYPE		0x2000
+#define TYPERANGE_TARGETADDRESS		0x4000
+#define TYPERANGE_UTF8			0x8000
+
+#define IS_TYPERANGE_0_TO_2(p)		((p)->type_range & TYPERANGE_0_TO_2)
+#define IS_TYPERANGE_0_TO_3600(p)	((p)->type_range & TYPERANGE_0_TO_36=
00)
+#define IS_TYPERANGE_0_TO_32767(p)	((p)->type_range & TYPERANGE_0_TO_3=
2767)
+#define IS_TYPERANGE_0_TO_65535(p)	((p)->type_range & TYPERANGE_0_TO_6=
5535)
+#define IS_TYPERANGE_1_TO_65535(p)	((p)->type_range & TYPERANGE_1_TO_6=
5535)
+#define IS_TYPERANGE_2_TO_3600(p)	((p)->type_range & TYPERANGE_2_TO_36=
00)
+#define IS_TYPERANGE_512_TO_16777215(p)	((p)->type_range & \
+						TYPERANGE_512_TO_16777215)
+#define IS_TYPERANGE_AUTH_PARAM(p)	((p)->type_range & TYPERANGE_AUTH)
+#define IS_TYPERANGE_DIGEST_PARAM(p)	((p)->type_range & TYPERANGE_DIGE=
ST)
+#define IS_TYPERANGE_SESSIONTYPE(p)	((p)->type_range & \
+						TYPERANGE_SESSIONTYPE)
+
+/*
+ * struct iscsi_param->state
+ */
+#define PSTATE_ACCEPTOR			0x01
+#define PSTATE_NEGOTIATE		0x02
+#define PSTATE_PROPOSER			0x04
+#define PSTATE_IRRELEVANT		0x08
+#define PSTATE_REJECT			0x10
+#define PSTATE_REPLY_OPTIONAL		0x20
+#define PSTATE_RESPONSE_GOT		0x40
+#define PSTATE_RESPONSE_SENT		0x80
+
+#define IS_PSTATE_ACCEPTOR(p)		((p)->state & PSTATE_ACCEPTOR)
+#define IS_PSTATE_NEGOTIATE(p)		((p)->state & PSTATE_NEGOTIATE)
+#define IS_PSTATE_PROPOSER(p)		((p)->state & PSTATE_PROPOSER)
+#define IS_PSTATE_IRRELEVANT(p)		((p)->state & PSTATE_IRRELEVANT)
+#define IS_PSTATE_REJECT(p)		((p)->state & PSTATE_REJECT)
+#define IS_PSTATE_REPLY_OPTIONAL(p)	((p)->state & PSTATE_REPLY_OPTIONA=
L)
+#define IS_PSTATE_RESPONSE_GOT(p)	((p)->state & PSTATE_RESPONSE_GOT)
+#define IS_PSTATE_RESPONSE_SENT(p)	((p)->state & PSTATE_RESPONSE_SENT)
+
+#define SET_PSTATE_ACCEPTOR(p)		((p)->state |=3D PSTATE_ACCEPTOR)
+#define SET_PSTATE_NEGOTIATE(p)		((p)->state |=3D PSTATE_NEGOTIATE)
+#define SET_PSTATE_PROPOSER(p)		((p)->state |=3D PSTATE_PROPOSER)
+#define SET_PSTATE_IRRELEVANT(p)	((p)->state |=3D PSTATE_IRRELEVANT)
+#define SET_PSTATE_REJECT(p)		((p)->state |=3D PSTATE_REJECT)
+#define SET_PSTATE_REPLY_OPTIONAL(p)	((p)->state |=3D PSTATE_REPLY_OPT=
IONAL)
+#define SET_PSTATE_RESPONSE_GOT(p)	((p)->state |=3D PSTATE_RESPONSE_GO=
T)
+#define SET_PSTATE_RESPONSE_SENT(p)	((p)->state |=3D PSTATE_RESPONSE_S=
ENT)
+
+#endif /* ISCSI_PARAMETERS_H */
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target=
/iscsi/iscsi_target_login.c
new file mode 100644
index 0000000..b0aa699
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -0,0 +1,1381 @@
+/*********************************************************************=
**********
+ * This file contains the login functions used by the iSCSI Target dri=
ver.
+ *
+ * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/inet.h>
+#include <linux/crypto.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <net/ipv6.h>
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_thread_queue.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_nego.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl2.h"
+#include "iscsi_target_login.h"
+#include "iscsi_target_stat.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+#include "iscsi_parameters.h"
+
+/*	iscsi_login_init_conn():
+ *
+ *
+ */
+static int iscsi_login_init_conn(struct iscsi_conn *conn)
+{
+	INIT_LIST_HEAD(&conn->conn_list);
+	INIT_LIST_HEAD(&conn->conn_cmd_list);
+	INIT_LIST_HEAD(&conn->immed_queue_list);
+	INIT_LIST_HEAD(&conn->response_queue_list);
+	sema_init(&conn->conn_post_wait_sem, 0);
+	sema_init(&conn->conn_wait_sem, 0);
+	sema_init(&conn->conn_wait_rcfr_sem, 0);
+	sema_init(&conn->conn_waiting_on_uc_sem, 0);
+	sema_init(&conn->conn_logout_sem, 0);
+	sema_init(&conn->rx_half_close_sem, 0);
+	sema_init(&conn->tx_half_close_sem, 0);
+	sema_init(&conn->tx_sem, 0);
+	spin_lock_init(&conn->cmd_lock);
+	spin_lock_init(&conn->conn_usage_lock);
+	spin_lock_init(&conn->immed_queue_lock);
+	spin_lock_init(&conn->netif_lock);
+	spin_lock_init(&conn->nopin_timer_lock);
+	spin_lock_init(&conn->response_queue_lock);
+	spin_lock_init(&conn->state_lock);
+
+	if (!(zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate conn->conn_cpumask\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/*
+ * Used by iscsi_target_nego.c:iscsi_target_locate_portal() to setup
+ * per struct iscsi_conn libcrypto contexts for crc32c and crc32-intel
+ */
+int iscsi_login_setup_crypto(struct iscsi_conn *conn)
+{
+	/*
+	 * Setup slicing by CRC32C algorithm for RX and TX libcrypto contexts
+	 * which will default to crc32c_intel.ko for cpu_has_xmm4_2, or fallb=
ack
+	 * to software 1x8 byte slicing from crc32c.ko
+	 */
+	conn->conn_rx_hash.flags =3D 0;
+	conn->conn_rx_hash.tfm =3D crypto_alloc_hash("crc32c", 0,
+						CRYPTO_ALG_ASYNC);
+	if (IS_ERR(conn->conn_rx_hash.tfm)) {
+		printk(KERN_ERR "crypto_alloc_hash() failed for conn_rx_tfm\n");
+		return -ENOMEM;
+	}
+
+	conn->conn_tx_hash.flags =3D 0;
+	conn->conn_tx_hash.tfm =3D crypto_alloc_hash("crc32c", 0,
+						CRYPTO_ALG_ASYNC);
+	if (IS_ERR(conn->conn_tx_hash.tfm)) {
+		printk(KERN_ERR "crypto_alloc_hash() failed for conn_tx_tfm\n");
+		crypto_free_hash(conn->conn_rx_hash.tfm);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/*	iscsi_login_check_initiator_version():
+ *
+ *
+ */
+static int iscsi_login_check_initiator_version(
+	struct iscsi_conn *conn,
+	u8 version_max,
+	u8 version_min)
+{
+	if ((version_max !=3D 0x00) || (version_min !=3D 0x00)) {
+		printk(KERN_ERR "Unsupported iSCSI IETF Pre-RFC Revision,"
+			" version Min/Max 0x%02x/0x%02x, rejecting login.\n",
+			version_min, version_max);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_NO_VERSION);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_check_for_session_reinstatement():
+ *
+ *
+ */
+int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
+{
+	int sessiontype;
+	struct iscsi_param *initiatorname_param =3D NULL, *sessiontype_param =
=3D NULL;
+	struct iscsi_portal_group *tpg =3D conn->tpg;
+	struct iscsi_session *sess =3D NULL, *sess_p =3D NULL;
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+	struct se_session *se_sess, *se_sess_tmp;
+
+	initiatorname_param =3D iscsi_find_param_from_key(
+			INITIATORNAME, conn->param_list);
+	if (!(initiatorname_param))
+		return -1;
+
+	sessiontype_param =3D iscsi_find_param_from_key(
+			SESSIONTYPE, conn->param_list);
+	if (!(sessiontype_param))
+		return -1;
+
+	sessiontype =3D (strncmp(sessiontype_param->value, NORMAL, 6)) ? 1 : =
0;
+
+	spin_lock_bh(&se_tpg->session_lock);
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list=
,
+			sess_list) {
+
+		sess_p =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
+		spin_lock(&sess_p->conn_lock);
+		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
+		    atomic_read(&sess_p->session_logout) ||
+		    (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
+			spin_unlock(&sess_p->conn_lock);
+			continue;
+		}
+		if (!memcmp((void *)sess_p->isid, (void *)SESS(conn)->isid, 6) &&
+		   (!strcmp((void *)SESS_OPS(sess_p)->InitiatorName,
+			    (void *)initiatorname_param->value) &&
+		   (SESS_OPS(sess_p)->SessionType =3D=3D sessiontype))) {
+			atomic_set(&sess_p->session_reinstatement, 1);
+			spin_unlock(&sess_p->conn_lock);
+			iscsi_inc_session_usage_count(sess_p);
+			iscsi_stop_time2retain_timer(sess_p);
+			sess =3D sess_p;
+			break;
+		}
+		spin_unlock(&sess_p->conn_lock);
+	}
+	spin_unlock_bh(&se_tpg->session_lock);
+	/*
+	 * If the Time2Retain handler has expired, the session is already gon=
e.
+	 */
+	if (!sess)
+		return 0;
+
+	TRACE(TRACE_ERL0, "%s iSCSI Session SID %u is still active for %s,"
+		" preforming session reinstatement.\n", (sessiontype) ?
+		"Discovery" : "Normal", sess->sid,
+		SESS_OPS(sess)->InitiatorName);
+
+	spin_lock_bh(&sess->conn_lock);
+	if (sess->session_state =3D=3D TARG_SESS_STATE_FAILED) {
+		spin_unlock_bh(&sess->conn_lock);
+		iscsi_dec_session_usage_count(sess);
+		return iscsi_close_session(sess);
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	iscsi_stop_session(sess, 1, 1);
+	iscsi_dec_session_usage_count(sess);
+
+	return iscsi_close_session(sess);
+}
+
+static void iscsi_login_set_conn_values(
+	struct iscsi_session *sess,
+	struct iscsi_conn *conn,
+	u16 cid)
+{
+	conn->sess		=3D sess;
+	conn->cid		=3D cid;
+	/*
+	 * Generate a random Status sequence number (statsn) for the new
+	 * iSCSI connection.
+	 */
+	get_random_bytes(&conn->stat_sn, sizeof(u32));
+
+	down(&iscsi_global->auth_id_sem);
+	conn->auth_id		=3D iscsi_global->auth_id++;
+	up(&iscsi_global->auth_id_sem);
+}
+
+/*	iscsi_login_zero_tsih():
+ *
+ *	This is the leading connection of a new session,
+ *	or session reinstatement.
+ */
+static int iscsi_login_zero_tsih_s1(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	struct iscsi_session *sess =3D NULL;
+	struct iscsi_login_req *pdu =3D (struct iscsi_login_req *)buf;
+
+	sess =3D kmem_cache_zalloc(lio_sess_cache, GFP_KERNEL);
+	if (!(sess)) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		printk(KERN_ERR "Could not allocate memory for session\n");
+		return -1;
+	}
+
+	iscsi_login_set_conn_values(sess, conn, pdu->cid);
+	sess->init_task_tag	=3D pdu->itt;
+	memcpy((void *)&sess->isid, (void *)pdu->isid, 6);
+	sess->exp_cmd_sn	=3D pdu->cmdsn;
+	INIT_LIST_HEAD(&sess->sess_conn_list);
+	INIT_LIST_HEAD(&sess->sess_ooo_cmdsn_list);
+	INIT_LIST_HEAD(&sess->cr_active_list);
+	INIT_LIST_HEAD(&sess->cr_inactive_list);
+	sema_init(&sess->async_msg_sem, 0);
+	sema_init(&sess->reinstatement_sem, 0);
+	sema_init(&sess->session_wait_sem, 0);
+	sema_init(&sess->session_waiting_on_uc_sem, 0);
+	spin_lock_init(&sess->cmdsn_lock);
+	spin_lock_init(&sess->conn_lock);
+	spin_lock_init(&sess->cr_a_lock);
+	spin_lock_init(&sess->cr_i_lock);
+	spin_lock_init(&sess->session_usage_lock);
+	spin_lock_init(&sess->ttt_lock);
+	sess->session_index =3D iscsi_get_new_index(ISCSI_SESSION_INDEX);
+	sess->creation_time =3D get_jiffies_64();
+	spin_lock_init(&sess->session_stats_lock);
+	/*
+	 * The FFP CmdSN window values will be allocated from the TPG's
+	 * Initiator Node's ACL once the login has been successfully complete=
d.
+	 */
+	sess->max_cmd_sn	=3D pdu->cmdsn;
+
+	sess->sess_ops =3D kzalloc(sizeof(struct iscsi_sess_ops), GFP_KERNEL)=
;
+	if (!(sess->sess_ops)) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_sess_ops.\n");
+		return -1;
+	}
+
+	sess->se_sess =3D transport_init_session();
+	if (!(sess->se_sess)) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int iscsi_login_zero_tsih_s2(
+	struct iscsi_conn *conn)
+{
+	struct iscsi_node_attrib *na;
+	struct iscsi_session *sess =3D conn->sess;
+	unsigned char buf[32];
+
+	sess->tpg =3D conn->tpg;
+
+	/*
+	 * Assign a new TPG Session Handle.  Note this is protected with
+	 * struct iscsi_portal_group->np_login_sem from core_access_np().
+	 */
+	sess->tsih =3D ++ISCSI_TPG_S(sess)->ntsih;
+	if (!(sess->tsih))
+		sess->tsih =3D ++ISCSI_TPG_S(sess)->ntsih;
+
+	/*
+	 * Create the default params from user defined values..
+	 */
+	if (iscsi_copy_param_list(&conn->param_list,
+				ISCSI_TPG_C(conn)->param_list, 1) < 0) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+
+	iscsi_set_keys_to_negotiate(0, conn->param_list);
+
+	if (SESS_OPS(sess)->SessionType)
+		return iscsi_set_keys_irrelevant_for_discovery(
+				conn->param_list);
+
+	na =3D iscsi_tpg_get_node_attrib(sess);
+
+	/*
+	 * Need to send TargetPortalGroupTag back in first login response
+	 * on any iSCSI connection where the Initiator provides TargetName.
+	 * See 5.3.1.  Login Phase Start
+	 *
+	 * In our case, we have already located the struct iscsi_tiqn at this=
 point.
+	 */
+	memset(buf, 0, 32);
+	sprintf(buf, "TargetPortalGroupTag=3D%hu", ISCSI_TPG_S(sess)->tpgt);
+	if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+
+	/*
+	 * Workaround for Initiators that have broken connection recovery log=
ic.
+	 *
+	 * "We would really like to get rid of this." Linux-iSCSI.org team
+	 */
+	memset(buf, 0, 32);
+	sprintf(buf, "ErrorRecoveryLevel=3D%d", na->default_erl);
+	if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+
+	if (iscsi_login_disable_FIM_keys(conn->param_list, conn) < 0)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Remove PSTATE_NEGOTIATE for the four FIM related keys.
+ * The Initiator node will be able to enable FIM by proposing them its=
elf.
+ */
+int iscsi_login_disable_FIM_keys(
+	struct iscsi_param_list *param_list,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_param *param;
+
+	param =3D iscsi_find_param_from_key("OFMarker", param_list);
+	if (!(param)) {
+		printk(KERN_ERR "iscsi_find_param_from_key() for"
+				" OFMarker failed\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+	param->state &=3D ~PSTATE_NEGOTIATE;
+
+	param =3D iscsi_find_param_from_key("OFMarkInt", param_list);
+	if (!(param)) {
+		printk(KERN_ERR "iscsi_find_param_from_key() for"
+				" IFMarker failed\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+	param->state &=3D ~PSTATE_NEGOTIATE;
+
+	param =3D iscsi_find_param_from_key("IFMarker", param_list);
+	if (!(param)) {
+		printk(KERN_ERR "iscsi_find_param_from_key() for"
+				" IFMarker failed\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+	param->state &=3D ~PSTATE_NEGOTIATE;
+
+	param =3D iscsi_find_param_from_key("IFMarkInt", param_list);
+	if (!(param)) {
+		printk(KERN_ERR "iscsi_find_param_from_key() for"
+				" IFMarker failed\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+	param->state &=3D ~PSTATE_NEGOTIATE;
+
+	return 0;
+}
+
+static int iscsi_login_non_zero_tsih_s1(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	struct iscsi_login_req *pdu =3D (struct iscsi_login_req *)buf;
+
+	iscsi_login_set_conn_values(NULL, conn, pdu->cid);
+	return 0;
+}
+
+/*	iscsi_login_non_zero_tsih_s2():
+ *
+ *	Add a new connection to an existing session.
+ */
+static int iscsi_login_non_zero_tsih_s2(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	struct iscsi_portal_group *tpg =3D conn->tpg;
+	struct iscsi_session *sess =3D NULL, *sess_p =3D NULL;
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+	struct se_session *se_sess, *se_sess_tmp;
+	struct iscsi_login_req *pdu =3D (struct iscsi_login_req *)buf;
+
+	spin_lock_bh(&se_tpg->session_lock);
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list=
,
+			sess_list) {
+
+		sess_p =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
+		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
+		    atomic_read(&sess_p->session_logout) ||
+		   (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED))
+			continue;
+		if (!(memcmp((const void *)sess_p->isid,
+		     (const void *)pdu->isid, 6)) &&
+		     (sess_p->tsih =3D=3D pdu->tsih)) {
+			iscsi_inc_session_usage_count(sess_p);
+			iscsi_stop_time2retain_timer(sess_p);
+			sess =3D sess_p;
+			break;
+		}
+	}
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	/*
+	 * If the Time2Retain handler has expired, the session is already gon=
e.
+	 */
+	if (!sess) {
+		printk(KERN_ERR "Initiator attempting to add a connection to"
+			" a non-existent session, rejecting iSCSI Login.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_NO_SESSION);
+		return -1;
+	}
+
+	/*
+	 * Stop the Time2Retain timer if this is a failed session, we restart
+	 * the timer if the login is not successful.
+	 */
+	spin_lock_bh(&sess->conn_lock);
+	if (sess->session_state =3D=3D TARG_SESS_STATE_FAILED)
+		atomic_set(&sess->session_continuation, 1);
+	spin_unlock_bh(&sess->conn_lock);
+
+	iscsi_login_set_conn_values(sess, conn, pdu->cid);
+
+	if (iscsi_copy_param_list(&conn->param_list,
+			ISCSI_TPG_C(conn)->param_list, 0) < 0) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+
+	iscsi_set_keys_to_negotiate(0, conn->param_list);
+	/*
+	 * Need to send TargetPortalGroupTag back in first login response
+	 * on any iSCSI connection where the Initiator provides TargetName.
+	 * See 5.3.1.  Login Phase Start
+	 *
+	 * In our case, we have already located the struct iscsi_tiqn at this=
 point.
+	 */
+	memset(buf, 0, 32);
+	sprintf(buf, "TargetPortalGroupTag=3D%hu", ISCSI_TPG_S(sess)->tpgt);
+	if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		return -1;
+	}
+
+	return iscsi_login_disable_FIM_keys(conn->param_list, conn);
+}
+
+/*	iscsi_login_post_auth_non_zero_tsih():
+ *
+ *
+ */
+int iscsi_login_post_auth_non_zero_tsih(
+	struct iscsi_conn *conn,
+	u16 cid,
+	u32 exp_statsn)
+{
+	struct iscsi_conn *conn_ptr =3D NULL;
+	struct iscsi_conn_recovery *cr =3D NULL;
+	struct iscsi_session *sess =3D SESS(conn);
+
+	/*
+	 * By following item 5 in the login table,  if we have found
+	 * an existing ISID and a valid/existing TSIH and an existing
+	 * CID we do connection reinstatement.  Currently we dont not
+	 * support it so we send back an non-zero status class to the
+	 * initiator and release the new connection.
+	 */
+	conn_ptr =3D iscsi_get_conn_from_cid_rcfr(sess, cid);
+	if ((conn_ptr)) {
+		printk(KERN_ERR "Connection exists with CID %hu for %s,"
+			" performing connection reinstatement.\n",
+			conn_ptr->cid, SESS_OPS(sess)->InitiatorName);
+
+		iscsi_connection_reinstatement_rcfr(conn_ptr);
+		iscsi_dec_conn_usage_count(conn_ptr);
+	}
+
+	/*
+	 * Check for any connection recovery entires containing CID.
+	 * We use the original ExpStatSN sent in the first login request
+	 * to acknowledge commands for the failed connection.
+	 *
+	 * Also note that an explict logout may have already been sent,
+	 * but the response may not be sent due to additional connection
+	 * loss.
+	 */
+	if (SESS_OPS(sess)->ErrorRecoveryLevel =3D=3D 2) {
+		cr =3D iscsi_get_inactive_connection_recovery_entry(
+				sess, cid);
+		if ((cr)) {
+			TRACE(TRACE_ERL2, "Performing implicit logout"
+				" for connection recovery on CID: %hu\n",
+					conn->cid);
+			iscsi_discard_cr_cmds_by_expstatsn(cr, exp_statsn);
+		}
+	}
+
+	/*
+	 * Else we follow item 4 from the login table in that we have
+	 * found an existing ISID and a valid/existing TSIH and a new
+	 * CID we go ahead and continue to add a new connection to the
+	 * session.
+	 */
+	TRACE(TRACE_LOGIN, "Adding CID %hu to existing session for %s.\n",
+			cid, SESS_OPS(sess)->InitiatorName);
+
+	if ((atomic_read(&sess->nconn) + 1) > SESS_OPS(sess)->MaxConnections)=
 {
+		printk(KERN_ERR "Adding additional connection to this session"
+			" would exceed MaxConnections %d, login failed.\n",
+				SESS_OPS(sess)->MaxConnections);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_ISID_ERROR);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_post_login_start_timers():
+ *
+ *
+ */
+static void iscsi_post_login_start_timers(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D SESS(conn);
+
+/* #warning PHY timer is disabled */
+#if 0
+	iscsi_get_network_interface_from_conn(conn);
+
+	spin_lock_bh(&conn->netif_lock);
+	iscsi_start_netif_timer(conn);
+	spin_unlock_bh(&conn->netif_lock);
+#endif
+	if (!SESS_OPS(sess)->SessionType)
+		iscsi_start_nopin_timer(conn);
+}
+
+/*	iscsi_post_login_handler():
+ *
+ *
+ */
+static int iscsi_post_login_handler(
+	struct iscsi_np *np,
+	struct iscsi_conn *conn,
+	u8 zero_tsih)
+{
+	int stop_timer =3D 0;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE], buf1_ipv4[IPV4_BUF_SIZE];
+	unsigned char *ip, *ip_np;
+	struct iscsi_session *sess =3D SESS(conn);
+	struct se_session *se_sess =3D sess->se_sess;
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+	struct se_thread_set *ts;
+
+	iscsi_inc_conn_usage_count(conn);
+
+	iscsi_collect_login_stats(conn, ISCSI_STATUS_CLS_SUCCESS,
+			ISCSI_LOGIN_STATUS_ACCEPT);
+
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_LOGGED_IN.\n");
+	conn->conn_state =3D TARG_CONN_STATE_LOGGED_IN;
+
+	iscsi_set_connection_parameters(conn->conn_ops, conn->param_list);
+	iscsi_set_sync_and_steering_values(conn);
+
+	if (np->np_net_size =3D=3D IPV6_ADDRESS_SPACE) {
+		ip =3D &conn->ipv6_login_ip[0];
+		ip_np =3D &np->np_ipv6[0];
+	} else {
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		memset(buf1_ipv4, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, conn->login_ip);
+		iscsi_ntoa2(buf1_ipv4, np->np_ipv4);
+		ip =3D &buf_ipv4[0];
+		ip_np =3D &buf1_ipv4[0];
+	}
+
+	/*
+	 * SCSI Initiator -> SCSI Target Port Mapping
+	 */
+	ts =3D iscsi_get_thread_set();
+	if (!zero_tsih) {
+		iscsi_set_session_parameters(sess->sess_ops,
+				conn->param_list, 0);
+		iscsi_release_param_list(conn->param_list);
+		conn->param_list =3D NULL;
+
+		spin_lock_bh(&sess->conn_lock);
+		atomic_set(&sess->session_continuation, 0);
+		if (sess->session_state =3D=3D TARG_SESS_STATE_FAILED) {
+			TRACE(TRACE_STATE, "Moving to"
+					" TARG_SESS_STATE_LOGGED_IN.\n");
+			sess->session_state =3D TARG_SESS_STATE_LOGGED_IN;
+			stop_timer =3D 1;
+		}
+
+		printk(KERN_INFO "iSCSI Login successful on CID: %hu from %s to"
+			" %s:%hu,%hu\n", conn->cid, ip, ip_np,
+				np->np_port, tpg->tpgt);
+
+		list_add_tail(&conn->conn_list, &sess->sess_conn_list);
+		atomic_inc(&sess->nconn);
+		printk(KERN_INFO "Incremented iSCSI Connection count to %hu"
+			" from node: %s\n", atomic_read(&sess->nconn),
+			SESS_OPS(sess)->InitiatorName);
+		spin_unlock_bh(&sess->conn_lock);
+
+		iscsi_post_login_start_timers(conn);
+		iscsi_activate_thread_set(conn, ts);
+		/*
+		 * Determine CPU mask to ensure connection's RX and TX kthreads
+		 * are scheduled on the same CPU.
+		 */
+		iscsi_thread_get_cpumask(conn);
+		conn->conn_rx_reset_cpumask =3D 1;
+		conn->conn_tx_reset_cpumask =3D 1;
+
+		iscsi_dec_conn_usage_count(conn);
+		if (stop_timer) {
+			spin_lock_bh(&se_tpg->session_lock);
+			iscsi_stop_time2retain_timer(sess);
+			spin_unlock_bh(&se_tpg->session_lock);
+		}
+		iscsi_dec_session_usage_count(sess);
+		return 0;
+	}
+
+	iscsi_set_session_parameters(sess->sess_ops, conn->param_list, 1);
+	iscsi_release_param_list(conn->param_list);
+	conn->param_list =3D NULL;
+
+	iscsi_determine_maxcmdsn(sess);
+
+	spin_lock_bh(&se_tpg->session_lock);
+	__transport_register_session(&sess->tpg->tpg_se_tpg,
+			se_sess->se_node_acl, se_sess, (void *)sess);
+	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_LOGGED_IN.\n");
+	sess->session_state =3D TARG_SESS_STATE_LOGGED_IN;
+
+	printk(KERN_INFO "iSCSI Login successful on CID: %hu from %s to %s:%h=
u,%hu\n",
+		conn->cid, ip, ip_np, np->np_port, tpg->tpgt);
+
+	spin_lock_bh(&sess->conn_lock);
+	list_add_tail(&conn->conn_list, &sess->sess_conn_list);
+	atomic_inc(&sess->nconn);
+	printk(KERN_INFO "Incremented iSCSI Connection count to %hu from node=
:"
+		" %s\n", atomic_read(&sess->nconn),
+		SESS_OPS(sess)->InitiatorName);
+	spin_unlock_bh(&sess->conn_lock);
+
+	sess->sid =3D tpg->sid++;
+	if (!sess->sid)
+		sess->sid =3D tpg->sid++;
+	printk(KERN_INFO "Established iSCSI session from node: %s\n",
+			SESS_OPS(sess)->InitiatorName);
+
+	tpg->nsessions++;
+	if (tpg->tpg_tiqn)
+		tpg->tpg_tiqn->tiqn_nsessions++;
+
+	printk(KERN_INFO "Incremented number of active iSCSI sessions to %u o=
n"
+		" iSCSI Target Portal Group: %hu\n", tpg->nsessions, tpg->tpgt);
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	iscsi_post_login_start_timers(conn);
+	iscsi_activate_thread_set(conn, ts);
+	/*
+	 * Determine CPU mask to ensure connection's RX and TX kthreads
+	 * are scheduled on the same CPU.
+	 */
+	iscsi_thread_get_cpumask(conn);
+	conn->conn_rx_reset_cpumask =3D 1;
+	conn->conn_tx_reset_cpumask =3D 1;
+
+	iscsi_dec_conn_usage_count(conn);
+
+	return 0;
+}
+
+/*	iscsi_handle_login_thread_timeout():
+ *
+ *
+ */
+static void iscsi_handle_login_thread_timeout(unsigned long data)
+{
+	unsigned char buf_ipv4[IPV4_BUF_SIZE];
+	struct iscsi_np *np =3D (struct iscsi_np *) data;
+
+	memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+	spin_lock_bh(&np->np_thread_lock);
+	iscsi_ntoa2(buf_ipv4, np->np_ipv4);
+
+	printk(KERN_ERR "iSCSI Login timeout on Network Portal %s:%hu\n",
+			buf_ipv4, np->np_port);
+
+	if (np->np_login_timer_flags & ISCSI_TF_STOP) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return;
+	}
+
+	if (np->np_thread)
+		send_sig(SIGKILL, np->np_thread, 1);
+
+	np->np_login_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	spin_unlock_bh(&np->np_thread_lock);
+}
+
+/*	iscsi_start_login_thread_timer():
+ *
+ *
+ */
+static void iscsi_start_login_thread_timer(struct iscsi_np *np)
+{
+	/*
+	 * This used the TA_LOGIN_TIMEOUT constant because at this
+	 * point we do not have access to ISCSI_TPG_ATTRIB(tpg)->login_timeou=
t
+	 */
+	spin_lock_bh(&np->np_thread_lock);
+	init_timer(&np->np_login_timer);
+	SETUP_TIMER(np->np_login_timer, TA_LOGIN_TIMEOUT, np,
+			iscsi_handle_login_thread_timeout);
+	np->np_login_timer_flags &=3D ~ISCSI_TF_STOP;
+	np->np_login_timer_flags |=3D ISCSI_TF_RUNNING;
+	add_timer(&np->np_login_timer);
+
+	TRACE(TRACE_LOGIN, "Added timeout timer to iSCSI login request for"
+			" %u seconds.\n", TA_LOGIN_TIMEOUT);
+	spin_unlock_bh(&np->np_thread_lock);
+}
+
+/*	iscsi_stop_login_thread_timer():
+ *
+ *
+ */
+static void iscsi_stop_login_thread_timer(struct iscsi_np *np)
+{
+	spin_lock_bh(&np->np_thread_lock);
+	if (!(np->np_login_timer_flags & ISCSI_TF_RUNNING)) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return;
+	}
+	np->np_login_timer_flags |=3D ISCSI_TF_STOP;
+	spin_unlock_bh(&np->np_thread_lock);
+
+	del_timer_sync(&np->np_login_timer);
+
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_login_timer_flags &=3D ~ISCSI_TF_RUNNING;
+	spin_unlock_bh(&np->np_thread_lock);
+}
+
+/*	iscsi_target_setup_login_socket():
+ *
+ *
+ */
+static struct socket *iscsi_target_setup_login_socket(struct iscsi_np =
*np)
+{
+	const char *end;
+	struct socket *sock;
+	int backlog =3D 5, ip_proto, sock_type, ret, opt =3D 0;
+	struct sockaddr_in sock_in;
+	struct sockaddr_in6 sock_in6;
+
+	switch (np->np_network_transport) {
+	case ISCSI_TCP:
+		ip_proto =3D IPPROTO_TCP;
+		sock_type =3D SOCK_STREAM;
+		break;
+	case ISCSI_SCTP_TCP:
+		ip_proto =3D IPPROTO_SCTP;
+		sock_type =3D SOCK_STREAM;
+		break;
+	case ISCSI_SCTP_UDP:
+		ip_proto =3D IPPROTO_SCTP;
+		sock_type =3D SOCK_SEQPACKET;
+		break;
+	case ISCSI_IWARP_TCP:
+	case ISCSI_IWARP_SCTP:
+	case ISCSI_INFINIBAND:
+	default:
+		printk(KERN_ERR "Unsupported network_transport: %d\n",
+				np->np_network_transport);
+		goto fail;
+	}
+
+	if (sock_create((np->np_flags & NPF_NET_IPV6) ? AF_INET6 : AF_INET,
+			sock_type, ip_proto, &sock) < 0) {
+		printk(KERN_ERR "sock_create() failed.\n");
+		goto fail;
+	}
+	np->np_socket =3D sock;
+
+	/*
+	 * The SCTP stack needs struct socket->file.
+	 */
+	if ((np->np_network_transport =3D=3D ISCSI_SCTP_TCP) ||
+	    (np->np_network_transport =3D=3D ISCSI_SCTP_UDP)) {
+		if (!sock->file) {
+			sock->file =3D kzalloc(sizeof(struct file), GFP_KERNEL);
+			if (!(sock->file)) {
+				printk(KERN_ERR "Unable to allocate struct"
+						" file for SCTP\n");
+				goto fail;
+			}
+			np->np_flags |=3D NPF_SCTP_STRUCT_FILE;
+		}
+	}
+
+	if (np->np_flags & NPF_NET_IPV6) {
+		memset(&sock_in6, 0, sizeof(struct sockaddr_in6));
+		sock_in6.sin6_family =3D AF_INET6;
+		sock_in6.sin6_port =3D htons(np->np_port);
+#if 1
+		ret =3D in6_pton(&np->np_ipv6[0], IPV6_ADDRESS_SPACE,
+				(void *)&sock_in6.sin6_addr.in6_u, -1, &end);
+		if (ret <=3D 0) {
+			printk(KERN_ERR "in6_pton returned: %d\n", ret);
+			goto fail;
+		}
+#else
+		ret =3D iscsi_pton6(&np->np_ipv6[0],
+				(unsigned char *)&sock_in6.sin6_addr.in6_u);
+		if (ret <=3D 0) {
+			printk(KERN_ERR "iscsi_pton6() returned: %d\n", ret);
+			goto fail;
+		}
+#endif
+	} else {
+		memset(&sock_in, 0, sizeof(struct sockaddr_in));
+		sock_in.sin_family =3D AF_INET;
+		sock_in.sin_port =3D htons(np->np_port);
+		sock_in.sin_addr.s_addr =3D htonl(np->np_ipv4);
+	}
+
+	/*
+	 * Set SO_REUSEADDR, and disable Nagel Algorithm with TCP_NODELAY.
+	 */
+	opt =3D 1;
+	if (np->np_network_transport =3D=3D ISCSI_TCP) {
+		ret =3D kernel_setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
+				(char *)&opt, sizeof(opt));
+		if (ret < 0) {
+			printk(KERN_ERR "kernel_setsockopt() for TCP_NODELAY"
+				" failed: %d\n", ret);
+			goto fail;
+		}
+	}
+	ret =3D kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR,
+			(char *)&opt, sizeof(opt));
+	if (ret < 0) {
+		printk(KERN_ERR "kernel_setsockopt() for SO_REUSEADDR"
+			" failed\n");
+		goto fail;
+	}
+
+	if (np->np_flags & NPF_NET_IPV6) {
+		ret =3D kernel_bind(sock, (struct sockaddr *)&sock_in6,
+				sizeof(struct sockaddr_in6));
+		if (ret < 0) {
+			printk(KERN_ERR "kernel_bind() failed: %d\n", ret);
+			goto fail;
+		}
+	} else {
+		ret =3D kernel_bind(sock, (struct sockaddr *)&sock_in,
+				sizeof(struct sockaddr));
+		if (ret < 0) {
+			printk(KERN_ERR "kernel_bind() failed: %d\n", ret);
+			goto fail;
+		}
+	}
+
+	if (kernel_listen(sock, backlog)) {
+		printk(KERN_ERR "kernel_listen() failed.\n");
+		goto fail;
+	}
+
+	return sock;
+
+fail:
+	np->np_socket =3D NULL;
+	if (sock) {
+		if (np->np_flags & NPF_SCTP_STRUCT_FILE) {
+			kfree(sock->file);
+			sock->file =3D NULL;
+		}
+
+		sock_release(sock);
+	}
+	return NULL;
+}
+
+/*	iscsi_target_login_thread():
+ *
+ *
+ */
+int iscsi_target_login_thread(void *arg)
+{
+	u8 buffer[ISCSI_HDR_LEN], iscsi_opcode, zero_tsih =3D 0;
+	unsigned char *ip =3D NULL, *ip_init_buf =3D NULL;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE], buf1_ipv4[IPV4_BUF_SIZE];
+	int err, ret =3D 0, start =3D 1, ip_proto;
+	int sock_type, set_sctp_conn_flag =3D 0;
+	struct iscsi_conn *conn =3D NULL;
+	struct iscsi_login *login;
+	struct iscsi_portal_group *tpg =3D NULL;
+	struct socket *new_sock, *sock;
+	struct iscsi_np *np =3D (struct iscsi_np *) arg;
+	struct iovec iov;
+	struct iscsi_login_req *pdu;
+	struct sockaddr_in sock_in;
+	struct sockaddr_in6 sock_in6;
+
+	{
+	char name[16];
+	memset(name, 0, 16);
+	sprintf(name, "iscsi_np");
+	iscsi_daemon(np->np_thread, name, SHUTDOWN_SIGS);
+	}
+
+	sock =3D iscsi_target_setup_login_socket(np);
+	if (!(sock)) {
+		up(&np->np_start_sem);
+		return -1;
+	}
+
+get_new_sock:
+	flush_signals(current);
+	ip_proto =3D sock_type =3D set_sctp_conn_flag =3D 0;
+
+	switch (np->np_network_transport) {
+	case ISCSI_TCP:
+		ip_proto =3D IPPROTO_TCP;
+		sock_type =3D SOCK_STREAM;
+		break;
+	case ISCSI_SCTP_TCP:
+		ip_proto =3D IPPROTO_SCTP;
+		sock_type =3D SOCK_STREAM;
+		break;
+	case ISCSI_SCTP_UDP:
+		ip_proto =3D IPPROTO_SCTP;
+		sock_type =3D SOCK_SEQPACKET;
+		break;
+	case ISCSI_IWARP_TCP:
+	case ISCSI_IWARP_SCTP:
+	case ISCSI_INFINIBAND:
+	default:
+		printk(KERN_ERR "Unsupported network_transport: %d\n",
+			np->np_network_transport);
+		if (start)
+			up(&np->np_start_sem);
+		return -1;
+	}
+
+	spin_lock_bh(&np->np_thread_lock);
+	if (np->np_thread_state =3D=3D ISCSI_NP_THREAD_SHUTDOWN)
+		goto out;
+	else if (np->np_thread_state =3D=3D ISCSI_NP_THREAD_RESET) {
+		if (atomic_read(&np->np_shutdown)) {
+			spin_unlock_bh(&np->np_thread_lock);
+			up(&np->np_restart_sem);
+			down(&np->np_shutdown_sem);
+			goto out;
+		}
+		np->np_thread_state =3D ISCSI_NP_THREAD_ACTIVE;
+		up(&np->np_restart_sem);
+	} else {
+		np->np_thread_state =3D ISCSI_NP_THREAD_ACTIVE;
+
+		if (start) {
+			start =3D 0;
+			up(&np->np_start_sem);
+		}
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	if (kernel_accept(sock, &new_sock, 0) < 0) {
+		if (signal_pending(current)) {
+			spin_lock_bh(&np->np_thread_lock);
+			if (np->np_thread_state =3D=3D ISCSI_NP_THREAD_RESET) {
+				if (atomic_read(&np->np_shutdown)) {
+					spin_unlock_bh(&np->np_thread_lock);
+					up(&np->np_restart_sem);
+					down(&np->np_shutdown_sem);
+					goto out;
+				}
+				spin_unlock_bh(&np->np_thread_lock);
+				goto get_new_sock;
+			}
+			spin_unlock_bh(&np->np_thread_lock);
+			goto out;
+		}
+		goto get_new_sock;
+	}
+	/*
+	 * The SCTP stack needs struct socket->file.
+	 */
+	if ((np->np_network_transport =3D=3D ISCSI_SCTP_TCP) ||
+	    (np->np_network_transport =3D=3D ISCSI_SCTP_UDP)) {
+		if (!new_sock->file) {
+			new_sock->file =3D kzalloc(
+					sizeof(struct file), GFP_KERNEL);
+			if (!(new_sock->file)) {
+				printk(KERN_ERR "Unable to allocate struct"
+						" file for SCTP\n");
+				sock_release(new_sock);
+				goto get_new_sock;
+			}
+			set_sctp_conn_flag =3D 1;
+		}
+	}
+
+	iscsi_start_login_thread_timer(np);
+
+	conn =3D kmem_cache_zalloc(lio_conn_cache, GFP_KERNEL);
+	if (!(conn)) {
+		printk(KERN_ERR "Could not allocate memory for"
+			" new connection\n");
+		if (set_sctp_conn_flag) {
+			kfree(new_sock->file);
+			new_sock->file =3D NULL;
+		}
+		sock_release(new_sock);
+
+		goto get_new_sock;
+	}
+
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_FREE.\n");
+	conn->conn_state =3D TARG_CONN_STATE_FREE;
+	conn->sock =3D new_sock;
+
+	if (set_sctp_conn_flag)
+		conn->conn_flags |=3D CONNFLAG_SCTP_STRUCT_FILE;
+
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_XPT_UP.\n");
+	conn->conn_state =3D TARG_CONN_STATE_XPT_UP;
+
+	/*
+	 * Allocate conn->conn_ops early as a failure calling
+	 * iscsi_tx_login_rsp() below will call tx_data().
+	 */
+	conn->conn_ops =3D kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL)=
;
+	if (!(conn->conn_ops)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+			" struct iscsi_conn_ops.\n");
+		goto new_sess_out;
+	}
+	/*
+	 * Perform the remaining iSCSI connection initialization items..
+	 */
+	if (iscsi_login_init_conn(conn) < 0)
+		goto new_sess_out;
+
+	memset(buffer, 0, ISCSI_HDR_LEN);
+	memset(&iov, 0, sizeof(struct iovec));
+	iov.iov_base	=3D buffer;
+	iov.iov_len	=3D ISCSI_HDR_LEN;
+
+	if (rx_data(conn, &iov, 1, ISCSI_HDR_LEN) <=3D 0) {
+		printk(KERN_ERR "rx_data() returned an error.\n");
+		goto new_sess_out;
+	}
+
+	iscsi_opcode =3D (buffer[0] & ISCSI_OPCODE_MASK);
+	if (!(iscsi_opcode & ISCSI_OP_LOGIN)) {
+		printk(KERN_ERR "First opcode is not login request,"
+			" failing login request.\n");
+		goto new_sess_out;
+	}
+
+	pdu			=3D (struct iscsi_login_req *) buffer;
+	pdu->cid		=3D be16_to_cpu(pdu->cid);
+	pdu->tsih		=3D be16_to_cpu(pdu->tsih);
+	pdu->itt		=3D be32_to_cpu(pdu->itt);
+	pdu->cmdsn		=3D be32_to_cpu(pdu->cmdsn);
+	pdu->exp_statsn		=3D be32_to_cpu(pdu->exp_statsn);
+	/*
+	 * Used by iscsi_tx_login_rsp() for Login Resonses PDUs
+	 * when Status-Class !=3D 0.
+	*/
+	conn->login_itt		=3D pdu->itt;
+
+	if (np->np_net_size =3D=3D IPV6_ADDRESS_SPACE)
+		ip =3D &np->np_ipv6[0];
+	else {
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, np->np_ipv4);
+		ip =3D &buf_ipv4[0];
+	}
+
+	spin_lock_bh(&np->np_thread_lock);
+	if ((atomic_read(&np->np_shutdown)) ||
+	    (np->np_thread_state !=3D ISCSI_NP_THREAD_ACTIVE)) {
+		spin_unlock_bh(&np->np_thread_lock);
+		printk(KERN_ERR "iSCSI Network Portal on %s:%hu currently not"
+			" active.\n", ip, np->np_port);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
+		goto new_sess_out;
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	if (np->np_net_size =3D=3D IPV6_ADDRESS_SPACE) {
+		memset(&sock_in6, 0, sizeof(struct sockaddr_in6));
+
+		if (conn->sock->ops->getname(conn->sock,
+				(struct sockaddr *)&sock_in6, &err, 1) < 0) {
+			printk(KERN_ERR "sock_ops->getname() failed.\n");
+			iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+					ISCSI_LOGIN_STATUS_TARGET_ERROR);
+			goto new_sess_out;
+		}
+#if 0
+		if (!(iscsi_ntop6((const unsigned char *)
+				&sock_in6.sin6_addr.in6_u,
+				(char *)&conn->ipv6_login_ip[0],
+				IPV6_ADDRESS_SPACE))) {
+			printk(KERN_ERR "iscsi_ntop6() failed\n");
+			iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+					ISCSI_LOGIN_STATUS_TARGET_ERROR);
+			goto new_sess_out;
+		}
+#else
+		printk(KERN_INFO "Skipping iscsi_ntop6()\n");
+#endif
+		ip_init_buf =3D &conn->ipv6_login_ip[0];
+	} else {
+		memset(&sock_in, 0, sizeof(struct sockaddr_in));
+
+		if (conn->sock->ops->getname(conn->sock,
+				(struct sockaddr *)&sock_in, &err, 1) < 0) {
+			printk(KERN_ERR "sock_ops->getname() failed.\n");
+			iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+					ISCSI_LOGIN_STATUS_TARGET_ERROR);
+			goto new_sess_out;
+		}
+		memset(buf1_ipv4, 0, IPV4_BUF_SIZE);
+		conn->login_ip =3D ntohl(sock_in.sin_addr.s_addr);
+		conn->login_port =3D ntohs(sock_in.sin_port);
+		iscsi_ntoa2(buf1_ipv4, conn->login_ip);
+		ip_init_buf =3D &buf1_ipv4[0];
+	}
+
+	conn->network_transport =3D np->np_network_transport;
+	snprintf(conn->net_dev, ISCSI_NETDEV_NAME_SIZE, "%s", np->np_net_dev)=
;
+
+	conn->conn_index =3D iscsi_get_new_index(ISCSI_CONNECTION_INDEX);
+	conn->local_ip =3D np->np_ipv4;
+	conn->local_port =3D np->np_port;
+
+	printk(KERN_INFO "Received iSCSI login request from %s on %s Network"
+			" Portal %s:%hu\n", ip_init_buf,
+		(conn->network_transport =3D=3D ISCSI_TCP) ? "TCP" : "SCTP",
+			ip, np->np_port);
+
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGIN.\n");
+	conn->conn_state	=3D TARG_CONN_STATE_IN_LOGIN;
+
+	if (iscsi_login_check_initiator_version(conn, pdu->max_version,
+			pdu->min_version) < 0)
+		goto new_sess_out;
+
+	zero_tsih =3D (pdu->tsih =3D=3D 0x0000);
+	if ((zero_tsih)) {
+		/*
+		 * This is the leading connection of a new session.
+		 * We wait until after authentication to check for
+		 * session reinstatement.
+		 */
+		if (iscsi_login_zero_tsih_s1(conn, buffer) < 0)
+			goto new_sess_out;
+	} else {
+		/*
+		 * Add a new connection to an existing session.
+		 * We check for a non-existant session in
+		 * iscsi_login_non_zero_tsih_s2() below based
+		 * on ISID/TSIH, but wait until after authentication
+		 * to check for connection reinstatement, etc.
+		 */
+		if (iscsi_login_non_zero_tsih_s1(conn, buffer) < 0)
+			goto new_sess_out;
+	}
+
+	/*
+	 * This will process the first login request, and call
+	 * iscsi_target_locate_portal(), and return a valid struct iscsi_logi=
n.
+	 */
+	login =3D iscsi_target_init_negotiation(np, conn, buffer);
+	if (!(login)) {
+		tpg =3D conn->tpg;
+		goto new_sess_out;
+	}
+
+	tpg =3D conn->tpg;
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to locate struct iscsi_conn->tpg\n");
+		goto new_sess_out;
+	}
+
+	if (zero_tsih) {
+		if (iscsi_login_zero_tsih_s2(conn) < 0) {
+			iscsi_target_nego_release(login, conn);
+			goto new_sess_out;
+		}
+	} else {
+		if (iscsi_login_non_zero_tsih_s2(conn, buffer) < 0) {
+			iscsi_target_nego_release(login, conn);
+			goto old_sess_out;
+		}
+	}
+
+	if (iscsi_target_start_negotiation(login, conn) < 0)
+		goto new_sess_out;
+
+	if (!SESS(conn)) {
+		printk(KERN_ERR "struct iscsi_conn session pointer is NULL!\n");
+		goto new_sess_out;
+	}
+
+	iscsi_stop_login_thread_timer(np);
+
+	if (signal_pending(current))
+		goto new_sess_out;
+
+	ret =3D iscsi_post_login_handler(np, conn, zero_tsih);
+
+	if (ret < 0)
+		goto new_sess_out;
+
+	core_deaccess_np(np, tpg);
+	tpg =3D NULL;
+	goto get_new_sock;
+
+new_sess_out:
+	printk(KERN_ERR "iSCSI Login negotiation failed.\n");
+	iscsi_collect_login_stats(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				  ISCSI_LOGIN_STATUS_INIT_ERR);
+	if (!zero_tsih || !SESS(conn))
+		goto old_sess_out;
+	if (SESS(conn)->se_sess)
+		transport_free_session(SESS(conn)->se_sess);
+	if (SESS(conn)->sess_ops)
+		kfree(SESS(conn)->sess_ops);
+	if (SESS(conn))
+		kmem_cache_free(lio_sess_cache, SESS(conn));
+old_sess_out:
+	iscsi_stop_login_thread_timer(np);
+	/*
+	 * If login negotiation fails check if the Time2Retain timer
+	 * needs to be restarted.
+	 */
+	if (!zero_tsih && SESS(conn)) {
+		spin_lock_bh(&SESS(conn)->conn_lock);
+		if (SESS(conn)->session_state =3D=3D TARG_SESS_STATE_FAILED) {
+			struct se_portal_group *se_tpg =3D
+					&ISCSI_TPG_C(conn)->tpg_se_tpg;
+
+			atomic_set(&SESS(conn)->session_continuation, 0);
+			spin_unlock_bh(&SESS(conn)->conn_lock);
+			spin_lock_bh(&se_tpg->session_lock);
+			iscsi_start_time2retain_handler(SESS(conn));
+			spin_unlock_bh(&se_tpg->session_lock);
+		} else
+			spin_unlock_bh(&SESS(conn)->conn_lock);
+		iscsi_dec_session_usage_count(SESS(conn));
+	}
+
+	if (!IS_ERR(conn->conn_rx_hash.tfm))
+		crypto_free_hash(conn->conn_rx_hash.tfm);
+	if (!IS_ERR(conn->conn_tx_hash.tfm))
+		crypto_free_hash(conn->conn_tx_hash.tfm);
+
+	if (conn->conn_cpumask)
+		free_cpumask_var(conn->conn_cpumask);
+
+	kfree(conn->conn_ops);
+
+	if (conn->param_list) {
+		iscsi_release_param_list(conn->param_list);
+		conn->param_list =3D NULL;
+	}
+	if (conn->sock) {
+		if (conn->conn_flags & CONNFLAG_SCTP_STRUCT_FILE) {
+			kfree(conn->sock->file);
+			conn->sock->file =3D NULL;
+		}
+		sock_release(conn->sock);
+	}
+	kmem_cache_free(lio_conn_cache, conn);
+
+	if (tpg) {
+		core_deaccess_np(np, tpg);
+		tpg =3D NULL;
+	}
+
+	if (!(signal_pending(current)))
+		goto get_new_sock;
+
+	spin_lock_bh(&np->np_thread_lock);
+	if (atomic_read(&np->np_shutdown)) {
+		spin_unlock_bh(&np->np_thread_lock);
+		up(&np->np_restart_sem);
+		down(&np->np_shutdown_sem);
+		goto out;
+	}
+	if (np->np_thread_state !=3D ISCSI_NP_THREAD_SHUTDOWN) {
+		spin_unlock_bh(&np->np_thread_lock);
+		goto get_new_sock;
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+out:
+	iscsi_stop_login_thread_timer(np);
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_thread_state =3D ISCSI_NP_THREAD_EXIT;
+	np->np_thread =3D NULL;
+	spin_unlock_bh(&np->np_thread_lock);
+	up(&np->np_done_sem);
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target=
/iscsi/iscsi_target_login.h
new file mode 100644
index 0000000..d9d129b
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -0,0 +1,14 @@
+#ifndef ISCSI_TARGET_LOGIN_H
+#define ISCSI_TARGET_LOGIN_H
+
+extern int iscsi_login_setup_crypto(struct iscsi_conn *);
+extern int iscsi_check_for_session_reinstatement(struct iscsi_conn *);
+extern int iscsi_login_post_auth_non_zero_tsih(struct iscsi_conn *, u1=
6, u32);
+extern int iscsi_target_login_thread(void *);
+extern int iscsi_login_disable_FIM_keys(struct iscsi_param_list *, str=
uct iscsi_conn *);
+
+extern struct iscsi_global *iscsi_global;
+extern struct kmem_cache *lio_sess_cache;
+extern struct kmem_cache *lio_conn_cache;
+
+#endif   /*** ISCSI_TARGET_LOGIN_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/=
iscsi/iscsi_target_nego.c
new file mode 100644
index 0000000..afa488d
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -0,0 +1,1113 @@
+/*********************************************************************=
**********
+ * This file contains main functions related to iSCSI Parameter negoti=
ation.
+ *
+ * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/ctype.h>
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_tpg.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_parameters.h"
+#include "iscsi_target_login.h"
+#include "iscsi_target_nego.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+#include "iscsi_auth_chap.h"
+
+#define MAX_LOGIN_PDUS  7
+#define TEXT_LEN	4096
+
+void convert_null_to_semi(char *buf, int len)
+{
+	int i;
+
+	for (i =3D 0; i < len; i++)
+		if (buf[i] =3D=3D '\0')
+			buf[i] =3D ';';
+}
+
+int strlen_semi(char *buf)
+{
+	int i =3D 0;
+
+	while (buf[i] !=3D '\0') {
+		if (buf[i] =3D=3D ';')
+			return i;
+		i++;
+	}
+
+	return -1;
+}
+
+int extract_param(
+	const char *in_buf,
+	const char *pattern,
+	unsigned int max_length,
+	char *out_buf,
+	unsigned char *type)
+{
+	char *ptr;
+	int len;
+
+	if (!in_buf || !pattern || !out_buf || !type)
+		return -1;
+
+	ptr =3D strstr(in_buf, pattern);
+	if (!ptr)
+		return -1;
+
+	ptr =3D strstr(ptr, "=3D");
+	if (!ptr)
+		return -1;
+
+	ptr +=3D 1;
+	if (*ptr =3D=3D '0' && (*(ptr+1) =3D=3D 'x' || *(ptr+1) =3D=3D 'X')) =
{
+		ptr +=3D 2; /* skip 0x */
+		*type =3D HEX;
+	} else
+		*type =3D DECIMAL;
+
+	len =3D strlen_semi(ptr);
+	if (len < 0)
+		return -1;
+
+	if (len > max_length) {
+		printk(KERN_ERR "Length of input: %d exeeds max_length:"
+			" %d\n", len, max_length);
+		return -1;
+	}
+	memcpy(out_buf, ptr, len);
+	out_buf[len] =3D '\0';
+
+	return 0;
+}
+
+static u32 iscsi_handle_authentication(
+	struct iscsi_conn *conn,
+	char *in_buf,
+	char *out_buf,
+	int in_length,
+	int *out_length,
+	unsigned char *authtype)
+{
+	struct iscsi_session *sess =3D SESS(conn);
+	struct iscsi_node_auth *auth;
+	struct iscsi_node_acl *iscsi_nacl;
+	struct se_node_acl *se_nacl;
+
+	if (!(SESS_OPS(sess)->SessionType)) {
+		/*
+		 * For SessionType=3DNormal
+		 */
+		se_nacl =3D SESS(conn)->se_sess->se_node_acl;
+		if (!(se_nacl)) {
+			printk(KERN_ERR "Unable to locate struct se_node_acl for"
+					" CHAP auth\n");
+			return -1;
+		}
+		iscsi_nacl =3D container_of(se_nacl, struct iscsi_node_acl,
+				se_node_acl);
+		if (!(iscsi_nacl)) {
+			printk(KERN_ERR "Unable to locate struct iscsi_node_acl for"
+					" CHAP auth\n");
+			return -1;
+		}
+
+		auth =3D ISCSI_NODE_AUTH(iscsi_nacl);
+	} else {
+		/*
+		 * For SessionType=3DDiscovery
+		 */
+		auth =3D &iscsi_global->discovery_acl.node_auth;
+	}
+
+	if (strstr("CHAP", authtype))
+		strcpy(SESS(conn)->auth_type, "CHAP");
+	else
+		strcpy(SESS(conn)->auth_type, NONE);
+
+	if (strstr("None", authtype))
+		return 1;
+#ifdef CANSRP
+	else if (strstr("SRP", authtype))
+		return srp_main_loop(conn, auth, in_buf, out_buf,
+				&in_length, out_length);
+#endif
+	else if (strstr("CHAP", authtype))
+		return chap_main_loop(conn, auth, in_buf, out_buf,
+				&in_length, out_length);
+	else if (strstr("SPKM1", authtype))
+		return 2;
+	else if (strstr("SPKM2", authtype))
+		return 2;
+	else if (strstr("KRB5", authtype))
+		return 2;
+	else
+		return 2;
+}
+
+static void iscsi_remove_failed_auth_entry(struct iscsi_conn *conn)
+{
+	kfree(conn->auth_protocol);
+}
+
+/*	iscsi_target_check_login_request():
+ *
+ *
+ */
+static int iscsi_target_check_login_request(
+	struct iscsi_conn *conn,
+	struct iscsi_login *login)
+{
+	int req_csg, req_nsg, rsp_csg, rsp_nsg;
+	u32 payload_length;
+	struct iscsi_login_req *login_req;
+	struct iscsi_login_rsp *login_rsp;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	login_rsp =3D (struct iscsi_login_rsp *) login->rsp;
+	payload_length =3D ntoh24(login_req->dlength);
+
+	switch (login_req->opcode & ISCSI_OPCODE_MASK) {
+	case ISCSI_OP_LOGIN:
+		break;
+	default:
+		printk(KERN_ERR "Received unknown opcode 0x%02x.\n",
+				login_req->opcode & ISCSI_OPCODE_MASK);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
+		return -1;
+	}
+
+	if ((login_req->flags & ISCSI_FLAG_LOGIN_CONTINUE) &&
+	    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
+		printk(KERN_ERR "Login request has both ISCSI_FLAG_LOGIN_CONTINUE"
+			" and ISCSI_FLAG_LOGIN_TRANSIT set, protocol error.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
+		return -1;
+	}
+
+	req_csg =3D (login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) =
>> 2;
+	rsp_csg =3D (login_rsp->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) =
>> 2;
+	req_nsg =3D (login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE_MASK);
+	rsp_nsg =3D (login_rsp->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE_MASK);
+
+	if (req_csg !=3D login->current_stage) {
+		printk(KERN_ERR "Initiator unexpectedly changed login stage"
+			" from %d to %d, login failed.\n", login->current_stage,
+			req_csg);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
+		return -1;
+	}
+
+	if ((req_nsg =3D=3D 2) || (req_csg >=3D 2) ||
+	   ((login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT) &&
+	    (req_nsg <=3D req_csg))) {
+		printk(KERN_ERR "Illegal login_req->flags Combination, CSG: %d,"
+			" NSG: %d, ISCSI_FLAG_LOGIN_TRANSIT: %d.\n", req_csg,
+			req_nsg, (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT));
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
+		return -1;
+	}
+
+	if ((login_req->max_version !=3D login->version_max) ||
+	    (login_req->min_version !=3D login->version_min)) {
+		printk(KERN_ERR "Login request changed Version Max/Nin"
+			" unexpectedly to 0x%02x/0x%02x, protocol error\n",
+			login_req->max_version, login_req->min_version);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
+		return -1;
+	}
+
+	if (memcmp(login_req->isid, login->isid, 6) !=3D 0) {
+		printk(KERN_ERR "Login request changed ISID unexpectedly,"
+				" protocol error.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
+		return -1;
+	}
+
+	if (login_req->itt !=3D login->init_task_tag) {
+		printk(KERN_ERR "Login request changed ITT unexpectedly to"
+			" 0x%08x, protocol error.\n", login_req->itt);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
+		return -1;
+	}
+
+	if (payload_length > MAX_KEY_VALUE_PAIRS) {
+		printk(KERN_ERR "Login request payload exceeds default"
+			" MaxRecvDataSegmentLength: %u, protocol error.\n",
+				MAX_KEY_VALUE_PAIRS);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_target_check_first_request():
+ *
+ *
+ */
+static int iscsi_target_check_first_request(
+	struct iscsi_conn *conn,
+	struct iscsi_login *login)
+{
+	struct iscsi_param *param =3D NULL;
+	struct se_node_acl *se_nacl;
+
+	login->first_request =3D 0;
+
+	list_for_each_entry(param, &conn->param_list->param_list, p_list) {
+		if (!strncmp(param->name, SESSIONTYPE, 11)) {
+			if (!IS_PSTATE_ACCEPTOR(param)) {
+				printk(KERN_ERR "SessionType key not received"
+					" in first login request.\n");
+				iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
+				return -1;
+			}
+			if (!(strncmp(param->value, DISCOVERY, 9)))
+				return 0;
+		}
+
+		if (!strncmp(param->name, INITIATORNAME, 13)) {
+			if (!IS_PSTATE_ACCEPTOR(param)) {
+				if (!login->leading_connection)
+					continue;
+
+				printk(KERN_ERR "InitiatorName key not received"
+					" in first login request.\n");
+				iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
+				return -1;
+			}
+
+			/*
+			 * For non-leading connections, double check that the
+			 * received InitiatorName matches the existing session's
+			 * struct iscsi_node_acl.
+			 */
+			if (!login->leading_connection) {
+				se_nacl =3D SESS(conn)->se_sess->se_node_acl;
+				if (!(se_nacl)) {
+					printk(KERN_ERR "Unable to locate"
+						" struct se_node_acl\n");
+					iscsi_tx_login_rsp(conn,
+							ISCSI_STATUS_CLS_INITIATOR_ERR,
+							ISCSI_LOGIN_STATUS_TGT_NOT_FOUND);
+					return -1;
+				}
+
+				if (strcmp(param->value,
+						se_nacl->initiatorname)) {
+					printk(KERN_ERR "Incorrect"
+						" InitiatorName: %s for this"
+						" iSCSI Initiator Node.\n",
+						param->value);
+					iscsi_tx_login_rsp(conn,
+							ISCSI_STATUS_CLS_INITIATOR_ERR,
+							ISCSI_LOGIN_STATUS_TGT_NOT_FOUND);
+					return -1;
+				}
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*	iscsi_target_do_tx_login_io():
+ *
+ *
+ */
+static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct=
 iscsi_login *login)
+{
+	u32 padding =3D 0;
+	struct iscsi_session *sess =3D SESS(conn);
+	struct iscsi_login_rsp *login_rsp;
+
+	login_rsp =3D (struct iscsi_login_rsp *) login->rsp;
+
+	login_rsp->opcode		=3D ISCSI_OP_LOGIN_RSP;
+	hton24(login_rsp->dlength, login->rsp_length);
+	memcpy(login_rsp->isid, login->isid, 6);
+	login_rsp->tsih			=3D cpu_to_be16(login->tsih);
+	login_rsp->itt			=3D cpu_to_be32(login->init_task_tag);
+	login_rsp->statsn		=3D cpu_to_be32(conn->stat_sn++);
+	login_rsp->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	login_rsp->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	TRACE(TRACE_LOGIN, "Sending Login Response, Flags: 0x%02x, ITT: 0x%08=
x,"
+		" ExpCmdSN; 0x%08x, MaxCmdSN: 0x%08x, StatSN: 0x%08x, Length:"
+		" %u\n", login_rsp->flags, ntohl(login_rsp->itt),
+		ntohl(login_rsp->exp_cmdsn), ntohl(login_rsp->max_cmdsn),
+		ntohl(login_rsp->statsn), login->rsp_length);
+
+	padding =3D ((-login->rsp_length) & 3);
+
+	if (iscsi_login_tx_data(
+			conn,
+			login->rsp,
+			login->rsp_buf,
+			login->rsp_length + padding) < 0)
+		return -1;
+
+	login->rsp_length		=3D 0;
+	login_rsp->tsih			=3D be16_to_cpu(login_rsp->tsih);
+	login_rsp->itt			=3D be32_to_cpu(login_rsp->itt);
+	login_rsp->statsn		=3D be32_to_cpu(login_rsp->statsn);
+	spin_lock(&sess->cmdsn_lock);
+	login_rsp->exp_cmdsn		=3D be32_to_cpu(sess->exp_cmd_sn);
+	login_rsp->max_cmdsn		=3D be32_to_cpu(sess->max_cmd_sn);
+	spin_unlock(&sess->cmdsn_lock);
+
+	return 0;
+}
+
+/*	iscsi_target_do_rx_login_io():
+ *
+ *
+ */
+static int iscsi_target_do_rx_login_io(struct iscsi_conn *conn, struct=
 iscsi_login *login)
+{
+	u32 padding =3D 0, payload_length;
+	struct iscsi_login_req *login_req;
+
+	if (iscsi_login_rx_data(conn, login->req, ISCSI_HDR_LEN) < 0)
+		return -1;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	payload_length			=3D ntoh24(login_req->dlength);
+	login_req->tsih			=3D be16_to_cpu(login_req->tsih);
+	login_req->itt			=3D be32_to_cpu(login_req->itt);
+	login_req->cid			=3D be16_to_cpu(login_req->cid);
+	login_req->cmdsn		=3D be32_to_cpu(login_req->cmdsn);
+	login_req->exp_statsn		=3D be32_to_cpu(login_req->exp_statsn);
+
+	TRACE(TRACE_LOGIN, "Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+		 login_req->flags, login_req->itt, login_req->cmdsn,
+		 login_req->exp_statsn, login_req->cid, payload_length);
+
+	if (iscsi_target_check_login_request(conn, login) < 0)
+		return -1;
+
+	padding =3D ((-payload_length) & 3);
+	memset(login->req_buf, 0, MAX_KEY_VALUE_PAIRS);
+
+	if (iscsi_login_rx_data(
+			conn,
+			login->req_buf,
+			payload_length + padding) < 0)
+		return -1;
+
+	return 0;
+}
+
+/*      iscsi_target_do_login_io():
+ *
+ *
+ */
+static int iscsi_target_do_login_io(struct iscsi_conn *conn, struct is=
csi_login *login)
+{
+	if (iscsi_target_do_tx_login_io(conn, login) < 0)
+		return -1;
+
+	if (iscsi_target_do_rx_login_io(conn, login) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int iscsi_target_get_initial_payload(
+	struct iscsi_conn *conn,
+	struct iscsi_login *login)
+{
+	u32 padding =3D 0, payload_length;
+	struct iscsi_login_req *login_req;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	payload_length =3D ntoh24(login_req->dlength);
+
+	TRACE(TRACE_LOGIN, "Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
+		login_req->flags, login_req->itt, login_req->cmdsn,
+		login_req->exp_statsn, payload_length);
+
+	if (iscsi_target_check_login_request(conn, login) < 0)
+		return -1;
+
+	padding =3D ((-payload_length) & 3);
+
+	if (iscsi_login_rx_data(
+			conn,
+			login->req_buf,
+			payload_length + padding) < 0)
+		return -1;
+
+	return 0;
+}
+
+/*	iscsi_target_check_for_existing_instances():
+ *
+ *	NOTE: We check for existing sessions or connections AFTER the initi=
ator
+ *	has been successfully authenticated in order to protect against fak=
ed
+ *	ISID/TSIH combinations.
+ */
+static int iscsi_target_check_for_existing_instances(
+	struct iscsi_conn *conn,
+	struct iscsi_login *login)
+{
+	if (login->checked_for_existing)
+		return 0;
+
+	login->checked_for_existing =3D 1;
+
+	if (!login->tsih)
+		return iscsi_check_for_session_reinstatement(conn);
+	else
+		return iscsi_login_post_auth_non_zero_tsih(conn, login->cid,
+				login->initial_exp_statsn);
+}
+
+/*	iscsi_target_do_authentication():
+ *
+ *
+ */
+static int iscsi_target_do_authentication(
+	struct iscsi_conn *conn,
+	struct iscsi_login *login)
+{
+	int authret;
+	u32 payload_length;
+	struct iscsi_param *param;
+	struct iscsi_login_req *login_req;
+	struct iscsi_login_rsp *login_rsp;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	login_rsp =3D (struct iscsi_login_rsp *) login->rsp;
+	payload_length =3D ntoh24(login_req->dlength);
+
+	param =3D iscsi_find_param_from_key(AUTHMETHOD, conn->param_list);
+	if (!(param))
+		return -1;
+
+	authret =3D iscsi_handle_authentication(
+			conn,
+			login->req_buf,
+			login->rsp_buf,
+			payload_length,
+			&login->rsp_length,
+			param->value);
+	switch (authret) {
+	case 0:
+		printk(KERN_INFO "Received OK response"
+		" from LIO Authentication, continuing.\n");
+		break;
+	case 1:
+		printk(KERN_INFO "iSCSI security negotiation"
+			" completed sucessfully.\n");
+		login->auth_complete =3D 1;
+		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
+		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
+			login_rsp->flags |=3D (ISCSI_FLAG_LOGIN_NEXT_STAGE1 |
+					     ISCSI_FLAG_LOGIN_TRANSIT);
+			login->current_stage =3D 1;
+		}
+		return iscsi_target_check_for_existing_instances(
+				conn, login);
+	case 2:
+		printk(KERN_ERR "Security negotiation"
+			" failed.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_AUTH_FAILED);
+		return -1;
+	default:
+		printk(KERN_ERR "Received unknown error %d from LIO"
+				" Authentication\n", authret);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_TARGET_ERROR);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*	iscsi_target_handle_csg_zero():
+ *
+ *
+ */
+static int iscsi_target_handle_csg_zero(
+	struct iscsi_conn *conn,
+	struct iscsi_login *login)
+{
+	int ret;
+	u32 payload_length;
+	struct iscsi_param *param;
+	struct iscsi_login_req *login_req;
+	struct iscsi_login_rsp *login_rsp;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	login_rsp =3D (struct iscsi_login_rsp *) login->rsp;
+	payload_length =3D ntoh24(login_req->dlength);
+
+	param =3D iscsi_find_param_from_key(AUTHMETHOD, conn->param_list);
+	if (!(param))
+		return -1;
+
+	ret =3D iscsi_decode_text_input(
+			PHASE_SECURITY|PHASE_DECLARATIVE,
+			SENDER_INITIATOR|SENDER_RECEIVER,
+			login->req_buf,
+			payload_length,
+			conn->param_list);
+	if (ret < 0)
+		return -1;
+
+	if (ret > 0) {
+		if (login->auth_complete) {
+			printk(KERN_ERR "Initiator has already been"
+				" successfully authenticated, but is still"
+				" sending %s keys.\n", param->value);
+			iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+					ISCSI_LOGIN_STATUS_INIT_ERR);
+			return -1;
+		}
+
+		goto do_auth;
+	}
+
+	if (login->first_request)
+		if (iscsi_target_check_first_request(conn, login) < 0)
+			return -1;
+
+	ret =3D iscsi_encode_text_output(
+			PHASE_SECURITY|PHASE_DECLARATIVE,
+			SENDER_TARGET,
+			login->rsp_buf,
+			&login->rsp_length,
+			conn->param_list);
+	if (ret < 0)
+		return -1;
+
+	if (!(iscsi_check_negotiated_keys(conn->param_list))) {
+		if (ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication &&
+		    !strncmp(param->value, NONE, 4)) {
+			printk(KERN_ERR "Initiator sent AuthMethod=3DNone but"
+				" Target is enforcing iSCSI Authentication,"
+					" login failed.\n");
+			iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+					ISCSI_LOGIN_STATUS_AUTH_FAILED);
+			return -1;
+		}
+
+		if (ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication &&
+		    !login->auth_complete)
+			return 0;
+
+		if (strncmp(param->value, NONE, 4) && !login->auth_complete)
+			return 0;
+
+		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
+		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
+			login_rsp->flags |=3D ISCSI_FLAG_LOGIN_NEXT_STAGE1 |
+					    ISCSI_FLAG_LOGIN_TRANSIT;
+			login->current_stage =3D 1;
+		}
+	}
+
+	return 0;
+do_auth:
+	return iscsi_target_do_authentication(conn, login);
+}
+
+/*	iscsi_target_handle_csg_one():
+ *
+ *
+ */
+static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct=
 iscsi_login *login)
+{
+	int ret;
+	u32 payload_length;
+	struct iscsi_login_req *login_req;
+	struct iscsi_login_rsp *login_rsp;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	login_rsp =3D (struct iscsi_login_rsp *) login->rsp;
+	payload_length =3D ntoh24(login_req->dlength);
+
+	ret =3D iscsi_decode_text_input(
+			PHASE_OPERATIONAL|PHASE_DECLARATIVE,
+			SENDER_INITIATOR|SENDER_RECEIVER,
+			login->req_buf,
+			payload_length,
+			conn->param_list);
+	if (ret < 0)
+		return -1;
+
+	if (login->first_request)
+		if (iscsi_target_check_first_request(conn, login) < 0)
+			return -1;
+
+	if (iscsi_target_check_for_existing_instances(conn, login) < 0)
+		return -1;
+
+	ret =3D iscsi_encode_text_output(
+			PHASE_OPERATIONAL|PHASE_DECLARATIVE,
+			SENDER_TARGET,
+			login->rsp_buf,
+			&login->rsp_length,
+			conn->param_list);
+	if (ret < 0)
+		return -1;
+
+	if (!(login->auth_complete) &&
+	      ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication) {
+		printk(KERN_ERR "Initiator is requesting CSG: 1, has not been"
+			 " successfully authenticated, and the Target is"
+			" enforcing iSCSI Authentication, login failed.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_AUTH_FAILED);
+		return -1;
+	}
+
+	if (!(iscsi_check_negotiated_keys(conn->param_list)))
+		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE3) &&
+		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT))
+			login_rsp->flags |=3D ISCSI_FLAG_LOGIN_NEXT_STAGE3 |
+					    ISCSI_FLAG_LOGIN_TRANSIT;
+
+	return 0;
+}
+
+/*	iscsi_target_do_login():
+ *
+ *
+ */
+static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi=
_login *login)
+{
+	int pdu_count =3D 0;
+	struct iscsi_login_req *login_req;
+	struct iscsi_login_rsp *login_rsp;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	login_rsp =3D (struct iscsi_login_rsp *) login->rsp;
+
+	while (1) {
+		if (++pdu_count > MAX_LOGIN_PDUS) {
+			printk(KERN_ERR "MAX_LOGIN_PDUS count reached.\n");
+			iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+					ISCSI_LOGIN_STATUS_TARGET_ERROR);
+			return -1;
+		}
+
+		switch ((login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) >> =
2) {
+		case 0:
+			login_rsp->flags |=3D (0 & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK);
+			if (iscsi_target_handle_csg_zero(conn, login) < 0)
+				return -1;
+			break;
+		case 1:
+			login_rsp->flags |=3D ISCSI_FLAG_LOGIN_CURRENT_STAGE1;
+			if (iscsi_target_handle_csg_one(conn, login) < 0)
+				return -1;
+			if (login_rsp->flags & ISCSI_FLAG_LOGIN_TRANSIT) {
+				login->tsih =3D SESS(conn)->tsih;
+				if (iscsi_target_do_tx_login_io(conn,
+						login) < 0)
+					return -1;
+				return 0;
+			}
+			break;
+		default:
+			printk(KERN_ERR "Illegal CSG: %d received from"
+				" Initiator, protocol error.\n",
+				(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK)
+				>> 2);
+			break;
+		}
+
+		if (iscsi_target_do_login_io(conn, login) < 0)
+			return -1;
+
+		if (login_rsp->flags & ISCSI_FLAG_LOGIN_TRANSIT) {
+			login_rsp->flags &=3D ~ISCSI_FLAG_LOGIN_TRANSIT;
+			login_rsp->flags &=3D ~ISCSI_FLAG_LOGIN_NEXT_STAGE_MASK;
+		}
+	}
+
+	return 0;
+}
+
+static void iscsi_initiatorname_tolower(
+	char *param_buf)
+{
+	char *c;
+	u32 iqn_size =3D strlen(param_buf), i;
+
+	for (i =3D 0; i < iqn_size; i++) {
+		c =3D (char *)&param_buf[i];
+		if (!(isupper(*c)))
+			continue;
+
+		*c =3D tolower(*c);
+	}
+}
+
+/*
+ * Processes the first Login Request..
+ */
+static int iscsi_target_locate_portal(
+	struct iscsi_np *np,
+	struct iscsi_conn *conn,
+	struct iscsi_login *login)
+{
+	char *i_buf =3D NULL, *s_buf =3D NULL, *t_buf =3D NULL;
+	char *tmpbuf, *start =3D NULL, *end =3D NULL, *key, *value;
+	struct iscsi_session *sess =3D conn->sess;
+	struct iscsi_tiqn *tiqn;
+	struct iscsi_login_req *login_req;
+	struct iscsi_targ_login_rsp *login_rsp;
+	u32 payload_length;
+	int sessiontype =3D 0, ret =3D 0;
+
+	login_req =3D (struct iscsi_login_req *) login->req;
+	login_rsp =3D (struct iscsi_targ_login_rsp *) login->rsp;
+	payload_length =3D ntoh24(login_req->dlength);
+
+	login->first_request	=3D 1;
+	login->leading_connection =3D (!login_req->tsih) ? 1 : 0;
+	login->current_stage	=3D
+		(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) >> 2;
+	login->version_min	=3D login_req->min_version;
+	login->version_max	=3D login_req->max_version;
+	memcpy(login->isid, login_req->isid, 6);
+	login->cmd_sn		=3D login_req->cmdsn;
+	login->init_task_tag	=3D login_req->itt;
+	login->initial_exp_statsn =3D login_req->exp_statsn;
+	login->cid		=3D login_req->cid;
+	login->tsih		=3D login_req->tsih;
+
+	if (iscsi_target_get_initial_payload(conn, login) < 0)
+		return -1;
+
+	tmpbuf =3D kzalloc(payload_length + 1, GFP_KERNEL);
+	if (!(tmpbuf)) {
+		printk(KERN_ERR "Unable to allocate memory for tmpbuf.\n");
+		return -1;
+	}
+
+	memcpy(tmpbuf, login->req_buf, payload_length);
+	tmpbuf[payload_length] =3D '\0';
+	start =3D tmpbuf;
+	end =3D (start + payload_length);
+
+	/*
+	 * Locate the initial keys expected from the Initiator node in
+	 * the first login request in order to progress with the login phase.
+	 */
+	while (start < end) {
+		if (iscsi_extract_key_value(start, &key, &value) < 0) {
+			ret =3D -1;
+			goto out;
+		}
+
+		if (!(strncmp(key, "InitiatorName", 13)))
+			i_buf =3D value;
+		else if (!(strncmp(key, "SessionType", 11)))
+			s_buf =3D value;
+		else if (!(strncmp(key, "TargetName", 10)))
+			t_buf =3D value;
+
+		start +=3D strlen(key) + strlen(value) + 2;
+	}
+
+	/*
+	 * See 5.3.  Login Phase.
+	 */
+	if (!i_buf) {
+		printk(KERN_ERR "InitiatorName key not received"
+			" in first login request.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
+		ret =3D -1;
+		goto out;
+	}
+	/*
+	 * Convert the incoming InitiatorName to lowercase following
+	 * RFC-3720 3.2.6.1. section c) that says that iSCSI IQNs
+	 * are NOT case sensitive.
+	 */
+	iscsi_initiatorname_tolower(i_buf);
+
+	if (!s_buf) {
+		if (!login->leading_connection)
+			goto get_target;
+
+		printk(KERN_ERR "SessionType key not received"
+			" in first login request.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
+		ret =3D -1;
+		goto out;
+	}
+
+	/*
+	 * Use default portal group for discovery sessions.
+	 */
+	sessiontype =3D strncmp(s_buf, DISCOVERY, 9);
+	if (!(sessiontype)) {
+		conn->tpg =3D iscsi_global->discovery_tpg;
+		if (!login->leading_connection)
+			goto get_target;
+
+		SESS_OPS(sess)->SessionType =3D 1;
+		/*
+		 * Setup crc32c modules from libcrypto
+		 */
+		if (iscsi_login_setup_crypto(conn) < 0) {
+			printk(KERN_ERR "iscsi_login_setup_crypto() failed\n");
+			ret =3D -1;
+			goto out;
+		}
+		/*
+		 * Serialize access across the discovery struct iscsi_portal_group t=
o
+		 * process login attempt.
+		 */
+		if (core_access_np(np, conn->tpg) < 0) {
+			iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
+			ret =3D -1;
+			goto out;
+		}
+		ret =3D 0;
+		goto out;
+	}
+
+get_target:
+	if (!t_buf) {
+		printk(KERN_ERR "TargetName key not received"
+			" in first login request while"
+			" SessionType=3DNormal.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
+		ret =3D -1;
+		goto out;
+	}
+
+	/*
+	 * Locate Target IQN from Storage Node.
+	 */
+	tiqn =3D core_get_tiqn_for_login(t_buf);
+	if (!(tiqn)) {
+		printk(KERN_ERR "Unable to locate Target IQN: %s in"
+			" Storage Node\n", t_buf);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
+		ret =3D -1;
+		goto out;
+	}
+	printk(KERN_INFO "Located Storage Object: %s\n", tiqn->tiqn);
+
+	/*
+	 * Locate Target Portal Group from Storage Node.
+	 */
+	conn->tpg =3D core_get_tpg_from_np(tiqn, np);
+	if (!(conn->tpg)) {
+		printk(KERN_ERR "Unable to locate Target Portal Group"
+				" on %s\n", tiqn->tiqn);
+		core_put_tiqn_for_login(tiqn);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
+		ret =3D -1;
+		goto out;
+	}
+	printk(KERN_INFO "Located Portal Group Object: %hu\n", conn->tpg->tpg=
t);
+	/*
+	 * Setup crc32c modules from libcrypto
+	 */
+	if (iscsi_login_setup_crypto(conn) < 0) {
+		printk(KERN_ERR "iscsi_login_setup_crypto() failed\n");
+		ret =3D -1;
+		goto out;
+	}
+	/*
+	 * Serialize access across the struct iscsi_portal_group to
+	 * process login attempt.
+	 */
+	if (core_access_np(np, conn->tpg) < 0) {
+		core_put_tiqn_for_login(tiqn);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
+		ret =3D -1;
+		conn->tpg =3D NULL;
+		goto out;
+	}
+
+	/*
+	 * SESS(conn)->node_acl will be set when the referenced
+	 * struct iscsi_session is located from received ISID+TSIH in
+	 * iscsi_login_non_zero_tsih_s2().
+	 */
+	if (!login->leading_connection) {
+		ret =3D 0;
+		goto out;
+	}
+
+	/*
+	 * This value is required in iscsi_login_zero_tsih_s2()
+	 */
+	SESS_OPS(sess)->SessionType =3D 0;
+
+	/*
+	 * Locate incoming Initiator IQN reference from Storage Node.
+	 */
+	sess->se_sess->se_node_acl =3D core_tpg_check_initiator_node_acl(
+			&conn->tpg->tpg_se_tpg, i_buf);
+	if (!(sess->se_sess->se_node_acl)) {
+		printk(KERN_ERR "iSCSI Initiator Node: %s is not authorized to"
+			" access iSCSI target portal group: %hu.\n",
+				i_buf, conn->tpg->tpgt);
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_TGT_FORBIDDEN);
+		ret =3D -1;
+		goto out;
+	}
+
+	ret =3D 0;
+out:
+	kfree(tmpbuf);
+	return ret;
+}
+
+/*	iscsi_target_init_negotiation():
+ *
+ *
+ */
+struct iscsi_login *iscsi_target_init_negotiation(
+	struct iscsi_np *np,
+	struct iscsi_conn *conn,
+	char *login_pdu)
+{
+	struct iscsi_login *login;
+
+	login =3D kzalloc(sizeof(struct iscsi_login), GFP_KERNEL);
+	if (!(login)) {
+		printk(KERN_ERR "Unable to allocate memory for struct iscsi_login.\n=
");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		goto out;
+	}
+
+	login->req =3D kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!(login->req)) {
+		printk(KERN_ERR "Unable to allocate memory for Login Request.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		goto out;
+	}
+	memcpy(login->req, login_pdu, ISCSI_HDR_LEN);
+
+	login->req_buf =3D kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	if (!(login->req_buf)) {
+		printk(KERN_ERR "Unable to allocate memory for response buffer.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		goto out;
+	}
+	/*
+	 * SessionType: Discovery
+	 *
+	 *	Locates Default Portal
+	 *
+	 * SessionType: Normal
+	 *
+	 *	Locates Target Portal from NP -> Target IQN
+	 */
+	if (iscsi_target_locate_portal(np, conn, login) < 0) {
+		printk(KERN_ERR "iSCSI Login negotiation failed.\n");
+		goto out;
+	}
+
+	return login;
+out:
+	kfree(login->req);
+	kfree(login->req_buf);
+	kfree(login);
+
+	return NULL;
+}
+
+int iscsi_target_start_negotiation(
+	struct iscsi_login *login,
+	struct iscsi_conn *conn)
+{
+	int ret =3D -1;
+
+	login->rsp =3D kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!(login->rsp)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" Login Response.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		ret =3D -1;
+		goto out;
+	}
+
+	login->rsp_buf =3D kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	if (!(login->rsp_buf)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+			" request buffer.\n");
+		iscsi_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+		ret =3D -1;
+		goto out;
+	}
+
+	ret =3D iscsi_target_do_login(conn, login);
+out:
+	if (ret !=3D 0)
+		iscsi_remove_failed_auth_entry(conn);
+
+	iscsi_target_nego_release(login, conn);
+	return ret;
+}
+
+void iscsi_target_nego_release(
+	struct iscsi_login *login,
+	struct iscsi_conn *conn)
+{
+	kfree(login->req);
+	kfree(login->rsp);
+	kfree(login->req_buf);
+	kfree(login->rsp_buf);
+	kfree(login);
+}
diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/=
iscsi/iscsi_target_nego.h
new file mode 100644
index 0000000..fd74f49
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_nego.h
@@ -0,0 +1,19 @@
+#ifndef ISCSI_TARGET_NEGO_H
+#define ISCSI_TARGET_NEGO_H
+
+#define DECIMAL         0
+#define HEX             1
+
+extern void convert_null_to_semi(char *, int);
+extern int extract_param(const char *, const char *, unsigned int, cha=
r *,
+		unsigned char *);
+extern struct iscsi_login *iscsi_target_init_negotiation(
+		struct iscsi_np *, struct iscsi_conn *, char *);
+extern int iscsi_target_start_negotiation(
+		struct iscsi_login *, struct iscsi_conn *);
+extern void iscsi_target_nego_release(
+		struct iscsi_login *, struct iscsi_conn *);
+
+extern struct iscsi_global *iscsi_global;
+
+#endif /* ISCSI_TARGET_NEGO_H */
diff --git a/drivers/target/iscsi/iscsi_thread_queue.c b/drivers/target=
/iscsi/iscsi_thread_queue.c
new file mode 100644
index 0000000..d5feeed
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_thread_queue.c
@@ -0,0 +1,635 @@
+/*********************************************************************=
**********
+ * This file contains the iSCSI Login Thread and Thread Queue function=
s.
+ *
+ * Copyright (c) 2003 PyX Technologies, Inc.
+ * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/smp_lock.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/bitmap.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_thread_queue.h"
+
+/*	iscsi_add_ts_to_active_list():
+ *
+ *
+ */
+static void iscsi_add_ts_to_active_list(struct se_thread_set *ts)
+{
+	spin_lock(&iscsi_global->active_ts_lock);
+	list_add_tail(&ts->ts_list, &iscsi_global->active_ts_list);
+	iscsi_global->active_ts++;
+	spin_unlock(&iscsi_global->active_ts_lock);
+}
+
+/*	iscsi_add_ts_to_inactive_list():
+ *
+ *
+ */
+extern void iscsi_add_ts_to_inactive_list(struct se_thread_set *ts)
+{
+	spin_lock(&iscsi_global->inactive_ts_lock);
+	list_add_tail(&ts->ts_list, &iscsi_global->inactive_ts_list);
+	iscsi_global->inactive_ts++;
+	spin_unlock(&iscsi_global->inactive_ts_lock);
+}
+
+/*	iscsi_del_ts_from_active_list():
+ *
+ *
+ */
+static void iscsi_del_ts_from_active_list(struct se_thread_set *ts)
+{
+	spin_lock(&iscsi_global->active_ts_lock);
+	list_del(&ts->ts_list);
+	iscsi_global->active_ts--;
+	spin_unlock(&iscsi_global->active_ts_lock);
+
+	if (ts->stop_active)
+		up(&ts->stop_active_sem);
+}
+
+/*	iscsi_get_ts_from_inactive_list():
+ *
+ *
+ */
+static struct se_thread_set *iscsi_get_ts_from_inactive_list(void)
+{
+	struct se_thread_set *ts;
+
+	spin_lock(&iscsi_global->inactive_ts_lock);
+	if (list_empty(&iscsi_global->inactive_ts_list)) {
+		spin_unlock(&iscsi_global->inactive_ts_lock);
+		return NULL;
+	}
+
+	list_for_each_entry(ts, &iscsi_global->inactive_ts_list, ts_list)
+		break;
+
+	list_del(&ts->ts_list);
+	iscsi_global->inactive_ts--;
+	spin_unlock(&iscsi_global->inactive_ts_lock);
+
+	return ts;
+}
+
+/*	iscsi_allocate_thread_sets():
+ *
+ *
+ */
+extern int iscsi_allocate_thread_sets(u32 thread_pair_count)
+{
+	int allocated_thread_pair_count =3D 0, i, thread_id;
+	struct se_thread_set *ts =3D NULL;
+
+	for (i =3D 0; i < thread_pair_count; i++) {
+		ts =3D kzalloc(sizeof(struct se_thread_set), GFP_KERNEL);
+		if (!(ts)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+					" thread set.\n");
+			return allocated_thread_pair_count;
+		}
+		/*
+		 * Locate the next available regision in the thread_set_bitmap
+		 */
+		spin_lock(&iscsi_global->ts_bitmap_lock);
+		thread_id =3D bitmap_find_free_region(iscsi_global->ts_bitmap,
+				iscsi_global->ts_bitmap_count, get_order(1));
+		spin_unlock(&iscsi_global->ts_bitmap_lock);
+		if (thread_id < 0) {
+			printk(KERN_ERR "bitmap_find_free_region() failed for"
+				" thread_set_bitmap\n");
+			kfree(ts);
+			return allocated_thread_pair_count;
+		}
+
+		ts->thread_id =3D thread_id;
+		ts->status =3D ISCSI_THREAD_SET_FREE;
+		INIT_LIST_HEAD(&ts->ts_list);
+		spin_lock_init(&ts->ts_state_lock);
+		sema_init(&ts->stop_active_sem, 0);
+		sema_init(&ts->rx_create_sem, 0);
+		sema_init(&ts->tx_create_sem, 0);
+		sema_init(&ts->rx_done_sem, 0);
+		sema_init(&ts->tx_done_sem, 0);
+		sema_init(&ts->rx_post_start_sem, 0);
+		sema_init(&ts->tx_post_start_sem, 0);
+		sema_init(&ts->rx_restart_sem, 0);
+		sema_init(&ts->tx_restart_sem, 0);
+		sema_init(&ts->rx_start_sem, 0);
+		sema_init(&ts->tx_start_sem, 0);
+
+		ts->create_threads =3D 1;
+		kernel_thread(iscsi_target_rx_thread,
+				(void *)ts, 0);
+		down(&ts->rx_create_sem);
+
+		kernel_thread(iscsi_target_tx_thread,
+				(void *)ts, 0);
+		down(&ts->tx_create_sem);
+		ts->create_threads =3D 0;
+
+		iscsi_add_ts_to_inactive_list(ts);
+		allocated_thread_pair_count++;
+	}
+
+	printk(KERN_INFO "Spawned %d thread set(s) (%d total threads).\n",
+		allocated_thread_pair_count, allocated_thread_pair_count * 2);
+	return allocated_thread_pair_count;
+}
+
+/*	iscsi_deallocate_thread_sets():
+ *
+ *
+ */
+extern void iscsi_deallocate_thread_sets(void)
+{
+	u32 released_count =3D 0;
+	struct se_thread_set *ts =3D NULL;
+
+	while ((ts =3D iscsi_get_ts_from_inactive_list())) {
+
+		spin_lock_bh(&ts->ts_state_lock);
+		ts->status =3D ISCSI_THREAD_SET_DIE;
+		spin_unlock_bh(&ts->ts_state_lock);
+
+		if (ts->rx_thread) {
+			send_sig(SIGKILL, ts->rx_thread, 1);
+			down(&ts->rx_done_sem);
+		}
+		if (ts->tx_thread) {
+			send_sig(SIGKILL, ts->tx_thread, 1);
+			down(&ts->tx_done_sem);
+		}
+		/*
+		 * Release this thread_id in the thread_set_bitmap
+		 */
+		spin_lock(&iscsi_global->ts_bitmap_lock);
+		bitmap_release_region(iscsi_global->ts_bitmap,
+				ts->thread_id, get_order(1));
+		spin_unlock(&iscsi_global->ts_bitmap_lock);
+
+		released_count++;
+		kfree(ts);
+	}
+
+	if (released_count)
+		printk(KERN_INFO "Stopped %d thread set(s) (%d total threads)."
+			"\n", released_count, released_count * 2);
+}
+
+/*	iscsi_deallocate_extra_thread_sets():
+ *
+ *
+ */
+static void iscsi_deallocate_extra_thread_sets(void)
+{
+	u32 orig_count, released_count =3D 0;
+	struct se_thread_set *ts =3D NULL;
+
+	orig_count =3D TARGET_THREAD_SET_COUNT;
+
+	while ((iscsi_global->inactive_ts + 1) > orig_count) {
+		ts =3D iscsi_get_ts_from_inactive_list();
+		if (!(ts))
+			break;
+
+		spin_lock_bh(&ts->ts_state_lock);
+		ts->status =3D ISCSI_THREAD_SET_DIE;
+		spin_unlock_bh(&ts->ts_state_lock);
+
+		if (ts->rx_thread) {
+			send_sig(SIGKILL, ts->rx_thread, 1);
+			down(&ts->rx_done_sem);
+		}
+		if (ts->tx_thread) {
+			send_sig(SIGKILL, ts->tx_thread, 1);
+			down(&ts->tx_done_sem);
+		}
+		/*
+		 * Release this thread_id in the thread_set_bitmap
+		 */
+		spin_lock(&iscsi_global->ts_bitmap_lock);
+		bitmap_release_region(iscsi_global->ts_bitmap,
+				ts->thread_id, get_order(1));
+		spin_unlock(&iscsi_global->ts_bitmap_lock);
+
+		released_count++;
+		kfree(ts);
+	}
+
+	if (released_count) {
+		printk(KERN_INFO "Stopped %d thread set(s) (%d total threads)."
+			"\n", released_count, released_count * 2);
+	}
+}
+
+/*	iscsi_activate_thread_set():
+ *
+ *
+ */
+void iscsi_activate_thread_set(struct iscsi_conn *conn, struct se_thre=
ad_set *ts)
+{
+	iscsi_add_ts_to_active_list(ts);
+
+	spin_lock_bh(&ts->ts_state_lock);
+	conn->thread_set =3D ts;
+	ts->conn =3D conn;
+	spin_unlock_bh(&ts->ts_state_lock);
+
+	/*
+	 * Start up the RX thread and wait on rx_post_start_sem.  The RX
+	 * Thread will then do the same for the TX Thread in
+	 * iscsi_rx_thread_pre_handler().
+	 */
+	up(&ts->rx_start_sem);
+	down(&ts->rx_post_start_sem);
+}
+
+/*	iscsi_get_thread_set_timeout():
+ *
+ *
+ */
+static void iscsi_get_thread_set_timeout(unsigned long data)
+{
+	up((struct semaphore *)data);
+}
+
+/*	iscsi_get_thread_set():
+ *
+ *	Parameters:	iSCSI Connection Pointer.
+ *	Returns:	iSCSI Thread Set Pointer
+ */
+struct se_thread_set *iscsi_get_thread_set(void)
+{
+	int allocate_ts =3D 0;
+	struct semaphore sem;
+	struct timer_list timer;
+	struct se_thread_set *ts =3D NULL;
+
+	/*
+	 * If no inactive thread set is available on the first call to
+	 * iscsi_get_ts_from_inactive_list(), sleep for a second and
+	 * try again.  If still none are available after two attempts,
+	 * allocate a set ourselves.
+	 */
+get_set:
+	ts =3D iscsi_get_ts_from_inactive_list();
+	if (!(ts)) {
+		if (allocate_ts =3D=3D 2)
+			iscsi_allocate_thread_sets(1);
+
+		sema_init(&sem, 0);
+		init_timer(&timer);
+		SETUP_TIMER(timer, 1, &sem, iscsi_get_thread_set_timeout);
+		add_timer(&timer);
+
+		down(&sem);
+		del_timer_sync(&timer);
+		allocate_ts++;
+		goto get_set;
+	}
+
+	ts->delay_inactive =3D 1;
+	ts->signal_sent =3D ts->stop_active =3D 0;
+	ts->thread_count =3D 2;
+	sema_init(&ts->rx_restart_sem, 0);
+	sema_init(&ts->tx_restart_sem, 0);
+
+	return ts;
+}
+
+/*	iscsi_set_thread_clear():
+ *
+ *
+ */
+void iscsi_set_thread_clear(struct iscsi_conn *conn, u8 thread_clear)
+{
+	struct se_thread_set *ts =3D NULL;
+
+	if (!conn->thread_set) {
+		printk(KERN_ERR "struct iscsi_conn->thread_set is NULL\n");
+		return;
+	}
+	ts =3D conn->thread_set;
+
+	spin_lock_bh(&ts->ts_state_lock);
+	ts->thread_clear &=3D ~thread_clear;
+
+	if ((thread_clear & ISCSI_CLEAR_RX_THREAD) &&
+	    (ts->blocked_threads & ISCSI_BLOCK_RX_THREAD))
+		up(&ts->rx_restart_sem);
+	else if ((thread_clear & ISCSI_CLEAR_TX_THREAD) &&
+		 (ts->blocked_threads & ISCSI_BLOCK_TX_THREAD))
+		up(&ts->tx_restart_sem);
+	spin_unlock_bh(&ts->ts_state_lock);
+}
+
+/*	iscsi_set_thread_set_signal():
+ *
+ *
+ */
+void iscsi_set_thread_set_signal(struct iscsi_conn *conn, u8 signal_se=
nt)
+{
+	struct se_thread_set *ts =3D NULL;
+
+	if (!conn->thread_set) {
+		printk(KERN_ERR "struct iscsi_conn->thread_set is NULL\n");
+		return;
+	}
+	ts =3D conn->thread_set;
+
+	spin_lock_bh(&ts->ts_state_lock);
+	ts->signal_sent |=3D signal_sent;
+	spin_unlock_bh(&ts->ts_state_lock);
+}
+
+/*	iscsi_release_thread_set():
+ *
+ *	Parameters:	iSCSI Connection Pointer.
+ *	Returns:	0 on success, -1 on error.
+ */
+int iscsi_release_thread_set(struct iscsi_conn *conn)
+{
+	int thread_called =3D 0;
+	struct se_thread_set *ts =3D NULL;
+
+	if (!conn || !conn->thread_set) {
+		printk(KERN_ERR "connection or thread set pointer is NULL\n");
+		BUG();
+	}
+	ts =3D conn->thread_set;
+
+	spin_lock_bh(&ts->ts_state_lock);
+	ts->status =3D ISCSI_THREAD_SET_RESET;
+
+	if (!(strncmp(current->comm, ISCSI_RX_THREAD_NAME,
+			strlen(ISCSI_RX_THREAD_NAME))))
+		thread_called =3D ISCSI_RX_THREAD;
+	else if (!(strncmp(current->comm, ISCSI_TX_THREAD_NAME,
+			strlen(ISCSI_TX_THREAD_NAME))))
+		thread_called =3D ISCSI_TX_THREAD;
+
+	if (ts->rx_thread && (thread_called =3D=3D ISCSI_TX_THREAD) &&
+	   (ts->thread_clear & ISCSI_CLEAR_RX_THREAD)) {
+
+		if (!(ts->signal_sent & ISCSI_SIGNAL_RX_THREAD)) {
+			send_sig(SIGABRT, ts->rx_thread, 1);
+			ts->signal_sent |=3D ISCSI_SIGNAL_RX_THREAD;
+		}
+		ts->blocked_threads |=3D ISCSI_BLOCK_RX_THREAD;
+		spin_unlock_bh(&ts->ts_state_lock);
+		down(&ts->rx_restart_sem);
+		spin_lock_bh(&ts->ts_state_lock);
+		ts->blocked_threads &=3D ~ISCSI_BLOCK_RX_THREAD;
+	}
+	if (ts->tx_thread && (thread_called =3D=3D ISCSI_RX_THREAD) &&
+	   (ts->thread_clear & ISCSI_CLEAR_TX_THREAD)) {
+
+		if (!(ts->signal_sent & ISCSI_SIGNAL_TX_THREAD)) {
+			send_sig(SIGABRT, ts->tx_thread, 1);
+			ts->signal_sent |=3D ISCSI_SIGNAL_TX_THREAD;
+		}
+		ts->blocked_threads |=3D ISCSI_BLOCK_TX_THREAD;
+		spin_unlock_bh(&ts->ts_state_lock);
+		down(&ts->tx_restart_sem);
+		spin_lock_bh(&ts->ts_state_lock);
+		ts->blocked_threads &=3D ~ISCSI_BLOCK_TX_THREAD;
+	}
+
+	conn->thread_set =3D NULL;
+	ts->conn =3D NULL;
+	ts->status =3D ISCSI_THREAD_SET_FREE;
+	spin_unlock_bh(&ts->ts_state_lock);
+
+	return 0;
+}
+
+/*	iscsi_thread_set_force_reinstatement():
+ *
+ *
+ */
+int iscsi_thread_set_force_reinstatement(struct iscsi_conn *conn)
+{
+	struct se_thread_set *ts;
+
+	if (!conn->thread_set)
+		return -1;
+	ts =3D conn->thread_set;
+
+	spin_lock_bh(&ts->ts_state_lock);
+	if (ts->status !=3D ISCSI_THREAD_SET_ACTIVE) {
+		spin_unlock_bh(&ts->ts_state_lock);
+		return -1;
+	}
+
+	if (ts->tx_thread && (!(ts->signal_sent & ISCSI_SIGNAL_TX_THREAD))) {
+		send_sig(SIGABRT, ts->tx_thread, 1);
+		ts->signal_sent |=3D ISCSI_SIGNAL_TX_THREAD;
+	}
+	if (ts->rx_thread && (!(ts->signal_sent & ISCSI_SIGNAL_RX_THREAD))) {
+		send_sig(SIGABRT, ts->rx_thread, 1);
+		ts->signal_sent |=3D ISCSI_SIGNAL_RX_THREAD;
+	}
+	spin_unlock_bh(&ts->ts_state_lock);
+
+	return 0;
+}
+
+/*	iscsi_check_to_add_additional_sets():
+ *
+ *
+ */
+static void iscsi_check_to_add_additional_sets(void)
+{
+	int thread_sets_add;
+
+	spin_lock(&iscsi_global->inactive_ts_lock);
+	thread_sets_add =3D iscsi_global->inactive_ts;
+	spin_unlock(&iscsi_global->inactive_ts_lock);
+	if (thread_sets_add =3D=3D 1)
+		iscsi_allocate_thread_sets(1);
+}
+
+/*	iscsi_signal_thread_pre_handler():
+ *
+ *
+ */
+static int iscsi_signal_thread_pre_handler(struct se_thread_set *ts)
+{
+	spin_lock_bh(&ts->ts_state_lock);
+	if ((ts->status =3D=3D ISCSI_THREAD_SET_DIE) || signal_pending(curren=
t)) {
+		spin_unlock_bh(&ts->ts_state_lock);
+		return -1;
+	}
+	spin_unlock_bh(&ts->ts_state_lock);
+
+	return 0;
+}
+
+/*	iscsi_rx_thread_pre_handler():
+ *
+ *
+ */
+struct iscsi_conn *iscsi_rx_thread_pre_handler(struct se_thread_set *t=
s)
+{
+	int ret;
+
+	spin_lock_bh(&ts->ts_state_lock);
+	if (ts->create_threads) {
+		spin_unlock_bh(&ts->ts_state_lock);
+		up(&ts->rx_create_sem);
+		goto sleep;
+	}
+
+	flush_signals(current);
+
+	if (ts->delay_inactive && (--ts->thread_count =3D=3D 0)) {
+		spin_unlock_bh(&ts->ts_state_lock);
+		iscsi_del_ts_from_active_list(ts);
+
+		if (!iscsi_global->in_shutdown)
+			iscsi_deallocate_extra_thread_sets();
+
+		iscsi_add_ts_to_inactive_list(ts);
+		spin_lock_bh(&ts->ts_state_lock);
+	}
+
+	if ((ts->status =3D=3D ISCSI_THREAD_SET_RESET) &&
+	    (ts->thread_clear & ISCSI_CLEAR_RX_THREAD))
+		up(&ts->rx_restart_sem);
+
+	ts->thread_clear &=3D ~ISCSI_CLEAR_RX_THREAD;
+	spin_unlock_bh(&ts->ts_state_lock);
+sleep:
+	ret =3D down_interruptible(&ts->rx_start_sem);
+	if (ret !=3D 0)
+		return NULL;
+
+	if (iscsi_signal_thread_pre_handler(ts) < 0)
+		return NULL;
+
+	if (!ts->conn) {
+		printk(KERN_ERR "struct se_thread_set->conn is NULL for"
+			" thread_id: %d, going back to sleep\n", ts->thread_id);
+		goto sleep;
+	}
+	iscsi_check_to_add_additional_sets();
+	/*
+	 * The RX Thread starts up the TX Thread and sleeps.
+	 */
+	ts->thread_clear |=3D ISCSI_CLEAR_RX_THREAD;
+	up(&ts->tx_start_sem);
+	down(&ts->tx_post_start_sem);
+
+	return ts->conn;
+}
+
+/*	iscsi_tx_thread_pre_handler():
+ *
+ *
+ */
+struct iscsi_conn *iscsi_tx_thread_pre_handler(struct se_thread_set *t=
s)
+{
+	int ret;
+
+	spin_lock_bh(&ts->ts_state_lock);
+	if (ts->create_threads) {
+		spin_unlock_bh(&ts->ts_state_lock);
+		up(&ts->tx_create_sem);
+		goto sleep;
+	}
+
+	flush_signals(current);
+
+	if (ts->delay_inactive && (--ts->thread_count =3D=3D 0)) {
+		spin_unlock_bh(&ts->ts_state_lock);
+		iscsi_del_ts_from_active_list(ts);
+
+		if (!iscsi_global->in_shutdown)
+			iscsi_deallocate_extra_thread_sets();
+
+		iscsi_add_ts_to_inactive_list(ts);
+		spin_lock_bh(&ts->ts_state_lock);
+	}
+	if ((ts->status =3D=3D ISCSI_THREAD_SET_RESET) &&
+	    (ts->thread_clear & ISCSI_CLEAR_TX_THREAD))
+		up(&ts->tx_restart_sem);
+
+	ts->thread_clear &=3D ~ISCSI_CLEAR_TX_THREAD;
+	spin_unlock_bh(&ts->ts_state_lock);
+sleep:
+	ret =3D down_interruptible(&ts->tx_start_sem);
+	if (ret !=3D 0)
+		return NULL;
+
+	if (iscsi_signal_thread_pre_handler(ts) < 0)
+		return NULL;
+
+	if (!ts->conn) {
+		printk(KERN_ERR "struct se_thread_set->conn is NULL for "
+			" thread_id: %d, going back to sleep\n",
+			ts->thread_id);
+		goto sleep;
+	}
+
+	iscsi_check_to_add_additional_sets();
+	/*
+	 * From the TX thread, up the tx_post_start_sem that the RX Thread is
+	 * sleeping on in iscsi_rx_thread_pre_handler(), then up the
+	 * rx_post_start_sem that iscsi_activate_thread_set() is sleeping on.
+	 */
+	ts->thread_clear |=3D ISCSI_CLEAR_TX_THREAD;
+	up(&ts->tx_post_start_sem);
+	up(&ts->rx_post_start_sem);
+
+	spin_lock_bh(&ts->ts_state_lock);
+	ts->status =3D ISCSI_THREAD_SET_ACTIVE;
+	spin_unlock_bh(&ts->ts_state_lock);
+
+	return ts->conn;
+}
+
+int iscsi_thread_set_init(void)
+{
+	int size;
+
+	iscsi_global->ts_bitmap_count =3D ISCSI_TS_BITMAP_BITS;
+
+	size =3D BITS_TO_LONGS(iscsi_global->ts_bitmap_count) * sizeof(long);
+	iscsi_global->ts_bitmap =3D kzalloc(size, GFP_KERNEL);
+	if (!(iscsi_global->ts_bitmap)) {
+		printk(KERN_ERR "Unable to allocate iscsi_global->ts_bitmap\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void iscsi_thread_set_free(void)
+{
+	kfree(iscsi_global->ts_bitmap);
+}
diff --git a/drivers/target/iscsi/iscsi_thread_queue.h b/drivers/target=
/iscsi/iscsi_thread_queue.h
new file mode 100644
index 0000000..55dc5f6
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_thread_queue.h
@@ -0,0 +1,102 @@
+#ifndef ISCSI_THREAD_QUEUE_H
+#define ISCSI_THREAD_QUEUE_H
+
+/*
+ * Defines for thread sets.
+ */
+extern int iscsi_thread_set_force_reinstatement(struct iscsi_conn *);
+extern void iscsi_add_ts_to_inactive_list(struct se_thread_set *);
+extern int iscsi_allocate_thread_sets(u32);
+extern void iscsi_deallocate_thread_sets(void);
+extern void iscsi_activate_thread_set(struct iscsi_conn *, struct se_t=
hread_set *);
+extern struct se_thread_set *iscsi_get_thread_set(void);
+extern void iscsi_set_thread_clear(struct iscsi_conn *, u8);
+extern void iscsi_set_thread_set_signal(struct iscsi_conn *, u8);
+extern int iscsi_release_thread_set(struct iscsi_conn *);
+extern struct iscsi_conn *iscsi_rx_thread_pre_handler(struct se_thread=
_set *);
+extern struct iscsi_conn *iscsi_tx_thread_pre_handler(struct se_thread=
_set *);
+extern int iscsi_thread_set_init(void);
+extern void iscsi_thread_set_free(void);
+
+extern int iscsi_target_tx_thread(void *);
+extern int iscsi_target_rx_thread(void *);
+extern struct iscsi_global *iscsi_global;
+
+#define INITIATOR_THREAD_SET_COUNT		4
+#define TARGET_THREAD_SET_COUNT			4
+
+#define ISCSI_RX_THREAD                         1
+#define ISCSI_TX_THREAD                         2
+#define ISCSI_RX_THREAD_NAME			"iscsi_trx"
+#define ISCSI_TX_THREAD_NAME			"iscsi_ttx"
+#define ISCSI_BLOCK_RX_THREAD			0x1
+#define ISCSI_BLOCK_TX_THREAD			0x2
+#define ISCSI_CLEAR_RX_THREAD			0x1
+#define ISCSI_CLEAR_TX_THREAD			0x2
+#define ISCSI_SIGNAL_RX_THREAD			0x1
+#define ISCSI_SIGNAL_TX_THREAD			0x2
+
+/* struct se_thread_set->status */
+#define ISCSI_THREAD_SET_FREE			1
+#define ISCSI_THREAD_SET_ACTIVE			2
+#define ISCSI_THREAD_SET_DIE			3
+#define ISCSI_THREAD_SET_RESET			4
+#define ISCSI_THREAD_SET_DEALLOCATE_THREADS	5
+
+/* By default allow a maximum of 32K iSCSI connections */
+#define ISCSI_TS_BITMAP_BITS			32768
+
+struct se_thread_set {
+	/* flags used for blocking and restarting sets */
+	u8	blocked_threads;
+	/* flag for creating threads */
+	u8	create_threads;
+	/* flag for delaying readding to inactive list */
+	u8	delay_inactive;
+	/* status for thread set */
+	u8	status;
+	/* which threads have had signals sent */
+	u8	signal_sent;
+	/* used for stopping active sets during shutdown */
+	u8	stop_active;
+	/* flag for which threads exited first */
+	u8	thread_clear;
+	/* Active threads in the thread set */
+	u8	thread_count;
+	/* Unique thread ID */
+	u32	thread_id;
+	/* pointer to connection if set is active */
+	struct iscsi_conn	*conn;
+	/* used for controlling ts state accesses */
+	spinlock_t	ts_state_lock;
+	/* used for stopping active sets during shutdown */
+	struct semaphore	stop_active_sem;
+	/* used for controlling thread creation */
+	struct semaphore	rx_create_sem;
+	/* used for controlling thread creation */
+	struct semaphore	tx_create_sem;
+	/* used for controlling killing */
+	struct semaphore	rx_done_sem;
+	/* used for controlling killing */
+	struct semaphore	tx_done_sem;
+	/* Used for rx side post startup */
+	struct semaphore	rx_post_start_sem;
+	/* Used for tx side post startup */
+	struct semaphore	tx_post_start_sem;
+	/* used for restarting thread queue */
+	struct semaphore	rx_restart_sem;
+	/* used for restarting thread queue */
+	struct semaphore	tx_restart_sem;
+	/* used for normal unused blocking */
+	struct semaphore	rx_start_sem;
+	/* used for normal unused blocking */
+	struct semaphore	tx_start_sem;
+	/* OS descriptor for rx thread */
+	struct task_struct	*rx_thread;
+	/* OS descriptor for tx thread */
+	struct task_struct	*tx_thread;
+	/* struct se_thread_set in list list head*/
+	struct list_head	ts_list;
+} ____cacheline_aligned;
+
+#endif   /*** ISCSI_THREAD_QUEUE_H ***/
--=20
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
