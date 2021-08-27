Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E5CC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 09:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B8BA60F6C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 09:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244841AbhH0J1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 05:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244843AbhH0J1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 05:27:48 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B5DC0617AD;
        Fri, 27 Aug 2021 02:26:59 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y23so5485448pgi.7;
        Fri, 27 Aug 2021 02:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGqMC/gT0Hu/hyGaRVtj0bRZrD0WSdlmK/0myQjMrVw=;
        b=bbfFgaeFXP8CnMwrwIlRc+v6P9XQFFAfuIxGrlS3mbXywbKyTWVLEWy/WhTesK0rjN
         CTzGfctK1w9zICY4KQR3JZzFe9hJYZsSgj2wH03TEe0imYrFhUDjI6JLhUjkhREvLalq
         WtaT0isJ6Hi5RA41tLQZjg57YHWDzR0or+pmde052xRm5Zvii20LvSJ9A2pFAUGFqh2A
         2I+SWHOpapqpNax8W7fM3+KGB7vpcS2GS3AERBTtVxXPxwQDy/SaBYkyKzNwrT6c4tb1
         8be0OZkddaqdcmsJsIlvPgEuj5pfL5lmfFB+ICa/Sn+pcX2SR1gWh1ODevGQCa/b9Jkk
         1T7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGqMC/gT0Hu/hyGaRVtj0bRZrD0WSdlmK/0myQjMrVw=;
        b=OyV7jE6EvdmV69bqw9rVoXzfirSe/6VLqKs6E5fqSS+two/Q5P8fgxFse4cACAjixw
         B5714pDUroep15lscfpR2Bt18bigdedFneQUpie1VSwaAWvHZsKDVqHpW5Lg9Mb6SZ9s
         8uEDFJz0+050LlAkBMqmN8DohkmnDX1xHHH1qOsA92i0yY/HsTIozWGPM5eNx8vdzCqW
         AP8SRj8/Ek1s5OiQZOsabU7PwwIrrdRqIYUWzoBuj89lF7iH2qgZaT/uvsTKhotsTwc4
         T/5TzcsejZUgDaylfV60OscxCT5aPlJ0oJItiz+dG4FB1megmJJQg7hmCPZ1ie5a5uU0
         5MuQ==
X-Gm-Message-State: AOAM532bWA1nw26cUUlKxYhyrLszxU6iUAIw2qtyAz8TTQz2yZn0e0HT
        JeXnH8fAQ9EzW1kJDb56by0=
X-Google-Smtp-Source: ABdhPJwkFsfttccKndYmNFtwNy9IXjuRJF6E7r/rvEl1ejhQlpCz3No/4VPgPP8ifgWYfnSlTj67/Q==
X-Received: by 2002:a62:8287:0:b0:3ec:f6dc:9672 with SMTP id w129-20020a628287000000b003ecf6dc9672mr8003817pfd.65.1630056418532;
        Fri, 27 Aug 2021 02:26:58 -0700 (PDT)
Received: from tq-G3-3579.tsinghua.edu.cn ([183.173.48.61])
        by smtp.gmail.com with ESMTPSA id r3sm5398359pff.119.2021.08.27.02.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 02:26:57 -0700 (PDT)
From:   starmiku1207184332@gmail.com
To:     njavali@marvell.com, mrangankar@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Teng Qi <starmiku120718432@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] scsi: qla4xxx: Fix a buffer overflow in qla4xxx_free_ddb()
Date:   Fri, 27 Aug 2021 17:26:43 +0800
Message-Id: <20210827092643.273357-1-starmiku1207184332@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Teng Qi <starmiku120718432@gmail.com>

Function qla4xxx_session_destroy(), function qla4xxx_get_fwddb_entry() and 
function qla4xxx_free_ddb() are corresponding this buffer overflow.
Function qla4xxx_session_destroy() firstly calls function 
qla4xxx_get_fwddb_entry(), and secondly calls function qla4xxx_free_ddb().

In functon qla4xxx_session_destroy(), the function qla4xxx_get_fwddb_entry() is
called with ddb_entry->fw_ddb_index being passed to formal parameter 
fw_ddb_index.
ret = qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index,
	      fw_ddb_entry, fw_ddb_entry_dma,
	      NULL, NULL, &ddb_state, NULL,
	      NULL, NULL);

In qla4xxx_get_fwddb_entry(), fw_ddb_index is checked in:
  if (fw_ddb_index >= MAX_DDB_ENTRIES)

This indicates fw_ddb_index could be greater than or equal to MAX_DDB_ENTRIES, 
and ddb_entry->fw_ddb_index could be also greater than or equal to
MAX_DDB_ENTRIES.
If so, the qla4xxx_get_fwddb_entry() will return QLA_ERROR.
After return, the program goes to the label destory_seession.
Then the function qla4xxx_free_ddb() is called with argument ddb_entry.
In qla4xxx_free_ddb(), ddb_entry->fw_ddb_index is used as index.
  ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] =
		(struct ddb_entry *) INVALID_ENTRY;

However, the size of ha->fw_ddb_index_map is MAX_DDB_ENTRIES, which can cause
a buffer overflow.

To fix this possible buffer overflow, ddb_entry->fw_ddb_index should be
checked first.
If ddb_entry->fw_ddb_index is greater than or equal to MAX_DDB_ENTRIES, the
function qla4xxx_free_ddb() returns.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku120718432@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index f786ac2f5548..e5b2161e59ed 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -47,6 +47,8 @@ static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
 void qla4xxx_free_ddb(struct scsi_qla_host *ha,
     struct ddb_entry *ddb_entry)
 {
+	if (ddb_entry->fw_ddb_index >= MAX_DDB_ENTRIES)
+		return;
 	/* Remove device pointer from index mapping arrays */
 	ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] =
 		(struct ddb_entry *) INVALID_ENTRY;
-- 
2.25.1

