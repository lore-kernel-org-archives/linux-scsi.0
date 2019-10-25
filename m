Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5264CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 18:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7393221D7B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 18:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sR3UVFTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfJYSn4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 14:43:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46339 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfJYSn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 14:43:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id n15so3438281wrw.13
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 11:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TAg41ZA0+Me5EM0LPx+WZLx/D5vJfgnJOEsn+VEIEYg=;
        b=sR3UVFTrlOsQXFZtcmpMfL5SOA3IOnBfbSFeCflUU1hEFQCy9DDckUDH6TKcwkpEfO
         PrqmiTOvk5kzbCJa4HVsS0tBqlMw0mO9oeR0iT4RsFgS4pr6lUZ+xDNHzgFUyOUjrADD
         uwzB3avVfdM23pwHnLi+SEw8tlXyTURnVI5CkGiPoUieQkWI5HZeCbDh+y1cEeD9/JSl
         utuz567vdYKyrcM/jlZTtT+eETenEA7EDmhifXUiD8ebfOlpuTmFn2xLkTfiuc7mL30b
         BguxAE5QnIxp0jLgmrxcTg8ruBXJXyE+Y65QsotpAzI4OMe1Rn6KMBtPMei4zlfVQlV1
         6sbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TAg41ZA0+Me5EM0LPx+WZLx/D5vJfgnJOEsn+VEIEYg=;
        b=p0B/wBuh750nJc0wKc1XMHqfYzEchxUezA993QRuqhNZVcuF31mJQ4yeL/7HhOJ/1a
         c7XtPcGEfBJ3ANX/wYs/73WgPJ1vbNF9Vf6VsFY9VQuSUK9K0DdxNoKtRrDmd4gTLZ2L
         /ErKgCvtCmZC7cGWI5j8ODhr5kQV5I0jFzz14E1PhT7W4FsnxJqoqBbmasdEBLhZKvM5
         uPb/vXTWukgV3D55OVyopyFrpVCm/R+isKHMcrTYAk+rSbeKQ1MGCmvIXi42xZXIoIo0
         Ksl4Stcz7rChqB/3wQWRJi8dgj/tSCdM54iJ6pa8jD4hY3u/ptPbx2XHy70/ZpyeOJah
         cZWA==
X-Gm-Message-State: APjAAAWSP4p5MaATGRIOZaQ+3PDWZHHPV9jbKBUOPSwfmFGBaREzlec7
        TPJBRLrhiSKJpm9Ln+bGaq7X+d0X
X-Google-Smtp-Source: APXvYqyM+06n6hNXNJl0VxA1CIv8hzx6qyae3ACJkjyELZJ03+S7IoA3+GPlAPSDW8B8C0HV38dCuQ==
X-Received: by 2002:a5d:4a82:: with SMTP id o2mr4284989wrq.186.1572029032341;
        Fri, 25 Oct 2019 11:43:52 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r1sm2906807wmh.41.2019.10.25.11.43.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 25 Oct 2019 11:43:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: fix spelling error in MAGIC_NUMER_xxx
Date:   Fri, 25 Oct 2019 11:43:42 -0700
Message-Id: <20191025184342.6623-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

convert MAGIC_NUMER_xxx to MAGIC_NUMBER_xxx

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  | 4 ++--
 drivers/scsi/lpfc/lpfc_init.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index d40bfe5aa21f..9daa2b494b5c 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4822,8 +4822,8 @@ union lpfc_wqe128 {
 	struct send_frame_wqe send_frame;
 };
 
-#define MAGIC_NUMER_G6 0xFEAA0003
-#define MAGIC_NUMER_G7 0xFEAA0005
+#define MAGIC_NUMBER_G6 0xFEAA0003
+#define MAGIC_NUMBER_G7 0xFEAA0005
 
 struct lpfc_grp_hdr {
 	uint32_t size;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 686677dd52a4..9536ad3cc4ee 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12418,9 +12418,9 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
 	 */
 	if (offset == ADD_STATUS_FW_NOT_SUPPORTED ||
 	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
-	     magic_number != MAGIC_NUMER_G6) ||
+	     magic_number != MAGIC_NUMBER_G6) ||
 	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC &&
-	     magic_number != MAGIC_NUMER_G7)) {
+	     magic_number != MAGIC_NUMBER_G7)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3030 This firmware version is not supported on"
 				" this HBA model. Device:%x Magic:%x Type:%x "
-- 
2.13.7

