Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F46C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbiCBFhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiCBFhN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10822B16D5
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222m9p1014692
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=nMmBzpYhUHTdlPVXepcIyqO48i+jKceUhZejNfuElOs=;
 b=C3wNdcrdE338iPTniS9aUCgXr/6Sul8+sXigFdPMg23vwSI0PC32K2WNUw8EhCDhJZpH
 fXngYM6Z/damNSJ8nY01z0NIOZH5hoPTTJjmAL/oA+X8uuj+4GZrwZh1Gl+5vbNs6I8g
 Lm6q4+a2N+5eYDwDJR8UyA435y9EmjjM4PiTYbopSt6MYv78K1oPIDzQWOGLIs4wfIWu
 tlxMkqT35x3NX3L2zf6uSytmG8ZdPfwqMNfNDyQpUZ81Gh1nzNVvHpN4/z5Vl5jBeOeu
 18lJVnapOSXhJaI2nmTFEFM63CQCsZPsoysl9OxPjnTFhLaLwHcZiw5RY18Gm+jEVnDT ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amq8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IpLO175843
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vah8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:29 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZb014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-5;
        Wed, 02 Mar 2022 05:36:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/14] scsi: core: Pick suitable allocation length in scsi_report_opcode()
Date:   Wed,  2 Mar 2022 00:35:49 -0500
Message-Id: <20220302053559.32147-5-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mewB3eW7IELqvE2jKHUFx05AN2Lvu2KN
X-Proofpoint-GUID: mewB3eW7IELqvE2jKHUFx05AN2Lvu2KN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some devices hang when a buffer size larger than expected is passed in
the ALLOCATION LENGTH field. For REPORT SUPPORTED OPERATION CODES we
currently only request a single command descriptor at a time and
therefore the actual size of the command is known ahead of time. Limit
the ALLOCATION LENGTH to the header size plus the command length of
the opcode we are asking about.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index af896d0647a7..c6221a2ca04e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -508,21 +508,30 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
-	int result;
+	int result, request_len;
 
 	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
 		return -EINVAL;
 
+	/* RSOC header + size of command we are asking about */
+	request_len = 4 + COMMAND_SIZE(opcode);
+	if (request_len > len) {
+		dev_warn_once(&sdev->sdev_gendev,
+			      "%s: len %u bytes, opcode 0x%02x needs %u\n",
+			      __func__, len, opcode, request_len);
+		return -EINVAL;
+	}
+
 	memset(cmd, 0, 16);
 	cmd[0] = MAINTENANCE_IN;
 	cmd[1] = MI_REPORT_SUPPORTED_OPERATION_CODES;
 	cmd[2] = 1;		/* One command format */
 	cmd[3] = opcode;
-	put_unaligned_be32(len, &cmd[6]);
+	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  &sshdr, 30 * HZ, 3, NULL);
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
+				  request_len, &sshdr, 30 * HZ, 3, NULL);
 
 	if (result < 0)
 		return result;
-- 
2.32.0

