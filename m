Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4756BC54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC12206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgD0DD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:03:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33142 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgD0DD0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 23:03:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id d17so8044199pgo.0
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 20:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sztv8dlrMcI00jM9/LYHY5zF2yIbkxmPS9pV6qJkeKY=;
        b=YB7FHgYBc8xP0wfSFecV2xhH4ZhBsNb6CbkStiCRx+eZbHii9fbPaOSufVa6w4OOyN
         brHF1QnrCZQ1Yj3TfnkZ+ppbRiav+Zt70nxwE7QTVBDJpk+rph9KPtrtwg92vKnMOork
         Km53u528DxympetwbeOohX96CkHL5/Lrbr9xmGSsezUWeaj5mudXtQXWz1GBIcg+rwGd
         jYApmuBf+YJLP3OW6P1G4a2W6qYRDxQOwuVNO2jGhmTCio3OplOFzZp/ykqto4FMfOKt
         XrAm18DtoXT8HpfTC1Qx18UBo5TkSpShHzHsZHxX8Qit6bbc53mKV8oaKNsIx770wJ62
         VnfA==
X-Gm-Message-State: AGi0PubJdbjjypek+FMniZB56hVcrr2yYaZX2jcVZ4l2ulxVlKbkx/7V
        cxBww1/v1nNuYKCoSpIT1OmUjM74j1o=
X-Google-Smtp-Source: APiQypJqkBl7ipAIyKa58aNG4m+Zr27mUwfd6/vSOLRQ83BxwdLbjKSYuxbEbUgkglnC2JA7z3PK/A==
X-Received: by 2002:a63:2e44:: with SMTP id u65mr21233739pgu.142.1587956605475;
        Sun, 26 Apr 2020 20:03:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id v94sm9982617pjb.39.2020.04.26.20.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:03:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v4 06/11] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
Date:   Sun, 26 Apr 2020 20:03:05 -0700
Message-Id: <20200427030310.19687-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427030310.19687-1-bvanassche@acm.org>
References: <20200427030310.19687-1-bvanassche@acm.org>
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

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
index 2dd9c2a39cd5..30c2750c5745 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7877,6 +7877,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct qla82xx_uri_data_desc) != 28);
 	BUILD_BUG_ON(sizeof(struct qla82xx_uri_table_desc) != 32);
 	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
+	BUILD_BUG_ON(sizeof(struct qla_fcp_prio_cfg) != FCP_PRIO_CFG_SIZE);
 	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
 	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
 	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
