Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92526C33CB2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 16:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EDE7222C4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 16:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbgANQJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 11:09:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:49338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728826AbgANQJ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 11:09:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB1B3AE54;
        Tue, 14 Jan 2020 16:09:55 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla1280: Fix dma firmware download, if dma address is 64bit
Date:   Tue, 14 Jan 2020 17:09:36 +0100
Message-Id: <20200114160936.1517-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do firmware download with 64bit LOAD_RAM command, if driver is using
64bit addressing.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/scsi/qla1280.c | 20 ++++++++++++++------
 drivers/scsi/qla1280.h |  2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 832af4213046..607cbddcdd14 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1699,6 +1699,16 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 	return err;
 }
 
+#if QLA_64BIT_PTR
+#define LOAD_CMD	MBC_LOAD_RAM_A64_ROM
+#define DUMP_CMD	MBC_DUMP_RAM_A64_ROM
+#define CMD_ARGS	(BIT_7 | BIT_6 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0)
+#else
+#define LOAD_CMD	MBC_LOAD_RAM
+#define DUMP_CMD	MBC_DUMP_RAM
+#define CMD_ARGS	(BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0)
+#endif
+
 #define DUMP_IT_BACK 0		/* for debug of RISC loading */
 static int
 qla1280_load_firmware_dma(struct scsi_qla_host *ha)
@@ -1748,7 +1758,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		for(i = 0; i < cnt; i++)
 			((__le16 *)ha->request_ring)[i] = fw_data[i];
 
-		mb[0] = MBC_LOAD_RAM;
+		mb[0] = LOAD_CMD;
 		mb[1] = risc_address;
 		mb[4] = cnt;
 		mb[3] = ha->request_dma & 0xffff;
@@ -1759,8 +1769,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 				__func__, mb[0],
 				(void *)(long)ha->request_dma,
 				mb[6], mb[7], mb[2], mb[3]);
-		err = qla1280_mailbox_command(ha, BIT_4 | BIT_3 | BIT_2 |
-				BIT_1 | BIT_0, mb);
+		err = qla1280_mailbox_command(ha, CMD_ARGS, mb);
 		if (err) {
 			printk(KERN_ERR "scsi(%li): Failed to load partial "
 			       "segment of f\n", ha->host_no);
@@ -1768,7 +1777,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		}
 
 #if DUMP_IT_BACK
-		mb[0] = MBC_DUMP_RAM;
+		mb[0] = DUMP_CMD;
 		mb[1] = risc_address;
 		mb[4] = cnt;
 		mb[3] = p_tbuf & 0xffff;
@@ -1776,8 +1785,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		mb[7] = upper_32_bits(p_tbuf) & 0xffff;
 		mb[6] = upper_32_bits(p_tbuf) >> 16;
 
-		err = qla1280_mailbox_command(ha, BIT_4 | BIT_3 | BIT_2 |
-				BIT_1 | BIT_0, mb);
+		err = qla1280_mailbox_command(ha, CMD_ARGS, mb);
 		if (err) {
 			printk(KERN_ERR
 			       "Failed to dump partial segment of f/w\n");
diff --git a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
index a1a8aefc7cc3..e7820b5bca38 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -277,6 +277,8 @@ struct device_reg {
 #define MBC_MAILBOX_REGISTER_TEST	6	/* Wrap incoming mailboxes */
 #define MBC_VERIFY_CHECKSUM		7	/* Verify checksum */
 #define MBC_ABOUT_FIRMWARE		8	/* Get firmware revision */
+#define MBC_LOAD_RAM_A64_ROM		9	/* Load RAM 64bit ROM version */
+#define MBC_DUMP_RAM_A64_ROM		0x0a	/* Dump RAM 64bit ROM version */
 #define MBC_INIT_REQUEST_QUEUE		0x10	/* Initialize request queue */
 #define MBC_INIT_RESPONSE_QUEUE		0x11	/* Initialize response queue */
 #define MBC_EXECUTE_IOCB		0x12	/* Execute IOCB command */
-- 
2.24.1

