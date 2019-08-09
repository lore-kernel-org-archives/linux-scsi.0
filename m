Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C20C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3FA216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405189AbfHIDDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:17 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:42736 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:17 -0400
Received: by mail-pf1-f169.google.com with SMTP id q10so45206495pff.9
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d3kX1jDZGhnR6tIP+VIsgt7/+Ml8CT2bwEco6BSJ4D0=;
        b=Dh7IbRn5Ziwfm0MDQtwAKfZtpOx3m+/9xchCu1N7y9R86MPrntIW4mkadfQwNiLts/
         eSID+WOcpUSIFcPGERBAuHPuGp3KQtEmARN7DaarB5R/p79f0Cu1hpyAFeWOBtj5cmXh
         v/xYOVt6sD9rLfLJFIYTBDu1jXQuD408kXHHDu3irMjqm7GflV8FtPFzdJOoqihkIOMO
         uclgDcCNhZHXg6KT6ca7lXWmjjUKupL3P1f5C7Bo2fKtrH5/7Xk2YfBf3GkN4K3NoliI
         +hmCkjDxBbAzsSGlv6JKd0EURFVmbu5CjcC/CSSjGcfcW9TByoGc0gejeCX6fqIiWx2r
         7LPw==
X-Gm-Message-State: APjAAAVMEJO8MDEDTTSDTVBqf8dvlpN3Sgw9EP5a4tvk2eKsv8uC/VAl
        ixGjpHmUoBEwLp9z+KFAn10=
X-Google-Smtp-Source: APXvYqwWMCF9aLtVDaRcUzwz/Xi7bKPHFAfSUk8Dp/5xPzel34Eabmr9atxwKYRzphfBtjExpBKTRw==
X-Received: by 2002:a65:62d7:: with SMTP id m23mr15530710pgv.358.1565319796334;
        Thu, 08 Aug 2019 20:03:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 30/58] qla2xxx: Suppress multiple Coverity complaint about out-of-bounds accesses
Date:   Thu,  8 Aug 2019 20:01:51 -0700
Message-Id: <20190809030219.11296-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5ec3c2b96f3f..33e0cf210332 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1555,7 +1555,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Attributes */
 	ct_req->req.rhba.attrs.count =
 	    cpu_to_be32(FDMI_HBA_ATTR_COUNT);
-	entries = ct_req->req.rhba.hba_identifier;
+	entries = &ct_req->req;
 
 	/* Nodename. */
 	eiter = entries + size;
@@ -1764,7 +1764,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 
 	/* Attributes */
 	ct_req->req.rpa.attrs.count = cpu_to_be32(FDMI_PORT_ATTR_COUNT);
-	entries = ct_req->req.rpa.port_name;
+	entries = &ct_req->req;
 
 	/* FC4 types. */
 	eiter = entries + size;
@@ -1977,7 +1977,7 @@ qla2x00_fdmiv2_rhba(scsi_qla_host_t *vha)
 
 	/* Attributes */
 	ct_req->req.rhba2.attrs.count = cpu_to_be32(FDMIV2_HBA_ATTR_COUNT);
-	entries = ct_req->req.rhba2.hba_identifier;
+	entries = &ct_req->req;
 
 	/* Nodename. */
 	eiter = entries + size;
@@ -2336,7 +2336,7 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
 
 	/* Attributes */
 	ct_req->req.rpa2.attrs.count = cpu_to_be32(FDMIV2_PORT_ATTR_COUNT);
-	entries = ct_req->req.rpa2.port_name;
+	entries = &ct_req->req;
 
 	/* FC4 types. */
 	eiter = entries + size;
-- 
2.22.0

