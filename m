Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1082AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 09:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiBXJIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 04:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbiBXJIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 04:08:14 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B62113AEA;
        Thu, 24 Feb 2022 01:07:44 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id ba20so2565444qvb.1;
        Thu, 24 Feb 2022 01:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dBBa+m5WJxw/OTFjHbJ6+LeZpWFvvqiydygw9xKnoS4=;
        b=Oc1r7lycBzB3aLDcGUGQxFXlvv19N4fMyOjhtgCRpBK/C7i6dmxBn41c7urKYHy/7Y
         wMImarxg2DfHr7BAQf/EBepVdRTaJjyUOjmueW+6FfgK1vDuYO0EDesmtqsdFHCTeLJ4
         bRkrB0Q1mOvAwCbi0VaLO8jV8O4YLiSwo+W+36lTzwn+o6ySkVR9jYwyDTvdl5dZLn88
         h7yiv5O1qfhMDT/fO4WT/PdXYiAm6lpwJmkXWDW/R3mq67P8iu+/PTrgh7A2IBsaBs3v
         Y93l+nYGYpLIkXID9oWSYxvstcXwUTSoljipiZu/W5GiaJ2c7tiX/hRfucnqcvr3+xtn
         obuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dBBa+m5WJxw/OTFjHbJ6+LeZpWFvvqiydygw9xKnoS4=;
        b=G2yxsDiGHmroVAfTubKgW+VhgH4AQ0pAHRoCvT13Ovlce5/mLQQTfNEr2fuKnKvLTL
         OwwLG1S+LVHSBnGnSPygUheA1DKNWYZAn7m4lzOZrNicjjkIQmK2Fhmo48M0YFlY/cZ8
         hKJzKXsOHX2LL4W9M4jkOe/czRE0T4BuT5qUyUbInSNaNiZB5QJteWRhgevrf0Zz/rOM
         IjsUKzylgNY6l8YmWHfpjw0X6C5JvxC73gvPsCMrE30nN0N/Q9R6r3+TK/nOLXArCDWG
         VR/ACr06neDaMBssgjiaWFNSaqKJqBxT04rG9JamY9YprHSELJIQYTim0qD7MyXOsq73
         urWw==
X-Gm-Message-State: AOAM533rHKZ5ykrKRFcfvQL7BGhUiuTdsC2ketKKWnEqkvMhjn8ijH85
        dgebe24s7m7pU9rDtA73+Kk=
X-Google-Smtp-Source: ABdhPJx0rn7zCTJSTevgT6ltmxUujV0ZykC+hrr/6rizOnVOLzaVlBpjaiaz5XmZbJRqt7I7bndUPA==
X-Received: by 2002:ac8:7d90:0:b0:2de:7561:b2fc with SMTP id c16-20020ac87d90000000b002de7561b2fcmr1398833qtd.435.1645693663781;
        Thu, 24 Feb 2022 01:07:43 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id bk19sm1053110qkb.125.2022.02.24.01.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 01:07:43 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     njavali@marvell.com
Cc:     mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: qla4xxx: Remove unneeded variable
Date:   Thu, 24 Feb 2022 09:07:35 +0000
Message-Id: <20220224090735.1967816-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Remove unneeded variable used to store return value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/scsi/qla4xxx/ql4_os.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d64eda961412..b49c38416fb9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3640,7 +3640,6 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 				       struct dev_db_entry *fw_ddb_entry)
 {
 	uint16_t options;
-	int rc = 0;
 
 	options = le16_to_cpu(fw_ddb_entry->options);
 	SET_BITVAL(conn->is_fw_assigned_ipv6,  options, BIT_11);
@@ -3739,7 +3738,7 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 
 	COPY_ISID(fw_ddb_entry->isid, sess->isid);
 
-	return rc;
+	return 0;
 }
 
 static void qla4xxx_copy_to_sess_conn_params(struct iscsi_conn *conn,
-- 
2.25.1

