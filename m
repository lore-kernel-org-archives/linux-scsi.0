Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B9FC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A89216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405213AbfHIDDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34050 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so38879729pgc.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sohRIQjGaZHbOtGZAaiozi+XgIyF1jUoOzhe+m1XviI=;
        b=koxKSur1pMVFs4Oh1DIkTFzgKBYK2ZgYUUlwyZ/rfKcMn7JmHSYF+QmgcOh+9J/r/t
         aUiD1H6suz6xqZXRv6G+DqRX0XJ1PGxo1jiSidBcz1s57l7b4GuuIAlp5LKBuOxftPlL
         ozg1UbwhJgQr4xYHvChQlDmEq8AxJBQf03DAT+KXfaoCobojUHh/TZ4FmxsynJlrPKRZ
         diFpEYOKDyixWRbsO2OnrmPNmwHLtnEV42OO+UeBxeNnF9B5g1PMgaU7SzPHsiki0fgC
         2pfrwPghD2VECR4JBYBizMeZqfoQ46vC5pARvgLjcel/C9JMtzGZtysp51s0CTKeJns+
         +Zxg==
X-Gm-Message-State: APjAAAXCI0iJqfclKFEss95Gk/OQHwE+BDvhhccEmeF3N9XdUvfdOuGz
        vxLzXej+Mqaw/iMB0rYtmQJjX/5Q
X-Google-Smtp-Source: APXvYqy2ejklAwgh5hF6hev5Vf5bw4r/c5YYrEWKaxJD1ZzU2mpZsDQMl3gJwc2vHZ0XyPaa53vRKQ==
X-Received: by 2002:a63:c84d:: with SMTP id l13mr15520763pgi.154.1565319803457;
        Thu, 08 Aug 2019 20:03:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 35/58] qla2xxx: Use memcpy() and strlcpy() instead of strcpy() and strncpy()
Date:   Thu,  8 Aug 2019 20:01:56 -0700
Message-Id: <20190809030219.11296-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes the string manipulation code easier to verify.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++--------
 drivers/scsi/qla2xxx/qla_mr.c   |  6 ++++--
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2d9a379fd8fb..5258d2486e25 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4438,7 +4438,7 @@ qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 	if (len > sizeof(zero))
 		len = sizeof(zero);
 	if (memcmp(model, &zero, len) != 0) {
-		strncpy(ha->model_number, model, len);
+		memcpy(ha->model_number, model, len);
 		st = en = ha->model_number;
 		en += len - 1;
 		while (en > st) {
@@ -4451,21 +4451,23 @@ qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 		if (use_tbl &&
 		    ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES)
-			strncpy(ha->model_desc,
+			strlcpy(ha->model_desc,
 			    qla2x00_model_name[index * 2 + 1],
-			    sizeof(ha->model_desc) - 1);
+			    sizeof(ha->model_desc));
 	} else {
 		index = (ha->pdev->subsystem_device & 0xff);
 		if (use_tbl &&
 		    ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES) {
-			strcpy(ha->model_number,
-			    qla2x00_model_name[index * 2]);
-			strncpy(ha->model_desc,
+			strlcpy(ha->model_number,
+				qla2x00_model_name[index * 2],
+				sizeof(ha->model_number));
+			strlcpy(ha->model_desc,
 			    qla2x00_model_name[index * 2 + 1],
-			    sizeof(ha->model_desc) - 1);
+			    sizeof(ha->model_desc));
 		} else {
-			strcpy(ha->model_number, def);
+			strlcpy(ha->model_number, def,
+				sizeof(ha->model_number));
 		}
 	}
 	if (IS_FWI2_CAPABLE(ha))
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 759fcfecc310..78b3679e1b9c 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1939,8 +1939,10 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	if (fx_type == FXDISC_GET_CONFIG_INFO) {
 		struct config_info_data *pinfo =
 		    (struct config_info_data *) fdisc->u.fxiocb.rsp_addr;
-		strcpy(vha->hw->model_number, pinfo->model_num);
-		strcpy(vha->hw->model_desc, pinfo->model_description);
+		strlcpy(vha->hw->model_number, pinfo->model_num,
+			ARRAY_SIZE(vha->hw->model_number));
+		strlcpy(vha->hw->model_desc, pinfo->model_description,
+			ARRAY_SIZE(vha->hw->model_desc));
 		memcpy(&vha->hw->mr.symbolic_name, pinfo->symbolic_name,
 		    sizeof(vha->hw->mr.symbolic_name));
 		memcpy(&vha->hw->mr.serial_num, pinfo->serial_num,
-- 
2.22.0

