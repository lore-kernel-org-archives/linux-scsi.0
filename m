Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8543EC56201
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28B3B21D7B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WSO4WsrS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437248AbgJUJ2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:28:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403891AbgJUJ2b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 05:28:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L9OcdA006663
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:28:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YlWhd4A8HAITFSYWPMCR5Hw8hQNLEuB1Ujgs0iXuVVE=;
 b=WSO4WsrSrZjPSDDIvKW3qtQPzRlB4WW+ySr6iAvnArFF7SoUg6jiPutx0pjAABAnGEPZ
 0KAh7FpaGxN4GXmGd4j8318zxR09iE0jEisaqmH+d2jSC193qWn704Ch9xNyVbwhQnZ9
 NVOpnCVFfrQ4wN0Ku6X88vSE9TH0d+Ng9uZjlmqf/3M2NEPNnHa2Ks9qpAofy+AoOQRn
 IN279CojuV/4cL3iM2XpkbVbuHUPn5o4QuwzIs8+Gf3PIWUAFpnZepWZySrdBQW1Jdg6
 LCoi4Wfmg/5cB4Y0+pYjHA43OBGT1CMkFdubGbb1D2N7ZrXmmK2GGOPWmcwDw9NsZbYR og== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 347wyqcmau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:28:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct
 2020 02:28:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct
 2020 02:28:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Oct 2020 02:28:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AB09F3F703F;
        Wed, 21 Oct 2020 02:28:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 09L9SR4x022720;
        Wed, 21 Oct 2020 02:28:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 09L9SRcp022719;
        Wed, 21 Oct 2020 02:28:27 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 2/5] scsi: fc: Add FPIN statistics to fc_host and fc_rport objects
Date:   Wed, 21 Oct 2020 02:27:12 -0700
Message-ID: <20201021092715.22669-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201021092715.22669-1-njavali@marvell.com>
References: <20201021092715.22669-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

- Adds a structure for holding fpin stats for host & rport

- Adds sysfs nodes to maintain FPIN stats:
        /sys/class/fc_host/hostXX/statistics/
        /sys/class/fc_remote_ports/rport-XX\:Y-Z/statistics/

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/scsi_transport_fc.c | 117 +++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_fc.h |  32 +++++++++
 2 files changed, 149 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2ff7f06203da..501e165ae6f1 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -22,6 +22,7 @@
 #include <net/netlink.h>
 #include <scsi/scsi_netlink_fc.h>
 #include <scsi/scsi_bsg_fc.h>
+#include <uapi/scsi/fc/fc_els.h>
 #include "scsi_priv.h"
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
@@ -419,6 +420,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	fc_host->fabric_name = -1;
 	memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
 	memset(fc_host->system_hostname, 0, sizeof(fc_host->system_hostname));
+	memset(&fc_host->fpin_stats, 0, sizeof(fc_host->fpin_stats));
 
 	fc_host->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
 
@@ -991,6 +993,67 @@ store_fc_rport_fast_io_fail_tmo(struct device *dev,
 static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);
 
