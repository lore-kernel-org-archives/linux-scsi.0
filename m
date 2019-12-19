Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFBDC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A2D21D7D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfLSAtM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:49:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43786 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSAtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 19:49:12 -0500
Received: by mail-pg1-f195.google.com with SMTP id k197so2167643pga.10
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 16:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2LpIrygf1W1+CgcfyxcxDZpe539lsLVbxUb7BcWapY0=;
        b=ZUc+Y7YgILmUeSbgKE5z4xexh+rzUstT7M/QKupP9+b6iGZxmZfCQgQu7AeFbTZiAU
         dlxRVKICZ08U2PE+wyY4eLHL87DLnZqE5T9mJJSUXFjb8jA1qy/6ST9cbJIUr1pXMHRv
         mWEuB5krOmtxEwND46YLeMTUNGspwjS+NLhTcMrbaBzQ17GpyXBzHXZ3GsPVVDQcqboO
         lRrHS36I7fsreF/8gZ6CQT93iSmYZg4yXF8Zz+jR7+o98KtWFz4ejlQeEpNs3y25mkUl
         CJqk83iQF8xhRcxftX6eS/s62j4MGht1hCM216RhH6Y5OBRoItLvCjUQsbARhWXnBSzR
         N4ng==
X-Gm-Message-State: APjAAAX7H7HjRLopVk4azlvY6bFQMVniiRHBZuUiZVId5Oovqa2B49q+
        EnOM2wttNLvmo2I5HOmmO90c/B/W
X-Google-Smtp-Source: APXvYqz+bbJ4QVlpNkQtVg7FoIn8e2sOApUj+Zjj3nlfsE1agzaNmdAmn9i3qDMyZt/XkOX7dhLyIA==
X-Received: by 2002:a63:28a:: with SMTP id 132mr6026761pgc.165.1576716551531;
        Wed, 18 Dec 2019 16:49:11 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id r7sm5118256pfg.34.2019.12.18.16.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 16:49:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type
Date:   Wed, 18 Dec 2019 16:49:05 -0800
Message-Id: <20191219004905.39586-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since qla82xx_get_fw_size() returns a number in CPU-endian format, change
its return type from __le32 into u32. This patch does not change any
functionality.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Fixes: 9c2b297572bf ("[SCSI] qla2xxx: Support for loading Unified ROM Image (URI) format firmware file.")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 2b2028f2383e..c855d013ba8a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1612,8 +1612,7 @@ qla82xx_get_bootld_offset(struct qla_hw_data *ha)
 	return (u8 *)&ha->hablob->fw->data[offset];
 }
 
-static __le32
-qla82xx_get_fw_size(struct qla_hw_data *ha)
+static u32 qla82xx_get_fw_size(struct qla_hw_data *ha)
 {
 	struct qla82xx_uri_data_desc *uri_desc = NULL;
 
@@ -1624,7 +1623,7 @@ qla82xx_get_fw_size(struct qla_hw_data *ha)
 			return cpu_to_le32(uri_desc->size);
 	}
 
-	return cpu_to_le32(*(u32 *)&ha->hablob->fw->data[FW_SIZE_OFFSET]);
+	return get_unaligned_le32(&ha->hablob->fw->data[FW_SIZE_OFFSET]);
 }
 
 static u8 *
@@ -1816,7 +1815,7 @@ qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
 	}
 
 	flashaddr = FLASH_ADDR_START;
-	size = (__force u32)qla82xx_get_fw_size(ha) / 8;
+	size = qla82xx_get_fw_size(ha) / 8;
 	ptr64 = (u64 *)qla82xx_get_fw_offs(ha);
 
 	for (i = 0; i < size; i++) {
