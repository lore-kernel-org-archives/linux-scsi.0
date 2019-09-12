Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF29AC4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0C7220856
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FjLu8Ls2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733037AbfILPU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:20:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20970 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732699AbfILPU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 11:20:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CFHIUZ011820;
        Thu, 12 Sep 2019 08:20:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=AWvSBSs+jyoGEpwcnERrRaJZv4NNeDB1/NbsHvNabYk=;
 b=FjLu8Ls2RRwitL8Tr43qu399XBUN3FVHrTsex5sIYCrhFfnHSY7farzQb+lXQWEsbBwB
 jPY2BPQ6TEk9Ute4kYZ4bUfLycBRvIB2m3SarLJhlctq8akH3PZYvp3Xxaif+0MvK7/6
 xdB7UcqS3U5TLMv+LQNQej+g5nHbiiJQX3ImqOs76+fPn1caGjwetQhFi7RvbRIIhpMF
 ZF4d/T3h7vZuU+CtRllIqECuQPzQK485i4/y+TcRXcAtjR7Y0KguVuPi0yPX154Yh09B
 L5Ahf7DZhnG03MWzMEwHNTQO/zEcbTf/czHEXtavUBzDAwZfYMDBNyAB2E9cs1hUgZtd Yw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uvc2jy5qx-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 08:20:24 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 08:20:23 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 08:20:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 37BED3F7040;
        Thu, 12 Sep 2019 08:20:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CFKNMh002654;
        Thu, 12 Sep 2019 08:20:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CFKNLr002653;
        Thu, 12 Sep 2019 08:20:23 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 11/14] qla2xxx: Check for MB timeout while capturing ISP27/28xx FW dump
Date:   Thu, 12 Sep 2019 08:19:46 -0700
Message-ID: <20190912151949.2348-12-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912151949.2348-1-hmadhani@marvell.com>
References: <20190912151949.2348-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_08:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Add mailbox timeout checkout for ISP 27xx/28xx during FW dump
procedure. Without the timeout check, hardware lock can
be held for long period. This patch would shorten the dump
procedure, if a timeout condition is encountered.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index de696a07532e..ad84a64dcb2a 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -10,6 +10,7 @@
 #define ISPREG(vha)	(&(vha)->hw->iobase->isp24)
 #define IOBAR(reg)	offsetof(typeof(*(reg)), iobase_addr)
 #define IOBASE(vha)	IOBAR(ISPREG(vha))
+#define INVALID_ENTRY ((struct qla27xx_fwdt_entry *)0xffffffffffffffffUL)
 
 static inline void
 qla27xx_insert16(uint16_t value, void *buf, ulong *len)
@@ -261,6 +262,7 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 	ulong start = le32_to_cpu(ent->t262.start_addr);
 	ulong end = le32_to_cpu(ent->t262.end_addr);
 	ulong dwords;
+	int rc;
 
 	ql_dbg(ql_dbg_misc, vha, 0xd206,
 	    "%s: rdram(%x) [%lx]\n", __func__, ent->t262.ram_area, *len);
@@ -308,7 +310,13 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 	dwords = end - start + 1;
 	if (buf) {
 		buf += *len;
-		qla24xx_dump_ram(vha->hw, start, buf, dwords, &buf);
+		rc = qla24xx_dump_ram(vha->hw, start, buf, dwords, &buf);
+		if (rc != QLA_SUCCESS) {
+			ql_dbg(ql_dbg_async, vha, 0xffff,
+			    "%s: dump ram MB failed. Area %xh start %lxh end %lxh\n",
+			    __func__, area, start, end);
+			return INVALID_ENTRY;
+		}
 	}
 	*len += dwords * sizeof(uint32_t);
 done:
@@ -838,6 +846,13 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 		ent = qla27xx_find_entry(type)(vha, ent, buf, len);
 		if (!ent)
 			break;
+
+		if (ent == INVALID_ENTRY) {
+			*len = 0;
+			ql_dbg(ql_dbg_async, vha, 0xffff,
+			    "Unable to capture FW dump");
+			goto bailout;
+		}
 	}
 
 	if (tmp->count)
@@ -847,6 +862,9 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 	if (ent)
 		ql_dbg(ql_dbg_misc, vha, 0xd019,
 		    "%s: missing end entry\n", __func__);
+
+bailout:
+	cpu_to_le32s(&tmp->count);	/* endianize residual count */
 }
 
 static void
@@ -1009,7 +1027,9 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 			}
 			len = qla27xx_execute_fwdt_template(vha,
 			    fwdt->template, buf);
-			if (len != fwdt->dump_size) {
+			if (len == 0) {
+				goto bailout;
+			} else if (len != fwdt->dump_size) {
 				ql_log(ql_log_warn, vha, 0xd013,
 				    "-> fwdt%u fwdump residual=%+ld\n",
 				    j, fwdt->dump_size - len);
@@ -1024,6 +1044,7 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 	}
 
+bailout:
 #ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
-- 
2.12.0

