Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486D5C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3253661154
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352349AbhIHQsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:48:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46504 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352343AbhIHQsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889r43v000993;
        Wed, 8 Sep 2021 09:47:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=BA16KHXgPwzpkpmaZfSeiRh0NW4xfBrI0QrV++lBcuY=;
 b=OXpYbWksA8mh7YVWx5ydDMdyQA8r/CJHu+QeyDGXTywG47mMxv1luMIGVTbrXnAUr2MF
 Dm1YpSkBHedQMxCrr6AxjWF/6txSTwASuqGA3JofIIhaR1W5VgMtaH4N53HGRjgy725Y
 6QFIp+T1wYWuzr5jGjALz778m/MSTRgozdDO5+4GZqBiBhx/U4LzVtO6FZCHm3LH+kmR
 u4SDaX0cUXp6Rcv7cxFi4XA7COt604jmUPDQ8kjlnMDYVts2/3VPkMoPLBl8cgcwnnrw
 xXaYk1hi0N/WP8hwpTXW4d4gwPkCwCLtqrvcv18y9RrsegIfmqiBM4pyt8MSyeDPcED1 PA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axtxc1kh3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:38 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 83F1D3F70A4;
        Wed,  8 Sep 2021 09:47:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188GlcIB019307;
        Wed, 8 Sep 2021 09:47:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188GlcOU019306;
        Wed, 8 Sep 2021 09:47:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 06/10] qla2xxx: Fix kernel crash when accessing port_speed sysfs file
Date:   Wed, 8 Sep 2021 09:46:18 -0700
Message-ID: <20210908164622.19240-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SJqcvkMg8sc302WYIeDTu3H8zhwRKJiF
X-Proofpoint-GUID: SJqcvkMg8sc302WYIeDTu3H8zhwRKJiF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Kernel crashes when accessing port_speed sysfs file.
The issue happens on a CNA when the local array was
accessed beyond bounds. Fix this by changing the lookup.

BUG: unable to handle kernel paging request at 0000000000004000
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 15 PID: 455213 Comm: sosreport Kdump: loaded Not tainted
4.18.0-305.7.1.el8_4.x86_64 #1
RIP: 0010:string_nocheck+0x12/0x70
Code: 00 00 4c 89 e2 be 20 00 00 00 48 89 ef e8 86 9a 00 00 4c 01
e3 eb 81 90 49 89 f2 48 89 ce 48 89 f8 48 c1 fe 30 66 85 f6 74 4f <44> 0f b6 0a
45 84 c9 74 46 83 ee 01 41 b8 01 00 00 00 48 8d 7c 37
RSP: 0018:ffffb5141c1afcf0 EFLAGS: 00010286
RAX: ffff8bf4009f8000 RBX: ffff8bf4009f9000 RCX: ffff0a00ffffff04
RDX: 0000000000004000 RSI: ffffffffffffffff RDI: ffff8bf4009f8000
RBP: 0000000000004000 R08: 0000000000000001 R09: ffffb5141c1afb84
R10: ffff8bf4009f9000 R11: ffffb5141c1afce6 R12: ffff0a00ffffff04
R13: ffffffffc08e21aa R14: 0000000000001000 R15: ffffffffc08e21aa
FS:  00007fc4ebfff700(0000) GS:ffff8c717f7c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000004000 CR3: 000000edfdee6006 CR4: 00000000001706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  string+0x40/0x50
  vsnprintf+0x33c/0x520
  scnprintf+0x4d/0x90
  qla2x00_port_speed_show+0xb5/0x100 [qla2xxx]
  dev_attr_show+0x1c/0x40
  sysfs_kf_seq_show+0x9b/0x100
  seq_read+0x153/0x410
  vfs_read+0x91/0x140
  ksys_read+0x4f/0xb0
  do_syscall_64+0x5b/0x1a0
  entry_SYSCALL_64_after_hwframe+0x65/0xca

Fixes: 4910b524ac9e6 ("scsi: qla2xxx: Add support for setting port speed”)
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d09776b77af2..cb5f2ecb652d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1868,6 +1868,18 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 	return strlen(buf);
 }
 
+static const struct {
+	u16 rate;
+	char *str;
+} port_speed_str[] = {
+	{ PORT_SPEED_4GB, "4" },
+	{ PORT_SPEED_8GB, "8" },
+	{ PORT_SPEED_16GB, "16" },
+	{ PORT_SPEED_32GB, "32" },
+	{ PORT_SPEED_64GB, "64" },
+	{ PORT_SPEED_10GB, "10" },
+};
+
 static ssize_t
 qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
     char *buf)
@@ -1875,7 +1887,8 @@ qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 	ssize_t rval;
-	char *spd[7] = {"0", "0", "0", "4", "8", "16", "32"};
+	u16 i;
+	char *speed = "Unknown";
 
 	rval = qla2x00_get_data_rate(vha);
 	if (rval != QLA_SUCCESS) {
@@ -1884,7 +1897,14 @@ qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
+	for (i = 0; i < ARRAY_SIZE(port_speed_str); i++) {
+		if (port_speed_str[i].rate != ha->link_data_rate)
+			continue;
+		speed = port_speed_str[i].str;
+		break;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", speed);
 }
 
 static ssize_t
-- 
2.19.0.rc0

