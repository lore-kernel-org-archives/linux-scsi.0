Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAA3C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD48520780
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgF2WzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33819 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgF2WzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id o1so1102855plk.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g9xVjHzCg0wskyJL6JySNkn8fsSLAlFJ7WsgYLGLYKs=;
        b=W5x9NLh9Jjpj6nuV7YwQFKdFAnTGpLhxnkHU0j+hk4tGtbL9X9rqJ02eXivLUarY0u
         MfjRXvcKky6yMRXkqyo6bieM46u5il3NF2rRdkhT18wzR6M2dPCtDYqIu1+NH7kSTpL/
         Mipto1z3BayDQAe463ETB3GmJdUXe5ycoXcmZ3sxh4brPGnvpP2Nkt2aV/1Dybq4ImQp
         vaIScxatXivV387TpdZkYF3WRnTs3kDmaDT82aeKGRJ/28s0Q3pbsIwm5+GHFp6tcdDB
         8NSGFaUE4ecgZDXyNZ2LpOMUoS73TGYtRt+RAnv3w7Q9guNVTWtOuhQoK3LbAZEvSKhr
         eT0A==
X-Gm-Message-State: AOAM532/5suheJzZ/KemqkrcxaGWp1m8Gp7o8TUnBtauBq8I6Agx2MtE
        hYXFe98iElhSVtVdg87588s3BCeOPMY=
X-Google-Smtp-Source: ABdhPJw54926qGuhEC1hmuKcUYyqXl+qVy/SK7uV/TjRhU0KTpRFQUJtvNXKzJxxb6mZ1BrNVnhAEQ==
X-Received: by 2002:a17:902:7b89:: with SMTP id w9mr3658339pll.175.1593471311072;
        Mon, 29 Jun 2020 15:55:11 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Shyam Sundar <ssundar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 4/9] qla2xxx: Initialize 'n' before using it
Date:   Mon, 29 Jun 2020 15:54:49 -0700
Message-Id: <20200629225454.22863-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
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

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
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
