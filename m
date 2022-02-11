Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA777C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345891AbiBKWeo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354164AbiBKWei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:38 -0500
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90430D68
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:36 -0800 (PST)
Received: by mail-pf1-f171.google.com with SMTP id 9so15764467pfx.12
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wWx0oD4y/h5fR0o1HnTS+lemIDFT4V4tl6fYkeJP2UA=;
        b=gR6s1xfWliH2WGynEVBzOChK1m6FMr9JMyLWLPoxbKkSSOgtvUpVT+sp6SSIW1eUFc
         dmoehiC9uttdXGKemXu05kH05eistOxsXepQQ8DrSmUcNYy6qWGNmuvJzavEKb86MaSC
         9CGfpTbvOJGtW+86zqnEMbiv8C/Rsp7RAeq9n27Xf599l2hu2N/Yob6v6ibfVWkRwzoR
         csM5qK33zs7gtvqp4z7Dao4jyOFTorbJNAS3buoVdpTDwYQ8dpc1iGws+wnO4T0TLonj
         x+Fv37XAvKaS79B+/mYue+SWqss8Bjvw9XZTGM3wbtWeGUovE0wzw0gvHea18C9rdf4E
         Go3A==
X-Gm-Message-State: AOAM533ykuHpRdE+9apoF1HczVuKMUrdGhkJ7AKDNsTh2HBaUv7Lvpez
        s5QsdClqaqJ9HCDXHjP5/ug=
X-Google-Smtp-Source: ABdhPJwhyBrUUm+SEASY7hEtsS5FCZe8JHYV8of6PurKjGVIYoRva/ufL+LffTxeDK20Z7jLKSvEvw==
X-Received: by 2002:a62:b605:: with SMTP id j5mr3664072pff.25.1644618875943;
        Fri, 11 Feb 2022 14:34:35 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 43/48] scsi: sym53c8xx_2: Move the SCSI pointer to private command data
Date:   Fri, 11 Feb 2022 14:32:42 -0800
Message-Id: <20220211223247.14369-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index b04bfde65e3f..2e2852bd5860 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -118,7 +118,7 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
 	struct completion *eh_done;		/* SCSI error handling */
 };
 
-#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
+#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)scsi_cmd_priv(cmd))
 #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
 
 /*
@@ -127,7 +127,6 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 {
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
 
 	if (ucmd->eh_done)
 		complete(ucmd->eh_done);
@@ -1630,6 +1629,7 @@ static struct scsi_host_template sym2_template = {
 	.module			= THIS_MODULE,
 	.name			= "sym53c8xx",
 	.info			= sym53c8xx_info, 
+	.cmd_size		= sizeof(struct sym_ucmd),
 	.queuecommand		= sym53c8xx_queue_command,
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
