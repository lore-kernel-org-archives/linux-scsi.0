Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247B7C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC07610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhDOWJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:08 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:40684 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbhDOWJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:07 -0400
Received: by mail-pl1-f170.google.com with SMTP id 20so8924510pll.7
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sA9N5oKKPhmXywujYprCSEsN8faX1miAqRolBWrD9U=;
        b=OuDqKDN9oA62ISNdr7ucUis50CemqDyRbdripeM6lxXkDx72bbrkm9DMDTXrBvIAUi
         /WfichOA7nKAUDRBJt5vog+9O2uDiVPKIYRbElinUVz/kRLayrAY6LmrSgZd7uZSHlGb
         CdDLjCqlq/KYooM0BEZZwecrpgvaTJRiGrV5DxUxZQOteJmvY6ryINtq8FE5/rdBb1Na
         jiZp2IP0bjr5n52U4uVC1lx8E4EKXD5o1iBgQH+Zi+G/OJkirb5B0K5gzADMsk4xd4PB
         Z59KfTj/lrkKqQPhmyT/injFBpwRxabLjSQYAJ3lWLKTpIAGQJwl+L/+sDBfAOypjD+S
         J+yg==
X-Gm-Message-State: AOAM533sDnFqPheaAOGRcVf57di3CSwI8AEREgC66AWSdyVDrGe5JyDF
        iQbHImETr/NkmDeAI7Hiepc=
X-Google-Smtp-Source: ABdhPJzYAVnaqKRHG21rPoJZmF4AukuNymlZn4hbcm0LVhZQEFmbGA9w5gWQLox87DW6TSAMI5w2og==
X-Received: by 2002:a17:90a:dc13:: with SMTP id i19mr6130945pjv.194.1618524524049;
        Thu, 15 Apr 2021 15:08:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 07/20] libfc: Fix a format specifier
Date:   Thu, 15 Apr 2021 15:08:13 -0700
Message-Id: <20210415220826.29438-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the 'mfs' member has been declared as 'u32' in include/scsi/libfc.h,
use the %u format specifier instead of %hu. This patch fixes the following
clang compiler warning:

warning: format specifies type
      'unsigned short' but the argument has type 'u32' (aka 'unsigned int')
      [-Wformat]
                             "lport->mfs:%hu\n", mfs, lport->mfs);
                                         ~~~          ^~~~~~~~~~
                                         %u

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libfc/fc_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 78bd317f0553..cf36c8cb5493 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1731,7 +1731,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	if (mfs < FC_SP_MIN_MAX_PAYLOAD || mfs > FC_SP_MAX_MAX_PAYLOAD) {
 		FC_LPORT_DBG(lport, "FLOGI bad mfs:%hu response, "
-			     "lport->mfs:%hu\n", mfs, lport->mfs);
+			     "lport->mfs:%u\n", mfs, lport->mfs);
 		fc_lport_error(lport, fp);
 		goto out;
 	}
