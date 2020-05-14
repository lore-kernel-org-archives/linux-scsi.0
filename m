Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4AEC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC2272065F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgENVgH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 17:36:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45283 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENVgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 17:36:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id u22so46887plq.12
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 14:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2dITsv9JMmCOILvd6qs9FnxxdcpxfpNDUd3BI/+BJ7E=;
        b=tpQTxukGfBT1WYn42yAbxPQ4cGxdKJ8Jd5x2hSrRkoSr/su6/ygt30xNcl99odJ1sP
         g6EqTJoMel1OiJQGz57VzEW8/7I9S4eY/CWGnypbTXs4I+JaZydvWvxQp7SUE9OEo2BR
         JTbCmOAEbjGVAHTikY/3/essD9yifVZFSi7YZ2IwadZ47RJUPdk+z21FlwZRr+rd6x3M
         CHTgwYYLKfLYDjLCe4cHpX0aWs+MnHHMsI9GuOK5nu52wSdlxgUPS9l9+DDGp7c2COCv
         JX/YlmQdSZ6x+jFncr3gcoQHfR7Vlll/LT+/V9ZCdSUMt9pNT6ufYUqIQBFDJBW1auZF
         DJFQ==
X-Gm-Message-State: AOAM5303+t7PuijuqSt37iivPUhVgpW+2NSy+FduATC1Wl4ybeodbttB
        JYki/bVE9czq/0+3GPw8yKk=
X-Google-Smtp-Source: ABdhPJxjftF4qxuiKrH2oP2R7qwLWHcHCwiTommQ+vipjl53DwiorESbIph1UScmk1MXyRacqRCiOg==
X-Received: by 2002:a17:90a:c201:: with SMTP id e1mr12367pjt.162.1589492165425;
        Thu, 14 May 2020 14:36:05 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id a142sm145754pfa.6.2020.05.14.14.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:36:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v6 07/15] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
Date:   Thu, 14 May 2020 14:35:08 -0700
Message-Id: <20200514213516.25461-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213516.25461-1-bvanassche@acm.org>
References: <20200514213516.25461-1-bvanassche@acm.org>
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
index 5199169c4ce0..743c0df18fa0 100644
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