+#define fc_rport_fpin_statistic(name)					\
+static ssize_t fc_rport_fpinstat_##name(struct device *cd,		\
+				  struct device_attribute *attr,	\
+				  char *buf)				\
+{									\
+	struct fc_rport *rport = transport_class_to_rport(cd);		\
+									\
+	return snprintf(buf, 20, "0x%llx\n", rport->fpin_stats.name);	\
+}									\
+static FC_DEVICE_ATTR(rport, fpin_##name, 0444, fc_rport_fpinstat_##name, NULL)
+
+fc_rport_fpin_statistic(dn);
+fc_rport_fpin_statistic(dn_unknown);
+fc_rport_fpin_statistic(dn_timeout);
+fc_rport_fpin_statistic(dn_unable_to_route);
+fc_rport_fpin_statistic(dn_device_specific);
+fc_rport_fpin_statistic(cn);
+fc_rport_fpin_statistic(cn_clear);
+fc_rport_fpin_statistic(cn_lost_credit);
+fc_rport_fpin_statistic(cn_credit_stall);
+fc_rport_fpin_statistic(cn_oversubscription);
+fc_rport_fpin_statistic(cn_device_specific);
+fc_rport_fpin_statistic(li);
+fc_rport_fpin_statistic(li_failure_unknown);
+fc_rport_fpin_statistic(li_link_failure_count);
+fc_rport_fpin_statistic(li_loss_of_sync_count);
+fc_rport_fpin_statistic(li_loss_of_signals_count);
+fc_rport_fpin_statistic(li_prim_seq_err_count);
+fc_rport_fpin_statistic(li_invalid_tx_word_count);
+fc_rport_fpin_statistic(li_invalid_crc_count);
+fc_rport_fpin_statistic(li_device_specific);
+
+static struct attribute *fc_rport_statistics_attrs[] = {
+	&device_attr_rport_fpin_dn.attr,
+	&device_attr_rport_fpin_dn_unknown.attr,
+	&device_attr_rport_fpin_dn_timeout.attr,
+	&device_attr_rport_fpin_dn_unable_to_route.attr,
+	&device_attr_rport_fpin_dn_device_specific.attr,
+	&device_attr_rport_fpin_li.attr,
+	&device_attr_rport_fpin_li_failure_unknown.attr,
+	&device_attr_rport_fpin_li_link_failure_count.attr,
+	&device_attr_rport_fpin_li_loss_of_sync_count.attr,
+	&device_attr_rport_fpin_li_loss_of_signals_count.attr,
+	&device_attr_rport_fpin_li_prim_seq_err_count.attr,
+	&device_attr_rport_fpin_li_invalid_tx_word_count.attr,
+	&device_attr_rport_fpin_li_invalid_crc_count.attr,
+	&device_attr_rport_fpin_li_device_specific.attr,
+	&device_attr_rport_fpin_cn.attr,
+	&device_attr_rport_fpin_cn_clear.attr,
+	&device_attr_rport_fpin_cn_lost_credit.attr,
+	&device_attr_rport_fpin_cn_credit_stall.attr,
+	&device_attr_rport_fpin_cn_oversubscription.attr,
+	&device_attr_rport_fpin_cn_device_specific.attr,
+	NULL
+};
+
+static struct attribute_group fc_rport_statistics_group = {
+	.name = "statistics",
+	.attrs = fc_rport_statistics_attrs,
+};
+
 
 /*
  * FC SCSI Target Attribute Management
@@ -1745,6 +1808,39 @@ fc_host_statistic(fc_xid_busy);
 fc_host_statistic(fc_seq_not_found);
 fc_host_statistic(fc_non_bls_resp);
 
+#define fc_host_fpin_statistic(name)					\
+static ssize_t fc_host_fpinstat_##name(struct device *cd,		\
+				  struct device_attribute *attr,	\
+				  char *buf)				\
+{									\
+	struct Scsi_Host *shost = transport_class_to_shost(cd);		\
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);	\
+									\
+	return snprintf(buf, 20, "0x%llx\n", fc_host->fpin_stats.name);	\
+}									\
+static FC_DEVICE_ATTR(host, fpin_##name, 0444, fc_host_fpinstat_##name, NULL)
+
+fc_host_fpin_statistic(dn);
+fc_host_fpin_statistic(dn_unknown);
+fc_host_fpin_statistic(dn_timeout);
+fc_host_fpin_statistic(dn_unable_to_route);
+fc_host_fpin_statistic(dn_device_specific);
+fc_host_fpin_statistic(cn);
+fc_host_fpin_statistic(cn_clear);
+fc_host_fpin_statistic(cn_lost_credit);
+fc_host_fpin_statistic(cn_credit_stall);
+fc_host_fpin_statistic(cn_oversubscription);
+fc_host_fpin_statistic(cn_device_specific);
+fc_host_fpin_statistic(li);
+fc_host_fpin_statistic(li_failure_unknown);
+fc_host_fpin_statistic(li_link_failure_count);
+fc_host_fpin_statistic(li_loss_of_sync_count);
+fc_host_fpin_statistic(li_loss_of_signals_count);
+fc_host_fpin_statistic(li_prim_seq_err_count);
+fc_host_fpin_statistic(li_invalid_tx_word_count);
+fc_host_fpin_statistic(li_invalid_crc_count);
+fc_host_fpin_statistic(li_device_specific);
+
 static ssize_t
 fc_reset_statistics(struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
@@ -1794,6 +1890,26 @@ static struct attribute *fc_statistics_attrs[] = {
 	&device_attr_host_fc_seq_not_found.attr,
 	&device_attr_host_fc_non_bls_resp.attr,
 	&device_attr_host_reset_statistics.attr,
+	&device_attr_host_fpin_dn.attr,
+	&device_attr_host_fpin_dn_unknown.attr,
+	&device_attr_host_fpin_dn_timeout.attr,
+	&device_attr_host_fpin_dn_unable_to_route.attr,
+	&device_attr_host_fpin_dn_device_specific.attr,
+	&device_attr_host_fpin_li.attr,
+	&device_attr_host_fpin_li_failure_unknown.attr,
+	&device_attr_host_fpin_li_link_failure_count.attr,
+	&device_attr_host_fpin_li_loss_of_sync_count.attr,
+	&device_attr_host_fpin_li_loss_of_signals_count.attr,
+	&device_attr_host_fpin_li_prim_seq_err_count.attr,
+	&device_attr_host_fpin_li_invalid_tx_word_count.attr,
+	&device_attr_host_fpin_li_invalid_crc_count.attr,
+	&device_attr_host_fpin_li_device_specific.attr,
+	&device_attr_host_fpin_cn.attr,
+	&device_attr_host_fpin_cn_clear.attr,
+	&device_attr_host_fpin_cn_lost_credit.attr,
+	&device_attr_host_fpin_cn_credit_stall.attr,
+	&device_attr_host_fpin_cn_oversubscription.attr,
+	&device_attr_host_fpin_cn_device_specific.attr,
 	NULL
 };
 
@@ -2177,6 +2293,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
 	i->rport_attr_cont.ac.class = &fc_rport_class.class;
 	i->rport_attr_cont.ac.match = fc_rport_match;
+	i->rport_attr_cont.statistics = &fc_rport_statistics_group;
 	transport_container_register(&i->rport_attr_cont);
 
 	i->vport_attr_cont.ac.attrs = &i->vport_attrs[0];
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 1c7dd35cb7a0..487a403ee51e 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -285,6 +285,36 @@ struct fc_rport_identifiers {
 	u32 roles;
 };
 
+/*
+ * Fabric Performance Impact Notification Statistics
+ */
+struct fc_fpin_stats {
+	/* Delivery */
+	u64 dn;
+	u64 dn_unknown;
+	u64 dn_timeout;
+	u64 dn_unable_to_route;
+	u64 dn_device_specific;
+
+	/* Link Integrity */
+	u64 li;
+	u64 li_failure_unknown;
+	u64 li_link_failure_count;
+	u64 li_loss_of_sync_count;
+	u64 li_loss_of_signals_count;
+	u64 li_prim_seq_err_count;
+	u64 li_invalid_tx_word_count;
+	u64 li_invalid_crc_count;
+	u64 li_device_specific;
+
+	/* Congestion/Peer Congestion */
+	u64 cn;
+	u64 cn_clear;
+	u64 cn_lost_credit;
+	u64 cn_credit_stall;
+	u64 cn_oversubscription;
+	u64 cn_device_specific;
+};
 
 /* Macro for use in defining Remote Port attributes */
 #define FC_RPORT_ATTR(_name,_mode,_show,_store)				\
@@ -326,6 +356,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
 
 	/* Dynamic Attributes */
 	u32 dev_loss_tmo;	/* Remote Port loss timeout in seconds. */
+	struct fc_fpin_stats fpin_stats;
 
 	/* Private (Transport-managed) Attributes */
 	u64 node_name;
@@ -516,6 +547,7 @@ struct fc_host_attrs {
 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
 	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
 	u32 dev_loss_tmo;
+	struct fc_fpin_stats fpin_stats;
 
 	/* Private (Transport-managed) Attributes */
 	enum fc_tgtid_binding_type  tgtid_bind_type;
-- 
2.19.0.rc0

