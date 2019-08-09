Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FECC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 649DD216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405226AbfHIDD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43299 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so45225908pfg.10
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mTB55GFfPwjhqHXOekDJn5vjE40NR/qLB1A1NhF6fns=;
        b=A6DBs28WTRl7jxEIxsOGbZRgBH8DuZ9o4XkrNyol3SdOQFDKfXnsYPXoaBqUbQoseh
         Qz9E7+QJ0Se+hQt+CoEcbqZyBOOQdb98Wa5vUg1sfajBpMGmzFS6TlFKkYNcXt+q5Ka+
         JV9cnjLTc157zzQ6DdYxjsESKZZAmLlMCTzgGaoRmkrDpgxu4ubIpf3awUSIyD4lca31
         FG8C8RLwtaxERAAtti9cSjRdUvm3sCawFsGQR+cVeIDdRS5aGLYzT8+eJCW4ZM+g6RAE
         WFXgg5AYIRkbla1Ug7puAnmI+PufcV+gm6xMlNHH2zwXx0+HMaR8nH1sJdjTDQXl7pDV
         wJcQ==
X-Gm-Message-State: APjAAAW0LneztViUmGuSU+bFQ1uP4o3yT7o2WiGkst++iCohr5evTyWk
        9uBJiFqI/AvC+TyhnluecE0=
X-Google-Smtp-Source: APXvYqwjdsB5AWfUcPmGlccVT5QD22tcyrLVI/zaGEUIsktap+VIHTeVhuaOE3kcGgSUwztr6Z3HFg==
X-Received: by 2002:a63:3006:: with SMTP id w6mr15689802pgw.440.1565319804783;
        Thu, 08 Aug 2019 20:03:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 36/58] qla2xxx: Complain if a soft reset fails
Date:   Thu,  8 Aug 2019 20:01:57 -0700
Message-Id: <20190809030219.11296-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Failure of a soft reset is a severe failure. Hence report such failures.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 7ed481dd8ee6..294d77c02cdf 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -429,7 +429,7 @@ qla27xx_fwdt_entry_t266(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_misc, vha, 0xd20a,
 	    "%s: reset risc [%lx]\n", __func__, *len);
 	if (buf)
-		qla24xx_soft_reset(vha->hw);
+		WARN_ON_ONCE(qla24xx_soft_reset(vha->hw) != QLA_SUCCESS);
 
 	return qla27xx_next_entry(ent);
 }
-- 
2.22.0

