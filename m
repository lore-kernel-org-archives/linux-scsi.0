Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75DBC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 04:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C25842076C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 04:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgFIEOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 00:14:10 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39292 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgFIEOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 00:14:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id v24so7513671plo.6
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2020 21:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8POUdWeTCCvGFNOOnZkQjiQedlyX/5lCUaTARAIXOuE=;
        b=Mfj07VUALLpWZ3mhShSsrQnEd+/ycAsT4T8hQvp7vNhUQPU9IjvWCa4bYOzeK/bNeO
         UJuGJyzzVLqrDnWocOmWdS3vy8Uo0yYlcJr/wfrjsW14mWNdIzI/ssBpKbsCbrlwSCeH
         ao0FFe61Qg9Bunac4IKGfnaQoIH0wPRZwPV9bR7PRkL73wC5vRtwcrRDVFd+FpZlDxAj
         49K4ZShoHiY+uo57ouqzHXYmAtyYPgF38VaNuwTgjYKYi5RK0euwNrr4SrgeA22au0FJ
         JbDTC90OfrxtvSH+9WxeJ9Hf3hPv5gThUAgtDFwlI/JvYfwrXeX5uUb47PBe39JZLxiU
         mV1A==
X-Gm-Message-State: AOAM531H19OvgVZCbBbgTkegAknyp9w+TnA0/nGJeh4AH/DBXGc8ifH0
        YgbiddZjX27z/RgGmf1SQwI=
X-Google-Smtp-Source: ABdhPJx4KmLTrBrvspBlLzfoY/R/UVKcHcaT9MPs1DWQg2d4ptzxQdG0QzuUzxZCdX5OguQbTWq1HA==
X-Received: by 2002:a17:902:9f90:: with SMTP id g16mr1679406plq.146.1591676048912;
        Mon, 08 Jun 2020 21:14:08 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d15sm8455298pfh.175.2020.06.08.21.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 21:14:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Fix the ARM build
Date:   Mon,  8 Jun 2020 21:14:03 -0700
Message-Id: <20200609041403.20306-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the build errors reported by the kernel test robot on June
7th. Does this perhaps mean that so far nobody has tried to use the qla2xxx
driver on an ARM system? For the kernel test robot output, see also
https://lore.kernel.org/lkml/202006070558.Cy93XggE%25lkp@intel.com/.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 42dbf90d4651..edc9c082dc6e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -46,7 +46,7 @@ typedef struct {
 	uint8_t al_pa;
 	uint8_t area;
 	uint8_t domain;
-} le_id_t;
+} __packed le_id_t;
 
 #include "qla_bsg.h"
 #include "qla_dsd.h"
@@ -1841,8 +1841,8 @@ typedef union {
 	struct {
 		uint8_t reserved;
 		uint8_t standard;
-	} id;
-} target_id_t;
+	} __packed id;
+} __packed target_id_t;
 
 #define SET_TARGET_ID(ha, to, from)			\
 do {							\
