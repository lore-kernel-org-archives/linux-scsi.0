Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAF3C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCDAdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjCDAdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:16 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA08D10257
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:04 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id h8so4511496plf.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGX3sCfP9S9SbUwoJVF9uNLn7ct4AxiUrRAsNV4NPzM=;
        b=a+Q5foZheIp6YAvKEnKSuzqWLSeFAP5O0WfpbaRL5nne72S5WEMujD6f4q2gVV3YPL
         irxvyQBjxCZcNfPTQxsOHtZy/6QPYkizs+GkJf6zZuQ8rg+/V509FZaFVZv1WIW+wQxQ
         oWj82j9LI8HwceQpbEGhxWPisaNHiS/rXW6Kg6sJA2jSMKnujKIRSVN54HsoFdfMAXKC
         UUd3+BUDbqtaofcV0ZA+iCOO0350jilBKcmQYHtP/n6xUJ8vhmm03KxOT/UFR/Mp0gkM
         WaYStzQJjelee/WtySj3BV6TGY0C/nohBNAx72YX4CSgvuo8KcHOYmbRS6dl/kEsICEn
         L2Dw==
X-Gm-Message-State: AO0yUKWhJF9R3yW3LsgbKHXigwohemVna48/ypXDXPMeFenXm2qQBEni
        Smn/AIFr/tY+9nyEqVRVcUc=
X-Google-Smtp-Source: AK7set8CMNUFH/V8n0z18l+FP+6W1yJ9PdGmJO60TqkGHJDxdCPuQIqpoez95hgVDL06yT32H0EQpg==
X-Received: by 2002:a17:903:230d:b0:19a:a546:2959 with SMTP id d13-20020a170903230d00b0019aa5462959mr8356580plh.19.1677889984226;
        Fri, 03 Mar 2023 16:33:04 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 37/81] scsi: qedf: Declare host template const
Date:   Fri,  3 Mar 2023 16:30:19 -0800
Message-Id: <20230304003103.2572793-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 35e16600fc63..e7f2560b9f7d 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -979,7 +979,7 @@ static int qedf_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template qedf_host_template = {
+static const struct scsi_host_template qedf_host_template = {
 	.module 	= THIS_MODULE,
 	.name 		= QEDF_MODULE_NAME,
 	.this_id 	= -1,
