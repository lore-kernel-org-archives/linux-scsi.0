Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFB2C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 15:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbiGRP0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiGRP0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 11:26:12 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B0F286DE;
        Mon, 18 Jul 2022 08:26:11 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E072D4127C;
        Mon, 18 Jul 2022 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658157968; x=1659972369; bh=tR9l9Zvsy0SyfKsabEX1E0Xht
        LVDse0uSp0nlq+RSP4=; b=a6WypALA3WcRfCcEa4g1xtsKHrFqCj02+XHoNqqZH
        atVSFaIOZHEKcfHWFgKaOqv3ufE/C2AaRdQOXu0bMYy0TQrcrvvtqt68YUtbt3NK
        PUDICO5MJqdVkqXKvDZjs5pML480VwI4nfkDI+09ouPaZVFE64FqjsQFALXoIoF2
        ag=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XoHQqRIQoNVI; Mon, 18 Jul 2022 18:26:08 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8C47841239;
        Mon, 18 Jul 2022 18:26:08 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 18:26:08 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 18 Jul 2022 18:26:07 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 1/4] scsi: target: iscsi: add support extended CDB AHS
Date:   Mon, 18 Jul 2022 18:25:52 +0300
Message-ID: <20220718152555.17084-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718152555.17084-1-d.bogdanov@yadro.com>
References: <20220718152555.17084-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Variable length SCSI commands are transferred over iSCSI via two cdb
buffers - in Basic Header Segment and in Additional Header Segment(AHS).
Since AHS is not supported yet, a target reads just BHS (48 byte) from
TCP and treats the rest octets as a next new iSCSI PDU that causes
protocol errors.

This patch adds support of Extended CDB AHS type.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c | 55 +++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e368f038ff5c..a9600c52c3cc 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1004,8 +1004,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  unsigned char *buf)
 {
 	int data_direction, payload_length;
+	struct iscsi_ecdb_ahdr *ecdb_ahdr;
 	struct iscsi_scsi_req *hdr;
 	int iscsi_task_attr;
+	unsigned char *cdb;
 	int sam_task_attr;
 
 	atomic_long_inc(&conn->sess->cmd_pdus);
@@ -1106,6 +1108,27 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
+	cdb = hdr->cdb;
+
+	if (hdr->hlength) {
+		ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
+		if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
+			pr_err("Additional Header Segment type %d not supported!\n",
+			       ecdb_ahdr->ahstype);
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
+		}
+
+		cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
+			      GFP_KERNEL);
+		if (cdb == NULL)
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
+		memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
+		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
+		       be16_to_cpu(ecdb_ahdr->ahslength) - 1);
+	}
+
 	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
 			 (hdr->flags & ISCSI_FLAG_CMD_READ) ? DMA_FROM_DEVICE :
 			  DMA_NONE;
@@ -1153,9 +1176,12 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		struct iscsi_datain_req *dr;
 
 		dr = iscsit_allocate_datain_req();
-		if (!dr)
+		if (!dr) {
+			if (cdb != hdr->cdb)
+				kfree(cdb);
 			return iscsit_add_reject_cmd(cmd,
 					ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
+		}
 
 		iscsit_attach_datain_req(cmd, dr);
 	}
@@ -1176,9 +1202,12 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
-	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb,
+	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, cdb,
 						GFP_KERNEL);
 
+	if (cdb != hdr->cdb)
+		kfree(cdb);
+
 	if (cmd->sense_reason) {
 		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
 			return iscsit_add_reject_cmd(cmd,
@@ -4036,8 +4065,9 @@ static bool iscsi_target_check_conn_state(struct iscsit_conn *conn)
 static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 {
 	int ret;
-	u8 *buffer, opcode;
+	u8 *buffer, *tmp_buf, opcode;
 	u32 checksum = 0, digest = 0;
+	struct iscsi_hdr *hdr;
 	struct kvec iov;
 
 	buffer = kcalloc(ISCSI_HDR_LEN, sizeof(*buffer), GFP_KERNEL);
@@ -4062,6 +4092,25 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 			break;
 		}
 
+		hdr = (struct iscsi_hdr *) buffer;
+		if (hdr->hlength) {
+			iov.iov_len = hdr->hlength * 4;
+			tmp_buf = krealloc(buffer,
+					  ISCSI_HDR_LEN + iov.iov_len,
+					  GFP_KERNEL);
+			if (!tmp_buf)
+				break;
+
+			buffer = tmp_buf;
+			iov.iov_base = &buffer[ISCSI_HDR_LEN];
+
+			ret = rx_data(conn, &iov, 1, iov.iov_len);
+			if (ret != iov.iov_len) {
+				iscsit_rx_thread_wait_for_tcp(conn);
+				break;
+			}
+		}
+
 		if (conn->conn_ops->HeaderDigest) {
 			iov.iov_base	= &digest;
 			iov.iov_len	= ISCSI_CRC_LEN;
-- 
2.25.1

