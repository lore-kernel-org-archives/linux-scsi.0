Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02456C433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5B29206D7
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgFNWjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46026 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgFNWje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:34 -0400
Received: by mail-pg1-f193.google.com with SMTP id l63so4531948pge.12
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tUo1LfUJKjx/9q6JjyDQZpOF7RFyfFzDzwqCMO7qVMg=;
        b=J8U/LVtXlrQMMk68NBDAUdrFKjPZEXgeqZARPiKfW4SziJDSTcAgxl4sXTFoitXwuz
         OCgeYK3rSGnL0JmmgZXa0BfFdPU7V/C+Cx0UmukCeQScAF5EYyjsgRJxj8YRUMYZzCrM
         hETjWPBQWoixM0yopaKlY70gk0b42tpg13CBc3QmolvmNp91BmcXtLo264+TKaeAFIsG
         SdeYuHGNMP3Jq15kKW5PY7DrXeYcDlYmEZmMPTs9CAs11S9/JroqAd0jc6ja+cMEIgxA
         VrhOwkX1pbLqp3VbDeYe9Mm9PxusH3gtdqpnEK+7vv8X/rOU15VmnASVsTFyP6twiae6
         QN+Q==
X-Gm-Message-State: AOAM530L+ButuIwf5CyA/oCXbJhyMn7veg2rFKObfz3rtlPF/W5CDRdT
        Jkx0nauWBiEloJYRaMPzGVY=
X-Google-Smtp-Source: ABdhPJwK2BG7PQ0WiUeE/N8+keBaEO15skmHWmKXc7czlcGyJO0x9B/bdib43QM1VJCR8QADFTjaLQ==
X-Received: by 2002:a63:9d8c:: with SMTP id i134mr2504049pgd.9.1592174374068;
        Sun, 14 Jun 2020 15:39:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 4/9] qla2xxx: Initialize 'n' before using it
Date:   Sun, 14 Jun 2020 15:39:16 -0700
Message-Id: <20200614223921.5851-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following code:
	qla82xx_rom_fast_read(ha, 0, &n)
only initializes 'n' if it succeeds. Since 'n' may be reported in a debug
message even if no ROM reads succeeded, initialize 'n' to zero.

This patch fixes the following sparse warning:

qla_nx.c:1218: qla82xx_pinit_from_rom() error: uninitialized symbol 'n'.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index ff365b434a02..71273eb634d3 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1167,6 +1167,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	 * Offset 4: Offset and number of addr/value pairs
 	 * that present in CRB initialize sequence
 	 */
+	n = 0;
 	if (qla82xx_rom_fast_read(ha, 0, &n) != 0 || n != 0xcafecafeUL ||
 	    qla82xx_rom_fast_read(ha, 4, &n) != 0) {
 		ql_log(ql_log_fatal, vha, 0x006e,
