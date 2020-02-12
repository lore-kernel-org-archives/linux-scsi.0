Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A70C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CDAB217F4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ig92Ufw3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgBLVou (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:44:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVou (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:44:50 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLf6WJ001716;
        Wed, 12 Feb 2020 13:44:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=QrA9Lbqx+S+8p49awJmmzMFzc5lm8CpspKI3erlUEv4=;
 b=ig92Ufw3a6Iv1I7US/BVgeW8GVU6vJ13bwFpWGHKGKa6czxxW5q8c8RzZ5VLMFtptkYO
 Ge2IuKh9JQKwDC8XKbgdYcD3LUEJZ+yB2IRjEByDfJS2Lkfu0zhd/jpEBJfYWtyfLdU1
 2ioRlwBb39jQqs2Ib/c6Rx7FeV6CtLAweJKrZe6v+NvOP4gqaH1fPsbx0IOpcyciF62g
 /AVDQW2GXAULRcwW65E4W6vPnWKj9hDxy+MZQugmWPlhrQvuhl9HioFK4vAQick3LDoZ
 BzXJy0ydTfC9cWznwKcHsRY2O43Mwh6+bX6rDtYHRl6EYl0KTiaNGPRR/js6L1oS+Fa9 sw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:44:47 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:46 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:44:46 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F04D33F703F;
        Wed, 12 Feb 2020 13:44:45 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLijsg025580;
        Wed, 12 Feb 2020 13:44:45 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLijBq025579;
        Wed, 12 Feb 2020 13:44:45 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 03/25] qla2xxx: Add sysfs node for D-Port Diagnostics AEN data
Date:   Wed, 12 Feb 2020 13:44:14 -0800
Message-ID: <20200212214436.25532-4-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This patch adds SysFS node to show D-Port diag data.

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 21 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_isr.c  |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 927115dc2526..de1930cd53fb 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2323,6 +2323,26 @@ qla2x00_port_no_show(struct device *dev, struct device_attribute *attr,
 	return scnprintf(buf, PAGE_SIZE, "%u\n", vha->hw->port_no);
 }
 
+static ssize_t
+qla2x00_dport_diagnostics_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+
+	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
+	    !IS_QLA28XX(vha->hw))
+		return scnprintf(buf, PAGE_SIZE, "\n");
+
+	if (!*vha->dport_data)
+		return scnprintf(buf, PAGE_SIZE, "\n");
+
+	return scnprintf(buf, PAGE_SIZE, "%04x %04x %04x %04x\n",
+	    vha->dport_data[0], vha->dport_data[1],
+	    vha->dport_data[2], vha->dport_data[3]);
+}
+static DEVICE_ATTR(dport_diagnostics, 0444,
+	   qla2x00_dport_diagnostics_show, NULL);
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_driver_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -2431,6 +2451,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_port_speed,
 	&dev_attr_port_no,
 	&dev_attr_fw_attr,
+	&dev_attr_dport_diagnostics,
 	NULL, /* reserve for qlini_mode */
 	NULL, /* reserve for ql2xiniexchg */
 	NULL, /* reserve for ql2xexchoffld */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b59643883ad1..22f859bef778 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4541,6 +4541,7 @@ typedef struct scsi_qla_host {
 	uint8_t n2n_node_name[WWN_SIZE];
 	uint8_t n2n_port_name[WWN_SIZE];
 	uint16_t	n2n_id;
+	__le16 dport_data[4];
 	struct list_head gpnid_list;
 	struct fab_scan scan;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e40705d38cea..73b6cfd14581 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1254,6 +1254,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		ql_dbg(ql_dbg_async, vha, 0x5052,
 		    "D-Port Diagnostics: %04x %04x %04x %04x\n",
 		    mb[0], mb[1], mb[2], mb[3]);
+		memcpy(vha->dport_data, mb, sizeof(vha->dport_data));
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
 			static char *results[] = {
 			    "start", "done(pass)", "done(error)", "undefined" };
-- 
2.12.0

