Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098D5C47257
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AE82082E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgEGE2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:28:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41996 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEGE2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:28:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id k19so1548099pll.9
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2020 21:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3w/D8TiID7Z7/MNMdCKJbutr+jIPuFJL/W0cltCVDok=;
        b=ryt1CsJplZ3W6pmvodjp2qepH/euGBKYQ/bkzvzg0kW9WOkqPehkTWlNa0NYP+O5R2
         FXL4ItoyCc/isk3FjcKWbwzf/Ao8lkX30/Dc4kCHyHa8P4N2lFN3czayxOkBkLkWlIGE
         5/2xFVGnZISlXZdxOtUaLm4diAfnQhBEGbDAzPTELovR9C04gh8xlIH24pGoJpHOz0eH
         Sm4aFbEhTm12t87IWi4w2H3gftxwQWQrVAOUpD3pDVPsL1XOrAEbIRioQ1KsjqKKHIVn
         YP1xuG4ZsSV71OKuLx1qwbme/1NTXfkv5zis+LF4GJi1p8rRH0KePoZlC2Pdj7B3PUWi
         1vjQ==
X-Gm-Message-State: AGi0PuYvtT3oCb7GBLsQ1tLyx2Qe30n334LGXyzrsrrqW/tvuDy9K7qF
        Ede+XA8+pHUbyjE1wnI1tUE=
X-Google-Smtp-Source: APiQypLZ4wxMF9BuA2fcTOTvgqtjzdY0AikU0ybdk1QLHlBR6wM54R6FAqBj7IBHEi4DEcKJfvd+/Q==
X-Received: by 2002:a17:90a:a591:: with SMTP id b17mr13988506pjq.90.1588825732552;
        Wed, 06 May 2020 21:28:52 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id z28sm3471028pfr.3.2020.05.06.21.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 21:28:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 06/11] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
Date:   Wed,  6 May 2020 21:28:30 -0700
Message-Id: <20200507042835.9135-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507042835.9135-1-bvanassche@acm.org>
References: <20200507042835.9135-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity complaint without changing any
functionality:

CID 337793 (#1 of 1): Wrong size argument (SIZEOF_MISMATCH)
suspicious_sizeof: Passing argument ha->fcp_prio_cfg of type
struct qla_fcp_prio_cfg * and argument 32768UL to function memset is
suspicious because a multiple of sizeof (struct qla_fcp_prio_cfg) /*48*/
is expected.

memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_fw.h | 3 ++-
 drivers/scsi/qla2xxx/qla_os.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index b364a497e33d..4fa34374f34f 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -2217,8 +2217,9 @@ struct qla_fcp_prio_cfg {
 #define FCP_PRIO_ATTR_PERSIST   0x2
 	uint8_t  reserved;      /* Reserved for future use          */
 #define FCP_PRIO_CFG_HDR_SIZE   0x10
-	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
+	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
 #define FCP_PRIO_CFG_ENTRY_SIZE 0x20
+	uint8_t  reserved2[16];
 };
 
 #define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b7b2abc786d4..c6d25dcceb72 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7883,6 +7883,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct qla82xx_uri_data_desc) != 28);
 	BUILD_BUG_ON(sizeof(struct qla82xx_uri_table_desc) != 32);
 	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
+	BUILD_BUG_ON(sizeof(struct qla_fcp_prio_cfg) != FCP_PRIO_CFG_SIZE);
 	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
 	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
 	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
