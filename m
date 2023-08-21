Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19E3EE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 13:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbjHUNBH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbjHUNBG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 09:01:06 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D11EE9
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:02 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37KMwWM4022515
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=/CQowSLayOKoJldWC2X55wbsYF25KmJxIOipOm2pHz8=;
 b=k8KC/0dL4srP0i8Xg9rA2LJNDmRZVHfs25E68wS9vhV5sbWw/NOP9X+Nwt8SGmCbxYZy
 ZMXQZbs2+58wj2XPN3VI/0Tvp+dpAZ+mSK5HRr57guukw5DXuawQnCLdnOv9SP9nbYCG
 IjIZfarycWgJAUpdZ8wEZPrBxqkE0TGhd0el2j/UoVaaDBb1mJog93zmZzStrkqKkJwL
 DOb3R+qhtZtyA/COk8GKKj+kT+3mZ+IthFubnt+1TVt3fvlue6W5GE19wKW41k5kiM+Q
 65OMqBHgvStkmFolfsXdZlNPwhMT+bNEzvx1eQyZ0rQrS07AqL8sTh1NZpxP8XU3MsZp zw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3sjw8jcs4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 21 Aug
 2023 06:00:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 21 Aug 2023 06:00:59 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 2E2873F7097;
        Mon, 21 Aug 2023 06:00:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v3 4/9] qla2xxx: Add logs for SFP temperature monitoring
Date:   Mon, 21 Aug 2023 18:30:40 +0530
Message-ID: <20230821130045.34850-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230821130045.34850-1-njavali@marvell.com>
References: <20230821130045.34850-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PsIQO81MDcIRoNEw8fZOKUZ8sqTCI_Ar
X-Proofpoint-GUID: PsIQO81MDcIRoNEw8fZOKUZ8sqTCI_Ar
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_01,2023-08-18_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Add logs for SFP Temperature Alert async event to
check if laser is enabled/disabled.

Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 867025c89909..e98788191897 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -56,6 +56,22 @@ const char *const port_state_str[] = {
 	[FCS_ONLINE]		= "ONLINE"
 };
 
+#define SFP_DISABLE_LASER_INITIATED    0x15  /* Sub code of 8070 AEN */
+#define SFP_ENABLE_LASER_INITIATED     0x16  /* Sub code of 8070 AEN */
+
+static inline void display_Laser_info(scsi_qla_host_t *vha,
+				      u16 mb1, u16 mb2, u16 mb3) {
+
+	if (mb1 == SFP_DISABLE_LASER_INITIATED)
+		ql_log(ql_log_warn, vha, 0xf0a2,
+		       "SFP temperature (%d C) reached/exceeded the threshold (%d C). Laser is disabled.\n",
+		       mb3, mb2);
+	if (mb1 == SFP_ENABLE_LASER_INITIATED)
+		ql_log(ql_log_warn, vha, 0xf0a3,
+		       "SFP temperature (%d C) reached normal operating level. Laser is enabled.\n",
+		       mb3);
+}
+
 static void
 qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 {
@@ -1927,6 +1943,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_TEMPERATURE_ALERT:
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+			display_Laser_info(vha, mb[1], mb[2], mb[3]);
 		ql_dbg(ql_dbg_async, vha, 0x505e,
 		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
 		break;
-- 
2.23.1

